Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbbAUDkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:40:45 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55478 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbbAUDkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:40:43 -0500
Message-ID: <1421811639.5285.25.camel@marge.simpson.net>
Subject: Re: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Date: Wed, 21 Jan 2015 04:40:39 +0100
In-Reply-To: <20150120203022.GR9719@linux.vnet.ibm.com>
References: <20150107014906.GA27996@mail.thefacebook.com>
	 <20150107021926.GT5280@linux.vnet.ibm.com>
	 <20150107165223.GA21555@linux.vnet.ibm.com>
	 <20150108043329.GB27996@mail.thefacebook.com>
	 <20150108045306.GJ5280@linux.vnet.ibm.com>
	 <20150108214644.GC27996@mail.thefacebook.com>
	 <alpine.DEB.2.11.1501131215380.5526@nanos>
	 <20150113184301.GO9719@linux.vnet.ibm.com>
	 <20150113211618.GA21498@mail.thefacebook.com>
	 <alpine.DEB.2.11.1501201419550.5526@nanos>
	 <20150120203022.GR9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 12:30 -0800, Paul E. McKenney wrote: 
> On Tue, Jan 20, 2015 at 02:21:51PM +0100, Thomas Gleixner wrote:

> > > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > > index 501baa9..9e787d8 100644
> > > --- a/kernel/softirq.c
> > > +++ b/kernel/softirq.c
> > > @@ -656,9 +656,13 @@ static void run_ksoftirqd(unsigned int cpu)
> > >  		 * in the task stack here.
> > >  		 */
> > >  		__do_softirq();
> > > -		rcu_note_context_switch(cpu);
> > >  		local_irq_enable();
> > >  		cond_resched();
> > > +
> > > +		preempt_disable();
> > > +		rcu_note_context_switch(cpu);
> > > +		preempt_enable();
> > > +
> > 
> > The whole rcu_note_context_switch() in run_ksoftirqd() is silly.
> > 
> >     cond_resched()
> > 	__preempt_count_add(PREEMPT_ACTIVE);
> > 
> > 	__schedule();
> > 	     preempt_disable();
> > 	     rcu_note_context_switch();
> > 	     ....
> > 
> > 	__preempt_count_sub(PREEMPT_ACTIVE);
> 
> I agree that if should_resched() returns true as assumed above, then there
> is no point to invoking rcu_note_context_switch().  However, the case that
> this code applies to is when should_resched() returns false, but RCU is
> waiting for a quiescent state from the current CPU.  In that case,
> cond_resched() won't do anything for RCU, and we do need the
> rcu_note_context_switch().

I've been curious about this for ages, so now is a great time to bite
the bullet and ask TheMan.  A context switch is not far away, why do we
need that quiescent state badly enough to tell what looks like a little
white lie to get it immediately?

(I commented it out in an -rt kernel I was testing yesterday, beat it
enthusiastically for a while, and box didn't _seem_ to notice that it
was missing anything)

-Mike

