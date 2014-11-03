Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaKCAvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 19:51:08 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60370 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaKCAvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 19:51:02 -0500
X-Original-SENDERIP: 10.177.222.33
X-Original-MAILFROM: byungchul.park@lge.com
Date: Mon, 3 Nov 2014 09:50:49 +0900
From: Byungchul Park <byungchul.park@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing, function_graph: add additional marks to
 signal very large function execution time
Message-ID: <20141103005049.GB3393@byungchulpark-X58A-UD3R>
References: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
 <1414052242-9828-3-git-send-email-byungchul.park@lge.com>
 <20141031130129.022b0bf3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031130129.022b0bf3@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 31, 2014 at 01:01:29PM -0400, Steven Rostedt wrote:
> On Thu, 23 Oct 2014 17:17:22 +0900
> byungchul.park@lge.com wrote:
> 
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
> > $ grep "!s" $LOGFILE
> >  3) !s22082032 us |                      } /* kernel_map_pages */
> >  3) !s22082040 us |                    } /* free_pages_prepare */
> >  3) !s22082113 us |                  } /* free_hot_cold_page */
> >  3) !s22083455 us |                } /* free_hot_cold_page_list */
> >  3) !s22083895 us |              } /* release_pages */
> >  3) !s22177873 us |            } /* free_pages_and_swap_cache */
> >  3) !s22178929 us |          } /* unmap_single_vma */
> >  3) !s22198885 us |        } /* unmap_vmas */
> >  3) !s22206949 us |      } /* exit_mmap */
> >  3) !s22207659 us |    } /* mmput */
> >  3) !s22207793 us |  } /* exit_mm */
> 
> Hmm, I wonder if a "s!" is better. Having the 's' next to the number
> seems to make it look like some strange number.

Yes, what you suggest looks better.

> 
> Maybe we should still keep this cryptic. We can update the
> debugfs/tracing/README to add the meanings as well.

I missed updating document, it should be done, and I will add it.

> 
> But perhaps have:
> 
>  + == > 10usec
>  ! == > 100usec
>  * == > 1msec
>  $ == > 1sec
> 

To be honest, this is what I did at first implementation and I changed it
to inform the scale like s(=second) or like m(=millisecond). Do you think
'+' '!' '*' '$' notation is better? :)

> 
> > 
> > And then, it was easy to find out that a schedule-out occured by
> > sub_preempt_count() within kernel_map_pages().
> > 
> > To detect very large function exection time either by problematic
> > function implementation or by scheduling issues, this patch can be
> > useful.
> > 
> > Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> > ---
> >  kernel/trace/trace_functions_graph.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> > index c18a1e3..ea8b7e7 100644
> > --- a/kernel/trace/trace_functions_graph.c
> > +++ b/kernel/trace/trace_functions_graph.c
> > @@ -822,8 +822,14 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
> >  
> >  	/* Signal a overhead of time execution to the output */
> >  	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
> > +		/* Duration exceeded 1 secs */
> > +		if (duration > 1000000000ULL)
> > +			ret = trace_seq_puts(s, "!s");
> > +		/* Duration exceeded 1 msecs */
> > +		else if (duration > 1000000ULL)
> > +			ret = trace_seq_puts(s, "!m");
> >  		/* Duration exceeded 100 usecs */
> > -		if (duration > 100000ULL)
> > +		else if (duration > 100000ULL)
> >  			ret = trace_seq_puts(s, "! ");
> >  		/* Duration exceeded 10 usecs */
> >  		else if (duration > 10000ULL)
> 
> also, the documentation in Documentation/trace/ftrace.txt must be
> updated with this patch. Make sure you update the function graph part
> and not the "time:" and "delay:" section.

OK. I will do it.

> 
> Come to think of it. Could you make another patch that adds this to the
> normal delay as well? And we should make the "normal" '+' mean 10usecs
> instead of 1usec. 1 is rather meaningless and inconsistent with the
> graph tracer.

Why not? I will try it.

Thanks,
Byungchul.

> 
> Thanks!
> 
> -- Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
