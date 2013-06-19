Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935004Ab3FSSRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934566Ab3FSSQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:16:58 -0400
Date: Wed, 19 Jun 2013 20:12:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tracing/perf: Avoid perf_trace_buf_*() in
	perf_trace_##call() when possible
Message-ID: <20130619181211.GA28363@redhat.com>
References: <20130618192218.GA19476@redhat.com> <1371585773.18733.45.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371585773.18733.45.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Steven Rostedt wrote:
>
> On Tue, 2013-06-18 at 21:22 +0200, Oleg Nesterov wrote:
> > @@ -663,6 +663,12 @@ perf_trace_##call(void *__data, proto)					\
> >  	int rctx;							\
> >  									\
> >  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> > +									\
> > +	head = this_cpu_ptr(event_call->perf_events);			\
> > +	if (__builtin_constant_p(!__task) && !__task &&			\
>
>
> I'm trying to wrap my head around this:
>
>   __builtin_constant_p(!task)
>
> is this the same as:
>
>   !__builtin_constant_p(task)
>
> Or is it the same as:
>
>   __builtin_constant_p(task)
>
> ?
>
> Because that '!' is confusing the heck out of me.
>
> If !task is a constant, wouldn't task be a constant too, and if task is
> not a constant then I would also assume !task is not a constant as well.

!__task looks more explicit/symmetrical to me. We need

	if (is_compile_time_true(!__task)) && list_empty)
		return;

is_compile_time_true(cond) could be defined as

	__builtin_constant_p(cond) && (cond)
or
	__builtin_constant_p(!cond) && (cond)

but the 1ts one looks more clean.

However,

> If this is the case, can we nuke the '!' from the builtin_consant_p().

OK, I do not really mind, will do.

And,

> Or is this your way to confuse me as much as my code has confused
> you? ;-)

Of course! this was the main reason.


Steven, I convinced myself the patch should be correct. If you agree with
this hack:

	- anything else I should do apart from the change above?

	- should I resend the previous "[PATCH 0/3] tracing: more
	  list_empty(perf_events) checks" series?

	  This series depends on "[PATCH 3/3] tracing/perf: Move the
	  PERF_MAX_TRACE_SIZE check into perf_trace_buf_prepare()".

	  Or I can drop this patch if you do not like it and rediff.

	  Just in case, there are other pending patches in trace_kprobe.c
	  which I am going to resend, but they are orthogonal.

Oleg.

