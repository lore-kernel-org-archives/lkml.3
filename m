Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbaAUVqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:46:19 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:63781 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbaAUVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:46:14 -0500
From: bsegall@google.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, daniel.lezcano@linaro.org,
        pjt@google.com
Subject: Re: [PATCH 6/9] sched: Push put_prev_task() into pick_next_task()
References: <20140121111754.580142558@infradead.org>
	<20140121112258.586781016@infradead.org>
Date: Tue, 21 Jan 2014 13:46:11 -0800
In-Reply-To: <20140121112258.586781016@infradead.org> (Peter Zijlstra's
	message of "Tue, 21 Jan 2014 12:18:00 +0100")
Message-ID: <xm26sishj9ek.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> In order to avoid having to do put/set on a whole cgroup hierarchy
> when we context switch, push the put into pick_next_task() so that
> both operations are in the same function. Further changes then allow
> us to possibly optimize away redundant work.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1328936700.2476.17.camel@laptop
> --- a/kernel/sched/idle_task.c
> +++ b/kernel/sched/idle_task.c
> @@ -23,8 +23,12 @@ static void check_preempt_curr_idle(stru
>  	resched_task(rq->idle);
>  }
>  
> -static struct task_struct *pick_next_task_idle(struct rq *rq)
> +static struct task_struct *
> +pick_next_task_idle(struct rq *rq, struct task_struct *prev)
>  {
> +	if (prev)
> +		prev->sched_class->put_prev_task(rq, prev);
> +
>  	schedstat_inc(rq, sched_goidle);
>  #ifdef CONFIG_SMP
>  	idle_enter_fair(rq);
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1310,15 +1310,7 @@ static struct task_struct *_pick_next_ta
>  {
>  	struct sched_rt_entity *rt_se;
>  	struct task_struct *p;
> -	struct rt_rq *rt_rq;
> -
> -	rt_rq = &rq->rt;
> -
> -	if (!rt_rq->rt_nr_running)
> -		return NULL;
> -
> -	if (rt_rq_throttled(rt_rq))
> -		return NULL;
> +	struct rt_rq *rt_rq  = &rq->rt;
>  
>  	do {
>  		rt_se = pick_next_rt_entity(rq, rt_rq);
> @@ -1332,9 +1324,22 @@ static struct task_struct *_pick_next_ta
>  	return p;
>  }
>  
> -static struct task_struct *pick_next_task_rt(struct rq *rq)
> +static struct task_struct *
> +pick_next_task_rt(struct rq *rq, struct task_struct *prev)
>  {
> -	struct task_struct *p = _pick_next_task_rt(rq);
> +	struct task_struct *p;
> +	struct rt_rq *rt_rq = &rq->rt;
> +
> +	if (!rt_rq->rt_nr_running)
> +		return NULL;
> +
> +	if (rt_rq_throttled(rt_rq))
> +		return NULL;
> +
> +	if (prev)
> +		prev->sched_class->put_prev_task(rq, prev);
> +
> +	p = _pick_next_task_rt(rq);
>  
>  	/* The running task is never eligible for pushing */
>  	if (p)
p is now always non-NULL, so this branch can now go (and it is important
that we can't fail after doing put).
