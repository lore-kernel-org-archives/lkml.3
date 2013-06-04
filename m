Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3FDMQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:16:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3FDMQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:16:31 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ldwk5sxjx74A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=d1pqzc9q_nUA:10 a=pGLkceISAAAA:8 a=Q2wVtQmV3_NYaSgvCuIA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370348189.26799.117.camel@gandalf.local.home>
Subject: Re: [PATCH v2][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 04 Jun 2013 08:16:29 -0400
In-Reply-To: <20130604120949.GD14973@somewhere>
References: <1369943981.26799.43.camel@gandalf.local.home>
	 <20130531134319.GE5932@somewhere>
	 <1370013528.26799.49.camel@gandalf.local.home>
	 <20130531160101.GB5910@twins.programming.kicks-ass.net>
	 <1370050218.26799.87.camel@gandalf.local.home>
	 <20130604120949.GD14973@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 14:09 +0200, Frederic Weisbecker wrote:
>  
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
> > +void __sched notrace preempt_schedule_context(void)
> > +{
> > +	struct thread_info *ti = current_thread_info();
> > +	enum ctx_state prev_ctx;
> > +
> > +	if (likely(ti->preempt_count || irqs_disabled()))
> > +		return;
> 
> or:
>         if (!preemptible())
>                 return;

Sure, but this is a cut and paste from preempt_schedule(). If I make
that change here, I would want to make that there too.

Peter, should I use !preemptible() or keep it like preempt_schedule()
and make a clean up change for 3.11?

> 
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
> That's quite a tricky change but I can't think of anything better.

Yeah, I had a few other solutions that were even worse than this one.
Then I finally decided this was the best of the worse.

> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks,

-- Steve

> 
> 
> >  /**
> >   * user_exit - Inform the context tracking that the CPU is
> > -- 
> > 1.7.3.4
> > 
> > 
> > 


