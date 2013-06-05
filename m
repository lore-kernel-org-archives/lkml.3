Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3FENlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:41:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3FENlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:41:50 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ldwk5sxjx74A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=d1pqzc9q_nUA:10 a=1-I0of2uQAiTad8UejAA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370439709.9844.17.camel@gandalf.local.home>
Subject: Re: [PATCH v2][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Wed, 05 Jun 2013 09:41:49 -0400
In-Reply-To: <20130605114559.GE8923@twins.programming.kicks-ass.net>
References: <1369943981.26799.43.camel@gandalf.local.home>
	 <20130531134319.GE5932@somewhere>
	 <1370013528.26799.49.camel@gandalf.local.home>
	 <20130531160101.GB5910@twins.programming.kicks-ass.net>
	 <1370050218.26799.87.camel@gandalf.local.home>
	 <20130604122712.GE14973@somewhere>
	 <1370355416.26799.119.camel@gandalf.local.home>
	 <20130605114559.GE8923@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 13:45 +0200, Peter Zijlstra wrote:
> On Tue, Jun 04, 2013 at 10:16:56AM -0400, Steven Rostedt wrote:
> > index 65349f0..73b89d9 100644
> > --- a/kernel/context_tracking.c
> > +++ b/kernel/context_tracking.c
> > @@ -71,6 +71,46 @@ void user_enter(void)
> >  	local_irq_restore(flags);
> >  }
> >  
> > +#ifdef CONFIG_PREEMPT
> > +/**
> > + * preempt_schedule_context - preempt_schedule called by tracing
> > + *
> > + * The tracing infrastructure uses preempt_enable_notrace to prevent
> > + * recursion and tracing preempt enabling caused by the tracing
> > + * infrastructure itself. But as tracing can happen in areas coming
> > + * from userspace or just about to enter userspace, a preempt enable
> > + * can occur before user_exit() is called. This will cause the scheduler
> > + * to be called when the system is still in usermode.
> > + *
> > + * To prevent this, the preempt_enable_notrace will use this function
> > + * instead of preempt_schedule() to exit user context if needed before
> > + * calling the scheduler.
> > + */
> 
> If preempt_enable_notrace() is the only user, why does this live in
> kernel/context_tracking.c and not in kernel/sched/core.c?

Then we would need to add #ifdef CONFIG_CONTEXT_TRACKING around it too.
As we have in preempt.h:

#ifdef CONFIG_CONTEXT_TRACKING

void preempt_schedule_context(void);

#define preempt_check_resched_context() \
do { \
	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
		preempt_schedule_context(); \
} while(0)
#else

#define preempt_check_resched_context() preempt_check_resched()

#endif

Seemed like it was more appropriate to be in context_tracking.c than
sched/core.c, as it depends on context tracking.

> 
> > +void __sched notrace preempt_schedule_context(void)
> > +{
> > +	struct thread_info *ti = current_thread_info();
> > +	enum ctx_state prev_ctx;
> > +
> > +	if (likely(ti->preempt_count || irqs_disabled()))
> > +		return;
> > +
> > +	/*
> > +	 * Need to disable preemption in case user_exit() is traced
> > +	 * and the tracer calls preempt_enable_notrace() causing
> > +	 * an infinite recursion.
> > +	 */
> > +	preempt_disable_notrace();
> > +	prev_ctx = exception_enter();
> > +	preempt_enable_no_resched_notrace();
> > +
> > +	preempt_schedule();
> > +
> > +	preempt_disable_notrace();
> > +	exception_exit(prev_ctx);
> > +	preempt_enable_notrace();
> > +}
> > +EXPORT_SYMBOL(preempt_schedule_context);
> 
> Do we really need to export this?

As preempt_enable_notrace() is also used by tracepoints, yes. Because
tracepoints are used by modules. Hmm, now it may be exported via a GPL
export though.

-- Steve


> 
> > +#endif /* CONFIG_PREEMPT */
> >  
> >  /**
> >   * user_exit - Inform the context tracking that the CPU is
> > -- 
> > 1.7.10.4
> > 
> > 
> > 


