Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab3F1PT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:19:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53650 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3F1PT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:19:26 -0400
Date: Fri, 28 Jun 2013 17:19:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
Message-ID: <20130628151906.GE6626@twins.programming.kicks-ass.net>
References: <51C8AA31.3070208@hds.com>
 <1372429303.18733.325.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372429303.18733.325.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 10:21:43AM -0400, Steven Rostedt wrote:
> [ Added Peter Z. and Paul ]
> >  void smp_trace_reschedule_interrupt(struct pt_regs *regs)
> >  {
> >  	ack_APIC_irq();
> > +	rcu_irq_enter();
> >  	trace_reschedule_entry(RESCHEDULE_VECTOR);
> >  	__smp_reschedule_interrupt();
> >  	trace_reschedule_exit(RESCHEDULE_VECTOR);
> > +	rcu_irq_exit();
> 
> The question is, should we add normal irq_enter/exit here? As that
> should be OK to nest. There's a comment in scheduler_ipi():
> 
> 	/*
> 	 * Not all reschedule IPI handlers call irq_enter/irq_exit, since
> 	 * traditionally all their work was done from the interrupt return
> 	 * path. Now that we actually do some work, we need to make sure
> 	 * we do call them.
> 	 *
> 	 * Some archs already do call them, luckily irq_enter/exit nest
> 	 * properly.
> 	 *
> 	 * Arguably we should visit all archs and update all handlers,
> 	 * however a fair share of IPIs are still resched only so this would
> 	 * somewhat pessimize the simple resched case.
> 	 */
> 
> just before it calls irq_enter(). Seems that not calling irq_enter() for
> the reschedule ipi interrupt is more of a legacy thing. It also states
> that its OK for an arch to call irq_enter() before calling this as it
> can nest. I wonder if we should invest time in fixing all archs and
> remove this irq_enter? But that's out of scope for this change.

That comment also states why I never did the arch sweep; doing
irq_enter()/irq_exit() for the pure empty reschedule interrupt makes it
more expensive.

Back when I introduced scheduler_ipi() I measured the amount of pure
resched interrupts (no schedule_ipi() content, pure interrupt return
path work) vs actually doing something in schedule_ipi() and found a
significant number of interrupts were 'pure'.

Things might have changed; but you'd better remeasure if you want to go
sweep the arch tree.
