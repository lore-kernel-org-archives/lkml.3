Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab3BMQNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:13:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:59715 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934345Ab3BMQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:13:12 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 03/16] softirq: Split softirq locks
Date: Wed, 13 Feb 2013 17:11:58 +0100
Message-Id: <1360771932-27150-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The 3.x RT series removed the split softirq implementation in favour
of pushing softirq processing into the context of the thread which
raised it. Though this prevents us from handling the various softirqs
at different priorities. Now instead of reintroducing the split
softirq threads we split the locks which serialize the softirq
processing.

If a softirq is raised in context of a thread, then the softirq is
noted on a per thread field, if the thread is in a bh disabled
region. If the softirq is raised from hard interrupt context, then the
bit is set in the flag field of ksoftirqd and ksoftirqd is invoked.
When a thread leaves a bh disabled region, then it tries to execute
the softirqs which have been raised in its own context. It acquires
the per softirq / per cpu lock for the softirq and then checks,
whether the softirq is still pending in the per cpu
local_softirq_pending() field. If yes, it runs the softirq. If no,
then some other task executed it already. This allows for zero config
softirq elevation in the context of user space tasks or interrupt
threads.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy@linutronix: PF_MALLOC handling, __raise_softirq_irqoff() not
inline, shrink invoke_softirq()]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/interrupt.h |    6 +-
 include/linux/sched.h     |    1 +
 kernel/softirq.c          |  295 ++++++++++++++++++++++++++++-----------------
 3 files changed, 185 insertions(+), 117 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index f70a65b..cafd56c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -468,11 +468,7 @@ extern void thread_do_softirq(void);
 
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
-static inline void __raise_softirq_irqoff(unsigned int nr)
-{
-	trace_softirq_raise(nr);
-	or_softirq_pending(1UL << nr);
-}
+extern void __raise_softirq_irqoff(unsigned int nr);
 
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 751e65a..324b277 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1607,6 +1607,7 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RT_BASE
 	struct rcu_head put_rcu;
 	int softirq_nestcnt;
+	unsigned int softirqs_raised;
 #endif
 #if defined CONFIG_PREEMPT_RT_FULL && defined CONFIG_HIGHMEM
 	int kmap_idx;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 79ba7d3..3f7b3fb 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -159,6 +159,7 @@ static void handle_softirq(unsigned int vec_nr, int cpu, int need_rcu_bh_qs)
 		rcu_bh_qs(cpu);
 }
 
+#ifndef CONFIG_PREEMPT_RT_FULL
 static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
 {
 	unsigned int vec_nr;
@@ -171,7 +172,6 @@ static void handle_pending_softirqs(u32 pending, int cpu, int need_rcu_bh_qs)
 	local_irq_disable();
 }
 
-#ifndef CONFIG_PREEMPT_RT_FULL
 /*
  * preempt_count and SOFTIRQ_OFFSET usage:
  * - preempt_count is changed by SOFTIRQ_OFFSET on entering or leaving
@@ -375,28 +375,113 @@ asmlinkage void do_softirq(void)
 
 #endif
 
+/*
+ * This function must run with irqs disabled!
+ */
+void raise_softirq_irqoff(unsigned int nr)
+{
+	__raise_softirq_irqoff(nr);
+
+	/*
+	 * If we're in an interrupt or softirq, we're done
+	 * (this also catches softirq-disabled code). We will
+	 * actually run the softirq once we return from
+	 * the irq or softirq.
+	 *
+	 * Otherwise we wake up ksoftirqd to make sure we
+	 * schedule the softirq soon.
+	 */
+	if (!in_interrupt())
+		wakeup_softirqd();
+}
+
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	trace_softirq_raise(nr);
+	or_softirq_pending(1UL << nr);
+}
+
 static inline void local_bh_disable_nort(void) { local_bh_disable(); }
 static inline void _local_bh_enable_nort(void) { _local_bh_enable(); }
 static inline void ksoftirqd_set_sched_params(void) { }
 static inline void ksoftirqd_clr_sched_params(void) { }
 
+static inline int ksoftirqd_softirq_pending(void)
+{
+	return local_softirq_pending();
+}
+
 #else /* !PREEMPT_RT_FULL */
 
 /*
- * On RT we serialize softirq execution with a cpu local lock
+ * On RT we serialize softirq execution with a cpu local lock per softirq
  */
-static DEFINE_LOCAL_IRQ_LOCK(local_softirq_lock);
+static DEFINE_PER_CPU(struct local_irq_lock [NR_SOFTIRQS], local_softirq_locks);
 
-static void __do_softirq_common(int need_rcu_bh_qs);
+void __init softirq_early_init(void)
+{
+	int i;
+
+	for (i = 0; i < NR_SOFTIRQS; i++)
+		local_irq_lock_init(local_softirq_locks[i]);
+}
 
-void __do_softirq(void)
+static void lock_softirq(int which)
 {
-	__do_softirq_common(0);
+	__local_lock(&__get_cpu_var(local_softirq_locks[which]));
 }
 
-void __init softirq_early_init(void)
+static void unlock_softirq(int which)
+{
+	__local_unlock(&__get_cpu_var(local_softirq_locks[which]));
+}
+
+static void do_single_softirq(int which, int need_rcu_bh_qs)
+{
+	account_system_vtime(current);
+	current->flags |= PF_IN_SOFTIRQ;
+	lockdep_softirq_enter();
+	local_irq_enable();
+	handle_softirq(which, smp_processor_id(), need_rcu_bh_qs);
+	local_irq_disable();
+	lockdep_softirq_exit();
+	current->flags &= ~PF_IN_SOFTIRQ;
+	account_system_vtime(current);
+}
+
+/*
+ * Called with interrupts disabled. Process softirqs which were raised
+ * in current context (or on behalf of ksoftirqd).
+ */
+static void do_current_softirqs(int need_rcu_bh_qs)
 {
-	local_irq_lock_init(local_softirq_lock);
+	while (current->softirqs_raised) {
+		int i = __ffs(current->softirqs_raised);
+		unsigned int pending, mask = (1U << i);
+
+		current->softirqs_raised &= ~mask;
+		local_irq_enable();
+
+		/*
+		 * If the lock is contended, we boost the owner to
+		 * process the softirq or leave the critical section
+		 * now.
+		 */
+		lock_softirq(i);
+		local_irq_disable();
+		/*
+		 * Check with the local_softirq_pending() bits,
+		 * whether we need to process this still or if someone
+		 * else took care of it.
+		 */
+		pending = local_softirq_pending();
+		if (pending & mask) {
+			set_softirq_pending(pending & ~mask);
+			do_single_softirq(i, need_rcu_bh_qs);
+		}
+		unlock_softirq(i);
+		WARN_ON(current->softirq_nestcnt != 1);
+	}
 }
 
 void local_bh_disable(void)
@@ -411,17 +496,11 @@ void local_bh_enable(void)
 	if (WARN_ON(current->softirq_nestcnt == 0))
 		return;
 
-	if ((current->softirq_nestcnt == 1) &&
-	    local_softirq_pending() &&
-	    local_trylock(local_softirq_lock)) {
+	local_irq_disable();
+	if (current->softirq_nestcnt == 1 && current->softirqs_raised)
+		do_current_softirqs(1);
+	local_irq_enable();
 
-		local_irq_disable();
-		if (local_softirq_pending())
-			__do_softirq();
-		local_irq_enable();
-		local_unlock(local_softirq_lock);
-		WARN_ON(current->softirq_nestcnt != 1);
-	}
 	current->softirq_nestcnt--;
 	migrate_enable();
 }
@@ -446,37 +525,8 @@ int in_serving_softirq(void)
 }
 EXPORT_SYMBOL(in_serving_softirq);
 
-/*
- * Called with bh and local interrupts disabled. For full RT cpu must
- * be pinned.
- */
-static void __do_softirq_common(int need_rcu_bh_qs)
-{
-	u32 pending = local_softirq_pending();
-	int cpu = smp_processor_id();
-
-	current->softirq_nestcnt++;
-
-	/* Reset the pending bitmask before enabling irqs */
-	set_softirq_pending(0);
-
-	current->flags |= PF_IN_SOFTIRQ;
-
-	lockdep_softirq_enter();
-
-	handle_pending_softirqs(pending, cpu, need_rcu_bh_qs);
-
-	pending = local_softirq_pending();
-	if (pending)
-		wakeup_softirqd();
-
-	lockdep_softirq_exit();
-	current->flags &= ~PF_IN_SOFTIRQ;
-
-	current->softirq_nestcnt--;
-}
-
-static int __thread_do_softirq(int cpu)
+/* Called with preemption disabled */
+static int ksoftirqd_do_softirq(int cpu)
 {
 	/*
 	 * Prevent the current cpu from going offline.
@@ -487,45 +537,90 @@ static int __thread_do_softirq(int cpu)
 	 */
 	pin_current_cpu();
 	/*
-	 * If called from ksoftirqd (cpu >= 0) we need to check
-	 * whether we are on the wrong cpu due to cpu offlining. If
-	 * called via thread_do_softirq() no action required.
+	 * We need to check whether we are on the wrong cpu due to cpu
+	 * offlining.
 	 */
-	if (cpu >= 0 && cpu_is_offline(cpu)) {
+	if (cpu_is_offline(cpu)) {
 		unpin_current_cpu();
 		return -1;
 	}
 	preempt_enable();
-	local_lock(local_softirq_lock);
 	local_irq_disable();
-	/*
-	 * We cannot switch stacks on RT as we want to be able to
-	 * schedule!
-	 */
-	if (local_softirq_pending())
-		__do_softirq_common(cpu >= 0);
-	local_unlock(local_softirq_lock);
-	unpin_current_cpu();
-	preempt_disable();
+	current->softirq_nestcnt++;
+	do_current_softirqs(1);
+	current->softirq_nestcnt--;
 	local_irq_enable();
+
+	preempt_disable();
+	unpin_current_cpu();
 	return 0;
 }
 
 /*
- * Called from netif_rx_ni(). Preemption enabled.
+ * Called from netif_rx_ni(). Preemption enabled, but migration
+ * disabled. So the cpu can't go away under us.
  */
 void thread_do_softirq(void)
 {
-	if (!in_serving_softirq()) {
-		preempt_disable();
-		__thread_do_softirq(-1);
-		preempt_enable();
+	if (!in_serving_softirq() && current->softirqs_raised) {
+		current->softirq_nestcnt++;
+		do_current_softirqs(0);
+		current->softirq_nestcnt--;
 	}
 }
 
-static int ksoftirqd_do_softirq(int cpu)
+void __raise_softirq_irqoff(unsigned int nr)
+{
+	trace_softirq_raise(nr);
+	or_softirq_pending(1UL << nr);
+
+	/*
+	 * If we are not in a hard interrupt and inside a bh disabled
+	 * region, we simply raise the flag on current. local_bh_enable()
+	 * will make sure that the softirq is executed. Otherwise we
+	 * delegate it to ksoftirqd.
+	 */
+	if (!in_irq() && current->softirq_nestcnt)
+		current->softirqs_raised |= (1U << nr);
+	else if (__this_cpu_read(ksoftirqd))
+		__this_cpu_read(ksoftirqd)->softirqs_raised |= (1U << nr);
+}
+
+/*
+ * This function must run with irqs disabled!
+ */
+void raise_softirq_irqoff(unsigned int nr)
+{
+	__raise_softirq_irqoff(nr);
+
+	/*
+	 * If we're in an hard interrupt we let irq return code deal
+	 * with the wakeup of ksoftirqd.
+	 */
+	if (in_irq())
+		return;
+
+	/*
+	 * If we are in thread context but outside of a bh disabled
+	 * region, we need to wake ksoftirqd as well.
+	 *
+	 * CHECKME: Some of the places which do that could be wrapped
+	 * into local_bh_disable/enable pairs. Though it's unclear
+	 * whether this is worth the effort. To find those places just
+	 * raise a WARN() if the condition is met.
+	 */
+	if (!current->softirq_nestcnt)
+		wakeup_softirqd();
+}
+
+void do_raise_softirq_irqoff(unsigned int nr)
+{
+	raise_softirq_irqoff(nr);
+}
+
+static inline int ksoftirqd_softirq_pending(void)
 {
-	return __thread_do_softirq(cpu);
+	return current->softirqs_raised;
 }
 
 static inline void local_bh_disable_nort(void) { }
@@ -536,6 +631,10 @@ static inline void ksoftirqd_set_sched_params(void)
 	struct sched_param param = { .sched_priority = 1 };
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
+	/* Take over all pending softirqs when starting */
+	local_irq_disable();
+	current->softirqs_raised = local_softirq_pending();
+	local_irq_enable();
 }
 
 static inline void ksoftirqd_clr_sched_params(void)
@@ -567,39 +666,31 @@ void irq_enter(void)
 	__irq_enter();
 }
 
-#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 static inline void invoke_softirq(void)
 {
 #ifndef CONFIG_PREEMPT_RT_FULL
-	if (!force_irqthreads)
+	if (!force_irqthreads) {
+#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
-	else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
-		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
-#else
-	wakeup_softirqd();
-#endif
-}
 #else
-static inline void invoke_softirq(void)
-{
-#ifndef CONFIG_PREEMPT_RT_FULL
-	if (!force_irqthreads)
 		do_softirq();
-	else {
+#endif
+	} else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
 		__local_bh_enable(SOFTIRQ_OFFSET);
 	}
-#else
-	wakeup_softirqd();
+#else /* PREEMPT_RT_FULL */
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (__this_cpu_read(ksoftirqd) &&
+	    __this_cpu_read(ksoftirqd)->softirqs_raised)
+		wakeup_softirqd();
+	local_irq_restore(flags);
 #endif
 }
-#endif
 
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
@@ -621,26 +712,6 @@ void irq_exit(void)
 	__preempt_enable_no_resched();
 }
 
-/*
- * This function must run with irqs disabled!
- */
-inline void raise_softirq_irqoff(unsigned int nr)
-{
-	__raise_softirq_irqoff(nr);
-
-	/*
-	 * If we're in an interrupt or softirq, we're done
-	 * (this also catches softirq-disabled code). We will
-	 * actually run the softirq once we return from
-	 * the irq or softirq.
-	 *
-	 * Otherwise we wake up ksoftirqd to make sure we
-	 * schedule the softirq soon.
-	 */
-	if (!in_interrupt())
-		wakeup_softirqd();
-}
-
 void raise_softirq(unsigned int nr)
 {
 	unsigned long flags;
@@ -1101,12 +1172,12 @@ static int run_ksoftirqd(void * __bind_cpu)
 
 	while (!kthread_should_stop()) {
 		preempt_disable();
-		if (!local_softirq_pending())
+		if (!ksoftirqd_softirq_pending())
 			schedule_preempt_disabled();
 
 		__set_current_state(TASK_RUNNING);
 
-		while (local_softirq_pending()) {
+		while (ksoftirqd_softirq_pending()) {
 			if (ksoftirqd_do_softirq((long) __bind_cpu))
 				goto wait_to_die;
 			__preempt_enable_no_resched();
-- 
1.7.10.4

