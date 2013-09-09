Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3IIP2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:28:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28335 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3IIP0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:26:47 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0R1hYCFCeCQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0Irq6MuVi30A:10 a=VwQbUJbxAAAA:8 a=BzcpA60qLsQmd2d8w4QA:9 a=jeBq3FmKZ4MA:10 a=oSyOWUg5ok3-PGW_:21 a=3QSgYePpgmxBa_t1:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909143535.749287955@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 10:35:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 10/16] rt,ntp: Move call to schedule_delayed_work() to helper thread
References: <20130909143517.641735717@goodmis.org>
Content-Disposition: inline; filename=0010-rt-ntp-Move-call-to-schedule_delayed_work-to-helper-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

The ntp code for notify_cmos_timer() is called from a hard interrupt
context. schedule_delayed_work() under PREEMPT_RT_FULL calls spinlocks
that have been converted to mutexes, thus calling schedule_delayed_work()
from interrupt is not safe.

Add a helper thread that does the call to schedule_delayed_work and wake
up that thread instead of calling schedule_delayed_work() directly.
This is only for CONFIG_PREEMPT_RT_FULL, otherwise the code still calls
schedule_delayed_work() directly in irq context.

Note: There's a few places in the kernel that do this. Perhaps the RT
code should have a dedicated thread that does the checks. Just register
a notifier on boot up for your check and wake up the thread when
needed. This will be a todo.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/ntp.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8b3a185..fa0c206 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -10,6 +10,7 @@
 #include <linux/workqueue.h>
 #include <linux/hrtimer.h>
 #include <linux/jiffies.h>
+#include <linux/kthread.h>
 #include <linux/math64.h>
 #include <linux/timex.h>
 #include <linux/time.h>
@@ -494,11 +495,52 @@ static void sync_cmos_clock(struct work_struct *work)
 	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * RT can not call schedule_delayed_work from real interrupt context.
+ * Need to make a thread to do the real work.
+ */
+static struct task_struct *cmos_delay_thread;
+static bool do_cmos_delay;
+
+static int run_cmos_delay(void *ignore)
+{
+	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (do_cmos_delay) {
+			do_cmos_delay = false;
+			schedule_delayed_work(&sync_cmos_work, 0);
+		}
+		schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+static void notify_cmos_timer(void)
+{
+	if (!no_sync_cmos_clock) {
+		do_cmos_delay = true;
+		/* Make visible before waking up process */
+		smp_wmb();
+		wake_up_process(cmos_delay_thread);
+	}
+}
+
+static __init int create_cmos_delay_thread(void)
+{
+	cmos_delay_thread = kthread_run(run_cmos_delay, NULL, "kcmosdelayd");
+	BUG_ON(!cmos_delay_thread);
+	return 0;
+}
+early_initcall(create_cmos_delay_thread);
+#else
 static void notify_cmos_timer(void)
 {
 	if (!no_sync_cmos_clock)
 		schedule_delayed_work(&sync_cmos_work, 0);
 }
+#endif /* CONFIG_PREEMPT_RT_FULL */
 
 #else
 static inline void notify_cmos_timer(void) { }
-- 
1.7.10.4


