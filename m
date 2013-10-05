Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3JEWDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 18:03:19 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46984 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3JEWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 18:03:18 -0400
Date: Sat, 5 Oct 2013 15:03:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131005220310.GR5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131003195832.GU5790@linux.vnet.ibm.com>
 <20131004065835.GP28601@twins.programming.kicks-ass.net>
 <20131004160352.GF5790@linux.vnet.ibm.com>
 <20131004165044.GV28601@twins.programming.kicks-ass.net>
 <20131004170954.GK5790@linux.vnet.ibm.com>
 <20131004185239.GS15690@laptop.programming.kicks-ass.net>
 <20131004212506.GM5790@linux.vnet.ibm.com>
 <20131005160511.GV3081@twins.programming.kicks-ass.net>
 <20131005162802.GP5790@linux.vnet.ibm.com>
 <20131005195949.GW3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005195949.GW3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100522-9332-0000-0000-000001A9474B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 09:59:49PM +0200, Peter Zijlstra wrote:
> On Sat, Oct 05, 2013 at 09:28:02AM -0700, Paul E. McKenney wrote:
> > On Sat, Oct 05, 2013 at 06:05:11PM +0200, Peter Zijlstra wrote:
> > > On Fri, Oct 04, 2013 at 02:25:06PM -0700, Paul E. McKenney wrote:
> > > > >                                                                     Why
> > > > > do we still have a per-cpu kthread in nocb mode? The idea is that we do
> > > > > not disturb the cpu, right? So I suppose these kthreads get to run on
> > > > > another cpu.
> > > > 
> > > > Yep, the idea is that usermode figures out where to run them.  Even if
> > > > usermode doesn't do that, this has the effect of getting them to be
> > > > more out of the way of real-time tasks.
> > > > 
> > > > > Since its running on another cpu; we get into atomic and memory barriers
> > > > > anyway; so why not keep the logic the same as no-nocb but have another
> > > > > cpu check our nocb cpu's state.
> > > > 
> > > > You can do that today by setting rcu_nocb_poll, but that results in
> > > > frequent polling wakeups even when the system is completely idle, which
> > > > is out of the question for the battery-powered embedded guys.
> > > 
> > > So its this polling I don't get.. why is the different behaviour
> > > required? And why would you continue polling if the cpus were actually
> > > idle.
> > 
> > The idea is to offload the overhead of doing the wakeup from (say)
> > a real-time thread/CPU onto some housekeeping CPU.
> 
> Sure I get that that is the idea; what I don't get is why it needs to
> behave differently depending on NOCB.
> 
> Why does a NOCB thingy need to wake up the kthread far more often?

A better question would be "Why do NOCB wakeups have higher risk of
hitting RCU/sched/perf deadlocks?"

In the !NOCB case, we rely on the scheduling-clock interrupt handler and
transition to idle to do the wakeups of ksoftirqd.  These two environments
cannot possibly be holding scheduler or perf locks, so there is no risk
of deadlock in the common case.

Now there would be risk of deadlock in the !NOCB uncommon case where a
huge burst of call_rcu() invocations has caused more than 10,000 callbacks
to pile up on a single CPU -- in that case, call_rcu() will do the wakeup.
But only if interrupts are enabled, which again avoids the deadlock.

This deferral is OK because we are guaranteed that one of the following
things will eventually happen:

1.	Another call_rcu() arrives with more than 10,000 callbacks on
	the CPU, but when interrupts are enabled.

2.	In NO_HZ_PERIODIC kernels, or in workloads that remain in the
	kernel for a very long time, we eventually take a scheduling-clock
	interrupt.

3.	In !RCU_FAST_NO_HZ kernels, on attempted transition to an
	idle-RCU state (idle and, for NO_HZ_FULL, userspace with
	only one task runnable), rcu_needs_cpu() will refuse the
	request to turn off the scheduling-clock interrupt, again
	eventually taking a scheduling-clock interrupt.

4.	In RCU_FAST_NO_HZ kernels, on transition to an idle-RCU
	state, we advance the new callbacks and inform the RCU
	core of their existence.

But none of these currently apply in the NOCB case.  Instead, the idea
is to wake up the corresponding rcuo kthread when the first callback
arrives at an initially empty per-CPU list.  Wakeups are omitted if the
list already has callbacks in it.  Given that this produces a wakeup at
most once per grace period (several milliseconds at the very least),
I wasn't worried about it from a performance/scalability viewpoint.
Unfortunately, we have a deadlock issue.

My patch attempts to resolve this by moving the wakeup to the RCU core,
which is invoked by the scheduling-clock interrupt, and to the idle-entry
code.

> > > Is there some confusion between the nr_running==1 extended quiescent
> > > state and the nr_running==0 extended quiescent state?
> > 
> > This is independent of the nr_running=1 extended quiescent state.  The
> > wakeups only happen when runnning in the kernel.  That said, a real-time
> > thread might want both rcu_nocb_poll=y and CONFIG_NO_HZ_FULL=y.
> 
> So there's 3 behaviours?
> 
>  - CONFIG_NO_HZ_FULL=n
>  - CONFIG_NO_HZ_FULL=y, rcu_nocb_poll=n
>  - CONFIG_NO_HZ_FULL=y, rcu_nocb_poll=y

More like the following:

CONFIG_RCU_NOCB_CPU=n: Old behavior.
CONFIG_RCU_NOCB_CPU=y, rcu_nocb_poll=n: Wakeup deadlocks.
CONFIG_RCU_NOCB_CPU=y, rcu_nocb_poll=y: rcuo kthread periodically polls,
	so no wakeups and (presumably) no deadlocks.

> What I'm trying to understand is why do all those things behave
> differently? For all 3 configs there's kthreads that do the GP advancing
> and can run on different cpus.

Yes, there are always the RCU grace-period kthreads, but these are
never awakened by call_rcu().  Instead, call_rcu() awakens either the
ksoftirqd kthread (old behavior) or the rcuo callback-offload kthread
(CONFIG_RCU_NOCB_CPU=y, rcu_nocb_poll=n behavior), in both cases, the
kthread for the current CPU.

The old ksoftirqd wakeup is avoided if interrupts were disabled on entry
to call_rcu(), as you noted earlier, which avoids the deadlock.  The basic
idea of the patch is to do something similar in the CONFIG_RCU_NOCB_CPU=y,
rcu_nocb_poll=n case.

> And why does rcu_nocb_poll=y need to be terrible for power usage; surely
> we know when cpus are actually idle and can stop polling them.

In theory, we could do that.  But in practice, what would wake us up
when the CPUs go non-idle?

1.	We could do a wakeup on the idle-to-non-idle transition.  That
	would increase idle-to-non-idle latency, defeating the purpose
	of rcu_nocb_poll=y.  Plus there are workloads that enter and
	exit idle extremely quickly, which would not be good for either
	perforrmance, scalability, or energy efficiency.

2.	We could have some other thread poll all the CPUs for activity,
	for example, the RCU grace-period kthreads.  This might actually
	work, but there are some really ugly races involving CPUs becoming
	active just long enough to post a callback, going to sleep,
	with no other RCU activity in the system.  This could easily
	result in a system hang.

3.	We could post a timeout to check for the corresponding CPU
	being idle, but that just transfers the wakeups from idle from
	the rcuo kthreads to the other CPUs.

4.	I remove rcu_nocb_poll and see if anyone complains.  That doesn't
	solve the deadlock problem, but it does simplify RCU a bit.  ;-)

Other thoughts?

							Thanx, Paul

