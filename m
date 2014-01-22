Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaAVUJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:09:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:37268 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753040AbaAVUJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:09:14 -0500
Date: Wed, 22 Jan 2014 15:09:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH] preempt: Debug for possible missed preemption
 checks
Message-ID: <20140122150907.75ed820b@gandalf.local.home>
In-Reply-To: <52E0205E.3090600@windriver.com>
References: <20140116235751.084728c8@gandalf.local.home>
	<52E0205E.3090600@windriver.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 14:47:42 -0500
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

 
> > +
> > +static void update_pied_state(enum pied_stat_type type, bool enable,
> > +			      unsigned long ip)
> > +{
> > +	struct stack_trace *trace;
> > +	int state, new_state;
> > +	unsigned long flags;
> > +
> > +	if (pied_failed)
> > +		return;
> > +
> > +	if (this_cpu_read(pied_recursive))
> > +		return;
> 
> Maybe I'm just missing something obvious, but it wasn't clear to me
> how or what the recursive check above would reliably protect against,
> when the increment is ~20 lines below and not a cmpxchg here.

It protects against interrupts.

You don't need cmpxchg to protect against interrupts. Think about it.
Even a simple "read/modify/write" works too. The key is, interrupts are
nested:

	read x = 1
	x = x + 1 (modified on stack)

	interrupt comes in.

		read x = 1 (everything is ok to continue our state)

		x = x + 1

		write x (x now equals 2)

		update the state

		read x = 2

		x = x - 1

		write x (x is back to 1)

		interrupt ends

	write x (x is now 2, just like it would be without the
		interrupt)

	read state (the state is what we expect it to be)

The only thing you need is a barrier to keep gcc from messing things
up, but the local_irq_save() does that for us.

Note, the bad state can't happen in an interrupt, but we keep track of
states in the interrupt because it makes it easier to compute. Too many
corner cases to ignore interrupts (I tried). But the interrupts that
happens inside this code are not those corner cases and we can ignore
(with the recursive flag).

-- Steve

> 
> Thanks,
> Paul.
> --
> 
> > +
> > +	/*
> > +	 * Boot up may start with interrupts and/or preemption
> > +	 * disabled. We can't start the state updates till
> > +	 * we have synced with the initial state.
> > +	 */
> > +	if (!this_cpu_read(pied_initialized)) {
> > +		/*
> > +		 * The first time we enable preemption with interrupts
> > +		 * enabled on a CPU, start the state transactions.
> > +		 */
> > +		if (!in_interrupt() && type == PIED_STATE_PREEMPT &&
> > +		    enable && !irqs_disabled())
> > +			this_cpu_write(pied_initialized, 1);
> > +		return;
> > +	}
> > +
> > +	if (type == PIED_STATE_INTERRUPT) {
> > +		if (enable == false) {
> > +			/* Ignore nested disabling of interrupts */
> > +			if (this_cpu_read(pied_irqsoff))
> > +				return;
> > +			this_cpu_write(pied_irqsoff, 1);
> > +		} else
> > +			this_cpu_write(pied_irqsoff, 0);
> > +	}
> > +
> > +	this_cpu_inc(pied_recursive);
> > +	raw_local_irq_save(flags);
> > +
> > +	state = this_cpu_read(current_pied_state);
> > +
> > +	switch (type) {
> > +	case PIED_STATE_PREEMPT:
> > +		new_state = pied_state_trans[state].preempt_change;
> > +		switch (new_state) {
> > +		case 0: case 1: case 6: case 7:
> > +			if (!enable)
> > +				pied_state_bug(type, enable, state, new_state);
> > +			break;
> > +		default:
> > +			if (enable)
> > +				pied_state_bug(type, enable, state, new_state);
> > +			break;
> > +		}
> > +		break;
> > +	case PIED_STATE_INTERRUPT:
> > +		new_state = pied_state_trans[state].interrupt_change;
> > +		switch (new_state) {
> > +		case 0: case 2: case 3: case 7:
> > +			if (!enable)
> > +				pied_state_bug(type, enable, state, new_state);
> > +			break;
> > +		default:
> > +			if (enable)
> > +				pied_state_bug(type, enable, state, new_state);
> > +			break;
> > +		}
> > +		break;
> > +	}
> > +
> > +	switch (new_state) {
> > +	case PIED_DANGEROUS_STATE:
> > +		/*
> > +		 * If we are in an interrupt, then we need to switch
> > +		 * to state 3 to prevent from going into state 5, 6 and 7.
> > +		 *
> > +		 * PDIEX ==> PDIE
> > +		 */
> > +		if (in_interrupt()) {
> > +			new_state = 3;
> > +			break;
> > +		}
> > +		trace = this_cpu_ptr(&pied_stack_trace);
> > +		trace->nr_entries = 0;
> > +		trace->max_entries = PIED_STACK_MAX;
> > +		trace->entries = this_cpu_ptr(pied_stack);
> > +
> > +		trace->skip = 3;
> > +
> > +		save_stack_trace(trace);
> > +
> > +		break;
> > +	case PIED_BAD_STATE:
> > +
> > +		/*
> > +		 * Interrupts themselves do not cause problems as they
> > +		 * always check NEED_RESCHED when going back to normal context.
> > +		 *
> > +		 * PEIEX ==> PEIE
> > +		 */
> > +		if (in_interrupt()) {
> > +			new_state = 0;
> > +			break;
> > +		}
> > +
> > +		lockdep_off();
> > +		pied_failed = true;
> > +		printk("\n");
> > +		printk("===============================\n");
> > +		printk("[INFO: preempt check hit problem state]\n");
> > +		print_irqtrace_events(current);
> > +		printk("Entered dangerous state at: \n");
> > +		print_stack_trace(this_cpu_ptr(&pied_stack_trace), 2); 
> > +		printk("\nstack backtrace:\n");
> > +		dump_stack();
> > +		print_pied_trail();
> > +		lockdep_on();
> > +		break;
> > +	}
> > +	this_cpu_write(current_pied_state, new_state);
> > +	update_pied_trail(new_state, ip, irqs_disabled_flags(flags));
> > +	raw_local_irq_restore(flags);
> > +	this_cpu_dec(pied_recursive);
> > +}
> > +
> > +void trace_preempt_on(unsigned long a0, unsigned long a1)
> > +{
> > +	time_preempt_on(a0, a1);
> > +	update_pied_state(PIED_STATE_PREEMPT, true, a0);
> > +}
> > +
> > +void trace_preempt_off(unsigned long a0, unsigned long a1)
> > +{
> > +	time_preempt_off(a0, a1);
> > +	update_pied_state(PIED_STATE_PREEMPT, false, a0);
> > +}
> > +#endif /* CONFIG_PREEMPT */
> > Index: linux-trace.git/kernel/sched/core.c
> > ===================================================================
> > --- linux-trace.git.orig/kernel/sched/core.c
> > +++ linux-trace.git/kernel/sched/core.c
> > @@ -2414,7 +2414,8 @@ void __kprobes preempt_count_add(int val
> >  	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
> >  				PREEMPT_MASK - 10);
> >  #endif
> > -	if (preempt_count() == val)
> > +	/* PREEMPT_ACTIVE gets set directly, it must be ignored */
> > +	if ((preempt_count() & ~PREEMPT_ACTIVE) == val)
> >  		trace_preempt_off(ip, parent_ip);
> >  }
> >  EXPORT_SYMBOL(preempt_count_add);
> > @@ -2435,7 +2436,8 @@ void __kprobes preempt_count_sub(int val
> >  		return;
> >  #endif
> >  
> > -	if (preempt_count() == val)
> > +	/* PREEMPT_ACTIVE gets set directly, it must be ignored */
> > +	if ((preempt_count() & ~PREEMPT_ACTIVE) == val)
> >  		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
> >  	__preempt_count_sub(val);
> >  }
> > Index: linux-trace.git/kernel/softirq.c
> > ===================================================================
> > --- linux-trace.git.orig/kernel/softirq.c
> > +++ linux-trace.git/kernel/softirq.c
> > @@ -111,7 +111,8 @@ static void __local_bh_disable(unsigned
> >  		trace_softirqs_off(ip);
> >  	raw_local_irq_restore(flags);
> >  
> > -	if (preempt_count() == cnt)
> > +	/* PREEMPT_ACTIVE gets set directly, it must be ignored */
> > +	if ((preempt_count() & ~PREEMPT_ACTIVE) == cnt)
> >  		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
> >  }
> >  #else /* !CONFIG_TRACE_IRQFLAGS */
> > Index: linux-trace.git/kernel/trace/trace_irqsoff.c
> > ===================================================================
> > --- linux-trace.git.orig/kernel/trace/trace_irqsoff.c
> > +++ linux-trace.git/kernel/trace/trace_irqsoff.c
> > @@ -516,13 +516,13 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller)
> >  #endif /*  CONFIG_IRQSOFF_TRACER */
> >  
> >  #ifdef CONFIG_PREEMPT_TRACER
> > -void trace_preempt_on(unsigned long a0, unsigned long a1)
> > +void time_preempt_on(unsigned long a0, unsigned long a1)
> >  {
> >  	if (preempt_trace() && !irq_trace())
> >  		stop_critical_timing(a0, a1);
> >  }
> >  
> > -void trace_preempt_off(unsigned long a0, unsigned long a1)
> > +void time_preempt_off(unsigned long a0, unsigned long a1)
> >  {
> >  	if (preempt_trace() && !irq_trace())
> >  		start_critical_timing(a0, a1);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 

