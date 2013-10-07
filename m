Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3JGImy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 04:42:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57027 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3JGImw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 04:42:52 -0400
Date: Mon, 7 Oct 2013 10:42:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131007084239.GX3081@twins.programming.kicks-ass.net>
References: <20131004065835.GP28601@twins.programming.kicks-ass.net>
 <20131004160352.GF5790@linux.vnet.ibm.com>
 <20131004165044.GV28601@twins.programming.kicks-ass.net>
 <20131004170954.GK5790@linux.vnet.ibm.com>
 <20131004185239.GS15690@laptop.programming.kicks-ass.net>
 <20131004212506.GM5790@linux.vnet.ibm.com>
 <20131005160511.GV3081@twins.programming.kicks-ass.net>
 <20131005162802.GP5790@linux.vnet.ibm.com>
 <20131005195949.GW3081@twins.programming.kicks-ass.net>
 <20131005220310.GR5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005220310.GR5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 03:03:11PM -0700, Paul E. McKenney wrote:
> In theory, we could do that.  But in practice, what would wake us up
> when the CPUs go non-idle?
> 
> 1.	We could do a wakeup on the idle-to-non-idle transition.  That
> 	would increase idle-to-non-idle latency, defeating the purpose
> 	of rcu_nocb_poll=y.  Plus there are workloads that enter and
> 	exit idle extremely quickly, which would not be good for either
> 	perforrmance, scalability, or energy efficiency.
> 
> 2.	We could have some other thread poll all the CPUs for activity,
> 	for example, the RCU grace-period kthreads.  This might actually
> 	work, but there are some really ugly races involving CPUs becoming
> 	active just long enough to post a callback, going to sleep,
> 	with no other RCU activity in the system.  This could easily
> 	result in a system hang.
> 
> 3.	We could post a timeout to check for the corresponding CPU
> 	being idle, but that just transfers the wakeups from idle from
> 	the rcuo kthreads to the other CPUs.
> 
> 4.	I remove rcu_nocb_poll and see if anyone complains.  That doesn't
> 	solve the deadlock problem, but it does simplify RCU a bit.  ;-)
> 
> Other thoughts?

So we already move all the nocb rcuo threads over to the timekeeping
cpu, right? Giving you n threads to wake and/or poll and that's
expensive.

So why doesn't the time-keeping cpu, which is awake when at least one of
the nocb cpus is awake, not poll the nocb cpus their call list?

Arguably you don't want to do that from the old scheduler tick interrupt
or softirq context thingy, but by using a kthread but you've already got
all that around.

At that point; you've got a single kthread periodically being woken by
the scheduler timer interrupt -- which still goes away when the entire
machine goes idle -- which would do something like:


  for_each_cpu(cpu, nocb_cpus_mask) {
  	if (!list_empty_careful(&per_cpu(rcu_state, cpu)->callbacks))
		advance_cpu_callbacks(cpu);
  }


That fully preserves the !NOCB state of affairs while also dealing with
the NOCB stuff. And the single remote read only gets really expensive
once you go _very_ large or once the cpu in question actually touched
the cacheline and moved it into exclusive mode due to writing to it; at
which point you've saved yourself a wakeup and we're still faster.

It automatically deals with the full idle case, it basically gives you
'poll' behaviour for nr_running==1 and to me appears as the simplest and
most straight fwd extension of the RCU model.

More importantly it does away with that wakeup that so often happens on
nocb cpus. Although, rereading your email, I get the impression we do
this wakeup even on !nocb cpus when CONFIG_NOCB=y, which seems another
undesired feature.


Maybe you've already thought of this and there's a very good reason
things aren't like this; but like said, I've been away for a little
while and need to catch up a bit.

