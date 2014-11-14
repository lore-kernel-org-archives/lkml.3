Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbaKNDc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:32:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:21277 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934913AbaKNDcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:32:25 -0500
Date: Thu, 13 Nov 2014 22:32:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: byungchul.park@lge.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v2 2/3] tracing, function_graph: add additional marks to
 signal very large function execution time
Message-ID: <20141113223206.04912862@gandalf.local.home>
In-Reply-To: <1415171926-9782-3-git-send-email-byungchul.park@lge.com>
References: <1415171926-9782-1-git-send-email-byungchul.park@lge.com>
	<1415171926-9782-3-git-send-email-byungchul.park@lge.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Nov 2014 16:18:45 +0900
byungchul.park@lge.com wrote:
  
> +/* trace overhead mark */
> +struct trace_mark {
> +	unsigned long long val; /* unit: nsec */
> +	char sym;
> +};

Please format the above to:

struct trace_mark {
	unsigned long long		val;
	char				sym;
};

> +
> +#define DEFINE_MARK_STRUCT static const struct trace_mark mark[]

Why is this a macro?

> +#define DEFINE_MARK(v, s) {.val = v, .sym = s}
> +#define MARK(d) 							\
> +({									\
> +	int i = ARRAY_SIZE(mark);					\
> +	while ((unsigned long long)(d) <= mark[--i].val && i > 0);	\
> +	mark[i].sym;							\
> +})

Why is this a macro and not a static inline?

static inline char find_trace_mark(unsigned long long duration)
{
	int i = ARRAY_SIZE(mark);

	while (duration <= mark[--i].val && i > 0)
		;

	return make[i]. sym;
}

That's much more readable.

>  
>  /**
>   * struct tracer - a specific tracer and its callbacks to interact with debugfs
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index cb33f46..8a62907 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -797,6 +797,14 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
>  	return TRACE_TYPE_HANDLED;
>  }
>  
> +DEFINE_MARK_STRUCT = {
> +	DEFINE_MARK(0ULL		, ' '), /* 0 usecs */
> +	DEFINE_MARK(10000ULL		, '+'), /* 10 usecs */
> +	DEFINE_MARK(100000ULL		, '!'), /* 100 usecs */
> +	DEFINE_MARK(1000000ULL		, '#'), /* 1000 usecs */
> +	DEFINE_MARK(1000000000ULL	, '$'), /* 1 sec */
> +};

Don't need to use a name as big as DEFINE_MARK. Just have:

#undef MARK
#define MARK(v, s) { .val = v, .sym = s }

struct trace_mark mark[] = {
	MARK(0ULL			, ' '), /* 0 usecs */
[...]
};

With the define directly above the call, we don't need need to be that
descriptive.

> +
>  static enum print_line_t
>  print_graph_duration(unsigned long long duration, struct trace_seq *s,
>  		     u32 flags)
> @@ -822,12 +830,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
>  
>  	/* Signal a overhead of time execution to the output */
>  	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
> -		/* Duration exceeded 100 usecs */
> -		if (duration > 100000ULL)
> -			ret = trace_seq_puts(s, "! ");
> -		/* Duration exceeded 10 usecs */
> -		else if (duration > 10000ULL)
> -			ret = trace_seq_puts(s, "+ ");
> +		ret = trace_seq_printf(s, "%c ", MARK(duration));

Then this could just be:

		ret = trace_seq_printf(s, "%c ",
				       find_trace_mark(duration));

-- Steve

>  	}
>  
>  	/*

