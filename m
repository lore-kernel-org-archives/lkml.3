Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaEOHj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:39:29 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:64567 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaEOHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <1400101030-17717-4-git-send-email-nicolas.pitre@linaro.org>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org> <1400101030-17717-4-git-send-email-nicolas.pitre@linaro.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 15 May 2014 09:39:07 +0200
Message-ID: <CAKfTPtDueiEzqL_1kVvScvLvGmeNTMqX5mCU-2JdZ=Uth=nd-g@mail.gmail.com>
Subject: Re: [PATCH 3/6] sched/fair.c: disambiguate existing/remaining
 "capacity" usage
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 May 2014 22:57, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> We have "power" (which should actually become "capacity") and "capacity"
> which is a scaled down "capacity factor" in terms of possible tasks.
> Let's use "capa_factor" to make room for proper usage of "capacity"
> later.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> ---
>  kernel/sched/fair.c | 42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0eda4c527e..2633c42692 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5487,7 +5487,7 @@ struct sg_lb_stats {
>         unsigned long load_per_task;
>         unsigned long group_power;
>         unsigned int sum_nr_running; /* Nr tasks running in the group */
> -       unsigned int group_capacity;
> +       unsigned int group_capa_factor;

As it is mainly compared to sum_nr_running, you might rename it to
group_nr_capacity instead of group_capa_factor

>         unsigned int idle_cpus;
>         unsigned int group_weight;
>         int group_imb; /* Is there an imbalance in the group ? */
> @@ -5782,15 +5782,15 @@ static inline int sg_imbalanced(struct sched_group *group)
>  }
>
>  /*
> - * Compute the group capacity.
> + * Compute the group capacity factor.
>   *
>   * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
>   * first dividing out the smt factor and computing the actual number of cores
>   * and limit power unit capacity with that.
>   */
> -static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
> +static inline int sg_capa_factor(struct lb_env *env, struct sched_group *group)
>  {
> -       unsigned int capacity, smt, cpus;
> +       unsigned int capa_factor, smt, cpus;
>         unsigned int power, power_orig;
>
>         power = group->sgp->power;
> @@ -5799,13 +5799,13 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
>
>         /* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
>         smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);
> -       capacity = cpus / smt; /* cores */
> +       capa_factor = cpus / smt; /* cores */
>
> -       capacity = min_t(unsigned, capacity, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
> -       if (!capacity)
> -               capacity = fix_small_capacity(env->sd, group);
> +       capa_factor = min_t(unsigned, capa_factor, DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE));
> +       if (!capa_factor)
> +               capa_factor = fix_small_capacity(env->sd, group);
>
> -       return capacity;
> +       return capa_factor;
>  }
>
>  /**
> @@ -5855,9 +5855,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>         sgs->group_weight = group->group_weight;
>
>         sgs->group_imb = sg_imbalanced(group);
> -       sgs->group_capacity = sg_capacity(env, group);
> +       sgs->group_capa_factor = sg_capa_factor(env, group);
>
> -       if (sgs->group_capacity > sgs->sum_nr_running)
> +       if (sgs->group_capa_factor > sgs->sum_nr_running)
>                 sgs->group_has_free_capacity = 1;
>  }
>
> @@ -5882,7 +5882,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>         if (sgs->avg_load <= sds->busiest_stat.avg_load)
>                 return false;
>
> -       if (sgs->sum_nr_running > sgs->group_capacity)
> +       if (sgs->sum_nr_running > sgs->group_capa_factor)
>                 return true;
>
>         if (sgs->group_imb)
> @@ -5973,17 +5973,17 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>
>                 /*
>                  * In case the child domain prefers tasks go to siblings
> -                * first, lower the sg capacity to one so that we'll try
> +                * first, lower the sg capacity factor to one so that we'll try
>                  * and move all the excess tasks away. We lower the capacity
>                  * of a group only if the local group has the capacity to fit
> -                * these excess tasks, i.e. nr_running < group_capacity. The
> +                * these excess tasks, i.e. nr_running < group_capa_factor. The
>                  * extra check prevents the case where you always pull from the
>                  * heaviest group when it is already under-utilized (possible
>                  * with a large weight task outweighs the tasks on the system).
>                  */
>                 if (prefer_sibling && sds->local &&
>                     sds->local_stat.group_has_free_capacity)
> -                       sgs->group_capacity = min(sgs->group_capacity, 1U);
> +                       sgs->group_capa_factor = min(sgs->group_capa_factor, 1U);
>
>                 if (update_sd_pick_busiest(env, sds, sg, sgs)) {
>                         sds->busiest = sg;
> @@ -6157,7 +6157,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>                  * have to drop below capacity to reach cpu-load equilibrium.
>                  */
>                 load_above_capacity =
> -                       (busiest->sum_nr_running - busiest->group_capacity);
> +                       (busiest->sum_nr_running - busiest->group_capa_factor);
>
>                 load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
>                 load_above_capacity /= busiest->group_power;
> @@ -6301,7 +6301,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>         int i;
>
>         for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
> -               unsigned long power, capacity, wl;
> +               unsigned long power, capa_factor, wl;
>                 enum fbq_type rt;
>
>                 rq = cpu_rq(i);
> @@ -6330,9 +6330,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>                         continue;
>
>                 power = power_of(i);
> -               capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
> -               if (!capacity)
> -                       capacity = fix_small_capacity(env->sd, group);
> +               capa_factor = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
> +               if (!capa_factor)
> +                       capa_factor = fix_small_capacity(env->sd, group);
>
>                 wl = weighted_cpuload(i);
>
> @@ -6340,7 +6340,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>                  * When comparing with imbalance, use weighted_cpuload()
>                  * which is not scaled with the cpu power.
>                  */
> -               if (capacity && rq->nr_running == 1 && wl > env->imbalance)
> +               if (capa_factor && rq->nr_running == 1 && wl > env->imbalance)
>                         continue;
>
>                 /*
> --
> 1.8.4.108.g55ea5f6
>
