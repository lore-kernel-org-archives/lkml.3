Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161112AbaKNPfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:35:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53299 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965729AbaKNPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:35:22 -0500
Message-ID: <54662133.4060405@hitachi.com>
Date: Sat, 15 Nov 2014 00:35:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 10/23 v4] tracing/uprobes: Do not use return values
 of trace_seq_printf()
References: <20141114011244.256115061@goodmis.org> <20141114011411.693008134@goodmis.org>
In-Reply-To: <20141114011411.693008134@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/14 10:12), Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The functions trace_seq_printf() and friends will soon no longer have
> return values. Using trace_seq_has_overflowed() and trace_handle_return()
> should be used instead.
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_uprobe.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 33ff6a24b802..bd6007b13b52 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -852,31 +852,26 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
>  	tu = container_of(event, struct trace_uprobe, tp.call.event);
>  
>  	if (is_ret_probe(tu)) {
> -		if (!trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
> -					ftrace_event_name(&tu->tp.call),
> -					entry->vaddr[1], entry->vaddr[0]))
> -			goto partial;
> +		trace_seq_printf(s, "%s: (0x%lx <- 0x%lx)",
> +				 ftrace_event_name(&tu->tp.call),
> +				 entry->vaddr[1], entry->vaddr[0]);
>  		data = DATAOF_TRACE_ENTRY(entry, true);
>  	} else {
> -		if (!trace_seq_printf(s, "%s: (0x%lx)",
> -					ftrace_event_name(&tu->tp.call),
> -					entry->vaddr[0]))
> -			goto partial;
> +		trace_seq_printf(s, "%s: (0x%lx)",
> +				 ftrace_event_name(&tu->tp.call),
> +				 entry->vaddr[0]);
>  		data = DATAOF_TRACE_ENTRY(entry, false);
>  	}
>  
>  	for (i = 0; i < tu->tp.nr_args; i++) {
>  		struct probe_arg *parg = &tu->tp.args[i];
>  
> -		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
> -			goto partial;
> +		parg->type->print(s, parg->name, data + parg->offset, entry);

In 7/23 you've left loop canceling path, why don't you do same thing here?

Thank you,

>  	}
>  
> -	if (trace_seq_puts(s, "\n"))
> -		return TRACE_TYPE_HANDLED;
> +	trace_seq_puts(s, "\n");
>  
> -partial:
> -	return TRACE_TYPE_PARTIAL_LINE;
> +	return trace_handle_return(s);
>  }
>  
>  typedef bool (*filter_func_t)(struct uprobe_consumer *self,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


