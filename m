Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784Ab3DGOEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 10:04:11 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54536 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717Ab3DGOEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 10:04:10 -0400
Date: Sun, 7 Apr 2013 19:28:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] uprobes/tracing: Introduce
 uprobe_{trace,perf}_print() helpers
Message-ID: <20130407135825.GA8672@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130401160827.GA19206@redhat.com>
 <20130401160845.GA19566@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130401160845.GA19566@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040714-5518-0000-0000-00000D4A2E24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-04-01 18:08:45]:

> Extract the output code from uprobe_trace_func() and uprobe_perf_func()
> into the new helpers, they will be used by ->ret_handler() too. We also
> add the unused "unsigned long func" argument in advance, to simplify the
> next changes.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |   29 ++++++++++++++++++++---------
>  1 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 92a4b08..2ea9961 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -496,8 +496,8 @@ static const struct file_operations uprobe_profile_ops = {
>  	.release	= seq_release,
>  };
> 
> -/* uprobe handler */
> -static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
> +static void uprobe_trace_print(struct trace_uprobe *tu,
> +				unsigned long func, struct pt_regs *regs)
>  {
>  	struct uprobe_trace_entry_head *entry;
>  	struct ring_buffer_event *event;
> @@ -510,7 +510,7 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
>  						  size, 0, 0);
>  	if (!event)
> -		return 0;
> +		return;
> 
>  	entry = ring_buffer_event_data(event);
>  	entry->vaddr[0] = instruction_pointer(regs);
> @@ -520,7 +520,12 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
> 
>  	if (!filter_current_check_discard(buffer, call, entry, event))
>  		trace_buffer_unlock_commit(buffer, event, 0, 0);
> +}
> 
> +/* uprobe handler */
> +static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
> +{
> +	uprobe_trace_print(tu, 0, regs);
>  	return 0;
>  }
> 
> @@ -753,8 +758,8 @@ static bool uprobe_perf_filter(struct uprobe_consumer *uc,
>  	return ret;
>  }
> 
> -/* uprobe profile handler */
> -static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
> +static void uprobe_perf_print(struct trace_uprobe *tu,
> +				unsigned long func, struct pt_regs *regs)
>  {
>  	struct ftrace_event_call *call = &tu->call;
>  	struct uprobe_trace_entry_head *entry;
> @@ -763,13 +768,10 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	void *data;
>  	int size, rctx, i;
> 
> -	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
> -		return UPROBE_HANDLER_REMOVE;
> -
>  	size = SIZEOF_TRACE_ENTRY(1);
>  	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
>  	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
> -		return 0;
> +		return;
> 
>  	preempt_disable();
>  	entry = perf_trace_buf_prepare(size, call->event.type, regs, &rctx);
> @@ -786,6 +788,15 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	perf_trace_buf_submit(entry, size, rctx, ip, 1, regs, head, NULL);
>   out:
>  	preempt_enable();
> +}
> +
> +/* uprobe profile handler */
> +static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
> +{
> +	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
> +		return UPROBE_HANDLER_REMOVE;
> +
> +	uprobe_perf_print(tu, 0, regs);
>  	return 0;
>  }
>  #endif	/* CONFIG_PERF_EVENTS */
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

