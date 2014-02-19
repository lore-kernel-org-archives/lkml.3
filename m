Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaBSKcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:32:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33810 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaBSKcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:32:31 -0500
Message-ID: <53048849.3000601@gmail.com>
Date: Wed, 19 Feb 2014 11:32:41 +0100
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
References: <20140214235946.60a89b65@gandalf.local.home> <53022F2D.8040301@gmail.com> <20140218215012.209059c0@gandalf.local.home> <20140219084618.GF27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140219084618.GF27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 09:46 AM, Peter Zijlstra wrote:
> On Tue, Feb 18, 2014 at 09:50:12PM -0500, Steven Rostedt wrote:
>>  
>>> Rationale for this odd behavior is that, when a task is throttled, it
>>> is removed only from the dl_rq, but we keep it on_rq (as this is not
>>> a "full dequeue", that is the task is not actually sleeping). But, it
>>> is also true that, while throttled a task behaves like it is sleeping
>>> (e.g., its timer will fire on a new CPU if the old one is dead). So,
>>> Steven's fix sounds also semantically correct.
>>
>> Actually, it seems that I was hitting it again, but this time getting a
>> negative number. OK, after looking at the code a bit more, I think we
>> should update the runqueue nr_running only when the task is officially
>> enqueued and dequeued, and all accounting within, will not touch that
>> number.

This is a different way to get the same result (mildly tested on my box):

---
 kernel/sched/deadline.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0dd5e09..675dad3 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -837,7 +837,8 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
        if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
                enqueue_pushable_dl_task(rq, p);

-       inc_nr_running(rq);
+       if (!(flags & ENQUEUE_REPLENISH))
+               inc_nr_running(rq);
 }

 static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
--

We touch nr_running only when we don't enqueue back as a consequence
of a replenishment.

> 
> But if the task is throttled it should still very much decrement the
> number. There's places that very much rely on nr_running be exactly the
> number of runnable tasks.
> 

This is a different thing, and V2 seemed to implement this behavior
(that's why I said it looked semantically correct).

Thanks,

- Juri
