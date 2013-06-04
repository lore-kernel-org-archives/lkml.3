Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3FDM1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 08:27:19 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:42976 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3FDM1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 08:27:17 -0400
Date: Tue, 4 Jun 2013 14:27:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2][RFC] tracing/context-tracking: Add
 preempt_schedule_context() for tracing
Message-ID: <20130604122712.GE14973@somewhere>
References: <1369943981.26799.43.camel@gandalf.local.home>
 <20130531134319.GE5932@somewhere>
 <1370013528.26799.49.camel@gandalf.local.home>
 <20130531160101.GB5910@twins.programming.kicks-ass.net>
 <1370050218.26799.87.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370050218.26799.87.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 09:30:18PM -0400, Steven Rostedt wrote:
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index 65349f0..15c9f2e 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -71,6 +71,44 @@ void user_enter(void)
>  	local_irq_restore(flags);
>  }
>  
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
> +void __sched notrace preempt_schedule_context(void)

Should it be under CONFIG_PREEMPT?

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
>  
>  /**
>   * user_exit - Inform the context tracking that the CPU is
> -- 
> 1.7.3.4
> 
> 
> 
