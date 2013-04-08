Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285Ab3DHRIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:08:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14018 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751Ab3DHRIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:08:16 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=GTPbgbULCTEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=D_6splb7uo4A:10 a=20KFwNOVAAAA:8 a=nv4MrCtDpqPb-8qfgzEA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365440895.25498.24.camel@gandalf.local.home>
Subject: Re: [PATCH 3/6] uprobes/tracing: Make uprobe_{trace,perf}_print()
 uretprobe-friendly
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 13:08:15 -0400
In-Reply-To: <20130401160851.GA19576@redhat.com>
References: <20130401160851.GA19576@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 18:08 +0200, Oleg Nesterov wrote:
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
> +		size = SIZEOF_TRACE_ENTRY(2);
> +	else
> +		size = SIZEOF_TRACE_ENTRY(1);

Again, having an enum for 1 and 2 would make this much more readable:

	if (is_ret_probe(tu))
		size = SIZEOF_TRACE_ENTRY(UPROBE_ENTRY_RETPROBE);
	else
		size = SIZEOF_TRACE_ENTRY(UPROBE_ENTRY_NORMAL);


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

		data = DATAOF_TRACE_ENTRY(entry, UPROBE_ENTRY_RETPROBE);

> +	} else {
> +		entry->vaddr[0] = instruction_pointer(regs);
> +		data = DATAOF_TRACE_ENTRY(entry, 1);

		data = DATAOF_TRACE_ENTRY(entry, UPROBE_ENTRY_NORMAL);

etc,

-- Steve

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


