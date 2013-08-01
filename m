Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3HANkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:40:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab3HANkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:40:41 -0400
Date: Thu, 1 Aug 2013 15:34:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
	event files are open
Message-ID: <20130801133455.GB8703@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <1375300192.5418.17.camel@gandalf.local.home> <20130731204003.GA30188@redhat.com> <1375310548.5418.21.camel@gandalf.local.home> <1375322866.5418.46.camel@gandalf.local.home> <1375325414.5418.50.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375325414.5418.50.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Steven Rostedt wrote:
>
> Subject: [PATCH] tracing/kprobes: Fail to unregister if probe event files are
>  in use
>
> When a probe is being removed, it cleans up the event files that correspond
> to the probe. But there is a race between writing to one of these files
> and deleting the probe. This is especially true for the "enable" file.
>
> 	CPU 0				CPU 1
> 	-----				-----
>
> 				  fd = open("enable",O_WRONLY);
>
>   probes_open()
>   release_all_trace_probes()
>   unregister_trace_probe()
>   if (trace_probe_is_enabled(tp))
> 	return -EBUSY
>
> 				   write(fd, "1", 1)
> 				   __ftrace_set_clr_event()
> 				   call->class->reg()
> 				    (kprobe_register)
> 				     enable_trace_probe(tp)
>
>   __unregister_trace_probe(tp);
>   list_del(&tp->list)
>   unregister_probe_event(tp) <-- fails!
>   free_trace_probe(tp)

Yes. But again, this doesn't explain why unregister_probe_event()->
__trace_remove_event_call() can't simply proceed and
do ftrace_event_enable_disable() + remove_event_from_tracers().

IOW, if we do not apply the previous "trace_remove_event_call() should
fail if call/file is in use" patch, then everything is fine:


> 				   write(fd, "0", 1)

this will fail with ENODEV.

Let's consider another race:

	CPU 0					CPU 1
	-----					-----

	probes_open()
	trace_probe_is_enabled() == F;

						sys_perf_event_open(attr.config == id)


	...
	trace_remove_event_call()

Whatever we do, we should abort. We could even do TRACE_REG_PERF_UNREGISTER
(although the current code doesn't do this), but we have no way to cleanup
the perf event's which have ->>tp_event = call.

trace_remove_event_call() was already changed to return the error.

And. Since it can fail, this obviously means that it should be checked,
we can't blindly do free_trace_probe().

IOW, the changelog could be very simple, I think. Either
trace_remove_event_call() should always succeed or we should check the
possible failure.

But I won't argue with this changelog. The only important thing is that
we all seem to agree that we do have the races here which can be fixed
by this and the previous change.

And just in case. I believe that the patch is fine.

Just one off-topic note,

> @@ -632,7 +635,9 @@ static int release_all_trace_probes(void)
>  	/* TODO: Use batch unregistration */
>  	while (!list_empty(&probe_list)) {
>  		tp = list_entry(probe_list.next, struct trace_probe, list);
> -		unregister_trace_probe(tp);
> +		ret = unregister_trace_probe(tp);
> +		if (ret)
> +			goto end;
>  		free_trace_probe(tp);
>  	}

This obviously breaks all-or-nothing semantics (I mean, this breaks
the intent, the current code is buggy).

I think we can't avoid this, and I hope this is fine. But then perhaps
we should simply remove the "list_for_each_entry" check above?

Oleg.

