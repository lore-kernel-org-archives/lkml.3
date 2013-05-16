Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3EPNOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:14:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52644 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab3EPNOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:14:48 -0400
Date: Thu, 16 May 2013 06:13:19 -0700
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
Message-ID: <20130516131319.GU4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130413193425.GY29861@linux.vnet.ibm.com>
 <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
 <20130515085639.GD10510@laptop.programming.kicks-ass.net>
 <20130515163700.GK4442@linux.vnet.ibm.com>
 <20130516093740.GI19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516093740.GI19669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051613-7606-0000-0000-00000B6F82EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 11:37:40AM +0200, Peter Zijlstra wrote:
> On Wed, May 15, 2013 at 09:37:00AM -0700, Paul E. McKenney wrote:
> > The need is to detect that an idle CPU is idle without making it do
> > anything.  To do otherwise would kill battery lifetime and introduce
> > OS jitter.
> 
> Not anything isn't leaving us much room to wriggle, we could maybe try and do a
> wee bit without people shooting us :-) In fact, looking at rcu_idle_enter()
> its very much not an empty function.

That said, it operates on CPU-local variables, so the first idle/nonidle
transition after an FQS scan is expensive, but subsequent transitions
will not incur communications cache misses.

> > This other CPU must be able to correctly detect idle CPUs regardless of
> > how long they have been idle.  In particular, it is necessary to detect
> > CPUs that were idle at the start of the current grace period and have
> > remained idle throughout the entirety of the current grace period.
> 
> OK, so continuing this hypothetical merry go round :-) 
> 
> Since RCU is a global endeavour, I'm assuming there is a global GP sequence
> number. Could we not stamp the CPU with the current GP# in rcu_idle_enter().

We could do that.  But we would still need to store it surrounded by
memory barriers, and we would still need to scan it every grace period
to which the CPU did not otherwise repond.

This would get rid of atomic-instruction overhead, but the atomic part
of the increment is on my list to eliminate in any case.

Furthermore, if we stamp the CPU with the last grace period during which
it was non-idle (which needs to be the case for the non-idle-to-idle
transition), we cannot tell whether or not that CPU went idle during
the current grace period if it was non-idle during that grace period.
In contrast, the current scheme can detect arbitrarily short idle
sojourns, regardless of the current state of the CPU.

> > A CPU might transition between idle and non-idle states at any time.
> > Therefore, if RCU collects a given CPU's idleness state during a given
> > grace period, it must be very careful to avoid relying on that state
> > during some other grace period.
> 
> However, if we know during which GP it became idle, we know we can ignore it
> for all GPs thereafter, right?

Yes, but as noted above, we wouldn't know to ignore it during the GP during
which it became idle, which is quite important -- many workloads have
short idle sojourns, e.g., due to interrupts arriving at an otherwise
idle CPU.

> > Therefore, from what I can see, unless all CPUs explicitly report a
> > quiescent state in a timely fashion during a given grace period (in
> > which case each CPU was non-idle at some point during that grace period),
> > there is no alternative to polling RCU's per-CPU rcu_dynticks structures
> > during that grace period.  In particular, if at least one CPU remained
> > idle throughout that grace period, it will be necessary to poll.
> 
> Agreed.. 
> 
> > Of course, during boot time, there are often long time periods during
> > which at least one CPU remains idle.  Therefore, we can expect many
> > boot-time grace periods to delay for at least one FQS time period.
> > 
> > OK, so how much delay does this cause? 
> 
> Oh, I'm so way past that, it is a neat puzzle by now ;-)

I can identify with that feeling! ;-)

							Thanx, Paul

