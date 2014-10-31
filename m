Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaJaRBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:01:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:35223 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751211AbaJaRBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:01:31 -0400
Date: Fri, 31 Oct 2014 13:01:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: byungchul.park@lge.com
Cc: mingo@redhat.com, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing, function_graph: add additional marks to
 signal very large function execution time
Message-ID: <20141031130129.022b0bf3@gandalf.local.home>
In-Reply-To: <1414052242-9828-3-git-send-email-byungchul.park@lge.com>
References: <1414052242-9828-1-git-send-email-byungchul.park@lge.com>
	<1414052242-9828-3-git-send-email-byungchul.park@lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014 17:17:22 +0900
byungchul.park@lge.com wrote:

> From: Byungchul Park <byungchul.park@lge.com>
> 
> Currently, function graph tracer prints "!" or "+" just before
> function execution time to signal a function overhead, depending
> on the time. Even it is usually enough to do that, we sometimes
> need to be signaled for bigger execution time than 100 micro seconds.
> 
> For example, I used function graph tracer to detect if there is
> any case that exit_mm() takes too much time. I did following steps
> in /sys/kernel/debug/tracing. It was easier to detect very big
> excution time with patched kernel than with original kernel.
> 
> $ echo exit_mm > set_graph_function
> $ echo function_graph > current_tracer
> $ echo > trace
> $ cat trace_pipe > $LOGFILE
>  ... (do something and terminate logging)
> $ grep "!s" $LOGFILE
>  3) !s22082032 us |                      } /* kernel_map_pages */
>  3) !s22082040 us |                    } /* free_pages_prepare */
>  3) !s22082113 us |                  } /* free_hot_cold_page */
>  3) !s22083455 us |                } /* free_hot_cold_page_list */
>  3) !s22083895 us |              } /* release_pages */
>  3) !s22177873 us |            } /* free_pages_and_swap_cache */
>  3) !s22178929 us |          } /* unmap_single_vma */
>  3) !s22198885 us |        } /* unmap_vmas */
>  3) !s22206949 us |      } /* exit_mmap */
>  3) !s22207659 us |    } /* mmput */
>  3) !s22207793 us |  } /* exit_mm */

Hmm, I wonder if a "s!" is better. Having the 's' next to the number
seems to make it look like some strange number.

Maybe we should still keep this cryptic. We can update the
debugfs/tracing/README to add the meanings as well.

But perhaps have:

 + == > 10usec
 ! == > 100usec
 * == > 1msec
 $ == > 1sec


> 
> And then, it was easy to find out that a schedule-out occured by
> sub_preempt_count() within kernel_map_pages().
> 
> To detect very large function exection time either by problematic
> function implementation or by scheduling issues, this patch can be
> useful.
> 
> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
> ---
>  kernel/trace/trace_functions_graph.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index c18a1e3..ea8b7e7 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -822,8 +822,14 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
>  
>  	/* Signal a overhead of time execution to the output */
>  	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
> +		/* Duration exceeded 1 secs */
> +		if (duration > 1000000000ULL)
> +			ret = trace_seq_puts(s, "!s");
> +		/* Duration exceeded 1 msecs */
> +		else if (duration > 1000000ULL)
> +			ret = trace_seq_puts(s, "!m");
>  		/* Duration exceeded 100 usecs */
> -		if (duration > 100000ULL)
> +		else if (duration > 100000ULL)
>  			ret = trace_seq_puts(s, "! ");
>  		/* Duration exceeded 10 usecs */
>  		else if (duration > 10000ULL)

also, the documentation in Documentation/trace/ftrace.txt must be
updated with this patch. Make sure you update the function graph part
and not the "time:" and "delay:" section.

Come to think of it. Could you make another patch that adds this to the
normal delay as well? And we should make the "normal" '+' mean 10usecs
instead of 1usec. 1 is rather meaningless and inconsistent with the
graph tracer.

Thanks!

-- Steve
