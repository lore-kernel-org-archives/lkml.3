Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329AbaKNMlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:41:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934994AbaKNMle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:41:34 -0500
Date: Fri, 14 Nov 2014 13:41:26 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 06/23 v4] tracing: Have function_graph use
 trace_seq_has_overflowed()
Message-ID: <20141114124126.GB2988@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
 <20141114011410.987913836@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114011410.987913836@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 20:12:50, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Instead of doing individual checks all over the place that makes the code
> very messy. Just check trace_seq_has_overflowed() at the end or in
> strategic places.
> 
> This makes the code much cleaner and also helps with getting closer
> to removing the return values of trace_seq_printf() and friends.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.h                 |   2 +-
>  kernel/trace/trace_functions_graph.c | 374 +++++++++++------------------------
>  2 files changed, 116 insertions(+), 260 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 19418221b302..c3a37e55ec8b 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -726,7 +726,7 @@ extern unsigned long trace_flags;
>  extern enum print_line_t
>  print_graph_function_flags(struct trace_iterator *iter, u32 flags);
>  extern void print_graph_headers_flags(struct seq_file *s, u32 flags);
> -extern enum print_line_t
> +extern void
>  trace_print_graph_duration(unsigned long long duration, struct trace_seq *s);
>  extern void graph_trace_open(struct trace_iterator *iter);
>  extern void graph_trace_close(struct trace_iterator *iter);
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index f0a0c982cde3..477a7c65cf08 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
[...]
> @@ -682,94 +639,69 @@ get_return_for_leaf(struct trace_iterator *iter,
>  	return next;
>  }
>  
> -static int print_graph_abs_time(u64 t, struct trace_seq *s)
> +static void print_graph_abs_time(u64 t, struct trace_seq *s)
>  {
>  	unsigned long usecs_rem;
>  
>  	usecs_rem = do_div(t, NSEC_PER_SEC);
>  	usecs_rem /= 1000;
>  
> -	return trace_seq_printf(s, "%5lu.%06lu |  ",
> -			(unsigned long)t, usecs_rem);
> +	trace_seq_printf(s, "%5lu.%06lu |  ",
> +			 (unsigned long)t, usecs_rem);
>  }
>  
> -static enum print_line_t
> +static void
>  print_graph_irq(struct trace_iterator *iter, unsigned long addr,
>  		enum trace_type type, int cpu, pid_t pid, u32 flags)
>  {
> -	int ret;
>  	struct trace_seq *s = &iter->seq;
>  
>  	if (addr < (unsigned long)__irqentry_text_start ||
>  		addr >= (unsigned long)__irqentry_text_end)
> -		return TRACE_TYPE_UNHANDLED;
> +		return;

I was curious if the TRACE_TYPE_UNHANDLED return value has any special
effect. But it seems to be ignored. There are only two callers and
they take care only of the PARTIAL_LINE return value.

[...]

> @@ -953,62 +856,43 @@ print_graph_entry_nested(struct trace_iterator *iter,
>  	return TRACE_TYPE_NO_CONSUME;
>  }
>  
> -static enum print_line_t
> +static void
>  print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
>  		     int type, unsigned long addr, u32 flags)
>  {
>  	struct fgraph_data *data = iter->private;
>  	struct trace_entry *ent = iter->ent;
>  	int cpu = iter->cpu;
> -	int ret;
>  
>  	/* Pid */
> -	if (verif_pid(s, ent->pid, cpu, data) == TRACE_TYPE_PARTIAL_LINE)
> -		return TRACE_TYPE_PARTIAL_LINE;
> +	verif_pid(s, ent->pid, cpu, data);
>  
> -	if (type) {
> +	if (type)
>  		/* Interrupt */
> -		ret = print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
> -		if (ret == TRACE_TYPE_PARTIAL_LINE)
> -			return TRACE_TYPE_PARTIAL_LINE;
> -	}
> +		print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
>  
>  	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
> -		return 0;
> +		return;
>  
>  	/* Absolute time */
> -	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
> -		ret = print_graph_abs_time(iter->ts, s);
> -		if (!ret)
> -			return TRACE_TYPE_PARTIAL_LINE;
> -	}
> +	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
> +		print_graph_abs_time(iter->ts, s);
>  
>  	/* Cpu */
> -	if (flags & TRACE_GRAPH_PRINT_CPU) {
> -		ret = print_graph_cpu(s, cpu);
> -		if (ret == TRACE_TYPE_PARTIAL_LINE)
> -			return TRACE_TYPE_PARTIAL_LINE;
> -	}
> +	if (flags & TRACE_GRAPH_PRINT_CPU)
> +		print_graph_cpu(s, cpu);
>  
>  	/* Proc */
>  	if (flags & TRACE_GRAPH_PRINT_PROC) {
> -		ret = print_graph_proc(s, ent->pid);
> -		if (ret == TRACE_TYPE_PARTIAL_LINE)
> -			return TRACE_TYPE_PARTIAL_LINE;
> -
> -		ret = trace_seq_puts(s, " | ");
> -		if (!ret)
> -			return TRACE_TYPE_PARTIAL_LINE;
> +		print_graph_proc(s, ent->pid);
> +		trace_seq_puts(s, " | ");
>  	}
>  
>  	/* Latency format */
> -	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
> -		ret = print_graph_lat_fmt(s, ent);
> -		if (ret == TRACE_TYPE_PARTIAL_LINE)
> -			return TRACE_TYPE_PARTIAL_LINE;
> -	}
> +	if (trace_flags & TRACE_ITER_LATENCY_FMT)
> +		print_graph_lat_fmt(s, ent);
>  
> -	return 0;
> +	return;

This probably even fixed a bug. The function returned
TRACE_TYPE_PARTIAL_LINE (0) even when it did not print anything.

The simplification is really cool.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr Mladek
