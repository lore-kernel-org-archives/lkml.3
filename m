Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaCGR5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:57:53 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:58374 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752981AbaCGR5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:57:50 -0500
Date: Fri, 7 Mar 2014 12:57:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.8.13.14-rt28
Message-ID: <20140307125747.786e1784@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.8.13.14-rt28 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.8-rt
  Head SHA1: 4e356430b57e27543c552b19adf7cb0ce37197d3


Or to build 3.8.13.14-rt28 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/stable/patch-3.8.13.14.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.14-rt28.patch.xz



You can also build from 3.8.13.14-rt27 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13.14-rt27-rt28.patch.xz



Enjoy,

-- Steve


Changes from v3.8.13.14-rt27:

---

Nicholas Mc Guire (1):
      net: ip_send_unicast_reply: add missing local serialization

Paul E. McKenney (1):
      rcu: Eliminate softirq processing from rcutree

Sebastian Andrzej Siewior (3):
      Revert "x86: Disable IST stacks for debug/int 3/stack fault for PREEMPT_RT"
      kernel/hrtimer: be non-freezeable in cpu_chill()
      arm/unwind: use a raw_spin_lock

Steven Rostedt (1):
      rt: Make cpu_chill() use hrtimer instead of msleep()

Steven Rostedt (Red Hat) (1):
      Linux 3.8.13.14-rt28

Tiejun Chen (1):
      rcutree/rcu_bh_qs: disable irq while calling rcu_preempt_qs()

----
 arch/arm/kernel/unwind.c             |  14 ++--
 arch/x86/include/asm/page_64_types.h |  21 ++----
 arch/x86/kernel/cpu/common.c         |   2 -
 arch/x86/kernel/dumpstack_64.c       |   4 --
 include/linux/delay.h                |   2 +-
 kernel/hrtimer.c                     |  19 +++++
 kernel/rcutree.c                     | 119 +++++++++++++++++++++++++++----
 kernel/rcutree.h                     |   3 +-
 kernel/rcutree_plugin.h              | 133 ++++-------------------------------
 localversion-rt                      |   2 +-
 net/ipv4/ip_output.c                 |   9 ++-
 11 files changed, 159 insertions(+), 169 deletions(-)
---------------------------
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..bbafc67 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -87,7 +87,7 @@ extern const struct unwind_idx __start_unwind_idx[];
 static const struct unwind_idx *__origin_unwind_idx;
 extern const struct unwind_idx __stop_unwind_idx[];
 
-static DEFINE_SPINLOCK(unwind_lock);
+static DEFINE_RAW_SPINLOCK(unwind_lock);
 static LIST_HEAD(unwind_tables);
 
 /* Convert a prel31 symbol to an absolute address */
@@ -195,7 +195,7 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 		/* module unwind tables */
 		struct unwind_table *table;
 
-		spin_lock_irqsave(&unwind_lock, flags);
+		raw_spin_lock_irqsave(&unwind_lock, flags);
 		list_for_each_entry(table, &unwind_tables, list) {
 			if (addr >= table->begin_addr &&
 			    addr < table->end_addr) {
@@ -207,7 +207,7 @@ static const struct unwind_idx *unwind_find_idx(unsigned long addr)
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&unwind_lock, flags);
+		raw_spin_unlock_irqrestore(&unwind_lock, flags);
 	}
 
 	pr_debug("%s: idx = %p\n", __func__, idx);
@@ -469,9 +469,9 @@ struct unwind_table *unwind_table_add(unsigned long start, unsigned long size,
 	tab->begin_addr = text_addr;
 	tab->end_addr = text_addr + text_size;
 
-	spin_lock_irqsave(&unwind_lock, flags);
+	raw_spin_lock_irqsave(&unwind_lock, flags);
 	list_add_tail(&tab->list, &unwind_tables);
-	spin_unlock_irqrestore(&unwind_lock, flags);
+	raw_spin_unlock_irqrestore(&unwind_lock, flags);
 
 	return tab;
 }
@@ -483,9 +483,9 @@ void unwind_table_del(struct unwind_table *tab)
 	if (!tab)
 		return;
 
-	spin_lock_irqsave(&unwind_lock, flags);
+	raw_spin_lock_irqsave(&unwind_lock, flags);
 	list_del(&tab->list);
-	spin_unlock_irqrestore(&unwind_lock, flags);
+	raw_spin_unlock_irqrestore(&unwind_lock, flags);
 
 	kfree(tab);
 }
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 65b85f4..320f7bb 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -14,21 +14,12 @@
 #define IRQ_STACK_ORDER 2
 #define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
 
-#ifdef CONFIG_PREEMPT_RT_FULL
-# define STACKFAULT_STACK 0
-# define DOUBLEFAULT_STACK 1
-# define NMI_STACK 2
-# define DEBUG_STACK 0
-# define MCE_STACK 3
-# define N_EXCEPTION_STACKS 3  /* hw limit: 7 */
-#else
-# define STACKFAULT_STACK 1
-# define DOUBLEFAULT_STACK 2
-# define NMI_STACK 3
-# define DEBUG_STACK 4
-# define MCE_STACK 5
-# define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
-#endif
+#define STACKFAULT_STACK 1
+#define DOUBLEFAULT_STACK 2
+#define NMI_STACK 3
+#define DEBUG_STACK 4
+#define MCE_STACK 5
+#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2636e0f..9c3ab43 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1103,9 +1103,7 @@ DEFINE_PER_CPU(struct task_struct *, fpu_owner_task);
  */
 static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
 	  [0 ... N_EXCEPTION_STACKS - 1]	= EXCEPTION_STKSZ,
-#if DEBUG_STACK > 0
 	  [DEBUG_STACK - 1]			= DEBUG_STKSZ
-#endif
 };
 
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index f16c07b..b653675 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -21,14 +21,10 @@
 		(N_EXCEPTION_STACKS + DEBUG_STKSZ/EXCEPTION_STKSZ - 2)
 
 static char x86_stack_ids[][8] = {
-#if DEBUG_STACK > 0
 		[ DEBUG_STACK-1			]	= "#DB",
-#endif
 		[ NMI_STACK-1			]	= "NMI",
 		[ DOUBLEFAULT_STACK-1		]	= "#DF",
-#if STACKFAULT_STACK > 0
 		[ STACKFAULT_STACK-1		]	= "#SS",
-#endif
 		[ MCE_STACK-1			]	= "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
 		[ N_EXCEPTION_STACKS ...
diff --git a/include/linux/delay.h b/include/linux/delay.h
index e23a7c0..37caab3 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -53,7 +53,7 @@ static inline void ssleep(unsigned int seconds)
 }
 
 #ifdef CONFIG_PREEMPT_RT_FULL
-# define cpu_chill()	msleep(1)
+extern void cpu_chill(void);
 #else
 # define cpu_chill()	cpu_relax()
 #endif
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index aa5eb4f..2e66fbb 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1852,6 +1852,25 @@ SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 	return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+/*
+ * Sleep for 1 ms in hope whoever holds what we want will let it go.
+ */
+void cpu_chill(void)
+{
+	struct timespec tu = {
+		.tv_nsec = NSEC_PER_MSEC,
+	};
+	unsigned int freeze_flag = current->flags & PF_NOFREEZE;
+
+	current->flags |= PF_NOFREEZE;
+	hrtimer_nanosleep(&tu, NULL, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
+	if (!freeze_flag)
+		current->flags &= ~PF_NOFREEZE;
+}
+EXPORT_SYMBOL(cpu_chill);
+#endif
+
 /*
  * Functions related to boot-time initialization:
  */
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7ec834d..6a34f87 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,6 +53,11 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/delay.h>
+#include <linux/gfp.h>
+#include <linux/oom.h>
+#include <linux/smpboot.h>
+#include "time/tick-internal.h"
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -127,8 +132,6 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
  */
 static int rcu_scheduler_fully_active __read_mostly;
 
-#ifdef CONFIG_RCU_BOOST
-
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
  * handle all flavors of RCU.
@@ -138,8 +141,6 @@ DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 
-#endif /* #ifdef CONFIG_RCU_BOOST */
-
 static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu);
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
@@ -186,7 +187,12 @@ static void rcu_preempt_qs(int cpu);
 
 void rcu_bh_qs(int cpu)
 {
+	unsigned long flags;
+
+	/* Callers to this function, rcu_preempt_qs(), must disable irqs. */
+	local_irq_save(flags);
 	rcu_preempt_qs(cpu);
+	local_irq_restore(flags);
 }
 #else
 void rcu_bh_qs(int cpu)
@@ -2043,16 +2049,14 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 /*
  * Do RCU core processing for the current CPU.
  */
-static void rcu_process_callbacks(struct softirq_action *unused)
+static void rcu_process_callbacks(void)
 {
 	struct rcu_state *rsp;
 
 	if (cpu_is_offline(smp_processor_id()))
 		return;
-	trace_rcu_utilization("Start RCU core");
 	for_each_rcu_flavor(rsp)
 		__rcu_process_callbacks(rsp);
-	trace_rcu_utilization("End RCU core");
 }
 
 /*
@@ -2066,17 +2070,105 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	if (unlikely(!ACCESS_ONCE(rcu_scheduler_fully_active)))
 		return;
-	if (likely(!rsp->boost)) {
-		rcu_do_batch(rsp, rdp);
-		return;
-	}
-	invoke_rcu_callbacks_kthread();
+	rcu_do_batch(rsp, rdp);
 }
 
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
 static void invoke_rcu_core(void)
 {
-	raise_softirq(RCU_SOFTIRQ);
+	unsigned long flags;
+	struct task_struct *t;
+
+	if (!cpu_online(smp_processor_id()))
+		return;
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
+		trace_rcu_utilization("Start CPU kthread@rcu_wait");
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
+			trace_rcu_utilization("End CPU kthread@rcu_wait");
+			*statusp = RCU_KTHREAD_WAITING;
+			return;
+		}
+	}
+	*statusp = RCU_KTHREAD_YIELDING;
+	trace_rcu_utilization("Start CPU kthread@rcu_yield");
+	schedule_timeout_interruptible(2);
+	trace_rcu_utilization("End CPU kthread@rcu_yield");
+	*statusp = RCU_KTHREAD_WAITING;
+}
+
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
+{
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
@@ -3082,7 +3174,6 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
 	rcu_init_nocb();
-	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5cfdff9..d67eaed 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -519,10 +519,9 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
 static void __init __rcu_init_preempt(void);
 static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
 static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
-static void invoke_rcu_callbacks_kthread(void);
 static bool rcu_is_callbacks_kthread(void);
+static void rcu_cpu_kthread_setup(unsigned int cpu);
 #ifdef CONFIG_RCU_BOOST
-static void rcu_preempt_do_callbacks(void);
 static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 778f138..a24ee9f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -24,11 +24,6 @@
  *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
  */
 
-#include <linux/delay.h>
-#include <linux/gfp.h>
-#include <linux/oom.h>
-#include <linux/smpboot.h>
-
 #define RCU_KTHREAD_PRIO 1
 
 #ifdef CONFIG_RCU_BOOST
@@ -648,15 +643,6 @@ static void rcu_preempt_check_callbacks(int cpu)
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
@@ -1092,6 +1078,19 @@ static void __init __rcu_init_preempt(void)
 
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
@@ -1123,16 +1122,6 @@ static void rcu_initiate_boost_trace(struct rcu_node *rnp)
 
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
@@ -1276,23 +1265,6 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
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
@@ -1346,67 +1318,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
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
-		trace_rcu_utilization("Start CPU kthread@rcu_wait");
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
-			trace_rcu_utilization("End CPU kthread@rcu_wait");
-			*statusp = RCU_KTHREAD_WAITING;
-			return;
-		}
-	}
-	*statusp = RCU_KTHREAD_YIELDING;
-	trace_rcu_utilization("Start CPU kthread@rcu_yield");
-	schedule_timeout_interruptible(2);
-	trace_rcu_utilization("End CPU kthread@rcu_yield");
-	*statusp = RCU_KTHREAD_WAITING;
-}
-
 /*
  * Set the per-rcu_node kthread's affinity to cover all CPUs that are
  * served by the rcu_node in question.  The CPU hotplug lock is still
@@ -1440,27 +1351,14 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
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
@@ -1488,11 +1386,6 @@ static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags)
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
diff --git a/localversion-rt b/localversion-rt
index be1e37b..5a64c9c 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt27
+-rt28
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 90af992..6e75fb1 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -79,6 +79,7 @@
 #include <linux/mroute.h>
 #include <linux/netlink.h>
 #include <linux/tcp.h>
+#include <linux/locallock.h>
 
 int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
 EXPORT_SYMBOL(sysctl_ip_default_ttl);
@@ -1471,6 +1472,9 @@ static DEFINE_PER_CPU(struct inet_sock, unicast_sock) = {
 	.uc_ttl		= -1,
 };
 
+/* serialize concurrent calls on the same CPU to ip_send_unicast_reply */
+static DEFINE_LOCAL_IRQ_LOCK(unicast_lock);
+
 void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 			   __be32 saddr, const struct ip_reply_arg *arg,
 			   unsigned int len)
@@ -1508,8 +1512,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 	if (IS_ERR(rt))
 		return;
 
-	get_cpu_light();
-	inet = &__get_cpu_var(unicast_sock);
+	inet = &get_locked_var(unicast_lock, unicast_sock);
 
 	inet->tos = arg->tos;
 	sk = &inet->sk;
@@ -1533,7 +1536,7 @@ void ip_send_unicast_reply(struct net *net, struct sk_buff *skb, __be32 daddr,
 		ip_push_pending_frames(sk, &fl4);
 	}
 
-	put_cpu_light();
+	put_locked_var(unicast_lock, unicast_sock);
 
 	ip_rt_put(rt);
 }
