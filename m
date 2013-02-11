Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3BKJtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:49:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47204 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3BKJtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:49:09 -0500
Date: Mon, 11 Feb 2013 15:16:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frank Eigler <fche@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes/perf: Teach trace_uprobe/perf code to
 pre-filter
Message-ID: <20130211094643.GG525@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130204190225.GA10840@redhat.com>
 <20130204190258.GA10882@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130204190258.GA10882@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021109-7282-0000-0000-00001400AF75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-02-04 20:02:58]:

> Finally implement uprobe_perf_filter() which checks ->nr_systemwide or
> ->perf_events to figure out whether we need to insert the breakpoint.
> 
> uprobe_perf_open/close are changed to do uprobe_apply(true/false) when
> the new perf event comes or goes away.
> 
> Note that currently this is very suboptimal:
> 
> 	- uprobe_register() called by TRACE_REG_PERF_REGISTER becomes a
> 	  heavy nop, consumer->filter() always returns F at this stage.
> 
> 	  As it was already discussed we need uprobe_register_only() to
> 	  avoid the costly register_for_each_vma() when possible.
> 
> 	- uprobe_apply() is oftenly overkill. Unless "nr_systemwide != 0"
> 	  changes we need uprobe_apply_mm(), unapply_uprobe() is almost
> 	  what we need.
> 
> 	- uprobe_apply() can be simply avoided sometimes, see the next
> 	  changes.
> 
> Testing:
> 
> 	# perf probe -x /lib/libc.so.6 syscall
> 
> 	# perl -e 'syscall -1 while 1' &
> 	[1] 530
> 
> 	# perf record -e probe_libc:syscall perl -e 'syscall -1 for 1..10; sleep 1'
> 
> 	# perf report --show-total-period
> 		100.00%            10     perl  libc-2.8.so    [.] syscall
> 
> Before this patch:
> 
> 	# cat /sys/kernel/debug/tracing/uprobe_profile
> 		/lib/libc.so.6 syscall				79291
> 
> A huge ->nrhit == 79291 reflects the fact that the background process
> 530 constantly hits this breakpoint too, even if doesn't contribute to
> the output.
> 
> After the patch:
> 
> 	# cat /sys/kernel/debug/tracing/uprobe_profile
> 		/lib/libc.so.6 syscall				10
> 
> This shows that only the target process was punished by int3.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |   46 ++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index f05ec32..5d5a261 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -554,7 +554,12 @@ static inline bool is_trace_uprobe_enabled(struct trace_uprobe *tu)
>  	return tu->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE);
>  }
> 
> -static int probe_event_enable(struct trace_uprobe *tu, int flag)
> +typedef bool (*filter_func_t)(struct uprobe_consumer *self,
> +				enum uprobe_filter_ctx ctx,
> +				struct mm_struct *mm);
> +
> +static int
> +probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
>  {
>  	int ret = 0;
> 
> @@ -564,6 +569,7 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
> 
>  	tu->flags |= flag;
> +	tu->consumer.filter = filter;
>  	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
>  	if (ret)
>  		tu->flags &= ~flag;
> @@ -653,6 +659,22 @@ static int set_print_fmt(struct trace_uprobe *tu)
>  }
> 
>  #ifdef CONFIG_PERF_EVENTS
> +static bool
> +__uprobe_perf_filter(struct trace_uprobe_filter *filter, struct mm_struct *mm)
> +{
> +	struct perf_event *event;
> +
> +	if (filter->nr_systemwide)
> +		return true;
> +
> +	list_for_each_entry(event, &filter->perf_events, hw.tp_list) {
> +		if (event->hw.tp_target->mm == mm)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
>  {
>  	write_lock(&tu->filter.rwlock);
> @@ -662,6 +684,8 @@ static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
>  		tu->filter.nr_systemwide++;
>  	write_unlock(&tu->filter.rwlock);
> 
> +	uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
> +
>  	return 0;
>  }
> 
> @@ -674,9 +698,25 @@ static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
>  		tu->filter.nr_systemwide--;
>  	write_unlock(&tu->filter.rwlock);
> 
> +	uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
> +
>  	return 0;
>  }
> 
> +static bool uprobe_perf_filter(struct uprobe_consumer *uc,
> +				enum uprobe_filter_ctx ctx, struct mm_struct *mm)
> +{
> +	struct trace_uprobe *tu;
> +	int ret;
> +
> +	tu = container_of(uc, struct trace_uprobe, consumer);
> +	read_lock(&tu->filter.rwlock);
> +	ret = __uprobe_perf_filter(&tu->filter, mm);
> +	read_unlock(&tu->filter.rwlock);
> +
> +	return ret;
> +}
> +
>  /* uprobe profile handler */
>  static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  {
> @@ -719,7 +759,7 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
> 
>  	switch (type) {
>  	case TRACE_REG_REGISTER:
> -		return probe_event_enable(tu, TP_FLAG_TRACE);
> +		return probe_event_enable(tu, TP_FLAG_TRACE, NULL);
> 
>  	case TRACE_REG_UNREGISTER:
>  		probe_event_disable(tu, TP_FLAG_TRACE);
> @@ -727,7 +767,7 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
> 
>  #ifdef CONFIG_PERF_EVENTS
>  	case TRACE_REG_PERF_REGISTER:
> -		return probe_event_enable(tu, TP_FLAG_PROFILE);
> +		return probe_event_enable(tu, TP_FLAG_PROFILE, uprobe_perf_filter);
> 
>  	case TRACE_REG_PERF_UNREGISTER:
>  		probe_event_disable(tu, TP_FLAG_PROFILE);
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

