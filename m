Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaHJBil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 21:38:41 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34270 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaHJBik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 21:38:40 -0400
Date: Sat, 9 Aug 2014 18:38:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140810013829.GP5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809183355.GP9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809183355.GP9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081001-7164-0000-0000-000003B4B47A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 08:33:55PM +0200, Peter Zijlstra wrote:
> On Fri, Aug 08, 2014 at 01:58:26PM -0700, Paul E. McKenney wrote:
> > 
> > > And on that, you probably should change rcu_sched_rq() to read:
> > > 
> > > 	this_cpu_inc(rcu_sched_data.passed_quiesce);
> > > 
> > > That avoids touching the per-cpu data offset.
> > 
> > Hmmm...  Interrupts are disabled,
> 
> No they are not, __schedule()->rcu_note_context_switch()->rcu_sched_qs()
> is only called with preemption disabled.
> 
> We only disable IRQs later, where we take the rq->lock.

You want me not to disable irqs before invoking rcu_preempt_qs() from
rcu_preempt_note_context_switch(), I get that.  But right now, they
really are disabled courtesy of the local_irq_save() before the call
to rcu_preempt_qs() from rcu_preempt_note_context_switch().

> > so no need to further disable
> > interrupts.  Storing 1 works fine, no need to increment.  If I followed
> > the twisty per_cpu passages correctly, my guess is that you would like
> > me to do something like this:
> > 
> > 	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
> > 
> > Does that work?
> 
> Yeah, should be more or less similar, the inc might be encoded shorter
> due to not requiring an immediate, but who cares :-)
> 
> void rcu_sched_qs(int cpu)
> {
> 	if (trace_rcu_grace_period_enabled()) {
> 		if (!__this_cpu_read(rcu_sched_data.passed_quiesce))
> 			trace_rcu_grace_period(...);
> 	}
> 	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
> }
> 
> Would further avoid emitting the conditional in the normal case where
> the tracepoint is inactive.

It might be better to avoid storing to rcu_sched_data.passed_quiesce when
it is already 1, though the difference would be quite hard to measure.
In that case, this would work nicely:

static void rcu_preempt_qs(int cpu)
{
	if (rdp->passed_quiesce == 0) {
		trace_rcu_grace_period(TPS("rcu_preempt"), rdp->gpnum, TPS("cpuqs"));
	> 	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
	}
	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
}

> Steve does it make sense to have __DO_TRACE() emit __trace_##name() to
> avoid the double static_branch thing?
> 
> > > And it would be very good if we could avoid the unconditional IRQ flag
> > > fiddling in rcu_preempt_note_context_switch(), them expensive, this
> > > looks entirely feasibly in the 'normal' case where
> > > t->rcu_read_unlock_special doesn't have RCU_READ_UNLOCK_NEED_QS set.
> > 
> > Agreed, but sometimes RCU_READ_UNLOCK_NEED_QS is set.
> > 
> > That said, I should probably revisit RCU_READ_UNLOCK_NEED_QS.  A lot has
> > changed since I wrote that code.
> 
> Sure, but a conditional testing RCU_READ_UNLOCK_NEED_QS is far cheaper
> than poking the IRQ flags. That said, its not entirely clear to me why
> that needs IRQs disabled at all, then again I didn't look long and I'm
> sure its all subtle.

This bit gets set from the scheduler-clock interrupt, so disabling
interrupts is the standard approach to avoid confusion.  Might be possible
to avoid it in this case, or make it less frequent, or whatever.  As I
said, I haven't thought much about it since the initial implementation
some years back, so worth worrying about again.

							Thanx, Paul

