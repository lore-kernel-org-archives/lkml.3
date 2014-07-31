Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaGaQJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:09:33 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60415 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGaQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:09:29 -0400
Date: Thu, 31 Jul 2014 09:09:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
Message-ID: <20140731160924.GR11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53D9F084.7000706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D9F084.7000706@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073116-9332-0000-0000-0000018EA543
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 03:30:12PM +0800, Lai Jiangshan wrote:
> On 07/31/2014 08:39 AM, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit adds a new RCU-tasks flavor of RCU, which provides
> > call_rcu_tasks().  This RCU flavor's quiescent states are voluntary
> > context switch (not preemption!), userspace execution, and the idle loop.
> > Note that unlike other RCU flavors, these quiescent states occur in tasks,
> > not necessarily CPUs.  Includes fixes from Steven Rostedt.
> > 
> > This RCU flavor is assumed to have very infrequent latency-tolerate
> > updaters.  This assumption permits significant simplifications, including
> > a single global callback list protected by a single global lock, along
> > with a single linked list containing all tasks that have not yet passed
> > through a quiescent state.  If experience shows this assumption to be
> > incorrect, the required additional complexity will be added.
> > 
> > Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/linux/init_task.h |   9 +++
> >  include/linux/rcupdate.h  |  36 ++++++++++
> >  include/linux/sched.h     |  23 +++----
> >  init/Kconfig              |  10 +++
> >  kernel/rcu/tiny.c         |   2 +
> >  kernel/rcu/tree.c         |   2 +
> >  kernel/rcu/update.c       | 164 ++++++++++++++++++++++++++++++++++++++++++++++
> >  7 files changed, 235 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> > index 6df7f9fe0d01..78715ea7c30c 100644
> > --- a/include/linux/init_task.h
> > +++ b/include/linux/init_task.h
> > @@ -124,6 +124,14 @@ extern struct group_info init_groups;
> >  #else
> >  #define INIT_TASK_RCU_PREEMPT(tsk)
> >  #endif
> > +#ifdef CONFIG_TASKS_RCU
> > +#define INIT_TASK_RCU_TASKS(tsk)					\
> > +	.rcu_tasks_holdout = false,					\
> > +	.rcu_tasks_holdout_list =					\
> > +		LIST_HEAD_INIT(tsk.rcu_tasks_holdout_list),
> > +#else
> > +#define INIT_TASK_RCU_TASKS(tsk)
> > +#endif
> >  
> >  extern struct cred init_cred;
> >  
> > @@ -231,6 +239,7 @@ extern struct task_group root_task_group;
> >  	INIT_FTRACE_GRAPH						\
> >  	INIT_TRACE_RECURSION						\
> >  	INIT_TASK_RCU_PREEMPT(tsk)					\
> > +	INIT_TASK_RCU_TASKS(tsk)					\
> >  	INIT_CPUSET_SEQ(tsk)						\
> >  	INIT_RT_MUTEXES(tsk)						\
> >  	INIT_VTIME(tsk)							\
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 6a94cc8b1ca0..05656b504295 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -197,6 +197,26 @@ void call_rcu_sched(struct rcu_head *head,
> >  
> >  void synchronize_sched(void);
> >  
> > +/**
> > + * call_rcu_tasks() - Queue an RCU for invocation task-based grace period
> > + * @head: structure to be used for queueing the RCU updates.
> > + * @func: actual callback function to be invoked after the grace period
> > + *
> > + * The callback function will be invoked some time after a full grace
> > + * period elapses, in other words after all currently executing RCU
> > + * read-side critical sections have completed. call_rcu_tasks() assumes
> > + * that the read-side critical sections end at a voluntary context
> > + * switch (not a preemption!), entry into idle, or transition to usermode
> > + * execution.  As such, there are no read-side primitives analogous to
> > + * rcu_read_lock() and rcu_read_unlock() because this primitive is intended
> > + * to determine that all tasks have passed through a safe state, not so
> > + * much for data-strcuture synchronization.
> > + *
> > + * See the description of call_rcu() for more detailed information on
> > + * memory ordering guarantees.
> > + */
> > +void call_rcu_tasks(struct rcu_head *head, void (*func)(struct rcu_head *head));
> > +
> >  #ifdef CONFIG_PREEMPT_RCU
> >  
> >  void __rcu_read_lock(void);
> > @@ -294,6 +314,22 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
> >  		rcu_irq_exit(); \
> >  	} while (0)
> >  
> > +/*
> > + * Note a voluntary context switch for RCU-tasks benefit.  This is a
> > + * macro rather than an inline function to avoid #include hell.
> > + */
> > +#ifdef CONFIG_TASKS_RCU
> > +#define rcu_note_voluntary_context_switch(t) \
> > +	do { \
> > +		preempt_disable(); /* Exclude synchronize_sched(); */ \
> > +		if ((t)->rcu_tasks_holdout) \
> > +			smp_store_release(&(t)->rcu_tasks_holdout, 0); \
> > +		preempt_enable(); \
> > +	} while (0)
> > +#else /* #ifdef CONFIG_TASKS_RCU */
> > +#define rcu_note_voluntary_context_switch(t)	do { } while (0)
> > +#endif /* #else #ifdef CONFIG_TASKS_RCU */
> > +
> >  #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP)
> >  bool __rcu_is_watching(void);
> >  #endif /* #if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) || defined(CONFIG_SMP) */
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 306f4f0c987a..3cf124389ec7 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1273,6 +1273,11 @@ struct task_struct {
> >  #ifdef CONFIG_RCU_BOOST
> >  	struct rt_mutex *rcu_boost_mutex;
> >  #endif /* #ifdef CONFIG_RCU_BOOST */
> > +#ifdef CONFIG_TASKS_RCU
> > +	unsigned long rcu_tasks_nvcsw;
> > +	int rcu_tasks_holdout;
> > +	struct list_head rcu_tasks_holdout_list;
> > +#endif /* #ifdef CONFIG_TASKS_RCU */
> >  
> >  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
> >  	struct sched_info sched_info;
> > @@ -1998,31 +2003,27 @@ extern void task_clear_jobctl_pending(struct task_struct *task,
> >  				      unsigned int mask);
> >  
> >  #ifdef CONFIG_PREEMPT_RCU
> > -
> >  #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
> >  #define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
> > +#endif /* #ifdef CONFIG_PREEMPT_RCU */
> >  
> >  static inline void rcu_copy_process(struct task_struct *p)
> >  {
> > +#ifdef CONFIG_PREEMPT_RCU
> >  	p->rcu_read_lock_nesting = 0;
> >  	p->rcu_read_unlock_special = 0;
> > -#ifdef CONFIG_TREE_PREEMPT_RCU
> >  	p->rcu_blocked_node = NULL;
> > -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> >  #ifdef CONFIG_RCU_BOOST
> >  	p->rcu_boost_mutex = NULL;
> >  #endif /* #ifdef CONFIG_RCU_BOOST */
> >  	INIT_LIST_HEAD(&p->rcu_node_entry);
> > +#endif /* #ifdef CONFIG_PREEMPT_RCU */
> > +#ifdef CONFIG_TASKS_RCU
> > +	p->rcu_tasks_holdout = false;
> > +	INIT_LIST_HEAD(&p->rcu_tasks_holdout_list);
> > +#endif /* #ifdef CONFIG_TASKS_RCU */
> >  }
> >  
> > -#else
> > -
> > -static inline void rcu_copy_process(struct task_struct *p)
> > -{
> > -}
> > -
> > -#endif
> > -
> >  static inline void tsk_restore_flags(struct task_struct *task,
> >  				unsigned long orig_flags, unsigned long flags)
> >  {
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 9d76b99af1b9..c56cb62a2df1 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -507,6 +507,16 @@ config PREEMPT_RCU
> >  	  This option enables preemptible-RCU code that is common between
> >  	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
> >  
> > +config TASKS_RCU
> > +	bool "Task_based RCU implementation using voluntary context switch"
> > +	default n
> > +	help
> > +	  This option enables a task-based RCU implementation that uses
> > +	  only voluntary context switch (not preemption!), idle, and
> > +	  user-mode execution as quiescent states.
> > +
> > +	  If unsure, say N.
> > +
> >  config RCU_STALL_COMMON
> >  	def_bool ( TREE_RCU || TREE_PREEMPT_RCU || RCU_TRACE )
> >  	help
> > diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
> > index d9efcc13008c..717f00854fc0 100644
> > --- a/kernel/rcu/tiny.c
> > +++ b/kernel/rcu/tiny.c
> > @@ -254,6 +254,8 @@ void rcu_check_callbacks(int cpu, int user)
> >  		rcu_sched_qs(cpu);
> >  	else if (!in_softirq())
> >  		rcu_bh_qs(cpu);
> > +	if (user)
> > +		rcu_note_voluntary_context_switch(current);
> >  }
> >  
> >  /*
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index 625d0b0cd75a..f958c52f644d 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -2413,6 +2413,8 @@ void rcu_check_callbacks(int cpu, int user)
> >  	rcu_preempt_check_callbacks(cpu);
> >  	if (rcu_pending(cpu))
> >  		invoke_rcu_core();
> > +	if (user)
> > +		rcu_note_voluntary_context_switch(current);
> >  	trace_rcu_utilization(TPS("End scheduler-tick"));
> >  }
> >  
> > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > index bc7883570530..b92268647a01 100644
> > --- a/kernel/rcu/update.c
> > +++ b/kernel/rcu/update.c
> > @@ -47,6 +47,7 @@
> >  #include <linux/hardirq.h>
> >  #include <linux/delay.h>
> >  #include <linux/module.h>
> > +#include <linux/kthread.h>
> >  
> >  #define CREATE_TRACE_POINTS
> >  
> > @@ -350,3 +351,166 @@ static int __init check_cpu_stall_init(void)
> >  early_initcall(check_cpu_stall_init);
> >  
> >  #endif /* #ifdef CONFIG_RCU_STALL_COMMON */
> > +
> > +#ifdef CONFIG_TASKS_RCU
> > +
> > +/*
> > + * Simple variant of RCU whose quiescent states are voluntary context switch,
> > + * user-space execution, and idle.  As such, grace periods can take one good
> > + * long time.  There are no read-side primitives similar to rcu_read_lock()
> > + * and rcu_read_unlock() because this implementation is intended to get
> > + * the system into a safe state for some of the manipulations involved in
> > + * tracing and the like.  Finally, this implementation does not support
> > + * high call_rcu_tasks() rates from multiple CPUs.  If this is required,
> > + * per-CPU callback lists will be needed.
> > + */
> > +
> > +/* Lists of tasks that we are still waiting for during this grace period. */
> > +static LIST_HEAD(rcu_tasks_holdouts);
> > +
> > +/* Global list of callbacks and associated lock. */
> > +static struct rcu_head *rcu_tasks_cbs_head;
> > +static struct rcu_head **rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
> > +static DEFINE_RAW_SPINLOCK(rcu_tasks_cbs_lock);
> > +
> > +/* Post an RCU-tasks callback. */
> > +void call_rcu_tasks(struct rcu_head *rhp, void (*func)(struct rcu_head *rhp))
> > +{
> > +	unsigned long flags;
> > +
> > +	rhp->next = NULL;
> > +	rhp->func = func;
> > +	raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
> > +	*rcu_tasks_cbs_tail = rhp;
> > +	rcu_tasks_cbs_tail = &rhp->next;
> > +	raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> > +}
> > +EXPORT_SYMBOL_GPL(call_rcu_tasks);
> > +
> > +/* RCU-tasks kthread that detects grace periods and invokes callbacks. */
> > +static int __noreturn rcu_tasks_kthread(void *arg)
> > +{
> > +	unsigned long flags;
> > +	struct task_struct *g, *t;
> > +	struct rcu_head *list;
> > +	struct rcu_head *next;
> > +
> > +	/* FIXME: Add housekeeping affinity. */
> > +
> > +	/*
> > +	 * Each pass through the following loop makes one check for
> > +	 * newly arrived callbacks, and, if there are some, waits for
> > +	 * one RCU-tasks grace period and then invokes the callbacks.
> > +	 * This loop is terminated by the system going down.  ;-)
> > +	 */
> > +	for (;;) {
> > +
> > +		/* Pick up any new callbacks. */
> > +		raw_spin_lock_irqsave(&rcu_tasks_cbs_lock, flags);
> > +		smp_mb__after_unlock_lock(); /* Enforce GP memory ordering. */
> > +		list = rcu_tasks_cbs_head;
> > +		rcu_tasks_cbs_head = NULL;
> > +		rcu_tasks_cbs_tail = &rcu_tasks_cbs_head;
> > +		raw_spin_unlock_irqrestore(&rcu_tasks_cbs_lock, flags);
> > +
> > +		/* If there were none, wait a bit and start over. */
> > +		if (!list) {
> > +			schedule_timeout_interruptible(HZ);
> > +			flush_signals(current);
> > +			continue;
> > +		}
> > +
> 
> A "synchronize_sched();" may be needed here, or else the following code may
> read t->on_rq == 0 but actually the task is just running and traced with trampoline.

Good point!  This is fixed by later patches in the series, but it would
be good to have it set up initially.

> > +		/*
> > +		 * There were callbacks, so we need to wait for an
> > +		 * RCU-tasks grace period.  Start off by scanning
> > +		 * the task list for tasks that are not already
> > +		 * voluntarily blocked.  Mark these tasks and make
> > +		 * a list of them in rcu_tasks_holdouts.
> > +		 */
> > +		rcu_read_lock();
> > +		for_each_process_thread(g, t) {
> > +			if (t != current && ACCESS_ONCE(t->on_rq) &&
> > +			    !is_idle_task(t)) {
> 
> What happen when the trampoline is on the idle task?
> 
> I think we need to use schedule_on_each_cpu() to replace one of
> the synchronize_sched() in this function. (or other stuff which can
> cause real schedule for *ALL* online CPUs).

Well, that is one of the questions in the 0/10 cover letter.  If it turns
out to be necessary to worry about idle-task trampolines, it should be
possible to avoid hammering all idle CPUs in the common case.  Though maybe
battery-powered devices won't need RCU-tasks.

> > +				t->rcu_tasks_nvcsw = ACCESS_ONCE(t->nvcsw);
> > +				t->rcu_tasks_holdout = 1;
> > +				list_add(&t->rcu_tasks_holdout_list,
> > +					 &rcu_tasks_holdouts);
> 
> I think get_task_struct() is needed here to avoid the task disappears.

Hmmm...  Let's see...

Looks like get_task_struct() does a blind atomic increment of ->usage.
And put_task_struct() does an atomic_dec_and_test().  So one question
is "what prevents us from doing get_task_struct() after the final
put_task_struct() has pushed ->usage down to zero?"

Hopefully there is a grace period in there somewhere, otherwise it will
be necessary to take the task-list lock, which I would like to avoid.

Looks like the call_rcu() of delayed_put_task_struct() in release_task()
might be doing this.  And release_task() invokes __exit_signals() before
that call_rcu(), and __exit_signals() does an __unhash_process(), which
looks to remove the task from all the RCU-protected lists.  In the case
of for_each_process_thread(), the ->tasks and ->thread_node lists are
relevant, and __unhash_process() does RCU-safe removal from both lists.

This means that when for_each_process_thread() finds a given task under
RCU protection, we can indeed expect get_task_struct() to hold on to the
task structure.  The corresponding put_task_struct() gets called as soon
as we remove the task from the list.  No tricky exit-side synchronization
is then required.

That does indeed look way simpler, thank you!

> > +			}
> > +		}
> > +		rcu_read_unlock();
> > +
> > +		/*
> > +		 * The "t != current" and "!is_idle_task()" comparisons
> > +		 * above are stable, but the "t->on_rq" value could
> > +		 * change at any time, and is generally unordered.
> > +		 * Therefore, we need some ordering.  The trick is
> > +		 * that t->on_rq is updated with a runqueue lock held,
> > +		 * and thus with interrupts disabled.  So the following
> > +		 * synchronize_sched() provides the needed ordering by:
> > +		 * (1) Waiting for all interrupts-disabled code sections
> > +		 * to complete and (2) The synchronize_sched() ordering
> > +		 * guarantees, which provide for a memory barrier on each
> > +		 * CPU since the completion of its last read-side critical
> > +		 * section, including interrupt-disabled code sections.
> > +		 */
> > +		synchronize_sched();
> > +
> > +		/*
> > +		 * Each pass through the following loop scans the list
> > +		 * of holdout tasks, removing any that are no longer
> > +		 * holdouts.  When the list is empty, we are done.
> > +		 */
> > +		while (!list_empty(&rcu_tasks_holdouts)) {
> > +			schedule_timeout_interruptible(HZ / 10);
> > +			flush_signals(current);
> > +			rcu_read_lock();
> > +			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
> > +						rcu_tasks_holdout_list) {
> > +				if (smp_load_acquire(&t->rcu_tasks_holdout)) {
> > +					if (t->rcu_tasks_nvcsw ==
> > +					    ACCESS_ONCE(t->nvcsw))
> > +						continue;
> > +					ACCESS_ONCE(t->rcu_tasks_holdout) = 0;
> > +				}
> 
> t->on_rq can be rechecked here.

Yep, I would need to pull some of the logic from 10/10 to this point
in 1/1.

> I think the recheck for t->on_rq and get_task_struct()/put_task_struct() can
> handle the exiting of the tasks, thus we don't need the complex of the patch 10/10.
> 
> Quick and superficial thought,

Seems likely, will give it a try.

							Thanx, Paul

> Thanks,
> Lai
> 
> > +				list_del_init(&t->rcu_tasks_holdout_list);
> > +				/* @@@ need to check for usermode on CPU. */
> > +			}
> > +			rcu_read_unlock();
> > +		}
> > +
> > +		/*
> > +		 * Because ->nvcsw is not guaranteed to have a full
> > +		 * memory barrier prior to it in the schedule() path,
> > +		 * memory reordering on other CPUs could cause their
> > +		 * RCU-tasks read-side critical sections to extend past
> > +		 * the end of the grace period.  However, because these
> > +		 * ->nvcsw updates are carried out with interrupts
> > +		 * disabled, we can use synchronize_sched() to force
> > +		 * the needed ordering on all such CPUs.
> > +		 */
> > +		synchronize_sched();
> > +
> > +		/* Invoke the callbacks. */
> > +		while (list) {
> > +			next = list->next;
> > +			local_bh_disable();
> > +			list->func(list);
> > +			local_bh_enable();
> > +			list = next;
> > +			cond_resched();
> > +		}
> > +	}
> > +}
> > +
> > +/* Spawn rcu_tasks_kthread() at boot time. */
> > +static int __init rcu_spawn_tasks_kthread(void)
> > +{
> > +	struct task_struct __maybe_unused *t;
> > +
> > +	t = kthread_run(rcu_tasks_kthread, NULL, "rcu_tasks_kthread");
> > +	BUG_ON(IS_ERR(t));
> > +	return 0;
> > +}
> > +early_initcall(rcu_spawn_tasks_kthread);
> > +
> > +#endif /* #ifdef CONFIG_TASKS_RCU */
> 

