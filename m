Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaIZT5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 15:57:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37765 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaIZT5r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 15:57:47 -0400
Message-ID: <5425C537.6050507@arm.com>
Date: Fri, 26 Sep 2014 20:57:43 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
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
Subject: Re: [PATCH v6 4/6] sched: get CPU's usage statistic
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org> <1411488485-10025-5-git-send-email-vincent.guittot@linaro.org> <54246791.9050101@arm.com> <CAKfTPtCzVRY4q184nqHSL7zFh1CvF009p8q8EPFCZxDFMx9TeQ@mail.gmail.com>
In-Reply-To: <CAKfTPtCzVRY4q184nqHSL7zFh1CvF009p8q8EPFCZxDFMx9TeQ@mail.gmail.com>
X-OriginalArrivalTime: 26 Sep 2014 19:57:43.0494 (UTC) FILETIME=[22A2B660:01CFD9C4]
X-MC-Unique: 114092620574400201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/14 13:17, Vincent Guittot wrote:
> On 25 September 2014 21:05, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
>> On 23/09/14 17:08, Vincent Guittot wrote:

[...]

>>>
>>> +static int get_cpu_usage(int cpu)
>>> +{
>>> +     unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
>>> +     unsigned long capacity = capacity_orig_of(cpu);
>>> +
>>> +     if (usage >= SCHED_LOAD_SCALE)
>>> +             return capacity + 1;
>>
>> Why you are returning rq->cpu_capacity_orig + 1 (1025) in case
>> utilization_load_avg is greater or equal than 1024 and not usage or
>> (usage * capacity) >> SCHED_LOAD_SHIFT too?
> 
> The usage can't be higher than the full capacity of the CPU because
> it's about the running time on this CPU. Nevertheless, usage can be
> higher than SCHED_LOAD_SCALE because of unfortunate rounding in
> avg_period and running_load_avg or just after migrating tasks until
> the average stabilizes with the new running time.

Ok, I got it now, thanks!


When running 'hackbench -p -T -s 10 -l 1' on TC2, the usage for a cpu
goes occasionally also much higher than SCHED_LOAD_SCALE. After all,
p->se.avg.running_avg_sum is initialized to slice in
init_task_runnable_average.

> 
>>
>> In case the weight of a sched group is greater than 1, you might loose
>> the information that the whole sched group is over-utilized too.
> 
> that's exactly for sched_group with more than 1 CPU that we need to
> cap the usage of a CPU to 100%. Otherwise, the group could be seen as
> overloaded (CPU0 usage at 121% + CPU1 usage at 80%) whereas CPU1 has
> 20% of available capacity

Makes sense, we don't want to do anything in this case on a sched level
(e.g. DIE), the appropriate level below (e.g. MC) should balance this
out first. Got it!

> 
>>
>> You add up the individual cpu usage values for a group by
>> sgs->group_usage += get_cpu_usage(i) in update_sg_lb_stats and later use
>> sgs->group_usage in group_is_overloaded to compare it against
>> sgs->group_capacity (taking imbalance_pct into consideration).
>>
>>> +
>>> +     return (usage * capacity) >> SCHED_LOAD_SHIFT;
>>
>> Nit-pick: Since you're multiplying by a capacity value
>> (rq->cpu_capacity_orig) you should shift by SCHED_CAPACITY_SHIFT.
> 
> we want to compare the output of the function with some capacity
> figures so i think that >> SCHED_LOAD_SHIFT is the right operation.
> 
>>
>> Just to make sure: You do this scaling of usage by cpu_capacity_orig
>> here only to cater for the fact that cpu_capacity_orig might be uarch
>> scaled (by arch_scale_cpu_capacity, !SMT) in update_cpu_capacity while
> 
> I do this for any system with CPUs that have an original capacity that
> is different from SCHED_CAPACITY_SCALE so it's for both uArch and SMT.

Understood so your current patch-set is doing uArch scaling for capacity
and since you're not doing uArch scaling for utilization, you do this '*
capacity) >> SCHED_LOAD_SHIFT' thing. Correct?

> 
>> utilization_load_avg is currently not.
>> We don't even uArch scale on ARM TC2 big.LITTLE platform in mainline
>> today due to the missing clock-frequency property in the device tree.
> 
> sorry i don't catch your point

With mainline dts file for ARM TC2, the rq->cpu_capacity-orig is 1024
for all 5 cpus (A15's and A7's). The arm topology shim layer barfs a

  /cpus/cpu@x missing clock-frequency property

per cpu in this case and doesn't scale the capacity. Only when I add

 clock-frequency = <xxxxxxxxx>;

per cpuX node into the dts file, I get a system with asymmetric
rq->cpu_capacity_orig values (606 for an A7 and 1441 for an A15).

> 
>>
>> I think it's hard for people to grasp that your patch-set takes uArch
>> scaling of capacity into consideration but not frequency scaling of
>> capacity (via arch_scale_freq_capacity, not used at the moment).

[...]

