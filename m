Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaKDLLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:11:04 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:59781 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaKDLLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:11:00 -0500
MIME-Version: 1.0
In-Reply-To: <5458AD87.7020709@gmail.com>
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
 <1414745252-4895-4-git-send-email-vincent.guittot@linaro.org>
 <54588E89.1080108@gmail.com> <CAKfTPtDOaE00BZnOYW8ioz22mi6H-4xkVa=25f44fQmh46Vq3w@mail.gmail.com>
 <5458AD87.7020709@gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 4 Nov 2014 12:10:37 +0100
Message-ID: <CAKfTPtAgg8b-ERmUXd0imTdp_pEvCX0uSvq7CZvfCs5gw49y+w@mail.gmail.com>
Subject: Re: [PATCH v8 03/10] sched: move cfs task on a CPU with higher capacity
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 11:42, Wanpeng Li <kernellwp@gmail.com> wrote:
> Hi Vincent,
>
>>>> +
>>>> +/*
>>>>     * Group imbalance indicates (and tries to solve) the problem where
>>>> balancing
>>>>     * groups is inadequate due to tsk_cpus_allowed() constraints.
>>>>     *
>>>> @@ -6562,6 +6574,28 @@ static int need_active_balance(struct lb_env
>>>> *env)
>>>>                          return 1;
>>>>          }
>>>>    +     /*
>>>> +        * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
>>>
>>>
>>> Why specify one task instead of not less than one?
>>
>> if cfs.h_nr_running == 0 (which should not occurs at that point), we
>> don't need to do more test to check if it's worth moving the task
>> because there is no task to move.
>
>
> Sorry for my confusing statement. I mean cfs.h_nr_running >= 1.

ok.

If we have more than 1 task, we fall back into the default balancing
policy than should move a not running task or that will use the
imbalance field in case of the presence of pinned tasks

Regards,
Vincent

>
> Regards,
> Wanpeng Li
>
>
>>
>> Regards,
>> Vincent
>>>
>>> Regards,
>>> Wanpeng Li
>>>
>>>
>>>> +        * It's worth migrating the task if the src_cpu's capacity is
>>>> reduced
>>>> +        * because of other sched_class or IRQs whereas capacity stays
>>>> +        * available on dst_cpu.
>>>> +        */
>>>> +       if ((env->idle != CPU_NOT_IDLE) &&
>>>> +                       (env->src_rq->cfs.h_nr_running == 1)) {
>>>> +               unsigned long src_eff_capacity, dst_eff_capacity;
>>>> +
>>>> +               dst_eff_capacity = 100;
>>>> +               dst_eff_capacity *= capacity_of(env->dst_cpu);
>>>> +               dst_eff_capacity *= capacity_orig_of(env->src_cpu);
>>>> +
>>>> +               src_eff_capacity = sd->imbalance_pct;
>>>> +               src_eff_capacity *= capacity_of(env->src_cpu);
>>>> +               src_eff_capacity *= capacity_orig_of(env->dst_cpu);
>>>> +
>>>> +               if (src_eff_capacity < dst_eff_capacity)
>>>> +                       return 1;
>>>> +       }
>>>> +
