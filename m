Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaCPGZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 02:25:10 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37693 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaCPGZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 02:25:08 -0400
Date: Sat, 15 Mar 2014 23:25:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: peterz@infradead.org, mingo@elte.hu, josh@joshtriplett.org,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: cond_resched() and RCU CPU stall warnings
Message-ID: <20140316062501.GX21124@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140316015914.GA22102@linux.vnet.ibm.com>
 <1394950182.5470.15.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394950182.5470.15.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031606-1542-0000-0000-0000006765A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2014 at 07:09:42AM +0100, Mike Galbraith wrote:
> On Sat, 2014-03-15 at 18:59 -0700, Paul E. McKenney wrote: 
> > So I have been tightening up rcutorture a bit over the past year.
> > The other day, I came across what looked like a great opportunity for
> > further tightening, namely the schedule() in rcu_torture_reader().
> > Why not turn this into a cond_resched(), speeding up the readers a bit
> > and placing more stress on RCU?
> > 
> > And boy does it increase stress!
> > 
> > Unfortunately, this increased stress sometimes shows up in the form of
> > lots of RCU CPU stall warnings.  These can appear when an instance of
> > rcu_torture_reader() gets a CPU to itself, in which case it won't ever
> > enter the scheduler, and RCU will never see a quiescent state from that
> > CPU, which means the grace period never ends.
> > 
> > So I am taking a more measured approach to cond_resched() in
> > rcu_torture_reader() for the moment.
> > 
> > But longer term, should cond_resched() imply a set of RCU
> > quiescent states?  One way to do this would be to add calls to
> > rcu_note_context_switch() in each of the various cond_resched() functions.
> > Easy change, but of course adds some overhead.  On the other hand,
> > there might be more than a few of the 500+ calls to cond_resched() that
> > expect that RCU CPU stalls will be prevented (to say nothing of
> > might_sleep() and cond_resched_lock()).
> > 
> > Thoughts?
> > 
> > (Untested patch below, FWIW.)
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index b46131ef6aab..994d2b0fd0b2 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4075,6 +4075,9 @@ int __sched _cond_resched(void)
> >  		__cond_resched();
> >  		return 1;
> >  	}
> > +	preempt_disable();
> > +	rcu_note_context_switch(smp_processor_id());
> > +	preempt_enable();
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(_cond_resched);
> 
> Hm.  Since you only care about the case where your task is solo, how
> about do racy checks, 100% accuracy isn't required is it?  Seems you
> wouldn't want to unconditionally do that in tight loops.

And indeed, my current workaround unconditionally does schedule() one
out of 256 loops.  I would do something similar here, perhaps based
on per-CPU counters, perhaps even with racy accesses to avoid always
doing preempt_disable()/preempt_enable().

Or did you have something else in mind?

							Thanx, Paul

