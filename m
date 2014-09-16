Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaIPLaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:30:18 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40685 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaIPLaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:30:16 -0400
Message-ID: <54181F34.5000406@linux.vnet.ibm.com>
Date: Tue, 16 Sep 2014 16:59:56 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kirill Tkhai <ktkhai@parallels.com>, preeti@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH] sched: Do not stop cpu in set_cpus_allowed_ptr() if task
 is not running
References: <1410519814.3569.7.camel@tkhai> <CAM4v1pPWKpoRjGqms8wXhMs0B1iLeVnUJRZu3iOW9Dy_44dCKQ@mail.gmail.com> <1410775350.3569.51.camel@tkhai>
In-Reply-To: <1410775350.3569.51.camel@tkhai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091611-1344-0000-0000-0000043B2B70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 03:32 PM, Kirill Tkhai wrote:
> Hi, Preeti,
> 
> В Пн, 15/09/2014 в 15:18 +0530, Preeti Murthy пишет:
>> Hi Kirill,
>>
>> Which tree is this patch based on? __migrate_task() does a
>> double_rq_lock/unlock() today in mainline, doesn't it? I don't
>> however see that in your patch.
> 
> it's based on recent tip tree:
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/
> 
> Also, once I received a build-robot message about my patch
> makes warning on allyesconfig, and since that time I learned
> about Peter's tree :) 
> 
> https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git
> 
> (This is for info, I don't know if it is right to make patches
> based on in. But really good if you was away for some time
> and you're interested in recent news without lkml archive reading.
> I use it :)

Ok I checked the patch against tip tree and the patch looks good to me.

Reviewed-by; Preeti U Murthy <preeti@linux.vnet.ibm.com>

Thanks!

Regards
Preeti U Murthy
> 
> Regards,
> Kirill
> 
>> On Fri, Sep 12, 2014 at 4:33 PM, Kirill Tkhai <ktkhai@parallels.com> wrote:
>>>
>>> If a task is queued but not running on it rq, we can simply migrate
>>> it without migration thread and switching of context.
>>>
>>> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
>>> ---
>>>  kernel/sched/core.c |   47 ++++++++++++++++++++++++++++++++---------------
>>>  1 file changed, 32 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index d4399b4..dbbba26 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -4594,6 +4594,33 @@ void init_idle(struct task_struct *idle, int cpu)
>>>  }
>>>
>>>  #ifdef CONFIG_SMP
>>> +/*
>>> + * move_queued_task - move a queued task to new rq.
>>> + *
>>> + * Returns (locked) new rq. Old rq's lock is released.
>>> + */
>>> +static struct rq *move_queued_task(struct task_struct *p, int new_cpu)
>>> +{
>>> +       struct rq *rq = task_rq(p);
>>> +
>>> +       lockdep_assert_held(&rq->lock);
>>> +
>>> +       dequeue_task(rq, p, 0);
>>> +       p->on_rq = TASK_ON_RQ_MIGRATING;
>>> +       set_task_cpu(p, new_cpu);
>>> +       raw_spin_unlock(&rq->lock);
>>> +
>>> +       rq = cpu_rq(new_cpu);
>>> +
>>> +       raw_spin_lock(&rq->lock);
>>> +       BUG_ON(task_cpu(p) != new_cpu);
>>> +       p->on_rq = TASK_ON_RQ_QUEUED;
>>> +       enqueue_task(rq, p, 0);
>>> +       check_preempt_curr(rq, p, 0);
>>> +
>>> +       return rq;
>>> +}
>>> +
>>>  void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
>>>  {
>>>         if (p->sched_class && p->sched_class->set_cpus_allowed)
>>> @@ -4650,14 +4677,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>>>                 goto out;
>>>
>>>         dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
>>> -       if (task_on_rq_queued(p) || p->state == TASK_WAKING) {
>>> +       if (task_running(rq, p) || p->state == TASK_WAKING) {
>>>                 struct migration_arg arg = { p, dest_cpu };
>>>                 /* Need help from migration thread: drop lock and wait. */
>>>                 task_rq_unlock(rq, p, &flags);
>>>                 stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
>>>                 tlb_migrate_finish(p->mm);
>>>                 return 0;
>>> -       }
>>> +       } else if (task_on_rq_queued(p))
>>> +               rq = move_queued_task(p, dest_cpu);
>>>  out:
>>>         task_rq_unlock(rq, p, &flags);
>>>
>>> @@ -4700,19 +4728,8 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
>>>          * If we're not on a rq, the next wake-up will ensure we're
>>>          * placed properly.
>>>          */
>>> -       if (task_on_rq_queued(p)) {
>>> -               dequeue_task(rq, p, 0);
>>> -               p->on_rq = TASK_ON_RQ_MIGRATING;
>>> -               set_task_cpu(p, dest_cpu);
>>> -               raw_spin_unlock(&rq->lock);
>>> -
>>> -               rq = cpu_rq(dest_cpu);
>>> -               raw_spin_lock(&rq->lock);
>>> -               BUG_ON(task_rq(p) != rq);
>>> -               p->on_rq = TASK_ON_RQ_QUEUED;
>>> -               enqueue_task(rq, p, 0);
>>> -               check_preempt_curr(rq, p, 0);
>>> -       }
>>> +       if (task_on_rq_queued(p))
>>> +               rq = move_queued_task(p, dest_cpu);
>>>  done:
>>>         ret = 1;
>>>  fail:
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

