Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaHUOxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:53:50 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52392 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaHUOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:42 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 9/9] nohz: nohz full depends on irq work self IPI support
Date: Thu, 21 Aug 2014 16:52:57 +0200
Message-Id: <1408632777-3348-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nohz full functionality depends on IRQ work to trigger its own
interrupts. As it's used to restart the tick, we can't rely on the tick
fallback for irq work callbacks, ie: we can't use the tick to restart
the tick itself as it may well be completely stopped.

Lets reject the full dynticks initialization if that arch support isn't
available.

As a side effect, this makes sure that nohz kick is never called from
the tick. Some lockup have been reported due to the kick trying to cancel
the tick hrtimer from the tick itself, which of course doesn't work.

Cc: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq_work.h |  1 +
 kernel/time/tick-sched.c | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 708c895..cffdf47 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -33,6 +33,7 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 #define DEFINE_IRQ_WORK(name, _f) struct irq_work name = { .func = (_f), }
 
 bool irq_work_queue(struct irq_work *work);
+int arch_irq_work_has_own_interrupt(void);
 
 #ifdef CONFIG_SMP
 bool irq_work_queue_on(struct irq_work *work, int cpu);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index eb4af01..767a081 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -365,6 +365,20 @@ void __init tick_nohz_init(void)
 		return;
 	}
 
+	/*
+	 * Full dynticks uses irq work to drive the tick rescheduling on safe
+	 * locking contexts. But then we need irq work to raise its own
+	 * interrupts to avoid circular dependency on the tick
+	 */
+	if (!arch_irq_work_has_own_interrupt()) {
+		pr_warning("NO_HZ: Can't run full dynticks because arch doesn't "
+			   "support irq work self-IPIs\n");
+		cpumask_clear(tick_nohz_full_mask);
+		cpumask_copy(housekeeping_mask, cpu_possible_mask);
+		tick_nohz_full_running = false;
+		return;
+	}
+
 	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
-- 
1.8.3.1

