Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3JDP5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:57:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:12313 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754476Ab3JDP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:57:16 -0400
Date: Fri, 4 Oct 2013 11:57:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, lkp@linux.intel.com
Subject: Re: [PATCH] ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
Message-ID: <20131004115712.40c62743@gandalf.local.home>
In-Reply-To: <20131004152826.GP3081@twins.programming.kicks-ass.net>
References: <tip-7a7m5qqbn5pmwnd4wko9u6da@git.kernel.org>
	<20130927091427.GE24743@yliu-dev.sh.intel.com>
	<20130927152908.GE15690@laptop.programming.kicks-ass.net>
	<20131004080909.GP26785@twins.programming.kicks-ass.net>
	<20131004105342.20c00a41@gandalf.local.home>
	<20131004152826.GP3081@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Oct 2013 17:28:26 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Oct 04, 2013 at 10:53:42AM -0400, Steven Rostedt wrote:
> > In other words, what does these flags in the trace actually mean?
> > Probably need to add comments in the code and/or update the
> > Documentation section
> 
> If "task need resched" is supposed to explain things; the below too will
> suffice... muwhahaha!

Damn! You caught on. (/me fails to get Peter to explain my
documentation better)

> 
> ---
> Subject: ftrace, sched: Add TRACE_FLAG_PREEMPT_RESCHED
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri Sep 27 17:11:00 CEST 2013
> 
> Since the introduction of PREEMPT_NEED_RESCHED; see commit:
> f27dde8deef3 ("sched: Add NEED_RESCHED to the preempt_count") we need
> to be able to look at both TIF_NEED_RESCHED and PREEMPT_NEED_RESCHED
> to understand the full preemption behaviour. Add it to the trace
> output.

This is much better than your previous change log. At least now we have
a pointer to what to read to understand this change.

> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-1tys5rfpbpi7ky20b7msh4qy@git.kernel.org
> ---
>  Documentation/trace/ftrace.txt |    6 +++++-
>  kernel/trace/trace.c           |    3 ++-
>  kernel/trace/trace.h           |    1 +
>  kernel/trace/trace_output.c    |   13 +++++++++++--
>  4 files changed, 19 insertions(+), 4 deletions(-)
> 
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -655,7 +655,11 @@ explains which is which.
>  		  read the irq flags variable, an 'X' will always
>  		  be printed here.
>  
> -  need-resched: 'N' task need_resched is set, '.' otherwise.
> +  need-resched:
> +	'N' both TIF_NEED_RESCHED and PREEMPT_NEED_RESCHED is set,
> +	'n' only TIF_NEED_RESCHED is set,
> +	'p' only PREEMPT_NEED_RESCHED is set,
> +	'.' otherwise.

Yes this is actually good enough. I'll have to spend time to explain
this better. But I'll let you off the hook from doing it for me ;-)

>  
>    hardirq/softirq:
>  	'H' - hard irq occurred inside a softirq.
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1509,7 +1509,8 @@ tracing_generic_entry_update(struct trac
>  #endif
>  		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
>  		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
> -		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
> +		(tif_need_resched() ? TRACE_FLAG_NEED_RESCHED : 0) |
> +		(test_preempt_need_resched() ? TRACE_FLAG_PREEMPT_RESCHED : 0);
>  }
>  EXPORT_SYMBOL_GPL(tracing_generic_entry_update);
>  
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -124,6 +124,7 @@ enum trace_flag_type {
>  	TRACE_FLAG_NEED_RESCHED		= 0x04,
>  	TRACE_FLAG_HARDIRQ		= 0x08,
>  	TRACE_FLAG_SOFTIRQ		= 0x10,
> +	TRACE_FLAG_PREEMPT_RESCHED	= 0x20,

We'll have to update libtraceevent to handle this. I'm hoping it
doesn't barf on the new flag. I don't think it would, but I need to
look at that code to make sure.

>  };
>  
>  #define TRACE_BUF_SIZE		1024
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -618,8 +618,17 @@ int trace_print_lat_fmt(struct trace_seq
>  		(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
>  		(entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' :
>  		'.';
> -	need_resched =
> -		(entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.';
> +
> +	if ((entry->flags & TRACE_FLAG_NEED_RESCHED) &&
> +	    (entry->flags & TRACE_FLAG_PREEMPT_RESCHED))
> +		need_resched = 'N';
> +	else if (entry->flags & TRACE_FLAG_NEED_RESCHED)
> +		need_resched = 'n';
> +	else if (entry->flags & TRACE_FLAG_PREEMPT_RESCHED)
> +		need_resched = 'p';
> +	else
> +		need_resched = '.';
> +

We could optimize the above with:

	int ns;

	ns = entry->flags & (TRACE_FLAG_NEED_RESCHED |
		TRACE_FLAG_PREEMPT_RESCHED);

	switch (ns) {
		case 0:
			need_resched = '.';
			break;
		case TRACE_FLAG_NEED_RSCHED:
			need_resched = 'n';
			break;
		case TRACE_FLAG_PREEMPT_RESCHED:
			need_resched = 'p';
			break;
		case TRACE_FLAG_NEED_RESCHED |
				TRACE_FLAG_PREEMPT_RESCHED:
			need_resched = 'N';
			break;
	}

Not sure if the above is more readable or not, or if it is worth it.

-- Steve

>  	hardsoft_irq =
>  		(hardirq && softirq) ? 'H' :
>  		hardirq ? 'h' :

