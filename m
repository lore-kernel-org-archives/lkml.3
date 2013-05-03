Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417Ab3ECViw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:38:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592Ab3ECViV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:38:21 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wVjbDTKekSkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1UxL-qhO9PsA:10 a=VwQbUJbxAAAA:8 a=4-pcMlRTT7BXjaTAMckA:9 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=N6c5aT810Tu-8APp:21 a=ltYeNcj6TBwQFle0:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130503213817.938979538@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 03 May 2013 17:37:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 2/5] x86/mce: Defer mce wakeups to threads for PREEMPT_RT
References: <20130503213703.521223574@goodmis.org>
Content-Disposition: inline; filename=0002-x86-mce-Defer-mce-wakeups-to-threads-for-PREEMPT_RT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

We had a customer report a lockup on a 3.0-rt kernel that had the
following backtrace:

[ffff88107fca3e80] rt_spin_lock_slowlock at ffffffff81499113
[ffff88107fca3f40] rt_spin_lock at ffffffff81499a56
[ffff88107fca3f50] __wake_up at ffffffff81043379
[ffff88107fca3f80] mce_notify_irq at ffffffff81017328
[ffff88107fca3f90] intel_threshold_interrupt at ffffffff81019508
[ffff88107fca3fa0] smp_threshold_interrupt at ffffffff81019fc1
[ffff88107fca3fb0] threshold_interrupt at ffffffff814a1853

It actually bugged because the lock was taken by the same owner that
already had that lock. What happened was the thread that was setting
itself on a wait queue had the lock when an MCE triggered. The MCE
interrupt does a wake up on its wait list and grabs the same lock.

NOTE: THIS IS NOT A BUG ON MAINLINE

Sorry for yelling, but as I Cc'd mainline maintainers I want them to
know that this is an PREEMPT_RT bug only. I only Cc'd them for advice.

On PREEMPT_RT the wait queue locks are converted from normal
"spin_locks" into an rt_mutex (see the rt_spin_lock_slowlock above).
These are not to be taken by hard interrupt context. This usually isn't
a problem as most all interrupts in PREEMPT_RT are converted into
schedulable threads. Unfortunately that's not the case with the MCE irq.

As wait queue locks are notorious for long hold times, we can not
convert them to raw_spin_locks without causing issues with -rt. But
Thomas has created a "simple-wait" structure that uses raw spin locks
which may have been a good fit.

Unfortunately, wait queues are not the only issue, as the mce_notify_irq
also does a schedule_work(), which grabs the workqueue spin locks that
have the exact same issue.

Thus, this patch I'm proposing is to move the actual work of the MCE
interrupt into a helper thread that gets woken up on the MCE interrupt
and does the work in a schedulable context.

NOTE: THIS PATCH ONLY CHANGES THE BEHAVIOR WHEN PREEMPT_RT IS SET

Oops, sorry for yelling again, but I want to stress that I keep the same
behavior of mainline when PREEMPT_RT is not set. Thus, this only changes
the MCE behavior when PREEMPT_RT is configured.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bigeasy@linutronix: make mce_notify_work() a proper prototype, use
		     kthread_run()]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   78 +++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e8d8ad0..e31ea90 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -18,6 +18,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kobject.h>
 #include <linux/uaccess.h>
+#include <linux/kthread.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
 #include <linux/percpu.h>
@@ -1308,6 +1309,63 @@ static void mce_do_trigger(struct work_struct *work)
 
 static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
 
+static void __mce_notify_work(void)
+{
+	/* Not more than two messages every minute */
+	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
+
+	/* wake processes polling /dev/mcelog */
+	wake_up_interruptible(&mce_chrdev_wait);
+
+	/*
+	 * There is no risk of missing notifications because
+	 * work_pending is always cleared before the function is
+	 * executed.
+	 */
+	if (mce_helper[0] && !work_pending(&mce_trigger_work))
+		schedule_work(&mce_trigger_work);
+
+	if (__ratelimit(&ratelimit))
+		pr_info(HW_ERR "Machine check events logged\n");
+}
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+struct task_struct *mce_notify_helper;
+
+static int mce_notify_helper_thread(void *unused)
+{
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+		if (kthread_should_stop())
+			break;
+		__mce_notify_work();
+	}
+	return 0;
+}
+
+static int mce_notify_work_init(void)
+{
+	mce_notify_helper = kthread_run(mce_notify_helper_thread, NULL,
+					   "mce-notify");
+	if (!mce_notify_helper)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void mce_notify_work(void)
+{
+	wake_up_process(mce_notify_helper);
+}
+#else
+static void mce_notify_work(void)
+{
+	__mce_notify_work();
+}
+static inline int mce_notify_work_init(void) { return 0; }
+#endif
+
 /*
  * Notify the user(s) about new machine check events.
  * Can be called from interrupt context, but not from machine check/NMI
@@ -1315,24 +1373,8 @@ static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
  */
 int mce_notify_irq(void)
 {
-	/* Not more than two messages every minute */
-	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
-
 	if (test_and_clear_bit(0, &mce_need_notify)) {
-		/* wake processes polling /dev/mcelog */
-		wake_up_interruptible(&mce_chrdev_wait);
-
-		/*
-		 * There is no risk of missing notifications because
-		 * work_pending is always cleared before the function is
-		 * executed.
-		 */
-		if (mce_helper[0] && !work_pending(&mce_trigger_work))
-			schedule_work(&mce_trigger_work);
-
-		if (__ratelimit(&ratelimit))
-			pr_info(HW_ERR "Machine check events logged\n");
-
+		mce_notify_work();
 		return 1;
 	}
 	return 0;
@@ -2375,6 +2417,8 @@ static __init int mcheck_init_device(void)
 	/* register character device /dev/mcelog */
 	misc_register(&mce_chrdev_device);
 
+	err = mce_notify_work_init();
+
 	return err;
 }
 device_initcall_sync(mcheck_init_device);
-- 
1.7.10.4


