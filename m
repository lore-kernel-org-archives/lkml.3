Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbbAUFKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:10:15 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:44864 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUFKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:10:13 -0500
Date: Tue, 20 Jan 2015 21:10:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Calvin Owens <calvinowens@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
Message-ID: <20150121051008.GX9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150107165223.GA21555@linux.vnet.ibm.com>
 <20150108043329.GB27996@mail.thefacebook.com>
 <20150108045306.GJ5280@linux.vnet.ibm.com>
 <20150108214644.GC27996@mail.thefacebook.com>
 <alpine.DEB.2.11.1501131215380.5526@nanos>
 <20150113184301.GO9719@linux.vnet.ibm.com>
 <20150113211618.GA21498@mail.thefacebook.com>
 <alpine.DEB.2.11.1501201419550.5526@nanos>
 <20150120203022.GR9719@linux.vnet.ibm.com>
 <1421811639.5285.25.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421811639.5285.25.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012105-0025-0000-0000-000007EE9E60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 04:40:39AM +0100, Mike Galbraith wrote:
> On Tue, 2015-01-20 at 12:30 -0800, Paul E. McKenney wrote: 
> > On Tue, Jan 20, 2015 at 02:21:51PM +0100, Thomas Gleixner wrote:
> 
> > > > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > > > index 501baa9..9e787d8 100644
> > > > --- a/kernel/softirq.c
> > > > +++ b/kernel/softirq.c
> > > > @@ -656,9 +656,13 @@ static void run_ksoftirqd(unsigned int cpu)
> > > >  		 * in the task stack here.
> > > >  		 */
> > > >  		__do_softirq();
> > > > -		rcu_note_context_switch(cpu);
> > > >  		local_irq_enable();
> > > >  		cond_resched();
> > > > +
> > > > +		preempt_disable();
> > > > +		rcu_note_context_switch(cpu);
> > > > +		preempt_enable();
> > > > +
> > > 
> > > The whole rcu_note_context_switch() in run_ksoftirqd() is silly.
> > > 
> > >     cond_resched()
> > > 	__preempt_count_add(PREEMPT_ACTIVE);
> > > 
> > > 	__schedule();
> > > 	     preempt_disable();
> > > 	     rcu_note_context_switch();
> > > 	     ....
> > > 
> > > 	__preempt_count_sub(PREEMPT_ACTIVE);
> > 
> > I agree that if should_resched() returns true as assumed above, then there
> > is no point to invoking rcu_note_context_switch().  However, the case that
> > this code applies to is when should_resched() returns false, but RCU is
> > waiting for a quiescent state from the current CPU.  In that case,
> > cond_resched() won't do anything for RCU, and we do need the
> > rcu_note_context_switch().
> 
> I've been curious about this for ages, so now is a great time to bite
> the bullet and ask TheMan.  A context switch is not far away, why do we
> need that quiescent state badly enough to tell what looks like a little
> white lie to get it immediately?
> 
> (I commented it out in an -rt kernel I was testing yesterday, beat it
> enthusiastically for a while, and box didn't _seem_ to notice that it
> was missing anything)

Yeah, you do have to have a fairly violent network-based DoS attack
to see the difference.  Robert Olsson was the first to make this happen
back in the day.

							Thanx, Paul

