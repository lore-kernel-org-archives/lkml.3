Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaGURdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:33:13 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59364 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbaGURdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:33:12 -0400
Date: Mon, 21 Jul 2014 10:33:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu] Do not keep timekeeping CPU tick running
 for non-nohz_full= CPUs
Message-ID: <20140721173306.GA8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140719165350.GA18411@linux.vnet.ibm.com>
 <20140719180120.GA20887@localhost.localdomain>
 <20140720114759.GO8690@linux.vnet.ibm.com>
 <20140720203417.GV9918@twins.programming.kicks-ass.net>
 <20140721155741.GW8690@linux.vnet.ibm.com>
 <20140721170459.GP3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721170459.GP3935@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072117-9332-0000-0000-00000173DC63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 07:04:59PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 21, 2014 at 08:57:41AM -0700, Paul E. McKenney wrote:
> > On Sun, Jul 20, 2014 at 10:34:17PM +0200, Peter Zijlstra wrote:
> > > On Sun, Jul 20, 2014 at 04:47:59AM -0700, Paul E. McKenney wrote:
> > > > So we really have to have -all- the CPUs be idle to turn off the timekeeper.
> > > 
> > > That seems to be pretty unavoidable any which way around.
> > 
> > Hmmm...  The exception would be the likely common case where none of
> > the CPUs are flagged as nohz_full= CPUs.  If we handled that case as
> > if CONFIG_NO_HZ_FULL=n, we would have handled almost all of
> > the problem.
> 
> You mean that is not currently the case? Yes that seems like a fairly
> sane thing to do.

Hard to say -- need to see where Frederic is putting the call to
rcu_sys_is_idle().  On the RCU side, I could potentially lower overhead
by checking tick_nohz_full_enabled() in a few functions.

> > > > This won't make the battery-powered embedded guys happy...
> > > > 
> > > > Other thoughts on this?  We really should not be setting
> > > > CONFIG_NO_HZ_FULL_SYSIDLE by default until this is solved.
> > > 
> > > What are those same guys doing with nohz_full to begin with?
> > 
> > If CONFIG_NO_HZ_FULL_SYSIDLE=y is the default, my main concern is for
> > people who didn't really want it, and who thus did not set the nohz_full=
> > boot parameter.  Hence my suggestion above that we treat that case as
> > if CONFIG_NO_HZ_FULL=n (and thus also as if CONFIG_NO_HZ_FULL_SYSIDLE=n).
> 
> ack
> 
> > There have been some people saying that they want only a subset of
> > their CPUs in nohz_full= state, and these guys seem to want to run a
> > mixed workload.  For example, they have HPC (or RT) workloads on the
> > nohz_full= CPUs, and also want normal high-throughput processing on the
> > remaining CPUs.  If software was trivial (and making other unlikely
> > assumptions about the perfection of the world and the invalidity of
> > Murphy's lawy), we would want the timekeeping CPU to be able to move
> > among the non-nohz_full= CPUs.
> 
> Yeah, I don't see a problem with that, but then I'm not entirely sure
> why we use RCU to track system idle state.

Because RCU needs to do very similar tracking to deal with dyntick-idle
CPUs and the various types of RCU grace periods.

> > However, this should be a small fraction of the users, and many of
> > these guys would probably be open to making a few changes.  Thus, a
> > less-proactive approach should allow us to solve their actual problems, as
> > opposed to the problems that we speculate that they might encounter.  ;-)
> 
> But you still haven't talked about the battery people... I don't think
> nohz_full is something they should care about / use.

For all I know, they might care, but it is all speculative at this point.
The possible use cases would be if they were needing some HPC-style
computations for some misbegotten mobile implementation of some
misbegotten game.

So as far as I know at this point, the common case for the battery-powered
guys is that they don't want unconditional scheduling-clock interrupts
on CPU 0 when CPU 0 is idle, and that case is covered by our discussion
above.

							Thanx, Paul

