Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaKQIL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:11:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59503 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaKQIL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:11:56 -0500
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date: Mon, 17 Nov 2014 17:11:30 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        seungho1.park@lge.com, jolsa@redhat.com
Subject: Re: [PATCH v3 2/3] tracing, function_graph: add additional marks to
 signal very large function execution time
Message-ID: <20141117081130.GA5360@byungchulpark-X58A-UD3R>
References: <1416184918-10471-1-git-send-email-byungchul.park@lge.com>
 <1416184918-10471-3-git-send-email-byungchul.park@lge.com>
 <87y4ras1gi.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y4ras1gi.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung, :)

On Mon, Nov 17, 2014 at 04:58:21PM +0900, Namhyung Kim wrote:
> Hi Byungchul,
> 
> On Mon, 17 Nov 2014 09:41:57 +0900, byungchul park wrote:
> > From: Byungchul Park <byungchul.park@lge.com>
> >
> > Currently, function graph tracer prints "!" or "+" just before
> > function execution time to signal a function overhead, depending
> > on the time. Even it is usually enough to do that, we sometimes
> > need to be signaled for bigger execution time than 100 micro seconds.
> >
> > For example, I used function graph tracer to detect if there is
> > any case that exit_mm() takes too much time. I did following steps
> > in /sys/kernel/debug/tracing. It was easier to detect very big
> > excution time with patched kernel than with original kernel.
> >
> > $ echo exit_mm > set_graph_function
> > $ echo function_graph > current_tracer
> > $ echo > trace
> > $ cat trace_pipe > $LOGFILE
> >  ... (do something and terminate logging)
> > $ grep "\\$" $LOGFILE
> >  3) $ 22082032 us |                      } /* kernel_map_pages */
> >  3) $ 22082040 us |                    } /* free_pages_prepare */
> >  3) $ 22082113 us |                  } /* free_hot_cold_page */
> >  3) $ 22083455 us |                } /* free_hot_cold_page_list */
> >  3) $ 22083895 us |              } /* release_pages */
> >  3) $ 22177873 us |            } /* free_pages_and_swap_cache */
> >  3) $ 22178929 us |          } /* unmap_single_vma */
> >  3) $ 22198885 us |        } /* unmap_vmas */
> >  3) $ 22206949 us |      } /* exit_mmap */
> >  3) $ 22207659 us |    } /* mmput */
> >  3) $ 22207793 us |  } /* exit_mm */
> >
> > And then, it was easy to find out that a schedule-out occured by
> > sub_preempt_count() within kernel_map_pages().
> >
> > To detect very large function exection time caused by either problematic
> > function implementation or scheduling issues, this patch can be useful.
> >
> > Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> > ---
> >  Documentation/trace/ftrace.txt       |    2 ++
> >  kernel/trace/trace.h                 |   19 +++++++++++++++++++
> >  kernel/trace/trace_functions_graph.c |   20 ++++++++++++++------
> >  3 files changed, 35 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> > index 4da4261..f827e2f 100644
> > --- a/Documentation/trace/ftrace.txt
> > +++ b/Documentation/trace/ftrace.txt
> > @@ -1951,6 +1951,8 @@ want, depending on your needs.
> >  
> >    + means that the function exceeded 10 usecs.
> >    ! means that the function exceeded 100 usecs.
> > +  # means that the function exceeded 1000 usecs.
> > +  $ means that the function exceeded 1 sec.
> >  
> >  
> >  - The task/pid field displays the thread cmdline and pid which
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 385391f..d89868a 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -331,6 +331,25 @@ struct tracer_flags {
> >  /* Makes more easy to define a tracer opt */
> >  #define TRACER_OPT(s, b)	.name = #s, .bit = b
> >  
> > +/* trace overhead mark */
> > +struct trace_mark {
> > +	unsigned long long	val; /* unit: nsec */
> > +	char			sym;
> > +};
> > +
> > +#define MARK(v, s) {.val = v, .sym = s}
> > +
> > +static inline char trace_duration_mark(unsigned long long d,
> > +				       const struct trace_mark m[],
> > +				       int size)
> > +{
> > +	int idx = size;
> > +
> > +	if (size <= 0) return ' ';
> > +	while (d <= m[--idx].val && idx > 0);
> > +
> > +	return m[idx].sym;
> > +}
> 
> I think it'd be simpler if you arrange the mark array in an opposity
> order:
> 
> static const struct trace_mark mark[] = {
> 	MARK(1000000000ULL	, '$'), /* 1 sec */
> 	MARK(1000000ULL		, '#'), /* 1000 usecs */
> 	MARK(100000ULL		, '!'), /* 100 usecs */
> 	MARK(10000ULL		, '+'), /* 10 usecs */
> 	MARK(0ULL		, ' '), /* 0 usecs */
> };
> 
> static inline char trace_duration_mark(unsigned long long d,
> 				       const struct trace_mark m[],
> 				       int size)
> {
> 	int i;
> 
> 	for (i = 0; i < size; i++) {
> 		if (d >= m[i].val)
> 			break;
> 	}
> 
> 	return m[i].sym;
> }
> 

Thank you for commenting.
It looks better.
I need to fix it.

Thanks,
Byungchul.

> Thanks,
> Namhyung
> 
> 
> >  
> >  /**
> >   * struct tracer - a specific tracer and its callbacks to interact with debugfs
> > diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> > index cb33f46..d9ac09f 100644
> > --- a/kernel/trace/trace_functions_graph.c
> > +++ b/kernel/trace/trace_functions_graph.c
> > @@ -797,6 +797,19 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
> >  	return TRACE_TYPE_HANDLED;
> >  }
> >  
> > +static const struct trace_mark mark[] = {
> > +	MARK(0ULL		, ' '), /* 0 usecs */
> > +	MARK(10000ULL		, '+'), /* 10 usecs */
> > +	MARK(100000ULL		, '!'), /* 100 usecs */
> > +	MARK(1000000ULL		, '#'), /* 1000 usecs */
> > +	MARK(1000000000ULL	, '$'), /* 1 sec */
> > +};
> > +
> > +static inline char find_trace_mark(unsigned long long d)
> > +{
> > +	return trace_duration_mark(d, mark, ARRAY_SIZE(mark));
> > +}
> > +
> >  static enum print_line_t
> >  print_graph_duration(unsigned long long duration, struct trace_seq *s,
> >  		     u32 flags)
> > @@ -822,12 +835,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
> >  
> >  	/* Signal a overhead of time execution to the output */
> >  	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
> > -		/* Duration exceeded 100 usecs */
> > -		if (duration > 100000ULL)
> > -			ret = trace_seq_puts(s, "! ");
> > -		/* Duration exceeded 10 usecs */
> > -		else if (duration > 10000ULL)
> > -			ret = trace_seq_puts(s, "+ ");
> > +		ret = trace_seq_printf(s, "%c ", find_trace_mark(duration));
> >  	}
> >  
> >  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
