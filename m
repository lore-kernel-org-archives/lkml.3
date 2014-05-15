Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaEOVtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:49:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:7822 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752316AbaEOVtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:49:40 -0400
Date: Thu, 15 May 2014 17:49:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
Message-ID: <20140515174936.1db2b218@gandalf.local.home>
In-Reply-To: <20140515064709.GA28517@gmail.com>
References: <20140514195705.618583609@linutronix.de>
	<20140514200104.670614672@linutronix.de>
	<20140515064709.GA28517@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 08:47:09 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> A couple of suggestions:
> 
> 1)
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > +	if (requeue) {
> > +		if (waiter == rt_mutex_top_waiter(lock)) {
> 
> So we have a 'top_waiter' local variable already at this point, and we 
> use it here:
> 
> > +			/* Boost the owner */
> > +			rt_mutex_dequeue_pi(task, top_waiter);
> > +			rt_mutex_enqueue_pi(task, waiter);
> > +			__rt_mutex_adjust_prio(task);
> > +
> > +		} else if (top_waiter == waiter) {
> 
> To me it's a bit confusing that we have both the 'top_waiter' local 
> variable and also evaluate 'rt_mutex_top_waiter()' directly.
> 
> So what happens is that when we do the requeue, the top waiter might 
> change. I'd really suggest to signal that via naming - i.e. add 
> another local variable (which GCC will optimize out happily), named 
> descriptively:
> 
> 	orig_top_waiter = top_waiter;
> 
> and use that variable after that point.

I wouldn't use "orig_top_waiter" as all the "orig_*" variables are
passed in via the parameters and do not change.

Maybe: last_top_waiter?


> 
> > +			/* Deboost the owner */
> > +			rt_mutex_dequeue_pi(task, waiter);
> > +			waiter = rt_mutex_top_waiter(lock);
> > +			rt_mutex_enqueue_pi(task, waiter);
> > +			__rt_mutex_adjust_prio(task);
> > +		}
> >  	}
> 
> 2)
> 
> Also another small flow of control side comment, because this code is 
> apparently rather tricky, I'd suggest a bit more explicit structure to 
> show the real flow of the logic: for example in the first reading of 
> the above block I mistakenly read it as a usual 'if () { } else { }' 
> block pattern - which it really isn't.
> 
> Something like this would be slightly easier to understand 'at a 
> glance', IMHO:
> 
> 	if (requeue) {
> 		if (waiter == top_waiter) {
> 			/* Boost the owner */
> 			rt_mutex_dequeue_pi(task, orig_top_waiter);
> 			rt_mutex_enqueue_pi(task, waiter);
> 			__rt_mutex_adjust_prio(task);
> 
> 		} else {
> 			if (orig_top_waiter == waiter) {
> 				/* Deboost the owner */
> 				rt_mutex_dequeue_pi(task, waiter);
> 				waiter = rt_mutex_top_waiter(lock);
> 				rt_mutex_enqueue_pi(task, waiter);
> 				__rt_mutex_adjust_prio(task);
> 			} else {
> 				/* The requeueing did not affect us, no need to boost or deboost */
> 			}
> 		}
> 	}
> 
> Assuming you agree with this structure, it's a bit more verbose, but 
> this might be one of the cases where verbosity helps readability. 
> (Note that I already propagated the 'orig_top_waiter' name into it.)

Instead of the nesting, what about:

	if (requeue) {
		if (waiter == top_waiter) {
			/* Boost the owner */
			rt_mutex_dequeue_pi(task, last_top_waiter);
			rt_mutex_enqueue_pi(task, waiter);
			__rt_mutex_adjust_prio(task);

		} else if (last_top_waiter == waiter) {
			/* Deboost the owner */
			rt_mutex_dequeue_pi(task, waiter);
			waiter = rt_mutex_top_waiter(lock);
			rt_mutex_enqueue_pi(task, waiter);
			__rt_mutex_adjust_prio(task);
		} else {
			/*
			 * The requeueing did not affect us, no need to
			 * boost or deboost
			 */
		}
	}

That last else should also visually keep one from thinking this is a
simple "if { } else { }" construct.

(Note that I already propagated the 'last_top_waiter' name into it ;-)

		

> 
> 3)
> 
> Also note how the code continues:
> 
>         raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> 
>         top_waiter = rt_mutex_top_waiter(lock);
>         raw_spin_unlock(&lock->wait_lock);
> 
>         if (!detect_deadlock && waiter != top_waiter)
>                 goto out_put_task;
> 
>         goto again;
> 
> So we evaluate 'top_waiter' again - maybe we could move that line to 
> the two branches that actually have a chance to change the top waiter, 
> and not change it in the 'no need to requeue' case.

This is probably a good idea and needs my change I suggested earlier
(which doesn't do the wakeup if requeue == 0).

-- Steve

> 
> So ... all in one, what I would suggest is something like the patch 
> below, on top of your two patches. Totally untested and such.
> 
