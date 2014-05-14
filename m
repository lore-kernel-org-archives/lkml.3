Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaENM7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:59:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:43458 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbaENM7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:59:05 -0400
Date: Wed, 14 May 2014 14:59:12 +0200 (CEST)
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
Message-ID: <alpine.DEB.2.02.1405141448210.6261@ionos.tec.linutronix.de>
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

On Tue, 13 May 2014, Lai Jiangshan wrote:

> Hi, Thomas,
> 
> I think this patch is just a workaround, it is not the proper fix.
> you need a updated deadlock-check mechanism:
> 
> - (old) skip the check when top_waiter != task_top_pi_waiter(task)
> + (new) skip the check when top_waiter->prio > task->prio

I don't think that helps. 
 
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

Right it doesn't.
 
> 	/*
> 	 * Drop out, when the task has no waiters. Note,
> 	 * top_waiter can be NULL, when we are in the deboosting
> 	 * mode!
> 	 */
> 	if (top_waiter && (!task_has_pi_waiters(task) ||
> 			   top_waiter != task_top_pi_waiter(task)))
> 		goto out_unlock_pi;

So the issue here is, that we break out of the chain walk even if
deadlock detection is enabled.

The break out is correct for the boost case w/o deadlock detection, so
we won't do any pointless work.

For the deadlock detection case, we need to continue. But we should
store, that we are not the top_waiter so we can avoid the requeue
business when walking the chain.

Thanks,

	tglx




