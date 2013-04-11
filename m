Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3DKSdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:33:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7370 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3DKSdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:33:36 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=RKbimCT2a08A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=j5D2oEQ9Kg0A:10 a=4-pcMlRTT7BXjaTAMckA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=kyoCiWENxn4702s2:21 a=eae_7G5JjKgrkUgW:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365705214.9609.58.camel@gandalf.local.home>
Subject: [PATCH RT v2] x86/mce: Defer mce wakeups to threads for PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 11 Apr 2013 14:33:34 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This time without the hitchhiking process_32.c cruff on the patch ]

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

Comments?

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index e8d8ad0..060e473 100644
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
@@ -1308,6 +1309,61 @@ static void mce_do_trigger(struct work_struct *work)
 
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
+	while (!kthread_should_stop()) {
+		__mce_notify_work();
+		set_current_state(TASK_INTERRUPTIBLE);
+		schedule();
+	}
+	return 0;
+}
+
+static int mce_notify_work_init(void)
+{
+	mce_notify_helper = kthread_create(mce_notify_helper_thread, NULL,
+					   "mce-notify");
+	if (!mce_notify_helper)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void mce_notify_work()
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
@@ -1315,24 +1371,8 @@ static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
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
@@ -2375,6 +2415,8 @@ static __init int mcheck_init_device(void)
 	/* register character device /dev/mcelog */
 	misc_register(&mce_chrdev_device);
 
+	err = mce_notify_work_init();
+
 	return err;
 }
 device_initcall_sync(mcheck_init_device);


