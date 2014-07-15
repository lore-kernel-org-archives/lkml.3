Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbaGONOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:14:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874AbaGONOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:14:45 -0400
Date: Tue, 15 Jul 2014 15:12:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: finish_task_switch && prev_state (Was: sched, timers: use
	after free in __lock_task_sighand when exiting a process)
Message-ID: <20140715131240.GA23014@redhat.com>
References: <53C2FF4D.3020606@oracle.com> <53C31A34.8030500@oracle.com> <20140714090449.GL9918@twins.programming.kicks-ass.net> <20140714144953.GA8173@redhat.com> <20140714160147.GA11986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714160147.GA11986@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, I am stupid, please ignore.

Of course a TASK_DEAD task can not schedule, but we can race with RUNNING ->
DEAD transition. So we should only do put_task_struct() if "prev" was already
TASK_DEAD before we drop the rq locks.

On 07/14, Oleg Nesterov wrote:
>
> On 07/14, Oleg Nesterov wrote:
> >
> > Yes, the task itself (or, depending ob pov, scheduler) has a reference.
> > copy_process() does
> >
> > 	/*
> > 	 * One for us, one for whoever does the "release_task()" (usually
> > 	 * parent)
> > 	 */
> > 	atomic_set(&tsk->usage, 2);
> >
> > "us" actually means that put_task_struct(TASK_DEAD).
>
> Off-topic, but I do not understand the huge comment in finish_task_switch().
> Perhaps this all was true a long ago, but currently "prev could be scheduled
> on another cpu" is certainly impossible?
>
> And if it was possible we have much more problems? In particular, in this case
> we still can drop the reference twice?
>
> I'll try to recheck, but do you see anything wrong in the patch below?
>
> Oleg.
>
> --- x/kernel/sched/core.c
> +++ x/kernel/sched/core.c
> @@ -2197,22 +2197,9 @@ static void finish_task_switch(struct rq
>  	__releases(rq->lock)
>  {
>  	struct mm_struct *mm = rq->prev_mm;
> -	long prev_state;
>
>  	rq->prev_mm = NULL;
>
> -	/*
> -	 * A task struct has one reference for the use as "current".
> -	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
> -	 * schedule one last time. The schedule call will never return, and
> -	 * the scheduled task must drop that reference.
> -	 * The test for TASK_DEAD must occur while the runqueue locks are
> -	 * still held, otherwise prev could be scheduled on another cpu, die
> -	 * there before we look at prev->state, and then the reference would
> -	 * be dropped twice.
> -	 *		Manfred Spraul <manfred@colorfullife.com>
> -	 */
> -	prev_state = prev->state;
>  	vtime_task_switch(prev);
>  	finish_arch_switch(prev);
>  	perf_event_task_sched_in(prev, current);
> @@ -2222,7 +2209,7 @@ static void finish_task_switch(struct rq
>  	fire_sched_in_preempt_notifiers(current);
>  	if (mm)
>  		mmdrop(mm);
> -	if (unlikely(prev_state == TASK_DEAD)) {
> +	if (unlikely(prev->state == TASK_DEAD)) {
>  		if (prev->sched_class->task_dead)
>  			prev->sched_class->task_dead(prev);
>

