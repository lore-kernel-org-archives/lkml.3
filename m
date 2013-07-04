Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3GDMtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:49:00 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38483 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3GDMsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:48:52 -0400
Message-ID: <51D56F29.2040700@hitachi.com>
Date: Thu, 04 Jul 2013 21:48:41 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/4] tracing: trace_remove_event_call() should
 fail if call/file is in use
References: <20130704033347.807661713@goodmis.org> <20130704034038.665930010@goodmis.org>
In-Reply-To: <20130704034038.665930010@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/04 12:33), Steven Rostedt wrote:
> From: Oleg Nesterov <oleg@redhat.com>
> 
> Change trace_remove_event_call(call) to return the error if this
> call is active. This is what the callers assume but can't verify
> outside of the tracing locks. Both trace_kprobe.c/trace_uprobe.c
> need the additional changes, unregister_trace_probe() should abort
> if trace_remove_event_call() fails.
> 
> We also check TRACE_EVENT_FL_REF_MASK to ensure that nobody opened
> the files we are going to remove, these means that nobody can access
> the soon-to-be-freed ftrace_event_file/call via filp->private_data.
> 
> Link: http://lkml.kernel.org/r/20130702222359.GA27629@redhat.com

This looks good for me ;)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/ftrace_event.h |    2 +-
>  kernel/trace/trace_events.c  |   33 +++++++++++++++++++++++++++++++--
>  2 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 72ff2c6..bdf6bdd 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -338,7 +338,7 @@ extern int trace_define_field(struct ftrace_event_call *call, const char *type,
>  			      const char *name, int offset, int size,
>  			      int is_signed, int filter_type);
>  extern int trace_add_event_call(struct ftrace_event_call *call);
> -extern void trace_remove_event_call(struct ftrace_event_call *call);
> +extern int trace_remove_event_call(struct ftrace_event_call *call);
>  
>  #define is_signed_type(type)	(((type)(-1)) < (type)1)
>  
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 90cf243..1a5547e 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1766,16 +1766,45 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
>  	destroy_preds(call);
>  }
>  
> +static int probe_remove_event_call(struct ftrace_event_call *call)
> +{
> +	struct trace_array *tr;
> +	struct ftrace_event_file *file;
> +
> +	if (call->flags & TRACE_EVENT_FL_REF_MASK)
> +		return -EBUSY;
> +
> +#ifdef CONFIG_PERF_EVENTS
> +	if (call->perf_refcount)
> +		return -EBUSY;
> +#endif
> +	do_for_each_event_file(tr, file) {
> +		if (file->event_call != call)
> +			continue;
> +		if (file->flags & FTRACE_EVENT_FL_ENABLED)
> +			return -EBUSY;
> +		break;
> +	} while_for_each_event_file();
> +
> +	__trace_remove_event_call(call);
> +
> +	return 0;
> +}
> +
>  /* Remove an event_call */
> -void trace_remove_event_call(struct ftrace_event_call *call)
> +int trace_remove_event_call(struct ftrace_event_call *call)
>  {
> +	int ret;
> +
>  	mutex_lock(&trace_types_lock);
>  	mutex_lock(&event_mutex);
>  	down_write(&trace_event_sem);
> -	__trace_remove_event_call(call);
> +	ret = probe_remove_event_call(call);
>  	up_write(&trace_event_sem);
>  	mutex_unlock(&event_mutex);
>  	mutex_unlock(&trace_types_lock);
> +
> +	return ret;
>  }
>  
>  #define for_each_event(event, start, end)			\
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


