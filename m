Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab3GDHld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:41:33 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60699 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3GDHlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:41:16 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-c9-51d5271ab0d2
From: Namhyung Kim <namhyung@kernel.org>
To: "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v5 typo updated] tracing/uprobes: Support ftrace_event_file base multibuffer
References: <51D51BF7.1000602@huawei.com> <51D51DB6.6020701@huawei.com>
Date: Thu, 04 Jul 2013 16:41:14 +0900
In-Reply-To: <51D51DB6.6020701@huawei.com> (zhangwei's message of "Thu, 4 Jul
	2013 15:01:10 +0800")
Message-ID: <87ppuyzs9x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jovi,

Just a few of dummy questions..


On Thu, 4 Jul 2013 15:01:10 +0800, zhangwei wrote:
> Support multi-buffer on uprobe-based dynamic events by
> using ftrace_event_file.
>
> This patch is based kprobe-based dynamic events multibuffer
> support work initially, commited by Masami(commit 41a7dd420c),
> but revised as below:
>
> Oleg changed the kprobe-based multibuffer design from
> array-pointers of ftrace_event_file into simple list,
> so this patch also change to the list design.
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

So why does this limitation exist?  Didn't we support this kind of thing
in the original code?

>
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
[SNIP]
> +	rcu_read_lock();
> +	list_for_each_entry(link, &tu->files, list)

list_for_each_entry_rcu() ?


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

Ditto.


> +		uprobe_trace_print(tu, func, regs, link->file);
> +	rcu_read_unlock();
>  }
[SNIP]
> -static void probe_event_disable(struct trace_uprobe *tu, int flag)
> +static struct event_file_link *
> +find_event_file_link(struct trace_uprobe *tu, struct ftrace_event_file *file)
> +{
> +	struct event_file_link *link;
> +
> +	list_for_each_entry(link, &tu->files, list)

Not sure of this case. ;)

Thanks,
Namhyung

> +		if (link->file == file)
> +			return link;
> +
> +	return NULL;
> +}
> +
> +static void
> +probe_event_disable(struct trace_uprobe *tu, struct ftrace_event_file *file)
>  {
>  	if (!is_trace_uprobe_enabled(tu))
>  		return;
>
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
> +
>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
>
>  	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
> -	tu->flags &= ~flag;
> +	tu->flags &= file ? ~TP_FLAG_TRACE : ~TP_FLAG_PROFILE;
>  }
>
>  static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
> @@ -867,21 +947,22 @@ static
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
> -- 1.7.9.7
