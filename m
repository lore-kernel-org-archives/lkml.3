Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaE1J5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:57:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:33708 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaE1J47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:56:59 -0400
Date: Wed, 28 May 2014 11:57:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 1/6] rtmutex: Fix deadlock detector for real
In-Reply-To: <20140527180930.1e9b020e@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1405281144150.21720@ionos.tec.linutronix.de>
References: <20140522031841.797415507@linutronix.de> <20140522031949.725272460@linutronix.de> <20140527180930.1e9b020e@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2014, Steven Rostedt wrote:
> On Thu, 22 May 2014 03:25:39 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> >  	 * When deadlock detection is off then we check, if further
> >  	 * priority adjustment is necessary.
> >  	 */
> > -	if (!detect_deadlock && waiter->prio == task->prio)
> > -		goto out_unlock_pi;
> > +	if (waiter->prio == task->prio) {
> > +		if (!detect_deadlock)
> > +			goto out_unlock_pi;
> > +	}
> 
> This too.
> 
> Although! if you want to micro-optimize the detect_deadlock case
> where !detect_deadlock is false. You might want to reverse the order.
> That way we don't need to dereference the ->prio for both waiter and
> task before seeing that we don't go to the out_unlock_pi.
> 
> 	if (!detect_deadlock) {
> 		if (waiter->prio == task->prio)
> 			goto out_unlock_pi;
> 	}
> 
> Hmm, or you did it this way for your "don't requeue" patch? Looking at
> that one, it seems you did.
> 
> 	if (waiter->prio == task->prio) {
> 		if (!detect_deadlock)
> 			goto out_unlock_pi;
> 		requeue = false;
> 	}
> 
> Oh well. But for stable maybe have the optimized way? And change it
> back when you add the requeue patch?

Right.

> > @@ -527,6 +538,10 @@ static int task_blocks_on_rt_mutex(struc
> >  	unsigned long flags;
> >  	int chain_walk = 0, res;
> >  
> > +	/* Early deadlock detection */
> > +	if (detect_deadlock && owner == task)
> > +		return -EDEADLK;
> > +
> 
> This is an optimization, right? Does it belong for stable?

It's kind of an optimization, but we really want to avoid enqueueing
the task on its own pi waiter list in the first place. So I rather
keep it for stable as well.

Thanks,

	tglx
