Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaG1W5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:57:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33175 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaG1W42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:56:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Date: Mon, 28 Jul 2014 15:56:12 -0700
Message-Id: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140728225556.GA19493@linux.vnet.ibm.com>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072822-6688-0000-0000-0000039D704E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a new RCU-tasks flavor of RCU, which provides
call_rcu_tasks().  This RCU flavor's quiescent states are voluntary
context switch (not preemption!), userspace execution, and the idle loop.
Note that unlike other RCU flavors, these quiescent states occur in tasks,
not necessarily CPUs.  Includes fixes from Steven Rostedt.

This RCU flavor is assumed to have very infrequent latency-tolerate
updaters.  This assumption permits significant simplifications, including
a single global callback list protected by a single global lock, along
with a single linked list containing all tasks that have not yet passed
through a quiescent state.  If experience shows this assumption to be
incorrect, the required additional complexity will be added.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/init_task.h |   9 +++
 include/linux/rcupdate.h  |  36 +++++++++++
 include/linux/sched.h     |   8 +++
 init/Kconfig              |  10 +++
 kernel/rcu/tiny.c         |   2 +
 kernel/rcu/tree.c         |   2 +
 kernel/rcu/update.c       | 158 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c       |   2 +
 8 files changed, 227 insertions(+)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6df7f9fe0d01..78715ea7c30c 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -124,6 +124,14 @@ extern struct group_info init_groups;
 #else
 #define INIT_TASK_RCU_PREEMPT(tsk)
 #endif
+#ifdef CONFIG_TASKS_RCU
+#define INIT_TASK_RCU_TASKS(tsk)					\
+	.rcu_tasks_holdout = false,					\
+	.rcu_tasks_holdout_list =					\
+		LIST_HEAD_INIT(tsk.rcu_tasks_holdout_list),
+#else
+#define INIT_TASK_RCU_TASKS(tsk)
+#endif
 
 extern struct cred init_cred;
 
@@ -231,6 +239,7 @@ extern struct task_group root_task_group;
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
 	INIT_TASK_RCU_PREEMPT(tsk)					\
+	INIT_TASK_RCU_TASKS(tsk)					\
 	INIT_CPUSET_SEQ(tsk)						\
 	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6a94cc8b1ca0..05656b504295 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -197,6 +197,26 @@ void call_rcu_sched(struct rcu_head *head,
 
 void synchronize_sched(void);
 
+/**
+ * call_rcu_tasks() - Queue an RCU for invocation task-based grace period
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual callback function to be invoked after the grace period
+ *
+ * The callback function will be invoked some time after a full grace
+ * period elapses, in other words after all currently executing RCU
+ * read-side critical sections have completed. call_rcu_tasks() assumes
+ * that the read-side critical sections end at a voluntary context
+ * switch (not a preemption!), entry into idle, or transition to usermode
+ * execution.  As such, there are no read-side primitives analogous to
+ * rcu_read_lock() and rcu_read_unlock() because this primitive is intended
+ * to determine that all tasks have passed through a safe state, not so
+ * much for data-strcuture synchronization.
+ *
+ * See the description of call_rcu() for more detailed information on
+ * memory ordering guarantees.
+ */
+void call_rcu_tasks(struct rcu_head *head, void (*func)(struct rcu_head *head));
+
 #ifdef CONFIG_PREEMPT_RCU
 
 void __rcu_read_lock(void);
@@ -294,6 +314,22 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 		rcu_irq_exit(); \
 	} while (0)
 
+/*
+ * Note a voluntary context switch for RCU-tasks benefit.  This is a
+ * macro rather than an inline function to avoid #include hell.
+ */
+#ifdef CONFIG_TASKS_RCU
+#define rcu_note_voluntary_context_switch(t) \
+	do { \
+		preempt_disable(); /* Exclude synchronize_sched(); */ \
+		if ((t)->rcu_tasks_holdout) \
+			smp_store_release(&(t)->rcu_tasks_holdout, 0); \
+		preempt_enable(); \
+	} while (0)
+#else /* #ifdef CONFIG_TASKS_RCU */
+#define rcu_note_voluntary_context_switch(t)	do { } while (0)
+#endif /* #else #ifdef CONFIG_TASKS_RCU */
+
 #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
 bool __rcu_is_watching(void);
 #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0c987a..3e18b7bbe4df 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1273,6 +1273,10 @@ struct task_struct {
 #ifdef CONFIG_RCU_BOOST
 	struct rt_mutex *rcu_boost_mutex;
 #endif /* #ifdef CONFIG_RCU_BOOST */
+#ifdef CONFIG_TASKS_RCU
+	int rcu_tasks_holdout;
+	struct list_head rcu_tasks_holdout_list;
+#endif /* #ifdef CONFIG_TASKS_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -2013,6 +2017,10 @@ static inline void rcu_copy_process(struct task_struct *p)
 	p->rcu_boost_mutex = NULL;
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	INIT_LIST_HEAD(&p->rcu_node_entry);
+#ifdef CONFIG_TASKS_RCU
+	p->rcu_tasks_holdout = false;
+	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
+#endif /* #ifdef CONFIG_TASKS_RCU */
 }
 
 #else
diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99af1b9..c56cb62a2df1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -507,6 +507,16 @@ config PREEMPT_RCU
 	  This option enables preemptible-RCU code that is common between
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
+config TASKS_RCU
+	bool "Task_based RCU implementation using voluntary context switch"
+	default n
+	help
+	  This option enables a task-based RCU implementation that uses
+	  only voluntary context switch (not preemption!), idle, and
+	  user-mode execution as quiescent states.
+
+	  If unsure, say N.
+
 config RCU_STALL_COMMON
 	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
 	help
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index d9efcc13008c..717f00854fc0 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -254,6 +254,8 @@ void rcu_check_callbacks(int cpu, int user)
 		rcu_sched_qs(cpu);
 	else if (!in_softirq())
 		rcu_bh_qs(cpu);
+	if (user)
+		rcu_note_voluntary_context_switch(current);
 }
 
 /*
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 625d0b0cd75a..f958c52f644d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2413,6 +2413,8 @@ void rcu_check_callbacks(int cpu, int user)
 	rcu_preempt_check_callbacks(cpu);
 	if (rcu_pending(cpu))
 		invoke_rcu_core();
+	if (user)
+		rcu_note_voluntary_context_switch(current);
 	trace_rcu_utilization(TPS("End scheduler-tick"));
 }
 
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index bc7883570530..2bcb1e611460 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -47,6 +47,7 @@
 #include <linux/hardirq.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/kthread.h>
 
 #define CREATE_TRACE_POINTS
 
@@ -350,3 +351,160 @@ static int __init check_cpu_stall_init(void)
 early_initcall(check_cpu_stall_init);
 
 #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
+
+#ifdef CONFIG_TASKS_RCU
+
+/*
+ * Simple variant of RCU whose quiescent states are voluntary context switch,
+ * user-space execution, and idle.  As such, grace periods can take one good
+ * long time.  There are no read-side primitives similar to rcu_read_lock()
+ * and rcu_read_unlock() because this implementation is intended to get
+ * the system into a safe state for some of the manipulations involved in
+ * tracing and the like.  Finally, this implementation does not support
+ * high call_rcu_tasks() rates from multiple CPUs.  If this is required,
+ * per-CPU callback lists will be needed.
+ */
+
+/* Lists of tasks that we are still waiting for during this grace period. */
+static LIST_HEAD(rcu_tasks_holdouts);
+
+/* Global list of callbacks and associated lock. */
+static struct rcu_head *rcu_tasks_cbs_head;
+static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
+static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
+
+/* Post an RCU-tasks callback. */
+void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
+{
+	unsigned long flags;
+
+	rhp->next = NULL;
+	rhp->func = func;
+	raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
+	*rcu_tasks_cbs_tail = rhp;
+	rcu_tasks_cbs_tail = &rhp->next;
+	raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
+}
+EXPORT_SYMBOL_GPL(call_rcu_tasks);
+
+/* RCU-tasks kthread that detects grace periods and invokes callbacks. */
+static int __noreturn rcu_tasks_kthread(void *arg)
+{
+	unsigned long flags;
+	struct task_struct *g, *t;
+	struct rcu_head *list;
+	struct rcu_head *next;
+
+	/* FIXME: Add housekeeping affinity. */
+
+	/*
+	 * Each pass through the following loop makes one check for
+	 * newly arrived callbacks, and, if there are some, waits for
+	 * one RCU-tasks grace period and then invokes the callbacks.
+	 * This loop is terminated by the system going down.  ;-)
+	 */
+	for (;;) {
+
+		/* Pick up any new callbacks. */
+		raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
+		smp_mb__after_unlock_lock(); /* Enforce GP memory ordering. */
+		list = rcu_tasks_cbs_head;
+		rcu_tasks_cbs_head = NULL;
+		rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
+		raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
+
+		/* If there were none, wait a bit and start over. */
+		if (!list) {
+			schedule_timeout_interruptible(HZ);
+			flush_signals(current);
+			continue;
+		}
+
+		/*
+		 * There were callbacks, so we need to wait for an
+		 * RCU-tasks grace period.  Start off by scanning
+		 * the task list for tasks that are not already
+		 * voluntarily blocked.  Mark these tasks and make
+		 * a list of them in rcu_tasks_holdouts.
+		 */
+		rcu_read_lock();
+		do_each_thread(g, t) {
+			if (t != current && ACCESS_ONCE(t->on_rq) &&
+			    !is_idle_task(t)) {
+				t->rcu_tasks_holdout = 1;
+				list_add(&t->rcu_tasks_holdout_list,
+					 &rcu_tasks_holdouts);
+			}
+		} while_each_thread(g, t);
+		rcu_read_unlock();
+
+		/*
+		 * The "t != current" and "!is_idle_task()" comparisons
+		 * above are stable, but the "t->on_rq" value could
+		 * change at any time, and is generally unordered.
+		 * Therefore, we need some ordering.  The trick is
+		 * that t->on_rq is updated with a runqueue lock held,
+		 * and thus with interrupts disabled.  So the following
+		 * synchronize_sched() provides the needed ordering by:
+		 * (1) Waiting for all interrupts-disabled code sections
+		 * to complete and (2) The synchronize_sched() ordering
+		 * guarantees, which provide for a memory barrier on each
+		 * CPU since the completion of its last read-side critical
+		 * section, including interrupt-disabled code sections.
+		 */
+		synchronize_sched();
+
+		/*
+		 * Each pass through the following loop scans the list
+		 * of holdout tasks, removing any that are no longer
+		 * holdouts.  When the list is empty, we are done.
+		 */
+		while (!list_empty(&rcu_tasks_holdouts)) {
+			schedule_timeout_interruptible(HZ / 10);
+			flush_signals(current);
+			rcu_read_lock();
+			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
+						rcu_tasks_holdout_list) {
+				if (smp_load_acquire(&t->rcu_tasks_holdout))
+					continue;
+				list_del_init(&t->rcu_tasks_holdout_list);
+				/* @@@ need to check for usermode on CPU. */
+			}
+			rcu_read_unlock();
+		}
+
+		/*
+		 * Most implementations of RCU would need to force a
+		 * memory barrier on all non-idle non-userspace CPUs at
+		 * this point.  The reason that this implementation does
+		 * not is that all of the callbacks are invoked by this
+		 * kthread.  Therefore, the quiescent states on the other
+		 * CPUs need only be ordered against this one kthread,
+		 * and the smp_store_release() and smp_load_acquire()
+		 * on ->rcu_tasks_holdout suffices for this ordering.
+		 */
+
+		/* Invoke the callbacks. */
+		while (list) {
+			next = list->next;
+			local_bh_disable();
+			list->func(list);
+			local_bh_enable();
+			list = next;
+			cond_resched();
+		}
+	}
+}
+
+/* Spawn rcu_tasks_kthread() at boot time. */
+static int __init rcu_spawn_tasks_kthread(void)
+{
+	struct task_struct __maybe_unused *t;
+
+	t = kthread_run(rcu_tasks_kthread, NULL, "rcu_tasks_kthread");
+	BUG_ON(IS_ERR(t));
+	return 0;
+}
+early_initcall(rcu_spawn_tasks_kthread);
+
+#endif /* #ifdef CONFIG_TASKS_RCU */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b33449..a0d2f3a03566 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2762,6 +2762,7 @@ need_resched:
 		} else {
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
+			rcu_note_voluntary_context_switch(prev);
 
 			/*
 			 * If a worker went to sleep, notify and ask workqueue
@@ -2828,6 +2829,7 @@ asmlinkage __visible void __sched schedule(void)
 	struct task_struct *tsk = current;
 
 	sched_submit_work(tsk);
+	rcu_note_voluntary_context_switch(tsk);
 	__schedule();
 }
 EXPORT_SYMBOL(schedule);
-- 
1.8.1.5

