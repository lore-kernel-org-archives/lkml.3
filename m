Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab3JGNLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 09:11:14 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54739 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3JGNLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 09:11:13 -0400
Date: Mon, 7 Oct 2013 06:11:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131007131102.GY5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131004160352.GF5790@linux.vnet.ibm.com>
 <20131004165044.GV28601@twins.programming.kicks-ass.net>
 <20131004170954.GK5790@linux.vnet.ibm.com>
 <20131004185239.GS15690@laptop.programming.kicks-ass.net>
 <20131004212506.GM5790@linux.vnet.ibm.com>
 <20131005160511.GV3081@twins.programming.kicks-ass.net>
 <20131005162802.GP5790@linux.vnet.ibm.com>
 <20131005195949.GW3081@twins.programming.kicks-ass.net>
 <20131005220310.GR5790@linux.vnet.ibm.com>
 <20131007084239.GX3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007084239.GX3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100713-8236-0000-0000-00000277C34E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:42:39AM +0200, Peter Zijlstra wrote:
> On Sat, Oct 05, 2013 at 03:03:11PM -0700, Paul E. McKenney wrote:
> > In theory, we could do that.  But in practice, what would wake us up
> > when the CPUs go non-idle?
> > 
> > 1.	We could do a wakeup on the idle-to-non-idle transition.  That
> > 	would increase idle-to-non-idle latency, defeating the purpose
> > 	of rcu_nocb_poll=y.  Plus there are workloads that enter and
> > 	exit idle extremely quickly, which would not be good for either
> > 	perforrmance, scalability, or energy efficiency.
> > 
> > 2.	We could have some other thread poll all the CPUs for activity,
> > 	for example, the RCU grace-period kthreads.  This might actually
> > 	work, but there are some really ugly races involving CPUs becoming
> > 	active just long enough to post a callback, going to sleep,
> > 	with no other RCU activity in the system.  This could easily
> > 	result in a system hang.
> > 
> > 3.	We could post a timeout to check for the corresponding CPU
> > 	being idle, but that just transfers the wakeups from idle from
> > 	the rcuo kthreads to the other CPUs.
> > 
> > 4.	I remove rcu_nocb_poll and see if anyone complains.  That doesn't
> > 	solve the deadlock problem, but it does simplify RCU a bit.  ;-)
> > 
> > Other thoughts?
> 
> So we already move all the nocb rcuo threads over to the timekeeping
> cpu, right? Giving you n threads to wake and/or poll and that's
> expensive.

I don't pin the rcuo threads anywhere, though I would expect people
to move them to some set of housekeeping CPUs, the timekeeping CPU
being a good candidate.

> So why doesn't the time-keeping cpu, which is awake when at least one of
> the nocb cpus is awake, not poll the nocb cpus their call list?

If !NO_HZ_FULL, there won't be a timekeeping CPU as such, if I remember
correctly.

> Arguably you don't want to do that from the old scheduler tick interrupt
> or softirq context thingy, but by using a kthread but you've already got
> all that around.

The polling happens in the grace-period kthread, but it is not guaranteed
to be happening unless NO_HZ_FULL_SYSIDLE, in which case the system
will generate artificial grace periods as needed to make the required
polling happen.  On the other hand, if !NO_HZ_FULL_SYSIDLE, there will
not be any polling if there is no RCU update activity.

> At that point; you've got a single kthread periodically being woken by
> the scheduler timer interrupt -- which still goes away when the entire
> machine goes idle -- which would do something like:
> 
> 
>   for_each_cpu(cpu, nocb_cpus_mask) {
>   	if (!list_empty_careful(&per_cpu(rcu_state, cpu)->callbacks))
> 		advance_cpu_callbacks(cpu);
>   }
> 
> 
> That fully preserves the !NOCB state of affairs while also dealing with
> the NOCB stuff. And the single remote read only gets really expensive
> once you go _very_ large or once the cpu in question actually touched
> the cacheline and moved it into exclusive mode due to writing to it; at
> which point you've saved yourself a wakeup and we're still faster.
> 
> It automatically deals with the full idle case, it basically gives you
> 'poll' behaviour for nr_running==1 and to me appears as the simplest and
> most straight fwd extension of the RCU model.
> 
> More importantly it does away with that wakeup that so often happens on
> nocb cpus. Although, rereading your email, I get the impression we do
> this wakeup even on !nocb cpus when CONFIG_NOCB=y, which seems another
> undesired feature.

The __call_rcu_nocb_enqueue() wakeup happens only when CONFIG_NOCB=y,
and even then only on CPUs that have actually been offloaded.
Now my patch does the checking even on non-offloaded CPUs, but this
still only happen on CONFIG_NOCB=y and is only a check of a
per-CPU variable.

The other wakeups in __call_rcu_core() only happen in special cases,
which I believe avoid this deadlock condition.

> Maybe you've already thought of this and there's a very good reason
> things aren't like this; but like said, I've been away for a little
> while and need to catch up a bit.

>From what I can see, what you suggest would work quite well in special
cases, but I still have to solve the general case.  If I solve the
general case, I don't believe I need to work on the special cases.

							Thanx, Paul

