Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaIKMPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:15:15 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:64793 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbaIKMPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:15:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140911101308.GU3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org> <20140911101308.GU3190@worktop.ger.corp.intel.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 11 Sep 2014 14:14:52 +0200
Message-ID: <CAKfTPtDtiTFVtgmM+38Ry-=32=o4NDn8LpPaQomug2NfeO_wnw@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] sched: move cfs task on a CPU with higher capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 12:13, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 26, 2014 at 01:06:51PM +0200, Vincent Guittot wrote:
>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 18db43e..60ae1ce 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -6049,6 +6049,14 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>>                       return true;
>>       }
>>
>> +     /*
>> +      * The group capacity is reduced probably because of activity from other
>> +      * sched class or interrupts which use part of the available capacity
>> +      */
>> +     if ((sg->sgc->capacity_orig * 100) > (sgs->group_capacity *
>> +                             env->sd->imbalance_pct))
>> +             return true;
>> +
>>       return false;
>>  }
>>
>> @@ -6534,13 +6542,23 @@ static int need_active_balance(struct lb_env *env)
>>       struct sched_domain *sd = env->sd;
>>
>>       if (env->idle == CPU_NEWLY_IDLE) {
>> +             int src_cpu = env->src_cpu;
>>
>>               /*
>>                * ASYM_PACKING needs to force migrate tasks from busy but
>>                * higher numbered CPUs in order to pack all tasks in the
>>                * lowest numbered CPUs.
>>                */
>> -             if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
>> +             if ((sd->flags & SD_ASYM_PACKING) && src_cpu > env->dst_cpu)
>> +                     return 1;
>> +
>> +             /*
>> +              * If the CPUs share their cache and the src_cpu's capacity is
>> +              * reduced because of other sched_class or IRQs, we trig an
>> +              * active balance to move the task
>> +              */
>> +             if ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
>> +                             sd->imbalance_pct))
>>                       return 1;
>>       }
>
> Should you not also check -- in both cases -- that the destination is
> any better?

The case should have been solved earlier when calculating the
imbalance which should be null if the destination is worse than the
source.

But i haven't formally check that calculate_imbalance correctly
handles that case

>
> Also, there's some obvious repetition going on there, maybe add a
> helper?

yes

>
> Also, both sites should probably ensure they're operating in the
> non-saturated/overloaded scenario. Because as soon as we're completely
> saturated we want SMP nice etc. and that all already works right
> (presumably).

If both are overloaded, calculated_imbalance will cap the max load
that can be pulled so the busiest_group will not become idle
