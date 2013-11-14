Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3KNQDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:03:40 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39991 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3KNQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:03:34 -0500
Date: Thu, 14 Nov 2013 17:03:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131114160319.GB4399@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131114152304.GC5364@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114152304.GC5364@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 04:23:04PM +0100, Peter Zijlstra wrote:
> On Sat, Nov 09, 2013 at 04:10:14PM +0100, Peter Zijlstra wrote:
> > Cute.. so what appears to happen is that:
> > 
> > 1) we trace irq_work_exit
> > 2) we generate event
> > 3) event needs to deliver signal
> > 4) we queue irq_work to send signal
> > 5) goto 1
> 
> ---
>  arch/x86/include/asm/trace/irq_vectors.h | 11 +++++++++++
>  include/linux/ftrace_event.h             | 16 ++++++++++++++++
>  include/linux/tracepoint.h               |  4 ++++
>  include/trace/ftrace.h                   |  7 +++++++
>  kernel/trace/trace_event_perf.c          |  6 ++++++
>  5 files changed, 44 insertions(+)
> 
> diff --git a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
> index 2874df24e7a4..4cab890007a7 100644
> --- a/arch/x86/include/asm/trace/irq_vectors.h
> +++ b/arch/x86/include/asm/trace/irq_vectors.h
> @@ -72,6 +72,17 @@ DEFINE_IRQ_VECTOR_EVENT(x86_platform_ipi);
>  DEFINE_IRQ_VECTOR_EVENT(irq_work);
>  
>  /*
> + * We must dis-allow sampling irq_work_exit() because perf event sampling
> + * itself can cause irq_work, which would lead to an infinite loop;
> + *
> + *  1) irq_work_exit happens
> + *  2) generates perf sample
> + *  3) generates irq_work
> + *  4) goto 1
> + */
> +TRACE_EVENT_PERF_PERM(irq_work_exit, is_sampling_event(p_event) ? -EPERM : 0);
> +
> +/*
>   * call_function - called when entering/exiting a call function interrupt
>   * vector handler
>   */
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 5eaa746735ff..3e4d05566022 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -244,6 +244,9 @@ struct ftrace_event_call {
>  #ifdef CONFIG_PERF_EVENTS
>  	int				perf_refcount;
>  	struct hlist_head __percpu	*perf_events;
> +
> +	int	(*perf_perm)(struct ftrace_event_call *,
> +			     struct perf_event *);
>  #endif
>  };
>  
> @@ -306,6 +309,19 @@ struct ftrace_event_file {
>  	}								\
>  	early_initcall(trace_init_flags_##name);
>  
> +#define __TRACE_EVENT_PERF_PERM(name, expr)				\
> +	static int perf_perm_##name(struct ftrace_event_call *tp_event, \
> +				    struct perf_event *p_event)		\
> +	{								\
> +		return expr;						\
> +	}								\
> +	static int __init trace_init_flags_##name(void)			\
> +	{								\
> +		event_##name.perf_perm = &perf_perm_##name;		\
> +		return 0;						\
> +	}								\
> +	early_initcall(trace_init_flags_##name);
> +
>  #define PERF_MAX_TRACE_SIZE	2048
>  
>  #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index ebeab360d851..dd5cb1dca207 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -267,6 +267,8 @@ static inline void tracepoint_synchronize_unregister(void)
>  
>  #define TRACE_EVENT_FLAGS(event, flag)
>  
> +#define TRACE_EVENT_PERF_PERM(event, expr)
> +
>  #endif /* DECLARE_TRACE */
>  
>  #ifndef TRACE_EVENT
> @@ -399,4 +401,6 @@ static inline void tracepoint_synchronize_unregister(void)
>  
>  #define TRACE_EVENT_FLAGS(event, flag)
>  
> +#define TRACE_EVENT_PERF_PERM(event, expr)
> +
>  #endif /* ifdef TRACE_EVENT (see note above) */
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 5c7ab17cbb02..7bdda40fc406 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -90,6 +90,10 @@
>  #define TRACE_EVENT_FLAGS(name, value)					\
>  	__TRACE_EVENT_FLAGS(name, value)
>  
> +#undef TRACE_EVENT_PERF_PERM
> +#define TRACE_EVENT_PERF_PERM(name, expr)				\
> +	__TRACE_EVENT_PERF_PERM(name, expr)
> +
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>  
>  
> @@ -140,6 +144,9 @@
>  #undef TRACE_EVENT_FLAGS
>  #define TRACE_EVENT_FLAGS(event, flag)
>  
> +#undef TRACE_EVENT_PERF_PERM
> +#define TRACE_EVENT_PERF_PERM(event, expr)
> +
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>  
>  /*
> diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> index 78e27e3b52ac..630889f68b1d 100644
> --- a/kernel/trace/trace_event_perf.c
> +++ b/kernel/trace/trace_event_perf.c
> @@ -24,6 +24,12 @@ static int	total_ref_count;
>  static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
>  				 struct perf_event *p_event)
>  {
> +	if (tp_event->perf_perm) {
> +		int ret = tp_event->perf_perm(tp_event, p_event);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	/* The ftrace function trace is allowed only for root. */
>  	if (ftrace_event_is_function(tp_event) &&
>  	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))

Looks good, I can't think of a more general solution.

Now thinking about kprobes, which can be used to reproduce this same kind of
scenario when put in the right place, perhaps we need to do something in perf_swevent_overflow()
which reject events once they cross a dangerous amount which we arbitrary define on top
of what looks like a storm that can trigger a lockup.
