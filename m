Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaAaOeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:34:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:54691 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaAaOeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:34:12 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] irq_work: allow certain work in hard irq context
Date: Fri, 31 Jan 2014 15:34:04 +0100
Message-Id: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_work is processed in softirq context on -RT because we want to avoid
long latencies which might arise from processing lots of perf events.
The noHZ-full mode requires its callback to be called from real hardirq
context (commit 76c24fb ("nohz: New APIs to re-evaluate the tick on full
dynticks CPUs")). If it is called from a thread context we might get
wrong results for checks like "is_idle_task(current)".
This patch introduces a second list (hirq_work_list) which will be used
if irq_work_run() has been invoked from hardirq context and process only
work items marked with IRQ_WORK_HARD_IRQ.

This patch also removes arch_irq_work_raise() from sparc & powerpc like
it is already done for x86. Atleast for powerpc it is somehow
superfluous because it is called from the timer interrupt which should
invoke update_process_times().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/powerpc/kernel/time.c |  2 +-
 arch/sparc/kernel/pcr.c    |  2 ++
 include/linux/irq_work.h   |  1 +
 kernel/irq_work.c          | 23 ++++++++++++++++++++---
 kernel/time/tick-sched.c   |  1 +
 kernel/timer.c             |  2 +-
 6 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index b3b1441..5ac241b 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -423,7 +423,7 @@ unsigned long profile_pc(struct pt_regs *regs)
 EXPORT_SYMBOL(profile_pc);
 #endif
 
-#ifdef CONFIG_IRQ_WORK
+#if defined(CONFIG_IRQ_WORK) && !defined(CONFIG_PREEMPT_RT_FULL)
 
 /*
  * 64-bit uses a byte in the PACA, 32-bit uses a per-cpu variable...
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index 269af58..dbb51a6 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -43,10 +43,12 @@ void __irq_entry deferred_pcr_work_irq(int irq, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 void arch_irq_work_raise(void)
 {
 	set_softint(1 << PIL_DEFERRED_PCR_WORK);
 }
+#endif
 
 const struct pcr_ops *pcr_ops;
 EXPORT_SYMBOL_GPL(pcr_ops);
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6601702..60c19ee 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -16,6 +16,7 @@
 #define IRQ_WORK_BUSY		2UL
 #define IRQ_WORK_FLAGS		3UL
 #define IRQ_WORK_LAZY		4UL /* Doesn't want IPI, wait for tick */
+#define IRQ_WORK_HARD_IRQ	8UL /* Run hard IRQ context, even on RT */
 
 struct irq_work {
 	unsigned long flags;
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f6e4377..3dc166d 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -20,6 +20,9 @@
 
 
 static DEFINE_PER_CPU(struct llist_head, irq_work_list);
+#ifdef CONFIG_PREEMPT_RT_FULL
+static DEFINE_PER_CPU(struct llist_head, hirq_work_list);
+#endif
 static DEFINE_PER_CPU(int, irq_work_raised);
 
 /*
@@ -48,7 +51,11 @@ static bool irq_work_claim(struct irq_work *work)
 	return true;
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+void arch_irq_work_raise(void)
+#else
 void __weak arch_irq_work_raise(void)
+#endif
 {
 	/*
 	 * Lame architectures will get the timer tick callback
@@ -70,8 +77,12 @@ void irq_work_queue(struct irq_work *work)
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (work->flags & IRQ_WORK_HARD_IRQ)
+		llist_add(&work->llnode, &__get_cpu_var(hirq_work_list));
+	else
+#endif
+		llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
 	/*
 	 * If the work is not "lazy" or the tick is stopped, raise the irq
 	 * work interrupt (if supported by the arch), otherwise, just wait
@@ -115,7 +126,13 @@ static void __irq_work_run(void)
 	__this_cpu_write(irq_work_raised, 0);
 	barrier();
 
-	this_list = &__get_cpu_var(irq_work_list);
+	pr_err("%s(%d) %d\n", __func__, __LINE__, in_irq() ? 1 : 0);
+#ifdef CONFIG_PREEMPT_RT_FULL
+	if (in_irq())
+		this_list = &__get_cpu_var(hirq_work_list);
+	else
+#endif
+		this_list = &__get_cpu_var(irq_work_list);
 	if (llist_empty(this_list))
 		return;
 
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4675aab..a236875 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -221,6 +221,7 @@ static void nohz_full_kick_work_func(struct irq_work *work)
 
 static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
 	.func = nohz_full_kick_work_func,
+	.flags = IRQ_WORK_HARD_IRQ,
 };
 
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index 106968f..6b3c172 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1425,7 +1425,7 @@ void update_process_times(int user_tick)
 	scheduler_tick();
 	run_local_timers();
 	rcu_check_callbacks(cpu, user_tick);
-#if defined(CONFIG_IRQ_WORK) && !defined(CONFIG_PREEMPT_RT_FULL)
+#if defined(CONFIG_IRQ_WORK)
 	if (in_irq())
 		irq_work_run();
 #endif
-- 
1.8.5.3

