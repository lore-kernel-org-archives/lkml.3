Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaGISkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:40:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:41042 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751778AbaGISkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:40:15 -0400
Date: Wed, 9 Jul 2014 14:40:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing: add ftrace_trace_stack into
 __trace_puts/__trace_bputs
Message-ID: <20140709144005.6afe7232@gandalf.local.home>
In-Reply-To: <51E7A7C9.9040401@huawei.com>
References: <51E7A7C9.9040401@huawei.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow! I some how missed your emails. I'm cleaning up my inbox and just
stumbled over them now.

I tell people, they can either ping me a few times (keep doing it until
you see a response, but spread them out). Otherwise, I will still get
to their email. Just a year later ;-)

Yeah, this looks fine. I can queue it up for 3.17.

-- Steve


On Thu, 18 Jul 2013 16:31:05 +0800
"zhangwei(Jovi)" <jovi.zhangwei@huawei.com> wrote:

> Currently trace option stacktrace is not applicable for
> trace_printk with constant string argument, the reason is
> there missed ftrace_trace_stack in __trace_puts/__trace_bputs.
> 
> In contrast, when using trace_printk with not constant string
> argument(will call into __trace_printk/__trace_bprintk), then
> trace option stacktrace is workable, this inconstant result
> will confusing user a lot.
> 
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

