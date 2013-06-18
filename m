Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab3FRUC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:02:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab3FRUC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:02:56 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=zqzIAArZTo8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6_eBa1HtGUEA:10 a=20KFwNOVAAAA:8 a=xF0oAQwB3HhRFHxWpigA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371585773.18733.45.camel@gandalf.local.home>
Subject: Re: [PATCH 3/3] tracing/perf: Avoid perf_trace_buf_*() in
 perf_trace_##call() when possible
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Jun 2013 16:02:53 -0400
In-Reply-To: <20130618192218.GA19476@redhat.com>
References: <20130618192218.GA19476@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 21:22 +0200, Oleg Nesterov wrote:
> perf_trace_buf_prepare() + perf_trace_buf_submit(task => NULL)
> make no sense if hlist_empty(head). Change perf_trace_##call()
> to check ->perf_events beforehand and do nothing if it is empty.
> 
> However, we can only do this if __task == NULL, so we also add
> the __builtin_constant_p(__task) check.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/trace/ftrace.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 8886877..04455b8 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -663,6 +663,12 @@ perf_trace_##call(void *__data, proto)					\
>  	int rctx;							\
>  									\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> +									\
> +	head = this_cpu_ptr(event_call->perf_events);			\
> +	if (__builtin_constant_p(!__task) && !__task &&			\


I'm trying to wrap my head around this:

  __builtin_constant_p(!task)

is this the same as:

  !__builtin_constant_p(task)

Or is it the same as:

  __builtin_constant_p(task)

?

Because that '!' is confusing the heck out of me.

If !task is a constant, wouldn't task be a constant too, and if task is
not a constant then I would also assume !task is not a constant as well.

If this is the case, can we nuke the '!' from the builtin_consant_p().
The code is confusing enough as is. Or is it that the code is very
confusing and in keeping with the coding style, you are trying to come
up with new ways of adding to the confusion.

Or is this your way to confuse me as much as my code has confused
you? ;-)

-- Steve

> +				hlist_empty(head))			\
> +		return;							\
> +									\
>  	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
>  			     sizeof(u64));				\
>  	__entry_size -= sizeof(u32);					\
> @@ -677,7 +683,6 @@ perf_trace_##call(void *__data, proto)					\
>  									\
>  	{ assign; }							\
>  									\
> -	head = this_cpu_ptr(event_call->perf_events);			\
>  	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
>  		__count, &__regs, head, __task);			\
>  }


