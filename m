Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3KMCb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:31:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64683 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755254Ab3KMCbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:31:48 -0500
Date: Tue, 12 Nov 2013 21:31:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures &
 implementation.
Message-ID: <20131112213142.0e311bac@gandalf.local.home>
In-Reply-To: <1383831828-15501-4-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-4-git-send-email-juri.lelli@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Nov 2013 14:43:37 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:

> From: Dario Faggioli <raistlin@linux.it>

> --- /dev/null
> +++ b/include/linux/sched/deadline.h
> @@ -0,0 +1,24 @@
> +#ifndef _SCHED_DEADLINE_H
> +#define _SCHED_DEADLINE_H
> +
> +/*
> + * SCHED_DEADLINE tasks has negative priorities, reflecting
> + * the fact that any of them has higher prio than RT and
> + * NORMAL/BATCH tasks.
> + */
> +
> +#define MAX_DL_PRIO		0
> +
> +static inline int dl_prio(int prio)
> +{
> +	if (unlikely(prio < MAX_DL_PRIO))
> +		return 1;
> +	return 0;
> +}
> +
> +static inline int dl_task(struct task_struct *p)
> +{
> +	return dl_prio(p->prio);
> +}
> +
> +#endif /* _SCHED_DEADLINE_H */
> diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
> index 440434d..a157797 100644
> --- a/include/linux/sched/rt.h
> +++ b/include/linux/sched/rt.h
> @@ -22,7 +22,7 @@
>  
>  static inline int rt_prio(int prio)
>  {
> -	if (unlikely(prio < MAX_RT_PRIO))
> +	if ((unsigned)prio < MAX_RT_PRIO)

Why remove the "unlikely" here?

>  		return 1;
>  	return 0;
>  }
> diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
> index 5a0f945..2d5e49a 100644
> --- a/include/uapi/linux/sched.h
> +++ b/include/uapi/linux/sched.h
> @@ -39,6 +39,7 @@
>  #define SCHED_BATCH		3
>  /* SCHED_ISO: reserved but not implemented yet */
>  #define SCHED_IDLE		5
> +#define SCHED_DEADLINE		6
>  /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
>  #define SCHED_RESET_ON_FORK     0x40000000
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 086fe73..55fc95f 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1313,7 +1313,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  #endif
>  
>  	/* Perform scheduler related setup. Assign this task to a CPU. */
> -	sched_fork(p);
> +	retval = sched_fork(p);
> +	if (retval)
> +		goto bad_fork_cleanup_policy;
>  
>  	retval = perf_event_init_task(p);
>  	if (retval)
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 383319b..0909436 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -46,6 +46,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/sysctl.h>
>  #include <linux/sched/rt.h>
> +#include <linux/sched/deadline.h>
>  #include <linux/timer.h>
>  #include <linux/freezer.h>
>  
> @@ -1610,7 +1611,7 @@ long hrtimer_nanosleep(struct timespec *rqtp, struct timespec __user *rmtp,
>  	unsigned long slack;
>  
>  	slack = current->timer_slack_ns;
> -	if (rt_task(current))
> +	if (dl_task(current) || rt_task(current))

Since dl_task() checks if prio is less than 0, and rt_task checks for
prio < MAX_RT_PRIO, I wonder if we can introduce a

	dl_or_rt_task(current)

that does a signed compare against MAX_RT_PRIO to eliminate the double
compare (in case gcc doesn't figure it out).

Not something that we need to change now, but something in the future
maybe.

>  		slack = 0;
>  
>  	hrtimer_init_on_stack(&t.timer, clockid, mode);
> diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
> index 54adcf3..d77282f 100644
> --- a/kernel/sched/Makefile
> +++ b/kernel/sched/Makefile
> @@ -11,7 +11,7 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
>  CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
>  endif
>  
> -obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o stop_task.o
> +obj-y += core.o proc.o clock.o cputime.o idle_task.o fair.o rt.o deadline.o stop_task.o
>  obj-$(CONFIG_SMP) += cpupri.o
>  obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
>  obj-$(CONFIG_SCHEDSTATS) += stats.o
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4fcbf13..cfe15bfc 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -903,7 +903,9 @@ static inline int normal_prio(struct task_struct *p)
>  {
>  	int prio;
>  
> -	if (task_has_rt_policy(p))
> +	if (task_has_dl_policy(p))
> +		prio = MAX_DL_PRIO-1;
> +	else if (task_has_rt_policy(p))
>  		prio = MAX_RT_PRIO-1 - p->rt_priority;
>  	else
>  		prio = __normal_prio(p);
> @@ -1611,6 +1613,12 @@ static void __sched_fork(struct task_struct *p)
>  	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
>  #endif
>  
> +	RB_CLEAR_NODE(&p->dl.rb_node);
> +	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	p->dl.dl_runtime = p->dl.runtime = 0;
> +	p->dl.dl_deadline = p->dl.deadline = 0;
> +	p->dl.flags = 0;
> +
>  	INIT_LIST_HEAD(&p->rt.run_list);
>  
>  #ifdef CONFIG_PREEMPT_NOTIFIERS
> @@ -1654,7 +1662,7 @@ void set_numabalancing_state(bool enabled)
>  /*
>   * fork()/clone()-time setup:
>   */
> -void sched_fork(struct task_struct *p)
> +int sched_fork(struct task_struct *p)
>  {
>  	unsigned long flags;
>  	int cpu = get_cpu();
> @@ -1676,7 +1684,7 @@ void sched_fork(struct task_struct *p)
>  	 * Revert to default priority/policy on fork if requested.
>  	 */
>  	if (unlikely(p->sched_reset_on_fork)) {
> -		if (task_has_rt_policy(p)) {
> +		if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
>  			p->policy = SCHED_NORMAL;
>  			p->static_prio = NICE_TO_PRIO(0);
>  			p->rt_priority = 0;
> @@ -1693,8 +1701,14 @@ void sched_fork(struct task_struct *p)
>  		p->sched_reset_on_fork = 0;
>  	}
>  
> -	if (!rt_prio(p->prio))
> +	if (dl_prio(p->prio)) {
> +		put_cpu();
> +		return -EAGAIN;

Deadline tasks are not allowed to fork? Well, without setting
reset_on_fork. Probably should add a comment here.

> +	} else if (rt_prio(p->prio)) {
> +		p->sched_class = &rt_sched_class;
> +	} else {
>  		p->sched_class = &fair_sched_class;
> +	}
>  
>  	if (p->sched_class->task_fork)
>  		p->sched_class->task_fork(p);
> @@ -1726,6 +1740,7 @@ void sched_fork(struct task_struct *p)
>  #endif
>  
>  	put_cpu();
> +	return 0;
>  }
>  
>  /*
> @@ -3029,7 +3044,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
>  	struct rq *rq;
>  	const struct sched_class *prev_class;
>  
> -	BUG_ON(prio < 0 || prio > MAX_PRIO);
> +	BUG_ON(prio > MAX_PRIO);

Should we have this be:

	BUG_ON(prio < -MAX_PRIO || prio > MAX_PRIO);
?

>  
>  	rq = __task_rq_lock(p);
>  
> @@ -3061,7 +3076,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
>  	if (running)
>  		p->sched_class->put_prev_task(rq, p);
>  
> -	if (rt_prio(prio))
> +	if (dl_prio(prio))
> +		p->sched_class = &dl_sched_class;
> +	else if (rt_prio(prio))
>  		p->sched_class = &rt_sched_class;
>  	else
>  		p->sched_class = &fair_sched_class;
> @@ -3095,9 +3112,9 @@ void set_user_nice(struct task_struct *p, long nice)
>  	 * The RT priorities are set via sched_setscheduler(), but we still
>  	 * allow the 'normal' nice value to be set - but as expected
>  	 * it wont have any effect on scheduling until the task is
> -	 * SCHED_FIFO/SCHED_RR:
> +	 * SCHED_DEADLINE, SCHED_FIFO or SCHED_RR:
>  	 */
> -	if (task_has_rt_policy(p)) {
> +	if (task_has_dl_policy(p) || task_has_rt_policy(p)) {
>  		p->static_prio = NICE_TO_PRIO(nice);
>  		goto out_unlock;
>  	}
> @@ -3261,7 +3278,9 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
>  	p->normal_prio = normal_prio(p);
>  	/* we are holding p->pi_lock already */
>  	p->prio = rt_mutex_getprio(p);
> -	if (rt_prio(p->prio))
> +	if (dl_prio(p->prio))
> +		p->sched_class = &dl_sched_class;
> +	else if (rt_prio(p->prio))
>  		p->sched_class = &rt_sched_class;
>  	else
>  		p->sched_class = &fair_sched_class;
> @@ -3269,6 +3288,50 @@ __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
>  }
>  
>  /*
> + * This function initializes the sched_dl_entity of a newly becoming
> + * SCHED_DEADLINE task.
> + *
> + * Only the static values are considered here, the actual runtime and the
> + * absolute deadline will be properly calculated when the task is enqueued
> + * for the first time with its new policy.
> + */
> +static void
> +__setparam_dl(struct task_struct *p, const struct sched_param2 *param2)
> +{
> +	struct sched_dl_entity *dl_se = &p->dl;
> +
> +	init_dl_task_timer(dl_se);
> +	dl_se->dl_runtime = param2->sched_runtime;
> +	dl_se->dl_deadline = param2->sched_deadline;
> +	dl_se->flags = param2->sched_flags;
> +	dl_se->dl_throttled = 0;
> +	dl_se->dl_new = 1;
> +}
> +
> +static void
> +__getparam_dl(struct task_struct *p, struct sched_param2 *param2)
> +{
> +	struct sched_dl_entity *dl_se = &p->dl;
> +
> +	param2->sched_priority = p->rt_priority;
> +	param2->sched_runtime = dl_se->dl_runtime;
> +	param2->sched_deadline = dl_se->dl_deadline;
> +	param2->sched_flags = dl_se->flags;
> +}
> +
> +/*
> + * This function validates the new parameters of a -deadline task.
> + * We ask for the deadline not being zero, and greater or equal
> + * than the runtime.
> + */
> +static bool
> +__checkparam_dl(const struct sched_param2 *prm)
> +{
> +	return prm && (&prm->sched_deadline) != 0 &&
> +	       (s64)(&prm->sched_deadline - &prm->sched_runtime) >= 0;
> +}
> +
> +/*
>   * check the target process has a UID that matches the current process's
>   */
>  static bool check_same_owner(struct task_struct *p)
> @@ -3305,7 +3368,8 @@ recheck:
>  		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
>  		policy &= ~SCHED_RESET_ON_FORK;
>  
> -		if (policy != SCHED_FIFO && policy != SCHED_RR &&
> +		if (policy != SCHED_DEADLINE &&
> +				policy != SCHED_FIFO && policy != SCHED_RR &&
>  				policy != SCHED_NORMAL && policy != SCHED_BATCH &&
>  				policy != SCHED_IDLE)
>  			return -EINVAL;
> @@ -3320,7 +3384,8 @@ recheck:
>  	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
>  	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
>  		return -EINVAL;
> -	if (rt_policy(policy) != (param->sched_priority != 0))
> +	if ((dl_policy(policy) && !__checkparam_dl(param)) ||
> +	    (rt_policy(policy) != (param->sched_priority != 0)))
>  		return -EINVAL;
>  
>  	/*
> @@ -3386,7 +3451,8 @@ recheck:
>  	 * If not changing anything there's no need to proceed further:
>  	 */
>  	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
> -			param->sched_priority == p->rt_priority))) {
> +			param->sched_priority == p->rt_priority) &&
> +			!dl_policy(policy))) {
>  		task_rq_unlock(rq, p, &flags);
>  		return 0;
>  	}
> @@ -3423,7 +3489,11 @@ recheck:
>  
>  	oldprio = p->prio;
>  	prev_class = p->sched_class;
> -	__setscheduler(rq, p, policy, param->sched_priority);
> +	if (dl_policy(policy)) {
> +		__setparam_dl(p, param);
> +		__setscheduler(rq, p, policy, param->sched_priority);
> +	} else
> +		__setscheduler(rq, p, policy, param->sched_priority);

Why the double "__setscheduler()" call? Why not just:

	if (dl_policy(policy))
		__setparam_dl(p, param);
	__setscheduler(rq, p, policy, param->sched_priority);

?

>  
>  	if (running)
>  		p->sched_class->set_curr_task(rq);
> @@ -3527,8 +3597,11 @@ do_sched_setscheduler2(pid_t pid, int policy,
>  	rcu_read_lock();
>  	retval = -ESRCH;
>  	p = find_process_by_pid(pid);
> -	if (p != NULL)
> +	if (p != NULL) {
> +		if (dl_policy(policy))
> +			lparam2.sched_priority = 0;
>  		retval = sched_setscheduler2(p, policy, &lparam2);
> +	}
>  	rcu_read_unlock();
>  
>  	return retval;
> @@ -3685,7 +3758,10 @@ SYSCALL_DEFINE2(sched_getparam2, pid_t, pid,
>  	if (retval)
>  		goto out_unlock;
>  
> -	lp.sched_priority = p->rt_priority;
> +	if (task_has_dl_policy(p))
> +		__getparam_dl(p, &lp);
> +	else
> +		lp.sched_priority = p->rt_priority;
>  	rcu_read_unlock();
>  
>  	retval = copy_to_user(param2, &lp,
> @@ -4120,6 +4196,7 @@ SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
>  	case SCHED_RR:
>  		ret = MAX_USER_RT_PRIO-1;
>  		break;
> +	case SCHED_DEADLINE:
>  	case SCHED_NORMAL:
>  	case SCHED_BATCH:
>  	case SCHED_IDLE:
> @@ -4146,6 +4223,7 @@ SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
>  	case SCHED_RR:
>  		ret = 1;
>  		break;
> +	case SCHED_DEADLINE:
>  	case SCHED_NORMAL:
>  	case SCHED_BATCH:
>  	case SCHED_IDLE:
> @@ -6563,6 +6641,7 @@ void __init sched_init(void)
>  		rq->calc_load_update = jiffies + LOAD_FREQ;
>  		init_cfs_rq(&rq->cfs);
>  		init_rt_rq(&rq->rt, rq);
> +		init_dl_rq(&rq->dl, rq);
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
>  		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
> @@ -6746,7 +6825,7 @@ void normalize_rt_tasks(void)
>  		p->se.statistics.block_start	= 0;
>  #endif
>  
> -		if (!rt_task(p)) {
> +		if (!dl_task(p) && !rt_task(p)) {

Again, a future enhancement is to combine these two.

>  			/*
>  			 * Renice negative nice level userspace
>  			 * tasks back to 0:
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> new file mode 100644
> index 0000000..cb93f2e
> --- /dev/null
> +++ b/kernel/sched/deadline.c
> @@ -0,0 +1,682 @@
> +/*
> + * Deadline Scheduling Class (SCHED_DEADLINE)
> + *
> + * Earliest Deadline First (EDF) + Constant Bandwidth Server (CBS).
> + *
> + * Tasks that periodically executes their instances for less than their
> + * runtime won't miss any of their deadlines.
> + * Tasks that are not periodic or sporadic or that tries to execute more
> + * than their reserved bandwidth will be slowed down (and may potentially
> + * miss some of their deadlines), and won't affect any other task.
> + *
> + * Copyright (C) 2012 Dario Faggioli <raistlin@linux.it>,
> + *                    Michael Trimarchi <michael@amarulasolutions.com>,
> + *                    Fabio Checconi <fchecconi@gmail.com>
> + */
> +#include "sched.h"
> +
> +static inline int dl_time_before(u64 a, u64 b)
> +{
> +	return (s64)(a - b) < 0;

I think I've seen this pattern enough that we probably should have a
helper function that does this. Off topic for this thread, but just
something for us to think about.

> +}
> +
> +static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se)
> +{
> +	return container_of(dl_se, struct task_struct, dl);
> +}
> +
> +static inline struct rq *rq_of_dl_rq(struct dl_rq *dl_rq)
> +{
> +	return container_of(dl_rq, struct rq, dl);
> +}
> +
> +static inline struct dl_rq *dl_rq_of_se(struct sched_dl_entity *dl_se)
> +{
> +	struct task_struct *p = dl_task_of(dl_se);
> +	struct rq *rq = task_rq(p);
> +
> +	return &rq->dl;
> +}
> +
> +static inline int on_dl_rq(struct sched_dl_entity *dl_se)
> +{
> +	return !RB_EMPTY_NODE(&dl_se->rb_node);
> +}
> +
> +static inline int is_leftmost(struct task_struct *p, struct dl_rq *dl_rq)
> +{
> +	struct sched_dl_entity *dl_se = &p->dl;
> +
> +	return dl_rq->rb_leftmost == &dl_se->rb_node;
> +}
> +
> +void init_dl_rq(struct dl_rq *dl_rq, struct rq *rq)
> +{
> +	dl_rq->rb_root = RB_ROOT;
> +}
> +
> +static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags);
> +static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags);
> +static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
> +				  int flags);
> +
> +/*
> + * We are being explicitly informed that a new instance is starting,
> + * and this means that:
> + *  - the absolute deadline of the entity has to be placed at
> + *    current time + relative deadline;
> + *  - the runtime of the entity has to be set to the maximum value.
> + *
> + * The capability of specifying such event is useful whenever a -deadline
> + * entity wants to (try to!) synchronize its behaviour with the scheduler's
> + * one, and to (try to!) reconcile itself with its own scheduling
> + * parameters.
> + */
> +static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +	struct rq *rq = rq_of_dl_rq(dl_rq);
> +
> +	WARN_ON(!dl_se->dl_new || dl_se->dl_throttled);
> +
> +	/*
> +	 * We use the regular wall clock time to set deadlines in the
> +	 * future; in fact, we must consider execution overheads (time
> +	 * spent on hardirq context, etc.).
> +	 */
> +	dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
> +	dl_se->runtime = dl_se->dl_runtime;
> +	dl_se->dl_new = 0;
> +}
> +
> +/*
> + * Pure Earliest Deadline First (EDF) scheduling does not deal with the
> + * possibility of a entity lasting more than what it declared, and thus
> + * exhausting its runtime.
> + *
> + * Here we are interested in making runtime overrun possible, but we do
> + * not want a entity which is misbehaving to affect the scheduling of all
> + * other entities.
> + * Therefore, a budgeting strategy called Constant Bandwidth Server (CBS)
> + * is used, in order to confine each entity within its own bandwidth.
> + *
> + * This function deals exactly with that, and ensures that when the runtime
> + * of a entity is replenished, its deadline is also postponed. That ensures
> + * the overrunning entity can't interfere with other entity in the system and
> + * can't make them miss their deadlines. Reasons why this kind of overruns
> + * could happen are, typically, a entity voluntarily trying to overcome its
> + * runtime, or it just underestimated it during sched_setscheduler_ex().
> + */
> +static void replenish_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +	struct rq *rq = rq_of_dl_rq(dl_rq);
> +
> +	/*
> +	 * We keep moving the deadline away until we get some
> +	 * available runtime for the entity. This ensures correct
> +	 * handling of situations where the runtime overrun is
> +	 * arbitrary large.
> +	 */
> +	while (dl_se->runtime <= 0) {
> +		dl_se->deadline += dl_se->dl_deadline;
> +		dl_se->runtime += dl_se->dl_runtime;
> +	}
> +
> +	/*
> +	 * At this point, the deadline really should be "in
> +	 * the future" with respect to rq->clock. If it's
> +	 * not, we are, for some reason, lagging too much!
> +	 * Anyway, after having warn userspace abut that,
> +	 * we still try to keep the things running by
> +	 * resetting the deadline and the budget of the
> +	 * entity.
> +	 */
> +	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
> +		static bool lag_once = false;
> +
> +		if (!lag_once) {
> +			lag_once = true;
> +			printk_sched("sched: DL replenish lagged to much\n");
> +		}
> +		dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
> +		dl_se->runtime = dl_se->dl_runtime;
> +	}
> +}
> +
> +/*
> + * Here we check if --at time t-- an entity (which is probably being
> + * [re]activated or, in general, enqueued) can use its remaining runtime
> + * and its current deadline _without_ exceeding the bandwidth it is
> + * assigned (function returns true if it can't). We are in fact applying
> + * one of the CBS rules: when a task wakes up, if the residual runtime
> + * over residual deadline fits within the allocated bandwidth, then we
> + * can keep the current (absolute) deadline and residual budget without
> + * disrupting the schedulability of the system. Otherwise, we should
> + * refill the runtime and set the deadline a period in the future,
> + * because keeping the current (absolute) deadline of the task would
> + * result in breaking guarantees promised to other tasks.
> + *
> + * This function returns true if:
> + *
> + *   runtime / (deadline - t) > dl_runtime / dl_deadline ,


I'm a bit confused here about this algorithm. If I state I want to have
a run time of 20 ms out of 100 ms, so my dl_runtime / dl_deadline is
1/5 or %20.

Now if I don't don't get scheduled at the start of my new period
because other tasks are running, and I start say, at 50ms in. Thus, my
deadline - t == 50, but my runtime remaining is still 20ms. Thus I have
20/50 which is 2/5 or %40. Doing the calculation I have 40 > 20 being
true, and thus we label this as an overflow.

Is this what we really want? Or did I misunderstand something here?

Is this only for tasks that went to sleep voluntarily and have just
woken up?


> + *
> + * IOW we can't recycle current parameters.
> + */
> +static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
> +{
> +	u64 left, right;
> +
> +	/*
> +	 * left and right are the two sides of the equation above,
> +	 * after a bit of shuffling to use multiplications instead
> +	 * of divisions.
> +	 *
> +	 * Note that none of the time values involved in the two
> +	 * multiplications are absolute: dl_deadline and dl_runtime
> +	 * are the relative deadline and the maximum runtime of each
> +	 * instance, runtime is the runtime left for the last instance
> +	 * and (deadline - t), since t is rq->clock, is the time left
> +	 * to the (absolute) deadline. Even if overflowing the u64 type
> +	 * is very unlikely to occur in both cases, here we scale down
> +	 * as we want to avoid that risk at all. Scaling down by 10
> +	 * means that we reduce granularity to 1us. We are fine with it,
> +	 * since this is only a true/false check and, anyway, thinking
> +	 * of anything below microseconds resolution is actually fiction
> +	 * (but still we want to give the user that illusion >;).
> +	 */
> +	left = (dl_se->dl_deadline >> 10) * (dl_se->runtime >> 10);
> +	right = ((dl_se->deadline - t) >> 10) * (dl_se->dl_runtime >> 10);
> +
> +	return dl_time_before(right, left);
> +}
> +
> +/*
> + * When a -deadline entity is queued back on the runqueue, its runtime and
> + * deadline might need updating.
> + *
> + * The policy here is that we update the deadline of the entity only if:
> + *  - the current deadline is in the past,
> + *  - using the remaining runtime with the current deadline would make
> + *    the entity exceed its bandwidth.
> + */
> +static void update_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +	struct rq *rq = rq_of_dl_rq(dl_rq);
> +
> +	/*
> +	 * The arrival of a new instance needs special treatment, i.e.,
> +	 * the actual scheduling parameters have to be "renewed".
> +	 */
> +	if (dl_se->dl_new) {
> +		setup_new_dl_entity(dl_se);
> +		return;
> +	}
> +
> +	if (dl_time_before(dl_se->deadline, rq_clock(rq)) ||
> +	    dl_entity_overflow(dl_se, rq_clock(rq))) {
> +		dl_se->deadline = rq_clock(rq) + dl_se->dl_deadline;
> +		dl_se->runtime = dl_se->dl_runtime;

In the case that I stated, we just moved the deadline forward.

Or is this only because it was just enqueued, and we fear that it will
starve out other tasks? That is, this only happens if the task was
sleeping and just woke up.

-- Steve

> +	}
> +}
> +
> +/*
> + * If the entity depleted all its runtime, and if we want it to sleep
> + * while waiting for some new execution time to become available, we
> + * set the bandwidth enforcement timer to the replenishment instant
> + * and try to activate it.
> + *
> + * Notice that it is important for the caller to know if the timer
> + * actually started or not (i.e., the replenishment instant is in
> + * the future or in the past).
> + */
> +static int start_dl_timer(struct sched_dl_entity *dl_se)
> +{
> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +	struct rq *rq = rq_of_dl_rq(dl_rq);
> +	ktime_t now, act;
> +	ktime_t soft, hard;
> +	unsigned long range;
> +	s64 delta;
> +
> +	/*
> +	 * We want the timer to fire at the deadline, but considering
> +	 * that it is actually coming from rq->clock and not from
> +	 * hrtimer's time base reading.
> +	 */
> +	act = ns_to_ktime(dl_se->deadline);
> +	now = hrtimer_cb_get_time(&dl_se->dl_timer);
> +	delta = ktime_to_ns(now) - rq_clock(rq);
> +	act = ktime_add_ns(act, delta);
> +
> +	/*
> +	 * If the expiry time already passed, e.g., because the value
> +	 * chosen as the deadline is too small, don't even try to
> +	 * start the timer in the past!
> +	 */
> +	if (ktime_us_delta(act, now) < 0)
> +		return 0;
> +
> +	hrtimer_set_expires(&dl_se->dl_timer, act);
> +
> +	soft = hrtimer_get_softexpires(&dl_se->dl_timer);
> +	hard = hrtimer_get_expires(&dl_se->dl_timer);
> +	range = ktime_to_ns(ktime_sub(hard, soft));
> +	__hrtimer_start_range_ns(&dl_se->dl_timer, soft,
> +				 range, HRTIMER_MODE_ABS, 0);
> +
> +	return hrtimer_active(&dl_se->dl_timer);
> +}
> +
> +/*
> + * This is the bandwidth enforcement timer callback. If here, we know
> + * a task is not on its dl_rq, since the fact that the timer was running
> + * means the task is throttled and needs a runtime replenishment.
> + *
> + * However, what we actually do depends on the fact the task is active,
> + * (it is on its rq) or has been removed from there by a call to
> + * dequeue_task_dl(). In the former case we must issue the runtime
> + * replenishment and add the task back to the dl_rq; in the latter, we just
> + * do nothing but clearing dl_throttled, so that runtime and deadline
> + * updating (and the queueing back to dl_rq) will be done by the
> + * next call to enqueue_task_dl().
> + */
> +static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
> +{
> +	struct sched_dl_entity *dl_se = container_of(timer,
> +						     struct sched_dl_entity,
> +						     dl_timer);
> +	struct task_struct *p = dl_task_of(dl_se);
> +	struct rq *rq = task_rq(p);
> +	raw_spin_lock(&rq->lock);
> +
> +	/*
> +	 * We need to take care of a possible races here. In fact, the
> +	 * task might have changed its scheduling policy to something
> +	 * different from SCHED_DEADLINE or changed its reservation
> +	 * parameters (through sched_setscheduler()).
> +	 */
> +	if (!dl_task(p) || dl_se->dl_new)
> +		goto unlock;
> +
> +	dl_se->dl_throttled = 0;
> +	if (p->on_rq) {
> +		enqueue_task_dl(rq, p, ENQUEUE_REPLENISH);
> +		if (task_has_dl_policy(rq->curr))
> +			check_preempt_curr_dl(rq, p, 0);
> +		else
> +			resched_task(rq->curr);
> +	}
> +unlock:
> +	raw_spin_unlock(&rq->lock);
> +
> +	return HRTIMER_NORESTART;
> +}
> +
> +void init_dl_task_timer(struct sched_dl_entity *dl_se)
> +{
> +	struct hrtimer *timer = &dl_se->dl_timer;
> +
> +	if (hrtimer_active(timer)) {
> +		hrtimer_try_to_cancel(timer);
> +		return;
> +	}
> +
> +	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +	timer->function = dl_task_timer;
> +}
> +
> +static
> +int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
> +{
> +	int dmiss = dl_time_before(dl_se->deadline, rq_clock(rq));
> +	int rorun = dl_se->runtime <= 0;
> +
> +	if (!rorun && !dmiss)
> +		return 0;
> +
> +	/*
> +	 * If we are beyond our current deadline and we are still
> +	 * executing, then we have already used some of the runtime of
> +	 * the next instance. Thus, if we do not account that, we are
> +	 * stealing bandwidth from the system at each deadline miss!
> +	 */
> +	if (dmiss) {
> +		dl_se->runtime = rorun ? dl_se->runtime : 0;
> +		dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
> +	}
> +
> +	return 1;
> +}
> +
> +/*
> + * Update the current task's runtime statistics (provided it is still
> + * a -deadline task and has not been removed from the dl_rq).
> + */
> +static void update_curr_dl(struct rq *rq)
> +{
> +	struct task_struct *curr = rq->curr;
> +	struct sched_dl_entity *dl_se = &curr->dl;
> +	u64 delta_exec;
> +
> +	if (!dl_task(curr) || !on_dl_rq(dl_se))
> +		return;
> +
> +	/*
> +	 * Consumed budget is computed considering the time as
> +	 * observed by schedulable tasks (excluding time spent
> +	 * in hardirq context, etc.). Deadlines are instead
> +	 * computed using hard walltime. This seems to be the more
> +	 * natural solution, but the full ramifications of this
> +	 * approach need further study.
> +	 */
> +	delta_exec = rq_clock_task(rq) - curr->se.exec_start;
> +	if (unlikely((s64)delta_exec < 0))
> +		delta_exec = 0;
> +
> +	schedstat_set(curr->se.statistics.exec_max,
> +		      max(curr->se.statistics.exec_max, delta_exec));
> +
> +	curr->se.sum_exec_runtime += delta_exec;
> +	account_group_exec_runtime(curr, delta_exec);
> +
> +	curr->se.exec_start = rq_clock_task(rq);
> +	cpuacct_charge(curr, delta_exec);
> +
> +	dl_se->runtime -= delta_exec;
> +	if (dl_runtime_exceeded(rq, dl_se)) {
> +		__dequeue_task_dl(rq, curr, 0);
> +		if (likely(start_dl_timer(dl_se)))
> +			dl_se->dl_throttled = 1;
> +		else
> +			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
> +
> +		if (!is_leftmost(curr, &rq->dl))
> +			resched_task(curr);
> +	}
> +}
> +
> +static void __enqueue_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +	struct rb_node **link = &dl_rq->rb_root.rb_node;
> +	struct rb_node *parent = NULL;
> +	struct sched_dl_entity *entry;
> +	int leftmost = 1;
> +
> +	BUG_ON(!RB_EMPTY_NODE(&dl_se->rb_node));
> +
> +	while (*link) {
> +		parent = *link;
> +		entry = rb_entry(parent, struct sched_dl_entity, rb_node);
> +		if (dl_time_before(dl_se->deadline, entry->deadline))
> +			link = &parent->rb_left;
> +		else {
> +			link = &parent->rb_right;
> +			leftmost = 0;
> +		}
> +	}
> +
> +	if (leftmost)
> +		dl_rq->rb_leftmost = &dl_se->rb_node;
> +
> +	rb_link_node(&dl_se->rb_node, parent, link);
> +	rb_insert_color(&dl_se->rb_node, &dl_rq->rb_root);
> +
> +	dl_rq->dl_nr_running++;
> +}
> +
> +static void __dequeue_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +	struct dl_rq *dl_rq = dl_rq_of_se(dl_se);
> +
> +	if (RB_EMPTY_NODE(&dl_se->rb_node))
> +		return;
> +
> +	if (dl_rq->rb_leftmost == &dl_se->rb_node) {
> +		struct rb_node *next_node;
> +
> +		next_node = rb_next(&dl_se->rb_node);
> +		dl_rq->rb_leftmost = next_node;
> +	}
> +
> +	rb_erase(&dl_se->rb_node, &dl_rq->rb_root);
> +	RB_CLEAR_NODE(&dl_se->rb_node);
> +
> +	dl_rq->dl_nr_running--;
> +}
> +
> +static void
> +enqueue_dl_entity(struct sched_dl_entity *dl_se, int flags)
> +{
> +	BUG_ON(on_dl_rq(dl_se));
> +
> +	/*
> +	 * If this is a wakeup or a new instance, the scheduling
> +	 * parameters of the task might need updating. Otherwise,
> +	 * we want a replenishment of its runtime.
> +	 */
> +	if (!dl_se->dl_new && flags & ENQUEUE_REPLENISH)
> +		replenish_dl_entity(dl_se);
> +	else
> +		update_dl_entity(dl_se);
> +
> +	__enqueue_dl_entity(dl_se);
> +}
> +
> +static void dequeue_dl_entity(struct sched_dl_entity *dl_se)
> +{
> +	__dequeue_dl_entity(dl_se);
> +}
> +
> +static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
> +{
> +	/*
> +	 * If p is throttled, we do nothing. In fact, if it exhausted
> +	 * its budget it needs a replenishment and, since it now is on
> +	 * its rq, the bandwidth timer callback (which clearly has not
> +	 * run yet) will take care of this.
> +	 */
> +	if (p->dl.dl_throttled)
> +		return;
> +
> +	enqueue_dl_entity(&p->dl, flags);
> +	inc_nr_running(rq);
> +}
> +
> +static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
> +{
> +	dequeue_dl_entity(&p->dl);
> +}
> +
> +static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
> +{
> +	update_curr_dl(rq);
> +	__dequeue_task_dl(rq, p, flags);
> +
> +	dec_nr_running(rq);
> +}
> +
> +/*
> + * Yield task semantic for -deadline tasks is:
> + *
> + *   get off from the CPU until our next instance, with
> + *   a new runtime. This is of little use now, since we
> + *   don't have a bandwidth reclaiming mechanism. Anyway,
> + *   bandwidth reclaiming is planned for the future, and
> + *   yield_task_dl will indicate that some spare budget
> + *   is available for other task instances to use it.
> + */
> +static void yield_task_dl(struct rq *rq)
> +{
> +	struct task_struct *p = rq->curr;
> +
> +	/*
> +	 * We make the task go to sleep until its current deadline by
> +	 * forcing its runtime to zero. This way, update_curr_dl() stops
> +	 * it and the bandwidth timer will wake it up and will give it
> +	 * new scheduling parameters (thanks to dl_new=1).
> +	 */
> +	if (p->dl.runtime > 0) {
> +		rq->curr->dl.dl_new = 1;
> +		p->dl.runtime = 0;
> +	}
> +	update_curr_dl(rq);
> +}
> +
> +/*
> + * Only called when both the current and waking task are -deadline
> + * tasks.
> + */
> +static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
> +				  int flags)
> +{
> +	if (dl_time_before(p->dl.deadline, rq->curr->dl.deadline))
> +		resched_task(rq->curr);
> +}
> +
> +#ifdef CONFIG_SCHED_HRTICK
> +static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
> +{
> +	s64 delta = p->dl.dl_runtime - p->dl.runtime;
> +
> +	if (delta > 10000)
> +		hrtick_start(rq, p->dl.runtime);
> +}
> +#endif
> +
> +static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
> +						   struct dl_rq *dl_rq)
> +{
> +	struct rb_node *left = dl_rq->rb_leftmost;
> +
> +	if (!left)
> +		return NULL;
> +
> +	return rb_entry(left, struct sched_dl_entity, rb_node);
> +}
> +
> +struct task_struct *pick_next_task_dl(struct rq *rq)
> +{
> +	struct sched_dl_entity *dl_se;
> +	struct task_struct *p;
> +	struct dl_rq *dl_rq;
> +
> +	dl_rq = &rq->dl;
> +
> +	if (unlikely(!dl_rq->dl_nr_running))
> +		return NULL;
> +
> +	dl_se = pick_next_dl_entity(rq, dl_rq);
> +	BUG_ON(!dl_se);
> +
> +	p = dl_task_of(dl_se);
> +	p->se.exec_start = rq_clock_task(rq);
> +#ifdef CONFIG_SCHED_HRTICK
> +	if (hrtick_enabled(rq))
> +		start_hrtick_dl(rq, p);
> +#endif
> +	return p;
> +}
> +
> +static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
> +{
> +	update_curr_dl(rq);
> +}
> +
> +static void task_tick_dl(struct rq *rq, struct task_struct *p, int queued)
> +{
> +	update_curr_dl(rq);
> +
> +#ifdef CONFIG_SCHED_HRTICK
> +	if (hrtick_enabled(rq) && queued && p->dl.runtime > 0)
> +		start_hrtick_dl(rq, p);
> +#endif
> +}
> +
> +static void task_fork_dl(struct task_struct *p)
> +{
> +	/*
> +	 * SCHED_DEADLINE tasks cannot fork and this is achieved through
> +	 * sched_fork()
> +	 */
> +}
> +
> +static void task_dead_dl(struct task_struct *p)
> +{
> +	struct hrtimer *timer = &p->dl.dl_timer;
> +
> +	if (hrtimer_active(timer))
> +		hrtimer_try_to_cancel(timer);
> +}
> +
> +static void set_curr_task_dl(struct rq *rq)
> +{
> +	struct task_struct *p = rq->curr;
> +
> +	p->se.exec_start = rq_clock_task(rq);
> +}
> +
> +static void switched_from_dl(struct rq *rq, struct task_struct *p)
> +{
> +	if (hrtimer_active(&p->dl.dl_timer))
> +		hrtimer_try_to_cancel(&p->dl.dl_timer);
> +}
> +
> +static void switched_to_dl(struct rq *rq, struct task_struct *p)
> +{
> +	/*
> +	 * If p is throttled, don't consider the possibility
> +	 * of preempting rq->curr, the check will be done right
> +	 * after its runtime will get replenished.
> +	 */
> +	if (unlikely(p->dl.dl_throttled))
> +		return;
> +
> +	if (!p->on_rq || rq->curr != p) {
> +		if (task_has_dl_policy(rq->curr))
> +			check_preempt_curr_dl(rq, p, 0);
> +		else
> +			resched_task(rq->curr);
> +	}
> +}
> +
> +static void prio_changed_dl(struct rq *rq, struct task_struct *p,
> +			    int oldprio)
> +{
> +	switched_to_dl(rq, p);
> +}
> +
> +#ifdef CONFIG_SMP
> +static int
> +select_task_rq_dl(struct task_struct *p, int sd_flag, int flags)
> +{
> +	return task_cpu(p);
> +}
> +#endif
> +
> +const struct sched_class dl_sched_class = {
> +	.next			= &rt_sched_class,
> +	.enqueue_task		= enqueue_task_dl,
> +	.dequeue_task		= dequeue_task_dl,
> +	.yield_task		= yield_task_dl,
> +
> +	.check_preempt_curr	= check_preempt_curr_dl,
> +
> +	.pick_next_task		= pick_next_task_dl,
> +	.put_prev_task		= put_prev_task_dl,
> +
> +#ifdef CONFIG_SMP
> +	.select_task_rq		= select_task_rq_dl,
> +#endif
> +
> +	.set_curr_task		= set_curr_task_dl,
> +	.task_tick		= task_tick_dl,
> +	.task_fork              = task_fork_dl,
> +	.task_dead		= task_dead_dl,
> +
> +	.prio_changed           = prio_changed_dl,
> +	.switched_from		= switched_from_dl,
> +	.switched_to		= switched_to_dl,
> +};
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 64eda5c..ba97476 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -2,6 +2,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/sysctl.h>
>  #include <linux/sched/rt.h>
> +#include <linux/sched/deadline.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
>  #include <linux/stop_machine.h>
> @@ -87,11 +88,23 @@ static inline int rt_policy(int policy)
>  	return 0;
>  }
>  
> +static inline int dl_policy(int policy)
> +{
> +	if (unlikely(policy == SCHED_DEADLINE))
> +		return 1;
> +	return 0;
> +}
> +
>  static inline int task_has_rt_policy(struct task_struct *p)
>  {
>  	return rt_policy(p->policy);
>  }
>  
> +static inline int task_has_dl_policy(struct task_struct *p)
> +{
> +	return dl_policy(p->policy);
> +}
> +
>  /*
>   * This is the priority-queue data structure of the RT scheduling class:
>   */
> @@ -363,6 +376,15 @@ struct rt_rq {
>  #endif
>  };
>  
> +/* Deadline class' related fields in a runqueue */
> +struct dl_rq {
> +	/* runqueue is an rbtree, ordered by deadline */
> +	struct rb_root rb_root;
> +	struct rb_node *rb_leftmost;
> +
> +	unsigned long dl_nr_running;
> +};
> +
>  #ifdef CONFIG_SMP
>  
>  /*
> @@ -427,6 +449,7 @@ struct rq {
>  
>  	struct cfs_rq cfs;
>  	struct rt_rq rt;
> +	struct dl_rq dl;
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	/* list of leaf cfs_rq on this cpu: */
> @@ -957,6 +980,7 @@ static const u32 prio_to_wmult[40] = {
>  #else
>  #define ENQUEUE_WAKING		0
>  #endif
> +#define ENQUEUE_REPLENISH	8
>  
>  #define DEQUEUE_SLEEP		1
>  
> @@ -1012,6 +1036,7 @@ struct sched_class {
>     for (class = sched_class_highest; class; class = class->next)
>  
>  extern const struct sched_class stop_sched_class;
> +extern const struct sched_class dl_sched_class;
>  extern const struct sched_class rt_sched_class;
>  extern const struct sched_class fair_sched_class;
>  extern const struct sched_class idle_sched_class;
> @@ -1047,6 +1072,8 @@ extern void resched_cpu(int cpu);
>  extern struct rt_bandwidth def_rt_bandwidth;
>  extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
>  
> +extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
> +
>  extern void update_idle_cpu_load(struct rq *this_rq);
>  
>  extern void init_task_runnable_average(struct task_struct *p);
> @@ -1305,6 +1332,7 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
>  
>  extern void init_cfs_rq(struct cfs_rq *cfs_rq);
>  extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
> +extern void init_dl_rq(struct dl_rq *rt_rq, struct rq *rq);
>  
>  extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
>  
> diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
> index e08fbee..a5cef17 100644
> --- a/kernel/sched/stop_task.c
> +++ b/kernel/sched/stop_task.c
> @@ -103,7 +103,7 @@ get_rr_interval_stop(struct rq *rq, struct task_struct *task)
>   * Simple, special scheduling class for the per-CPU stop tasks:
>   */
>  const struct sched_class stop_sched_class = {
> -	.next			= &rt_sched_class,
> +	.next			= &dl_sched_class,
>  
>  	.enqueue_task		= enqueue_task_stop,
>  	.dequeue_task		= dequeue_task_stop,

