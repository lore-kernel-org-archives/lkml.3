Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab3K0OIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:08:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3K0OIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:08:24 -0500
Date: Wed, 27 Nov 2013 06:07:43 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-5c4853b60ca8ec3d989ce05a5e995d15c3ed52c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, tglx@linutronix.de, bigeasy@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, bigeasy@linutronix.de, tglx@linutronix.de
In-Reply-To: <1384906054-30676-1-git-send-email-fweisbec@gmail.com>
References: <1384906054-30676-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Simplify a bit hardirq <->
  softirq transitions
Git-Commit-ID: 5c4853b60ca8ec3d989ce05a5e995d15c3ed52c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:07:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c4853b60ca8ec3d989ce05a5e995d15c3ed52c0
Gitweb:     http://git.kernel.org/tip/5c4853b60ca8ec3d989ce05a5e995d15c3ed52c0
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 20 Nov 2013 01:07:34 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:09:40 +0100

lockdep: Simplify a bit hardirq <-> softirq transitions

Instead of saving the hardirq state on a per CPU variable, which require
an explicit call before the softirq handling and some complication,
just save and restore the hardirq tracing state through functions
return values and parameters.

It simplifies a bit the black magic that works around the fact that
softirqs can be called from hardirqs while hardirqs can nest on softirqs
but those two cases have very different semantics and only the latter
case assume both states.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1384906054-30676-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/softirq.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index f84aa48..9a4500e 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -213,40 +213,35 @@ EXPORT_SYMBOL(local_bh_enable_ip);
 
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
@@ -255,6 +250,7 @@ asmlinkage void __do_softirq(void)
 	unsigned long old_flags = current->flags;
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	struct softirq_action *h;
+	bool in_hardirq;
 	__u32 pending;
 	int cpu;
 
@@ -269,7 +265,7 @@ asmlinkage void __do_softirq(void)
 	account_irq_enter_time(current);
 
 	__local_bh_disable(_RET_IP_, SOFTIRQ_OFFSET);
-	lockdep_softirq_start();
+	in_hardirq = lockdep_softirq_start();
 
 	cpu = smp_processor_id();
 restart:
@@ -316,7 +312,7 @@ restart:
 		wakeup_softirqd();
 	}
 
-	lockdep_softirq_end();
+	lockdep_softirq_end(in_hardirq);
 	account_irq_exit_time(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
 	WARN_ON_ONCE(in_interrupt());
@@ -365,7 +361,6 @@ void irq_enter(void)
 static inline void invoke_softirq(void)
 {
 	if (!force_irqthreads) {
-		lockdep_softirq_from_hardirq();
 #ifdef CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK
 		/*
 		 * We can safely execute softirq on the current stack if
