Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaBQDb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 22:31:27 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43808 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBQDbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 22:31:25 -0500
Message-ID: <53018284.5070408@linux.vnet.ibm.com>
Date: Mon, 17 Feb 2014 11:31:16 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [RFC PATCH] sched: make sure sched-priority after invoke idle_balance()
References: <52FDA18D.40100@linux.vnet.ibm.com> <20140214123845.GI27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140214123845.GI27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021703-8878-0000-0000-00000AE8284A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 08:38 PM, Peter Zijlstra wrote:
[snip]
>>
>> This patch will prevent this happen by some rechecking after idle_balance(), it
>> utilize the resched-flag for the case when RT/DL task was enqueued but don't ask
>> for resched (will that ever happened?).
> 
> I'm not sure this is actually working right; the problem is that while
> we do retry on need_resched() in the main schedule() loop, that last
> need_resched() is on @next (then current). So clearing/resetting @prev's
> need_resched() is not going to trigger that loop.
> 
> Not to mention we explicitly clear @prev's need_resched right after
> pick_next_task().

Actually it's not aim at that timing, but consider about the RT case, it
won't work as expected anyway...

> 
> So how about something like this?
> 
> I don't particularly like adding that condition to pick_next_task(); but
> the alternative is recursively calling pick_next_task() and while
> recursion is strictly limited to the number of sched_classes, it does
> feel kinda icky.

Yeah...but it works, the RT stuff is inside the loop and really hard to
be handled...

> 
> Anybody got any preferences?
> 
> ---
> Subject: sched: Guarantee task priority in pick_next_task()
[snip]
>  pick_next_task(struct rq *rq, struct task_struct *prev)
>  {
> -	const struct sched_class *class;
> +	const struct sched_class *class = &fair_sched_class;
>  	struct task_struct *p;
> 
>  	/*
>  	 * Optimization: we know that if all tasks are in
>  	 * the fair class we can call that function directly:
>  	 */
> -	if (likely(prev->sched_class == &fair_sched_class &&
> +	if (likely(prev->sched_class == class &&
>  		   rq->nr_running == rq->cfs.h_nr_running)) {
>  		p = fair_sched_class.pick_next_task(rq, prev);
>  		if (likely(p))
> -			return p;
> +			goto got_task;

Since idle_balance() won't happen in the loop, may be we could use:

	if p && p->sched_class == class
		return p

in here, let it fall down into the loop if p is idle, since that means
we got RT/DL and will do this anyway, could save two jump work may be?
(and may could combine some code below if so?)

Regards,
Michael Wang

>  	}
> 
> +again:
>  	for_each_class(class) {
>  		p = class->pick_next_task(rq, prev);
>  		if (p)
> -			return p;
> +			goto got_task;
>  	}
> 
>  	BUG(); /* the idle class will always have a runnable task */
> +
> +got_task:
> +	/*
> +	 * See pick_next_task_{fair,rt}(); they return rq->idle in case
> +	 * they want to re-start the task selection.
> +	 */
> +	if (unlikely(p->sched_class != class))
> +		goto again;
> +
> +	return p;
>  }
> 
>  /*
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4684,6 +4684,7 @@ pick_next_task_fair(struct rq *rq, struc
>  	struct cfs_rq *cfs_rq = &rq->cfs;
>  	struct sched_entity *se;
>  	struct task_struct *p;
> +	int new_tasks;
> 
>  again:
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> @@ -4782,7 +4783,20 @@ pick_next_task_fair(struct rq *rq, struc
>  	return p;
> 
>  idle:
> -	if (idle_balance(rq)) /* drops rq->lock */
> +	/*
> +	 * Because idle_balance() releases (and re-acquires) rq->lock, it is
> +	 * possible for any higher priority task to appear. In that case we
> +	 * must re-start the pick_next_entity() loop.
> +	 */
> +	new_tasks = idle_balance(rq);
> +
> +	/*
> +	 * See pick_next_task(); we return rq->idle to restart task selection.
> +	 */
> +	if (rq->nr_running != rq->cfs.h_nr_running)
> +		return rq->idle;
> +
> +	if (new_tasks)
>  		goto again;
> 
>  	return NULL;
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1360,8 +1360,16 @@ pick_next_task_rt(struct rq *rq, struct
>  	struct task_struct *p;
>  	struct rt_rq *rt_rq = &rq->rt;
> 
> -	if (need_pull_rt_task(rq, prev))
> +	if (need_pull_rt_task(rq, prev)) {
>  		pull_rt_task(rq);
> +		/*
> +		 * pull_rt_task() can drop (and re-acquire) rq->lock; this
> +		 * means a dl task can slip in, in which case we need to
> +		 * re-start task selection.
> +		 */
> +		if (unlikely(rq->dl.dl_nr_running))
> +			return rq->idle;
> +	}
> 
>  	if (!rt_rq->rt_nr_running)
>  		return NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

