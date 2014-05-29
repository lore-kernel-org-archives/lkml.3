Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbaE2TiC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:38:02 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38044 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620AbaE2TiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:38:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140529095024.GF11074@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org> <20140529095024.GF11074@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 29 May 2014 21:37:39 +0200
Message-ID: <CAKfTPtCHhxyugMOCeS0hZoEXWhgRec4uOBexZ2aB2A+Eycgi8w@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2014 11:50, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 23, 2014 at 05:53:04PM +0200, Vincent Guittot wrote:
>> If the CPU is used for handling lot of IRQs, trig a load balance to check if
>> it's worth moving its tasks on another CPU that has more capacity
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index e8a30f9..2501e49 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5948,6 +5948,13 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>>       if (sgs->sum_nr_running > sgs->group_capacity)
>>               return true;
>>
>> +     /*
>> +      * The group capacity is reduced probably because of activity from other
>> +      * sched class or interrupts which use part of the available capacity
>> +      */
>> +     if ((sg->sgp->power_orig * 100) > (sgs->group_power * env->sd->imbalance_pct))
>> +             return true;
>> +
>>       if (sgs->group_imb)
>>               return true;
>>
>
> But we should already do this because the load numbers are scaled with
> the power/capacity figures. If one CPU gets significant less time to run
> fair tasks, its effective load would spike and it'd get to be selected
> here anyway.
>
> Or am I missing something?

The CPU could have been picked when the capacity becomes null (which
occurred when the cpu_power goes below half the default
SCHED_POWER_SCALE). And even after that, there were some conditions in
find_busiest_group that was bypassing this busiest group

>
>> @@ -7282,6 +7289,12 @@ static inline int nohz_kick_needed(struct rq *rq)
>>
>>               if (nr_busy > 1)
>>                       goto need_kick_unlock;
>> +
>> +             if ((rq->cfs.h_nr_running >= 1)
>> +              && ((rq->cpu_power * sd->imbalance_pct) <
>> +                                     (rq->cpu_power_orig * 100)))
>> +                     goto need_kick_unlock;
>> +
>>       }
>>
>>       sd = rcu_dereference(per_cpu(sd_asym, cpu));
>
> OK, so there you're kicking the idle balancer to try and get another CPU
> to pull some load? That makes sense I suppose.

and especially if we have idle CPUs and one task on the CPU with
reduced capacity

>
> That function is pretty horrible though; how about something like this
> first?

ok, i will integrate this modification in next version

>
> ---
>  kernel/sched/fair.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c9617b73bcc0..47fb96e6fa83 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -7215,15 +7215,16 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
>   *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
>   *     domain span are idle.
>   */
> -static inline int nohz_kick_needed(struct rq *rq)
> +static inline bool nohz_kick_needed(struct rq *rq)
>  {
>         unsigned long now = jiffies;
>         struct sched_domain *sd;
>         struct sched_group_power *sgp;
>         int nr_busy, cpu = rq->cpu;
> +       bool kick = false;
>
>         if (unlikely(rq->idle_balance))
> -               return 0;
> +               return false;
>
>         /*
>         * We may be recently in ticked or tickless idle mode. At the first
> @@ -7237,38 +7238,34 @@ static inline int nohz_kick_needed(struct rq *rq)
>          * balancing.
>          */
>         if (likely(!atomic_read(&nohz.nr_cpus)))
> -               return 0;
> +               return false;
>
>         if (time_before(now, nohz.next_balance))
> -               return 0;
> +               return false;
>
>         if (rq->nr_running >= 2)
> -               goto need_kick;
> +               return true;
>
>         rcu_read_lock();
>         sd = rcu_dereference(per_cpu(sd_busy, cpu));
> -
>         if (sd) {
>                 sgp = sd->groups->sgp;
>                 nr_busy = atomic_read(&sgp->nr_busy_cpus);
>
> -               if (nr_busy > 1)
> -                       goto need_kick_unlock;
> +               if (nr_busy > 1) {
> +                       kick = true;
> +                       goto unlock;
> +               }
>         }
>
>         sd = rcu_dereference(per_cpu(sd_asym, cpu));
> -
>         if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
>                                   sched_domain_span(sd)) < cpu))
> -               goto need_kick_unlock;
> -
> -       rcu_read_unlock();
> -       return 0;
> +               kick = true;
>
> -need_kick_unlock:
> +unlock:
>         rcu_read_unlock();
> -need_kick:
> -       return 1;
> +       return kick;
>  }
>  #else
>  static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle) { }
