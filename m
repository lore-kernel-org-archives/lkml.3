Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3FUESK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:18:10 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52586 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3FUESI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:18:08 -0400
Message-ID: <51C3D3FD.2070408@hitachi.com>
Date: Fri, 21 Jun 2013 13:18:05 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] tracing: add and use generic set_trigger_filter()
 implementation
References: <cover.1371751701.git.tom.zanussi@linux.intel.com> <8fe2c1ceb63a6375b56f046de835742f18b955ce.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <8fe2c1ceb63a6375b56f046de835742f18b955ce.1371751701.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/21 3:31), Tom Zanussi wrote:
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 88ac7da..7c5627f 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -522,14 +522,6 @@ ftrace_raw_event_##call(void *__data, proto)				\
>  	int __data_size;						\
>  	int pc;								\
>  									\
> -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> -		     &ftrace_file->flags))				\
> -		event_triggers_call(ftrace_file);			\
> -									\
> -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
> -		     &ftrace_file->flags))				\
> -		return;							\
> -									\
>  	local_save_flags(irq_flags);					\
>  	pc = preempt_count();						\
>  									\
> @@ -547,8 +539,22 @@ ftrace_raw_event_##call(void *__data, proto)				\
>  									\
>  	{ assign; }							\
>  									\
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
> +		     &ftrace_file->flags)) {				\
> +		ring_buffer_discard_commit(buffer, event);		\
> +									\
> +		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,		\
> +			     &ftrace_file->flags))			\
> +			event_triggers_call(ftrace_file, entry);	\
> +		return;							\
> +	}								\
> +									\
>  	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
>  		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
> +									\
> +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,			\
> +		     &ftrace_file->flags))				\
> +		event_triggers_call(ftrace_file, entry);		\

Actually, since "entry" is a part of "event" which may be already discarded,
I think we should not access it here. It may not cause real problem because
even if it is discarded, that does NOT mean it is freed. However, it depends
on the ring-buffer implementation.

I recommend you to call event triggers before commit the event. It will also
make the code simpler :)

> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index e287011..47fa712 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -319,14 +319,6 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  	if (!sys_data)
>  		return;
>  
> -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> -		     &sys_data->enter_file->flags))
> -		event_triggers_call(sys_data->enter_file);
> -
> -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> -		     &sys_data->enter_file->flags))
> -		return;
> -
>  	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
>  
>  	buffer = tr->trace_buffer.buffer;
> @@ -339,9 +331,23 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  	entry->nr = syscall_nr;
>  	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
>  
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> +		     &sys_data->enter_file->flags)) {
> +		ring_buffer_discard_commit(buffer, event);
> +
> +		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> +			     &sys_data->enter_file->flags))
> +			event_triggers_call(sys_data->enter_file, entry);
> +		return;
> +	}
> +
>  	if (!filter_current_check_discard(buffer, sys_data->enter_event,
>  					  entry, event))
>  		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
> +
> +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> +		     &sys_data->enter_file->flags))
> +		event_triggers_call(sys_data->enter_file, entry);
>  }
>  
>  static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
> @@ -363,14 +369,6 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  	if (!sys_data)
>  		return;
>  
> -	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> -		     &sys_data->exit_file->flags))
> -		event_triggers_call(sys_data->exit_file);
> -
> -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> -		     &sys_data->exit_file->flags))
> -		return;
> -
>  	buffer = tr->trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer,
>  			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
> @@ -381,9 +379,23 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  	entry->nr = syscall_nr;
>  	entry->ret = syscall_get_return_value(current, regs);
>  
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
> +		     &sys_data->exit_file->flags)) {
> +		ring_buffer_discard_commit(buffer, event);
> +
> +		if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> +			     &sys_data->exit_file->flags))
> +			event_triggers_call(sys_data->exit_file, entry);
> +		return;
> +	}
> +
>  	if (!filter_current_check_discard(buffer, sys_data->exit_event,
>  					  entry, event))
>  		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
> +
> +	if (test_bit(FTRACE_EVENT_FL_TRIGGER_MODE_BIT,
> +		     &sys_data->exit_file->flags))
> +		event_triggers_call(sys_data->exit_file, entry);
>  }
>  
>  static int reg_event_syscall_enter(struct ftrace_event_file *file,
> 

Same changes are needed here.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


