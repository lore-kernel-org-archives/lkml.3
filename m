Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaKNGTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:19:00 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49544 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaKNGS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:18:59 -0500
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date: Fri, 14 Nov 2014 15:18:36 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v2 2/3] tracing, function_graph: add additional marks to
 signal very large function execution time
Message-ID: <20141114061836.GJ3393@byungchulpark-X58A-UD3R>
References: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
 <1415171926-9782-3-git-send-email-byungchul.park@lge.com>
 <20141113223206.04912862@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113223206.04912862@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 13, 2014 at 10:32:06PM -0500, Steven Rostedt wrote:
> On Wed,  5 Nov 2014 16:18:45 +0900
> byungchul.park@lge.com wrote:
>   
> > +/* trace overhead mark */
> > +struct trace_mark {
> > +	unsigned long long val; /* unit: nsec */
> > +	char sym;
> > +};
> 
> Please format the above to:
> 
> struct trace_mark {
> 	unsigned long long		val;
> 	char				sym;
> };

Thank you, I will do it.

> 
> > +
> > +#define DEFINE_MARK_STRUCT static const struct trace_mark mark[]
> 
> Why is this a macro?

Because I want to hide the 'mark' variable so that user dont need to know it.
If this macro wouldn't be used, the function or macro to find and get a symbol
must know what the variable is. And I didnt want to take an additional arg
'mark' to the function or macro.

I will explicitly define the variable 'mark' in the c file and use it in
the function to find and get a corresponding symbol, if it would be ok.

> 
> > +#define DEFINE_MARK(v, s) {.val = v, .sym = s}
> > +#define MARK(d) 							\
> > +({									\
> > +	int i = ARRAY_SIZE(mark);					\
> > +	while ((unsigned long long)(d) <= mark[--i].val && i > 0);	\
> > +	mark[i].sym;							\
> > +})
> 
> Why is this a macro and not a static inline?

I wanted to couple static data 'mark' and macro 'MARK' only in .h and 
abstract its details. But I will move it to .c explicitly if it looks better.

> 
> static inline char find_trace_mark(unsigned long long duration)
> {
> 	int i = ARRAY_SIZE(mark);
> 
> 	while (duration <= mark[--i].val && i > 0)
> 		;
> 
> 	return make[i]. sym;
> }
> 
> That's much more readable.
> 
> >  
> >  /**
> >   * struct tracer - a specific tracer and its callbacks to interact with debugfs
> > diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> > index cb33f46..8a62907 100644
> > --- a/kernel/trace/trace_functions_graph.c
> > +++ b/kernel/trace/trace_functions_graph.c
> > @@ -797,6 +797,14 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
> >  	return TRACE_TYPE_HANDLED;
> >  }
> >  
> > +DEFINE_MARK_STRUCT = {
> > +	DEFINE_MARK(0ULL		, ' '), /* 0 usecs */
> > +	DEFINE_MARK(10000ULL		, '+'), /* 10 usecs */
> > +	DEFINE_MARK(100000ULL		, '!'), /* 100 usecs */
> > +	DEFINE_MARK(1000000ULL		, '#'), /* 1000 usecs */
> > +	DEFINE_MARK(1000000000ULL	, '$'), /* 1 sec */
> > +};
> 
> Don't need to use a name as big as DEFINE_MARK. Just have:
> 
> #undef MARK
> #define MARK(v, s) { .val = v, .sym = s }
> 

Thank you, I will do it.

> struct trace_mark mark[] = {
> 	MARK(0ULL			, ' '), /* 0 usecs */
> [...]
> };
> 
> With the define directly above the call, we don't need need to be that
> descriptive.
> 

I still wonder if it's better to define 'mark' explicitly in .c. Anyway
I'll fix it. :)

> > +
> >  static enum print_line_t
> >  print_graph_duration(unsigned long long duration, struct trace_seq *s,
> >  		     u32 flags)
> > @@ -822,12 +830,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
> >  
> >  	/* Signal a overhead of time execution to the output */
> >  	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
> > -		/* Duration exceeded 100 usecs */
> > -		if (duration > 100000ULL)
> > -			ret = trace_seq_puts(s, "! ");
> > -		/* Duration exceeded 10 usecs */
> > -		else if (duration > 10000ULL)
> > -			ret = trace_seq_puts(s, "+ ");
> > +		ret = trace_seq_printf(s, "%c ", MARK(duration));
> 
> Then this could just be:
> 
> 		ret = trace_seq_printf(s, "%c ",
> 				       find_trace_mark(duration));
> 

Thank you very much for your kindness!

> -- Steve
> 
> >  	}
> >  
> >  	/*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
