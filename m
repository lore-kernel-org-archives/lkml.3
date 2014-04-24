Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaDXDRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 23:17:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:39365 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751386AbaDXDRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 23:17:32 -0400
Date: Wed, 23 Apr 2014 23:17:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] uprobes/tracing: uprobe_perf_open() forgets to
 handle the error from uprobe_apply()
Message-ID: <20140423231728.1b95e37c@gandalf.local.home>
In-Reply-To: <20140423165830.GA29493@redhat.com>
References: <20140423165808.GA29485@redhat.com>
	<20140423165830.GA29493@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2014 18:58:30 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> uprobe_perf_open()->uprobe_apply() can fail, but this error is wrongly
> ignored. Change uprobe_perf_open() to do uprobe_perf_close() and return
> the error code in this case.
> 
> Change uprobe_perf_close() to propogate the error from uprobe_apply()
> as well, although it should not fail.
> 
> The patch looks more complicated because it moves uprobe_perf_close()
> up to make it visible to uprobe_perf_open().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_uprobe.c |   46 +++++++++++++++++++++++-------------------
>  1 files changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 930e514..9aad3e2 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -1003,56 +1003,60 @@ uprobe_filter_event(struct trace_uprobe *tu, struct perf_event *event)
>  	return __uprobe_perf_filter(&tu->filter, event->hw.tp_target->mm);
>  }
>  
> -static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
> +static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)

Egad, this confused the heck out of me. I didn't notice the swap in
functions and was wondering what you were doing. I didn't realize this
is what you meant by moving the uprobe_perf_close() up. I was thinking
you moved the call up or something, not the function itself physically
in the file.

/me tries to continue dazed and confused.

>  {
>  	bool done;
>  
>  	write_lock(&tu->filter.rwlock);
>  	if (event->hw.tp_target) {
> -		/*
> -		 * event->parent != NULL means copy_process(), we can avoid
> -		 * uprobe_apply(). current->mm must be probed and we can rely
> -		 * on dup_mmap() which preserves the already installed bp's.
> -		 *
> -		 * attr.enable_on_exec means that exec/mmap will install the
> -		 * breakpoints we need.
> -		 */
> +		list_del(&event->hw.tp_list);
>  		done = tu->filter.nr_systemwide ||
> -			event->parent || event->attr.enable_on_exec ||
> +			(event->hw.tp_target->flags & PF_EXITING) ||
>  			uprobe_filter_event(tu, event);
> -		list_add(&event->hw.tp_list, &tu->filter.perf_events);
>  	} else {
> +		tu->filter.nr_systemwide--;
>  		done = tu->filter.nr_systemwide;
> -		tu->filter.nr_systemwide++;
>  	}
>  	write_unlock(&tu->filter.rwlock);
>  
>  	if (!done)
> -		uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
> +		return uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
>  
>  	return 0;
>  }
>  
> -static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
> +static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
>  {
>  	bool done;
> +	int err;
>  
>  	write_lock(&tu->filter.rwlock);
>  	if (event->hw.tp_target) {
> -		list_del(&event->hw.tp_list);
> +		/*
> +		 * event->parent != NULL means copy_process(), we can avoid
> +		 * uprobe_apply(). current->mm must be probed and we can rely
> +		 * on dup_mmap() which preserves the already installed bp's.
> +		 *
> +		 * attr.enable_on_exec means that exec/mmap will install the
> +		 * breakpoints we need.
> +		 */
>  		done = tu->filter.nr_systemwide ||
> -			(event->hw.tp_target->flags & PF_EXITING) ||
> +			event->parent || event->attr.enable_on_exec ||
>  			uprobe_filter_event(tu, event);
> +		list_add(&event->hw.tp_list, &tu->filter.perf_events);
>  	} else {
> -		tu->filter.nr_systemwide--;
>  		done = tu->filter.nr_systemwide;
> +		tu->filter.nr_systemwide++;
>  	}
>  	write_unlock(&tu->filter.rwlock);
>  
> -	if (!done)
> -		uprobe_apply(tu->inode, tu->offset, &tu->consumer, false);
> -
> -	return 0;
> +	err = 0;
> +	if (!done) {
> +		err = uprobe_apply(tu->inode, tu->offset, &tu->consumer, true);
> +		if (err)
> +			uprobe_perf_close(tu, event);
> +	}
> +	return err;

You can add by Acked-by, but next time, please make this into two
patches. One to do the move, the other to do the change.

Thanks!

-- Steve

>  }
>  
>  static bool uprobe_perf_filter(struct uprobe_consumer *uc,

