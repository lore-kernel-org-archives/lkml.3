Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab3EOVKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:10:50 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38609 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921Ab3EOVKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:10:41 -0400
Date: Wed, 15 May 2013 10:31:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130515173142.GL4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
 <20130515085639.GD10510@laptop.programming.kicks-ass.net>
 <20130515090234.GE10510@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515090234.GE10510@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051521-5518-0000-0000-00000EADE38D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:02:34AM +0200, Peter Zijlstra wrote:
> On Wed, May 15, 2013 at 10:56:39AM +0200, Peter Zijlstra wrote:
> > On Tue, May 14, 2013 at 08:47:28AM -0700, Paul E. McKenney wrote:
> > > On Tue, May 14, 2013 at 04:51:20PM +0200, Peter Zijlstra wrote:
> > > > > In theory, yes.  In practice, this requires lots of lock acquisitions
> > > > > and releases on large systems, including some global locks.  The weight
> > > > > could be reduced, but...
> > > > > 
> > > > > What I would like to do instead would be to specify expedited grace
> > > > > periods during boot.
> > > > 
> > > > But why, surely going idle without any RCU callbacks isn't completely unheard
> > > > of, even outside of the boot process?
> > > 
> > > Yep, and RCU has special-cased that for quite some time.
> > > 
> > > > Being able to quickly drop out of the RCU state machinery would be a good thing IMO.
> > > 
> > > And this is currently possible -- this is the job of rcu_idle_enter()
> > > and friends.  And it works well, at least when I get my "if" statements
> > > set up correctly (hence the earlier patch).
> > > 
> > > Or are you seeing a slowdown even with that earlier patch applied?  If so,
> > > please let me know what you are seeing.
> > 
> > I'm not running anything in particular, except maybe a broken mental
> > model of RCU ;-)
> > 
> > So what I'm talking about is the !rcu_cpu_has_callbacks() case, where
> > there's absolutely nothing for RCU to do except tell the state machine
> > its no longer participating.
> > 
> > Your patch to rcu_needs_cpu() frobbing the lazy condition is after that
> > and thus irrelevant for this AFAICT.
> > 
> > Now as far as I can see, rcu_needs_cpu() will return false in this case;
> > allowing the cpu to enter NO_HZ state. We then call rcu_idle_enter()
> > which would call rcu_eqs_enter(). Which should put the CPU in extended
> > quiescent state.
> > 
> > However, you're still running into these FQSs delaying boot. Why is
> > that? Is that because rcu_eqs_enter() doesn't really do enough?
> > 
> > The thing is, if all other CPUs are idle, detecting the end of a grace
> > period should be rather trivial and not involve FQSs and thus be tons
> > faster.
> > 
> > Clearly I'm missing something obvious and not communicating right or so.
> 
> Earlier you said that improving EQS behaviour was expensive in that it
> would require taking (global) locks or somesuch.
> 
> Would it not be possible to have the cpu performing a FQS finish this
> work; that way the first FQS would be a little slow, but after that no
> FQS would be needed anymore, right? Since we'd no longer require the
> other CPUs to end a grace period.

It is not just the first FQS that would be slow, it would also be slow
the next time that this CPU transitioned from idle to non-idle, which
is when this work would need to be undone.

Furthermore, in this approach, RCU would still need to scan all the CPUs
to see if any did the first part of the transition to idle.  And if we
have to scan either way, why not keep the idle-nonidle transitions cheap
and continue to rely on the scan?  Here are the rationales I can think
of and what I am thinking in terms of doing instead:

1.	The scan could become a scalability bottleneck.  There is one
	way to handle this today, and one possible future change.  The way
	to handle this today is to increas rcutree.jiffies_till_first_fqs,
	for example, the SGI guys set it to 20 or thereabouts.  If this
	becomes problematic, I could easily create multiple kthreads to
	carry out the FQS scan in parallel for large systems.

2.	Someone could demonstrate that RCU's grace periods were significantly
	delaying boot.  There are several ways of dealing with this:

	a.	Set rcupdate.rcu_expedited=1 at boot, and set it back
		after boot completes.

	b.	Set rcutree.jiffies_till_first_fqs=0.

	c.	As (b) above, but modifying RCU to use additional
		kthreads for the per-CPU grace-period operations.

Make sense?

							Thanx, Paul

