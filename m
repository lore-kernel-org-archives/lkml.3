Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbaKUMRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:17:39 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:35988 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaKUMRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:17:37 -0500
MIME-Version: 1.0
In-Reply-To: <546ECF4C.2040304@gmail.com>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-5-git-send-email-vincent.guittot@linaro.org>
 <54246791.9050101@arm.com> <CAKfTPtCzVRY4q184nqHSL7zFh1CvF009p8q8EPFCZxDFMx9TeQ@mail.gmail.com>
 <546ECF4C.2040304@gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 21 Nov 2014 13:17:16 +0100
Message-ID: <CAKfTPtD1OpHWwkRPWhZhRW-A_98Ro1SbmUM8fDufj15aQE-gAQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] sched: get CPU's usage statistic
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 November 2014 06:36, Wanpeng Li <kernellwp@gmail.com> wrote:
> Hi Vincent,
>
> On 9/26/14, 8:17 PM, Vincent Guittot wrote:

 [snip]

>>
>>> You add up the individual cpu usage values for a group by
>>> sgs->group_usage += get_cpu_usage(i) in update_sg_lb_stats and later use
>>> sgs->group_usage in group_is_overloaded to compare it against
>>> sgs->group_capacity (taking imbalance_pct into consideration).
>>>
>>>> +
>>>> +     return (usage * capacity) >> SCHED_LOAD_SHIFT;
>>>
>>> Nit-pick: Since you're multiplying by a capacity value
>>> (rq->cpu_capacity_orig) you should shift by SCHED_CAPACITY_SHIFT.
>>
>> we want to compare the output of the function with some capacity
>> figures so i think that >> SCHED_LOAD_SHIFT is the right operation.
>
>
> Could you explain more why '>> SCHED_LOAD_SHIFT' instead of '>>
> SCHED_CAPACITY_SHIFT'?

The return of get_cpu_usage is going to be compared with capacity so
we need to return CAPACITY unit

usage unit is LOAD, capacity unit is CAPACITY so we have to divide by
LOAD unit to return CAPACITY unit

LOAD unit * CAPACITY unit / LOAD unit -> CAPACITY unit

Regards,
Vincent

>
> Regards,
> Wanpeng Li
>
>>
>>> Just to make sure: You do this scaling of usage by cpu_capacity_orig
>>> here only to cater for the fact that cpu_capacity_orig might be uarch
>>> scaled (by arch_scale_cpu_capacity, !SMT) in update_cpu_capacity while
>>
>> I do this for any system with CPUs that have an original capacity that
>> is different from SCHED_CAPACITY_SCALE so it's for both uArch and SMT.
>>
>>> utilization_load_avg is currently not.
>>> We don't even uArch scale on ARM TC2 big.LITTLE platform in mainline
>>> today due to the missing clock-frequency property in the device tree.
>>
>> sorry i don't catch your point
>>
>>> I think it's hard for people to grasp that your patch-set takes uArch
>>> scaling of capacity into consideration but not frequency scaling of
>>> capacity (via arch_scale_freq_capacity, not used at the moment).
>>>
>>>> +}
>>>> +
>>>>   /*
>>>>    * select_task_rq_fair: Select target runqueue for the waking task in
>>>> domains
>>>>    * that have the 'sd_flag' flag set. In practice, this is
>>>> SD_BALANCE_WAKE,
>>>> @@ -5663,6 +5674,7 @@ struct sg_lb_stats {
>>>>        unsigned long sum_weighted_load; /* Weighted load of group's
>>>> tasks */
>>>>        unsigned long load_per_task;
>>>>        unsigned long group_capacity;
>>>> +     unsigned long group_usage; /* Total usage of the group */
>>>>        unsigned int sum_nr_running; /* Nr tasks running in the group */
>>>>        unsigned int group_capacity_factor;
>>>>        unsigned int idle_cpus;
>>>> @@ -6037,6 +6049,7 @@ static inline void update_sg_lb_stats(struct
>>>> lb_env *env,
>>>>                        load = source_load(i, load_idx);
>>>>
>>>>                sgs->group_load += load;
>>>> +             sgs->group_usage += get_cpu_usage(i);
>>>>                sgs->sum_nr_running += rq->cfs.h_nr_running;
>>>>
>>>>                if (rq->nr_running > 1)
>>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
