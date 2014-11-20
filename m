Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbaKTPGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:06:46 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:48272 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbaKTPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:06:45 -0500
MIME-Version: 1.0
In-Reply-To: <CADcy93VyTMPL1W1WcBtaMk5+kJnU_5GWGCAxPxsbpDMzAGU26A@mail.gmail.com>
References: <1416411982-1204-1-git-send-email-pang.xunlei@linaro.org>
	<1416411982-1204-3-git-send-email-pang.xunlei@linaro.org>
	<20141119112451.6fef30f0@gandalf.local.home>
	<CADcy93VyTMPL1W1WcBtaMk5+kJnU_5GWGCAxPxsbpDMzAGU26A@mail.gmail.com>
Date: Thu, 20 Nov 2014 23:06:44 +0800
Message-ID: <CADcy93V_8xO6ozg9ROyotyOjZnRZ5fL=iA-kwt=hA2o1qeyUvA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] sched/deadline: add the "set_flag" argument to cpudl_find()
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2014 22:58, pang.xunlei <pang.xunlei@linaro.org> wrote:
> On 20 November 2014 00:24, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Wed, 19 Nov 2014 23:46:21 +0800
>> "pang.xunlei" <pang.xunlei@linaro.org> wrote:
>>
>>> The call site of cpudl_find() in check_preempt_equal_dl() doesn't
>>> use later_mask, so add this extra argument to distinquish the case.
>>>
>>> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
>>> ---
>>>  kernel/sched/cpudeadline.c |    6 ++++--
>>>  kernel/sched/cpudeadline.h |    2 +-
>>>  kernel/sched/deadline.c    |    6 +++---
>>>  3 files changed, 8 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
>>> index c01b3aa..3047846 100644
>>> --- a/kernel/sched/cpudeadline.c
>>> +++ b/kernel/sched/cpudeadline.c
>>> @@ -98,11 +98,12 @@ static inline int cpudl_maximum(struct cpudl *cp)
>>>   * @cp: the cpudl max-heap context
>>>   * @p: the task
>>>   * @later_mask: a mask to fill in with the selected CPUs (not NULL)
>>> + * @set_flag: indicate if later_mask should be set
>>>   *
>>>   * Returns: int - best CPU (heap maximum if suitable)
>>>   */
>>>  int cpudl_find(struct cpudl *cp, struct task_struct *p,
>>> -            struct cpumask *later_mask)
>>> +            struct cpumask *later_mask, int set_flag)
>>
>> set_flag should be a bool type.
>>
>>>  {
>>>       int best_cpu = -1;
>>>       const struct sched_dl_entity *dl_se = &p->dl;
>>> @@ -114,7 +115,8 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
>>>       } else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
>>>                       dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
>>>               best_cpu = cpudl_maximum(cp);
>>> -             cpumask_set_cpu(best_cpu, later_mask);
>>> +             if (set_flag)
>>> +                     cpumask_set_cpu(best_cpu, later_mask);
>>
>> I'm not sure this is worth it. cpumask_set_cpu() is rather efficient.
> HI Steve,
>
> Thanks for your commenting, I've rethinked this a bit.
> We can do a little trick with its return value, then could avoid this
> extra cpumask_set_cpu() without this extra set_flag:
> 1) define macros for the return values of cpudl_find(), like:
> #define    CPUDL_FIND_NONE          -2  /* no available cpus */
> #define    CPUDL_FIND_CPUMASK   -1  /* available cpus in later_mask */
>
> then, with the return value >=0, means it returns the only one available cpu.
>
> 2) In the leg of "if", it can just return CPUDL_FIND_CPUMASK, as we
> want to select the best_cpu in find_later_rq().
> In the leg of "else if", just returns cpudl_maximum(cp), apparently
> there is no need to set the later_mask, since we will definitely
> select this cpu as the best_cpu in find_later_rq() .
>
> int cpudl_find(struct cpudl *cp, struct task_struct *p,
>            struct cpumask *later_mask)
> {
>     const struct sched_dl_entity *dl_se = &p->dl;
>
>     cpumask_and(later_mask, &p->cpus_allowed, &p->cpus_allowed);
Apologies for this typo, it should be:
cpumask_and(later_mask, cpu_active_mask, &p->cpus_allowed);

>     if (cpumask_and(later_mask, later_mask, cp->free_cpus)) {
>         return CPUDL_FIND_CPUMASK;
>     } else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
>                 dl_time_before(dl_se->deadline, cp->elements[0].dl))
>         int cpu;
>
>         cpu = cpudl_maximum(cp);
>         WARN_ON(!cpu_present(cpu));
>         return cpu;
>     }
>
> out:
also delete this lable.
>
>     return CPUDL_FIND_NONE;
> }
>
> Thus, in find_later_rq() we can change the call site code like:
>     best_cpu = cpudl_find(&task_rq(task)->rd->cpudl, task,
>                            later_mask);
>     if (best_cpu == CPUDL_FIND_NONE)
>         return -1;
>     if (best_cpu != CPUDL_FIND_CPUMASK)
>         return best_cpu;
>
>     /* adjust the following code as that in RT find_lowest_rq(), omit here... */
>
> What's your view about this?
>
> Thanks,
> Xunlei
>>
>>>       }
>>>
>>>  out:
>>
