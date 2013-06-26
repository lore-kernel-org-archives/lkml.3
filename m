Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3FZTcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:32:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15705 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3FZTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:30:52 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=j-RaGXO5n3AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=hId3TOQRqBMA:10 a=LD6OzeOfAdgjjmm37WYA:9 a=jeBq3FmKZ4MA:10 a=4ZjNkIfz2paf40kD:21 a=_7fK3VGF9F52NO80:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130626193050.368113600@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 26 Jun 2013 15:28:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC][PATCH RT 5/6] rt,ntp: Move call to schedule_delayed_work() to helper thread
References: <20130626192806.107564905@goodmis.org>
Content-Disposition: inline; filename=ntp-sched-delay-thread.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/kernel/time/ntp.c
===================================================================
--- linux-rt.git.orig/kernel/time/ntp.c
+++ linux-rt.git/kernel/time/ntp.c
@@ -10,6 +10,7 @@
 #include <linux/workqueue.h>
 #include <linux/hrtimer.h>
 #include <linux/jiffies.h>
+#include <linux/kthread.h>
 #include <linux/math64.h>
 #include <linux/timex.h>
 #include <linux/time.h>
@@ -516,10 +517,49 @@ static void sync_cmos_clock(struct work_
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
+	do_cmos_delay = true;
+	/* Make visible before waking up process */
+	smp_wmb();
+	wake_up_process(cmos_delay_thread);
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
 	schedule_delayed_work(&sync_cmos_work, 0);
 }
+#endif /* CONFIG_PREEMPT_RT_FULL */
 
 #else
 static inline void notify_cmos_timer(void) { }

