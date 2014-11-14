Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184AbaKNLZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:25:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934404AbaKNLZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:25:32 -0500
Date: Fri, 14 Nov 2014 12:25:23 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 02/23 v4] tracing: Add trace_seq_has_overflowed()
 and trace_handle_return()
Message-ID: <20141114112522.GA2988@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
 <20141114011410.365183157@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114011410.365183157@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 20:12:46, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Adding a trace_seq_has_overflowed() which returns true if the trace_seq
> had too much written into it allows us to simplify the code.
> 
> Instead of checking the return value of every call to trace_seq_printf()
> and friends, they can all be called normally, and at the end we can
> return !trace_seq_has_overflowed() instead.
> 
> Several functions also return TRACE_TYPE_PARTIAL_LINE when the trace_seq
> overflowed and TRACE_TYPE_HANDLED otherwise. Another helper function
> was created called trace_handle_return() which takes a trace_seq and
> returns these enums. Using this helper function also simplifies the
> code.
> 
> This change also makes it possible to remove the return values of
> trace_seq_printf() and friends. They should instead just be
> void functions.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h |  11 ++
>  include/linux/trace_seq.h    |  12 ++
>  include/trace/ftrace.h       |   6 +-
>  kernel/trace/trace.c         |  69 +++----
>  kernel/trace/trace.h         |   1 +
>  kernel/trace/trace_output.c  | 416 +++++++++++++++++--------------------------
>  kernel/trace/trace_output.h  |  16 +-
>  7 files changed, 231 insertions(+), 300 deletions(-)

[...]

> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index cfa91de22e27..163c11b6b8ff 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
[...]
> @@ -193,7 +184,6 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
>  	struct trace_seq *s = &iter->seq;
>  	struct trace_seq *p = &iter->tmp_seq;
>  	struct trace_entry *entry;
> -	int ret;
>  
>  	event = container_of(trace_event, struct ftrace_event_call, event);
>  	entry = iter->ent;
> @@ -204,8 +194,9 @@ int ftrace_raw_output_prep(struct trace_iterator *iter,
>  	}
>  
>  	trace_seq_init(p);
> -	ret = trace_seq_printf(s, "%s: ", ftrace_event_name(event));
> -	if (!ret)
> +	trace_seq_printf(s, "%s: ", ftrace_event_name(event));
> +
> +	if (trace_seq_has_overflowed(s))
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	return 0;

This looks like a bug in the original code. It returns 0 in each case
because TRACE_TYPE_PARTIAL_LINE == 0. I guess that the last three
lines should get replaced by

	return trace_handle_return(s);

as it is done in the other functions.

[...]

> @@ -320,14 +302,14 @@ int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
>  		if (file) {
>  			ret = trace_seq_path(s, &file->f_path);
>  			if (ret)

I think that we could ignore the return value from trace_seq_path() as
well. The other trace_seq*() writes will be NOP if there is an
overflow.

Or do you have some special plans with trace_seq_path(), please?

> -				ret = trace_seq_printf(s, "[+0x%lx]",
> -						       ip - vmstart);
> +				trace_seq_printf(s, "[+0x%lx]",
> +						 ip - vmstart);
>  		}
>  		up_read(&mm->mmap_sem);
>  	}
>  	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
> -		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
> -	return ret;
> +		trace_seq_printf(s, " <" IP_FMT ">", ip);
> +	return !trace_seq_has_overflowed(s);
>  }

The wrong return value was there even before. The other problem is
just another optimization. Feel free to solve them later in another
patch(set).

I really like the simplification.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
