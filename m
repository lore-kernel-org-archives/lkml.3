Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaBSNOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:14:45 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38235 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaBSNOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:14:43 -0500
Message-ID: <5304AE4E.6030208@gmail.com>
Date: Wed, 19 Feb 2014 14:14:54 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] sched/deadline: Fix bad accounting of nr_running
References: <20140214235946.60a89b65@gandalf.local.home> <53022F2D.8040301@gmail.com> <20140218215012.209059c0@gandalf.local.home> <20140219084618.GF27965@twins.programming.kicks-ass.net> <53048849.3000601@gmail.com>
In-Reply-To: <53048849.3000601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 11:32 AM, Juri Lelli wrote:
> On 02/19/2014 09:46 AM, Peter Zijlstra wrote:
>> On Tue, Feb 18, 2014 at 09:50:12PM -0500, Steven Rostedt wrote:
>>>  
>>>> Rationale for this odd behavior is that, when a task is throttled, it
>>>> is removed only from the dl_rq, but we keep it on_rq (as this is not
>>>> a "full dequeue", that is the task is not actually sleeping). But, it
>>>> is also true that, while throttled a task behaves like it is sleeping
>>>> (e.g., its timer will fire on a new CPU if the old one is dead). So,
>>>> Steven's fix sounds also semantically correct.
>>>
>>> Actually, it seems that I was hitting it again, but this time getting a
>>> negative number. OK, after looking at the code a bit more, I think we
>>> should update the runqueue nr_running only when the task is officially
>>> enqueued and dequeued, and all accounting within, will not touch that
>>> number.
> 
> This is a different way to get the same result (mildly tested on my box):
> 
> ---
>  kernel/sched/deadline.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 0dd5e09..675dad3 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -837,7 +837,8 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
>         if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
>                 enqueue_pushable_dl_task(rq, p);
> 
> -       inc_nr_running(rq);
> +       if (!(flags & ENQUEUE_REPLENISH))
> +               inc_nr_running(rq);
>  }
> 
>  static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
> --
> 
> We touch nr_running only when we don't enqueue back as a consequence
> of a replenishment.
> 
>>
>> But if the task is throttled it should still very much decrement the
>> number. There's places that very much rely on nr_running be exactly the
>> number of runnable tasks.
>>
> 
> This is a different thing, and V2 seemed to implement this behavior
> (that's why I said it looked semantically correct).
> 

So, both my last approach and Steven's V2 were causing nr_running to
become negative, as they double decrement it when dequeuing a task that
also exceeded its budget.

What follows seems to solve the issue, and correcly account for throttled
tasks as !nr_running.

---
 kernel/sched/deadline.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0dd5e09..b819577 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -717,6 +717,7 @@ void inc_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)

        WARN_ON(!dl_prio(prio));
        dl_rq->dl_nr_running++;
+       inc_nr_running(rq_of_dl_rq(dl_rq));

        inc_dl_deadline(dl_rq, deadline);
        inc_dl_migration(dl_se, dl_rq);
@@ -730,6 +731,7 @@ void dec_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
        WARN_ON(!dl_prio(prio));
        WARN_ON(!dl_rq->dl_nr_running);
        dl_rq->dl_nr_running--;
+       dec_nr_running(rq_of_dl_rq(dl_rq));

        dec_dl_deadline(dl_rq, dl_se->deadline);
        dec_dl_migration(dl_se, dl_rq);
@@ -836,8 +838,6 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)

        if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
                enqueue_pushable_dl_task(rq, p);
-
-       inc_nr_running(rq);
 }

 static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
@@ -850,8 +850,6 @@ static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
        update_curr_dl(rq);
        __dequeue_task_dl(rq, p, flags);
-
-       dec_nr_running(rq);
 }

 /*
-- 
1.7.9.5

Steven, could you test it?

Thanks,

- Juri
