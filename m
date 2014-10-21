Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbaJUNPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:15:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38135 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaJUNPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:15:38 -0400
Message-ID: <54465C77.8070209@arm.com>
Date: Tue, 21 Oct 2014 14:15:35 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <kernellwp@gmail.com>,
        "peterz@infradead.org" <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "michael@amarulasolutions.com" <michael@amarulasolutions.com>,
        "fchecconi@gmail.com" <fchecconi@gmail.com>,
        "daniel.wagner@bmw-carit.de" <daniel.wagner@bmw-carit.de>,
        "vincent@legout.info" <vincent@legout.info>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] sched/deadline: clear dl_entity params when setscheduling
 to different class
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com> <1411118561-26323-2-git-send-email-juri.lelli@arm.com> <54352ECB.5030507@gmail.com> <54464E79.2050601@gmail.com>
In-Reply-To: <54464E79.2050601@gmail.com>
X-OriginalArrivalTime: 21 Oct 2014 13:15:34.0949 (UTC) FILETIME=[193AAD50:01CFED31]
X-MC-Unique: 114102114153601401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21/10/14 13:15, Wanpeng Li wrote:
> ping,
> 
> 于 10/8/14, 8:32 PM, Wanpeng Li 写道:
>> Hi Juri,
>>
>> 于 9/19/14, 5:22 PM, Juri Lelli 写道:
>>> When a task is using SCHED_DEADLINE and the user setschedules it to a 
>>> different
>>> class its sched_dl_entity static parameters are not cleaned up. This 
>>> causes a
>>> bug if the user sets it back to SCHED_DEADLINE with the same 
>>> parameters again.
>>> The problem resides in the check we perform at the very beginning of
>>> dl_overflow():
>>>
>>>     if (new_bw == p->dl.dl_bw)
>>>         return 0;
>>>
>>> This condition is met in the case depicted above, so the function 
>>> returns and
>>> dl_b->total_bw is not updated (the p->dl.dl_bw is not added to it). 
>>> After this,
>>
>> As you know there is no static parameter clear before this patch, so 
>> if p->dl.dl_bw will decrease from dl_b->total_bw when the user 
>> setschedules to a different class instead of dl?
>>

We remove p->dl.dl_bw from dl_b->total_bw in dl_overflow(). Then this
patch introduces the clearing of p->dl params.

Thanks,

- Juri

>> Regards,
>> Wanpeng Li
>>
>>> admission control is broken.
>>>
>>> This patch fixes the thing, properly clearing static parameters for a 
>>> task
>>> that ceases to use SCHED_DEADLINE.
>>>
>>> Reported-by: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
>>> Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
>>> Reported-by: Vincent Legout <vincent@legout.info>
>>> Tested-by: Luca Abeni <luca.abeni@unitn.it>
>>> Signed-off-by: Juri Lelli <juri.lelli@arm.com>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Juri Lelli <juri.lelli@gmail.com>
>>> Cc: Dario Faggioli <raistlin@linux.it>
>>> Cc: Michael Trimarchi <michael@amarulasolutions.com>
>>> Cc: Fabio Checconi <fchecconi@gmail.com>
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>   kernel/sched/core.c     | 19 +++++++++++++++----
>>>   kernel/sched/deadline.c |  2 ++
>>>   kernel/sched/sched.h    |  3 +++
>>>   3 files changed, 20 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index ec1a286..581a429 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -1776,6 +1776,20 @@ int wake_up_state(struct task_struct *p, 
>>> unsigned int state)
>>>   }
>>>     /*
>>> + * This function clears the sched_dl_entity static params.
>>> + */
>>> +void __dl_clear_params(struct task_struct *p)
>>> +{
>>> +    struct sched_dl_entity *dl_se = &p->dl;
>>> +
>>> +    dl_se->dl_runtime = 0;
>>> +    dl_se->dl_deadline = 0;
>>> +    dl_se->dl_period = 0;
>>> +    dl_se->flags = 0;
>>> +    dl_se->dl_bw = 0;
>>> +}
>>> +
>>> +/*
>>>    * Perform scheduler related setup for a newly forked process p.
>>>    * p is forked by current.
>>>    *
>>> @@ -1799,10 +1813,7 @@ static void __sched_fork(unsigned long 
>>> clone_flags, struct task_struct *p)
>>>         RB_CLEAR_NODE(&p->dl.rb_node);
>>>       hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>>> -    p->dl.dl_runtime = p->dl.runtime = 0;
>>> -    p->dl.dl_deadline = p->dl.deadline = 0;
>>> -    p->dl.dl_period = 0;
>>> -    p->dl.flags = 0;
>>> +    __dl_clear_params(p);
>>>         INIT_LIST_HEAD(&p->rt.run_list);
>>>   diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>>> index 255ce13..4a51b14 100644
>>> --- a/kernel/sched/deadline.c
>>> +++ b/kernel/sched/deadline.c
>>> @@ -1569,6 +1569,8 @@ static void switched_from_dl(struct rq *rq, 
>>> struct task_struct *p)
>>>       if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
>>>           hrtimer_try_to_cancel(&p->dl.dl_timer);
>>>   +    __dl_clear_params(p);
>>> +
>>>   #ifdef CONFIG_SMP
>>>       /*
>>>        * Since this might be the only -deadline task on the rq,
>>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>>> index 579712f..4890484 100644
>>> --- a/kernel/sched/sched.h
>>> +++ b/kernel/sched/sched.h
>>> @@ -126,6 +126,9 @@ struct rt_bandwidth {
>>>       u64            rt_runtime;
>>>       struct hrtimer        rt_period_timer;
>>>   };
>>> +
>>> +void __dl_clear_params(struct task_struct *p);
>>> +
>>>   /*
>>>    * To keep the bandwidth of -deadline tasks and groups under control
>>>    * we need some place where:
>>
> 
> 

