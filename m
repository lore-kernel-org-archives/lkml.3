Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaKRAcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:32:43 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:36470 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaKRAcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:32:42 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 10/23 v4] tracing/uprobes: Do not use return values of trace_seq_printf()
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.693008134@goodmis.org> <54662133.4060405@hitachi.com>
	<20141114103733.03ffc40b@gandalf.local.home>
	<20141114131429.52b9345b@gandalf.local.home>
Date: Tue, 18 Nov 2014 09:32:37 +0900
In-Reply-To: <20141114131429.52b9345b@gandalf.local.home> (Steven Rostedt's
	message of "Fri, 14 Nov 2014 13:14:29 -0500")
Message-ID: <87mw7ps5zu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 13:14:29 -0500, Steven Rostedt wrote:
> Here's the new patch:
>
> -- Steve
>
> From cd883b4c2d5d68ec598d6c6a3b5dce4dd99a4cc1 Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Wed, 12 Nov 2014 17:26:57 -0500
> Subject: [PATCH] tracing/uprobes: Do not use return values of
>  trace_seq_printf()
>
> The functions trace_seq_printf() and friends will soon no longer have
> return values. Using trace_seq_has_overflowed() and trace_handle_return()
> should be used instead.
>
> Link: http://lkml.kernel.org/r/20141114011411.693008134@goodmis.org
>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> ---
>  kernel/trace/trace_uprobe.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index e35327c787f7..fd76f8e108ef 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -852,16 +852,14 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
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
> @@ -869,14 +867,13 @@ print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *e
>  		struct probe_arg *parg = &tu->tp.args[i];
>  
>  		if (!parg->type->print(s, parg->name, data + parg->offset, entry))
> -			goto partial;
> +			goto out;
>  	}
>  
> -	if (trace_seq_putc(s, '\n'))
> -		return TRACE_TYPE_HANDLED;
> +	trace_seq_putc(s, '\n');
>  
> -partial:
> -	return TRACE_TYPE_PARTIAL_LINE;
> + out:
> +	return trace_handle_return(s);
>  }
>  
>  typedef bool (*filter_func_t)(struct uprobe_consumer *self,
