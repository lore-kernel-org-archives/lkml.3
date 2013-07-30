Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3G3GMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:12:23 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46186 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3G3GMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:12:06 -0400
Message-ID: <51F7592E.3070807@hitachi.com>
Date: Tue, 30 Jul 2013 15:11:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] tracing: trace_remove_event_call() should fail
 if call/file is in use
References: <20130729175008.GA26284@redhat.com> <20130729175033.GB26284@redhat.com>
In-Reply-To: <20130729175033.GB26284@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/30 2:50), Oleg Nesterov wrote:
> Change trace_remove_event_call(call) to return the error if this
> call is active. This is what the callers assume but can't verify
> outside of the tracing locks. Both trace_kprobe.c/trace_uprobe.c
> need the additional changes, unregister_trace_probe() should abort
> if trace_remove_event_call() fails.
> 
> The caller is going to free this call/file so we must ensure that
> nobody can use them after trace_remove_event_call() succeeds.
> debugfs should be fine after the previous changes and event_remove()
> does TRACE_REG_UNREGISTER, but still there are 2 reasons why we need
> the additional checks:
> 
> - There could be a perf_event(s) attached to this tp_event, so the
>   patch checks ->perf_refcount.
> 
> - TRACE_REG_UNREGISTER can be suppressed by FTRACE_EVENT_FL_SOFT_MODE,
>   so we simply check FTRACE_EVENT_FL_ENABLED protected by event_mutex.
> 

This looks good to me :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks! I'll update trace_kprobes.c too.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/ftrace_event.h |    2 +-
>  kernel/trace/trace_events.c  |   35 +++++++++++++++++++++++++++++++++--
>  2 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 4372658..f98ab06 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -332,7 +332,7 @@ extern int trace_define_field(struct ftrace_event_call *call, const char *type,
>  			      const char *name, int offset, int size,
>  			      int is_signed, int filter_type);
>  extern int trace_add_event_call(struct ftrace_event_call *call);
> -extern void trace_remove_event_call(struct ftrace_event_call *call);
> +extern int trace_remove_event_call(struct ftrace_event_call *call);
>  
>  #define is_signed_type(type)	(((type)(-1)) < (type)1)
>  
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 79a2743..3450496 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1709,16 +1709,47 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
>  	destroy_preds(call);
>  }
>  
> +static int probe_remove_event_call(struct ftrace_event_call *call)
> +{
> +	struct trace_array *tr;
> +	struct ftrace_event_file *file;
> +
> +#ifdef CONFIG_PERF_EVENTS
> +	if (call->perf_refcount)
> +		return -EBUSY;
> +#endif
> +	do_for_each_event_file(tr, file) {
> +		if (file->event_call != call)
> +			continue;
> +		/*
> +		 * We can't rely on ftrace_event_enable_disable(enable => 0)
> +		 * we are going to do, FTRACE_EVENT_FL_SOFT_MODE can suppress
> +		 * TRACE_REG_UNREGISTER.
> +		 */
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


