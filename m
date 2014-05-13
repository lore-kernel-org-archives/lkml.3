Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbaEMIpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:45:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:59985 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaEMIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:44:55 -0400
Date: Tue, 13 May 2014 10:45:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
In-Reply-To: <5371B2D9.8060405@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1405131036450.6261@ionos.tec.linutronix.de>
References: <20140512190438.314125476@linutronix.de> <20140512201700.999660035@linutronix.de> <5371B2D9.8060405@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai,

On Tue, 13 May 2014, Lai Jiangshan wrote:
> I think this patch is just a workaround, it is not the proper fix.
> you need a updated deadlock-check mechanism:
> 
> - (old) skip the check when top_waiter != task_top_pi_waiter(task)
> + (new) skip the check when top_waiter->prio > task->prio
> 
> 	/*
> 	 * Drop out, when the task has no waiters. Note,
> 	 * top_waiter can be NULL, when we are in the deboosting
> 	 * mode!
> 	 */
> 	if (top_waiter && (!task_has_pi_waiters(task) ||
> 			   top_waiter != task_top_pi_waiter(task)))
> 		goto out_unlock_pi;
> 
> 
> (also need to update the code in other places respectively)

Ok, I did not think it through fully and I want to have the rtmutex
tester working again so we can check for this without going through
futex hoops and loops. I had no time yet to look into that as I needed
to understand the futex issue which exposed it first.

> On 05/13/2014 04:45 AM, Thomas Gleixner wrote:
> >  	/*
> > +	 * Deadlock check for the following scenario:
> > +	 *
> > +	 * T holds lock L and has waiters
> > +	 * T locks L again, but does not end up as it's own top waiter
> 
> ABBA problem (TA TB TC TD are of the same priority)
> 
> TA holds lock LA, and try to lock LB which TC already has waited on
> TB holds lock LB, and try to lock LA which TD already has waited on
> 
> I think this check can't detect it IIUC.
> 
> > +	 *
> > +	 * So we would drop out at the next check without noticing.
> > +	 *
> > +	 * Note, we need to check for orig_waiter as it might be NULL
> > +	 * when deboosting!
> > +	 */
> > +	if (orig_waiter && orig_waiter->task == rt_mutex_owner(lock)) {
> 
> when non-first-loop, it is already checked.

Right, but we must check it for the first loop as well. And that check
was not there ever, so it's not your problem. I verified against a
kernel w/o your optimization.
 
> > +		ret = deadlock_detect ? -EDEADLK : 0;
> > +		goto out_unlock_pi;
> > +	}
> 
> I considered you blamed to me.
> I would feel better if you directly blamed to me.

I blamed you as well for not following up and updating the stuff you
broke.

Thanks,

	tglx
