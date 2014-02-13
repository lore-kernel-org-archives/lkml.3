Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBMBkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:40:23 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50954 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaBMBkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:40:21 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC] sched: Add a new lockless wake-from-idle implementation
Date: Wed, 12 Feb 2014 17:40:12 -0800
Message-Id: <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
References: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a strawman proposal to simplify the idle implementation, eliminate
a race

Benefits over current code:
 - ttwu_queue_remote doesn't use an IPI unless needed
 - The diffstat should speak for itself :)
 - Less racy.  Spurious IPIs are possible, but only in narrow windows or
   when two wakeups occur in rapid succession.
 - Seems to work (?)

Issues:
 - Am I doing the percpu stuff right?
 - Needs work on non-x86 architectures
 - The !CONFIG_SMP case needs to be checked
 - Is "idlepoll" a good name for the new code?  It doesn't have *that*
   much to do with the idle state.  Maybe cpukick?

If this turns out okay, TIF_NEED_RESCHED could possibly be deleted as well.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/mwait.h       |  22 +++----
 arch/x86/include/asm/thread_info.h |   2 -
 arch/x86/kernel/apm_32.c           |  12 ----
 include/linux/idlepoll.h           |  85 ++++++++++++++++++++++++++
 include/linux/preempt.h            |   5 --
 include/linux/sched.h              | 120 -------------------------------------
 kernel/cpu/idle.c                  |  60 ++++++++++++-------
 kernel/sched/core.c                |  93 +++++++++++-----------------
 8 files changed, 167 insertions(+), 232 deletions(-)
 create mode 100644 include/linux/idlepoll.h

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 1da25a5..8addd29 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_MWAIT_H
 
 #include <linux/sched.h>
+#include <linux/idlepoll.h>
 
 #define MWAIT_SUBSTATE_MASK		0xf
 #define MWAIT_CSTATE_MASK		0xf
@@ -42,18 +43,17 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
  */
 static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
-	if (!current_set_polling_and_test()) {
-		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
-			mb();
-			clflush((void *)&current_thread_info()->flags);
-			mb();
-		}
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		if (!need_resched())
-			__mwait(eax, ecx);
+	idlepoll_begin_poll();
+	if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+		mb();
+		clflush(idlepoll_poll_ptr());
+		mb();
 	}
-	current_clr_polling();
+
+	__monitor(idlepoll_poll_ptr(), 0, 0);
+	if (idlepoll_keep_polling())
+		__mwait(eax, ecx);
+	idlepoll_end_poll();
 }
 
 #endif /* _ASM_X86_MWAIT_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e1940c0..caa3f63 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -234,8 +234,6 @@ static inline struct thread_info *current_thread_info(void)
  * have to worry about atomic accesses.
  */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-#define TS_POLLING		0x0004	/* idle task polling need_resched,
-					   skip sending interrupt */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 3ab0343..5848744 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -841,24 +841,12 @@ static int apm_do_idle(void)
 	u32 eax;
 	u8 ret = 0;
 	int idled = 0;
-	int polling;
 	int err = 0;
 
-	polling = !!(current_thread_info()->status & TS_POLLING);
-	if (polling) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
-	}
 	if (!need_resched()) {
 		idled = 1;
 		ret = apm_bios_call_simple(APM_FUNC_IDLE, 0, 0, &eax, &err);
 	}
-	if (polling)
-		current_thread_info()->status |= TS_POLLING;
 
 	if (!idled)
 		return 0;
diff --git a/include/linux/idlepoll.h b/include/linux/idlepoll.h
new file mode 100644
index 0000000..072bc7e
--- /dev/null
+++ b/include/linux/idlepoll.h
@@ -0,0 +1,85 @@
+/*
+ * idlepoll.h: definitions and inlines for lockless wake-from-idle.
+ *
+ * Copyright (c) 2014 Andy Lutomirski (luto@amacapital.net)
+ */
+#ifndef __IDLEPOLL_H
+#define __IDLEPOLL_H
+
+#include <linux/percpu-defs.h>
+#include <asm/atomic.h>
+
+DECLARE_PER_CPU_ALIGNED(atomic_t, idlepoll_state);
+
+#define IDLEPOLL_NOT_POLLING	0  /* wakers must send IPI */
+#define IDLEPOLL_POLLING	1  /* ok to wake using idlepoll_state */
+#define IDLEPOLL_KICKED		2  /* __idlepoll_kicked will be called soon */
+
+void __idlepoll_kicked(void);
+
+/**
+ * idlepoll_poll_ptr - Address to use for hardware idle polling
+ *
+ * On architectures with an idle-until-an-address-is-written operations,
+ * this returns the address to use.
+ */
+static inline void *idlepoll_poll_ptr(void)
+{
+	return this_cpu_ptr(&idlepoll_state);
+}
+
+/**
+ * idlepoll_begin_poll - Address to use for hardware idle polling
+ *
+ * If an idle implementation polls, call this before polling.
+ */
+static inline void idlepoll_begin_poll(void)
+{
+	BUG_ON(atomic_read(this_cpu_ptr(&idlepoll_state)) == IDLEPOLL_POLLING);
+
+	/*
+	 * Mark us polling.  Note: we don't particularly care what
+	 * what the previous value was.  If it was IDLEPOLL_KICKED, then
+	 * an IPI is on its way.
+	 */
+	atomic_set(this_cpu_ptr(&idlepoll_state), IDLEPOLL_POLLING);
+
+	/*
+	 * No barrier here: we assume that whoever calls us has enough
+	 * barriers to notice idlepoll_state changing.
+	 */
+}
+
+/**
+ * idlepoll_end_poll - Address to use for hardware idle polling
+ *
+ * If an idle implementation polls, call this after polling.
+ */
+static inline void idlepoll_end_poll(void)
+{
+	/*
+	 * It's possible to be in IDLEPOLL_NOT_POLLING: an IPI
+	 * could have come in and beaten us to the punch.
+	 */
+	if (atomic_xchg(this_cpu_ptr(&idlepoll_state), IDLEPOLL_NOT_POLLING) ==
+	    IDLEPOLL_KICKED)
+		__idlepoll_kicked();
+}
+
+/**
+ * idlepoll_keep_polling - Should a polling idle implementation stop polling?
+ *
+ * If an idle implementation polls, it should check this before pausing
+ * or asking hardware to wait.
+ */
+static inline bool idlepoll_keep_polling(void)
+{
+	return atomic_read(this_cpu_ptr(&idlepoll_state)) == IDLEPOLL_POLLING
+		&& !test_preempt_need_resched();
+}
+
+#ifdef CONFIG_SMP
+void idlepoll_kick_cpu(int cpu);
+#endif
+
+#endif
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index de83b4e..04a3f39 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -138,11 +138,6 @@ do { \
 do { \
 	set_preempt_need_resched(); \
 } while (0)
-#define preempt_fold_need_resched() \
-do { \
-	if (tif_need_resched()) \
-		set_preempt_need_resched(); \
-} while (0)
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..508df16 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2661,126 +2661,6 @@ static inline int spin_needbreak(spinlock_t *lock)
 #endif
 }
 
-/*
- * Idle thread specific functions to determine the need_resched
- * polling state. We have two versions, one based on TS_POLLING in
- * thread_info.status and one based on TIF_POLLING_NRFLAG in
- * thread_info.flags
- */
-#ifdef TS_POLLING
-static inline int tsk_is_polling(struct task_struct *p)
-{
-	return task_thread_info(p)->status & TS_POLLING;
-}
-static inline void __current_set_polling(void)
-{
-	current_thread_info()->status |= TS_POLLING;
-}
-
-static inline bool __must_check current_set_polling_and_test(void)
-{
-	__current_set_polling();
-
-	/*
-	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
-	 */
-	smp_mb();
-
-	return unlikely(tif_need_resched());
-}
-
-static inline void __current_clr_polling(void)
-{
-	current_thread_info()->status &= ~TS_POLLING;
-}
-
-static inline bool __must_check current_clr_polling_and_test(void)
-{
-	__current_clr_polling();
-
-	/*
-	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
-	 */
-	smp_mb();
-
-	return unlikely(tif_need_resched());
-}
-#elif defined(TIF_POLLING_NRFLAG)
-static inline int tsk_is_polling(struct task_struct *p)
-{
-	return test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
-}
-
-static inline void __current_set_polling(void)
-{
-	set_thread_flag(TIF_POLLING_NRFLAG);
-}
-
-static inline bool __must_check current_set_polling_and_test(void)
-{
-	__current_set_polling();
-
-	/*
-	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
-	 *
-	 * XXX: assumes set/clear bit are identical barrier wise.
-	 */
-	smp_mb__after_clear_bit();
-
-	return unlikely(tif_need_resched());
-}
-
-static inline void __current_clr_polling(void)
-{
-	clear_thread_flag(TIF_POLLING_NRFLAG);
-}
-
-static inline bool __must_check current_clr_polling_and_test(void)
-{
-	__current_clr_polling();
-
-	/*
-	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
-	 */
-	smp_mb__after_clear_bit();
-
-	return unlikely(tif_need_resched());
-}
-
-#else
-static inline int tsk_is_polling(struct task_struct *p) { return 0; }
-static inline void __current_set_polling(void) { }
-static inline void __current_clr_polling(void) { }
-
-static inline bool __must_check current_set_polling_and_test(void)
-{
-	return unlikely(tif_need_resched());
-}
-static inline bool __must_check current_clr_polling_and_test(void)
-{
-	return unlikely(tif_need_resched());
-}
-#endif
-
-static inline void current_clr_polling(void)
-{
-	__current_clr_polling();
-
-	/*
-	 * Ensure we check TIF_NEED_RESCHED after we clear the polling bit.
-	 * Once the bit is cleared, we'll get IPIs with every new
-	 * TIF_NEED_RESCHED and the IPI handler, scheduler_ipi(), will also
-	 * fold.
-	 */
-	smp_mb(); /* paired with resched_task() */
-
-	preempt_fold_need_resched();
-}
-
 static __always_inline bool need_resched(void)
 {
 	return unlikely(tif_need_resched());
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 277f494..5f772f5 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -6,12 +6,14 @@
 #include <linux/tick.h>
 #include <linux/mm.h>
 #include <linux/stackprotector.h>
+#include <linux/idlepoll.h>
 
 #include <asm/tlb.h>
 
 #include <trace/events/power.h>
 
 static int __read_mostly cpu_idle_force_poll;
+DEFINE_PER_CPU(atomic_t, idlepoll_state) ____cacheline_aligned;
 
 void cpu_idle_poll_ctrl(bool enable)
 {
@@ -44,13 +46,39 @@ static inline int cpu_idle_poll(void)
 	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
-	while (!tif_need_resched())
+
+	idlepoll_begin_poll();
+	while (idlepoll_keep_polling())
 		cpu_relax();
+	idlepoll_end_poll();
+
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	rcu_idle_exit();
 	return 1;
 }
 
+#ifdef CONFIG_SMP
+DEFINE_PER_CPU_ALIGNED(atomic_t, idlepoll_state);
+EXPORT_SYMBOL_GPL(idlepoll_state);
+
+/**
+ * idlepoll_kick_cpu - Cause a target cpu to call __idlepoll_kicked
+ *
+ * This implies a strong enough barrier that any writes before
+ * idlepoll_kick_cpu will be visible before __idlepoll_kicked is called.
+ *
+ * Do NOT call this on the current cpu.  Call from any context: no
+ * locks are required or taken.
+ */
+void idlepoll_kick_cpu(int cpu)
+{
+	if (atomic_xchg(per_cpu_ptr(&idlepoll_state, cpu), IDLEPOLL_KICKED) ==
+	    IDLEPOLL_NOT_POLLING)
+		smp_send_reschedule(cpu);
+}
+EXPORT_SYMBOL_GPL(idlepoll_kick_cpu);
+#endif
+
 /* Weak implementations for optional arch specific functions */
 void __weak arch_cpu_idle_prepare(void) { }
 void __weak arch_cpu_idle_enter(void) { }
@@ -65,12 +93,13 @@ void __weak arch_cpu_idle(void)
 /*
  * Generic idle loop implementation
  */
+
 static void cpu_idle_loop(void)
 {
 	while (1) {
 		tick_nohz_idle_enter();
 
-		while (!need_resched()) {
+		while (!test_preempt_need_resched()) {
 			check_pgt_cache();
 			rmb();
 
@@ -92,30 +121,16 @@ static void cpu_idle_loop(void)
 			if (cpu_idle_force_poll || tick_check_broadcast_expired()) {
 				cpu_idle_poll();
 			} else {
-				if (!current_clr_polling_and_test()) {
-					stop_critical_timings();
-					rcu_idle_enter();
-					arch_cpu_idle();
-					WARN_ON_ONCE(irqs_disabled());
-					rcu_idle_exit();
-					start_critical_timings();
-				} else {
-					local_irq_enable();
-				}
-				__current_set_polling();
+				stop_critical_timings();
+				rcu_idle_enter();
+				arch_cpu_idle();
+				WARN_ON_ONCE(irqs_disabled());
+				rcu_idle_exit();
+				start_critical_timings();
 			}
 			arch_cpu_idle_exit();
 		}
 
-		/*
-		 * Since we fell out of the loop above, we know
-		 * TIF_NEED_RESCHED must be set, propagate it into
-		 * PREEMPT_NEED_RESCHED.
-		 *
-		 * This is required because for polling idle loops we will
-		 * not have had an IPI to fold the state for us.
-		 */
-		preempt_set_need_resched();
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
 	}
@@ -138,7 +153,6 @@ void cpu_startup_entry(enum cpuhp_state state)
 	 */
 	boot_init_stack_canary();
 #endif
-	__current_set_polling();
 	arch_cpu_idle_prepare();
 	cpu_idle_loop();
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..b771c46 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -73,6 +73,7 @@
 #include <linux/init_task.h>
 #include <linux/binfmts.h>
 #include <linux/context_tracking.h>
+#include <linux/idlepoll.h>
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
@@ -504,6 +505,18 @@ static inline void init_hrtick(void)
 }
 #endif	/* CONFIG_SCHED_HRTICK */
 
+void resched_cpu(int cpu)
+{
+#ifdef CONFIG_SMP
+	if (cpu == smp_processor_id())
+		set_preempt_need_resched();
+	else
+		idlepoll_kick_cpu(cpu);
+#else
+	set_preempt_need_resched();
+#endif
+}
+
 /*
  * resched_task - mark a task 'to be rescheduled now'.
  *
@@ -513,36 +526,16 @@ static inline void init_hrtick(void)
  */
 void resched_task(struct task_struct *p)
 {
-	int cpu;
-
 	lockdep_assert_held(&task_rq(p)->lock);
 
+	/* XXX: this is probably unnecessary. */
 	if (test_tsk_need_resched(p))
 		return;
 
+	/* XXX: so is this. */
 	set_tsk_need_resched(p);
 
-	cpu = task_cpu(p);
-	if (cpu == smp_processor_id()) {
-		set_preempt_need_resched();
-		return;
-	}
-
-	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
-	if (!tsk_is_polling(p))
-		smp_send_reschedule(cpu);
-}
-
-void resched_cpu(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
-
-	if (!raw_spin_trylock_irqsave(&rq->lock, flags))
-		return;
-	resched_task(cpu_curr(cpu));
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	resched_cpu(task_cpu(p));
 }
 
 #ifdef CONFIG_SMP
@@ -586,32 +579,10 @@ unlock:
  */
 static void wake_up_idle_cpu(int cpu)
 {
-	struct rq *rq = cpu_rq(cpu);
-
 	if (cpu == smp_processor_id())
 		return;
 
-	/*
-	 * This is safe, as this function is called with the timer
-	 * wheel base lock of (cpu) held. When the CPU is on the way
-	 * to idle and has not yet set rq->curr to idle then it will
-	 * be serialized on the timer wheel base lock and take the new
-	 * timer into account automatically.
-	 */
-	if (rq->curr != rq->idle)
-		return;
-
-	/*
-	 * We can set TIF_RESCHED on the idle task of the other CPU
-	 * lockless. The worst case is that the other CPU runs the
-	 * idle task through an additional NOOP schedule()
-	 */
-	set_tsk_need_resched(rq->idle);
-
-	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
-	if (!tsk_is_polling(rq->idle))
-		smp_send_reschedule(cpu);
+	idlepoll_kick_cpu(cpu);
 }
 
 static bool wake_up_full_nohz_cpu(int cpu)
@@ -1493,19 +1464,23 @@ static void sched_ttwu_pending(void)
 	raw_spin_unlock(&rq->lock);
 }
 
+void __idlepoll_kicked(void)
+{
+	set_preempt_need_resched();
+	sched_ttwu_pending();
+}
+EXPORT_SYMBOL_GPL(__idlepoll_kicked);
+
 void scheduler_ipi(void)
 {
-	/*
-	 * Fold TIF_NEED_RESCHED into the preempt_count; anybody setting
-	 * TIF_NEED_RESCHED remotely (for the first time) will also send
-	 * this IPI.
-	 */
-	preempt_fold_need_resched();
+	irq_enter();
 
-	if (llist_empty(&this_rq()->wake_list)
-			&& !tick_nohz_full_cpu(smp_processor_id())
-			&& !got_nohz_idle_kick())
-		return;
+	if (atomic_xchg(this_cpu_ptr(&idlepoll_state), IDLEPOLL_NOT_POLLING) ==
+	    IDLEPOLL_KICKED)
+		__idlepoll_kicked();
+
+	if (!tick_nohz_full_cpu(smp_processor_id()) && !got_nohz_idle_kick())
+		goto out;
 
 	/*
 	 * Not all reschedule IPI handlers call irq_enter/irq_exit, since
@@ -1520,9 +1495,7 @@ void scheduler_ipi(void)
 	 * however a fair share of IPIs are still resched only so this would
 	 * somewhat pessimize the simple resched case.
 	 */
-	irq_enter();
 	tick_nohz_full_check();
-	sched_ttwu_pending();
 
 	/*
 	 * Check if someone kicked us for doing the nohz idle load balance.
@@ -1531,13 +1504,15 @@ void scheduler_ipi(void)
 		this_rq()->idle_balance = 1;
 		raise_softirq_irqoff(SCHED_SOFTIRQ);
 	}
+
+out:
 	irq_exit();
 }
 
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
 	if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
-		smp_send_reschedule(cpu);
+		idlepoll_kick_cpu(cpu);
 }
 
 bool cpus_share_cache(int this_cpu, int that_cpu)
-- 
1.8.5.3

