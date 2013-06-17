Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab3FQNwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:52:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab3FQNwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:52:34 -0400
Date: Mon, 17 Jun 2013 15:48:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tracing/kprobes: Avoid perf_trace_buf_*() if
	->perf_events is empty
Message-ID: <20130617134805.GA29246@redhat.com>
References: <20130616172146.GA8533@redhat.com> <51BE857A.1080505@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BE857A.1080505@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, zhangwei(Jovi) wrote:
>
> On 2013/6/17 1:21, Oleg Nesterov wrote:
> > perf_trace_buf_prepare() + perf_trace_buf_submit() make no sense
> > if this task/CPU has no active counters. Change kprobe_perf_func()
> > and kretprobe_perf_func() to check call->perf_events beforehand
> > and return if this list is empty.
> >
> > For example, "perf record -e some_probe -p1". Only /sbin/init will
> > report, all other threads which hit the same probe will do
> > perf_trace_buf_prepare/perf_trace_buf_submit just to realize that
> > nobody wants perf_swevent_event().
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Good point, I think we also need to change other places in below patch.
>
> After applied the patch, perf_tp_event() function call reduced a lots
> when using task based perf tracing.

Yes, I was going to do this, but this is not that simple.

> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -659,6 +659,10 @@ perf_trace_##call(void *__data, proto)					\
>  	int __data_size;						\
>  	int rctx;							\
>  									\
> +	head = this_cpu_ptr(event_call->perf_events);			\
> +	if (hlist_empty(head))						\
> +		return;							\
> +									\

This is not right. Please note __perf_task() and
"if (task && task != current)" in perf_tp_event().

Oleg.

