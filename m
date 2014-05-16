Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbaEPJBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:01:01 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34711 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbaEPJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:00:58 -0400
MIME-Version: 1.0
In-Reply-To: <1400101030-17717-6-git-send-email-nicolas.pitre@linaro.org>
References: <1400101030-17717-1-git-send-email-nicolas.pitre@linaro.org>
	<1400101030-17717-6-git-send-email-nicolas.pitre@linaro.org>
Date: Fri, 16 May 2014 14:30:57 +0530
Message-ID: <CAM4v1pNpc+dpEd4KZ3k-uTxsu01gKBtusNvppaHeMdvdzf_i+Q@mail.gmail.com>
Subject: Re: [PATCH 5/6] sched: remove remaining power to the CPU
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,
You might want to change the subject.

s/sched: remove remaining power to the CPU/
sched: remove remaining usage of cpu *power* .

The subject has to explicitly specify in some way
that it is a change made to the terminology.

Regards
Preeti U Murthy



On Thu, May 15, 2014 at 2:27 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> It is better not to think about compute capacity as being equivalent to
> "CPU power".  The upcoming "power aware" scheduler may create confusion
> with the notion of energy consumption if "power" is used too liberally.
>
> This is the remaining "power" -> "capacity" rename.  Those symbols
> visible to the rest of the kernel are not included yet.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
> ---
>  kernel/sched/core.c  |   6 +--
>  kernel/sched/fair.c  | 102 +++++++++++++++++++++++++--------------------------
>  kernel/sched/sched.h |   2 +-
>  3 files changed, 55 insertions(+), 55 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index d8ba3ab1c0..00d04e9e7b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5764,7 +5764,7 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
>  /*
>   * build_sched_groups will build a circular linked list of the groups
>   * covered by the given span, and will set each group's ->cpumask correctly,
> - * and ->cpu_power to 0.
> + * and ->cpu_capacity to 0.
>   *
>   * Assumes the sched_domain tree is fully constructed
>   */
> @@ -6473,7 +6473,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
>                 }
>         }
>
> -       /* Calculate CPU power for physical packages and nodes */
> +       /* Calculate CPU capacity for physical packages and nodes */
>         for (i = nr_cpumask_bits-1; i >= 0; i--) {
>                 if (!cpumask_test_cpu(i, cpu_map))
>                         continue;
> @@ -6923,7 +6923,7 @@ void __init sched_init(void)
>  #ifdef CONFIG_SMP
>                 rq->sd = NULL;
>                 rq->rd = NULL;
> -               rq->cpu_power = SCHED_POWER_SCALE;
> +               rq->cpu_capacity = SCHED_POWER_SCALE;
>                 rq->post_schedule = 0;
>                 rq->active_balance = 0;
>                 rq->next_balance = jiffies;
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6bc1e54d30..06619b52dd 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1017,7 +1017,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
>  static unsigned long weighted_cpuload(const int cpu);
>  static unsigned long source_load(int cpu, int type);
>  static unsigned long target_load(int cpu, int type);
> -static unsigned long power_of(int cpu);
> +static unsigned long capacity_of(int cpu);
>  static long effective_load(struct task_group *tg, int cpu, long wl, long wg);
>
>  /* Cached statistics for all CPUs within a node */
> @@ -1046,7 +1046,7 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
>
>                 ns->nr_running += rq->nr_running;
>                 ns->load += weighted_cpuload(cpu);
> -               ns->compute_capacity += power_of(cpu);
> +               ns->compute_capacity += capacity_of(cpu);
>
>                 cpus++;
>         }
> @@ -1185,7 +1185,7 @@ balance:
>         dst_load = env->dst_stats.load;
>         src_load = env->src_stats.load;
>
> -       /* XXX missing power terms */
> +       /* XXX missing capacity terms */
>         load = task_h_load(env->p);
>         dst_load += load;
>         src_load -= load;
> @@ -4015,9 +4015,9 @@ static unsigned long target_load(int cpu, int type)
>         return max(rq->cpu_load[type-1], total);
>  }
>
> -static unsigned long power_of(int cpu)
> +static unsigned long capacity_of(int cpu)
>  {
> -       return cpu_rq(cpu)->cpu_power;
> +       return cpu_rq(cpu)->cpu_capacity;
>  }
>
>  static unsigned long cpu_avg_load_per_task(int cpu)
> @@ -4260,12 +4260,12 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>                 s64 this_eff_load, prev_eff_load;
>
>                 this_eff_load = 100;
> -               this_eff_load *= power_of(prev_cpu);
> +               this_eff_load *= capacity_of(prev_cpu);
>                 this_eff_load *= this_load +
>                         effective_load(tg, this_cpu, weight, weight);
>
>                 prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
> -               prev_eff_load *= power_of(this_cpu);
> +               prev_eff_load *= capacity_of(this_cpu);
>                 prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
>
>                 balanced = this_eff_load <= prev_eff_load;
> @@ -4919,14 +4919,14 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
>   *
>   *   W'_i,n = (2^n - 1) / 2^n * W_i,n + 1 / 2^n * W_i,0               (3)
>   *
> - * P_i is the cpu power (or compute capacity) of cpu i, typically it is the
> + * C_i is the compute capacity of cpu i, typically it is the
>   * fraction of 'recent' time available for SCHED_OTHER task execution. But it
>   * can also include other factors [XXX].
>   *
>   * To achieve this balance we define a measure of imbalance which follows
>   * directly from (1):
>   *
> - *   imb_i,j = max{ avg(W/P), W_i/P_i } - min{ avg(W/P), W_j/P_j }    (4)
> + *   imb_i,j = max{ avg(W/C), W_i/C_i } - min{ avg(W/C), W_j/C_j }    (4)
>   *
>   * We them move tasks around to minimize the imbalance. In the continuous
>   * function space it is obvious this converges, in the discrete case we get
> @@ -5560,17 +5560,17 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
>         return load_idx;
>  }
>
> -static unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
> +static unsigned long default_scale_capacity(struct sched_domain *sd, int cpu)
>  {
>         return SCHED_POWER_SCALE;
>  }
>
>  unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
>  {
> -       return default_scale_freq_power(sd, cpu);
> +       return default_scale_capacity(sd, cpu);
>  }
>
> -static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
> +static unsigned long default_scale_smt_capacity(struct sched_domain *sd, int cpu)
>  {
>         unsigned long weight = sd->span_weight;
>         unsigned long smt_gain = sd->smt_gain;
> @@ -5582,10 +5582,10 @@ static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
>
>  unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
>  {
> -       return default_scale_smt_power(sd, cpu);
> +       return default_scale_smt_capacity(sd, cpu);
>  }
>
> -static unsigned long scale_rt_power(int cpu)
> +static unsigned long scale_rt_capacity(int cpu)
>  {
>         struct rq *rq = cpu_rq(cpu);
>         u64 total, available, age_stamp, avg;
> @@ -5605,7 +5605,7 @@ static unsigned long scale_rt_power(int cpu)
>         total = sched_avg_period() + delta;
>
>         if (unlikely(total < avg)) {
> -               /* Ensures that power won't end up being negative */
> +               /* Ensures that capacity won't end up being negative */
>                 available = 0;
>         } else {
>                 available = total - avg;
> @@ -5619,38 +5619,38 @@ static unsigned long scale_rt_power(int cpu)
>         return div_u64(available, total);
>  }
>
> -static void update_cpu_power(struct sched_domain *sd, int cpu)
> +static void update_cpu_capacity(struct sched_domain *sd, int cpu)
>  {
>         unsigned long weight = sd->span_weight;
> -       unsigned long power = SCHED_POWER_SCALE;
> +       unsigned long capacity = SCHED_POWER_SCALE;
>         struct sched_group *sdg = sd->groups;
>
>         if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
>                 if (sched_feat(ARCH_POWER))
> -                       power *= arch_scale_smt_power(sd, cpu);
> +                       capacity *= arch_scale_smt_power(sd, cpu);
>                 else
> -                       power *= default_scale_smt_power(sd, cpu);
> +                       capacity *= default_scale_smt_capacity(sd, cpu);
>
> -               power >>= SCHED_POWER_SHIFT;
> +               capacity >>= SCHED_POWER_SHIFT;
>         }
>
> -       sdg->sgc->capacity_orig = power;
> +       sdg->sgc->capacity_orig = capacity;
>
>         if (sched_feat(ARCH_POWER))
> -               power *= arch_scale_freq_power(sd, cpu);
> +               capacity *= arch_scale_freq_power(sd, cpu);
>         else
> -               power *= default_scale_freq_power(sd, cpu);
> +               capacity *= default_scale_capacity(sd, cpu);
>
> -       power >>= SCHED_POWER_SHIFT;
> +       capacity >>= SCHED_POWER_SHIFT;
>
> -       power *= scale_rt_power(cpu);
> -       power >>= SCHED_POWER_SHIFT;
> +       capacity *= scale_rt_capacity(cpu);
> +       capacity >>= SCHED_POWER_SHIFT;
>
> -       if (!power)
> -               power = 1;
> +       if (!capacity)
> +               capacity = 1;
>
> -       cpu_rq(cpu)->cpu_power = power;
> -       sdg->sgc->capacity = power;
> +       cpu_rq(cpu)->cpu_capacity = capacity;
> +       sdg->sgc->capacity = capacity;
>  }
>
>  void update_group_capacity(struct sched_domain *sd, int cpu)
> @@ -5665,7 +5665,7 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
>         sdg->sgc->next_update = jiffies + interval;
>
>         if (!child) {
> -               update_cpu_power(sd, cpu);
> +               update_cpu_capacity(sd, cpu);
>                 return;
>         }
>
> @@ -5686,8 +5686,8 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
>                          * gets here before we've attached the domains to the
>                          * runqueues.
>                          *
> -                        * Use power_of(), which is set irrespective of domains
> -                        * in update_cpu_power().
> +                        * Use capacity_of(), which is set irrespective of domains
> +                        * in update_cpu_capacity().
>                          *
>                          * This avoids capacity/capacity_orig from being 0 and
>                          * causing divide-by-zero issues on boot.
> @@ -5695,8 +5695,8 @@ void update_group_capacity(struct sched_domain *sd, int cpu)
>                          * Runtime updates will correct capacity_orig.
>                          */
>                         if (unlikely(!rq->sd)) {
> -                               capacity_orig += power_of(cpu);
> -                               capacity += power_of(cpu);
> +                               capacity_orig += capacity_of(cpu);
> +                               capacity += capacity_of(cpu);
>                                 continue;
>                         }
>
> @@ -5784,7 +5784,7 @@ static inline int sg_imbalanced(struct sched_group *group)
>  /*
>   * Compute the group capacity factor.
>   *
> - * Avoid the issue where N*frac(smt_power) >= 1 creates 'phantom' cores by
> + * Avoid the issue where N*frac(smt_capacity) >= 1 creates 'phantom' cores by
>   * first dividing out the smt factor and computing the actual number of cores
>   * and limit unit capacity with that.
>   */
> @@ -6082,7 +6082,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
>
>         /*
>          * OK, we don't have enough imbalance to justify moving tasks,
> -        * however we may be able to increase total CPU power used by
> +        * however we may be able to increase total CPU capacity used by
>          * moving them.
>          */
>
> @@ -6143,7 +6143,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>         /*
>          * In the presence of smp nice balancing, certain scenarios can have
>          * max load less than avg load(as we skip the groups at or below
> -        * its cpu_power, while calculating max_load..)
> +        * its cpu_capacity, while calculating max_load..)
>          */
>         if (busiest->avg_load <= sds->avg_load ||
>             local->avg_load >= sds->avg_load) {
> @@ -6298,11 +6298,11 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>                                      struct sched_group *group)
>  {
>         struct rq *busiest = NULL, *rq;
> -       unsigned long busiest_load = 0, busiest_power = 1;
> +       unsigned long busiest_load = 0, busiest_capacity = 1;
>         int i;
>
>         for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
> -               unsigned long power, capa_factor, wl;
> +               unsigned long capacity, capa_factor, wl;
>                 enum fbq_type rt;
>
>                 rq = cpu_rq(i);
> @@ -6330,8 +6330,8 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>                 if (rt > env->fbq_type)
>                         continue;
>
> -               power = power_of(i);
> -               capa_factor = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
> +               capacity = capacity_of(i);
> +               capa_factor = DIV_ROUND_CLOSEST(capacity, SCHED_POWER_SCALE);
>                 if (!capa_factor)
>                         capa_factor = fix_small_capacity(env->sd, group);
>
> @@ -6339,25 +6339,25 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>
>                 /*
>                  * When comparing with imbalance, use weighted_cpuload()
> -                * which is not scaled with the cpu power.
> +                * which is not scaled with the cpu capacity.
>                  */
>                 if (capa_factor && rq->nr_running == 1 && wl > env->imbalance)
>                         continue;
>
>                 /*
>                  * For the load comparisons with the other cpu's, consider
> -                * the weighted_cpuload() scaled with the cpu power, so that
> -                * the load can be moved away from the cpu that is potentially
> -                * running at a lower capacity.
> +                * the weighted_cpuload() scaled with the cpu capacity, so
> +                * that the load can be moved away from the cpu that is
> +                * potentially running at a lower capacity.
>                  *
> -                * Thus we're looking for max(wl_i / power_i), crosswise
> +                * Thus we're looking for max(wl_i / capacity_i), crosswise
>                  * multiplication to rid ourselves of the division works out
> -                * to: wl_i * power_j > wl_j * power_i;  where j is our
> -                * previous maximum.
> +                * to: wl_i * capacity_j > wl_j * capacity_i;  where j is
> +                * our previous maximum.
>                  */
> -               if (wl * busiest_power > busiest_load * power) {
> +               if (wl * busiest_capacity > busiest_load * capacity) {
>                         busiest_load = wl;
> -                       busiest_power = power;
> +                       busiest_capacity = capacity;
>                         busiest = rq;
>                 }
>         }
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index b384ccd07b..fe89387931 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -567,7 +567,7 @@ struct rq {
>         struct root_domain *rd;
>         struct sched_domain *sd;
>
> -       unsigned long cpu_power;
> +       unsigned long cpu_capacity;
>
>         unsigned char idle_balance;
>         /* For active balancing */
> --
> 1.8.4.108.g55ea5f6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
