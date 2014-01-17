Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaAQO0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:26:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35330 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:26:50 -0500
Date: Fri, 17 Jan 2014 15:26:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 4/4] sched: Idle task shortcut optimization
Message-ID: <20140117142644.GI11314@laptop.programming.kicks-ass.net>
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org>
 <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 10:04:04AM +0100, Daniel Lezcano wrote:
> @@ -2679,11 +2715,8 @@ need_resched:
>  
>  	pre_schedule(rq, prev);
>  
> -	if (unlikely(!rq->nr_running))
> -		rq->idle_stamp = idle_balance(rq) ? 0 : rq_clock(rq);
> -
>  	put_prev_task(rq, prev);
> -	next = pick_next_task(rq);
> +	next = pick_next_task_or_idle(rq);
>  	clear_tsk_need_resched(prev);
>  	clear_preempt_need_resched();
>  	rq->skip_clock_update = 0;

I have vague memories that we need to have idle_balance() before
put_prev_task(), but I can't recollect why this would be so.

That said, if I resurrect these patches:

  https://lkml.org/lkml/2012/6/14/271

I suppose we could write something like:

struct task_struct *pick_next_task(struct rq *rq, struct task_struct *prev)
{
	const struct sched_class *class;
	struct task_struct *p;

again:
	if (likely(rq->nr_running)) {

		if (likely(rq->nr_running == rq->cfs.h_nr_running))
			return fair_sched_class.pick_next_task(rq, prev);

		for_each_class(class) {
			p = class->pick_next_task(rq, prev);
			if (p)
				return p;
		}
	}

	if (idle_balance(rq))
		goto again;

	rq->idle_stamp = rq_clock(rq);

	return idle_sched_class.pick_next_task(rq, prev);
}

Which keeps idle_balance() before put_prev_task(), and by using
idle_sched_clas.pick_next_task() doesn't rape the idle class interface
like you did :-)




