Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFJRlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:41:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:54317 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaFJRln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:41:43 -0400
Date: Tue, 10 Jun 2014 19:41:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 7/7] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
In-Reply-To: <20140609212033.1cff0999@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406101630350.31315@nanos>
References: <20140609201118.387571774@linutronix.de> <20140609202336.506044876@linutronix.de> <20140609212033.1cff0999@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Steven Rostedt wrote:
> On Mon, 09 Jun 2014 20:28:10 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> >  	/*
> > +	 * If we just follow the lock chain for deadlock detection, no
> > +	 * need to do all the requeue operations. We avoid a truckload
> 
> s/We/To/
> 
> 
> > +	 * of conditinals around the various places below and just do
> 
> s/ and/, /

Ok.
 
> > +	 * the minimum chain walk checks here.
> > +	 */
> > +	if (!requeue) {
> > +		/* Release the task */
> > +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> > +		put_task_struct(task);
> > +
> > +		/* If there is no owner of the lock, end of chain. */
> > +		if (!rt_mutex_owner(lock)) {
> > +			raw_spin_unlock(&lock->wait_lock);
> > +			return 0;
> > +		}
> > +
> > +		/* Grab the next task, i.e. owner of @lock */
> > +		task = rt_mutex_owner(lock);
> > +		get_task_struct(task);
> > +		raw_spin_lock_irqsave(&task->pi_lock, flags);
> > +
> > +		/* Store whether owner is blocked itself and drop locks */
> > +		next_lock = task_blocked_on(task);
> > +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> > +		raw_spin_unlock(&lock->wait_lock);
> > +
> > +		/* If owner is not blocked, end of chain. */
> > +		if (!next_lock)
> > +			goto out_put_task;
> 
> On the loop back around, have something like:
> 
> 	if (top_waiter) {
> 		if (!task_has_pi_waiters(task))
> 			goto out_unlock_pi;

	The task has at least one pi waiter.
 
> 		if (!requeue &&
> 		    top_waiter != task_top_pi_waiter(task)) {
> 			if (!detect_deadlock)
> 				goto out_unlock_pi;
> 			else
> 				requeue = false;
> 		}

	Errm? if requeue is off we are in deadlock detection chainwalk
	mode. So all we care about is whether task is blocked on
	next_lock or not.

What you actually missed is that we need to read out top_waiter for
the current lock. Fixed already.
    

Thanks,

	tglx
