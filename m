Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462AbaKNOwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:52:13 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48949 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341AbaKNOwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:52:06 -0500
Message-ID: <5466170E.4020601@hitachi.com>
Date: Fri, 14 Nov 2014 23:51:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 07/23 v4] kprobes/tracing: Use trace_seq_has_overflowed()
 for overflow checks
References: <20141114011244.256115061@goodmis.org> <20141114011411.181812785@goodmis.org>
In-Reply-To: <20141114011411.181812785@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/14 10:12), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Instead of checking the return value of trace_seq_printf() and friends
> for overflowing of the buffer, use the trace_seq_has_overflowed() helper
> function.
> 
> This cleans up the code quite a bit and also takes us a step closer to
> changing the return values of trace_seq_printf() and friends to void.

Looks good to me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_kprobe.c | 42 ++++++++++++++++--------------------------
>  1 file changed, 16 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 282f6e4e5539..be14b2f091c8 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1024,27 +1024,22 @@ print_kprobe_event(struct trace_iterator *iter, int flags,
>  	field = (struct kprobe_trace_entry_head *)iter->ent;
>  	tp = container_of(event, struct trace_probe, call.event);
>  
> -	if (!trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call)))
> -		goto partial;
> +	trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call));
>  
>  	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
> -		goto partial;
> +		goto out;
>  
> -	if (!trace_seq_puts(s, ")"))
> -		goto partial;
> +	trace_seq_puts(s, ")");
>  
>  	data = (u8 *)&field[1];
>  	for (i = 0; i < tp->nr_args; i++)
>  		if (!tp->args[i].type->print(s, tp->args[i].name,
>  					     data + tp->args[i].offset, field))
> -			goto partial;
> -
> -	if (!trace_seq_puts(s, "\n"))
> -		goto partial;
> +			goto out;
>  
> -	return TRACE_TYPE_HANDLED;
> -partial:
> -	return TRACE_TYPE_PARTIAL_LINE;
> +	trace_seq_puts(s, "\n");
> + out:
> +	return trace_handle_return(s);
>  }
>  
>  static enum print_line_t
> @@ -1060,33 +1055,28 @@ print_kretprobe_event(struct trace_iterator *iter, int flags,
>  	field = (struct kretprobe_trace_entry_head *)iter->ent;
>  	tp = container_of(event, struct trace_probe, call.event);
>  
> -	if (!trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call)))
> -		goto partial;
> +	trace_seq_printf(s, "%s: (", ftrace_event_name(&tp->call));
>  
>  	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
> -		goto partial;
> +		goto out;
>  
> -	if (!trace_seq_puts(s, " <- "))
> -		goto partial;
> +	trace_seq_puts(s, " <- ");
>  
>  	if (!seq_print_ip_sym(s, field->func, flags & ~TRACE_ITER_SYM_OFFSET))
> -		goto partial;
> +		goto out;
>  
> -	if (!trace_seq_puts(s, ")"))
> -		goto partial;
> +	trace_seq_puts(s, ")");
>  
>  	data = (u8 *)&field[1];
>  	for (i = 0; i < tp->nr_args; i++)
>  		if (!tp->args[i].type->print(s, tp->args[i].name,
>  					     data + tp->args[i].offset, field))
> -			goto partial;
> +			goto out;
>  
> -	if (!trace_seq_puts(s, "\n"))
> -		goto partial;
> +	trace_seq_puts(s, "\n");
>  
> -	return TRACE_TYPE_HANDLED;
> -partial:
> -	return TRACE_TYPE_PARTIAL_LINE;
> + out:
> +	return trace_handle_return(s);
>  }
>  
>  


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


