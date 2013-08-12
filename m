Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3HLKCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:02:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:9396 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab3HLKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:02:19 -0400
Message-ID: <5208B293.2030906@huawei.com>
Date: Mon, 12 Aug 2013 18:01:55 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] ftrace: Add initialization check in trace_printk for
 *puts paths
References: <1376300045-3956-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1376300045-3956-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/12 17:34, Jiri Olsa wrote:
> Adding initialization check in trace_printk for *puts
> paths, plus unifying the check for all related cases.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
Missed Signed-off-by tag?

>  kernel/trace/trace.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 882ec1d..cb7cf96 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -126,6 +126,9 @@ static char *default_bootup_tracer;
>  
>  static bool allocate_snapshot;
>  
> +#define TRACE_PRINTK_DENIED \
> +	unlikely(tracing_selftest_running || tracing_disabled)
> +
>  static int __init set_cmdline_ftrace(char *str)
>  {
>  	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
> @@ -430,6 +433,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
>  	unsigned long irq_flags;
>  	int alloc;
>  
> +	if (TRACE_PRINTK_DENIED)
> +		return 0;
> +
>  	alloc = sizeof(*entry) + size + 2; /* possible \n added */
>  
>  	local_save_flags(irq_flags);
> @@ -470,6 +476,9 @@ int __trace_bputs(unsigned long ip, const char *str)
>  	unsigned long irq_flags;
>  	int size = sizeof(struct bputs_entry);
>  
> +	if (TRACE_PRINTK_DENIED)
> +		return 0;
> +
>  	local_save_flags(irq_flags);
>  	buffer = global_trace.trace_buffer.buffer;
>  	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
> @@ -1757,7 +1766,7 @@ void trace_dump_stack(int skip)
>  {
>  	unsigned long flags;
>  
> -	if (tracing_disabled || tracing_selftest_running)
> +	if (TRACE_PRINTK_DENIED)
>  		return;
>  
>  	local_save_flags(flags);
> @@ -1976,7 +1985,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
>  	char *tbuffer;
>  	int len = 0, size, pc;
>  
> -	if (unlikely(tracing_selftest_running || tracing_disabled))
> +	if (TRACE_PRINTK_DENIED)
>  		return 0;
>  
>  	/* Don't pollute graph traces with trace_vprintk internals */
> @@ -2032,7 +2041,7 @@ __trace_array_vprintk(struct ring_buffer *buffer,
>  	unsigned long flags;
>  	char *tbuffer;
>  
> -	if (tracing_disabled || tracing_selftest_running)
> +	if (TRACE_PRINTK_DENIED)
>  		return 0;
>  
>  	/* Don't pollute graph traces with trace_vprintk internals */
> 


