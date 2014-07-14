Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaGNTeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:34:09 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60182 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaGNTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:33:56 -0400
From: bsegall@google.com
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        pjt@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v2] sched: Rewrite per entity runnable load average tracking
References: <1405293352-9305-1-git-send-email-yuyang.du@intel.com>
	<1405293352-9305-3-git-send-email-yuyang.du@intel.com>
Date: Mon, 14 Jul 2014 12:33:53 -0700
In-Reply-To: <1405293352-9305-3-git-send-email-yuyang.du@intel.com> (Yuyang
	Du's message of "Mon, 14 Jul 2014 07:15:52 +0800")
Message-ID: <xm26vbqzwx9a.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yuyang Du <yuyang.du@intel.com> writes:
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1069,14 +1069,11 @@ struct load_weight {
>  
>  struct sched_avg {
>  	/*
> -	 * These sums represent an infinite geometric series and so are bound
> -	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
> -	 * choices of y < 1-2^(-32)*1024.
> +	 * The load_avg represents an infinite geometric series.
>  	 */
> -	u32 runnable_avg_sum, runnable_avg_period;
> -	u64 last_runnable_update;
> -	s64 decay_count;
> -	unsigned long load_avg_contrib;
> +	u32 load_avg;

This should probably be unsigned long (it can still overflow on 32-bit
if the user picks ~90000 as a cgroup weight, but so it goes).

> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -282,9 +282,6 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
>  	return grp->my_q;
>  }
>  
> -static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
> -				       int force_update);
> -
>  static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
>  {
>  	if (!cfs_rq->on_list) {
> @@ -304,8 +301,6 @@ static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
>  		}
>  
>  		cfs_rq->on_list = 1;
> -		/* We should have no load, but we need to update last_decay. */
> -		update_cfs_rq_blocked_load(cfs_rq, 0);

AFAICT this call was nonsense before your change, yes (it gets called by
enqueue_entity_load_avg)?

>  	}
>  }
>  
> @@ -667,18 +662,17 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  #ifdef CONFIG_SMP
>  static unsigned long task_h_load(struct task_struct *p);
>  
> -static inline void __update_task_entity_contrib(struct sched_entity *se);
> -
>  /* Give new task start runnable values to heavy its load in infant time */
>  void init_task_runnable_average(struct task_struct *p)
>  {
>  	u32 slice;
> +	struct sched_avg *sa = &p->se.avg;
>  
> -	p->se.avg.decay_count = 0;
> +	sa->last_update_time = 0;
> +	sa->period_contrib = 0;

sa->period_contrib = slice;

>  	slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
> -	p->se.avg.runnable_avg_sum = slice;
> -	p->se.avg.runnable_avg_period = slice;
> -	__update_task_entity_contrib(&p->se);
> +	sa->load_avg = slice * p->se.load.weight;
> +	/* when this task enqueue'ed, it will contribute to its cfs_rq's load_avg */
>  }
>  #else
>  void init_task_runnable_average(struct task_struct *p)
> @@ -1504,8 +1498,17 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
>  		delta = runtime - p->last_sum_exec_runtime;
>  		*period = now - p->last_task_numa_placement;
>  	} else {
> -		delta = p->se.avg.runnable_avg_sum;
> -		*period = p->se.avg.runnable_avg_period;
> +		/*
> +		 * XXX previous runnable_avg_sum and runnable_avg_period are
> +		 * only used here. May find a way to better suit NUMA here.
> +		 */
> +
> +		delta = p->se.avg.load_avg / p->se.load.weight;
> +#ifndef LOAD_AVG_MAX
> +#define LOAD_AVG_MAX 47742
> +		*period = LOAD_AVG_MAX;
> +#undef LOAD_AVG_MAX
> +#endif

#ifdef LOAD_AVG_MAX
*period = LOAD_AVG_MAX
#else
*period = 47742
#endif

>  	}
>  
>  	p->last_sum_exec_runtime = runtime;
> @@ -2071,13 +2074,9 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
>  	long tg_weight;
>  
>  	/*
> -	 * Use this CPU's actual weight instead of the last load_contribution
> -	 * to gain a more accurate current total weight. See
> -	 * update_cfs_rq_load_contribution().
> +	 * Use this CPU's load average instead of actual weight
>  	 */
> -	tg_weight = atomic_long_read(&tg->load_avg);
> -	tg_weight -= cfs_rq->tg_load_contrib;
> -	tg_weight += cfs_rq->load.weight;
> +	tg_weight = atomic64_read(&tg->load_avg);

You could do the load_contrib thing again. Also while you made
tg->load_avg 64-bit, this is still a long, so you still lose.

>  
>  	return tg_weight;
>  }
> @@ -2087,7 +2086,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
>  	long tg_weight, load, shares;
>  
>  	tg_weight = calc_tg_weight(tg, cfs_rq);
> -	load = cfs_rq->load.weight;
> +	load = cfs_rq->avg.load_avg;
>  
>  	shares = (tg->shares * load);
>  	if (tg_weight)
> @@ -2210,6 +2209,28 @@ static __always_inline u64 decay_load(u64 val, u64 n)
>  	return val >> 32;
>  }
>  
> +static __always_inline u64 decay_load64(u64 val, u64 n)
> +{
> +	if (likely(val <= UINT_MAX))
> +		val = decay_load(val, n);
> +	else {
> +		/*
> +		 * LOAD_AVG_MAX can last ~500ms (=log_2(LOAD_AVG_MAX)*32ms).
> +		 * Since we have so big runnable load_avg, it is impossible
> +		 * load_avg has not been updated for such a long time. So
> +		 * LOAD_AVG_MAX is enough here.
> +		 */

I mean, LOAD_AVG_MAX is irrelevant - the constant could just as well be
1<<20, or whatever, yes? In fact, if you're going to then turn it into a
fraction of 1<<10, just do (with whatever temporaries you find most tasteful):

val *= (u32) decay_load(1 << 10, n);
val >>= 10;

> +		u32 factor = decay_load(LOAD_AVG_MAX, n);
> +
> +		factor <<= 10;
> +		factor /= LOAD_AVG_MAX;
> +		val *= factor;
> +		val >>= 10;
> +	}
> +
> +	return val;
> +}
>
> [...]
>
> +/*
> + * Strictly, this se should use its parent cfs_rq's clock_task, but
> + * here we use its own cfs_rq's for performance matter. But on load_avg
> + * update, what we really care about is "the difference between two regular
> + * clock reads", not absolute time, so the variation should be neglectable.
> + */

Yes, but the difference between two clock reads can differ vastly
depending on which clock you read - if cfs_rq was throttled, but
parent_cfs_rq was not, reading cfs_rq's clock will give you no time
passing. That said I think that's probably what you want for cfs_rq's
load_avg, but is wrong for the group se, which probably needs to use its
parent's.

> +static __always_inline void __update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)

Massive code duplication here makes me sad, although it's not clear how
to avoid it without doing unnecessary u64 math on se load_avgs.

> +/* Update task and its cfs_rq load average */
> +static inline void update_load_avg(struct sched_entity *se, int update_tg)
>  {
> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +	u64 now = cfs_rq_clock_task(cfs_rq);
> +
>  	/*
> +	 * Track task load average for carrying it to new CPU after migrated
>  	 */
> +	if (entity_is_task(se))
> +		__update_load_avg(now, &se->avg, se->on_rq * se->load.weight);
>  
> +	update_cfs_rq_load_avg(now, cfs_rq);
>  
> +	if (update_tg)
> +		update_tg_load_avg(cfs_rq);
>  }

I personally find this very confusing, in that update_load_avg is doing
more to se->cfs_rq, and in fact on anything other than a task, it isn't
touching the se at all (instead, it touches _se->parent_ even).

> diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
> index 16f5a30..8f547fe 100644
> --- a/kernel/sched/proc.c
> +++ b/kernel/sched/proc.c
> @@ -504,7 +504,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  #ifdef CONFIG_SMP
>  static inline unsigned long get_rq_runnable_load(struct rq *rq)
>  {
> -	return rq->cfs.runnable_load_avg;
> +	return rq->cfs.avg.load_avg;
>  }
>  #else
>  static inline unsigned long get_rq_runnable_load(struct rq *rq)
>  
> @@ -3997,7 +3918,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
>  {
> -	return cpu_rq(cpu)->cfs.runnable_load_avg;
> +	return cpu_rq(cpu)->cfs.avg.load_avg;
>  }
>  
>  /*
> @@ -4042,7 +3963,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>  {
>  	struct rq *rq = cpu_rq(cpu);
>  	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
> -	unsigned long load_avg = rq->cfs.runnable_load_avg;
> +	unsigned long load_avg = rq->cfs.avg.load_avg;
>  
>  	if (nr_running)
>  		return load_avg / nr_running;
> @@ -4161,7 +4082,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>  		/*
>  		 * w = rw_i + @wl
>  		 */
> -		w = se->my_q->load.weight + wl;
> +		w = se->my_q->avg.load_avg + wl;
>  		/*
>  		 * Recursively apply this logic to all parent groups to compute
> @@ -4256,14 +4177,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	 */
>  	if (sync) {
>  		tg = task_group(current);
> -		weight = current->se.load.weight;
> +		weight = current->se.avg.load_avg;
>  
>  		this_load += effective_load(tg, this_cpu, -weight, -weight);
>  		load += effective_load(tg, prev_cpu, 0, -weight);
>  	}
>  
>  	tg = task_group(p);
> -	weight = p->se.load.weight;
> +	weight = p->se.avg.load_avg;

These all lose bits on 32-bit (weighted_cpuload did that already too),
and it is likely a pain to fix them all.


>  
>  	/*
>  	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
> @@ -4553,16 +4474,20 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>  	struct cfs_rq *cfs_rq = cfs_rq_of(se);
>  
>  	/*
> -	 * Load tracking: accumulate removed load so that it can be processed
> -	 * when we next update owning cfs_rq under rq->lock.  Tasks contribute
> -	 * to blocked load iff they have a positive decay-count.  It can never
> -	 * be negative here since on-rq tasks have decay-count == 0.
> +	 * Task on old CPU catches up with its old cfs_rq, and subtract itself from
> +	 * the cfs_rq (task must be off the queue now).
>  	 */
> -	if (se->avg.decay_count) {
> -		se->avg.decay_count = -__synchronize_entity_decay(se);
> -		atomic_long_add(se->avg.load_avg_contrib,
> -						&cfs_rq->removed_load);
> -	}
> +	__update_load_avg(cfs_rq->avg.last_update_time, &se->avg, 0);

This read of last_update_time needs to do the min_vruntime_copy trick on
32-bit.

> @@ -5477,14 +5372,14 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
>  	}
>  
>  	if (!se) {
> -		cfs_rq->h_load = cfs_rq->runnable_load_avg;
> +		cfs_rq->h_load = cfs_rq->avg.load_avg;
>  		cfs_rq->last_h_load_update = now;
>  	}
>  
>  	while ((se = cfs_rq->h_load_next) != NULL) {
>  		load = cfs_rq->h_load;
> -		load = div64_ul(load * se->avg.load_avg_contrib,
> -				cfs_rq->runnable_load_avg + 1);
> +		load = div64_ul(load * se->avg.load_avg,
> +				cfs_rq->avg.load_avg + 1);

This needs to be div64_u64 now (the prior one was actually kinda wrong
in that it wasn't even a 64-bit multiply on 32-bit, and you might as
well fix that too).

>  		cfs_rq = group_cfs_rq(se);
>  		cfs_rq->h_load = load;
>  		cfs_rq->last_h_load_update = now;
> @@ -5496,8 +5391,8 @@ static unsigned long task_h_load(struct task_struct *p)
>  	struct cfs_rq *cfs_rq = task_cfs_rq(p);
>  
>  	update_cfs_rq_h_load(cfs_rq);
> -	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
> -			cfs_rq->runnable_load_avg + 1);
> +	return div64_ul(p->se.avg.load_avg * cfs_rq->h_load,
> +			cfs_rq->avg.load_avg + 1);

Same.

> @@ -7547,14 +7438,11 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
>  	if (!on_rq) {
>  		cfs_rq = cfs_rq_of(se);
>  		se->vruntime += cfs_rq->min_vruntime;
> +
>  #ifdef CONFIG_SMP
> -		/*
> -		 * migrate_task_rq_fair() will have removed our previous
> -		 * contribution, but we must synchronize for ongoing future
> -		 * decay.
> -		 */
> -		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
> -		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
> +		/* synchronize task with its new cfs_rq */
> +		__update_load_avg(cfs_rq->avg.last_update_time, &p->se.avg, 0);

This will incorrectly decay for any time delta between groups, it should
just be a set of last_update_time.
