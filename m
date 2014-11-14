Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935333AbaKNMwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:52:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:59909 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934994AbaKNMws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:52:48 -0500
Date: Fri, 14 Nov 2014 07:52:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 06/23 v4] tracing: Have function_graph use
 trace_seq_has_overflowed()
Message-ID: <20141114075209.5a358890@gandalf.local.home>
In-Reply-To: <20141114124126.GB2988@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
	<20141114011410.987913836@goodmis.org>
	<20141114124126.GB2988@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 13:41:26 +0100
Petr Mladek <pmladek@suse.cz> wrote:

  
> > -static enum print_line_t
> > +static void
> >  print_graph_irq(struct trace_iterator *iter, unsigned long addr,
> >  		enum trace_type type, int cpu, pid_t pid, u32 flags)
> >  {
> > -	int ret;
> >  	struct trace_seq *s = &iter->seq;
> >  
> >  	if (addr < (unsigned long)__irqentry_text_start ||
> >  		addr >= (unsigned long)__irqentry_text_end)
> > -		return TRACE_TYPE_UNHANDLED;
> > +		return;
> 
> I was curious if the TRACE_TYPE_UNHANDLED return value has any special
> effect. But it seems to be ignored. There are only two callers and
> they take care only of the PARTIAL_LINE return value.

Yep, I noticed that too, and did the same check before I made the
change. IIRC, that UNHANDLED was written in case anyone did care.

> 
> [...]
> 
> > @@ -953,62 +856,43 @@ print_graph_entry_nested(struct trace_iterator *iter,
> >  	return TRACE_TYPE_NO_CONSUME;
> >  }
> >  
> > -static enum print_line_t
> > +static void
> >  print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
> >  		     int type, unsigned long addr, u32 flags)
> >  {
> >  	struct fgraph_data *data = iter->private;
> >  	struct trace_entry *ent = iter->ent;
> >  	int cpu = iter->cpu;
> > -	int ret;
> >  
> >  	/* Pid */
> > -	if (verif_pid(s, ent->pid, cpu, data) == TRACE_TYPE_PARTIAL_LINE)
> > -		return TRACE_TYPE_PARTIAL_LINE;
> > +	verif_pid(s, ent->pid, cpu, data);
> >  
> > -	if (type) {
> > +	if (type)
> >  		/* Interrupt */
> > -		ret = print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
> > -		if (ret == TRACE_TYPE_PARTIAL_LINE)
> > -			return TRACE_TYPE_PARTIAL_LINE;
> > -	}
> > +		print_graph_irq(iter, addr, type, cpu, ent->pid, flags);
> >  
> >  	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
> > -		return 0;
> > +		return;
> >  
> >  	/* Absolute time */
> > -	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
> > -		ret = print_graph_abs_time(iter->ts, s);
> > -		if (!ret)
> > -			return TRACE_TYPE_PARTIAL_LINE;
> > -	}
> > +	if (flags & TRACE_GRAPH_PRINT_ABS_TIME)
> > +		print_graph_abs_time(iter->ts, s);
> >  
> >  	/* Cpu */
> > -	if (flags & TRACE_GRAPH_PRINT_CPU) {
> > -		ret = print_graph_cpu(s, cpu);
> > -		if (ret == TRACE_TYPE_PARTIAL_LINE)
> > -			return TRACE_TYPE_PARTIAL_LINE;
> > -	}
> > +	if (flags & TRACE_GRAPH_PRINT_CPU)
> > +		print_graph_cpu(s, cpu);
> >  
> >  	/* Proc */
> >  	if (flags & TRACE_GRAPH_PRINT_PROC) {
> > -		ret = print_graph_proc(s, ent->pid);
> > -		if (ret == TRACE_TYPE_PARTIAL_LINE)
> > -			return TRACE_TYPE_PARTIAL_LINE;
> > -
> > -		ret = trace_seq_puts(s, " | ");
> > -		if (!ret)
> > -			return TRACE_TYPE_PARTIAL_LINE;
> > +		print_graph_proc(s, ent->pid);
> > +		trace_seq_puts(s, " | ");
> >  	}
> >  
> >  	/* Latency format */
> > -	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
> > -		ret = print_graph_lat_fmt(s, ent);
> > -		if (ret == TRACE_TYPE_PARTIAL_LINE)
> > -			return TRACE_TYPE_PARTIAL_LINE;
> > -	}
> > +	if (trace_flags & TRACE_ITER_LATENCY_FMT)
> > +		print_graph_lat_fmt(s, ent);
> >  
> > -	return 0;
> > +	return;
> 
> This probably even fixed a bug. The function returned
> TRACE_TYPE_PARTIAL_LINE (0) even when it did not print anything.
> 
> The simplification is really cool.

Thanks,

-- Steve

> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>
> 
> Best Regards,
> Petr Mladek

