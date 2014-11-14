Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbaKNDiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:38:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:7204 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934141AbaKNDiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:38:07 -0500
Date: Thu, 13 Nov 2014 22:38:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: byungchul.park@lge.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v2 3/3] tracing: add additional marks to signal very
 large delay
Message-ID: <20141113223801.367a5f33@gandalf.local.home>
In-Reply-To: <1415171926-9782-4-git-send-email-byungchul.park@lge.com>
References: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
	<1415171926-9782-4-git-send-email-byungchul.park@lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Nov 2014 16:18:46 +0900
byungchul.park@lge.com wrote:

> -static unsigned long preempt_mark_thresh_us = 100;
> +DEFINE_MARK_STRUCT = {
> +	DEFINE_MARK(0ULL		, ' '), /* 0 usecs */
> +	DEFINE_MARK(10000ULL		, '+'), /* 10 usecs */
> +	DEFINE_MARK(100000ULL		, '!'), /* 100 usecs */
> +	DEFINE_MARK(1000000ULL		, '#'), /* 1000 usecs */
> +	DEFINE_MARK(1000000000ULL	, '$'), /* 1 sec */
> +};

OK, I see why you did the macro magic here. But it's still obfuscates
the code.

Instead of having that find_trace_mark() be a static function, just
make it defined in trace_output.c that function_graph calls. This code
is used for outputting to userspace and a function call is not going to
be noticed.

As it would now be a global function (although only defined in
kernel/trace), we need to make the name a bit more specific. Instead of
calling it find_trace_mark(), call it trace_duration_mark().

-- Steve

>  
>  static int
>  lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
> @@ -506,8 +512,7 @@ lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
>  		return trace_seq_printf(
>  				s, " %4lldus%c: ",
>  				abs_ts,
> -				rel_ts > preempt_mark_thresh_us ? '!' :
> -				  rel_ts > 1 ? '+' : ' ');
> +				MARK(rel_ts * NSEC_PER_USEC));
>  	} else { /* !verbose && !in_ns */
>  		return trace_seq_printf(s, " %4lld: ", abs_ts);
>  	}
> @@ -692,7 +697,7 @@ int register_ftrace_event(struct trace_event *event)
>  				goto out;
>  
>  		} else {
> -			
> +
>  			event->type = next_event_type++;
>  			list = &ftrace_event_list;
>  		}

