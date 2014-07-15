Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaGOO1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbaGOO1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:27:30 -0400
Date: Tue, 15 Jul 2014 16:25:25 +0200
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
Message-ID: <20140715142525.GA26029@redhat.com>
References: <53C2FF4D.3020606@oracle.com> <53C31A34.8030500@oracle.com> <20140714090449.GL9918@twins.programming.kicks-ass.net> <20140714144953.GA8173@redhat.com> <20140714160147.GA11986@redhat.com> <20140715131240.GA23014@redhat.com> <20140715132353.GF9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715132353.GF9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15, Peter Zijlstra wrote:
>
> @@ -2211,13 +2211,15 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  
>  	/*
>  	 * A task struct has one reference for the use as "current".
> +	 *
>  	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
> -	 * schedule one last time. The schedule call will never return, and
> -	 * the scheduled task must drop that reference.
> -	 * The test for TASK_DEAD must occur while the runqueue locks are
> -	 * still held, otherwise prev could be scheduled on another cpu, die
> -	 * there before we look at prev->state, and then the reference would
> -	 * be dropped twice.
> +	 * schedule one last time. The schedule call will never return, and the
> +	 * scheduled task must drop that reference.
> +	 *
> +	 * The test for TASK_DEAD must occur while the runqueue locks are still
> +	 * held, otherwise we can race with RUNNING -> DEAD transitions, and
> +	 * then the reference would be dropped twice.
> +	 *
>  	 *		Manfred Spraul <manfred@colorfullife.com>
>  	 */

Agreed, this looks much more understandable!


And probably I missed something again, but it seems that this logic is broken
with __ARCH_WANT_UNLOCKED_CTXSW.

Of course, even if I am right this is pure theoretical, but smp_wmb() before
"->on_cpu = 0" is not enough and we need a full barrier ?

Oleg.

