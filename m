Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaGHKNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:13:07 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49338 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaGHKNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:13:05 -0400
MIME-Version: 1.0
In-Reply-To: <53BB61E9.80200@linux.vnet.ibm.com>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org> <53BB61E9.80200@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 8 Jul 2014 12:12:44 +0200
Message-ID: <CAKfTPtA8BVPtRRLzomqnGp7_uaSbFYmFTrrt4fpQTOb7qyjddg@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] sched: fix imbalance flag reset
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
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

On 8 July 2014 05:13, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 06/30/2014 09:35 PM, Vincent Guittot wrote:
>> The imbalance flag can stay set whereas there is no imbalance.
>>
>> Let assume that we have 3 tasks that run on a dual cores /dual cluster system.
>> We will have some idle load balance which are triggered during tick.
>> Unfortunately, the tick is also used to queue background work so we can reach
>> the situation where short work has been queued on a CPU which already runs a
>> task. The load balance will detect this imbalance (2 tasks on 1 CPU and an idle
>> CPU) and will try to pull the waiting task on the idle CPU. The waiting task is
>> a worker thread that is pinned on a CPU so an imbalance due to pinned task is
>> detected and the imbalance flag is set.
>> Then, we will not be able to clear the flag because we have at most 1 task on
>> each CPU but the imbalance flag will trig to useless active load balance
>> between the idle CPU and the busy CPU.
>>
>> We need to reset of the imbalance flag as soon as we have reached a balanced
>> state.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c | 14 +++++++++++---
>>  1 file changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index d3c73122..0c48dff 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -6615,10 +6615,8 @@ more_balance:
>>               if (sd_parent) {
>>                       int *group_imbalance = &sd_parent->groups->sgc->imbalance;
>>
>> -                     if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
>> +                     if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0)
>>                               *group_imbalance = 1;
>> -                     } else if (*group_imbalance)
>> -                             *group_imbalance = 0;
>>               }
>>
>>               /* All tasks on this runqueue were pinned by CPU affinity */
>> @@ -6703,6 +6701,16 @@ more_balance:
>>       goto out;
>>
>>  out_balanced:
>> +     /*
>> +      * We reach balance although we may have faced some affinity
>> +      * constraints. Clear the imbalance flag if it was set.
>> +      */
>> +     if (sd_parent) {
>> +             int *group_imbalance = &sd_parent->groups->sgc->imbalance;
>> +             if (*group_imbalance)
>> +                     *group_imbalance = 0;
>> +     }
>> +
>>       schedstat_inc(sd, lb_balanced[idle]);
>>
>>       sd->nr_balance_failed = 0;
>>
> I am not convinced that we can clear the imbalance flag here. Lets take
> a simple example. Assume at a particular level of sched_domain, there
> are two sched_groups with one cpu each. There are 2 tasks on the source
> cpu, one of which is running(t1) and the other thread(t2) does not have
> the dst_cpu in the tsk_allowed_mask. Now no task can be migrated to the
> dst_cpu due to affinity constraints. Note that t2 is *not pinned, it
> just cannot run on the dst_cpu*. In this scenario also we reach the
> out_balanced tag right? If we set the group_imbalance flag to 0, we are

No we will not. If we have 2 tasks on 1 CPU in one sched_group and the
other group with an idle CPU,  we are not balanced so we will not go
to out_balanced and the group_imbalance will staty set until we reach
a balanced state (by migrating t1).

> ruling out the possibility of migrating t2 to any other cpu in a higher
> level sched_domain by saying that all is well, there is no imbalance.
> This is wrong, isn't it?
>
> My point is that by clearing the imbalance flag in the out_balanced
> case, you might be overlooking the fact that the tsk_cpus_allowed mask
> of the tasks on the src_cpu may not be able to run on the dst_cpu in
> *this* level of sched_domain, but can potentially run on a cpu at any
> higher level of sched_domain. By clearing the flag, we are not

The imbalance flag is per sched_domain level so we will not clear
group_imbalance flag of other levels if the imbalance is also detected
at a higher level it will migrate t2

Regards,
Vincent

> encouraging load balance at that level for t2.
>
> Am I missing something?
>
> Regards
> Preeti U Murthy
>
