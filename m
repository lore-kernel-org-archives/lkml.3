Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3LKAqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:46:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:46350 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751224Ab3LKAqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:46:44 -0500
Message-Id: <20131211004643.475776182@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 10 Dec 2013 19:46:34 -0500
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
References: <20131211004631.950208564@goodmis.org>
Content-Disposition: inline; filename=0003-lockdep-Correctly-annotate-hardirq-context-in-irq_ex.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13-rt26-rc1 stable review patch.
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
 kernel/softirq.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 8447c8d..42b121f 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -350,6 +350,44 @@ EXPORT_SYMBOL(local_bh_enable_ip);
  */
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
@@ -369,7 +407,7 @@ asmlinkage void __do_softirq(void)
 
 	__local_bh_disable((unsigned long)__builtin_return_address(0),
 			   SOFTIRQ_OFFSET);
-	lockdep_softirq_enter();
+	lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -385,7 +423,7 @@ restart:
 	if (pending)
 		wakeup_softirqd();
 
-	lockdep_softirq_exit();
+	lockdep_softirq_end();
 
 	vtime_account_irq_exit(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
@@ -692,6 +730,7 @@ static inline void invoke_softirq(void)
 {
 #ifndef CONFIG_PREEMPT_RT_FULL
 	if (!force_irqthreads) {
+		lockdep_softirq_from_hardirq();
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
 #else
@@ -720,7 +759,6 @@ static inline void invoke_softirq(void)
 void irq_exit(void)
 {
 	vtime_account_irq_exit(current);
-	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
@@ -731,6 +769,7 @@ void irq_exit(void)
 		tick_nohz_irq_exit();
 #endif
 	rcu_irq_exit();
+	trace_hardirq_exit(); /* must be last! */
 	sched_preempt_enable_no_resched();
 }
 
-- 
1.8.4.3


