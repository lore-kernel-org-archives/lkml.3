Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaHABaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:30:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:27717 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120AbaHABaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:30:24 -0400
X-IronPort-AV: E=Sophos;i="5.04,240,1406563200"; 
   d="scan'208";a="34043307"
Message-ID: <53DAEDF9.2030503@cn.fujitsu.com>
Date: Fri, 1 Aug 2014 09:31:37 +0800
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

Why the preempt_disable() is needed here? The comments in rcu_tasks_kthread()
can't persuade me.  Maybe it could be removed?
