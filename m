Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaHLJjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:39:14 -0400
Received: from relay.parallels.com ([195.214.232.42]:46580 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHLJjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:39:13 -0400
Message-ID: <1407836347.23412.6.camel@tkhai>
Subject: Re: [PATCH v4 5/6] sched/fair: Remove double_lock_balance() from
 active_load_balance_cpu_stop()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <pjt@google.com>, <oleg@redhat.com>,
        <rostedt@goodmis.org>, <umgwanakikbuti@gmail.com>, <tkhai@yandex.ru>,
        <tim.c.chen@linux.intel.com>, <mingo@kernel.org>,
        <nicolas.pitre@linaro.org>
Date: Tue, 12 Aug 2014 13:39:07 +0400
In-Reply-To: <20140812092246.GQ9918@twins.programming.kicks-ass.net>
References: <20140806075138.24858.23816.stgit@tkhai>
	 <1407312416.8424.47.camel@tkhai>
	 <20140812092246.GQ9918@twins.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 12/08/2014 в 11:22 +0200, Peter Zijlstra пишет:
> Something like so?

Pair brackets detach_one_task()/attach_one_task() look good.
No objections.

> ---
> Subject: sched/fair: Remove double_lock_balance() from active_load_balance_cpu_stop()
> From: Kirill Tkhai <ktkhai@parallels.com>
> Date: Wed, 6 Aug 2014 12:06:56 +0400
> 
> Avoid double_rq_lock() and use ONRQ_MIGRATING for
> active_load_balance_cpu_stop(). The advantage is (obviously) not
> holding two 'rq->lock's at the same time and thereby increasing
> parallelism.
> 
> Further note that if there was no task to migrate we will not have
> acquired the second rq->lock at all.
> 
> The important point to note is that because we acquire dst->lock
> immediately after releasing src->lock the potential wait time of
> task_rq_lock() callers on ONRQ_MIGRATING is not longer than it would
> have been in the double rq lock scenario.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1407312416.8424.47.camel@tkhai
> ---
>  kernel/sched/fair.c |   60 ++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 44 insertions(+), 16 deletions(-)
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5135,6 +5135,8 @@ static int task_hot(struct task_struct *
>  {
>  	s64 delta;
>  
> +	lockdep_assert_held(&env->src_rq->lock);
> +
>  	if (p->sched_class != &fair_sched_class)
>  		return 0;
>  
> @@ -5254,6 +5256,9 @@ static
>  int can_migrate_task(struct task_struct *p, struct lb_env *env)
>  {
>  	int tsk_cache_hot = 0;
> +
> +	lockdep_assert_held(&env->src_rq->lock);
> +
>  	/*
>  	 * We do not migrate tasks that are:
>  	 * 1) throttled_lb_pair, or
> @@ -5338,30 +5343,49 @@ int can_migrate_task(struct task_struct
>  }
>  
>  /*
> - * move_one_task tries to move exactly one task from busiest to this_rq, as
> + * detach_one_task() -- tries to dequeue exactly one task from env->src_rq, as
>   * part of active balancing operations within "domain".
> - * Returns 1 if successful and 0 otherwise.
>   *
> - * Called with both runqueues locked.
> + * Returns a task if successful and NULL otherwise.
>   */
> -static int move_one_task(struct lb_env *env)
> +static struct task_struct *detach_one_task(struct lb_env *env)
>  {
>  	struct task_struct *p, *n;
>  
> +	lockdep_assert_held(&env->src_rq->lock);
> +
>  	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
>  		if (!can_migrate_task(p, env))
>  			continue;
>  
> -		move_task(p, env);
> +		deactivate_task(env->src_rq, p, 0);
> +		p->on_rq = ONRQ_MIGRATING;
> +		set_task_cpu(p, env->dst_cpu);
> +
>  		/*
> -		 * Right now, this is only the second place move_task()
> -		 * is called, so we can safely collect move_task()
> -		 * stats here rather than inside move_task().
> +		 * Right now, this is only the second place where
> +		 * lb_gained[env->idle] is updated (other is move_tasks)
> +		 * so we can safely collect stats here rather than
> +		 * inside move_tasks().
>  		 */
>  		schedstat_inc(env->sd, lb_gained[env->idle]);
> -		return 1;
> +		return p;
>  	}
> -	return 0;
> +	return NULL;
> +}
> +
> +/*
> + * attach_one_task() -- attaches the task returned from detach_one_task() to
> + * its new rq.
> + */
> +static void attach_one_task(struct rq *rq, struct task_struct *p)
> +{
> +	raw_spin_lock(&rq->lock);
> +	BUG_ON(task_rq(p) != rq);
> +	p->on_rq = ONRQ_QUEUED;
> +	activate_task(rq, p, 0);
> +	check_preempt_curr(rq, p, 0);
> +	raw_spin_unlock(&rq->lock);
>  }
>  
>  static const unsigned int sched_nr_migrate_break = 32;
> @@ -6940,6 +6964,7 @@ static int active_load_balance_cpu_stop(
>  	int target_cpu = busiest_rq->push_cpu;
>  	struct rq *target_rq = cpu_rq(target_cpu);
>  	struct sched_domain *sd;
> +	struct task_struct *p = NULL;
>  
>  	raw_spin_lock_irq(&busiest_rq->lock);
>  
> @@ -6959,9 +6984,6 @@ static int active_load_balance_cpu_stop(
>  	 */
>  	BUG_ON(busiest_rq == target_rq);
>  
> -	/* move a task from busiest_rq to target_rq */
> -	double_lock_balance(busiest_rq, target_rq);
> -
>  	/* Search for an sd spanning us and the target CPU. */
>  	rcu_read_lock();
>  	for_each_domain(target_cpu, sd) {
> @@ -6982,16 +7004,22 @@ static int active_load_balance_cpu_stop(
>  
>  		schedstat_inc(sd, alb_count);
>  
> -		if (move_one_task(&env))
> +		p = detach_one_task(&env);
> +		if (p)
>  			schedstat_inc(sd, alb_pushed);
>  		else
>  			schedstat_inc(sd, alb_failed);
>  	}
>  	rcu_read_unlock();
> -	double_unlock_balance(busiest_rq, target_rq);
>  out_unlock:
>  	busiest_rq->active_balance = 0;
> -	raw_spin_unlock_irq(&busiest_rq->lock);
> +	raw_spin_unlock(&busiest_rq->lock);
> +
> +	if (p)
> +		attach_one_task(target_rq, p);
> +
> +	local_irq_enable();
> +
>  	return 0;
>  }
>  


