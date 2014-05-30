Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbaE3TZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:25:10 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37712 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbaE3TZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <53888719.70604@arm.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org> <53888719.70604@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 30 May 2014 21:24:48 +0200
Message-ID: <CAKfTPtDWd5FKqSemFMFMMPz+t+aEnHWL_WH5grRoegtGnfD+bw@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher capacity
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2014 15:26, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 23/05/14 16:53, Vincent Guittot wrote:
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
>
> Here 'group capacity' refers to sgs->group_power and not to
> sgs->group_capacity, right?

yes, you're right it's cpu_power, i will correct the comment

>
>> +      * sched class or interrupts which use part of the available capacity
>> +      */
>
> ... 'interrupts' only w/ CONFIG_IRQ_TIME_ACCOUNTING=y, right ?

yes, we need CONFIG_IRQ_TIME_ACCOUNTING in order to scale the
cpu_power with time spent under irq. I have made test with and without
this config to show impact (in the cover letter)

Thanks
Vincent

>
>> +     if ((sg->sgp->power_orig * 100) > (sgs->group_power * env->sd->imbalance_pct))
>> +             return true;
>> +
> [...]
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
