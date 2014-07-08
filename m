Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbaGHNo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:44:56 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55413 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGHNoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:44:55 -0400
Date: Tue, 8 Jul 2014 06:44:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140708134446.GF4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <20140702172600.GR19379@twins.programming.kicks-ass.net>
 <20140702175501.GW4603@linux.vnet.ibm.com>
 <20140703131217.GO3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703131217.GO3935@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070813-7164-0000-0000-000002F7DC25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 03:12:17PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 02, 2014 at 10:55:01AM -0700, Paul E. McKenney wrote:
> > On Wed, Jul 02, 2014 at 07:26:00PM +0200, Peter Zijlstra wrote:
> > > On Wed, Jul 02, 2014 at 10:08:38AM -0700, Paul E. McKenney wrote:
> > > > As were others, not that long ago.  Today is the first hint that I got
> > > > that you feel otherwise.  But it does look like the softirq approach to
> > > > callback processing needs to stick around for awhile longer.  Nice to
> > > > hear that softirq is now "sane and normal" again, I guess.  ;-)
> > > 
> > > Nah, softirqs are still totally annoying :-)
> > 
> > Name me one thing that isn't annoying.  ;-)
> > 
> > > So I've lost detail again, but it seems to me that on all CPUs that are
> > > actually getting ticks, waking tasks to process the RCU state is
> > > entirely over doing it. Might as well keep processing their RCU state
> > > from the tick as was previously done.
> > 
> > And that is in fact the approach taken by my patch.  For which I just
> > kicked off testing, so expect an update later today.  (And that -is-
> > optimistic!  A pessimistic viewpoint would hold that the patch would
> > turn out to be so broken that it would take -weeks- to get a fix!)
> 
> Right, but as you told Mike its not really dynamic, but of course we can
> work on that.

If it is actually needed by someone, then I would be happy to work on it.
But all I see now is people asserting that it should be provided, without
any real justification.

> That said; I'm somewhat confused on the whole nocb thing. So the way I
> see things there's two things that need doing:
> 
>  1) push the state machine
>  2) run callbacks
> 
> It seems to me the nocb threads do both, and somehow some of this is
> getting conflated. Because afaik RCU only uses softirqs for (2), since
> (1) is fully done from the tick -- well, it used to be, before all this.

Well, you do need a finer-grained view of the RCU state machine:

1a.	Registering the need for a future grace period.
1b.	Self-reporting of quiescent states (softirq).
1c.	Reporting of other CPUs' quiescent states (grace-period kthread).
	This includes idle CPUs, userspace nohz_full CPUs, and CPUs that
	just now transitioned to offline.
1d.	Kicking CPUs that have not yet reported a quiescent state
	(also grace-period kthread).
2.	Running callbacks (softirq, or, for RCU_NOCB_CPU, rcuo kthread).

And here (1a) is done via softirq in the non-nocb case and via the rcuo
kthreads on the nocb case.

And yes, RCU's softirq processing is normally done from the tick.

> Now, IIRC rcu callbacks are not guaranteed to run on whatever cpu
> they're queued on, so we can 'easily' splice the actual callback list
> into some other CPUs callback list. Which leaves only (1) to actually
> 'do'.

True, although the 'easily' part needs to take into account the fact
that the RCU callbacks from an given CPU must be invoked in order.
Or rcu_barrier() needs to find a different way to guarantee that all
previously registered callbacks have been invoked, as the case may be.

> Yet the whole thing is called after the 'no-callback' thing, even though
> the most important part is pushing the state machine remotely.

Well, you do have to do both.  Pushing the state machine doesn't help
unless you also invoke the RCU callbacks.

> Now I can see we'd probably don't want to actually push remote cpu's
> their rcu state from IRQ context, but we could, I think, drive the state
> machine remotely. And we want to avoid overloading one CPU with the work
> of all others, which is I think still a fundamental issue with the whole
> nohz_full thing, it reverts to the _one_ timekeeper cpu, but on big
> enough systems that'll be a problem.

Well, RCU already pushes the remote CPU's RCU state remotely via
RCU's dynticks setup.  But you are quite right, dumping all of the RCU
processing onto one CPU can be a bottleneck on large systems (which
Fengguang's tests noted, by the way), and this is the reason for patch
11/17 in the fixes series (https://lkml.org/lkml/2014/7/7/990).  This
patch allows housekeeping kthreads like the grace-period kthreads to
use a new housekeeping_affine() function to bind themselves onto the
non-nohz_full CPUs.  The system can be booted with the desired number
of housekeeping CPUs using the nohz_full= boot parameter.

However, it is not clear to me that having only one timekeeping CPU
(as opposed to having only one housekeeping CPU) is a real problem,
even for very large systems.  If it does turn out to be a real problem,
the sysidle code will probably need to change as well.

							Thanx, Paul

