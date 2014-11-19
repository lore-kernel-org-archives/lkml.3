Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbaKSRa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:30:59 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56635 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbaKSRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <CADcy93WT7LzwU0BLN1ELvVugbGO+UMO6jJoM9JJGeTcNT-egAw@mail.gmail.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-9-git-send-email-vincent.guittot@linaro.org> <CADcy93WT7LzwU0BLN1ELvVugbGO+UMO6jJoM9JJGeTcNT-egAw@mail.gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 19 Nov 2014 18:30:37 +0100
Message-ID: <CAKfTPtCGOa9t12MpSr82qarD3FKXxYW8MmeyTCMr8Pev3Kcomg@mail.gmail.com>
Subject: Re: [PATCH v9 08/10] sched: replace capacity_factor by usage
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2014 16:15, pang.xunlei <pang.xunlei@linaro.org> wrote:
> On 4 November 2014 00:54, Vincent Guittot <vincent.guittot@linaro.org> wrote:

[snip]

>> +static inline bool
>> +group_has_capacity(struct lb_env *env, struct sg_lb_stats *sgs)
>>  {
>> -       unsigned int capacity_factor, smt, cpus;
>> -       unsigned int capacity, capacity_orig;
>> +       if ((sgs->group_capacity * 100) >
>> +                       (sgs->group_usage * env->sd->imbalance_pct))
> Hi Vincent,
>
> In case of when some CPU(s) is used to handle heavy IRQs or RT tasks,
> get_cpu_usage() will get low usage(capacity), and cpu_capacity gets
> low as well, so do those of the whole group correspondingly.
> So in this case, is there any guarantee that this math will return false?

As an example, we will return false whatever the non-zero value of
group_capacity if there is no CFS tasks in the group

Regards,
Vincent

>
> Thanks,
> Xunlei
>> +               return true;
>>
>> -       capacity = group->sgc->capacity;
>> -       capacity_orig = group->sgc->capacity_orig;
>> -       cpus = group->group_weight;
>> +       if (sgs->sum_nr_running < sgs->group_weight)
>> +               return true;
>> +
>> +       return false;
>> +}
>>
>> -       /* smt := ceil(cpus / capacity), assumes: 1 < smt_capacity < 2 */
>> -       smt = DIV_ROUND_UP(SCHED_CAPACITY_SCALE * cpus, capacity_orig);
>> -       capacity_factor = cpus / smt; /* cores */
>> +/*
>> + *  group_is_overloaded returns true if the group has more tasks than it can
>> + *  handle. We consider that a group is overloaded if the number of tasks is
>> + *  greater than the number of CPUs and the tasks already use all available
>> + *  capacity for CFS tasks. For the latter, we use a threshold to stabilize
>> + *  the state, to take into account the variance of tasks' load and to return
>> + *  true if available capacity is no more meaningful for load balancer
>> + */
>> +static inline bool
>> +group_is_overloaded(struct lb_env *env, struct sg_lb_stats *sgs)
>> +{
>> +       if (sgs->sum_nr_running <= sgs->group_weight)
>> +               return false;
>>
>> -       capacity_factor = min_t(unsigned,
>> -               capacity_factor, DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE));
>> -       if (!capacity_factor)
>> -               capacity_factor = fix_small_capacity(env->sd, group);
>> +       if ((sgs->group_capacity * 100) <
>> +                       (sgs->group_usage * env->sd->imbalance_pct))
>> +               return true;
>>
>> -       return capacity_factor;
>> +       return false;
>>  }
>>
>> -static enum group_type
>> -group_classify(struct sched_group *group, struct sg_lb_stats *sgs)
>> +static enum group_type group_classify(struct lb_env *env,
>> +               struct sched_group *group,
>> +               struct sg_lb_stats *sgs)
>>  {
>> -       if (sgs->sum_nr_running > sgs->group_capacity_factor)
>> +       if (sgs->group_no_capacity)
>>                 return group_overloaded;
>>
>>         if (sg_imbalanced(group))
>> @@ -6087,11 +6083,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>>                 sgs->load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
>>
>>         sgs->group_weight = group->group_weight;
>> -       sgs->group_capacity_factor = sg_capacity_factor(env, group);
>> -       sgs->group_type = group_classify(group, sgs);
>>
>> -       if (sgs->group_capacity_factor > sgs->sum_nr_running)
>> -               sgs->group_has_free_capacity = 1;
>> +       sgs->group_no_capacity = group_is_overloaded(env, sgs);
>> +       sgs->group_type = group_classify(env, group, sgs);
>>  }
>>
>>  /**
>> @@ -6213,17 +6207,20 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>>
>>                 /*
>>                  * In case the child domain prefers tasks go to siblings
>> -                * first, lower the sg capacity factor to one so that we'll try
>> +                * first, lower the sg capacity so that we'll try
>>                  * and move all the excess tasks away. We lower the capacity
>>                  * of a group only if the local group has the capacity to fit
>> -                * these excess tasks, i.e. nr_running < group_capacity_factor. The
>> -                * extra check prevents the case where you always pull from the
>> -                * heaviest group when it is already under-utilized (possible
>> -                * with a large weight task outweighs the tasks on the system).
>> +                * these excess tasks. The extra check prevents the case where
>> +                * you always pull from the heaviest group when it is already
>> +                * under-utilized (possible with a large weight task outweighs
>> +                * the tasks on the system).
>>                  */
>>                 if (prefer_sibling && sds->local &&
>> -                   sds->local_stat.group_has_free_capacity)
>> -                       sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
>> +                   group_has_capacity(env, &sds->local_stat) &&
>> +                   (sgs->sum_nr_running > 1)) {
>> +                       sgs->group_no_capacity = 1;
>> +                       sgs->group_type = group_overloaded;
>> +               }
>>
>>                 if (update_sd_pick_busiest(env, sds, sg, sgs)) {
>>                         sds->busiest = sg;
>> @@ -6402,11 +6399,12 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>>          */
>>         if (busiest->group_type == group_overloaded &&
>>             local->group_type   == group_overloaded) {
>> -               load_above_capacity =
>> -                       (busiest->sum_nr_running - busiest->group_capacity_factor);
>> -
>> -               load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
>> -               load_above_capacity /= busiest->group_capacity;
>> +               load_above_capacity = busiest->sum_nr_running *
>> +                                       SCHED_LOAD_SCALE;
>> +               if (load_above_capacity > busiest->group_capacity)
>> +                       load_above_capacity -= busiest->group_capacity;
>> +               else
>> +                       load_above_capacity = ~0UL;
>>         }
>>
>>         /*
>> @@ -6469,6 +6467,7 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
>>         local = &sds.local_stat;
>>         busiest = &sds.busiest_stat;
>>
>> +       /* ASYM feature bypasses nice load balance check */
>>         if ((env->idle == CPU_IDLE || env->idle == CPU_NEWLY_IDLE) &&
>>             check_asym_packing(env, &sds))
>>                 return sds.busiest;
>> @@ -6489,8 +6488,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
>>                 goto force_balance;
>>
>>         /* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
>> -       if (env->idle == CPU_NEWLY_IDLE && local->group_has_free_capacity &&
>> -           !busiest->group_has_free_capacity)
>> +       if (env->idle == CPU_NEWLY_IDLE && group_has_capacity(env, local) &&
>> +           busiest->group_no_capacity)
>>                 goto force_balance;
>>
>>         /*
>> @@ -6549,7 +6548,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>>         int i;
>>
>>         for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
>> -               unsigned long capacity, capacity_factor, wl;
>> +               unsigned long capacity, wl;
>>                 enum fbq_type rt;
>>
>>                 rq = cpu_rq(i);
>> @@ -6578,9 +6577,6 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>>                         continue;
>>
>>                 capacity = capacity_of(i);
>> -               capacity_factor = DIV_ROUND_CLOSEST(capacity, SCHED_CAPACITY_SCALE);
>> -               if (!capacity_factor)
>> -                       capacity_factor = fix_small_capacity(env->sd, group);
>>
>>                 wl = weighted_cpuload(i);
>>
>> @@ -6588,7 +6584,9 @@ static struct rq *find_busiest_queue(struct lb_env *env,
>>                  * When comparing with imbalance, use weighted_cpuload()
>>                  * which is not scaled with the cpu capacity.
>>                  */
>> -               if (capacity_factor && rq->nr_running == 1 && wl > env->imbalance)
>> +
>> +               if (rq->nr_running == 1 && wl > env->imbalance &&
>> +                   !check_cpu_capacity(rq, env->sd))
>>                         continue;
>>
>>                 /*
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index aaaa3e4..8fd30c1 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -759,7 +759,7 @@ struct sched_group_capacity {
>>          * CPU capacity of this group, SCHED_LOAD_SCALE being max capacity
>>          * for a single CPU.
>>          */
>> -       unsigned int capacity, capacity_orig;
>> +       unsigned int capacity;
>>         unsigned long next_update;
>>         int imbalance; /* XXX unrelated to capacity but shared group state */
>>         /*
>> --
>> 1.9.1
>>
>>
>> _______________________________________________
>> linaro-kernel mailing list
>> linaro-kernel@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-kernel
