Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaGVLp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 07:45:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbaGVLpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 07:45:55 -0400
Date: Tue, 22 Jul 2014 13:45:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        tkhai@yandex.ru, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/5] sched: Teach scheduler to understand ONRQ_MIGRATING
 state
Message-ID: <20140722114542.GG20603@laptop.programming.kicks-ass.net>
References: <20140722102425.29682.24086.stgit@tkhai>
 <1406028616.3526.20.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406028616.3526.20.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:30:16PM +0400, Kirill Tkhai wrote:
> 
> This is new on_rq state for the cases when task is migrating
> from one src_rq to another dst_rq, and locks of the both RQs
> are unlocked.
> 
> We will use the state this way:
> 
> 	raw_spin_lock(&src_rq->lock);
> 	dequeue_task(src_rq, p, 0);
> 	p->on_rq = ONRQ_MIGRATING;
> 	set_task_cpu(p, dst_cpu);
> 	raw_spin_unlock(&src_rq->lock);
> 
> 	raw_spin_lock(&dst_rq->lock);
> 	p->on_rq = ONRQ_QUEUED;
> 	enqueue_task(dst_rq, p, 0);
> 	raw_spin_unlock(&dst_rq->lock);
> 
> The profit is that double_rq_lock() is not needed now,
> and this may reduce the latencies in some situations.
> 
> The logic of try_to_wake_up() remained the same as it
> was. Its behaviour changes in a small subset of cases
> (when preempted task in ~TASK_RUNNING state is queued
>  on rq and we are migrating it to another).

more details is better ;-) Also, I think Oleg enjoys these kind of
things, so I've added him to the CC.

A few questions, haven't really thought about things yet.

> @@ -1491,10 +1491,14 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
>  static void
>  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>  {
> -	check_preempt_curr(rq, p, wake_flags);
>  	trace_sched_wakeup(p, true);
>  
>  	p->state = TASK_RUNNING;
> +
> +	if (!task_queued(p))
> +		return;

How can this happen? we're in the middle of a wakeup, we're just added
the task to the rq and are still holding the appropriate rq->lock.

> @@ -4623,9 +4629,14 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>  	struct rq *rq;
>  	unsigned int dest_cpu;
>  	int ret = 0;
> -
> +again:
>  	rq = task_rq_lock(p, &flags);
>  
> +	if (unlikely(p->on_rq) == ONRQ_MIGRATING) {
> +		task_rq_unlock(rq, p, &flags);
> +		goto again;
> +	}
> +
>  	if (cpumask_equal(&p->cpus_allowed, new_mask))
>  		goto out;
>  

That looks like a non-deterministic spin loop, 'waiting' for the
migration to finish. Not particularly nice and something I think we
should avoid for it has bad (TM) worst case behaviour.

Also, why only this site and not all task_rq_lock() sites?
