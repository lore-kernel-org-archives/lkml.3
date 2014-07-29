Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaG2Pzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:55:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaG2Pzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:55:39 -0400
Date: Tue, 29 Jul 2014 17:53:09 +0200
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
Message-ID: <20140729155309.GA30194@redhat.com>
References: <53C2FF4D.3020606@oracle.com> <53C31A34.8030500@oracle.com> <20140714090449.GL9918@twins.programming.kicks-ass.net> <20140714144953.GA8173@redhat.com> <20140714160147.GA11986@redhat.com> <20140715131240.GA23014@redhat.com> <20140715132353.GF9918@twins.programming.kicks-ass.net> <20140715142525.GA26029@redhat.com> <20140729091018.GT20603@laptop.programming.kicks-ass.net> <20140729092237.GU12054@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729092237.GU12054@laptop.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29, Peter Zijlstra wrote:
>
> On Tue, Jul 29, 2014 at 11:10:18AM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 15, 2014 at 04:25:25PM +0200, Oleg Nesterov wrote:
> >
> > > And probably I missed something again, but it seems that this logic is broken
> > > with __ARCH_WANT_UNLOCKED_CTXSW.
> > >
> > > Of course, even if I am right this is pure theoretical, but smp_wmb() before
> > > "->on_cpu = 0" is not enough and we need a full barrier ?
> >
> > (long delay there, forgot about this thread, sorry)
> >
> > Yes, I think I see that.. but now I think the comment is further wrong.
> >
> > Its not rq->lock that is important, remember, a concurrent wakeup onto
> > another CPU does not require our rq->lock at all.
> >
> > It is the ->on_cpu = 0 store that is important (for both the
> > UNLOCKED_CTXSW cases). As soon as that store comes through the task can
> > start running on the remote cpu.

Yes, I came to the same conclusion right after I sent that email.

> > Now the below patch 'fixes' this but at the cost of adding a full
> > barrier which is somewhat unfortunate to say the least.

And yes, this is obviously the "fix" I had in mind, but:

> > wmb's are free on x86 and generally cheaper than mbs, so it would to
> > find another solution to this problem...
>
> Something like so then?

Hmm, indeed! Unfortunately I didn't find this simple solution. Yes, I think
we should check current->state == TASK_DEAD,

> @@ -2304,6 +2293,21 @@ context_switch(struct rq *rq, struct task_struct *prev,
>  	       struct task_struct *next)
>  {
>  	struct mm_struct *mm, *oldmm;
> +	/*
> +	 * A task struct has one reference for the use as "current".
> +	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
> +	 * schedule one last time. The schedule call will never return, and
> +	 * the scheduled task must drop that reference.
> +	 *
> +	 * We must observe prev->state before clearing prev->on_cpu (in
> +	 * finish_lock_switch), otherwise a concurrent wakeup can get prev
> +	 * running on another CPU and we could race with its RUNNING -> DEAD
> +	 * transition, and then the reference would be dropped twice.
> +	 *
> +	 * We avoid the race by observing prev->state while it is still
> +	 * current.
> +	 */
> +	long prev_state = prev->state;

This doesn't really matter, but probably it would be better to do this right
before switch_to(), prev == current until this point.

Oleg.

