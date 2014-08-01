Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaHACL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:11:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55693 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaHACLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:11:25 -0400
Date: Thu, 31 Jul 2014 19:11:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140801021118.GK11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DAEDF9.2030503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DAEDF9.2030503@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080102-3532-0000-0000-00000388974F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 09:31:37AM +0800, Lai Jiangshan wrote:
> On 08/01/2014 05:55 AM, Paul E. McKenney wrote:
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
> >  include/linux/sched.h     |  23 ++++---
> >  init/Kconfig              |  10 +++
> >  kernel/rcu/tiny.c         |   2 +
> >  kernel/rcu/tree.c         |   2 +
> >  kernel/rcu/update.c       | 171 ++++++++++++++++++++++++++++++++++++++++++++++
> >  7 files changed, 242 insertions(+), 11 deletions(-)
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
> > index 6a94cc8b1ca0..829efc99df3e 100644
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
> > +		if (ACCESS_ONCE((t)->rcu_tasks_holdout)) \
> > +			ACCESS_ONCE((t)->rcu_tasks_holdout) = 0; \
> > +		preempt_enable(); \
> 
> Why the preempt_disable() is needed here? The comments in rcu_tasks_kthread()
> can't persuade me.  Maybe it could be removed?

The synchronize_sched() near the end of the main loop in rcu_tasks_thread()
might well have obsoleted this, will take a closer look.

							Thanx, Paul

