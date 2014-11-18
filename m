Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaKROC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:02:57 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:51618 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbaKROCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:02:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141117151515.670e2cd2@gandalf.local.home>
References: <1416240664-7200-1-git-send-email-pang.xunlei@linaro.org>
	<1416240664-7200-2-git-send-email-pang.xunlei@linaro.org>
	<20141117151515.670e2cd2@gandalf.local.home>
Date: Tue, 18 Nov 2014 22:02:53 +0800
Message-ID: <CADcy93VyhFOeanJqmEcB1NN=TddjMEdfx5Ndd2aiCrGCwUfGwA@mail.gmail.com>
Subject: Re: [PATCH 2/2] sched/deadline: Fix wrong cpudl_find() in check_preempt_equal_dl()
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2014 04:15, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 18 Nov 2014 00:11:04 +0800
> "pang.xunlei" <pang.xunlei@linaro.org> wrote:
>
>> In check_preempt_equal_dl(), cpudl_find() is called with a NULL later_mask,
>> thus cpudl_find() here doesn't check cpudl.free_cpus at all.
>>
>> This patch takles this issue by always passing a non-NULL cpumask to cpudl_find(),
>> and assigns later_mask in this function.
>>
>> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
>> ---
>>  kernel/sched/cpudeadline.c | 14 ++++++--------
>>  kernel/sched/deadline.c    | 10 ++++++----
>>  2 files changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
>> index 9a69353..623f7b5 100755
>> --- a/kernel/sched/cpudeadline.c
>> +++ b/kernel/sched/cpudeadline.c
>> @@ -97,7 +97,7 @@ static inline int cpudl_maximum(struct cpudl *cp)
>>   * cpudl_find - find the best (later-dl) CPU in the system
>>   * @cp: the cpudl max-heap context
>>   * @p: the task
>> - * @later_mask: a mask to fill in with the selected CPUs (or NULL)
>> + * @later_mask: a mask to fill in with the selected CPUs (not NULL)
>>   *
>>   * Returns: int - best CPU (heap maximum if suitable)
>>   */
>> @@ -107,16 +107,14 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
>>       int best_cpu = -1;
>>       const struct sched_dl_entity *dl_se = &p->dl;
>>
>> -     if (later_mask && cpumask_and(later_mask, cp->free_cpus,
>> -                     &p->cpus_allowed) && cpumask_and(later_mask,
>> -                     later_mask, cpu_active_mask)) {
>> +     cpumask_and(later_mask, cpu_active_mask, &p->cpus_allowed);
>> +     if (cpumask_and(later_mask, later_mask, cp->free_cpus)) {
>>               best_cpu = cpumask_any(later_mask);
>>               goto out;
>> -     } else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
>> -                     dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
>> +     } else if (cpumask_and(later_mask, cpumask_of(cpudl_maximum(cp)),
>> +                     &p->cpus_allowed) && dl_time_before(dl_se->deadline,
>> +                     cp->elements[0].dl)) {
>>               best_cpu = cpudl_maximum(cp);
>> -             if (later_mask)
>> -                     cpumask_set_cpu(best_cpu, later_mask);
>>       }
>>
>
> OK, I need to make this a before/after, as patch format sucks in this
> case.
>
> before:
>
>         if (later_mask &&
>             cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed) &&
>             cpumask_and(later_mask, later_mask, cpu_active_mask)) {
>                 best_cpu = cpumask_any(later_mask);
>                 goto out;
>         } else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
>                 dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
>                 best_cpu = cpudl_maximum(cp);
>                 if (later_mask)
>                         cpumask_set_cpu(best_cpu, later_mask);
>         }
>
> after:
>
>         cpumask_and(later_mask, cpu_active_mask, &p->cpus_allowed);
>         if (cpumask_and(later_mask, later_mask, cp->free_cpus)) {
>                 best_cpu = cpumask_any(later_mask);
>                 goto out;
>         } else if (cpumask_and(later_mask, cpumask_of(cpudl_maximum(cp)),
>                         &p->cpus_allowed) && dl_time_before(dl_se->deadline,
>                         cp->elements[0].dl)) {
>                 best_cpu = cpudl_maximum(cp);
>         }
>
> Again, the above else if is rather ugly. Note, if the first
> cpumask_and() is zero, there's no reason to call cpumask_and() (which
> could be expensive) the second time. Keep the two together with &&.
>
> Also, I wouldn't convert the cpumask_test_cpu() to a cpumask_and(), as
> I would think that would be more expensive to copy an entire mask
> (think what happens when we have a thousand CPUs). Just doing a test,
> and then if the test succeeds (remember, there's another test that
> might fail after it), then just set the one bit.

Hi Steve,

Thanks for pointing me out, it does make sense. I'll fix it and send
out another version.

But one more thing:
I made this change just want to avoid setting later_mask
conditionally, since the call site of check_preempt_equal_dl() doesn't
need the result of later_mask.

So, I wonder if it's reasonable to deal with this function further:
1) to introduce the 4th parameter to cpudl_find() like "int
set_flag"(in the hopes that it can gain some performance?), then the
code will be like this:
 int cpudl_find(struct cpudl *cp, struct task_struct *p,
            struct cpumask *later_mask, int set_flag)
 {
        int best_cpu = -1;
        const struct sched_dl_entity *dl_se = &p->dl;

         cpumask_and(later_mask, cpu_active_mask, &p->cpus_allowed);
         if (cpumask_and(later_mask, later_mask, cp->free_cpus)) {
                 best_cpu = cpumask_any(later_mask);
                 goto out;
         } else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
                     dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
             best_cpu = cpudl_maximum(cp);
             if (set_flag)
                  cpumask_set_cpu(best_cpu, later_mask); // does this
have some performance gain?
        }

out:
    WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));

    return best_cpu;
}

2) also, may put the best_cpu selecting back into find_later_rq()
where we can select additionally according to the sd topology,
obviously the cpumask_any() in cpudl_find() isn't the best one. Then
the code will be like this (change its return type to bool):

int cpudl_find(struct cpudl *cp, struct task_struct *p,
            struct cpumask *later_mask, int set_flag)
 {
        const struct sched_dl_entity *dl_se = &p->dl;

         cpumask_and(later_mask, cpu_active_mask, &p->cpus_allowed);
         if (cpumask_and(later_mask, later_mask, cp->free_cpus)) {
                return 1;
         } else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
                     dl_time_before(dl_se->deadline,
cp->elements[0].dl)) {
             if (set_flag)
                  cpumask_set_cpu(cpudl_maximum(cp), later_mask);

              return 1;
        }

        return 0;
}

Are these two changes acceptable? Thanks!

Regards,
Xunlei

>
> --- Steve
>
>
>
>>  out:
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index bd83272..3ecf838 100755
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -965,14 +965,18 @@ out:
>>       return cpu;
>>  }
>>
>> +static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
>> +
>>  static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
>>  {
>> +     struct cpumask *later_mask = this_cpu_cpumask_var_ptr(local_cpu_mask_dl);
>> +
>>       /*
>>        * Current can't be migrated, useless to reschedule,
>>        * let's hope p can move out.
>>        */
>>       if (rq->curr->nr_cpus_allowed == 1 ||
>> -         cpudl_find(&rq->rd->cpudl, rq->curr, NULL) == -1)
>> +         cpudl_find(&rq->rd->cpudl, rq->curr, later_mask) == -1)
>>               return;
>>
>>       /*
>> @@ -980,7 +984,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
>>        * see if it is pushed or pulled somewhere else.
>>        */
>>       if (p->nr_cpus_allowed != 1 &&
>> -         cpudl_find(&rq->rd->cpudl, p, NULL) != -1)
>> +         cpudl_find(&rq->rd->cpudl, p, later_mask) != -1)
>>               return;
>>
>>       resched_curr(rq);
>> @@ -1167,8 +1171,6 @@ next_node:
>>       return NULL;
>>  }
>>
>> -static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
>> -
>>  static int find_later_rq(struct task_struct *task)
>>  {
>>       struct sched_domain *sd;
>
