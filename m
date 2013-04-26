Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3DZOwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:52:54 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:47635 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab3DZOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130426131532.GB13964@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
	<1366910611-20048-9-git-send-email-vincent.guittot@linaro.org>
	<20130426131532.GB13964@dyad.programming.kicks-ass.net>
Date: Fri, 26 Apr 2013 16:52:50 +0200
Message-ID: <CAKfTPtCJzoYNEDu4WJWs0LraL59r8ZDuavBv9rypRKJiX4ZL7g@mail.gmail.com>
Subject: Re: [PATCH 08/14] sched: trig ILB on an idle buddy
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 15:15, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Apr 25, 2013 at 07:23:24PM +0200, Vincent Guittot wrote:
>> If the buddy CPU is not full and currently idle, we trigger an Idle Load
>> Balance to give it the opportunity to pull more tasks.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c |   24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 874f330..954adfd 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5776,6 +5776,26 @@ end:
>>       clear_bit(NOHZ_BALANCE_KICK, nohz_flags(this_cpu));
>>  }
>>
>> +static int check_nohz_buddy(int cpu)
>> +{
>> +     int buddy = per_cpu(sd_pack_buddy, cpu);
>> +
>> +     if (sysctl_sched_packing_mode != SCHED_PACKING_FULL)
>> +             return false;
>> +
>> +     /* No pack buddy for this CPU */
>> +     if (buddy == -1)
>> +             return false;
>> +
>> +     if (is_buddy_full(buddy))
>> +             return false;
>> +
>> +     if (cpumask_test_cpu(buddy, nohz.idle_cpus_mask))
>> +             return true;
>> +
>> +     return false;
>
> return cpumask_test_cpu(..); ?

right

>
>> +}
>> +
>>  /*
>>   * Current heuristic for kicking the idle load balancer in the presence
>>   * of an idle cpu is the system.
>> @@ -5813,6 +5833,10 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>>       if (rq->nr_running >= 2)
>>               goto need_kick;
>>
>> +     /* the buddy is idle and not busy so we can pack */
>> +     if (check_nohz_buddy(cpu))
>> +             goto need_kick;
>> +
>>       rcu_read_lock();
>>       for_each_domain(cpu, sd) {
>>               struct sched_group *sg = sd->groups;
>
> Bah.. this code is so confusing.. nohz_balance_kick(cpu) won't actually kick
> @cpu.
>
> Again.. suppose we're a big cpu (2) and our little buddy cpu (0) is busy, we
> miss an opportunity to kick the other little cpu into gear (1) and maybe take
> the big core out.

You're right that we can miss an opportunity but it means that cpus
allocated to packing effort are full and a new buddy cpu is going to
be allocated and will pull the task a bit later.


>
>
