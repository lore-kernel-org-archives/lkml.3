Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3JWP23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 11:28:29 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42917 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3JWP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 11:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <52679BD6.6090507@linux.vnet.ibm.com>
References: <20131021114002.13291.31478.stgit@drishya>
	<20131021114442.13291.99344.stgit@drishya>
	<20131022221138.GJ2490@laptop.programming.kicks-ass.net>
	<52679BD6.6090507@linux.vnet.ibm.com>
Date: Wed, 23 Oct 2013 17:28:26 +0200
Message-ID: <CAKfTPtAUFdmc7PasebNksYztMwRrWsGWPgN6JJJurddu+UP-hQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] sched: Fix nohz_kick_needed to consider the nr_busy
 of the parent domain's group
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti

On 23 October 2013 11:50, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Peter
>
> On 10/23/2013 03:41 AM, Peter Zijlstra wrote:
>> This nohz stuff really needs to be re-thought and made more scalable --
>> its a royal pain :/
>
> Why  not do something like the below instead? It does the following.
>
> This patch introduces sd_busy just like your suggested patch, except that
> it points to the parent of the highest level sched domain which has the
> SD_SHARE_PKG_RESOURCES set and initializes it in update_top_cache_domain().
> This is the sched domain that is relevant in nohz_kick_needed().
>
> sd_set_sd_state_busy(), sd_set_sd_state_idle() and nohz_kick_needed() query
> and update *only* this sched domain(sd_busy) for nr_busy_cpus. They are the
> only users of this parameter. While we are at it, we might as well change
> the nohz_idle parameter to be updated at the sd_busy domain level alone and
> not the base domain level of a CPU. This will unify the concept of busy cpus
> at just one level of sched domain.
>
> There is no need to iterate through all levels of sched domains of a cpu to
> update nr_busy_cpus since it is irrelevant at all other sched domains except
> at sd_busy level.
>
> De-couple asymmetric load balancing from the nr_busy parameter which the
> PATCH 2/3 anyway does. sd_busy therefore is irrelevant for asymmetric load
> balancing.
>
> Regards
> Preeti U Murthy
> --------------------START_PATCH-------------------------------
>
> sched: Fix nohz_kick_needed()
>
> ---
>  kernel/sched/core.c  |    4 ++++
>  kernel/sched/fair.c  |   40 ++++++++++++++++++++++------------------
>  kernel/sched/sched.h |    1 +
>  3 files changed, 27 insertions(+), 18 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c06b8d3..c1dd11c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5271,6 +5271,7 @@ DEFINE_PER_CPU(struct sched_domain *, sd_llc);
>  DEFINE_PER_CPU(int, sd_llc_size);
>  DEFINE_PER_CPU(int, sd_llc_id);
>  DEFINE_PER_CPU(struct sched_domain *, sd_numa);
> +DEFINE_PER_CPU(struct sched_domain *, sd_busy);
>
>  static void update_top_cache_domain(int cpu)
>  {
> @@ -5290,6 +5291,9 @@ static void update_top_cache_domain(int cpu)
>
>         sd = lowest_flag_domain(cpu, SD_NUMA);
>         rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
> +
> +       sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES)->parent;

highest_flag_domain can return null pointer

> +       rcu_assign_pointer(per_cpu(sd_busy, cpu), sd);
>  }
>
>  /*
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 813dd61..71e6f14 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6515,16 +6515,16 @@ static inline void nohz_balance_exit_idle(int cpu)
>  static inline void set_cpu_sd_state_busy(void)
>  {
>         struct sched_domain *sd;
> +       int cpu = smp_processor_id();
>
>         rcu_read_lock();
> -       sd = rcu_dereference_check_sched_domain(this_rq()->sd);
> +       sd = per_cpu(sd_busy, cpu);

Don't you need to use rcu_dereference when using sd_busy ?

>
>         if (!sd || !sd->nohz_idle)
>                 goto unlock;
>         sd->nohz_idle = 0;
>
> -       for (; sd; sd = sd->parent)
> -               atomic_inc(&sd->groups->sgp->nr_busy_cpus);
> +       atomic_inc(&sd->groups->sgp->nr_busy_cpus);
>  unlock:
>         rcu_read_unlock();
>  }
> @@ -6532,16 +6532,16 @@ unlock:
>  void set_cpu_sd_state_idle(void)
>  {
>         struct sched_domain *sd;
> +       int cpu = smp_processor_id();
>
>         rcu_read_lock();
> -       sd = rcu_dereference_check_sched_domain(this_rq()->sd);
> +       sd = per_cpu(sd_busy, cpu);
>
>         if (!sd || sd->nohz_idle)
>                 goto unlock;
>         sd->nohz_idle = 1;
>
> -       for (; sd; sd = sd->parent)
> -               atomic_dec(&sd->groups->sgp->nr_busy_cpus);
> +       atomic_dec(&sd->groups->sgp->nr_busy_cpus);
>  unlock:
>         rcu_read_unlock();
>  }
> @@ -6748,6 +6748,9 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>  {
>         unsigned long now = jiffies;
>         struct sched_domain *sd;
> +       struct sched_group *sg;
> +       struct sched_group_power *sgp;
> +       int nr_busy;
>
>         if (unlikely(idle_cpu(cpu)))
>                 return 0;
> @@ -6773,22 +6776,23 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>                 goto need_kick;
>
>         rcu_read_lock();
> -       for_each_domain(cpu, sd) {
> -               struct sched_group *sg = sd->groups;
> -               struct sched_group_power *sgp = sg->sgp;
> -               int nr_busy = atomic_read(&sgp->nr_busy_cpus);
> +       sd = per_cpu(sd_busy, cpu);
>
> -               if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
> -                       goto need_kick_unlock;
> +       if (sd) {
> +               sg = sd->groups;

sg is not needed anymore

> +               sgp = sg->sgp;
> +               nr_busy = atomic_read(&sgp->nr_busy_cpus);
>
> -               if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
> -                   && (cpumask_first_and(nohz.idle_cpus_mask,
> -                                         sched_domain_span(sd)) < cpu))
> +               if (nr_busy > 1)
>                         goto need_kick_unlock;
> -
> -               if (!(sd->flags & (SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING)))
> -                       break;
>         }
> +
> +       sd = highest_flag_domain(cpu, SD_ASYM_PACKING);
> +
> +       if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
> +                                 sched_domain_span(sd)) < cpu))
> +               goto need_kick_unlock;
> +
>         rcu_read_unlock();
>         return 0;
>
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index ffc7087..0f1253f 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -623,6 +623,7 @@ DECLARE_PER_CPU(struct sched_domain *, sd_llc);
>  DECLARE_PER_CPU(int, sd_llc_size);
>  DECLARE_PER_CPU(int, sd_llc_id);
>  DECLARE_PER_CPU(struct sched_domain *, sd_numa);
> +DECLARE_PER_CPU(struct sched_domain *, sd_busy);
>
>  struct sched_group_power {
>         atomic_t ref;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
