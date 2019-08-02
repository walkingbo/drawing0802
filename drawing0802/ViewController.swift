
import UIKit

class ViewController: UIViewController {
    
    var blueBoxView : UIView?
    var redBoxView : UIView?

    var animator : UIDynamicAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let view1 = MyView()
        view1.frame = UIScreen.main.bounds
        //self.view.addSubview(view1)
        self.view = view1
        */
        
        blueBoxView = UIView(frame: CGRect(x: 100, y: 60, width: 80, height: 80))
        blueBoxView?.backgroundColor = UIColor.blue
        self.view.addSubview(blueBoxView!)
        redBoxView = UIView(frame: CGRect(x: 250, y: 60, width: 80, height: 80))
        redBoxView?.backgroundColor = UIColor.red
         self.view.addSubview(redBoxView!)
    
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        //중력 애니메이션 적용
        let gravity = UIGravityBehavior(items: [blueBoxView!,redBoxView!])
        //옵 션 설 정
        let vector = CGVector(dx: 0, dy: 1)
        gravity.gravityDirection = vector
        animator?.addBehavior(gravity)
        //충돌 적용
        let collision = UICollisionBehavior(items: [blueBoxView!,redBoxView!])
        //부모 뷰와 충돌을 시켜서 멈추기
        collision.translatesReferenceBoundsIntoBoundary = true
        animator!.addBehavior(collision)
        
        //탄성 적용
        let behavior = UIDynamicItemBehavior(items: [blueBoxView!])
        behavior.elasticity = 0.89
        animator?.addBehavior(behavior)
        
        //push는 미는 애니메이션
        let push = UIPushBehavior(items: [redBoxView!,blueBoxView!], mode: .continuous)
        push.pushDirection = CGVector(dx: 1, dy: 0)
        animator.addBehavior(push)
        
        
        let boxAttachment = UIAttachmentBehavior(item: blueBoxView!,attachedTo:redBoxView!)
        boxAttachment.frequency = 4.0
        boxAttachment.damping = 0
        animator.addBehavior(boxAttachment)
        
        
    }
    
    //현재 위치를 저장할 변수
    var currentLocation : CGPoint!
    //AttachmentBehavior 변수 : 뷰를 부착시키는 애니메이션
    var attachment: UIAttachmentBehavior!
    //터치가 발생했을 때 호출되는 메소드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first, let blueBox = blueBoxView{
            currentLocation = theTouch.location(in: self.view) as CGPoint
            
            if let location = currentLocation{
                //좌표에서 떨어뜨릴 값 생성
                let offset = UIOffset(horizontal: 20, vertical: 20)
                attachment = UIAttachmentBehavior(item: blueBox, offsetFromCenter: offset, attachedToAnchor: location)
            }
            if let attach = attachment{
                animator!.addBehavior(attach)
            }
            
        }
    }
    //터치가 이동할 때 호출되는 메소드
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let theTouch = touches.first{
            currentLocation = theTouch.location(in: self.view)
            if let location = currentLocation{
                attachment!.anchorPoint = location
            }
        }
    }
    //터치가 종료되면 호출되는 메소드
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let attach = attachment{
            animator!.removeBehavior(attach)
        }
    }
    
    

}


class MyView: UIView {
    override func draw(_ rect: CGRect) {
        //화면에 뷰가 보열 질때 마다 호출되는 메소드
        //이 메소드 실제로 뷰를 그려주는 메소드
        
        let str = "텍스트를 그려서 출력하기"
        let attrs = [NSAttributedString.Key.foregroundColor:UIColor.red,
                     NSAttributedString.Key.font:UIFont.systemFont(ofSize: 30)]
        (str as NSString).draw(at: CGPoint(x: 30, y: 200), withAttributes: attrs)
}

}
