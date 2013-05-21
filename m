Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3EURFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:05:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:50985 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3EURFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:05:01 -0400
Date: Tue, 21 May 2013 09:54:59 -0700
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
Message-ID: <20130521165459.GO3578@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
 <20130515085639.GD10510@laptop.programming.kicks-ass.net>
 <20130515090234.GE10510@laptop.programming.kicks-ass.net>
 <20130515173142.GL4442@linux.vnet.ibm.com>
 <20130516094519.GJ19669@dyad.programming.kicks-ass.net>
 <20130516132210.GV4442@linux.vnet.ibm.com>
 <20130521094531.GE26912@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521094531.GE26912@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052116-7408-0000-0000-0000106CCAFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 11:45:31AM +0200, Peter Zijlstra wrote:
> On Thu, May 16, 2013 at 06:22:10AM -0700, Paul E. McKenney wrote:
> > > But somehow I imagined making a CPU part of the GP would be easier than taking
> > > it out. After all, taking it out is dangerous and careful work, one is not to
> > > accidentally execute a callback or otherwise end a GP before time.
> > > 
> > > When entering the GP cycle there is no such concern, the CPU state is clean
> > > after all.
> > 
> > But that would increase the overhead of GP initialization.  Right now,
> > GP initialization touches only the leaf rcu_node structures, of which
> > there are by default one per 16 CPUs (and can be configured up to one per
> > 64 CPUs, which it is on really big systems).  So on busy mixed-workload
> > systems, this approach increases GP initialization overhead for no
> > good reason -- and on systems running these sorts of workloads, there
> > usually aren't "sacrificial lamb" timekeeping CPUs whose utilization
> > doesn't matter.
> 
> Right, so I read through some of the fqs code to get a better feel for
> things and I suppose I see what you're talking about :-)
> 
> The only thing I could come up with is making fqslock a global/local
> style lock, so that individual CPUs can adjust their own state without
> bouncing the lock around.

Maybe...  The current design uses bitmasks at each level, and avoiding the
upper-level locks would mean making RCU work with out-of-date bitmasks
at the upper levels.  Might be possible, but it is not clear to me that
this would be a win.

I could also maintain yet another bitmask at the bottom level to record
the idle CPUs, but it is not clear that this is a win, either, especially
on systems with frequent idle/busy transitions.

> It would make the fqs itself a 'bit' more expensive but ideally those
> don't happen that often, ha!.
> 
> But yeah, every time you let the fqs propagate 'idle' state up the tree
> your join becomes more expensive too.

Yep!  :-/

							Thanx, Paul

