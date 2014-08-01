Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaHABOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:14:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4166 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752580AbaHABOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:14:20 -0400
X-IronPort-AV: E=Sophos;i="5.04,240,1406563200"; 
   d="scan'208";a="34042782"
Message-ID: <53DAEA36.7010905@cn.fujitsu.com>
Date: Fri, 1 Aug 2014 09:15:34 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <dipankar@in.ibm.com>,
        <akpm@linux-foundation.org>, <mathieu.desnoyers@efficios.com>,
        <josh@joshtriplett.org>, <tglx@linutronix.de>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <dhowells@redhat.com>, <edumazet@google.com>,
        <dvhart@linux.intel.com>, <fweisbec@gmail.com>, <oleg@redhat.com>,
        <bobby.prani@gmail.com>
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
References: <20140731215445.GA21933@linux.vnet.ibm.com> <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 05:55 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit adds a new RCU-tasks flavor of RCU, which provides
> call_rcu_tasks().  This RCU flavor's quiescent states are voluntary
> context switch (not preemption!), userspace execution, and the idle loop.
> Note that unlike other RCU flavors, these quiescent states occur in tasks,
> not necessarily CPUs.  Includes fixes from Steven Rostedt.
> 
> This RCU flavor is assumed to have very infrequent latency-tolerate
> updaters.  This assumption permits significant simplifications, including
> a single global callback list protected by a single global lock, along
> with a single linked list containing all tasks that have not yet passed
> through a quiescent state.  If experience shows this assumption to be
> incorrect, the required additional complexity will be added.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  include/linux/init_task.h |   9 +++
>  include/linux/rcupdate.h  |  36 ++++++++++
>  include/linux/sched.h     |  23 ++++---
>  init/Kconfig              |  10 +++
>  kernel/rcu/tiny.c         |   2 +
>  kernel/rcu/tree.c         |   2 +
>  kernel/rcu/update.c       | 171 ++++++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 242 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 6df7f9fe0d01..78715ea7c30c 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -124,6 +124,14 @@ extern struct group_info init_groups;
>  #else
>  #define INIT_TASK_RCU_PREEMPT(tsk)
>  #endif
> +#ifdef CONFIG_TASKS_RCU
> +#define INIT_TASK_RCU_TASKS(tsk)					\
> +	.rcu_tasks_holdout = false,					\
> +	.rcu_tasks_holdout_list =					\
> +		LIST_HEAD_INIT(tsk.rcu_tasks_holdout_list),
> +#else
> +#define INIT_TASK_RCU_TASKS(tsk)
> +#endif
>  
>  extern struct cred init_cred;
>  
> @@ -231,6 +239,7 @@ extern struct task_group root_task_group;
>  	INIT_FTRACE_GRAPH						\
>  	INIT_TRACE_RECURSION						\
>  	INIT_TASK_RCU_PREEMPT(tsk)					\
> +	INIT_TASK_RCU_TASKS(tsk)					\
>  	INIT_CPUSET_SEQ(tsk)						\
>  	INIT_RT_MUTEXES(tsk)						\
>  	INIT_VTIME(tsk)							\
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 6a94cc8b1ca0..829efc99df3e 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -197,6 +197,26 @@ void call_rcu_sched(struct rcu_head *head,
>  
>  void synchronize_sched(void);
>  
> +/**
> + * call_rcu_tasks() - Queue an RCU for invocation task-based grace period
> + * @head: structure to be used for queueing the RCU updates.
> + * @func: actual callback function to be invoked after the grace period
> + *
> + * The callback function will be invoked some time after a full grace
> + * period elapses, in other words after all currently executing RCU
> + * read-side critical sections have completed. call_rcu_tasks() assumes
> + * that the read-side critical sections end at a voluntary context
> + * switch (not a preemption!), entry into idle, or transition to usermode
> + * execution.  As such, there are no read-side primitives analogous to
> + * rcu_read_lock() and rcu_read_unlock() because this primitive is intended
> + * to determine that all tasks have passed through a safe state, not so
> + * much for data-strcuture synchronization.
> + *
> + * See the description of call_rcu() for more detailed information on
> + * memory ordering guarantees.
> + */
> +void call_rcu_tasks(struct rcu_head *head, void (*func)(struct rcu_head *head));
> +
>  #ifdef CONFIG_PREEMPT_RCU
>  
>  void __rcu_read_lock(void);
> @@ -294,6 +314,22 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
>  		rcu_irq_exit(); \
>  	} while (0)
>  
> +/*
> + * Note a voluntary context switch for RCU-tasks benefit.  This is a
> + * macro rather than an inline function to avoid #include hell.
> + */
> +#ifdef CONFIG_TASKS_RCU
> +#define rcu_note_voluntary_context_switch(t) \
> +	do { \
> +		preempt_disable(); /* Exclude synchronize_sched(); */ \
> +		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
> +			ACCESS_ONCE((t)->rcu_tasks_holdout) = 0; \
> +		preempt_enable(); \
> +	} while (0)
> +#else /* #ifdef CONFIG_TASKS_RCU */
> +#define rcu_note_voluntary_context_switch(t)	do { } while (0)
> +#endif /* #else #ifdef CONFIG_TASKS_RCU */
> +
>  #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
>  bool __rcu_is_watching(void);
>  #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 306f4f0c987a..3cf124389ec7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1273,6 +1273,11 @@ struct task_struct {
>  #ifdef CONFIG_RCU_BOOST
>  	struct rt_mutex *rcu_boost_mutex;
>  #endif /* #ifdef CONFIG_RCU_BOOST */
> +#ifdef CONFIG_TASKS_RCU
> +	unsigned long rcu_tasks_nvcsw;
> +	int rcu_tasks_holdout;
> +	struct list_head rcu_tasks_holdout_list;
> +#endif /* #ifdef CONFIG_TASKS_RCU */
>  
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  	struct sched_info sched_info;
> @@ -1998,31 +2003,27 @@ extern void task_clear_jobctl_pending(struct task_struct *task,
>  				      unsigned int mask);
>  
>  #ifdef CONFIG_PREEMPT_RCU
> -
>  #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
>  #define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
> +#endif /* #ifdef CONFIG_PREEMPT_RCU */
>  
>  static inline void rcu_copy_process(struct task_struct *p)
>  {
> +#ifdef CONFIG_PREEMPT_RCU
>  	p->rcu_read_lock_nesting = 0;
>  	p->rcu_read_unlock_special = 0;
> -#ifdef CONFIG_TREE_PREEMPT_RCU
>  	p->rcu_blocked_node = NULL;
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
>  #ifdef CONFIG_RCU_BOOST
>  	p->rcu_boost_mutex = NULL;
>  #endif /* #ifdef CONFIG_RCU_BOOST */
>  	INIT_LIST_HEAD(&p->rcu_node_entry);
> +#endif /* #ifdef CONFIG_PREEMPT_RCU */
> +#ifdef CONFIG_TASKS_RCU
> +	p->rcu_tasks_holdout = false;
> +	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
> +#endif /* #ifdef CONFIG_TASKS_RCU */
>  }
>  
> -#else
> -
> -static inline void rcu_copy_process(struct task_struct *p)
> -{
> -}
> -
> -#endif
> -
>  static inline void tsk_restore_flags(struct task_struct *task,
>  				unsigned long orig_flags, unsigned long flags)
>  {
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d76b99af1b9..c56cb62a2df1 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -507,6 +507,16 @@ config PREEMPT_RCU
>  	  This option enables preemptible-RCU code that is common between
>  	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
>  
> +config TASKS_RCU
> +	bool "Task_based RCU implementation using voluntary context switch"
> +	default n
> +	help
> +	  This option enables a task-based RCU implementation that uses
> +	  only voluntary context switch (not preemption!), idle, and
> +	  user-mode execution as quiescent states.
> +
> +	  If unsure, say N.
> +
>  config RCU_STALL_COMMON
>  	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
>  	help
> diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
> index d9efcc13008c..717f00854fc0 100644
> --- a/kernel/rcu/tiny.c
> +++ b/kernel/rcu/tiny.c
> @@ -254,6 +254,8 @@ void rcu_check_callbacks(int cpu, int user)
>  		rcu_sched_qs(cpu);
>  	else if (!in_softirq())
>  		rcu_bh_qs(cpu);
> +	if (user)
> +		rcu_note_voluntary_context_switch(current);
>  }
>  
>  /*
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 625d0b0cd75a..f958c52f644d 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -2413,6 +2413,8 @@ void rcu_check_callbacks(int cpu, int user)
>  	rcu_preempt_check_callbacks(cpu);
>  	if (rcu_pending(cpu))
>  		invoke_rcu_core();
> +	if (user)
> +		rcu_note_voluntary_context_switch(current);
>  	trace_rcu_utilization(TPS("End scheduler-tick"));
>  }
>  
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index bc7883570530..50453589e3ca 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -47,6 +47,7 @@
>  #include <linux/hardirq.h>
>  #include <linux/delay.h>
>  #include <linux/module.h>
> +#include <linux/kthread.h>
>  
>  #define CREATE_TRACE_POINTS
>  
> @@ -350,3 +351,173 @@ static int __init check_cpu_stall_init(void)
>  early_initcall(check_cpu_stall_init);
>  
>  #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
> +
> +#ifdef CONFIG_TASKS_RCU
> +
> +/*
> + * Simple variant of RCU whose quiescent states are voluntary context switch,
> + * user-space execution, and idle.  As such, grace periods can take one good
> + * long time.  There are no read-side primitives similar to rcu_read_lock()
> + * and rcu_read_unlock() because this implementation is intended to get
> + * the system into a safe state for some of the manipulations involved in
> + * tracing and the like.  Finally, this implementation does not support
> + * high call_rcu_tasks() rates from multiple CPUs.  If this is required,
> + * per-CPU callback lists will be needed.
> + */
> +
> +/* Lists of tasks that we are still waiting for during this grace period. */
> +static LIST_HEAD(rcu_tasks_holdouts);
> +
> +/* Global list of callbacks and associated lock. */
> +static struct rcu_head *rcu_tasks_cbs_head;
> +static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
> +static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
> +
> +/* Post an RCU-tasks callback. */
> +void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
> +{
> +	unsigned long flags;
> +
> +	rhp->next = NULL;
> +	rhp->func = func;
> +	raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
> +	*rcu_tasks_cbs_tail = rhp;
> +	rcu_tasks_cbs_tail = &rhp->next;
> +	raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(call_rcu_tasks);
> +
> +/* RCU-tasks kthread that detects grace periods and invokes callbacks. */
> +static int __noreturn rcu_tasks_kthread(void *arg)
> +{
> +	unsigned long flags;
> +	struct task_struct *g, *t;
> +	struct rcu_head *list;
> +	struct rcu_head *next;
> +
> +	/* FIXME: Add housekeeping affinity. */
> +
> +	/*
> +	 * Each pass through the following loop makes one check for
> +	 * newly arrived callbacks, and, if there are some, waits for
> +	 * one RCU-tasks grace period and then invokes the callbacks.
> +	 * This loop is terminated by the system going down.  ;-)
> +	 */
> +	for (;;) {
> +
> +		/* Pick up any new callbacks. */
> +		raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
> +		smp_mb__after_unlock_lock(); /* Enforce GP memory ordering. */
> +		list = rcu_tasks_cbs_head;
> +		rcu_tasks_cbs_head = NULL;
> +		rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
> +		raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> +
> +		/* If there were none, wait a bit and start over. */
> +		if (!list) {
> +			schedule_timeout_interruptible(HZ);
> +			flush_signals(current);
> +			continue;
> +		}
> +
> +		/*
> +		 * Wait for all pre-existing t->on_rq and t->nvcsw
> +		 * transitions to complete.  Invoking synchronize_sched()
> +		 * suffices because all these transitions occur with
> +		 * interrupts disabled.  Without this synchronize_sched(),
> +		 * a read-side critical section that started before the
> +		 * grace period might be incorrectly seen as having started
> +		 * after the grace period.
> +		 *
> +		 * This synchronize_sched() also dispenses with the
> +		 * need for a memory barrier on the first store to
> +		 * ->rcu_tasks_holdout, as it forces the store to happen
> +		 * after the beginning of the grace period.
> +		 */
> +		synchronize_sched();
> +
> +		/*
> +		 * There were callbacks, so we need to wait for an
> +		 * RCU-tasks grace period.  Start off by scanning
> +		 * the task list for tasks that are not already
> +		 * voluntarily blocked.  Mark these tasks and make
> +		 * a list of them in rcu_tasks_holdouts.
> +		 */
> +		rcu_read_lock();
> +		for_each_process_thread(g, t) {
> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> +			    !is_idle_task(t)) {
> +				get_task_struct(t);
> +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> +				ACCESS_ONCE(t->rcu_tasks_holdout) = 1;
> +				list_add(&t->rcu_tasks_holdout_list,
> +					 &rcu_tasks_holdouts);
> +			}
> +		}
> +		rcu_read_unlock();
> +
> +		/*
> +		 * Each pass through the following loop scans the list
> +		 * of holdout tasks, removing any that are no longer
> +		 * holdouts.  When the list is empty, we are done.
> +		 */
> +		while (!list_empty(&rcu_tasks_holdouts)) {
> +			schedule_timeout_interruptible(HZ / 10);
> +			flush_signals(current);
> +			rcu_read_lock();
> +			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
> +						rcu_tasks_holdout_list) {
> +				if (ACCESS_ONCE(t->rcu_tasks_holdout)) {
> +					if (t->rcu_tasks_nvcsw ==
> +					    ACCESS_ONCE(t->nvcsw) &&
> +					    ACCESS_ONCE(t->on_rq))
> +						continue;
> +					ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
> +				}
> +				list_del_rcu(&t->rcu_tasks_holdout_list);
> +				put_task_struct(t);
> +			}
> +			rcu_read_unlock();

rcu_read_lock() and list opertions of rcu variant are unneeded.

> +		}
> +
> +		/*
> +		 * Because ->on_rq and ->nvcsw are not guaranteed
> +		 * to have a full memory barriers prior to them in the
> +		 * schedule() path, memory reordering on other CPUs could
> +		 * cause their RCU-tasks read-side critical sections to
> +		 * extend past the end of the grace period.  However,
> +		 * because these ->nvcsw updates are carried out with
> +		 * interrupts disabled, we can use synchronize_sched()
> +		 * to force the needed ordering on all such CPUs.
> +		 *
> +		 * This synchronize_sched() also confines all
> +		 * ->rcu_tasks_holdout accesses to be within the grace
> +		 * period, avoiding the need for memory barriers for
> +		 * ->rcu_tasks_holdout accesses.
> +		 */
> +		synchronize_sched();
> +
> +		/* Invoke the callbacks. */
> +		while (list) {
> +			next = list->next;
> +			local_bh_disable();
> +			list->func(list);
> +			local_bh_enable();
> +			list = next;
> +			cond_resched();
> +		}
> +	}
> +}
> +
> +/* Spawn rcu_tasks_kthread() at boot time. */
> +static int __init rcu_spawn_tasks_kthread(void)
> +{
> +	struct task_struct __maybe_unused *t;
> +
> +	t = kthread_run(rcu_tasks_kthread, NULL, "rcu_tasks_kthread");
> +	BUG_ON(IS_ERR(t));
> +	return 0;
> +}
> +early_initcall(rcu_spawn_tasks_kthread);
> +
> +#endif /* #ifdef CONFIG_TASKS_RCU */

