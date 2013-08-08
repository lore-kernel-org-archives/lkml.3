Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965954Ab3HHQML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:12:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12595 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964796Ab3HHQMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:12:09 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=g3oJP0jvNMsA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Nv30PPXtYgsA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=eUUyZu43qd_tm7mBnRcA:9 a=QEXdDO2ut3YA:10 a=T_MzRWcqBuIA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375978326.6848.66.camel@gandalf.local.home>
Subject: Re: [for-next-3.11][PATCH 4/4] tracing: Fix reset of time stamps
 during trace_clock changes
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>, stable@vger.kernel.org,
        Alexander Z Lam <azl@google.com>
Date: Thu, 08 Aug 2013 12:12:06 -0400
In-Reply-To: <20130803125117.748903207@goodmis.org>
References: <20130803124926.157378122@goodmis.org>
	 <20130803125117.748903207@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I'm testing the backports, and I found that this patch depends on commit
10246fa35d4ffdfe472185d4cbf9c2dfd9a9f023 "tracing: Use flag
buffer_disabled for irqsoff tracer"

Please add that to 3.10 before applying this fix.

Thanks!

-- Steve


On Sat, 2013-08-03 at 08:49 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0004-tracing-Fix-reset-of-time-stamps-during-trace_clock-.patch)
> From: Alexander Z Lam <azl@google.com>
> 
> Fixed two issues with changing the timestamp clock with trace_clock:
> 
>  - The global buffer was reset on instance clock changes. Change this to pass
>    the correct per-instance buffer
>  - ftrace_now() is used to set buf->time_start in tracing_reset_online_cpus().
>    This was incorrect because ftrace_now() used the global buffer's clock to
>    return the current time. Change this to use buffer_ftrace_now() which
>    returns the current time for the correct per-instance buffer.
> 
> Also removed tracing_reset_current() because it is not used anywhere
> 
> Link: http://lkml.kernel.org/r/1375493777-17261-2-git-send-email-azl@google.com
> 
> Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
> Cc: David Sharp <dhsharp@google.com>
> Cc: Alexander Z Lam <lambchop468@gmail.com>
> Cc: stable@vger.kernel.org # 3.10
> Signed-off-by: Alexander Z Lam <azl@google.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |   24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 531c9e6..496f94d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -243,20 +243,25 @@ int filter_current_check_discard(struct ring_buffer *buffer,
>  }
>  EXPORT_SYMBOL_GPL(filter_current_check_discard);
>  
> -cycle_t ftrace_now(int cpu)
> +cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
>  {
>  	u64 ts;
>  
>  	/* Early boot up does not have a buffer yet */
> -	if (!global_trace.trace_buffer.buffer)
> +	if (!buf->buffer)
>  		return trace_clock_local();
>  
> -	ts = ring_buffer_time_stamp(global_trace.trace_buffer.buffer, cpu);
> -	ring_buffer_normalize_time_stamp(global_trace.trace_buffer.buffer, cpu, &ts);
> +	ts = ring_buffer_time_stamp(buf->buffer, cpu);
> +	ring_buffer_normalize_time_stamp(buf->buffer, cpu, &ts);
>  
>  	return ts;
>  }
>  
> +cycle_t ftrace_now(int cpu)
> +{
> +	return buffer_ftrace_now(&global_trace.trace_buffer, cpu);
> +}
> +
>  /**
>   * tracing_is_enabled - Show if global_trace has been disabled
>   *
> @@ -1211,7 +1216,7 @@ void tracing_reset_online_cpus(struct trace_buffer *buf)
>  	/* Make sure all commits have finished */
>  	synchronize_sched();
>  
> -	buf->time_start = ftrace_now(buf->cpu);
> +	buf->time_start = buffer_ftrace_now(buf, buf->cpu);
>  
>  	for_each_online_cpu(cpu)
>  		ring_buffer_reset_cpu(buffer, cpu);
> @@ -1219,11 +1224,6 @@ void tracing_reset_online_cpus(struct trace_buffer *buf)
>  	ring_buffer_record_enable(buffer);
>  }
>  
> -void tracing_reset_current(int cpu)
> -{
> -	tracing_reset(&global_trace.trace_buffer, cpu);
> -}
> -
>  /* Must have trace_types_lock held */
>  void tracing_reset_all_online_cpus(void)
>  {
> @@ -4634,12 +4634,12 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
>  	 * New clock may not be consistent with the previous clock.
>  	 * Reset the buffer so that it doesn't have incomparable timestamps.
>  	 */
> -	tracing_reset_online_cpus(&global_trace.trace_buffer);
> +	tracing_reset_online_cpus(&tr->trace_buffer);
>  
>  #ifdef CONFIG_TRACER_MAX_TRACE
>  	if (tr->flags & TRACE_ARRAY_FL_GLOBAL && tr->max_buffer.buffer)
>  		ring_buffer_set_clock(tr->max_buffer.buffer, trace_clocks[i].func);
> -	tracing_reset_online_cpus(&global_trace.max_buffer);
> +	tracing_reset_online_cpus(&tr->max_buffer);
>  #endif
>  
>  	mutex_unlock(&trace_types_lock);


