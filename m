Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaGHJFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:05:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:53735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaGHJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:04:58 -0400
Date: Thu, 3 Jul 2014 15:12:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140703131217.GO3935@laptop>
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <20140702172600.GR19379@twins.programming.kicks-ass.net>
 <20140702175501.GW4603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702175501.GW4603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 10:55:01AM -0700, Paul E. McKenney wrote:
> On Wed, Jul 02, 2014 at 07:26:00PM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 02, 2014 at 10:08:38AM -0700, Paul E. McKenney wrote:
> > > As were others, not that long ago.  Today is the first hint that I got
> > > that you feel otherwise.  But it does look like the softirq approach to
> > > callback processing needs to stick around for awhile longer.  Nice to
> > > hear that softirq is now "sane and normal" again, I guess.  ;-)
> > 
> > Nah, softirqs are still totally annoying :-)
> 
> Name me one thing that isn't annoying.  ;-)
> 
> > So I've lost detail again, but it seems to me that on all CPUs that are
> > actually getting ticks, waking tasks to process the RCU state is
> > entirely over doing it. Might as well keep processing their RCU state
> > from the tick as was previously done.
> 
> And that is in fact the approach taken by my patch.  For which I just
> kicked off testing, so expect an update later today.  (And that -is-
> optimistic!  A pessimistic viewpoint would hold that the patch would
> turn out to be so broken that it would take -weeks- to get a fix!)

Right, but as you told Mike its not really dynamic, but of course we can
work on that.

That said; I'm somewhat confused on the whole nocb thing. So the way I
see things there's two things that need doing:

 1) push the state machine
 2) run callbacks

It seems to me the nocb threads do both, and somehow some of this is
getting conflated. Because afaik RCU only uses softirqs for (2), since
(1) is fully done from the tick -- well, it used to be, before all this.

Now, IIRC rcu callbacks are not guaranteed to run on whatever cpu
they're queued on, so we can 'easily' splice the actual callback list
into some other CPUs callback list. Which leaves only (1) to actually
'do'.

Yet the whole thing is called after the 'no-callback' thing, even though
the most important part is pushing the state machine remotely.

Now I can see we'd probably don't want to actually push remote cpu's
their rcu state from IRQ context, but we could, I think, drive the state
machine remotely. And we want to avoid overloading one CPU with the work
of all others, which is I think still a fundamental issue with the whole
nohz_full thing, it reverts to the _one_ timekeeper cpu, but on big
enough systems that'll be a problem.


