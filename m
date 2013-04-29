Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3D2Hce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:32:34 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:49115 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3D2Hcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:32:32 -0400
MIME-Version: 1.0
In-Reply-To: <517CDBDB.1020608@gmail.com>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
	<1366910611-20048-11-git-send-email-vincent.guittot@linaro.org>
	<517CDBDB.1020608@gmail.com>
Date: Mon, 29 Apr 2013 09:32:30 +0200
Message-ID: <CAKfTPtAJJc5kcn07HrwB6FQmX+qyGFgMCOYsd3f6SWZP=Rpa5Q@mail.gmail.com>
Subject: Re: [PATCH 10/14] sched: update the buddy CPU
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Len Brown <len.brown@intel.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 April 2013 10:20, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> Hi,
>
> On 04/25/2013 07:23 PM, Vincent Guittot wrote:
>> Periodically updates the buddy of a CPU according to the current activity of
>> the system. A CPU is its own buddy if it participates to the packing effort.
>> Otherwise, it points to a CPU that participates to the packing effort.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c |   91 ++++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 86 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 234ecdd..28f8ea7 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -174,11 +174,17 @@ void sched_init_granularity(void)
>>
>>
>>  #ifdef CONFIG_SMP
>> +static unsigned long power_of(int cpu)
>> +{
>> +     return cpu_rq(cpu)->cpu_power;
>> +}
>> +
>>  /*
>>   * Save the id of the optimal CPU that should be used to pack small tasks
>>   * The value -1 is used when no buddy has been found
>>   */
>>  DEFINE_PER_CPU(int, sd_pack_buddy);
>> +DEFINE_PER_CPU(struct sched_domain *, sd_pack_domain);
>>
>>  /*
>>   * Look for the best buddy CPU that can be used to pack small tasks
>> @@ -237,6 +243,68 @@ void update_packing_domain(int cpu)
>>       }
>>
>>       pr_debug("CPU%d packing on CPU%d\n", cpu, id);
>> +     per_cpu(sd_pack_domain, cpu) = sd;
>> +     per_cpu(sd_pack_buddy, cpu) = id;
>> +}
>> +
>> +void update_packing_buddy(int cpu, int activity)
>> +{
>> +     struct sched_domain *sd = per_cpu(sd_pack_domain, cpu);
>> +     struct sched_group *sg, *pack, *tmp;
>> +     int id = cpu;
>> +
>> +     if (!sd)
>> +             return;
>> +
>> +     /*
>> +      * The sched_domain of a CPU points on the local sched_group
>> +      * and this CPU of this local group is a good candidate
>> +      */
>> +     pack = sg = sd->groups;
>> +
>> +     /* loop the sched groups to find the best one */
>> +     for (tmp = sg->next; tmp != sg; tmp = tmp->next) {
>> +             if ((tmp->sgp->power * pack->group_weight) >
>> +                     (pack->sgp->power_available * tmp->group_weight))
>
> The power_available struct member is defined in a subsequent patch
> (12/14), so this patch series would break git bisect.

Hi Francesco,

yes, power_available should have been added in patch 13/14.
I will correct that

Thanks
Vincent

>
> --
> Francesco
