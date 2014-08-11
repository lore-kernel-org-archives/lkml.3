Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaHKDhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:37:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47220 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaHKDhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:37:22 -0400
Date: Sun, 10 Aug 2014 20:37:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140811033714.GU5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809183355.GP9918@twins.programming.kicks-ass.net>
 <20140810013829.GP5821@linux.vnet.ibm.com>
 <20140810150005.GU9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140810150005.GU9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081103-1344-0000-0000-000003600449
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 05:00:05PM +0200, Peter Zijlstra wrote:
> On Sat, Aug 09, 2014 at 06:38:29PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 09, 2014 at 08:33:55PM +0200, Peter Zijlstra wrote:
> > > On Fri, Aug 08, 2014 at 01:58:26PM -0700, Paul E. McKenney wrote:
> > > > 
> > > > > And on that, you probably should change rcu_sched_rq() to read:
> > > > > 
> > > > > 	this_cpu_inc(rcu_sched_data.passed_quiesce);
> > > > > 
> > > > > That avoids touching the per-cpu data offset.
> > > > 
> > > > Hmmm...  Interrupts are disabled,
> > > 
> > > No they are not, __schedule()->rcu_note_context_switch()->rcu_sched_qs()
> > > is only called with preemption disabled.
> > > 
> > > We only disable IRQs later, where we take the rq->lock.
> > 
> > You want me not to disable irqs before invoking rcu_preempt_qs() from
> > rcu_preempt_note_context_switch(), I get that.  But right now, they
> > really are disabled courtesy of the local_irq_save() before the call
> > to rcu_preempt_qs() from rcu_preempt_note_context_switch().
> 
> Ah, confusion there, I said rcu_sched_qs(), you're talking about
> rcu_preempt_qs().
> 
> Yes the call to rcu_preempt_qs() is unconditionally wrapped in IRQ
> disable.

Apologies for my confusion!  The rcu_sched_qs() call doesn't need
to interact directly with the scheduling-clock interrupt using
read-modify-write variables, so it gets a pass.

> > > void rcu_sched_qs(int cpu)
> > > {
> > > 	if (trace_rcu_grace_period_enabled()) {
> > > 		if (!__this_cpu_read(rcu_sched_data.passed_quiesce))
> > > 			trace_rcu_grace_period(...);
> > > 	}
> > > 	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
> > > }
> > > 
> > > Would further avoid emitting the conditional in the normal case where
> > > the tracepoint is inactive.
> > 
> > It might be better to avoid storing to rcu_sched_data.passed_quiesce when
> > it is already 1, though the difference would be quite hard to measure.
> > In that case, this would work nicely:
> > 
> > static void rcu_preempt_qs(int cpu)
> > {
> > 	if (rdp->passed_quiesce == 0) {
> > 		trace_rcu_grace_period(TPS("rcu_preempt"), rdp->gpnum, TPS("cpuqs"));
> > 	> 	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
> > 	}
> > 	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
> > }
> 
> Yes, that's a consideration, fair enough. Again note the confusion
> between sched/preempt. But yes, both can use this 'cleanup'.

OK, it is on my list.

							Thanx, Paul

