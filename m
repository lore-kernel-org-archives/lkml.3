Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3KSTTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:19:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3KSTTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:19:48 -0500
Date: Tue, 19 Nov 2013 11:19:15 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-dgwc5cdksbn0jk09vbmcc9sa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
        bigeasy@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        fweisbec@gmail.com, akpm@linux-foundation.org, bigeasy@linutronix.de,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] lockdep:
  Correctly annotate hardirq context in irq_exit()
Git-Commit-ID: f1a83e652bedef88d6d77d3dc58250e08e7062bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 19 Nov 2013 11:19:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1a83e652bedef88d6d77d3dc58250e08e7062bd
Gitweb:     http://git.kernel.org/tip/f1a83e652bedef88d6d77d3dc58250e08e7062bd
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 19 Nov 2013 16:42:47 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 19 Nov 2013 17:07:00 +0100

lockdep: Correctly annotate hardirq context in irq_exit()

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

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-dgwc5cdksbn0jk09vbmcc9sa@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/softirq.c | 54 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index b249883..eb0acf4 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -213,14 +213,52 @@ EXPORT_SYMBOL(local_bh_enable_ip);
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
-	struct softirq_action *h;
-	__u32 pending;
 	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
-	int cpu;
 	unsigned long old_flags = current->flags;
 	int max_restart = MAX_SOFTIRQ_RESTART;
+	struct softirq_action *h;
+	__u32 pending;
+	int cpu;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -233,7 +271,7 @@ asmlinkage void __do_softirq(void)
 	account_irq_enter_time(current);
 
 	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
-	lockdep_softirq_enter();
+	lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -280,16 +318,13 @@ restart:
 		wakeup_softirqd();
 	}
 
-	lockdep_softirq_exit();
-
+	lockdep_softirq_end();
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	WARN_ON_ONCE(in_interrupt());
 	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
-
-
 asmlinkage void do_softirq(void)
 {
 	__u32 pending;
@@ -332,6 +367,7 @@ void irq_enter(void)
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads) {
+		lockdep_softirq_from_hardirq();
 #ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
 		 * We can safely execute softirq on the current stack if
@@ -377,13 +413,13 @@ void irq_exit(void)
 #endif
 
 	account_irq_exit_time(current);
-	trace_hardirq_exit();
 	preempt_count_sub(HARDIRQ_OFFSET);
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
 	tick_irq_exit();
 	rcu_irq_exit();
+	trace_hardirq_exit(); /* must be last! */
 }
 
 /*
