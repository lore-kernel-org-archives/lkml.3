Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab3EOVKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:10:41 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46699 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3EOVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:10:39 -0400
Date: Wed, 15 May 2013 09:37:00 -0700
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
Message-ID: <20130515163700.GK4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130413063804.GV29861@linux.vnet.ibm.com>
 <20130413181800.GA12096@leaf>
 <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
 <20130515085639.GD10510@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515085639.GD10510@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051521-3620-0000-0000-00000283B7A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 10:56:39AM +0200, Peter Zijlstra wrote:
> On Tue, May 14, 2013 at 08:47:28AM -0700, Paul E. McKenney wrote:
> > On Tue, May 14, 2013 at 04:51:20PM +0200, Peter Zijlstra wrote:
> > > > In theory, yes.  In practice, this requires lots of lock acquisitions
> > > > and releases on large systems, including some global locks.  The weight
> > > > could be reduced, but...
> > > > 
> > > > What I would like to do instead would be to specify expedited grace
> > > > periods during boot.
> > > 
> > > But why, surely going idle without any RCU callbacks isn't completely unheard
> > > of, even outside of the boot process?
> > 
> > Yep, and RCU has special-cased that for quite some time.
> > 
> > > Being able to quickly drop out of the RCU state machinery would be a good thing IMO.
> > 
> > And this is currently possible -- this is the job of rcu_idle_enter()
> > and friends.  And it works well, at least when I get my "if" statements
> > set up correctly (hence the earlier patch).
> > 
> > Or are you seeing a slowdown even with that earlier patch applied?  If so,
> > please let me know what you are seeing.
> 
> I'm not running anything in particular, except maybe a broken mental
> model of RCU ;-)
> 
> So what I'm talking about is the !rcu_cpu_has_callbacks() case, where
> there's absolutely nothing for RCU to do except tell the state machine
> its no longer participating.
> 
> Your patch to rcu_needs_cpu() frobbing the lazy condition is after that
> and thus irrelevant for this AFAICT.
> 
> Now as far as I can see, rcu_needs_cpu() will return false in this case;
> allowing the cpu to enter NO_HZ state. We then call rcu_idle_enter()
> which would call rcu_eqs_enter(). Which should put the CPU in extended
> quiescent state.

Yep, that is exactly what happens in that case.

But it really was the wrongly frobbed lazy check that was causing the
regression in boot times and in suspend/hibernate times.

> However, you're still running into these FQSs delaying boot. Why is
> that? Is that because rcu_eqs_enter() doesn't really do enough?

You are assuming that they are delaying boot.  Maybe they are and maybe
they are not.  One way to find out would be to boot both with and without
rcupdate.rcu_expedited=1 and compare the boot times.  I don't see a
statistically significant difference when I try it, but other hardware
and software configurations might see other results.

For the sake of argument, let's assume that thye are.

> The thing is, if all other CPUs are idle, detecting the end of a grace
> period should be rather trivial and not involve FQSs and thus be tons
> faster.
> 
> Clearly I'm missing something obvious and not communicating right or so.

Or maybe it is me missing the obvious -- wouldn't be the first time!  ;-)

The need is to detect that an idle CPU is idle without making it do
anything.  To do otherwise would kill battery lifetime and introduce
OS jitter.

This other CPU must be able to correctly detect idle CPUs regardless of
how long they have been idle.  In particular, it is necessary to detect
CPUs that were idle at the start of the current grace period and have
remained idle throughout the entirety of the current grace period.

A CPU might transition between idle and non-idle states at any time.
Therefore, if RCU collects a given CPU's idleness state during a given
grace period, it must be very careful to avoid relying on that state
during some other grace period.

Therefore, from what I can see, unless all CPUs explicitly report a
quiescent state in a timely fashion during a given grace period (in
which case each CPU was non-idle at some point during that grace period),
there is no alternative to polling RCU's per-CPU rcu_dynticks structures
during that grace period.  In particular, if at least one CPU remained
idle throughout that grace period, it will be necessary to poll.

Of course, during boot time, there are often long time periods during
which at least one CPU remains idle.  Therefore, we can expect many
boot-time grace periods to delay for at least one FQS time period.

OK, so how much delay does this cause?  The delay from the start
of the grace period until the first FQS scan is controlled by
jiffies_till_first_fqs, which defaults to 3 jiffies.  One question
might be "Why delay at all?"  The reason for delaying is efficiency at
run time -- the longer a given grace period delays, the more updates
will be handled by a given grace period, and the lower the per-update
grace-period overhead.

This still leaves the question of whether it would be better to
do the first scan immediately after initializing the grace period.
It turns out that you can make the current code do this by booting
with rcutree.jiffies_till_first_fqs=0.  You can also adjust the value
after boot via sysfs, though it will camp values to one second's worth
of jiffies.

So, if you are seeing RCU slowing down boot, there are two thing to try:

1.	Boot with rcupdate.rcu_expedited=1.

2.	Boot with rcutree.jiffies_till_first_fqs=0.

I cannot imagine changing the default for rcupdate.rcu_expedited
unless userspace set it back after boot completes, but if
rcutree.jiffies_till_first_fqs=0 helps, it might be worth changing
the default.

							Thanx, Paul

