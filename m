Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3BKJqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 04:46:53 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38693 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3BKJqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 04:46:51 -0500
Date: Mon, 11 Feb 2013 15:14:24 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frank Eigler <fche@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] perf: Introduce hw_perf_event->tp_target and
 ->tp_list
Message-ID: <20130211094424.GE525@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130204190225.GA10840@redhat.com>
 <20130204190246.GA10865@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130204190246.GA10865@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021109-5406-0000-0000-0000052780C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-02-04 20:02:46]:

> sys_perf_event_open()->perf_init_event(event) is called before
> find_get_context(event), this means that event->ctx == NULL when
> class->reg(TRACE_REG_PERF_REGISTER/OPEN) is called and thus it
> can't know if this event is per-task or system-wide.
> 
> This patch adds hw_perf_event->tp_target for PERF_TYPE_TRACEPOINT,
> this is analogous to PERF_TYPE_BREAKPOINT/bp_target we already have.
> The patch also moves ->bp_target up so that it can overlap with the
> new member, this can help the compiler to generate the better code.
> 
> trace_uprobe_register() will use it for prefiltering to avoid the
> unnecessary breakpoints in mm's we do not want to trace.
> 
> ->tp_target doesn't have its own reference, but we can rely on the
> fact that either sys_perf_event_open() holds a reference, or it is
> equal to event->ctx->task. So this pointer is always valid until
> free_event().
> 
> Also add the "struct list_head tp_list" into this union. It is not
> strictly necessary, but it can simplify the next changes and we can
> add it for free.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  include/linux/perf_event.h |    9 +++++++--
>  kernel/events/core.c       |    5 ++++-
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 6bfb2fa..c9775e9 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -135,16 +135,21 @@ struct hw_perf_event {
>  		struct { /* software */
>  			struct hrtimer	hrtimer;
>  		};
> +		struct { /* tracepoint */
> +			struct task_struct	*tp_target;
> +			/* for tp_event->class */
> +			struct list_head	tp_list;
> +		};
>  #ifdef CONFIG_HAVE_HW_BREAKPOINT
>  		struct { /* breakpoint */
> -			struct arch_hw_breakpoint	info;
> -			struct list_head		bp_list;
>  			/*
>  			 * Crufty hack to avoid the chicken and egg
>  			 * problem hw_breakpoint has with context
>  			 * creation and event initalization.
>  			 */
>  			struct task_struct		*bp_target;
> +			struct arch_hw_breakpoint	info;
> +			struct list_head		bp_list;
>  		};
>  #endif
>  	};
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 1b2e516..340fb53 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6162,11 +6162,14 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
> 
>  	if (task) {
>  		event->attach_state = PERF_ATTACH_TASK;
> +
> +		if (attr->type == PERF_TYPE_TRACEPOINT)
> +			event->hw.tp_target = task;
>  #ifdef CONFIG_HAVE_HW_BREAKPOINT
>  		/*
>  		 * hw_breakpoint is a bit difficult here..
>  		 */
> -		if (attr->type == PERF_TYPE_BREAKPOINT)
> +		else if (attr->type == PERF_TYPE_BREAKPOINT)
>  			event->hw.bp_target = task;
>  #endif
>  	}
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

