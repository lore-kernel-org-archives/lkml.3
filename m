Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaG2M5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:57:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:36331 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaG2M5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:57:48 -0400
Date: Tue, 29 Jul 2014 14:57:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH v2 5/5] sched/fair: Remove double_lock_balance() from
 load_balance()
Message-ID: <20140729125740.GV20603@laptop.programming.kicks-ass.net>
References: <20140726145508.6308.69121.stgit@localhost>
 <20140726145949.6308.12411.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140726145949.6308.12411.stgit@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 06:59:52PM +0400, Kirill Tkhai wrote:
> Keep on_rq = ONRQ_MIGRATING, while task is migrating, instead.
> 
> v2: Added missed check_preempt_curr() in attach_tasks().

vN thingies go below the ---, they're pointless to preserve. Which then
turns this Changelog into something that's entirely too short.

> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/fair.c |   85 +++++++++++++++++++++++++++++++++------------------
>  1 file changed, 55 insertions(+), 30 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index a1b74f2..a47fb3f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4706,9 +4706,9 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
>  		return;
>  
>  	/*
> -	 * This is possible from callers such as move_task(), in which we
> -	 * unconditionally check_prempt_curr() after an enqueue (which may have
> -	 * lead to a throttle).  This both saves work and prevents false
> +	 * This is possible from callers, in which we unconditionally
> +	 * check_prempt_curr() after an enqueue (which may have lead
> +	 * to a throttle).  This both saves work and prevents false
>  	 * next-buddy nomination below.
>  	 */

It would be good to retain the reference to code that does that.

>  	if (unlikely(throttled_hierarchy(cfs_rq_of(pse))))
> @@ -5114,20 +5114,22 @@ struct lb_env {
>  	unsigned int		loop_max;
>  
>  	enum fbq_type		fbq_type;
> +	struct list_head	tasks;
>  };
>  
>  /*
> - * move_task - move a task from one runqueue to another runqueue.
> - * Both runqueues must be locked.
> + * detach_task - detach a task from its runqueue for migration.
> + * The runqueue must be locked.
>   */
> -static void move_task(struct task_struct *p, struct lb_env *env)
> +static void detach_task(struct task_struct *p, struct lb_env *env)
>  {
>  	deactivate_task(env->src_rq, p, 0);
> +	list_add(&p->se.group_node, &env->tasks);
> +	p->on_rq = ONRQ_MIGRATING;
>  	set_task_cpu(p, env->dst_cpu);
> -	activate_task(env->dst_rq, p, 0);
> -	check_preempt_curr(env->dst_rq, p, 0);
>  }
>  
> +

We don't need more whitespace here, do we?

>  /*
>   * Is this task likely cache-hot?
>   *
> @@ -5375,18 +5377,18 @@ static struct task_struct *detach_one_task(struct lb_env *env)
>  static const unsigned int sched_nr_migrate_break = 32;
>  
>  /*
> - * move_tasks tries to move up to imbalance weighted load from busiest to
> - * this_rq, as part of a balancing operation within domain "sd".
> - * Returns 1 if successful and 0 otherwise.
> + * detach_tasks tries to detach up to imbalance weighted load from busiest_rq,
> + * as part of a balancing operation within domain "sd".
> + * Returns number of detached tasks if successful and 0 otherwise.
>   *
> - * Called with both runqueues locked.
> + * Called with env->src_rq locked.

We should avoid comments like that, and instead use assertions to
enforce them.

>   */
> -static int move_tasks(struct lb_env *env)
> +static int detach_tasks(struct lb_env *env)
>  {
>  	struct list_head *tasks = &env->src_rq->cfs_tasks;
>  	struct task_struct *p;
>  	unsigned long load;
> -	int pulled = 0;
> +	int detached = 0;

Like so:

	lockdep_assert_held(&env->src_rq->lock);

>  
>  	if (env->imbalance <= 0)
>  		return 0;


This one could use a comment to tell its the complement to
detach_tasks()

> +static void attach_tasks(struct lb_env *env)
> +{
> +	struct list_head *tasks = &env->tasks;
> +	struct task_struct *p;

And here we obviously want:

	lockdep_assert_held(&env->dst_rq->lock);

> +	while (!list_empty(tasks)) {
> +		p = list_first_entry(tasks, struct task_struct, se.group_node);
> +		BUG_ON(task_rq(p) != env->dst_rq);
> +		list_del_init(&p->se.group_node);
> +		p->on_rq = ONRQ_QUEUED;
> +		activate_task(env->dst_rq, p, 0);
> +		check_preempt_curr(env->dst_rq, p, 0);
> +	}
>  }

> @@ -6608,16 +6627,22 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
>  
>  more_balance:
> +		raw_spin_lock_irqsave(&busiest->lock, flags);
>  
>  		/*
>  		 * cur_ld_moved - load moved in current iteration
>  		 * ld_moved     - cumulative load moved across iterations
>  		 */
> +		cur_ld_moved = detach_tasks(&env);
> +		raw_spin_unlock(&busiest->lock);
> +
> +		if (cur_ld_moved) {
> +			raw_spin_lock(&env.dst_rq->lock);
> +			attach_tasks(&env);
> +			raw_spin_unlock(&env.dst_rq->lock);
> +			ld_moved += cur_ld_moved;
> +		}
> +
>  		local_irq_restore(flags);

I think somewhere here would be a good place to put a comment on how all
this is still 'bounded'.
