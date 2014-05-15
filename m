Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaEOGrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:47:19 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64139 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaEOGrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:47:15 -0400
Date: Thu, 15 May 2014 08:47:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
Message-ID: <20140515064709.GA28517@gmail.com>
References: <20140514195705.618583609@linutronix.de>
 <20140514200104.670614672@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514200104.670614672@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A couple of suggestions:

1)

* Thomas Gleixner <tglx@linutronix.de> wrote:

> +	if (requeue) {
> +		if (waiter == rt_mutex_top_waiter(lock)) {

So we have a 'top_waiter' local variable already at this point, and we 
use it here:

> +			/* Boost the owner */
> +			rt_mutex_dequeue_pi(task, top_waiter);
> +			rt_mutex_enqueue_pi(task, waiter);
> +			__rt_mutex_adjust_prio(task);
> +
> +		} else if (top_waiter == waiter) {

To me it's a bit confusing that we have both the 'top_waiter' local 
variable and also evaluate 'rt_mutex_top_waiter()' directly.

So what happens is that when we do the requeue, the top waiter might 
change. I'd really suggest to signal that via naming - i.e. add 
another local variable (which GCC will optimize out happily), named 
descriptively:

	orig_top_waiter = top_waiter;

and use that variable after that point.

> +			/* Deboost the owner */
> +			rt_mutex_dequeue_pi(task, waiter);
> +			waiter = rt_mutex_top_waiter(lock);
> +			rt_mutex_enqueue_pi(task, waiter);
> +			__rt_mutex_adjust_prio(task);
> +		}
>  	}

2)

Also another small flow of control side comment, because this code is 
apparently rather tricky, I'd suggest a bit more explicit structure to 
show the real flow of the logic: for example in the first reading of 
the above block I mistakenly read it as a usual 'if () { } else { }' 
block pattern - which it really isn't.

Something like this would be slightly easier to understand 'at a 
glance', IMHO:

	if (requeue) {
		if (waiter == top_waiter) {
			/* Boost the owner */
			rt_mutex_dequeue_pi(task, orig_top_waiter);
			rt_mutex_enqueue_pi(task, waiter);
			__rt_mutex_adjust_prio(task);

		} else {
			if (orig_top_waiter == waiter) {
				/* Deboost the owner */
				rt_mutex_dequeue_pi(task, waiter);
				waiter = rt_mutex_top_waiter(lock);
				rt_mutex_enqueue_pi(task, waiter);
				__rt_mutex_adjust_prio(task);
			} else {
				/* The requeueing did not affect us, no need to boost or deboost */
			}
		}
	}

Assuming you agree with this structure, it's a bit more verbose, but 
this might be one of the cases where verbosity helps readability. 
(Note that I already propagated the 'orig_top_waiter' name into it.)

3)

Also note how the code continues:

        raw_spin_unlock_irqrestore(&task->pi_lock, flags);

        top_waiter = rt_mutex_top_waiter(lock);
        raw_spin_unlock(&lock->wait_lock);

        if (!detect_deadlock && waiter != top_waiter)
                goto out_put_task;

        goto again;

So we evaluate 'top_waiter' again - maybe we could move that line to 
the two branches that actually have a chance to change the top waiter, 
and not change it in the 'no need to requeue' case.

So ... all in one, what I would suggest is something like the patch 
below, on top of your two patches. Totally untested and such.

Thanks,

	Ingo

=======================>
Subject: locking/rtmutex: Clean up the rt_mutex_adjust_prio_chain() code flow
From: Ingo Molnar <mingo@kernel.org>
Date: Thu May 15 08:39:42 CEST 2014

Clean up the code flow and variable names, always precisely 
maintaining the 'top_waiter' and 'orig_top_waiter' values whenever 
they can change.

This probably optimizes the !requeue case a bit as well.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/rtmutex.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -284,7 +284,7 @@ static int rt_mutex_adjust_prio_chain(st
 				      struct rt_mutex_waiter *orig_waiter,
 				      struct task_struct *top_task)
 {
-	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter;
+	struct rt_mutex_waiter *waiter, *top_waiter = orig_waiter, *orig_top_waiter;
 	int detect_deadlock, ret = 0, depth = 0;
 	struct rt_mutex *lock;
 	unsigned long flags;
@@ -380,13 +380,17 @@ static int rt_mutex_adjust_prio_chain(st
 		goto out_unlock_pi;
 	}
 
-	top_waiter = rt_mutex_top_waiter(lock);
-
 	if (requeue) {
+		orig_top_waiter = rt_mutex_top_waiter(lock);
+
 		/* Requeue the waiter */
 		rt_mutex_dequeue(lock, waiter);
 		waiter->prio = task->prio;
 		rt_mutex_enqueue(lock, waiter);
+
+		top_waiter = rt_mutex_top_waiter(lock);
+	} else {
+		orig_top_waiter = top_waiter = rt_mutex_top_waiter(lock);
 	}
 
 	/* Release the task */
@@ -401,8 +405,8 @@ static int rt_mutex_adjust_prio_chain(st
 		 * If the requeue above changed the top waiter, then we need
 		 * to wake the new top waiter up to try to get the lock.
 		 */
-		if (top_waiter != rt_mutex_top_waiter(lock))
-			wake_up_process(rt_mutex_top_waiter(lock)->task);
+		if (top_waiter != orig_top_waiter)
+			wake_up_process(top_waiter->task);
 		raw_spin_unlock(&lock->wait_lock);
 		goto out_put_task;
 	}
@@ -414,24 +418,27 @@ static int rt_mutex_adjust_prio_chain(st
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	if (requeue) {
-		if (waiter == rt_mutex_top_waiter(lock)) {
+		if (waiter == top_waiter) {
 			/* Boost the owner */
-			rt_mutex_dequeue_pi(task, top_waiter);
+			rt_mutex_dequeue_pi(task, orig_top_waiter);
 			rt_mutex_enqueue_pi(task, waiter);
 			__rt_mutex_adjust_prio(task);
 
-		} else if (top_waiter == waiter) {
-			/* Deboost the owner */
-			rt_mutex_dequeue_pi(task, waiter);
-			waiter = rt_mutex_top_waiter(lock);
-			rt_mutex_enqueue_pi(task, waiter);
-			__rt_mutex_adjust_prio(task);
+		} else {
+			if (orig_top_waiter == waiter) {
+				/* Deboost the owner */
+				rt_mutex_dequeue_pi(task, waiter);
+				waiter = rt_mutex_top_waiter(lock);
+				rt_mutex_enqueue_pi(task, waiter);
+				__rt_mutex_adjust_prio(task);
+			} else {
+				/* The requeueing did not affect us, no need to boost or deboost */
+			}
 		}
 	}
 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
-	top_waiter = rt_mutex_top_waiter(lock);
 	raw_spin_unlock(&lock->wait_lock);
 
 	if (!detect_deadlock && waiter != top_waiter)
