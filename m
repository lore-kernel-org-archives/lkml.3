Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab3EOJBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:01:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55937 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3EOJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:00:58 -0400
Date: Wed, 15 May 2013 10:56:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130515085639.GD10510@laptop.programming.kicks-ass.net>
References: <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514154728.GC4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 08:47:28AM -0700, Paul E. McKenney wrote:
> On Tue, May 14, 2013 at 04:51:20PM +0200, Peter Zijlstra wrote:
> > > In theory, yes.  In practice, this requires lots of lock acquisitions
> > > and releases on large systems, including some global locks.  The weight
> > > could be reduced, but...
> > > 
> > > What I would like to do instead would be to specify expedited grace
> > > periods during boot.
> > 
> > But why, surely going idle without any RCU callbacks isn't completely unheard
> > of, even outside of the boot process?
> 
> Yep, and RCU has special-cased that for quite some time.
> 
> > Being able to quickly drop out of the RCU state machinery would be a good thing IMO.
> 
> And this is currently possible -- this is the job of rcu_idle_enter()
> and friends.  And it works well, at least when I get my "if" statements
> set up correctly (hence the earlier patch).
> 
> Or are you seeing a slowdown even with that earlier patch applied?  If so,
> please let me know what you are seeing.

I'm not running anything in particular, except maybe a broken mental
model of RCU ;-)

So what I'm talking about is the !rcu_cpu_has_callbacks() case, where
there's absolutely nothing for RCU to do except tell the state machine
its no longer participating.

Your patch to rcu_needs_cpu() frobbing the lazy condition is after that
and thus irrelevant for this AFAICT.

Now as far as I can see, rcu_needs_cpu() will return false in this case;
allowing the cpu to enter NO_HZ state. We then call rcu_idle_enter()
which would call rcu_eqs_enter(). Which should put the CPU in extended
quiescent state.

However, you're still running into these FQSs delaying boot. Why is
that? Is that because rcu_eqs_enter() doesn't really do enough?

The thing is, if all other CPUs are idle, detecting the end of a grace
period should be rather trivial and not involve FQSs and thus be tons
faster.

Clearly I'm missing something obvious and not communicating right or so.


