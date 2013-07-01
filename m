Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab3GATWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:22:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab3GATWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:22:15 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=b50BksreE0kA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=R4sMS_rjWVkA:10 a=i0EeH86SAAAA:8 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=rxTo8IrRAAAA:8 a=xmjMVpMzI-pPJyG_v48A:9 a=QEXdDO2ut3YA:10 a=xYdMApT76mEA:10 a=hPjdaMEvmhQA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372706533.22688.15.camel@gandalf.local.home>
Subject: Re: [PATCH v4] tracing/uprobes: Support ftrace_event_file base
 multibuffer
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2013 15:22:13 -0400
In-Reply-To: <51CE920C.5020001@huawei.com>
References: <51CE920C.5020001@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-29 at 15:51 +0800, zhangwei(Jovi) wrote:
> [v3->v4]:
> 1. use "bool enabled = is_trace_uprobe_enabled(tu);", suggested by Oleg.
> 2. use list_add_tail_rcu instead of list_add_rcu, suggested by Masami.
> 3. fix the error handling in probe_event_enable, found by Srikar.

Is this the final patch?

Masami, can you give your reviewed by (Oleg and Srikar, feel free to add
your tags either).

Also, the origin was a two patch set. Is the second patch needed?

Thanks,

-- Steve

> 
> -------------------
> 
> Support multi-buffer on uprobe-based dynamic events by
> using ftrace_event_file.
> 
> This patch is based kprobe-based dynamic events multibuffer
> support work initially, commited by Masami(commit 41a7dd420c),
> but revised as below:
> 
> Oleg changed the kprobe-based multibuffer design from
> array-pointers of ftrace_event_file into simple list,
> so this patch also change to the list degisn.
> 
> rcu_read_lock/unlock added into uprobe_trace_func/uretprobe_trace_func,
> to synchronize with ftrace_event_file list add and delete.
> 
> Even though we allow multi-uprobes instances now,
> but TP_FLAG_PROFILE/TP_FLAG_TRACE are still mutually exclusive
> in probe_event_enable currently, this means we cannot allow
> one user is using uprobe-tracer, and another user is using
> perf-probe on same uprobe concurrently.
> (Perhaps this will be fix in future, kprobe dont't have this
> limitation now)
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_uprobe.c |  123 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 101 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 32494fb0..760d4ed 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -53,6 +53,7 @@ struct trace_uprobe {
>  	struct list_head		list;
>  	struct ftrace_event_class	class;
>  	struct ftrace_event_call	call;
> +	struct list_head		files;
>  	struct trace_uprobe_filter	filter;
>  	struct uprobe_consumer		consumer;
>  	struct inode			*inode;
> @@ -65,6 +66,11 @@ struct trace_uprobe {
>  	struct probe_arg		args[];
>  };
> 
> +struct event_file_link {
> +	struct ftrace_event_file	*file;
> +	struct list_head		list;
> +};
> +
>  #define SIZEOF_TRACE_UPROBE(n)			\
>  	(offsetof(struct trace_uprobe, args) +	\
>  	(sizeof(struct probe_arg) * (n)))
> @@ -124,6 +130,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
>  		goto error;
> 
>  	INIT_LIST_HEAD(&tu->list);
> +	INIT_LIST_HEAD(&tu->files);
>  	tu->consumer.handler = uprobe_dispatcher;
>  	if (is_ret)
>  		tu->consumer.ret_handler = uretprobe_dispatcher;
> @@ -511,7 +518,8 @@ static const struct file_operations uprobe_profile_ops = {
>  };
> 
>  static void uprobe_trace_print(struct trace_uprobe *tu,
> -				unsigned long func, struct pt_regs *regs)
> +				unsigned long func, struct pt_regs *regs,
> +				struct ftrace_event_file *ftrace_file)
>  {
>  	struct uprobe_trace_entry_head *entry;
>  	struct ring_buffer_event *event;
> @@ -520,9 +528,12 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
>  	int size, i;
>  	struct ftrace_event_call *call = &tu->call;
> 
> +	WARN_ON(call != ftrace_file->event_call);
> +
>  	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
> -	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
> -						  size + tu->size, 0, 0);
> +	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
> +						call->event.type,
> +						size + tu->size, 0, 0);
>  	if (!event)
>  		return;
> 
> @@ -546,15 +557,28 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
>  /* uprobe handler */
>  static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
>  {
> -	if (!is_ret_probe(tu))
> -		uprobe_trace_print(tu, 0, regs);
> +	struct event_file_link *link;
> +
> +	if (is_ret_probe(tu))
> +		return 0;
> +
> +	rcu_read_lock();
> +	list_for_each_entry(link, &tu->files, list)
> +		uprobe_trace_print(tu, 0, regs, link->file);
> +	rcu_read_unlock();
> +
>  	return 0;
>  }
> 
>  static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
>  				struct pt_regs *regs)
>  {
> -	uprobe_trace_print(tu, func, regs);
> +	struct event_file_link *link;
> +
> +	rcu_read_lock();
> +	list_for_each_entry(link, &tu->files, list)
> +		uprobe_trace_print(tu, func, regs, link->file);
> +	rcu_read_unlock();
>  }
> 
>  /* Event entry printers */
> @@ -605,33 +629,87 @@ typedef bool (*filter_func_t)(struct uprobe_consumer *self,
>  				struct mm_struct *mm);
> 
>  static int
> -probe_event_enable(struct trace_uprobe *tu, int flag, filter_func_t filter)
> +probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
> +		   filter_func_t filter)
>  {
> +	bool enabled = is_trace_uprobe_enabled(tu);
> +	struct event_file_link *link;
>  	int ret = 0;
> 
> -	if (is_trace_uprobe_enabled(tu))
> -		return -EINTR;
> +	if (file) {
> +		if (tu->flags & TP_FLAG_PROFILE)
> +			return -EINTR;
> +
> +		link = kmalloc(sizeof(*link), GFP_KERNEL);
> +		if (!link)
> +			return -ENOMEM;
> +
> +		link->file = file;
> +		list_add_tail_rcu(&link->list, &tu->files);
> +
> +		tu->flags |= TP_FLAG_TRACE;
> +	} else {
> +		if (tu->flags & TP_FLAG_TRACE)
> +			return -EINTR;
> +
> +		tu->flags |= TP_FLAG_PROFILE;
> +	}
> 
>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
> 
> -	tu->flags |= flag;
> -	tu->consumer.filter = filter;
> -	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> -	if (ret)
> -		tu->flags &= ~flag;
> +	/* we cannot call uprobe_register twice for same tu */
> +	if (!enabled) {
> +		tu->consumer.filter = filter;
> +		ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
> +	}
> +
> +	if (ret) {
> +		if (file) {
> +			list_del_rcu(&link->list);
> +			kfree(link);
> +			tu->flags &= ~TP_FLAG_TRACE;
> +		} else
> +			tu->flags &= ~TP_FLAG_PROFILE;
> +	}
> 
>  	return ret;
>  }
> 
> -static void probe_event_disable(struct trace_uprobe *tu, int flag)
> +static struct event_file_link *
> +find_event_file_link(struct trace_uprobe *tu, struct ftrace_event_file *file)
>  {
> -	if (!is_trace_uprobe_enabled(tu))
> -		return;
> +	struct event_file_link *link;
> +
> +	list_for_each_entry(link, &tu->files, list)
> +		if (link->file == file)
> +			return link;
> +
> +	return NULL;
> +}
> +
> +static void
> +probe_event_disable(struct trace_uprobe *tu, struct ftrace_event_file *file)
> +{
> +	if (file) {
> +		struct event_file_link *link;
> +
> +		link = find_event_file_link(tu, file);
> +		if (!link)
> +			return;
> +
> +		list_del_rcu(&link->list);
> +		/* synchronize with uprobe_trace_func/uretprobe_trace_func */
> +		synchronize_sched();
> +		kfree(link);
> +
> +		if (!list_empty(&tu->files))
> +			return;
> +	}
> 
>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
> 
>  	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
> -	tu->flags &= ~flag;
> +	tu->flags &= file ? ~TP_FLAG_TRACE : ~TP_FLAG_PROFILE;
>  }
> 
>  static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
> @@ -867,21 +945,22 @@ static
>  int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type, void *data)
>  {
>  	struct trace_uprobe *tu = event->data;
> +	struct ftrace_event_file *file = data;
> 
>  	switch (type) {
>  	case TRACE_REG_REGISTER:
> -		return probe_event_enable(tu, TP_FLAG_TRACE, NULL);
> +		return probe_event_enable(tu, file, NULL);
> 
>  	case TRACE_REG_UNREGISTER:
> -		probe_event_disable(tu, TP_FLAG_TRACE);
> +		probe_event_disable(tu, file);
>  		return 0;
> 
>  #ifdef CONFIG_PERF_EVENTS
>  	case TRACE_REG_PERF_REGISTER:
> -		return probe_event_enable(tu, TP_FLAG_PROFILE, uprobe_perf_filter);
> +		return probe_event_enable(tu, NULL, uprobe_perf_filter);
> 
>  	case TRACE_REG_PERF_UNREGISTER:
> -		probe_event_disable(tu, TP_FLAG_PROFILE);
> +		probe_event_disable(tu, NULL);
>  		return 0;
> 
>  	case TRACE_REG_PERF_OPEN:


