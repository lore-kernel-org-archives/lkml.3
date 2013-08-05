Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3HEDHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:07:45 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13176 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab3HEDHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:07:44 -0400
Message-ID: <51FF16EA.7000501@huawei.com>
Date: Mon, 5 Aug 2013 11:07:22 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing: add ftrace_trace_stack into __trace_puts/__trace_bputs
References: <51E7A7C9.9040401@huawei.com>
In-Reply-To: <51E7A7C9.9040401@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/18 16:31, zhangwei(Jovi) wrote:
> Currently trace option stacktrace is not applicable for
> trace_printk with constant string argument, the reason is
> there missed ftrace_trace_stack in __trace_puts/__trace_bputs.
> 
> In contrast, when using trace_printk with not constant string
> argument(will call into __trace_printk/__trace_bprintk), then
> trace option stacktrace is workable, this inconstant result
> will confusing user a lot.
> 

Hi steven,

How about this patch?
and [PATCH 2/3] "tracing: add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs"

Thanks.

jovi.

> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  kernel/trace/trace.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 3d5a931..4d70cc5 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -363,13 +363,16 @@ int __trace_puts(unsigned long ip, const char *str, int size)
>  	struct print_entry *entry;
>  	unsigned long irq_flags;
>  	int alloc;
> +	int pc;
> +
> +	pc = preempt_count();
> 
>  	alloc = sizeof(*entry) + size + 2; /* possible \n added */
> 
>  	local_save_flags(irq_flags);
>  	buffer = global_trace.trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc,
> -					  irq_flags, preempt_count());
> +					  irq_flags, pc);
>  	if (!event)
>  		return 0;
> 
> @@ -386,6 +389,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
>  		entry->buf[size] = '\0';
> 
>  	__buffer_unlock_commit(buffer, event);
> +	ftrace_trace_stack(buffer, irq_flags, 4, pc);
> 
>  	return size;
>  }
> @@ -403,11 +407,14 @@ int __trace_bputs(unsigned long ip, const char *str)
>  	struct bputs_entry *entry;
>  	unsigned long irq_flags;
>  	int size = sizeof(struct bputs_entry);
> +	int pc;
> +
> +	pc = preempt_count();
> 
>  	local_save_flags(irq_flags);
>  	buffer = global_trace.trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
> -					  irq_flags, preempt_count());
> +					  irq_flags, pc);
>  	if (!event)
>  		return 0;
> 
> @@ -416,6 +423,7 @@ int __trace_bputs(unsigned long ip, const char *str)
>  	entry->str			= str;
> 
>  	__buffer_unlock_commit(buffer, event);
> +	ftrace_trace_stack(buffer, irq_flags, 4, pc);
> 
>  	return 1;
>  }
> 


