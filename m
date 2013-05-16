Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3EPNWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:22:39 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55427 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab3EPNWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:22:38 -0400
Date: Thu, 16 May 2013 06:22:10 -0700
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
Message-ID: <20130516132210.GV4442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130413195336.GA14799@leaf>
 <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
 <20130515085639.GD10510@laptop.programming.kicks-ass.net>
 <20130515090234.GE10510@laptop.programming.kicks-ass.net>
 <20130515173142.GL4442@linux.vnet.ibm.com>
 <20130516094519.GJ19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516094519.GJ19669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051613-7182-0000-0000-000006BE6F62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 11:45:19AM +0200, Peter Zijlstra wrote:
> On Wed, May 15, 2013 at 10:31:42AM -0700, Paul E. McKenney wrote:
> > On Wed, May 15, 2013 at 11:02:34AM +0200, Peter Zijlstra wrote:
> 
> > > Earlier you said that improving EQS behaviour was expensive in that it
> > > would require taking (global) locks or somesuch.
> > > 
> > > Would it not be possible to have the cpu performing a FQS finish this
> > > work; that way the first FQS would be a little slow, but after that no
> > > FQS would be needed anymore, right? Since we'd no longer require the
> > > other CPUs to end a grace period.
> > 
> > It is not just the first FQS that would be slow, it would also be slow
> > the next time that this CPU transitioned from idle to non-idle, which
> > is when this work would need to be undone.
> 
> Hurm, yes I suppose that is true. If you've saved more on FQS cost it might be
> worth it for the throughput people though.

But the NO_HZ_PERIODIC and NO_HZ_IDLE throughput people will have their
CPUs non-idle, which means that they are reporting their quiescent states
and the FQS scan just isn't happening.  The NO_HZ_FULL throughput people
will have their RCU GP kthreads pinned to the timekeeping CPU, and therefore
won't care much about the overhead of the FQS scan.

> But somehow I imagined making a CPU part of the GP would be easier than taking
> it out. After all, taking it out is dangerous and careful work, one is not to
> accidentally execute a callback or otherwise end a GP before time.
> 
> When entering the GP cycle there is no such concern, the CPU state is clean
> after all.

But that would increase the overhead of GP initialization.  Right now,
GP initialization touches only the leaf rcu_node structures, of which
there are by default one per 16 CPUs (and can be configured up to one per
64 CPUs, which it is on really big systems).  So on busy mixed-workload
systems, this approach increases GP initialization overhead for no
good reason -- and on systems running these sorts of workloads, there
usually aren't "sacrificial lamb" timekeeping CPUs whose utilization
doesn't matter.

> > Furthermore, in this approach, RCU would still need to scan all the CPUs
> > to see if any did the first part of the transition to idle.  And if we
> > have to scan either way, why not keep the idle-nonidle transitions cheap
> > and continue to rely on the scan?  Here are the rationales I can think
> > of and what I am thinking in terms of doing instead:
> > 
> > 1.	The scan could become a scalability bottleneck.  There is one
> > 	way to handle this today, and one possible future change.  The way
> > 	to handle this today is to increas rcutree.jiffies_till_first_fqs,
> > 	for example, the SGI guys set it to 20 or thereabouts.  If this
> > 	becomes problematic, I could easily create multiple kthreads to
> > 	carry out the FQS scan in parallel for large systems.
> 
> *groan* whoever thought all this SMP nonsense was worth it again? :-)

NR_CPUS=0!!!  It is the only way!  ;-)

> > 2.	Someone could demonstrate that RCU's grace periods were significantly
> > 	delaying boot.  There are several ways of dealing with this:
> 
> Surely there's also non-boot cases where most of the machine is 'idle' and
> we're running into FQS? Esp. now with that userspace NO_HZ stuff from Frederic.

Yep, but as noted above, the NO_HZ_FULL case will be running the RCU
GP kthreads on the timekeeping CPUs, where they aren't running worker
threads.  In the general-purpose workload case, the CPUs are busy and
doing a wide variety of things, so that with high probability each
CPU checks in before the three-jiffies FQS scan has a chance to get
kicked off.

							Thanx, Paul

