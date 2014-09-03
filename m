Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaICM0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:26:37 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48278 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaICM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:26:35 -0400
Message-ID: <540708DC.9060901@linux.vnet.ibm.com>
Date: Wed, 03 Sep 2014 17:56:04 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v5 08/12] sched: move cfs task on a CPU with higher capacity
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org> <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org> <54020F00.2030807@linux.vnet.ibm.com> <CAKfTPtBq89SX=7=bXu2za7oXi1Lid_5ara-WputrtE8kCqcZcw@mail.gmail.com> <5406DB43.1030506@linux.vnet.ibm.com> <CAKfTPtCXBYSbXVgdeyMtvuK8aZaRBzhs9S3=+V2jvXnoCJFqBQ@mail.gmail.com>
In-Reply-To: <CAKfTPtCXBYSbXVgdeyMtvuK8aZaRBzhs9S3=+V2jvXnoCJFqBQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090312-7164-0000-0000-000004517093
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 05:14 PM, Vincent Guittot wrote:
> On 3 September 2014 11:11, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> On 09/01/2014 02:15 PM, Vincent Guittot wrote:
>>> On 30 August 2014 19:50, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>>>> Hi Vincent,
>>>>> index 18db43e..60ae1ce 100644
>>>>> --- a/kernel/sched/fair.c
>>>>> +++ b/kernel/sched/fair.c
>>>>> @@ -6049,6 +6049,14 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>>>>>                       return true;
>>>>>       }
>>>>>
>>>>> +     /*
>>>>> +      * The group capacity is reduced probably because of activity from other
>>>>> +      * sched class or interrupts which use part of the available capacity
>>>>> +      */
>>>>> +     if ((sg->sgc->capacity_orig * 100) > (sgs->group_capacity *
>>>>> +                             env->sd->imbalance_pct))
>>>>
>>>> Wouldn't the check on avg_load let us know if we are packing more tasks
>>>> in this group than its capacity ? Isn't that the metric we are more
>>>> interested in?
>>>
>>> With  this patch, we don't want to pack but we prefer to spread the
>>> task on another CPU than the one which handles the interruption if
>>> latter uses a significant part of the CPU capacity.
>>>
>>>>
>>>>> +             return true;
>>>>> +
>>>>>       return false;
>>>>>  }
>>>>>
>>>>> @@ -6534,13 +6542,23 @@ static int need_active_balance(struct lb_env *env)
>>>>>       struct sched_domain *sd = env->sd;
>>>>>
>>>>>       if (env->idle == CPU_NEWLY_IDLE) {
>>>>> +             int src_cpu = env->src_cpu;
>>>>>
>>>>>               /*
>>>>>                * ASYM_PACKING needs to force migrate tasks from busy but
>>>>>                * higher numbered CPUs in order to pack all tasks in the
>>>>>                * lowest numbered CPUs.
>>>>>                */
>>>>> -             if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
>>>>> +             if ((sd->flags & SD_ASYM_PACKING) && src_cpu > env->dst_cpu)
>>>>> +                     return 1;
>>>>> +
>>>>> +             /*
>>>>> +              * If the CPUs share their cache and the src_cpu's capacity is
>>>>> +              * reduced because of other sched_class or IRQs, we trig an
>>>>> +              * active balance to move the task
>>>>> +              */
>>>>> +             if ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
>>>>> +                             sd->imbalance_pct))
>>>>>                       return 1;
>>>>>       }
>>>>>
>>>>> @@ -6643,6 +6661,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>>>>>
>>>>>       schedstat_add(sd, lb_imbalance[idle], env.imbalance);
>>>>>
>>>>> +     env.src_cpu = busiest->cpu;
>>>>> +
>>>>>       ld_moved = 0;
>>>>>       if (busiest->nr_running > 1) {
>>>>>               /*
>>>>> @@ -6652,7 +6672,6 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>>>>>                * correctly treated as an imbalance.
>>>>>                */
>>>>>               env.flags |= LBF_ALL_PINNED;
>>>>> -             env.src_cpu   = busiest->cpu;
>>>>>               env.src_rq    = busiest;
>>>>>               env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
>>>>>
>>>>> @@ -7359,10 +7378,12 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
>>>>>
>>>>>  /*
>>>>>   * Current heuristic for kicking the idle load balancer in the presence
>>>>> - * of an idle cpu is the system.
>>>>> + * of an idle cpu in the system.
>>>>>   *   - This rq has more than one task.
>>>>> - *   - At any scheduler domain level, this cpu's scheduler group has multiple
>>>>> - *     busy cpu's exceeding the group's capacity.
>>>>> + *   - This rq has at least one CFS task and the capacity of the CPU is
>>>>> + *     significantly reduced because of RT tasks or IRQs.
>>>>> + *   - At parent of LLC scheduler domain level, this cpu's scheduler group has
>>>>> + *     multiple busy cpu.
>>>>>   *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
>>>>>   *     domain span are idle.
>>>>>   */
>>>>> @@ -7372,9 +7393,10 @@ static inline int nohz_kick_needed(struct rq *rq)
>>>>>       struct sched_domain *sd;
>>>>>       struct sched_group_capacity *sgc;
>>>>>       int nr_busy, cpu = rq->cpu;
>>>>> +     bool kick = false;
>>>>>
>>>>>       if (unlikely(rq->idle_balance))
>>>>> -             return 0;
>>>>> +             return false;
>>>>>
>>>>>         /*
>>>>>       * We may be recently in ticked or tickless idle mode. At the first
>>>>> @@ -7388,38 +7410,45 @@ static inline int nohz_kick_needed(struct rq *rq)
>>>>>        * balancing.
>>>>>        */
>>>>>       if (likely(!atomic_read(&nohz.nr_cpus)))
>>>>> -             return 0;
>>>>> +             return false;
>>>>>
>>>>>       if (time_before(now, nohz.next_balance))
>>>>> -             return 0;
>>>>> +             return false;
>>>>>
>>>>>       if (rq->nr_running >= 2)
>>>>
>>>> Will this check ^^ not catch those cases which this patch is targeting?
>>>
>>> This patch is not about how many tasks are running but if the capacity
>>> of the CPU is reduced because of side activity like interruptions
>>> which are only visible in the capacity value (with IRQ_TIME_ACCOUNTING
>>> config) but not in nr_running.
>>> Even if the capacity is reduced because of RT tasks, nothing ensures
>>> that the RT task will be running when the tick fires
>>>
>>> Regards,
>>> Vincent
>>>>
>>>> Regards
>>>> Preeti U Murthy
>>>>
>>>>> -             goto need_kick;
>>>>> +             return true;
>>>>>
>>>>>       rcu_read_lock();
>>>>>       sd = rcu_dereference(per_cpu(sd_busy, cpu));
>>>>> -
>>>>>       if (sd) {
>>>>>               sgc = sd->groups->sgc;
>>>>>               nr_busy = atomic_read(&sgc->nr_busy_cpus);
>>>>>
>>>>> -             if (nr_busy > 1)
>>>>> -                     goto need_kick_unlock;
>>>>> +             if (nr_busy > 1) {
>>>>> +                     kick = true;
>>>>> +                     goto unlock;
>>>>> +             }
>>>>> +
>>>>>       }
>>>>>
>>>>> -     sd = rcu_dereference(per_cpu(sd_asym, cpu));
>>>>> +     sd = rcu_dereference(rq->sd);
>>>>> +     if (sd) {
>>>>> +             if ((rq->cfs.h_nr_running >= 1) &&
>>>>> +                             ((rq->cpu_capacity * sd->imbalance_pct) <
>>>>> +                             (rq->cpu_capacity_orig * 100))) {
>>
>> Ok I understand your explanation above. But I was wondering if you would
>> need to add this check around rq->cfs.h_nr_running >= 1 in the above two
>> cases as well.
> 
> yes you're right for the test if (rq->nr_running >= 2).
> 
> It's not so straight forward for nr_busy_cpus which reflects how many
> CPUs have not stopped their tick. The scheduler assumes that the
> latter are busy with cfs tasks
> 
>>
>> I have actually raised this concern over whether we should be using
>> rq->nr_running or cfs_rq->nr_running while we do load balancing in reply
>> to your patch3. While all our load measurements are about the cfs_rq
> 
> I have just replied to your comments on patch 3. Sorry for the delay
> 
>> load, we use rq->nr_running, which may include tasks from other sched
>> classes as well. We divide them to get average load per task during load
>> balancing which is wrong, isn't it? Similarly during nohz_kick_needed(),
>> we trigger load balancing based on rq->nr_running again.
>>
>> In this patch too, even if you know that the cpu is being dominated by
>> tasks that do not belong to cfs class, you would be triggering a futile
>> load balance if there are no fair tasks to move.
> This patch adds one additional condition that is based on
> rq->cfs.h_nr_running so it should not trigger any futile load balance.
> Then, I have also take advantage of this patch to clean up
> nohz_kick_needed as proposed by Peter but the conditions are the same
> than previously (except the one with rq->cfs.h_nr_running)
> 
> I can prepare another patchset that will solve the concerns that you
> raised for nohz_kick_needed and in patch 3 but i would prefer not
> include them in this patchset which is large enough and which subject
> is a bit different.
> Does it seem ok for you ?

Sure Vincent, thanks! I have in fact sent out a mail raising my concern
over rq->nr_running. If others agree on the issue to be existing, maybe
we can work on this next patchset that can clean this up in all places
necessary and not just in nohz_kick_needed().

Regards
Preeti U Murthy
> 
> Regards,
> Vincent
>>
>> Regards
>> Preeti U Murthy
>>
> 

