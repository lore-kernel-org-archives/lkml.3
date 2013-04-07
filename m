Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab3DGKcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 06:32:19 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37517 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217Ab3DGKcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 06:32:14 -0400
Date: Sun, 7 Apr 2013 16:01:59 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] uprobes/tracing: Make uprobe_{trace,perf}_print()
 uretprobe-friendly
Message-ID: <20130407103159.GA6810@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130401160827.GA19206@redhat.com>
 <20130401160851.GA19576@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130401160851.GA19576@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040710-5806-0000-0000-000020A1204D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-04-01 18:08:51]:

> Change uprobe_trace_print() and uprobe_perf_print() to check
> is_ret_probe() and fill ring_buffer_event accordingly.
> 
> Also change uprobe_trace_func() and uprobe_perf_func() to not
> _print() if is_ret_probe() is true. Note that we keep ->handler()
> nontrivial even for uretprobe, we need this for filtering and for
> other potential extensions.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_uprobe.c |   42 +++++++++++++++++++++++++++++++++---------
>  1 files changed, 33 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index e91a354..db2718a 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -515,15 +515,26 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
>  	int size, i;
>  	struct ftrace_event_call *call = &tu->call;
> 
> -	size = SIZEOF_TRACE_ENTRY(1) + tu->size;
> +	if (is_ret_probe(tu))

One nit:
Here and couple of places below .. we could check for func instead of
is_ret_probe() right?
Or is there an advantage of checking is_ret_probe() over func?

> +		size = SIZEOF_TRACE_ENTRY(2);
> +	else
> +		size = SIZEOF_TRACE_ENTRY(1);
> +
>  	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
> -						  size, 0, 0);
> +						  size + tu->size, 0, 0);
>  	if (!event)
>  		return;
> 
>  	entry = ring_buffer_event_data(event);
> -	entry->vaddr[0] = instruction_pointer(regs);
> -	data = DATAOF_TRACE_ENTRY(entry, 1);
> +	if (is_ret_probe(tu)) {
> +		entry->vaddr[0] = func;
> +		entry->vaddr[1] = instruction_pointer(regs);
> +		data = DATAOF_TRACE_ENTRY(entry, 2);
> +	} else {
> +		entry->vaddr[0] = instruction_pointer(regs);
> +		data = DATAOF_TRACE_ENTRY(entry, 1);
> +	}
> +
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
> 
> @@ -534,7 +545,8 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
>  /* uprobe handler */
>  static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  {
> -	uprobe_trace_print(tu, 0, regs);
> +	if (!is_ret_probe(tu))
> +		uprobe_trace_print(tu, 0, regs);

Should this hunk be in the previous patch?

Also something for the future:
Most times a user uses a return probe, the user probably wants to probe
the function entry too. So should we extend the abi from p+r to
p+r+..<something else> to mean it traces both function entry and return.
Esp given that uretprobe has been elegantly been designed to make this a
possibility.


>  	return 0;
>  }
> 
> @@ -783,7 +795,11 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
>  	void *data;
>  	int size, rctx, i;
> 
> -	size = SIZEOF_TRACE_ENTRY(1);
> +	if (is_ret_probe(tu))
> +		size = SIZEOF_TRACE_ENTRY(2);
> +	else
> +		size = SIZEOF_TRACE_ENTRY(1);
> +
>  	size = ALIGN(size + tu->size + sizeof(u32), sizeof(u64)) - sizeof(u32);
>  	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE, "profile buffer not large enough"))
>  		return;
> @@ -794,8 +810,15 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
>  		goto out;
> 
>  	ip = instruction_pointer(regs);
> -	entry->vaddr[0] = ip;
> -	data = DATAOF_TRACE_ENTRY(entry, 1);
> +	if (is_ret_probe(tu)) {
> +		entry->vaddr[0] = func;
> +		entry->vaddr[1] = ip;
> +		data = DATAOF_TRACE_ENTRY(entry, 2);
> +	} else {
> +		entry->vaddr[0] = ip;
> +		data = DATAOF_TRACE_ENTRY(entry, 1);
> +	}
> +
>  	for (i = 0; i < tu->nr_args; i++)
>  		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
> 
> @@ -811,7 +834,8 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  	if (!uprobe_perf_filter(&tu->consumer, 0, current->mm))
>  		return UPROBE_HANDLER_REMOVE;
> 
> -	uprobe_perf_print(tu, 0, regs);
> +	if (!is_ret_probe(tu))
> +		uprobe_perf_print(tu, 0, regs);
>  	return 0;
>  }
> 
> -- 
> 1.5.5.1
> 

