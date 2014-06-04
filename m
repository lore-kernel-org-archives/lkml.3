Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaFDBGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:06:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:8639 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752439AbaFDBGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:06:12 -0400
Date: Tue, 3 Jun 2014 21:06:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Brad Mouring" <bmouring@ni.com>
Cc: linux-rt-users@vger.kernel.org, Brad Mouring <brad.mouring@ni.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140603210609.62de6451@gandalf.local.home>
In-Reply-To: <1400855410-14773-2-git-send-email-brad.mouring@ni.com>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
	<1400855410-14773-2-git-send-email-brad.mouring@ni.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added LKML and Thomas et. al., as this looks to be mainline too, and
we've been having so much fun with futexes lately.

What I've thought about is this scenario. In
rt_mutex_adjust_prio_chain(), at the bottom of the loop, just before
goto again is called, all locks are released, and we are fully
preemptible. That means, at than moment, anything can happen.

The reason we are in this code is because we blocked on a lock and we
are pushing the inheritance up as well as checking for deadlocks. But,
there's a flaw here in the deadlock case. Lets say we have this.

Tasks A, B, C and D

Locks L1, L2, L3, L4.

D owns L4, C owns L3, B owns L2. C tries to take L4 and blocks, B tries
to take L3, blocks. We then have:

  L2->B->L3->C->L4->D

Perfectly fine. Then A comes along and blocks on L2, where we would
have:

  A->L2->B->L3->C->L4->D

Lets say that A on its chain walk just before that goto again, and task
is D. top_waiter is C. As all locks are released and preemption is
enabled, lots of things can happen. Lets say they all release their
locks! And now we just have:

  A->L2

but things are still running, and they take the locks such that we have:

  C->L1->D->L2->B
         A->L2

That is, B grabbed L2 (stole it from A), D grabbed L1, D blocked on L2
and C blocked on L1. Now A gets scheduled in and continues.

  task->pi_blocked_on

Yep, as task is D, and it's blocked on L1 that is true.

  orig_waiter && !rt_mutex_owner(orig_lock)

well, L1 has a owner, thus it wont exit due to this.

  top_waiter && (!task_has_pi_waiters(task) ||
		top_waiter != task_top_pi_waiter(task))

top_waiter is C, and D has pi_waiters, and C is still the top pi waiter
for D.

Then we get to the test.

  lock == orig_lock || rt_mutex_owner(lock) == top_task

lock happens to be L2 and this is the original lock we wanted to take.
This reports a deadlock, but no deadlock scenario ever occurred.

I'm not sure if Brad's patch addresses this, but when reviewing
possible scenarios, this came to my mind.

-- Steve



On Fri, 23 May 2014 09:30:10 -0500
"Brad Mouring" <bmouring@ni.com> wrote:

> If, during walking the priority chain on a task blocking on a rtmutex,
> and the task is examining the waiter blocked on the lock owned by a task
> that is not blocking (the end of the chain), the current task is ejected
> from the processor and the owner of the end lock is scheduled in,
> releasing that lock, before the original task is scheduled back in, the
> task misses the fact that the previous owner of the current lock no
> longer holds it.
> 
> Signed-off-by: Brad Mouring <brad.mouring@ni.com>
> Acked-by: Scot Salmon <scot.salmon@ni.com>
> Acked-by: Ben Shelton <ben.shelton@ni.com>
> Tested-by: Jeff Westfahl <jeff.westfahl@ni.com>
> ---
>  kernel/locking/rtmutex.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> index fbf152b..029a9ab 100644
> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -384,6 +384,25 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  
>  	/* Deadlock detection */
>  	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
> +		/*
> +		 * If the prio chain has changed out from under us, set the task
> +		 * to the current owner of the lock in the current waiter and
> +		 * continue walking the prio chain
> +		 */
> +		if (rt_mutex_owner(lock) && rt_mutex_owner(lock) != task) {
> +			/* Release the old owner */
> +			raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +			put_task_struct(task);
> +
> +			/* Move to the new owner */
> +			task = rt_mutex_owner(lock);
> +			get_task_struct(task);
> +
> +			/* Let's try this again */
> +			raw_spin_unlock(&lock->wait_lock);
> +			goto retry;
> +		}
> +
>  		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
>  		raw_spin_unlock(&lock->wait_lock);
>  		ret = deadlock_detect ? -EDEADLK : 0;

