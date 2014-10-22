Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaJVJq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:46:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34316 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbaJVJqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:46:25 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-05-54477ceee357
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangjung Woo <sangjung.woo@samsung.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingoo Han <jg1.han@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 RESEND] extcon: Fix sleeping in atomic context after
 connecting USB cable
Date: Wed, 22 Oct 2014 11:46:14 +0200
Message-id: <1413971174-31762-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t/xa7rvatxDDE4/MrPYOGM9q8XB+/UW
	1788Z7VoXryezeLywkusFq9fGFqcbXrDbnF51xw2i7VH7rJb3G5cwWaxYE+JxYKNjxgdeDz2
	z13D7tG3ZRWjx/Eb25k8Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4dvgza8Fh24r5h54wNTBeNu5i
	5OSQEDCRuDD9DxuELSZx4d56IJuLQ0hgKaPE9n/7mEASQgJ9TBLvV8aC2GwCxhKbly8BKxIR
	OMgkcfjUORYQh1lgDVDHz+nsIFXCAnESy270g3WzCKhKLJ77lBHE5hVwl7i0YS4LxDo5iZPH
	JrNOYORewMiwilE0tTS5oDgpPddQrzgxt7g0L10vOT93EyMklL7sYFx8zOoQowAHoxIP7wwO
	9xAh1sSy4srcQ4wSHMxKIrxupUAh3pTEyqrUovz4otKc1OJDjEwcnFINjBkbtp/RFeyaf/TR
	ppbJkdNbQyZ7MNjI13sKeaWYnv6yaoqc6f1JDbMCdzq/4prTb6FxWslP81HK75zYrPZWnx6x
	Y1ef/NeVCZ/+K9Y95i/b5Jlr3S42SYUpxjC8dXMMjN8gXHZYz7/wc0KBitmLToevXm+ulb86
	3pYf+niJbHvGab4ypbsblFiKMxINtZiLihMB1prarAMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sleeping in atomic context happens because:
1. Extcon is notifying with raw notifier chain under spin lock.
2. Notified charger-manager calls sleeping functions.

Actually the problem is not only charger-manager specific because
the extcon is also exporting as API its raw notifier chain with
extcon_register_notifier(). User register its own notifier which may or
may not sleep, and extcon does not know that.

Solve the problem in a generic way: notify on cable change not directly
in extcon_update_state(), but from scheduled work on ordered workqueue.

Details on issue (steps to reproduce):
======================================
Kernel built with extcon and charger-manager. After connecting the USB
cable:
[    6.534930] max77693-muic max77693-muic: external connector is attached(chg_type:0x1, prev_chg_type:0x1)
[    6.544043] max77693-muic max77693-muic: CONTROL1 : 0x09, CONTROL2 : 0x04, state : attached
[    6.551539] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:615
[    6.559691] in_atomic(): 1, irqs_disabled(): 128, pid: 1248, name: kworker/2:1
[    6.566892] 4 locks held by kworker/2:1/1248:
[    6.571229]  #0:  ("events"){.+.+.+}, at: [<c0039648>] process_one_work+0x114/0x3f4
[    6.578867]  #1:  ((&info->irq_work)){+.+...}, at: [<c0039648>] process_one_work+0x114/0x3f4
[    6.587287]  #2:  (&info->mutex){+.+...}, at: [<c038e56c>] max77693_muic_irq_work+0x28/0x120
[    6.595706]  #3:  (&(&edev->lock)->rlock){......}, at: [<c038c3b8>] extcon_update_state+0x20/0x204
[    6.604648] irq event stamp: 3944
[    6.607945] hardirqs last  enabled at (3943): [<c0068fb4>] vprintk_emit+0x1dc/0x5c0
[    6.615584] hardirqs last disabled at (3944): [<c048b5ac>] _raw_spin_lock_irqsave+0x1c/0x5c
[    6.623917] softirqs last  enabled at (0): [<c0020c7c>] copy_process.part.54+0x3f4/0x1520
[    6.632076] softirqs last disabled at (0): [<  (null)>]   (null)
[    6.638065] Preemption disabled at:[<  (null)>]   (null)
[    6.643359]
[    6.644843] CPU: 2 PID: 1248 Comm: kworker/2:1 Not tainted 3.17.0-next-20141007-00047-g1b95596dfa88 #302
[    6.654307] Workqueue: events max77693_muic_irq_work
[    6.659277] [<c0014d2c>] (unwind_backtrace) from [<c0011c98>] (show_stack+0x10/0x14)
[    6.666986] [<c0011c98>] (show_stack) from [<c0484d18>] (dump_stack+0x70/0xbc)
[    6.674186] [<c0484d18>] (dump_stack) from [<c0487b38>] (mutex_lock_nested+0x24/0x458)
[    6.682087] [<c0487b38>] (mutex_lock_nested) from [<c028ef6c>] (regmap_read+0x30/0x60)
[    6.689990] [<c028ef6c>] (regmap_read) from [<c033d830>] (max77693_charger_get_property+0x20c/0x244)
[    6.699113] [<c033d830>] (max77693_charger_get_property) from [<c03365f8>] (power_supply_get_property+0x20/0x2c)
[    6.709255] [<c03365f8>] (power_supply_get_property) from [<c033a0a4>] (is_ext_pwr_online+0x30/0xb8)
[    6.718364] [<c033a0a4>] (is_ext_pwr_online) from [<c033b6ac>] (charger_extcon_notifier+0x40/0x70)
[    6.727306] [<c033b6ac>] (charger_extcon_notifier) from [<c038bf4c>] (_call_per_cable+0x40/0x4c)
[    6.736080] [<c038bf4c>] (_call_per_cable) from [<c00402b4>] (notifier_call_chain+0x64/0xd4)
[    6.744492] [<c00402b4>] (notifier_call_chain) from [<c0040340>] (raw_notifier_call_chain+0x18/0x20)
[    6.753607] [<c0040340>] (raw_notifier_call_chain) from [<c038c440>] (extcon_update_state+0xa8/0x204)
[    6.762807] [<c038c440>] (extcon_update_state) from [<c038de44>] (max77693_muic_chg_handler+0x1f4/0x25c)
[    6.772267] [<c038de44>] (max77693_muic_chg_handler) from [<c038e650>] (max77693_muic_irq_work+0x10c/0x120)
[    6.781992] [<c038e650>] (max77693_muic_irq_work) from [<c00396b4>] (process_one_work+0x180/0x3f4)
[    6.790930] [<c00396b4>] (process_one_work) from [<c003998c>] (worker_thread+0x30/0x458)
[    6.799000] [<c003998c>] (worker_thread) from [<c003f374>] (kthread+0xd8/0xf4)
[    6.806209] [<c003f374>] (kthread) from [<c000f268>] (ret_from_fork+0x14/0x2c)

The first sleeping function is is_ext_pwr_online()
(drivers/power/charger-manager.c). The atomic context initiating the
flow is set up in extcon_update_state() (drivers/extcon/extcon-class.c).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 0ea625037826 ("Extcon: renamed files to comply with the standard naming.")

---

Changes since v1:
1. Re-work after discussions MyungJoo Ham. Don't change spin locks into
   mutexes but completely move raw_notifier_call_chain out of atomic
   context.
2. Mark cc-stable.
---
 drivers/extcon/extcon-class.c | 47 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/extcon.h        |  1 +
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 4c2f2c543bb7..730e41cad935 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -34,6 +34,16 @@
 #include <linux/of.h>
 
 /*
+ * Not part of API.
+ * Work item for notifying on update state.
+ */
+struct notifier_work {
+	struct extcon_dev *edev;
+	u32 old_state;
+	struct work_struct work;
+};
+
+/*
  * extcon_cable_name suggests the standard cable names for commonly used
  * cable types.
  *
@@ -187,6 +197,32 @@ static ssize_t cable_state_show(struct device *dev,
 					       cable->cable_index));
 }
 
+static void update_state_notifier_worker(struct work_struct *_work)
+{
+	struct notifier_work *work = container_of(_work, struct notifier_work,
+			work);
+
+	raw_notifier_call_chain(&work->edev->nh, work->old_state, work->edev);
+	kfree(work);
+}
+
+static int queue_update_state_notifier(struct extcon_dev *edev, u32 old_state)
+{
+	struct notifier_work *work;
+
+	work = kzalloc(sizeof(*work), GFP_NOWAIT);
+	if (!work)
+		return -ENOMEM;
+
+	work->edev = edev;
+	work->old_state = old_state;
+	INIT_WORK(&work->work, update_state_notifier_worker);
+
+	queue_work(edev->noti_workqueue, &work->work);
+
+	return 0;
+}
+
 /**
  * extcon_update_state() - Update the cable attach states of the extcon device
  *			   only for the masked bits.
@@ -216,6 +252,7 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 
 	if (edev->state != ((edev->state & ~mask) | (state & mask))) {
 		u32 old_state = edev->state;
+		int ret;
 
 		if (check_mutually_exclusive(edev, (edev->state & ~mask) |
 						   (state & mask))) {
@@ -226,7 +263,12 @@ int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state)
 		edev->state &= ~mask;
 		edev->state |= state & mask;
 
-		raw_notifier_call_chain(&edev->nh, old_state, edev);
+		ret = queue_update_state_notifier(edev, old_state);
+		if (ret) {
+			spin_unlock_irqrestore(&edev->lock, flags);
+			return ret;
+		}
+
 		/* This could be in interrupt handler */
 		prop_buf = (char *)get_zeroed_page(GFP_ATOMIC);
 		if (prop_buf) {
@@ -588,6 +630,8 @@ struct extcon_dev *extcon_dev_allocate(const char **supported_cable)
 	edev->max_supported = 0;
 	edev->supported_cable = supported_cable;
 
+	edev->noti_workqueue = create_singlethread_workqueue("extcon");
+
 	return edev;
 }
 
@@ -597,6 +641,7 @@ struct extcon_dev *extcon_dev_allocate(const char **supported_cable)
  */
 void extcon_dev_free(struct extcon_dev *edev)
 {
+	destroy_workqueue(edev->noti_workqueue);
 	kfree(edev);
 }
 EXPORT_SYMBOL_GPL(extcon_dev_free);
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 36f49c405dfb..327bf5d85920 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -123,6 +123,7 @@ struct extcon_dev {
 	/* Internal data. Please do not set. */
 	struct device dev;
 	struct raw_notifier_head nh;
+	struct workqueue_struct *noti_workqueue;
 	struct list_head entry;
 	int max_supported;
 	spinlock_t lock;	/* could be called by irq handler */
-- 
1.9.1

