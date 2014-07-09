Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaGII1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:27:55 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:52477 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaGII1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:27:53 -0400
MIME-Version: 1.0
In-Reply-To: <53BCBD0E.2070609@linux.vnet.ibm.com>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org>
 <53BB61E9.80200@linux.vnet.ibm.com> <CAKfTPtA8BVPtRRLzomqnGp7_uaSbFYmFTrrt4fpQTOb7qyjddg@mail.gmail.com>
 <53BCBD0E.2070609@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 9 Jul 2014 10:27:32 +0200
Message-ID: <CAKfTPtA3FXE+kK_E_c_GkN7LAP+rf6+S4jRxE-42mdmLuS3L7A@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] sched: fix imbalance flag reset
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
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

On 9 July 2014 05:54, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Vincent,
>
> On 07/08/2014 03:42 PM, Vincent Guittot wrote:

[ snip]

>>>>  out_balanced:
>>>> +     /*
>>>> +      * We reach balance although we may have faced some affinity
>>>> +      * constraints. Clear the imbalance flag if it was set.
>>>> +      */
>>>> +     if (sd_parent) {
>>>> +             int *group_imbalance = &sd_parent->groups->sgc->imbalance;
>>>> +             if (*group_imbalance)
>>>> +                     *group_imbalance = 0;
>>>> +     }
>>>> +
>>>>       schedstat_inc(sd, lb_balanced[idle]);
>>>>
>>>>       sd->nr_balance_failed = 0;
>>>>
>>> I am not convinced that we can clear the imbalance flag here. Lets take
>>> a simple example. Assume at a particular level of sched_domain, there
>>> are two sched_groups with one cpu each. There are 2 tasks on the source
>>> cpu, one of which is running(t1) and the other thread(t2) does not have
>>> the dst_cpu in the tsk_allowed_mask. Now no task can be migrated to the
>>> dst_cpu due to affinity constraints. Note that t2 is *not pinned, it
>>> just cannot run on the dst_cpu*. In this scenario also we reach the
>>> out_balanced tag right? If we set the group_imbalance flag to 0, we are
>>
>> No we will not. If we have 2 tasks on 1 CPU in one sched_group and the
>> other group with an idle CPU,  we are not balanced so we will not go
>> to out_balanced and the group_imbalance will staty set until we reach
>> a balanced state (by migrating t1).
>
> In the example that I mention above, t1 and t2 are on the rq of cpu0;
> while t1 is running on cpu0, t2 is on the rq but does not have cpu1 in
> its cpus allowed mask. So during load balance, cpu1 tries to pull t2,
> cannot do so, and hence LBF_ALL_PINNED flag is set and it jumps to

That's where I disagree: my understanding of can_migrate_task is that
the LBF_ALL_PINNED will be cleared before returning false when
checking t1 because we are testing all tasks even the running task

> out_balanced. Note that there are only two sched groups at this level of
> sched domain.one with cpu0 and the other with cpu1. In this scenario we
> do not try to do active load balancing, atleast thats what the code does
> now if LBF_ALL_PINNED flag is set.
>
>>
>>> ruling out the possibility of migrating t2 to any other cpu in a higher
>>> level sched_domain by saying that all is well, there is no imbalance.
>>> This is wrong, isn't it?
>>>
>>> My point is that by clearing the imbalance flag in the out_balanced
>>> case, you might be overlooking the fact that the tsk_cpus_allowed mask
>>> of the tasks on the src_cpu may not be able to run on the dst_cpu in
>>> *this* level of sched_domain, but can potentially run on a cpu at any
>>> higher level of sched_domain. By clearing the flag, we are not
>>
>> The imbalance flag is per sched_domain level so we will not clear
>> group_imbalance flag of other levels if the imbalance is also detected
>> at a higher level it will migrate t2
>
> Continuing with the above explanation; when LBF_ALL_PINNED flag is
> set,and we jump to out_balanced, we clear the imbalance flag for the
> sched_group comprising of cpu0 and cpu1,although there is actually an
> imbalance. t2 could still be migrated to say cpu2/cpu3 (t2 has them in
> its cpus allowed mask) in another sched group when load balancing is
> done at the next sched domain level.

The imbalance is per sched_domain level so it will not have any side
effect on the next level

Regards,
Vincent

>
> Elaborating on this, when cpu2 in another socket,lets say, begins load
> balancing and update_sd_pick_busiest() is called, the group with cpu0
> and cpu1 may not be picked as a potential imbalanced group. Had we not
> cleared the imbalance flag for this group, we could have balanced out t2
> to cpu2/3.
>
> Is the scenario I am describing clear?
>
> Regards
> Preeti U Murthy
>>
>> Regards,
>> Vincent
>>
>>> encouraging load balance at that level for t2.
>>>
>>> Am I missing something?
>>>
>>> Regards
>>> Preeti U Murthy
>>>
>>
>
