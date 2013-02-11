Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3BKJ5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:57:51 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53879 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755042Ab3BKJ5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:57:49 -0500
Date: Mon, 11 Feb 2013 15:25:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frank Eigler <fche@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] uprobes/perf: Avoid uprobe_apply() whenever
 possible
Message-ID: <20130211095522.GI525@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130204190225.GA10840@redhat.com>
 <20130204190305.GA10892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130204190305.GA10892@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021109-7182-0000-0000-0000051B049A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-02-04 20:03:05]:

> uprobe_perf_open/close call the costly uprobe_apply() every time,
> we can avoid it if:
> 
> 	- "nr_systemwide != 0" is not changed.
> 
> 	- There is another process/thread with the same ->mm.
> 
> 	- copy_proccess() does inherit_event(). dup_mmap() preserves the
> 	  inserted breakpoints.
> 
> 	- event->attr.enable_on_exec == T, we can rely on uprobe_mmap()
> 	  called by exec/mmap paths.
> 
> 	- tp_target is exiting. Only _close() checks PF_EXITING, I don't
> 	  think TRACE_REG_PERF_OPEN can hit the dying task too often.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |   42 ++++++++++++++++++++++++++++++++++++------
>  1 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 1114619..e4aab34 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -677,30 +677,60 @@ __uprobe_perf_filter(struct trace_uprobe_filter *filter, struct mm_struct *mm)
>  	return false;
>  }
> 
> +static inline bool
> +uprobe_filter_event(struct trace_uprobe *tu, struct perf_event *event)
> +{
> +	return __uprobe_perf_filter(&tu->filter, event->hw.tp_target->mm);
> +}
> +
>  static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
>  {
> +	bool done;
> +
>  	write_lock(&tu->filter.rwlock);
> -	if (event->hw.tp_target)
> +	if (event->hw.tp_target) {
> +		/*
> +		 * event->parent != NULL means copy_process(), we can avoid
> +		 * uprobe_apply(). current->mm must be probed and we can rely
> +		 * on dup_mmap() which preserves the already installed bp's.
> +		 *
> +		 * attr.enable_on_exec means that exec/mmap will install the
> +		 * breakpoints we need.
> +		 */
> +		done = tu->filter.nr_systemwide ||
> +			event->parent || event->attr.enable_on_exec ||
> +			uprobe_filter_event(tu, event);
>  		list_add(&event->hw.tp_list, &tu->filter.perf_events);
> -	else
> +	} else {
> +		done = tu->filter.nr_systemwide;
>  		tu->filter.nr_systemwide++;
> +	}
>  	write_unlock(&tu->filter.rwlock);
> 
> -	uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
> +	if (!done)
> +		uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
> 
>  	return 0;
>  }
> 
>  static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
>  {
> +	bool done;
> +
>  	write_lock(&tu->filter.rwlock);
> -	if (event->hw.tp_target)
> +	if (event->hw.tp_target) {
>  		list_del(&event->hw.tp_list);
> -	else
> +		done = tu->filter.nr_systemwide ||
> +			(event->hw.tp_target->flags & PF_EXITING) ||
> +			uprobe_filter_event(tu, event);
> +	} else {
>  		tu->filter.nr_systemwide--;
> +		done = tu->filter.nr_systemwide;
> +	}
>  	write_unlock(&tu->filter.rwlock);
> 
> -	uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
> +	if (!done)
> +		uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
> 
>  	return 0;
>  }
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

