Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3KTAIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:08:04 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41721 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3KTAIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:08:00 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lockdep: Simplify a bit hardirq <-> softirq transitions
Date: Wed, 20 Nov 2013 01:07:34 +0100
Message-Id: <1384906054-30676-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of saving the hardirq state on a per CPU variable, which require
an explicit call before the softirq handling and some complication,
just save and restore the hardirq tracing state through functions
return values and parameters.

It simplifies a bit the black magic that works around the fact that
softirqs can be called from hardirqs while hardirqs can nest on softirqs
but those two cases have very different semantics and only the latter
case assume both states.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/softirq.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index eb0acf4..dc43ee8 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -215,40 +215,35 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 
 #ifdef CONFIG_TRACE_IRQFLAGS
 /*
- * Convoluted means of passing __do_softirq() a message through the various
- * architecture execute_on_stack() bits.
- *
  * When we run softirqs from irq_exit() and thus on the hardirq stack we need
  * to keep the lockdep irq context tracking as tight as possible in order to
  * not miss-qualify lock contexts and miss possible deadlocks.
  */
-static DEFINE_PER_CPU(int, softirq_from_hardirq);
 
-static inline void lockdep_softirq_from_hardirq(void)
+static inline bool lockdep_softirq_start(void)
 {
-	this_cpu_write(softirq_from_hardirq, 1);
-}
+	bool in_hardirq = false;
 
-static inline void lockdep_softirq_start(void)
-{
-	if (this_cpu_read(softirq_from_hardirq))
+	if (trace_hardirq_context(current)) {
+		in_hardirq = true;
 		trace_hardirq_exit();
+	}
+
 	lockdep_softirq_enter();
+
+	return in_hardirq;
 }
 
-static inline void lockdep_softirq_end(void)
+static inline void lockdep_softirq_end(bool in_hardirq)
 {
 	lockdep_softirq_exit();
-	if (this_cpu_read(softirq_from_hardirq)) {
-		this_cpu_write(softirq_from_hardirq, 0);
+
+	if (in_hardirq)
 		trace_hardirq_enter();
-	}
 }
-
 #else
-static inline void lockdep_softirq_from_hardirq(void) { }
-static inline void lockdep_softirq_start(void) { }
-static inline void lockdep_softirq_end(void) { }
+static inline bool lockdep_softirq_start(void) { return false; }
+static inline void lockdep_softirq_end(bool in_hardirq) { }
 #endif
 
 asmlinkage void __do_softirq(void)
@@ -257,6 +252,7 @@ asmlinkage void __do_softirq(void)
 	unsigned long old_flags = current->flags;
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	struct softirq_action *h;
+	bool in_hardirq;
 	__u32 pending;
 	int cpu;
 
@@ -271,7 +267,7 @@ asmlinkage void __do_softirq(void)
 	account_irq_enter_time(current);
 
 	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
-	lockdep_softirq_start();
+	in_hardirq = lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -318,7 +314,7 @@ restart:
 		wakeup_softirqd();
 	}
 
-	lockdep_softirq_end();
+	lockdep_softirq_end(in_hardirq);
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	WARN_ON_ONCE(in_interrupt());
@@ -367,7 +363,6 @@ void irq_enter(void)
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads) {
-		lockdep_softirq_from_hardirq();
 #ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
 		 * We can safely execute softirq on the current stack if
-- 
1.8.3.1

