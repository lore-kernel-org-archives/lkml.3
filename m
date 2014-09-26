Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaIZMSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:18:09 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:41426 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaIZMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <54246791.9050101@arm.com>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-5-git-send-email-vincent.guittot@linaro.org> <54246791.9050101@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 26 Sep 2014 14:17:43 +0200
Message-ID: <CAKfTPtCzVRY4q184nqHSL7zFh1CvF009p8q8EPFCZxDFMx9TeQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] sched: get CPU's usage statistic
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
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

On 25 September 2014 21:05, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 23/09/14 17:08, Vincent Guittot wrote:
>> Monitor the usage level of each group of each sched_domain level. The usage is
>> the amount of cpu_capacity that is currently used on a CPU or group of CPUs.
>> We use the utilization_load_avg to evaluate the usage level of each group.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 2cf153d..4097e3f 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4523,6 +4523,17 @@ static int select_idle_sibling(struct task_struct *p, int target)
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
> Why you are returning rq->cpu_capacity_orig + 1 (1025) in case
> utilization_load_avg is greater or equal than 1024 and not usage or
> (usage * capacity) >> SCHED_LOAD_SHIFT too?

The usage can't be higher than the full capacity of the CPU because
it's about the running time on this CPU. Nevertheless, usage can be
higher than SCHED_LOAD_SCALE because of unfortunate rounding in
avg_period and running_load_avg or just after migrating tasks until
the average stabilizes with the new running time.

>
> In case the weight of a sched group is greater than 1, you might loose
> the information that the whole sched group is over-utilized too.

that's exactly for sched_group with more than 1 CPU that we need to
cap the usage of a CPU to 100%. Otherwise, the group could be seen as
overloaded (CPU0 usage at 121% + CPU1 usage at 80%) whereas CPU1 has
20% of available capacity

>
> You add up the individual cpu usage values for a group by
> sgs->group_usage += get_cpu_usage(i) in update_sg_lb_stats and later use
> sgs->group_usage in group_is_overloaded to compare it against
> sgs->group_capacity (taking imbalance_pct into consideration).
>
>> +
>> +     return (usage * capacity) >> SCHED_LOAD_SHIFT;
>
> Nit-pick: Since you're multiplying by a capacity value
> (rq->cpu_capacity_orig) you should shift by SCHED_CAPACITY_SHIFT.

we want to compare the output of the function with some capacity
figures so i think that >> SCHED_LOAD_SHIFT is the right operation.

>
> Just to make sure: You do this scaling of usage by cpu_capacity_orig
> here only to cater for the fact that cpu_capacity_orig might be uarch
> scaled (by arch_scale_cpu_capacity, !SMT) in update_cpu_capacity while

I do this for any system with CPUs that have an original capacity that
is different from SCHED_CAPACITY_SCALE so it's for both uArch and SMT.

> utilization_load_avg is currently not.
> We don't even uArch scale on ARM TC2 big.LITTLE platform in mainline
> today due to the missing clock-frequency property in the device tree.

sorry i don't catch your point

>
> I think it's hard for people to grasp that your patch-set takes uArch
> scaling of capacity into consideration but not frequency scaling of
> capacity (via arch_scale_freq_capacity, not used at the moment).
>
>> +}
>> +
>>  /*
>>   * select_task_rq_fair: Select target runqueue for the waking task in domains
>>   * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
>> @@ -5663,6 +5674,7 @@ struct sg_lb_stats {
>>       unsigned long sum_weighted_load; /* Weighted load of group's tasks */
>>       unsigned long load_per_task;
>>       unsigned long group_capacity;
>> +     unsigned long group_usage; /* Total usage of the group */
>>       unsigned int sum_nr_running; /* Nr tasks running in the group */
>>       unsigned int group_capacity_factor;
>>       unsigned int idle_cpus;
>> @@ -6037,6 +6049,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
>>                       load = source_load(i, load_idx);
>>
>>               sgs->group_load += load;
>> +             sgs->group_usage += get_cpu_usage(i);
>>               sgs->sum_nr_running += rq->cfs.h_nr_running;
>>
>>               if (rq->nr_running > 1)
>>
>
>
