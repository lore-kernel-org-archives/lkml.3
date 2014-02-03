Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaBCTsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:48:45 -0500
Received: from www.linutronix.de ([62.245.132.108]:41981 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaBCTsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:48:43 -0500
Date: Mon, 3 Feb 2014 20:48:41 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, John Kacur <jkacur@redhat.com>
Subject: [ANNOUNCE] 3.12.9-rt13
Message-ID: <20140203194841.GA17108@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT folks!

I'm pleased to announce the v3.12.9-rt13 patch set.

Changes since v3.12.9-rt12
- The fix for "do not to raise the timer softirq unconditionally" was
  not perfect. Steven made a better one, thank you Steven.
- Drop the CPU led trigger. It is called from hard irq context and
  requires sleeping spinlocks. I doubt anyone will miss it.
- migrate_disable() in read_lock()/write_lock() has been pused into
  rt_read_lock()/rt_write_lock(). A cleanup patch by Nicholas Mc Guire.
- drop a migrate_disable() call in local_lock(). Clean up / optimization
  by Nicholas Mc Guire.
- a smal API clean up in lock_softirq()/unlock_softirq(). A patch by
  Nicholas Mc Guire.
- A patch from Paul E. McKenney to move RCU processing from softirq into
  its own thread. Mike Galbraith has been testing it and he did not
  complain anymore.

Known issues:

      - bcache is disabled.

      - In the NO_HZ_FULL mode there might come a onetime backtrace from
        kernel/time/tick-sched.c:191. I have a patch which should fix
        this (irq_work-allow-certain-work-in-hard-irq-context.patch) but
        Mike said that it caused two of his 64 CPUs to spin for five minutes
        doing nothing. Therefore it is disabled in the queue. Everyone
        who wants test it may do so :)

The delta patch against v3.12.9-rt12 is appended below and can be found
here:
   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/incr/patch-3.12.9-rt12-rt13.patch.xz

The RT patch against 3.12.9 can be found here:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patch-3.12.9-rt13.patch.xz

The split quilt queue is available at:

   https://www.kernel.org/pub/linux/kernel/projects/rt/3.12/patches-3.12.9-rt13.tar.xz

Sebastian

diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 49794b4..3d7245d 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -61,7 +61,7 @@ config LEDS_TRIGGER_BACKLIGHT
 
 config LEDS_TRIGGER_CPU
 	bool "LED CPU Trigger"
-	depends on LEDS_TRIGGERS
+	depends on LEDS_TRIGGERS && !PREEMPT_RT_BASE
 	help
 	  This allows LEDs to be controlled by active CPUs. This shows
 	  the active CPUs across an array of LEDs so you can see which
diff --git a/include/linux/locallock.h b/include/linux/locallock.h
index e7bd8be..32c684b 100644
--- a/include/linux/locallock.h
+++ b/include/linux/locallock.h
@@ -39,7 +39,7 @@ struct local_irq_lock {
 static inline void __local_lock(struct local_irq_lock *lv)
 {
 	if (lv->owner != current) {
-		spin_lock(&lv->lock);
+		spin_lock_local(&lv->lock);
 		LL_WARN(lv->owner);
 		LL_WARN(lv->nestcnt);
 		lv->owner = current;
@@ -52,7 +52,7 @@ static inline void __local_lock(struct local_irq_lock *lv)
 
 static inline int __local_trylock(struct local_irq_lock *lv)
 {
-	if (lv->owner != current && spin_trylock(&lv->lock)) {
+	if (lv->owner != current && spin_trylock_local(&lv->lock)) {
 		LL_WARN(lv->owner);
 		LL_WARN(lv->nestcnt);
 		lv->owner = current;
@@ -79,7 +79,7 @@ static inline void __local_unlock(struct local_irq_lock *lv)
 		return;
 
 	lv->owner = NULL;
-	spin_unlock(&lv->lock);
+	spin_unlock_local(&lv->lock);
 }
 
 #define local_unlock(lvar)					\
@@ -211,7 +211,7 @@ static inline int __local_unlock_irqrestore(struct local_irq_lock *lv,
 		&__get_cpu_var(var);					\
 	}))
 
-#define put_locked_var(lvar, var)		local_unlock(lvar)
+#define put_locked_var(lvar, var)	local_unlock(lvar);
 
 #define local_lock_cpu(lvar)						\
 	({								\
diff --git a/include/linux/rwlock_rt.h b/include/linux/rwlock_rt.h
index 853ee36..e85a5df 100644
--- a/include/linux/rwlock_rt.h
+++ b/include/linux/rwlock_rt.h
@@ -33,27 +33,23 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 #define read_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		migrate_disable();			\
 		flags = rt_read_lock_irqsave(lock);	\
 	} while (0)
 
 #define write_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		migrate_disable();			\
 		flags = rt_write_lock_irqsave(lock);	\
 	} while (0)
 
 #define read_lock(lock)					\
 	do {						\
-		migrate_disable();			\
 		rt_read_lock(lock);			\
 	} while (0)
 
 #define read_lock_bh(lock)				\
 	do {						\
 		local_bh_disable();			\
-		migrate_disable();			\
 		rt_read_lock(lock);			\
 	} while (0)
 
@@ -61,14 +57,12 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 
 #define write_lock(lock)				\
 	do {						\
-		migrate_disable();			\
 		rt_write_lock(lock);			\
 	} while (0)
 
 #define write_lock_bh(lock)				\
 	do {						\
 		local_bh_disable();			\
-		migrate_disable();			\
 		rt_write_lock(lock);			\
 	} while (0)
 
@@ -77,13 +71,11 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 #define read_unlock(lock)				\
 	do {						\
 		rt_read_unlock(lock);			\
-		migrate_enable();			\
 	} while (0)
 
 #define read_unlock_bh(lock)				\
 	do {						\
 		rt_read_unlock(lock);			\
-		migrate_enable();			\
 		local_bh_enable();			\
 	} while (0)
 
@@ -92,13 +84,11 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 #define write_unlock(lock)				\
 	do {						\
 		rt_write_unlock(lock);			\
-		migrate_enable();			\
 	} while (0)
 
 #define write_unlock_bh(lock)				\
 	do {						\
 		rt_write_unlock(lock);			\
-		migrate_enable();			\
 		local_bh_enable();			\
 	} while (0)
 
@@ -109,7 +99,6 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 		typecheck(unsigned long, flags);	\
 		(void) flags;				\
 		rt_read_unlock(lock);			\
-		migrate_enable();			\
 	} while (0)
 
 #define write_unlock_irqrestore(lock, flags) \
@@ -117,7 +106,6 @@ extern void __rt_rwlock_init(rwlock_t *rwlock, char *name, struct lock_class_key
 		typecheck(unsigned long, flags);	\
 		(void) flags;				\
 		rt_write_unlock(lock);			\
-		migrate_enable();			\
 	} while (0)
 
 #endif
diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index b3c504b..4f91114 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -37,6 +37,7 @@ extern void __lockfunc __rt_spin_lock(struct rt_mutex *lock);
 extern void __lockfunc __rt_spin_unlock(struct rt_mutex *lock);
 
 #define spin_lock_local(lock)			rt_spin_lock(lock)
+#define spin_trylock_local(lock)		rt_spin_trylock(lock)
 #define spin_unlock_local(lock)			rt_spin_unlock(lock)
 
 #define spin_lock(lock)				\
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f4f61bb..507fab1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -55,6 +55,11 @@
 #include <linux/random.h>
 #include <linux/ftrace_event.h>
 #include <linux/suspend.h>
+#include <linux/delay.h>
+#include <linux/gfp.h>
+#include <linux/oom.h>
+#include <linux/smpboot.h>
+#include "time/tick-internal.h"
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -145,8 +150,6 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  */
 static int rcu_scheduler_fully_active __read_mostly;
 
-#ifdef CONFIG_RCU_BOOST
-
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
  * handle all flavors of RCU.
@@ -156,8 +159,6 @@ DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
@@ -2226,16 +2227,14 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 /*
  * Do RCU core processing for the current CPU.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
 	struct rcu_state *rsp;
 
 	if (cpu_is_offline(smp_processor_id()))
 		return;
-	trace_rcu_utilization(TPS("Start RCU core"));
 	for_each_rcu_flavor(rsp)
 		__rcu_process_callbacks(rsp);
-	trace_rcu_utilization(TPS("End RCU core"));
 }
 
 /*
@@ -2249,18 +2248,105 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	if (unlikely(!ACCESS_ONCE(rcu_scheduler_fully_active)))
 		return;
-	if (likely(!rsp->boost)) {
-		rcu_do_batch(rsp, rdp);
+	rcu_do_batch(rsp, rdp);
+}
+
+static void rcu_wake_cond(struct task_struct *t, int status)
+{
+	/*
+	 * If the thread is yielding, only wake it when this
+	 * is invoked from idle
+	 */
+	if (t && (status != RCU_KTHREAD_YIELDING || is_idle_task(current)))
+		wake_up_process(t);
+}
+
+/*
+ * Wake up this CPU's rcuc kthread to do RCU core processing.
+ */
+static void invoke_rcu_core(void)
+{
+	unsigned long flags;
+	struct task_struct *t;
+
+	if (!cpu_online(smp_processor_id()))
 		return;
+	local_irq_save(flags);
+	__this_cpu_write(rcu_cpu_has_work, 1);
+	t = __this_cpu_read(rcu_cpu_kthread_task);
+	if (t != NULL && current != t)
+		rcu_wake_cond(t, __this_cpu_read(rcu_cpu_kthread_status));
+	local_irq_restore(flags);
+}
+
+static void rcu_cpu_kthread_park(unsigned int cpu)
+{
+	per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
+}
+
+static int rcu_cpu_kthread_should_run(unsigned int cpu)
+{
+	return __this_cpu_read(rcu_cpu_has_work);
+}
+
+/*
+ * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
+ * RCU softirq used in flavors and configurations of RCU that do not
+ * support RCU priority boosting.
+ */
+static void rcu_cpu_kthread(unsigned int cpu)
+{
+	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
+	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
+	int spincnt;
+
+	for (spincnt = 0; spincnt < 10; spincnt++) {
+		trace_rcu_utilization(TPS("Start CPU kthread@rcu_wait"));
+		local_bh_disable();
+		*statusp = RCU_KTHREAD_RUNNING;
+		this_cpu_inc(rcu_cpu_kthread_loops);
+		local_irq_disable();
+		work = *workp;
+		*workp = 0;
+		local_irq_enable();
+		if (work)
+			rcu_process_callbacks();
+		local_bh_enable();
+		if (*workp == 0) {
+			trace_rcu_utilization(TPS("End CPU kthread@rcu_wait"));
+			*statusp = RCU_KTHREAD_WAITING;
+			return;
+		}
 	}
-	invoke_rcu_callbacks_kthread();
+	*statusp = RCU_KTHREAD_YIELDING;
+	trace_rcu_utilization(TPS("Start CPU kthread@rcu_yield"));
+	schedule_timeout_interruptible(2);
+	trace_rcu_utilization(TPS("End CPU kthread@rcu_yield"));
+	*statusp = RCU_KTHREAD_WAITING;
 }
 
-static void invoke_rcu_core(void)
+static struct smp_hotplug_thread rcu_cpu_thread_spec = {
+	.store			= &rcu_cpu_kthread_task,
+	.thread_should_run	= rcu_cpu_kthread_should_run,
+	.thread_fn		= rcu_cpu_kthread,
+	.thread_comm		= "rcuc/%u",
+	.setup			= rcu_cpu_kthread_setup,
+	.park			= rcu_cpu_kthread_park,
+};
+
+/*
+ * Spawn per-CPU RCU core processing kthreads.
+ */
+static int __init rcu_spawn_core_kthreads(void)
 {
-	if (cpu_online(smp_processor_id()))
-		raise_softirq(RCU_SOFTIRQ);
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		per_cpu(rcu_cpu_has_work, cpu) = 0;
+	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
+	return 0;
 }
+early_initcall(rcu_spawn_core_kthreads);
 
 /*
  * Handle any core-RCU processing required by a call_rcu() invocation.
@@ -3325,7 +3411,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index eb4fe67..da1439d 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -526,10 +526,9 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
-static void invoke_rcu_callbacks_kthread(void);
 static bool rcu_is_callbacks_kthread(void);
+static void rcu_cpu_kthread_setup(unsigned int cpu);
 #ifdef CONFIG_RCU_BOOST
-static void rcu_preempt_do_callbacks(void);
 static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c1735a1..34d2a06 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -24,12 +24,6 @@
  *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
-#include <linux/delay.h>
-#include <linux/gfp.h>
-#include <linux/oom.h>
-#include <linux/smpboot.h>
-#include "time/tick-internal.h"
-
 #define RCU_KTHREAD_PRIO 1
 
 #ifdef CONFIG_RCU_BOOST
@@ -656,15 +650,6 @@ static void rcu_preempt_check_callbacks(int cpu)
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
 }
 
-#ifdef CONFIG_RCU_BOOST
-
-static void rcu_preempt_do_callbacks(void)
-{
-	rcu_do_batch(&rcu_preempt_state, &__get_cpu_var(rcu_preempt_data));
-}
-
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 /*
  * Queue a preemptible-RCU callback for invocation after a grace period.
  */
@@ -1126,6 +1111,19 @@ void exit_rcu(void)
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
+/*
+ * If boosting, set rcuc kthreads to realtime priority.
+ */
+static void rcu_cpu_kthread_setup(unsigned int cpu)
+{
+#ifdef CONFIG_RCU_BOOST
+	struct sched_param sp;
+
+	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
+#endif /* #ifdef CONFIG_RCU_BOOST */
+}
+
 #ifdef CONFIG_RCU_BOOST
 
 #include "rtmutex_common.h"
@@ -1157,16 +1155,6 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 
 #endif /* #else #ifdef CONFIG_RCU_TRACE */
 
-static void rcu_wake_cond(struct task_struct *t, int status)
-{
-	/*
-	 * If the thread is yielding, only wake it when this
-	 * is invoked from idle
-	 */
-	if (status != RCU_KTHREAD_YIELDING || is_idle_task(current))
-		wake_up_process(t);
-}
-
 /*
  * Carry out RCU priority boosting on the task indicated by ->exp_tasks
  * or ->boost_tasks, advancing the pointer to the next task in the
@@ -1310,23 +1298,6 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 }
 
 /*
- * Wake up the per-CPU kthread to invoke RCU callbacks.
- */
-static void invoke_rcu_callbacks_kthread(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__this_cpu_write(rcu_cpu_has_work, 1);
-	if (__this_cpu_read(rcu_cpu_kthread_task) != NULL &&
-	    current != __this_cpu_read(rcu_cpu_kthread_task)) {
-		rcu_wake_cond(__this_cpu_read(rcu_cpu_kthread_task),
-			      __this_cpu_read(rcu_cpu_kthread_status));
-	}
-	local_irq_restore(flags);
-}
-
-/*
  * Is the current CPU running the RCU-callbacks kthread?
  * Caller must have preemption disabled.
  */
@@ -1380,67 +1351,6 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	return 0;
 }
 
-static void rcu_kthread_do_work(void)
-{
-	rcu_do_batch(&rcu_sched_state, &__get_cpu_var(rcu_sched_data));
-	rcu_do_batch(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
-	rcu_preempt_do_callbacks();
-}
-
-static void rcu_cpu_kthread_setup(unsigned int cpu)
-{
-	struct sched_param sp;
-
-	sp.sched_priority = RCU_KTHREAD_PRIO;
-	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
-}
-
-static void rcu_cpu_kthread_park(unsigned int cpu)
-{
-	per_cpu(rcu_cpu_kthread_status, cpu) = RCU_KTHREAD_OFFCPU;
-}
-
-static int rcu_cpu_kthread_should_run(unsigned int cpu)
-{
-	return __get_cpu_var(rcu_cpu_has_work);
-}
-
-/*
- * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
- * RCU softirq used in flavors and configurations of RCU that do not
- * support RCU priority boosting.
- */
-static void rcu_cpu_kthread(unsigned int cpu)
-{
-	unsigned int *statusp = &__get_cpu_var(rcu_cpu_kthread_status);
-	char work, *workp = &__get_cpu_var(rcu_cpu_has_work);
-	int spincnt;
-
-	for (spincnt = 0; spincnt < 10; spincnt++) {
-		trace_rcu_utilization(TPS("Start CPU kthread@rcu_wait"));
-		local_bh_disable();
-		*statusp = RCU_KTHREAD_RUNNING;
-		this_cpu_inc(rcu_cpu_kthread_loops);
-		local_irq_disable();
-		work = *workp;
-		*workp = 0;
-		local_irq_enable();
-		if (work)
-			rcu_kthread_do_work();
-		local_bh_enable();
-		if (*workp == 0) {
-			trace_rcu_utilization(TPS("End CPU kthread@rcu_wait"));
-			*statusp = RCU_KTHREAD_WAITING;
-			return;
-		}
-	}
-	*statusp = RCU_KTHREAD_YIELDING;
-	trace_rcu_utilization(TPS("Start CPU kthread@rcu_yield"));
-	schedule_timeout_interruptible(2);
-	trace_rcu_utilization(TPS("End CPU kthread@rcu_yield"));
-	*statusp = RCU_KTHREAD_WAITING;
-}
-
 /*
  * Set the per-rcu_node kthread's affinity to cover all CPUs that are
  * served by the rcu_node in question.  The CPU hotplug lock is still
@@ -1474,27 +1384,14 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 	free_cpumask_var(cm);
 }
 
-static struct smp_hotplug_thread rcu_cpu_thread_spec = {
-	.store			= &rcu_cpu_kthread_task,
-	.thread_should_run	= rcu_cpu_kthread_should_run,
-	.thread_fn		= rcu_cpu_kthread,
-	.thread_comm		= "rcuc/%u",
-	.setup			= rcu_cpu_kthread_setup,
-	.park			= rcu_cpu_kthread_park,
-};
-
 /*
  * Spawn all kthreads -- called as soon as the scheduler is running.
  */
 static int __init rcu_spawn_kthreads(void)
 {
 	struct rcu_node *rnp;
-	int cpu;
 
 	rcu_scheduler_fully_active = 1;
-	for_each_possible_cpu(cpu)
-		per_cpu(rcu_cpu_has_work, cpu) = 0;
-	BUG_ON(smpboot_register_percpu_thread(&rcu_cpu_thread_spec));
 	rnp = rcu_get_root(rcu_state);
 	(void)rcu_spawn_one_boost_kthread(rcu_state, rnp);
 	if (NUM_RCU_NODES > 1) {
@@ -1522,11 +1419,6 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
-static void invoke_rcu_callbacks_kthread(void)
-{
-	WARN_ON_ONCE(1);
-}
-
 static bool rcu_is_callbacks_kthread(void)
 {
 	return false;
diff --git a/kernel/rt.c b/kernel/rt.c
index 29771e2..5d17727 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -197,8 +197,6 @@ int __lockfunc rt_write_trylock_irqsave(rwlock_t *rwlock, unsigned long *flags)
 
 	*flags = 0;
 	ret = rt_write_trylock(rwlock);
-	if (ret)
-		migrate_disable();
 	return ret;
 }
 EXPORT_SYMBOL(rt_write_trylock_irqsave);
@@ -213,19 +211,18 @@ int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 	 * but not when read_depth == 0 which means that the lock is
 	 * write locked.
 	 */
-	migrate_disable();
 	if (rt_mutex_owner(lock) != current) {
 		ret = rt_mutex_trylock(lock);
-		if (ret)
+		if (ret) {
 			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
+			migrate_disable();
+		}
 	} else if (!rwlock->read_depth) {
 		ret = 0;
 	}
 
 	if (ret)
 		rwlock->read_depth++;
-	else
-		migrate_enable();
 
 	return ret;
 }
@@ -234,6 +231,7 @@ EXPORT_SYMBOL(rt_read_trylock);
 void __lockfunc rt_write_lock(rwlock_t *rwlock)
 {
 	rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
+	migrate_disable();
 	__rt_spin_lock(&rwlock->lock);
 }
 EXPORT_SYMBOL(rt_write_lock);
@@ -248,6 +246,7 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 	if (rt_mutex_owner(lock) != current) {
 		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
 		__rt_spin_lock(lock);
+		migrate_disable();
 	}
 	rwlock->read_depth++;
 }
@@ -259,6 +258,7 @@ void __lockfunc rt_write_unlock(rwlock_t *rwlock)
 	/* NOTE: we always pass in '1' for nested, for simplicity */
 	rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
 	__rt_spin_unlock(&rwlock->lock);
+	migrate_enable();
 }
 EXPORT_SYMBOL(rt_write_unlock);
 
@@ -268,6 +268,7 @@ void __lockfunc rt_read_unlock(rwlock_t *rwlock)
 	if (--rwlock->read_depth == 0) {
 		rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
 		__rt_spin_unlock(&rwlock->lock);
+		migrate_enable();
 	}
 }
 EXPORT_SYMBOL(rt_read_unlock);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 2da729b..15ad603 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -505,12 +505,12 @@ void __init softirq_early_init(void)
 
 static void lock_softirq(int which)
 {
-	__local_lock(&__get_cpu_var(local_softirq_locks[which]));
+	local_lock(local_softirq_locks[which]);
 }
 
 static void unlock_softirq(int which)
 {
-	__local_unlock(&__get_cpu_var(local_softirq_locks[which]));
+	local_unlock(local_softirq_locks[which]);
 }
 
 static void do_single_softirq(int which, int need_rcu_bh_qs)
diff --git a/kernel/timer.c b/kernel/timer.c
index 106968f..426d114 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1461,18 +1461,20 @@ void run_local_timers(void)
 	 * the timer softirq.
 	 */
 #ifdef CONFIG_PREEMPT_RT_FULL
+	/* On RT, irq work runs from softirq */
+	if (irq_work_needs_cpu()) {
+		raise_softirq(TIMER_SOFTIRQ);
+		return;
+	}
+
 	if (!spin_do_trylock(&base->lock)) {
 		raise_softirq(TIMER_SOFTIRQ);
 		return;
 	}
 #endif
-	if (!base->active_timers) {
-#ifdef CONFIG_PREEMPT_RT_FULL
-		/* On RT, irq work runs from softirq */
-		if (!irq_work_needs_cpu())
-#endif
-			goto out;
-	}
+
+	if (!base->active_timers)
+		goto out;
 
 	/* Check whether the next pending timer has expired */
 	if (time_before_eq(base->next_timer, jiffies))
diff --git a/localversion-rt b/localversion-rt
index 6e44e54..9f7d0bd 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt12
+-rt13
