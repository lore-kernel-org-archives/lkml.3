Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3FELqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:46:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3FELqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:46:10 -0400
Date: Wed, 5 Jun 2013 13:45:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
Message-ID: <20130605114559.GE8923@twins.programming.kicks-ass.net>
References: <1369943981.26799.43.camel@gandalf.local.home>
 <20130531134319.GE5932@somewhere>
 <1370013528.26799.49.camel@gandalf.local.home>
 <20130531160101.GB5910@twins.programming.kicks-ass.net>
 <1370050218.26799.87.camel@gandalf.local.home>
 <20130604122712.GE14973@somewhere>
 <1370355416.26799.119.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370355416.26799.119.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 10:16:56AM -0400, Steven Rostedt wrote:
> index 65349f0..73b89d9 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -71,6 +71,46 @@ void user_enter(void)
>  	local_irq_restore(flags);
>  }
>  
> +#ifdef CONFIG_PREEMPT
> +/**
> + * preempt_schedule_context - preempt_schedule called by tracing
> + *
> + * The tracing infrastructure uses preempt_enable_notrace to prevent
> + * recursion and tracing preempt enabling caused by the tracing
> + * infrastructure itself. But as tracing can happen in areas coming
> + * from userspace or just about to enter userspace, a preempt enable
> + * can occur before user_exit() is called. This will cause the scheduler
> + * to be called when the system is still in usermode.
> + *
> + * To prevent this, the preempt_enable_notrace will use this function
> + * instead of preempt_schedule() to exit user context if needed before
> + * calling the scheduler.
> + */

If preempt_enable_notrace() is the only user, why does this live in
kernel/context_tracking.c and not in kernel/sched/core.c?

> +void __sched notrace preempt_schedule_context(void)
> +{
> +	struct thread_info *ti = current_thread_info();
> +	enum ctx_state prev_ctx;
> +
> +	if (likely(ti->preempt_count || irqs_disabled()))
> +		return;
> +
> +	/*
> +	 * Need to disable preemption in case user_exit() is traced
> +	 * and the tracer calls preempt_enable_notrace() causing
> +	 * an infinite recursion.
> +	 */
> +	preempt_disable_notrace();
> +	prev_ctx = exception_enter();
> +	preempt_enable_no_resched_notrace();
> +
> +	preempt_schedule();
> +
> +	preempt_disable_notrace();
> +	exception_exit(prev_ctx);
> +	preempt_enable_notrace();
> +}
> +EXPORT_SYMBOL(preempt_schedule_context);

Do we really need to export this?

> +#endif /* CONFIG_PREEMPT */
>  
>  /**
>   * user_exit - Inform the context tracking that the CPU is
> -- 
> 1.7.10.4
> 
> 
> 
