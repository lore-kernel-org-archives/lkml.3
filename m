Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3BVBgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:36:41 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:56622 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab3BVBgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:36:24 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 2/2] irq: Cleanup context state transitions in irq_exit()
Date: Fri, 22 Feb 2013 02:36:11 +0100
Message-Id: <1361496971-16939-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq code is run under HARDIRQ_OFFSET preempt offset until
we reach the softirq code. Then it's substracted, leaving the
preempt count to 0, whether we have pending softirqs or not.

Afterward, if we have softirqs to run, we'll run them under
the SOFTIRQ_OFFSET then set the preempt offset back to 0
after softirqs completion.

The rest of the code in irq_exit(), mainly tick_nohz_irq_exit()
and rcu_irq_exit(), are executed with this NULL preempt offset.

The semantics here are not very intuitive. They leave several portions
of the code into some half-defined context state, where in_interrupt()
returns false while we actually are in an interrupt.

In order to make the context definition less confusing, let's
cover the whole code in irq_exit() under HARDIRQ_OFFSET, except
for the softirq processing where we switch back and forth
from HARDIRQ_OFFSET to SOFTIRQ_OFFSET without leaving a gap
in the context definition.

There is a drawback though: raise_softirq() relies on the previous
semantics considering that as long as we are in_interrupt(), the
pending softirq will be handled in the end of the interrupt. Otherwise
it kicks ksoftirqd so the softirq is always processed.

Now tick_nohz_irq_exit() and rcu_irq_exit() can raise softirqs
themselves. Since these functions were not under the HARDIRQ_OFFSET,
calling raise_softirq() resulted in waking up the ksoftirqd thread.
This is correct because invoke_softirq() has already been invoked at
this stage. But with this patch they are now under HARDIRQ_OFFSET and
raise_softirq() wrongly thinks invoke_softirq() has yet to be called.
In the end, this could leave the softirq unprocessed for a while.

So as Thomas suggested me, this also brings a check in the end of
irq_exit() that looks for pending softirqs raised after invoke_softirq()
and wake up ksoftirqd if needed.

Given that the cleanup on the contexts transition involves that
new unpretty workaround, I have mixed feelings about this patch so I
tagged it as "RFC" and I wait for your opinion.

This is mostly based on a patch written by Linus Torvalds.

Original-patch-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/hardirq.h |    1 +
 kernel/softirq.c        |   52 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index c1d6555..62e084d 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -87,6 +87,7 @@
 #define in_irq()		(hardirq_count())
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
+#define in_nesting_interrupt()  (irq_count() - HARDIRQ_OFFSET)
 #define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
 
 /*
diff --git a/kernel/softirq.c b/kernel/softirq.c
index f42ff97..3ecaee9 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -320,12 +320,34 @@ void irq_enter(void)
 	__irq_enter();
 }
 
+/* Invoke softirq's from irq_exit(). */
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads)
-		__do_softirq();
-	else
+	/* Can we run softirq's at all? We might be nesting interrupts */
+	if (in_nesting_interrupt())
+		return;
+
+	/* Are there any pending? */
+	if (!local_softirq_pending())
+		return;
+
+	if (force_irqthreads) {
 		wakeup_softirqd();
+		return;
+	}
+
+	/*
+	 * Ok, do actual softirq handling!
+	 *
+	 * This downgrades us from hardirq context to softirq context.
+	 */
+	preempt_count() += SOFTIRQ_OFFSET - HARDIRQ_OFFSET;
+	trace_softirqs_off((unsigned long)__builtin_return_address(0));
+
+	__do_softirq();
+
+	preempt_count() += HARDIRQ_OFFSET - SOFTIRQ_OFFSET;
+	trace_softirqs_on((unsigned long)__builtin_return_address(0));
 }
 
 /*
@@ -343,16 +365,30 @@ void irq_exit(void)
 
 	account_irq_exit_time(current);
 	trace_hardirq_exit();
-	sub_preempt_count(HARDIRQ_OFFSET);
-	if (!in_interrupt() && local_softirq_pending())
-		invoke_softirq();
+	invoke_softirq();
 
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
-		tick_nohz_irq_exit();
+	if (idle_cpu(smp_processor_id())) {
+		if (!in_nesting_interrupt() && !need_resched())
+			tick_nohz_irq_exit();
+	}
 #endif
 	rcu_irq_exit();
+	sub_preempt_count(HARDIRQ_OFFSET);
+
+	/*
+	 * Softirqs have been processed already from invoke_softirq().
+	 * However tick_nohz_irq_exit() may raise timer or hrtimer
+	 * softirqs and rcu_irq_exit() may raise the RCU softirq.
+	 * But raise_softirq() won't wakeup ksoftirqd from these callsites:
+	 * it sees we are in_interrupt() so it makes the wrong assumption
+	 * that softirqs can still be processed through invoke_softirq().
+	 * But we already called it. So we need to do the last check here.
+	 */
+	if (local_softirq_pending() && !in_nesting_interrupt())
+		wakeup_softirqd();
+
 #ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
 	local_irq_restore(flags);
 #endif
-- 
1.7.5.4

