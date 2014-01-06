Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaAFV4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:56:34 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34085 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbaAFV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:56:32 -0500
Message-ID: <52CB2688.6020001@hitachi.com>
Date: Tue, 07 Jan 2014 06:56:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2 v2] tracing/kprobes: Add trace event trigger invocations
References: <cover.1389036657.git.tom.zanussi@linux.intel.com> <f2d49f157b608070045fdb26c9564d5a05a5a7d0.1389036657.git.tom.zanussi@linux.intel.com>
In-Reply-To: <f2d49f157b608070045fdb26c9564d5a05a5a7d0.1389036657.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/07 4:44), Tom Zanussi wrote:
> Add code to the kprobe/kretprobe event functions that will invoke any
> event triggers associated with a probe's ftrace_event_file.
> 
> The code to do this is very similar to the invocation code already
> used to invoke the triggers associated with static events and
> essentially replaces the existing soft-disable checks with a superset
> that preserves the original behavior but adds the bits needed to
> support event triggers.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>

Looks good for me :) BTW, we'll need similar code for trace_uprobe.c too.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> ---
>  kernel/trace/trace_kprobe.c | 42 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index ce0ed8a..3afa716 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -929,12 +929,20 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
>  	struct ring_buffer *buffer;
>  	int size, dsize, pc;
>  	unsigned long irq_flags;
> +	unsigned long eflags;
> +	enum event_trigger_type tt = ETT_NONE;
>  	struct ftrace_event_call *call = &tk->tp.call;
>  
>  	WARN_ON(call != ftrace_file->event_call);
>  
> -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> -		return;
> +	eflags = ftrace_file->flags;
> +
> +	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
> +		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
> +			event_triggers_call(ftrace_file, NULL);
> +		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
> +			return;
> +	}
>  
>  	local_save_flags(irq_flags);
>  	pc = preempt_count();
> @@ -952,9 +960,16 @@ __kprobe_trace_func(struct trace_kprobe *tk, struct pt_regs *regs,
>  	entry->ip = (unsigned long)tk->rp.kp.addr;
>  	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
>  
> -	if (!filter_check_discard(ftrace_file, entry, buffer, event))
> +	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
> +		tt = event_triggers_call(ftrace_file, entry);
> +
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> +		ring_buffer_discard_commit(buffer, event);
> +	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
>  		trace_buffer_unlock_commit_regs(buffer, event,
>  						irq_flags, pc, regs);
> +	if (tt)
> +		event_triggers_post_call(ftrace_file, tt);
>  }
>  
>  static __kprobes void
> @@ -977,12 +992,20 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
>  	struct ring_buffer *buffer;
>  	int size, pc, dsize;
>  	unsigned long irq_flags;
> +	unsigned long eflags;
> +	enum event_trigger_type tt = ETT_NONE;
>  	struct ftrace_event_call *call = &tk->tp.call;
>  
>  	WARN_ON(call != ftrace_file->event_call);
>  
> -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> -		return;
> +	eflags = ftrace_file->flags;
> +
> +	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
> +		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
> +			event_triggers_call(ftrace_file, NULL);
> +		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
> +			return;
> +	}
>  
>  	local_save_flags(irq_flags);
>  	pc = preempt_count();
> @@ -1001,9 +1024,16 @@ __kretprobe_trace_func(struct trace_kprobe *tk, struct kretprobe_instance *ri,
>  	entry->ret_ip = (unsigned long)ri->ret_addr;
>  	store_trace_args(sizeof(*entry), &tk->tp, regs, (u8 *)&entry[1], dsize);
>  
> -	if (!filter_check_discard(ftrace_file, entry, buffer, event))
> +	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
> +		tt = event_triggers_call(ftrace_file, entry);
> +
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> +		ring_buffer_discard_commit(buffer, event);
> +	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
>  		trace_buffer_unlock_commit_regs(buffer, event,
>  						irq_flags, pc, regs);
> +	if (tt)
> +		event_triggers_post_call(ftrace_file, tt);
>  }
>  
>  static __kprobes void
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


