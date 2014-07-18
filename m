Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934595AbaGRJvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:51:37 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:58486 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934416AbaGRJvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com> <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 18 Jul 2014 11:43:00 +0200
Message-ID: <CAKfTPtAoer-c7Hynr-VhvF112MaoUybM8zhaQKrc+n0CJ3Z47g@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average tracking
To: Yuyang Du <yuyang.du@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 July 2014 01:26, Yuyang Du <yuyang.du@intel.com> wrote:
> The idea of per entity runnable load average (let runnable time contribute to load
> weight) was proposed by Paul Turner, and it is still followed by this rewrite. This
> rewrite is done due to the following ends:
>
> 1. cfs_rq's load average (namely runnable_load_avg and blocked_load_avg) is updated
>    at the granularity of one entity at one time, which results in the cfs_rq load
>    average is partially updated or asynchronous across its entities: at any time,
>    only one entity is up to date and contributes to the cfs_rq, all other entities
>    are effectively lagging behind.
>
> 2. cfs_rq load average is different between top rq->cfs_rq and other task_group's
>    per CPU cfs_rqs in whether or not blocked_load_average contributes to the load.
>
> 3. How task_group's load is calculated is complex.
>
> This rewrite tackles these by:
>
> 1. Combine runnable and blocked load averages for cfs_rq. And track cfs_rq's load
>    average as a whole and is used as such.
>
> 2. Track task entity load average for carrying it between CPUs in migration, group
>    cfs_rq and its own entity load averages are tracked for update_cfs_shares and
>    task_h_load calc. task_group's load_avg is aggregated from its per CPU cfs_rq's
>    load_avg, which is aggregated from its sched_entities (both task and group entity).
>    Group entity's weight is proportional to its own cfs_rq's load_avg / task_group's
>    load_avg.
>
> 3. All task, cfs_rq/group_entity, and task_group have simple, consistent, up-to-date,
>    and synchronized load_avg.
>
> This rewrite in principle is equivalent to the previous in functionality, but
> significantly reduces code coplexity and hence increases efficiency and clarity.
> In addition, the new load_avg is much more smooth/continuous (no abrupt jumping ups
> and downs) and decayed/updated more quickly and synchronously to reflect the load
> dynamic. As a result, we have less load tracking overhead and better performance.
>
> Signed-off-by: Yuyang Du <yuyang.du@intel.com>
> ---
>  include/linux/sched.h |   21 +-
>  kernel/sched/debug.c  |   22 +-
>  kernel/sched/fair.c   |  542 ++++++++++++++++---------------------------------
>  kernel/sched/proc.c   |    2 +-
>  kernel/sched/sched.h  |   20 +-
>  5 files changed, 203 insertions(+), 404 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 306f4f0..c981f26 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1067,16 +1067,21 @@ struct load_weight {
>         u32 inv_weight;
>  };
>
> +/*
> + * The load_avg represents an infinite geometric series. The 64 bit
> + * load_sum can:
> + * 1) for cfs_rq, afford 4353082796 (=2^64/47742/88761) entities with
> + * the highest weight (=88761) always runnable, we should not overflow
> + * 2) for entity, support any load.weight always runnable
> + */
>  struct sched_avg {
>         /*
> -        * These sums represent an infinite geometric series and so are bound
> -        * above by 1024/(1-y).  Thus we only need a u32 to store them for all
> -        * choices of y < 1-2^(-32)*1024.
> +        * The load_avg represents an infinite geometric series.
>          */
> -       u32 runnable_avg_sum, runnable_avg_period;
> -       u64 last_runnable_update;
> -       s64 decay_count;
> -       unsigned long load_avg_contrib;
> +       u64 last_update_time;
> +       u64 load_sum;
> +       unsigned long load_avg;
> +       u32 period_contrib;
>  };
>
>  #ifdef CONFIG_SCHEDSTATS
> @@ -1142,7 +1147,7 @@ struct sched_entity {
>  #endif
>
>  #ifdef CONFIG_SMP
> -       /* Per-entity load-tracking */
> +       /* Per entity load average tracking */
>         struct sched_avg        avg;
>  #endif
>  };
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 4b864c7..34a3f26 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -85,10 +85,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
>  #endif
>         P(se->load.weight);
>  #ifdef CONFIG_SMP
> -       P(se->avg.runnable_avg_sum);
> -       P(se->avg.runnable_avg_period);
> -       P(se->avg.load_avg_contrib);
> -       P(se->avg.decay_count);
> +       P(se->my_q->avg.load_avg);
>  #endif
>  #undef PN
>  #undef P
> @@ -205,19 +202,11 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>         SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
>         SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
>  #ifdef CONFIG_SMP
> -       SEQ_printf(m, "  .%-30s: %ld\n", "runnable_load_avg",
> -                       cfs_rq->runnable_load_avg);
> -       SEQ_printf(m, "  .%-30s: %ld\n", "blocked_load_avg",
> -                       cfs_rq->blocked_load_avg);
> +       SEQ_printf(m, "  .%-30s: %lu\n", "load_avg",
> +                       cfs_rq->avg.load_avg);
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -       SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_contrib",
> -                       cfs_rq->tg_load_contrib);
> -       SEQ_printf(m, "  .%-30s: %d\n", "tg_runnable_contrib",
> -                       cfs_rq->tg_runnable_contrib);
>         SEQ_printf(m, "  .%-30s: %ld\n", "tg_load_avg",
>                         atomic_long_read(&cfs_rq->tg->load_avg));
> -       SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
> -                       atomic_read(&cfs_rq->tg->runnable_avg));
>  #endif
>  #endif
>  #ifdef CONFIG_CFS_BANDWIDTH
> @@ -624,10 +613,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
>
>         P(se.load.weight);
>  #ifdef CONFIG_SMP
> -       P(se.avg.runnable_avg_sum);
> -       P(se.avg.runnable_avg_period);
> -       P(se.avg.load_avg_contrib);
> -       P(se.avg.decay_count);
> +       P(se.avg.load_avg);
>  #endif
>         P(policy);
>         P(prio);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1a2d04f..3055b9b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -282,9 +282,6 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
>         return grp->my_q;
>  }
>
> -static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
> -                                      int force_update);
> -
>  static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
>  {
>         if (!cfs_rq->on_list) {
> @@ -304,8 +301,6 @@ static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
>                 }
>
>                 cfs_rq->on_list = 1;
> -               /* We should have no load, but we need to update last_decay. */
> -               update_cfs_rq_blocked_load(cfs_rq, 0);
>         }
>  }
>
> @@ -665,20 +660,27 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  }
>
>  #ifdef CONFIG_SMP
> -static unsigned long task_h_load(struct task_struct *p);
>
> -static inline void __update_task_entity_contrib(struct sched_entity *se);
> +/* dependent on LOAD_AVG_PERIOD, see below */
> +#define LOAD_AVG_MAX 47742 /* maximum possible load avg */
> +
> +static unsigned long task_h_load(struct task_struct *p);
>
>  /* Give new task start runnable values to heavy its load in infant time */
>  void init_task_runnable_average(struct task_struct *p)
>  {
> -       u32 slice;
> +       struct sched_avg *sa = &p->se.avg;
>
> -       p->se.avg.decay_count = 0;
> -       slice = sched_slice(task_cfs_rq(p), &p->se) >> 10;
> -       p->se.avg.runnable_avg_sum = slice;
> -       p->se.avg.runnable_avg_period = slice;
> -       __update_task_entity_contrib(&p->se);
> +       sa->last_update_time = 0;
> +       /*
> +        * sched_avg's period_contrib should be strictly less then 1024, so
> +        * we give it 1023 to make sure it is almost a period (1024us), and
> +        * will definitely be update (after enqueue).
> +        */
> +       sa->period_contrib = 1023;
> +       sa->load_avg = p->se.load.weight;
> +       sa->load_sum = p->se.load.weight * LOAD_AVG_MAX;
> +       /* when this task enqueue'ed, it will contribute to its cfs_rq's load_avg */
>  }
>  #else
>  void init_task_runnable_average(struct task_struct *p)
> @@ -1504,8 +1506,8 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
>                 delta = runtime - p->last_sum_exec_runtime;
>                 *period = now - p->last_task_numa_placement;
>         } else {
> -               delta = p->se.avg.runnable_avg_sum;
> -               *period = p->se.avg.runnable_avg_period;
> +               delta = p->se.avg.load_avg / p->se.load.weight;
> +               *period = LOAD_AVG_MAX;
>         }
>
>         p->last_sum_exec_runtime = runtime;
> @@ -2071,13 +2073,9 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
>         long tg_weight;
>
>         /*
> -        * Use this CPU's actual weight instead of the last load_contribution
> -        * to gain a more accurate current total weight. See
> -        * update_cfs_rq_load_contribution().
> +        * Use this CPU's load average instead of actual weight
>          */
>         tg_weight = atomic_long_read(&tg->load_avg);
> -       tg_weight -= cfs_rq->tg_load_contrib;
> -       tg_weight += cfs_rq->load.weight;
>
>         return tg_weight;
>  }
> @@ -2087,7 +2085,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq, struct task_group *tg)
>         long tg_weight, load, shares;
>
>         tg_weight = calc_tg_weight(tg, cfs_rq);
> -       load = cfs_rq->load.weight;
> +       load = cfs_rq->avg.load_avg;
>
>         shares = (tg->shares * load);
>         if (tg_weight)
> @@ -2154,7 +2152,6 @@ static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
>   * Note: The tables below are dependent on this value.
>   */
>  #define LOAD_AVG_PERIOD 32
> -#define LOAD_AVG_MAX 47742 /* maximum possible load avg */
>  #define LOAD_AVG_MAX_N 345 /* number of full periods to produce LOAD_MAX_AVG */
>
>  /* Precomputed fixed inverse multiplies for multiplication by y^n */
> @@ -2181,7 +2178,7 @@ static const u32 runnable_avg_yN_sum[] = {
>   * Approximate:
>   *   val * y^n,    where y^32 ~= 0.5 (~1 scheduling period)
>   */
> -static __always_inline u64 decay_load(u64 val, u64 n)
> +static __always_inline u64 decay_load32(u64 val, u64 n)
>  {
>         unsigned int local_n;
>
> @@ -2210,6 +2207,18 @@ static __always_inline u64 decay_load(u64 val, u64 n)
>         return val >> 32;
>  }
>
> +static __always_inline u64 decay_load(u64 val, u64 n)
> +{
> +       if (likely(val <= UINT_MAX))
> +               val = decay_load32(val, n);
> +       else {
> +               val *= (u32)decay_load32(1 << 15, n);
> +               val >>= 15;
> +       }
> +
> +       return val;
> +}
> +
>  /*
>   * For updates fully spanning n periods, the contribution to runnable
>   * average will be: \Sum 1024*y^n
> @@ -2234,7 +2243,7 @@ static u32 __compute_runnable_contrib(u64 n)
>                 n -= LOAD_AVG_PERIOD;
>         } while (n > LOAD_AVG_PERIOD);
>
> -       contrib = decay_load(contrib, n);
> +       contrib = decay_load32(contrib, n);
>         return contrib + runnable_avg_yN_sum[n];
>  }
>
> @@ -2266,21 +2275,20 @@ static u32 __compute_runnable_contrib(u64 n)
>   *   load_avg = u_0` + y*(u_0 + u_1*y + u_2*y^2 + ... )
>   *            = u_0 + u_1*y + u_2*y^2 + ... [re-labeling u_i --> u_{i+1}]
>   */
> -static __always_inline int __update_entity_runnable_avg(u64 now,
> -                                                       struct sched_avg *sa,
> -                                                       int runnable)
> +static __always_inline int
> +__update_load_avg(u64 now, struct sched_avg *sa, unsigned long w)
>  {
>         u64 delta, periods;
> -       u32 runnable_contrib;
> +       u32 contrib;
>         int delta_w, decayed = 0;
>
> -       delta = now - sa->last_runnable_update;
> +       delta = now - sa->last_update_time;
>         /*
>          * This should only happen when time goes backwards, which it
>          * unfortunately does during sched clock init when we swap over to TSC.
>          */
>         if ((s64)delta < 0) {
> -               sa->last_runnable_update = now;
> +               sa->last_update_time = now;
>                 return 0;
>         }
>
> @@ -2291,23 +2299,24 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>         delta >>= 10;
>         if (!delta)
>                 return 0;
> -       sa->last_runnable_update = now;
> +       sa->last_update_time = now;
>
>         /* delta_w is the amount already accumulated against our next period */
> -       delta_w = sa->runnable_avg_period % 1024;
> +       delta_w = sa->period_contrib;
>         if (delta + delta_w >= 1024) {
> -               /* period roll-over */
>                 decayed = 1;
>
> +               /* how much left for next period will start over, we don't know yet */
> +               sa->period_contrib = 0;
> +
>                 /*
>                  * Now that we know we're crossing a period boundary, figure
>                  * out how much from delta we need to complete the current
>                  * period and accrue it.
>                  */
>                 delta_w = 1024 - delta_w;
> -               if (runnable)
> -                       sa->runnable_avg_sum += delta_w;
> -               sa->runnable_avg_period += delta_w;
> +               if (w)
> +                       sa->load_sum += w * delta_w;

Do you really need to have *w for computing the load_sum ? can't you
only use it when computing the load_avg ?

sa->load_avg = div_u64(sa->load_sum * w , LOAD_AVG_MAX)

>
>                 delta -= delta_w;
>
> @@ -2315,290 +2324,120 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>                 periods = delta / 1024;
>                 delta %= 1024;
>
> -               sa->runnable_avg_sum = decay_load(sa->runnable_avg_sum,
> -                                                 periods + 1);
> -               sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
> -                                                    periods + 1);
> +               sa->load_sum = decay_load(sa->load_sum, periods + 1);
>
>                 /* Efficiently calculate \sum (1..n_period) 1024*y^i */
> -               runnable_contrib = __compute_runnable_contrib(periods);
> -               if (runnable)
> -                       sa->runnable_avg_sum += runnable_contrib;
> -               sa->runnable_avg_period += runnable_contrib;
> +               contrib = __compute_runnable_contrib(periods);
> +               if (w)
> +                       sa->load_sum += w * contrib;
>         }
>
>         /* Remainder of delta accrued against u_0` */
> -       if (runnable)
> -               sa->runnable_avg_sum += delta;
> -       sa->runnable_avg_period += delta;
> +       if (w)
> +               sa->load_sum += w * delta;
>
> -       return decayed;
> -}
> +       sa->period_contrib += delta;
>
> -/* Synchronize an entity's decay with its parenting cfs_rq.*/
> -static inline u64 __synchronize_entity_decay(struct sched_entity *se)
> -{
> -       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> -       u64 decays = atomic64_read(&cfs_rq->decay_counter);
> +       if (decayed)
> +               sa->load_avg = div_u64(sa->load_sum, LOAD_AVG_MAX);
>
> -       decays -= se->avg.decay_count;
> -       if (!decays)
> -               return 0;
> -
> -       se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
> -       se->avg.decay_count = 0;
> -
> -       return decays;
> +       return decayed;
>  }
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
> -                                                int force_update)
> -{
> -       struct task_group *tg = cfs_rq->tg;
> -       long tg_contrib;
> -
> -       tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> -       tg_contrib -= cfs_rq->tg_load_contrib;
> -
> -       if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> -               atomic_long_add(tg_contrib, &tg->load_avg);
> -               cfs_rq->tg_load_contrib += tg_contrib;
> -       }
> -}
> -
>  /*
> - * Aggregate cfs_rq runnable averages into an equivalent task_group
> - * representation for computing load contributions.
> + * Updating tg's load_avg is only necessary before it is used in
> + * update_cfs_share (which is done) and effective_load (which is
> + * not done because it is too costly).
>   */
> -static inline void __update_tg_runnable_avg(struct sched_avg *sa,
> -                                                 struct cfs_rq *cfs_rq)
> -{
> -       struct task_group *tg = cfs_rq->tg;
> -       long contrib;
> -
> -       /* The fraction of a cpu used by this cfs_rq */
> -       contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
> -                         sa->runnable_avg_period + 1);
> -       contrib -= cfs_rq->tg_runnable_contrib;
> -
> -       if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
> -               atomic_add(contrib, &tg->runnable_avg);
> -               cfs_rq->tg_runnable_contrib += contrib;
> -       }
> -}
> -
> -static inline void __update_group_entity_contrib(struct sched_entity *se)
> +static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
>  {
> -       struct cfs_rq *cfs_rq = group_cfs_rq(se);
> -       struct task_group *tg = cfs_rq->tg;
> -       int runnable_avg;
> -
> -       u64 contrib;
> -
> -       contrib = cfs_rq->tg_load_contrib * tg->shares;
> -       se->avg.load_avg_contrib = div_u64(contrib,
> -                                    atomic_long_read(&tg->load_avg) + 1);
> +       long delta = cfs_rq->avg.load_avg - cfs_rq->tg_load_avg_contrib;
>
> -       /*
> -        * For group entities we need to compute a correction term in the case
> -        * that they are consuming <1 cpu so that we would contribute the same
> -        * load as a task of equal weight.
> -        *
> -        * Explicitly co-ordinating this measurement would be expensive, but
> -        * fortunately the sum of each cpus contribution forms a usable
> -        * lower-bound on the true value.
> -        *
> -        * Consider the aggregate of 2 contributions.  Either they are disjoint
> -        * (and the sum represents true value) or they are disjoint and we are
> -        * understating by the aggregate of their overlap.
> -        *
> -        * Extending this to N cpus, for a given overlap, the maximum amount we
> -        * understand is then n_i(n_i+1)/2 * w_i where n_i is the number of
> -        * cpus that overlap for this interval and w_i is the interval width.
> -        *
> -        * On a small machine; the first term is well-bounded which bounds the
> -        * total error since w_i is a subset of the period.  Whereas on a
> -        * larger machine, while this first term can be larger, if w_i is the
> -        * of consequential size guaranteed to see n_i*w_i quickly converge to
> -        * our upper bound of 1-cpu.
> -        */
> -       runnable_avg = atomic_read(&tg->runnable_avg);
> -       if (runnable_avg < NICE_0_LOAD) {
> -               se->avg.load_avg_contrib *= runnable_avg;
> -               se->avg.load_avg_contrib >>= NICE_0_SHIFT;
> +       if (delta) {
> +               atomic_long_add(delta, &cfs_rq->tg->load_avg);
> +               cfs_rq->tg_load_avg_contrib = cfs_rq->avg.load_avg;
>         }
>  }
>
>  #else /* CONFIG_FAIR_GROUP_SCHED */
> -static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
> -                                                int force_update) {}
> -static inline void __update_tg_runnable_avg(struct sched_avg *sa,
> -                                                 struct cfs_rq *cfs_rq) {}
> -static inline void __update_group_entity_contrib(struct sched_entity *se) {}
> +static inline void update_tg_load_avg(struct cfs_rq *cfs_rq) {}
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>
> -static inline void __update_task_entity_contrib(struct sched_entity *se)
> -{
> -       u32 contrib;
> +static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
>
> -       /* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
> -       contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
> -       contrib /= (se->avg.runnable_avg_period + 1);
> -       se->avg.load_avg_contrib = scale_load(contrib);
> -}
> +#define subtract_until_zero(minuend, subtrahend)       \
> +       (subtrahend < minuend ? minuend - subtrahend : 0)
>
> -/* Compute the current contribution to load_avg by se, return any delta */
> -static long __update_entity_load_avg_contrib(struct sched_entity *se)
> +/*
> + * Group cfs_rq's load_avg is used for task_h_load and update_cfs_share
> + * calc.
> + */
> +static inline int update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
>  {
> -       long old_contrib = se->avg.load_avg_contrib;
> +       int decayed;
>
> -       if (entity_is_task(se)) {
> -               __update_task_entity_contrib(se);
> -       } else {
> -               __update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
> -               __update_group_entity_contrib(se);
> +       if (atomic_long_read(&cfs_rq->removed_load_avg)) {
> +               long r = atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
> +               cfs_rq->avg.load_avg = subtract_until_zero(cfs_rq->avg.load_avg, r);
> +               r *= LOAD_AVG_MAX;
> +               cfs_rq->avg.load_sum = subtract_until_zero(cfs_rq->avg.load_sum, r);
>         }
>
> -       return se->avg.load_avg_contrib - old_contrib;
> -}
> +       decayed = __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
>
> -static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
> -                                                long load_contrib)
> -{
> -       if (likely(load_contrib < cfs_rq->blocked_load_avg))
> -               cfs_rq->blocked_load_avg -= load_contrib;
> -       else
> -               cfs_rq->blocked_load_avg = 0;
> -}
> +#ifndef CONFIG_64BIT
> +       if (cfs_rq->avg.last_update_time != cfs_rq->load_last_update_time_copy) {
> +               smp_wmb();
> +               cfs_rq->load_last_update_time_copy = cfs_rq->avg.last_update_time;
> +       }
> +#endif
>
> -static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
> +       return decayed;
> +}
>
> -/* Update a sched_entity's runnable average */
> -static inline void update_entity_load_avg(struct sched_entity *se,
> -                                         int update_cfs_rq)
> +/* Update task and its cfs_rq load average */
> +static inline void update_load_avg(struct sched_entity *se, int update_tg)
>  {
>         struct cfs_rq *cfs_rq = cfs_rq_of(se);
> -       long contrib_delta;
> -       u64 now;
> +       u64 now = cfs_rq_clock_task(cfs_rq);
>
>         /*
> -        * For a group entity we need to use their owned cfs_rq_clock_task() in
> -        * case they are the parent of a throttled hierarchy.
> +        * Track task load average for carrying it to new CPU after migrated,
> +        * and group sched_entity for task_h_load calc in migration
>          */
> -       if (entity_is_task(se))
> -               now = cfs_rq_clock_task(cfs_rq);
> -       else
> -               now = cfs_rq_clock_task(group_cfs_rq(se));
> -
> -       if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
> -               return;
> -
> -       contrib_delta = __update_entity_load_avg_contrib(se);
> +       __update_load_avg(now, &se->avg, se->on_rq * se->load.weight);
>
> -       if (!update_cfs_rq)
> -               return;
> -
> -       if (se->on_rq)
> -               cfs_rq->runnable_load_avg += contrib_delta;
> -       else
> -               subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
> +       if (update_cfs_rq_load_avg(now, cfs_rq) && update_tg)
> +               update_tg_load_avg(cfs_rq);
>  }
>
> -/*
> - * Decay the load contributed by all blocked children and account this so that
> - * their contribution may appropriately discounted when they wake up.
> - */
> -static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
> +/* Add the load generated by se into cfs_rq's load average */
> +static inline void enqueue_entity_load_avg(struct sched_entity *se)
>  {
> -       u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
> -       u64 decays;
> -
> -       decays = now - cfs_rq->last_decay;
> -       if (!decays && !force_update)
> -               return;
> +       struct sched_avg *sa = &se->avg;
> +       struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +       u64 now = cfs_rq_clock_task(cfs_rq);
> +       int migrated = 0, decayed;
>
> -       if (atomic_long_read(&cfs_rq->removed_load)) {
> -               unsigned long removed_load;
> -               removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
> -               subtract_blocked_load_contrib(cfs_rq, removed_load);
> -       }
> +       if (sa->last_update_time == 0) {
> +               sa->last_update_time = now;
>
> -       if (decays) {
> -               cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
> -                                                     decays);
> -               atomic64_add(decays, &cfs_rq->decay_counter);
> -               cfs_rq->last_decay = now;
> +               if (entity_is_task(se))
> +                       migrated = 1;
>         }
> +       else
> +               __update_load_avg(now, sa, se->on_rq * se->load.weight);
>
> -       __update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
> -}
> -
> -/* Add the load generated by se into cfs_rq's child load-average */
> -static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
> -                                                 struct sched_entity *se,
> -                                                 int wakeup)
> -{
> -       /*
> -        * We track migrations using entity decay_count <= 0, on a wake-up
> -        * migration we use a negative decay count to track the remote decays
> -        * accumulated while sleeping.
> -        *
> -        * Newly forked tasks are enqueued with se->avg.decay_count == 0, they
> -        * are seen by enqueue_entity_load_avg() as a migration with an already
> -        * constructed load_avg_contrib.
> -        */
> -       if (unlikely(se->avg.decay_count <= 0)) {
> -               se->avg.last_runnable_update = rq_clock_task(rq_of(cfs_rq));
> -               if (se->avg.decay_count) {
> -                       /*
> -                        * In a wake-up migration we have to approximate the
> -                        * time sleeping.  This is because we can't synchronize
> -                        * clock_task between the two cpus, and it is not
> -                        * guaranteed to be read-safe.  Instead, we can
> -                        * approximate this using our carried decays, which are
> -                        * explicitly atomically readable.
> -                        */
> -                       se->avg.last_runnable_update -= (-se->avg.decay_count)
> -                                                       << 20;
> -                       update_entity_load_avg(se, 0);
> -                       /* Indicate that we're now synchronized and on-rq */
> -                       se->avg.decay_count = 0;
> -               }
> -               wakeup = 0;
> -       } else {
> -               __synchronize_entity_decay(se);
> -       }
> +       decayed = update_cfs_rq_load_avg(now, cfs_rq);
>
> -       /* migrated tasks did not contribute to our blocked load */
> -       if (wakeup) {
> -               subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
> -               update_entity_load_avg(se, 0);
> +       if (migrated) {
> +               cfs_rq->avg.load_avg += sa->load_avg;
> +               cfs_rq->avg.load_sum += sa->load_sum;
>         }
>
> -       cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
> -       /* we force update consideration on load-balancer moves */
> -       update_cfs_rq_blocked_load(cfs_rq, !wakeup);
> -}
> -
> -/*
> - * Remove se's load from this cfs_rq child load-average, if the entity is
> - * transitioning to a blocked state we track its projected decay using
> - * blocked_load_avg.
> - */
> -static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
> -                                                 struct sched_entity *se,
> -                                                 int sleep)
> -{
> -       update_entity_load_avg(se, 1);
> -       /* we force update consideration on load-balancer moves */
> -       update_cfs_rq_blocked_load(cfs_rq, !sleep);
> -
> -       cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
> -       if (sleep) {
> -               cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
> -               se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
> -       } /* migrations, e.g. sleep=0 leave decay_count == 0 */
> +       if (decayed || migrated)
> +               update_tg_load_avg(cfs_rq);
>  }
>
>  /*
> @@ -2623,16 +2462,8 @@ static int idle_balance(struct rq *this_rq);
>
>  #else /* CONFIG_SMP */
>
> -static inline void update_entity_load_avg(struct sched_entity *se,
> -                                         int update_cfs_rq) {}
> -static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
> -                                          struct sched_entity *se,
> -                                          int wakeup) {}
> -static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
> -                                          struct sched_entity *se,
> -                                          int sleep) {}
> -static inline void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
> -                                             int force_update) {}
> +static inline void update_load_avg(struct sched_entity *se, int update_tg) {}
> +static inline void enqueue_entity_load_avg(struct sched_entity *se) {}
>
>  static inline int idle_balance(struct rq *rq)
>  {
> @@ -2764,7 +2595,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>          * Update run-time statistics of the 'current'.
>          */
>         update_curr(cfs_rq);
> -       enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
> +       enqueue_entity_load_avg(se);
>         account_entity_enqueue(cfs_rq, se);
>         update_cfs_shares(cfs_rq);
>
> @@ -2839,7 +2670,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>          * Update run-time statistics of the 'current'.
>          */
>         update_curr(cfs_rq);
> -       dequeue_entity_load_avg(cfs_rq, se, flags & DEQUEUE_SLEEP);
> +
> +       update_load_avg(se, 1);
>
>         update_stats_dequeue(cfs_rq, se);
>         if (flags & DEQUEUE_SLEEP) {
> @@ -3028,7 +2860,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
>                 /* Put 'current' back into the tree. */
>                 __enqueue_entity(cfs_rq, prev);
>                 /* in !on_rq case, update occurred at dequeue */
> -               update_entity_load_avg(prev, 1);
> +               update_load_avg(prev, 0);
>         }
>         cfs_rq->curr = NULL;
>  }
> @@ -3044,8 +2876,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>         /*
>          * Ensure that runnable average is periodically updated.
>          */
> -       update_entity_load_avg(curr, 1);
> -       update_cfs_rq_blocked_load(cfs_rq, 1);
> +       update_load_avg(curr, 1);
>         update_cfs_shares(cfs_rq);
>
>  #ifdef CONFIG_SCHED_HRTICK
> @@ -3923,8 +3754,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>                 if (cfs_rq_throttled(cfs_rq))
>                         break;
>
> +               update_load_avg(se, 1);
>                 update_cfs_shares(cfs_rq);
> -               update_entity_load_avg(se, 1);
>         }
>
>         if (!se)
> @@ -3983,8 +3814,8 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>                 if (cfs_rq_throttled(cfs_rq))
>                         break;
>
> +               update_load_avg(se, 1);
>                 update_cfs_shares(cfs_rq);
> -               update_entity_load_avg(se, 1);
>         }
>
>         if (!se)
> @@ -3997,7 +3828,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
>  {
> -       return cpu_rq(cpu)->cfs.runnable_load_avg;
> +       return cpu_rq(cpu)->cfs.avg.load_avg;
>  }
>
>  /*
> @@ -4042,7 +3873,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>  {
>         struct rq *rq = cpu_rq(cpu);
>         unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
> -       unsigned long load_avg = rq->cfs.runnable_load_avg;
> +       unsigned long load_avg = rq->cfs.avg.load_avg;
>
>         if (nr_running)
>                 return load_avg / nr_running;
> @@ -4161,7 +3992,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>                 /*
>                  * w = rw_i + @wl
>                  */
> -               w = se->my_q->load.weight + wl;
> +               w = se->my_q->avg.load_avg + wl;
>
>                 /*
>                  * wl = S * s'_i; see (2)
> @@ -4182,7 +4013,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>                 /*
>                  * wl = dw_i = S * (s'_i - s_i); see (3)
>                  */
> -               wl -= se->load.weight;
> +               wl -= se->avg.load_avg;
>
>                 /*
>                  * Recursively apply this logic to all parent groups to compute
> @@ -4256,14 +4087,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>          */
>         if (sync) {
>                 tg = task_group(current);
> -               weight = current->se.load.weight;
> +               weight = current->se.avg.load_avg;
>
>                 this_load += effective_load(tg, this_cpu, -weight, -weight);
>                 load += effective_load(tg, prev_cpu, 0, -weight);
>         }
>
>         tg = task_group(p);
> -       weight = p->se.load.weight;
> +       weight = p->se.avg.load_avg;
>
>         /*
>          * In low-load situations, where prev_cpu is idle and this_cpu is idle
> @@ -4551,18 +4382,34 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>  {
>         struct sched_entity *se = &p->se;
>         struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +       u64 last_update_time;
>
>         /*
> -        * Load tracking: accumulate removed load so that it can be processed
> -        * when we next update owning cfs_rq under rq->lock.  Tasks contribute
> -        * to blocked load iff they have a positive decay-count.  It can never
> -        * be negative here since on-rq tasks have decay-count == 0.
> +        * Task on old CPU catches up with its old cfs_rq, and subtract itself from
> +        * the cfs_rq (task must be off the queue now).
>          */
> -       if (se->avg.decay_count) {
> -               se->avg.decay_count = -__synchronize_entity_decay(se);
> -               atomic_long_add(se->avg.load_avg_contrib,
> -                                               &cfs_rq->removed_load);
> -       }
> +#ifndef CONFIG_64BIT
> +       u64 last_update_time_copy;
> +
> +       do {
> +               last_update_time_copy = cfs_rq->load_last_update_time_copy;
> +               smp_rmb();
> +               last_update_time = cfs_rq->avg.last_update_time;
> +       } while (last_update_time != last_update_time_copy);
> +#else
> +       last_update_time = cfs_rq->avg.last_update_time;
> +#endif
> +       __update_load_avg(last_update_time, &se->avg, 0);
> +       atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
> +
> +       /*
> +        * We are supposed to update the task to "current" time, then its up to date
> +        * and ready to go to new CPU/cfs_rq. But we have difficulty in getting
> +        * what current time is, so simply throw away the out-of-date time. This
> +        * will result in the wakee task is less decayed, but giving the wakee more
> +        * load sounds not bad.
> +        */
> +       se->avg.last_update_time = 0;
>
>         /* We have migrated, no longer consider this task hot */
>         se->exec_start = 0;
> @@ -5399,36 +5246,6 @@ next:
>  }
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -/*
> - * update tg->load_weight by folding this cpu's load_avg
> - */
> -static void __update_blocked_averages_cpu(struct task_group *tg, int cpu)
> -{
> -       struct sched_entity *se = tg->se[cpu];
> -       struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
> -
> -       /* throttled entities do not contribute to load */
> -       if (throttled_hierarchy(cfs_rq))
> -               return;
> -
> -       update_cfs_rq_blocked_load(cfs_rq, 1);
> -
> -       if (se) {
> -               update_entity_load_avg(se, 1);
> -               /*
> -                * We pivot on our runnable average having decayed to zero for
> -                * list removal.  This generally implies that all our children
> -                * have also been removed (modulo rounding error or bandwidth
> -                * control); however, such cases are rare and we can fix these
> -                * at enqueue.
> -                *
> -                * TODO: fix up out-of-order children on enqueue.
> -                */
> -               if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
> -                       list_del_leaf_cfs_rq(cfs_rq);
> -       }
> -}
> -
>  static void update_blocked_averages(int cpu)
>  {
>         struct rq *rq = cpu_rq(cpu);
> @@ -5437,17 +5254,17 @@ static void update_blocked_averages(int cpu)
>
>         raw_spin_lock_irqsave(&rq->lock, flags);
>         update_rq_clock(rq);
> +
>         /*
>          * Iterates the task_group tree in a bottom up fashion, see
>          * list_add_leaf_cfs_rq() for details.
>          */
>         for_each_leaf_cfs_rq(rq, cfs_rq) {
> -               /*
> -                * Note: We may want to consider periodically releasing
> -                * rq->lock about these updates so that creating many task
> -                * groups does not result in continually extending hold time.
> -                */
> -               __update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
> +               /* throttled entities do not contribute to load */
> +               if (throttled_hierarchy(cfs_rq))
> +                       continue;
> +
> +               update_cfs_rq_load_avg(cfs_rq_clock_task(cfs_rq), cfs_rq);
>         }
>
>         raw_spin_unlock_irqrestore(&rq->lock, flags);
> @@ -5477,14 +5294,14 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
>         }
>
>         if (!se) {
> -               cfs_rq->h_load = cfs_rq->runnable_load_avg;
> +               cfs_rq->h_load = cfs_rq->avg.load_avg;
>                 cfs_rq->last_h_load_update = now;
>         }
>
>         while ((se = cfs_rq->h_load_next) != NULL) {
>                 load = cfs_rq->h_load;
> -               load = div64_ul(load * se->avg.load_avg_contrib,
> -                               cfs_rq->runnable_load_avg + 1);
> +               load = div64_ul(load * se->avg.load_avg,
> +                               cfs_rq->avg.load_avg + 1);
>                 cfs_rq = group_cfs_rq(se);
>                 cfs_rq->h_load = load;
>                 cfs_rq->last_h_load_update = now;
> @@ -5496,8 +5313,8 @@ static unsigned long task_h_load(struct task_struct *p)
>         struct cfs_rq *cfs_rq = task_cfs_rq(p);
>
>         update_cfs_rq_h_load(cfs_rq);
> -       return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
> -                       cfs_rq->runnable_load_avg + 1);
> +       return div64_ul(p->se.avg.load_avg * cfs_rq->h_load,
> +                       cfs_rq->avg.load_avg + 1);
>  }
>  #else
>  static inline void update_blocked_averages(int cpu)
> @@ -5506,7 +5323,7 @@ static inline void update_blocked_averages(int cpu)
>
>  static unsigned long task_h_load(struct task_struct *p)
>  {
> -       return p->se.avg.load_avg_contrib;
> +       return p->se.avg.load_avg;
>  }
>  #endif
>
> @@ -7437,14 +7254,14 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
>
>  #ifdef CONFIG_SMP
>         /*
> -       * Remove our load from contribution when we leave sched_fair
> -       * and ensure we don't carry in an old decay_count if we
> -       * switch back.
> +       * Remove our load from contribution when we leave cfs_rq.
>         */
> -       if (se->avg.decay_count) {
> -               __synchronize_entity_decay(se);
> -               subtract_blocked_load_contrib(cfs_rq, se->avg.load_avg_contrib);
> -       }
> +       __update_load_avg(cfs_rq->avg.last_update_time, &se->avg,
> +               se->on_rq * se->load.weight);
> +       cfs_rq->avg.load_avg =
> +               subtract_until_zero(cfs_rq->avg.load_avg, se->avg.load_avg);
> +       cfs_rq->avg.load_sum =
> +               subtract_until_zero(cfs_rq->avg.load_sum, se->avg.load_sum);
>  #endif
>  }
>
> @@ -7501,8 +7318,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
>         cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
>  #endif
>  #ifdef CONFIG_SMP
> -       atomic64_set(&cfs_rq->decay_counter, 1);
> -       atomic_long_set(&cfs_rq->removed_load, 0);
> +       atomic_long_set(&cfs_rq->removed_load_avg, 0);
>  #endif
>  }
>
> @@ -7547,14 +7363,12 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
>         if (!on_rq) {
>                 cfs_rq = cfs_rq_of(se);
>                 se->vruntime += cfs_rq->min_vruntime;
> +
>  #ifdef CONFIG_SMP
> -               /*
> -                * migrate_task_rq_fair() will have removed our previous
> -                * contribution, but we must synchronize for ongoing future
> -                * decay.
> -                */
> -               se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
> -               cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
> +               /* Virtually synchronize task with its new cfs_rq */
> +               p->se.avg.last_update_time = cfs_rq->avg.last_update_time;
> +               cfs_rq->avg.load_avg += p->se.avg.load_avg;
> +               cfs_rq->avg.load_sum += p->se.avg.load_sum;
>  #endif
>         }
>  }
> diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
> index 16f5a30..8f547fe 100644
> --- a/kernel/sched/proc.c
> +++ b/kernel/sched/proc.c
> @@ -504,7 +504,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  #ifdef CONFIG_SMP
>  static inline unsigned long get_rq_runnable_load(struct rq *rq)
>  {
> -       return rq->cfs.runnable_load_avg;
> +       return rq->cfs.avg.load_avg;
>  }
>  #else
>  static inline unsigned long get_rq_runnable_load(struct rq *rq)
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index a147571..7c8c2a9 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -210,7 +210,6 @@ struct task_group {
>
>  #ifdef CONFIG_SMP
>         atomic_long_t load_avg;
> -       atomic_t runnable_avg;
>  #endif
>  #endif
>
> @@ -331,21 +330,16 @@ struct cfs_rq {
>
>  #ifdef CONFIG_SMP
>         /*
> -        * CFS Load tracking
> -        * Under CFS, load is tracked on a per-entity basis and aggregated up.
> -        * This allows for the description of both thread and group usage (in
> -        * the FAIR_GROUP_SCHED case).
> +        * CFS load tracking
>          */
> -       unsigned long runnable_load_avg, blocked_load_avg;
> -       atomic64_t decay_counter;
> -       u64 last_decay;
> -       atomic_long_t removed_load;
> +       struct sched_avg avg;
> +       unsigned long tg_load_avg_contrib;
> +       atomic_long_t removed_load_avg;
> +#ifndef CONFIG_64BIT
> +       u64 load_last_update_time_copy;
> +#endif
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -       /* Required to track per-cpu representation of a task_group */
> -       u32 tg_runnable_contrib;
> -       unsigned long tg_load_contrib;
> -
>         /*
>          *   h_load = weight * f(tg)
>          *
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
