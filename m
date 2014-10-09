Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbaJIN56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:57:58 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35840 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaJIN5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:57:49 -0400
MIME-Version: 1.0
In-Reply-To: <20141009113614.GP4750@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-6-git-send-email-vincent.guittot@linaro.org> <20141009113614.GP4750@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 9 Oct 2014 15:57:28 +0200
Message-ID: <CAKfTPtDtfhQDWNjU5i-YpX4-Ak3nT3uaOCvhqgNP-u=-La7_gw@mail.gmail.com>
Subject: Re: [PATCH v7 5/7] sched: get CPU's usage statistic
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2014 13:36, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Oct 07, 2014 at 02:13:35PM +0200, Vincent Guittot wrote:
>> Monitor the usage level of each group of each sched_domain level. The usage is
>> the amount of cpu_capacity that is currently used on a CPU or group of CPUs.
>> We use the utilization_load_avg to evaluate the usage level of each group.
>>
>> The utilization_avg_contrib only takes into account the running time but not
>> the uArch so the utilization_load_avg is in the range [0..SCHED_LOAD_SCALE]
>> to reflect the running load on the CPU. We have to scale the utilization with
>> the capacity of the CPU to get the usage of the latter. The usage can then be
>> compared with the available capacity.
>
> You say cpu_capacity, but in actual fact you use capacity_orig and fail
> to justify/clarify this.

you're right it's cpu_capacity_orig no cpu_capacity

cpu_capacity is the compute capacity available for CFS task once we
have removed the capacity that is used by RT tasks.

We want to compare the utilization of the CPU (utilization_avg_contrib
which is in the range [0..SCHED_LOAD_SCALE]) with available capacity
(cpu_capacity which is in the range [0..cpu_capacity_orig])
An utilization_avg_contrib equals to SCHED_LOAD_SCALE means that the
CPU is fully utilized so all cpu_capacity_orig are used. so we scale
the utilization_avg_contrib from [0..SCHED_LOAD_SCALE] into cpu_usage
in the range [0..cpu_capacity_orig]


>
>> The frequency scaling invariance is not taken into account in this patchset,
>> it will be solved in another patchset
>
> Maybe explain what the specific invariance issue is that is skipped over
> for now.

ok. I can add description on the fact that if the core run slower, the
tasks will use more running time of the CPU for the same job so the
usage of the cpu which is based on the amount of time, will increase

>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index d3e9067..7364ed4 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4551,6 +4551,17 @@ static int select_idle_sibling(struct task_struct *p, int target)
>>       return target;
>>  }
>>
>> +static int get_cpu_usage(int cpu)
>> +{
>> +     unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
>> +     unsigned long capacity = capacity_orig_of(cpu);
>> +
>> +     if (usage >= SCHED_LOAD_SCALE)
>> +             return capacity + 1;
>
> Like Morten I'm confused by that +1 thing.

ok. the goal was to point out the erroneous case where usage is out of
the range but if it generates confusion, it can remove it

>
>> +
>> +     return (usage * capacity) >> SCHED_LOAD_SHIFT;
>> +}
>
> A comment with that function that it returns capacity units might
> clarify shift confusion Morten raised the other day.

ok. i will add a comment
