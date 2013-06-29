Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3F2G10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 02:27:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:53037 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3F2G1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 02:27:25 -0400
Message-ID: <51CE7E20.9030909@huawei.com>
Date: Sat, 29 Jun 2013 14:26:40 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tom Zanussi <tom.zanussi@linux.intel.com>
CC: <rostedt@goodmis.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/11] tracing: add soft disable for syscall events
References: <cover.1372479499.git.tom.zanussi@linux.intel.com> <d7a32766817e9050997629b195676e357e410726.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <d7a32766817e9050997629b195676e357e410726.1372479499.git.tom.zanussi@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/29 13:08, Tom Zanussi wrote:
> Add support for SOFT_DISABLE to syscall events.
> 
> The original SOFT_DISABLE patches didn't add support for soft disable
> of syscall events; this adds it and paves the way for future patches
> allowing triggers to be added to syscall events, since triggers are
> built on top of SOFT_DISABLE.
> 
> The existing code grabs the trace_array from the ftrace_file passed to
> the event registration functions and passes that to the probe
> functions.  Passing the file instead allows the probe functions to
> access not only the trace_array attached to the file but the flags as
> well.
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> ---
>  kernel/trace/trace_syscalls.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 8f2ac73..1765088 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -301,7 +301,8 @@ static int __init syscall_exit_define_fields(struct ftrace_event_call *call)
>  
>  static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  {
> -	struct trace_array *tr = data;
> +	struct ftrace_event_file *ftrace_file = data;
> +	struct trace_array *tr = ftrace_file->tr;
>  	struct syscall_trace_enter *entry;
>  	struct syscall_metadata *sys_data;
>  	struct ring_buffer_event *event;
> @@ -319,6 +320,9 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  	if (!sys_data)
>  		return;
>  
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> +		return;
> +
>  	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
>  
>  	buffer = tr->trace_buffer.buffer;
> @@ -338,7 +342,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
>  
>  static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  {
> -	struct trace_array *tr = data;
> +	struct ftrace_event_file *ftrace_file = data;
> +	struct trace_array *tr = ftrace_file->tr;
>  	struct syscall_trace_exit *entry;
>  	struct syscall_metadata *sys_data;
>  	struct ring_buffer_event *event;
> @@ -355,6 +360,9 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
>  	if (!sys_data)
>  		return;
>  
> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> +		return;
> +
>  	buffer = tr->trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer,
>  			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
> @@ -382,7 +390,7 @@ static int reg_event_syscall_enter(struct ftrace_event_file *file,
>  		return -ENOSYS;
>  	mutex_lock(&syscall_trace_lock);
>  	if (!tr->sys_refcount_enter)
> -		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
> +		ret = register_trace_sys_enter(ftrace_syscall_enter, file);
>  	if (!ret) {
>  		set_bit(num, tr->enabled_enter_syscalls);
>  		tr->sys_refcount_enter++;

Is this change can work correctly?

It seems that all syscalls in same tr will use same ftrace_event_file(first registered)
in ftrace_syscall_enter/ftrace_syscall_exit, obviously this is wrong.

Basically I think we still need pass tr into register_trace_sys_enter/exit, for
performance reason. If you use ftrace_event_file as argument, then when your are
using command 'perf stat -e syscalls:* -a sleep 10',
it will looping NR_SYSCALLS tracepoints for every syscall enter and exit,
that's unacceptable.

Thanks.

> @@ -404,7 +412,7 @@ static void unreg_event_syscall_enter(struct ftrace_event_file *file,
>  	tr->sys_refcount_enter--;
>  	clear_bit(num, tr->enabled_enter_syscalls);
>  	if (!tr->sys_refcount_enter)
> -		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
> +		unregister_trace_sys_enter(ftrace_syscall_enter, file);
>  	mutex_unlock(&syscall_trace_lock);
>  }
>  
> @@ -420,7 +428,7 @@ static int reg_event_syscall_exit(struct ftrace_event_file *file,
>  		return -ENOSYS;
>  	mutex_lock(&syscall_trace_lock);
>  	if (!tr->sys_refcount_exit)
> -		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
> +		ret = register_trace_sys_exit(ftrace_syscall_exit, file);
>  	if (!ret) {
>  		set_bit(num, tr->enabled_exit_syscalls);
>  		tr->sys_refcount_exit++;
> @@ -442,7 +450,7 @@ static void unreg_event_syscall_exit(struct ftrace_event_file *file,
>  	tr->sys_refcount_exit--;
>  	clear_bit(num, tr->enabled_exit_syscalls);
>  	if (!tr->sys_refcount_exit)
> -		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
> +		unregister_trace_sys_exit(ftrace_syscall_exit, file);
>  	mutex_unlock(&syscall_trace_lock);
>  }
>  
> 


