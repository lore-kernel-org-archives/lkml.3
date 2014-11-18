Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaKRAtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:49:16 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59064 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaKRAtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:49:15 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 11/23 v4] tracing: Do not use return values of trace_seq_printf() in syscall tracing
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.842421346@goodmis.org>
Date: Tue, 18 Nov 2014 09:49:12 +0900
In-Reply-To: <20141114011411.842421346@goodmis.org> (Steven Rostedt's message
	of "Thu, 13 Nov 2014 20:12:55 -0500")
Message-ID: <87ioids587.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 20:12:55 -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> The functions trace_seq_printf() and friends will not be returning values
> soon and will be void functions. To know if they succeeded or not, the
> functions trace_seq_has_overflowed() and trace_handle_return() should be
> used instead.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_syscalls.c | 43 +++++++++++++++----------------------------
>  1 file changed, 15 insertions(+), 28 deletions(-)
>
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 4dc8b79c5f75..2193e8038681 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -114,7 +114,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
>  	struct trace_entry *ent = iter->ent;
>  	struct syscall_trace_enter *trace;
>  	struct syscall_metadata *entry;
> -	int i, ret, syscall;
> +	int i, syscall;
>  
>  	trace = (typeof(trace))ent;
>  	syscall = trace->nr;
> @@ -128,35 +128,24 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
>  		goto end;
>  	}
>  
> -	ret = trace_seq_printf(s, "%s(", entry->name);
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> +	trace_seq_printf(s, "%s(", entry->name);
>  
>  	for (i = 0; i < entry->nb_args; i++) {

		if (trace_seq_has_overflowed())
			goto end;
?

Thanks,
Namhyung


>  		/* parameter types */
> -		if (trace_flags & TRACE_ITER_VERBOSE) {
> -			ret = trace_seq_printf(s, "%s ", entry->types[i]);
> -			if (!ret)
> -				return TRACE_TYPE_PARTIAL_LINE;
> -		}
> +		if (trace_flags & TRACE_ITER_VERBOSE)
> +			trace_seq_printf(s, "%s ", entry->types[i]);
> +
>  		/* parameter values */
> -		ret = trace_seq_printf(s, "%s: %lx%s", entry->args[i],
> -				       trace->args[i],
> -				       i == entry->nb_args - 1 ? "" : ", ");
> -		if (!ret)
> -			return TRACE_TYPE_PARTIAL_LINE;
> +		trace_seq_printf(s, "%s: %lx%s", entry->args[i],
> +				 trace->args[i],
> +				 i == entry->nb_args - 1 ? "" : ", ");
>  	}
>  
> -	ret = trace_seq_putc(s, ')');
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> -
> +	trace_seq_putc(s, ')');
>  end:
> -	ret =  trace_seq_putc(s, '\n');
> -	if (!ret)
> -		return TRACE_TYPE_PARTIAL_LINE;
> +	trace_seq_putc(s, '\n');
>  
> -	return TRACE_TYPE_HANDLED;
> +	return trace_handle_return(s);
>  }
