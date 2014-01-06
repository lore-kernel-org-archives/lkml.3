Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaAFBQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:16:37 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45632 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaAFBQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:16:36 -0500
Message-ID: <52CA03EB.6020107@hitachi.com>
Date: Mon, 06 Jan 2014 10:16:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/kprobes: Add trace event trigger invocations
References: <1388283848.3048.1.camel@empanada>
In-Reply-To: <1388283848.3048.1.camel@empanada>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/29 11:24), Tom Zanussi wrote:
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

Looks good for me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> ---
>  kernel/trace/trace_kprobe.c | 42 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index dae9541..1ee13eb 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -812,12 +812,20 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
>  	struct ring_buffer *buffer;
>  	int size, dsize, pc;
>  	unsigned long irq_flags;
> +	unsigned long eflags;
> +	enum event_trigger_type __tt = ETT_NONE;
>  	struct ftrace_event_call *call = &tp->call;
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
> @@ -835,9 +843,16 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
>  	entry->ip = (unsigned long)tp->rp.kp.addr;
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
>  
> -	if (!filter_check_discard(ftrace_file, entry, buffer, event))
> +	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
> +		__tt = event_triggers_call(ftrace_file, entry);
> +
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> +		ring_buffer_discard_commit(buffer, event);
> +	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
>  		trace_buffer_unlock_commit_regs(buffer, event,
>  						irq_flags, pc, regs);
> +	if (__tt)
> +		event_triggers_post_call(ftrace_file, __tt);
>  }
>  
>  static __kprobes void
> @@ -860,12 +875,20 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	struct ring_buffer *buffer;
>  	int size, pc, dsize;
>  	unsigned long irq_flags;
> +	unsigned long eflags;
> +	enum event_trigger_type __tt = ETT_NONE;
>  	struct ftrace_event_call *call = &tp->call;
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
> @@ -884,9 +907,16 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	entry->ret_ip = (unsigned long)ri->ret_addr;
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
>  
> -	if (!filter_check_discard(ftrace_file, entry, buffer, event))
> +	if (eflags & FTRACE_EVENT_FL_TRIGGER_COND)
> +		__tt = event_triggers_call(ftrace_file, entry);
> +
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> +		ring_buffer_discard_commit(buffer, event);
> +	else if (!filter_check_discard(ftrace_file, entry, buffer, event))
>  		trace_buffer_unlock_commit_regs(buffer, event,
>  						irq_flags, pc, regs);
> +	if (__tt)
> +		event_triggers_post_call(ftrace_file, __tt);
>  }
>  
>  static __kprobes void
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


