Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3LKAjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:39:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64867 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751429Ab3LKAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:38:05 -0500
Message-Id: <20131211003801.986511386@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 10 Dec 2013 19:37:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH RT 3/5] lockdep: Correctly annotate hardirq context in irq_exit()
References: <20131211003732.351606520@goodmis.org>
Content-Disposition: inline; filename=0003-lockdep-Correctly-annotate-hardirq-context-in-irq_ex.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.22-rt20-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

There was a reported deadlock on -rt which lockdep didn't report.

It turns out that in irq_exit() we tell lockdep that the hardirq
context ends and then do all kinds of locking afterwards.

To fix it, move trace_hardirq_exit() to the very end of irq_exit(), this
ensures all locking in tick_irq_exit() and rcu_irq_exit() are properly
recorded as happening from hardirq context.

This however leads to the 'fun' little problem of running softirqs
while in hardirq context. To cure this make the softirq code a little
more complex (in the CONFIG_TRACE_IRQFLAGS case).

Due to stack swizzling arch dependent trickery we cannot pass an
argument to __do_softirq() to tell it if it was done from hardirq
context or not; so use a side-band argument.

When we do __do_softirq() from hardirq context, 'atomically' flip to
softirq context and back, so that no locking goes without being in
either hard- or soft-irq context.

I didn't find any new problems in mainline using this patch, but it
did show the -rt problem.

Cc: stable-rt@vger.kernel.org
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-dgwc5cdksbn0jk09vbmcc9sa@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/softirq.c | 46 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4cacbcd..541adf3 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -355,6 +355,44 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
 #define MAX_SOFTIRQ_RESTART 10
 
+#ifdef CONFIG_TRACE_IRQFLAGS
+/*
+ * Convoluted means of passing __do_softirq() a message through the various
+ * architecture execute_on_stack() bits.
+ *
+ * When we run softirqs from irq_exit() and thus on the hardirq stack we need
+ * to keep the lockdep irq context tracking as tight as possible in order to
+ * not miss-qualify lock contexts and miss possible deadlocks.
+ */
+static DEFINE_PER_CPU(int, softirq_from_hardirq);
+
+static inline void lockdep_softirq_from_hardirq(void)
+{
+	this_cpu_write(softirq_from_hardirq, 1);
+}
+
+static inline void lockdep_softirq_start(void)
+{
+	if (this_cpu_read(softirq_from_hardirq))
+		trace_hardirq_exit();
+	lockdep_softirq_enter();
+}
+
+static inline void lockdep_softirq_end(void)
+{
+	lockdep_softirq_exit();
+	if (this_cpu_read(softirq_from_hardirq)) {
+		this_cpu_write(softirq_from_hardirq, 0);
+		trace_hardirq_enter();
+	}
+}
+
+#else
+static inline void lockdep_softirq_from_hardirq(void) { }
+static inline void lockdep_softirq_start(void) { }
+static inline void lockdep_softirq_end(void) { }
+#endif
+
 asmlinkage void __do_softirq(void)
 {
 	__u32 pending;
@@ -375,7 +413,7 @@ asmlinkage void __do_softirq(void)
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 			   SOFTIRQ_OFFSET);
-	lockdep_softirq_enter();
+	lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -393,8 +431,7 @@ restart:
 		wakeup_softirqd();
 	}
 
-	lockdep_softirq_exit();
-
+	lockdep_softirq_end();
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
@@ -700,6 +737,7 @@ static inline void invoke_softirq(void)
 {
 #ifndef CONFIG_PREEMPT_RT_FULL
 	if (!force_irqthreads) {
+		lockdep_softirq_from_hardirq();
 		/*
 		 * We can safely execute softirq on the current stack if
 		 * it is the irq stack, because it should be near empty
@@ -749,13 +787,13 @@ void irq_exit(void)
 #endif
 
 	account_irq_exit_time(current);
-	trace_hardirq_exit();
 	sub_preempt_count(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
 	tick_irq_exit();
 	rcu_irq_exit();
+	trace_hardirq_exit(); /* must be last! */
 }
 
 void raise_softirq(unsigned int nr)
-- 
1.8.4.3


