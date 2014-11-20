Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaKTATA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 19:19:00 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40587 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbaKTAS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 19:18:58 -0500
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date: Thu, 20 Nov 2014 09:18:30 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v4 3/3] tracing: add additional marks to signal very
 large delay
Message-ID: <20141120001830.GA27177@byungchulpark-X58A-UD3R>
References: <1416290246-882-1-git-send-email-byungchul.park@lge.com>
 <1416290246-882-4-git-send-email-byungchul.park@lge.com>
 <20141119133515.1caa293e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119133515.1caa293e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 01:35:15PM -0500, Steven Rostedt wrote:
> On Tue, 18 Nov 2014 14:57:26 +0900
> byungchul.park@lge.com wrote:
> 
> > From: Byungchul Park <byungchul.park@lge.com>
> > 
> > Currently, some tracers tracing latency print "!" or "+" just after time
> > to signal overhead, depending on the interval between events. Even it is
> > usually enough to do that, we sometimes need to be signaled for bigger
> > interval than 100 micro seconds.
> > 
> > Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> > ---
> >  Documentation/trace/ftrace.txt |    8 +++++---
> >  kernel/trace/trace_output.c    |   23 ++++++++++++++++++-----
> >  2 files changed, 23 insertions(+), 8 deletions(-)
> > 
> > diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> > index f827e2f..64efb3e 100644
> > --- a/Documentation/trace/ftrace.txt
> > +++ b/Documentation/trace/ftrace.txt
> > @@ -680,9 +680,11 @@ The above is mostly meaningful for kernel developers.
> >  	 needs to be fixed to be only relative to the same CPU.
> >  	 The marks are determined by the difference between this
> >  	 current trace and the next trace.
> > -	  '!' - greater than preempt_mark_thresh (default 100)
> > -	  '+' - greater than 1 microsecond
> > -	  ' ' - less than or equal to 1 microsecond.
> > +	  '$' - greater than 1 second
> > +	  '#' - greater than 1000 microsecond
> > +	  '!' - greater than 100 microsecond
> > +	  '+' - greater than 10 microsecond
> > +	  ' ' - less than or equal to 10 microsecond.
> >  
> >    The rest is the same as the 'trace' file.
> >  
> > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > index c6977d5..3fd3017 100644
> > --- a/kernel/trace/trace_output.c
> > +++ b/kernel/trace/trace_output.c
> > @@ -124,7 +124,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
> >  
> >  	if (ret == (const char *)(trace_seq_buffer_ptr(p)))
> >  		trace_seq_printf(p, "0x%lx", val);
> > -		
> > +
> >  	trace_seq_putc(p, 0);
> >  
> >  	return ret;
> > @@ -471,7 +471,21 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
> >  	return trace_print_lat_fmt(s, entry);
> >  }
> >  
> > -static unsigned long preempt_mark_thresh_us = 100;
> > +#undef MARK
> > +#define MARK(v, s) {.val = v, .sym = s}
> > +static const struct trace_mark mark[] = {
> > +	MARK(1000000000ULL	, '$'), /* 1 sec */
> > +	MARK(1000000ULL		, '#'), /* 1000 usecs */
> > +	MARK(100000ULL		, '!'), /* 100 usecs */
> > +	MARK(10000ULL		, '+'), /* 10 usecs */
> > +	MARK(0ULL		, ' '), /* 0 usecs */
> > +};
> > +#undef MARK
> > +
> > +static inline char find_trace_mark(unsigned long long d)
> > +{
> > +	return trace_duration_mark(d, mark, ARRAY_SIZE(mark));
> > +}
> 
> This is the exact same code as in function_graph tracer. Nuke the one
> from function graph and make this one a non static function, and have
> function graph tracer use it. trace_output.c is always compiled with
> tracing.
> 
> In fact, remove all the code from trace.h, and move it here. Just
> have this function be global and rename it to:
> 
>  trace_find_mark()
> 
> -- Steve

OK. I will do that.

Thank you,
BYungchul

> 
> 
> >  
> >  static int
> >  lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
> > @@ -506,8 +520,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
> >  		return trace_seq_printf(
> >  				s, " %4lldus%c: ",
> >  				abs_ts,
> > -				rel_ts > preempt_mark_thresh_us ? '!' :
> > -				  rel_ts > 1 ? '+' : ' ');
> > +				find_trace_mark(rel_ts * NSEC_PER_USEC));
> >  	} else { /* !verbose && !in_ns */
> >  		return trace_seq_printf(s, " %4lld: ", abs_ts);
> >  	}
> > @@ -692,7 +705,7 @@ int register_ftrace_event(struct trace_event *event)
> >  				goto out;
> >  
> >  		} else {
> > -			
> > +
> >  			event->type = next_event_type++;
> >  			list = &ftrace_event_list;
> >  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
