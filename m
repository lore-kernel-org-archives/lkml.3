Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaKQNTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:19:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:7974 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaKQNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:19:42 -0500
Date: Mon, 17 Nov 2014 08:19:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: byungchul.park@lge.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v3 2/3] tracing, function_graph: add additional marks to
 signal very large function execution time
Message-ID: <20141117081940.667ee391@gandalf.local.home>
In-Reply-To: <1416184918-10471-3-git-send-email-byungchul.park@lge.com>
References: <1416184918-10471-1-git-send-email-byungchul.park@lge.com>
	<1416184918-10471-3-git-send-email-byungchul.park@lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014 09:41:57 +0900
byungchul.park@lge.com wrote:

> From: Byungchul Park <byungchul.park@lge.com>
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 385391f..d89868a 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -331,6 +331,25 @@ struct tracer_flags {
>  /* Makes more easy to define a tracer opt */
>  #define TRACER_OPT(s, b)	.name = #s, .bit = b
>  
> +/* trace overhead mark */
> +struct trace_mark {
> +	unsigned long long	val; /* unit: nsec */
> +	char			sym;
> +};
> +
> +#define MARK(v, s) {.val = v, .sym = s}
> +
> +static inline char trace_duration_mark(unsigned long long d,
> +				       const struct trace_mark m[],
> +				       int size)
> +{
> +	int idx = size;
> +
> +	if (size <= 0) return ' ';
> +	while (d <= m[--idx].val && idx > 0);
> +
> +	return m[idx].sym;
> +}
>  
>  /**
>   * struct tracer - a specific tracer and its callbacks to interact with debugfs
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index cb33f46..d9ac09f 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -797,6 +797,19 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
>  	return TRACE_TYPE_HANDLED;
>  }

Move the #define MARK() down to here (just before it is used). And add
a "#undef MARK" before it. You never know if some header file might
include a #define MARK somewhere.


>  
> +static const struct trace_mark mark[] = {
> +	MARK(0ULL		, ' '), /* 0 usecs */
> +	MARK(10000ULL		, '+'), /* 10 usecs */
> +	MARK(100000ULL		, '!'), /* 100 usecs */
> +	MARK(1000000ULL		, '#'), /* 1000 usecs */
> +	MARK(1000000000ULL	, '$'), /* 1 sec */
> +};

You can add a "#undef MARK" here too, just to let people know that you
are done with it. But this one is optional.

Thanks!

-- Steve


> +
> +static inline char find_trace_mark(unsigned long long d)
> +{
> +	return trace_duration_mark(d, mark, ARRAY_SIZE(mark));
> +}
> +

