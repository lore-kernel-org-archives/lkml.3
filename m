Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3HAORy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:17:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3HAORw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:17:52 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0VS4G58IZu0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=laNjaRT52OkA:10 a=Qeugz8wW8wP0j5rNREwA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375366669.1152.23.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
 event files are open
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 01 Aug 2013 10:17:49 -0400
In-Reply-To: <20130801133455.GB8703@redhat.com>
References: <20130704033347.807661713@goodmis.org>
	 <20130704034038.819592356@goodmis.org>
	 <1375300192.5418.17.camel@gandalf.local.home>
	 <20130731204003.GA30188@redhat.com>
	 <1375310548.5418.21.camel@gandalf.local.home>
	 <1375322866.5418.46.camel@gandalf.local.home>
	 <1375325414.5418.50.camel@gandalf.local.home>
	 <20130801133455.GB8703@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 15:34 +0200, Oleg Nesterov wrote:
> On 07/31, Steven Rostedt wrote:
> >
> > Subject: [PATCH] tracing/kprobes: Fail to unregister if probe event files are
> >  in use
> >
> > When a probe is being removed, it cleans up the event files that correspond
> > to the probe. But there is a race between writing to one of these files
> > and deleting the probe. This is especially true for the "enable" file.
> >
> > 	CPU 0				CPU 1
> > 	-----				-----
> >
> > 				  fd = open("enable",O_WRONLY);
> >
> >   probes_open()
> >   release_all_trace_probes()
> >   unregister_trace_probe()
> >   if (trace_probe_is_enabled(tp))
> > 	return -EBUSY
> >
> > 				   write(fd, "1", 1)
> > 				   __ftrace_set_clr_event()
> > 				   call->class->reg()
> > 				    (kprobe_register)
> > 				     enable_trace_probe(tp)
> >
> >   __unregister_trace_probe(tp);
> >   list_del(&tp->list)
> >   unregister_probe_event(tp) <-- fails!
> >   free_trace_probe(tp)
> 
> Yes. But again, this doesn't explain why unregister_probe_event()->
> __trace_remove_event_call() can't simply proceed and
> do ftrace_event_enable_disable() + remove_event_from_tracers().

The problem is with the soft disable. We would have to look at what
functions have been attached to soft enable this event and remove them.
This can become quite complex. When the function is hit, it will try to
access the event call file. There's no inode associated to that, so the
i_private wont work. The answer would be to actually remove the
functions that are referencing it. See event_enable_probe() and
event_enable_count_probe(). The problem is that these are called from
the function tracer which means it can not take *any* locks.

This will become exponentially more complex when Tom Zanussi's patches
make it in that have events enabling other events and also using the
soft enable too.

This means that if we fail to disable, we must not destroy the event.

We may be able to start adding ref counts, such that it doesn't get
freed till it goes to zero, but every user will see it "not existing".
But that will take a bit of work to do and not for 3.11.

> 
> IOW, if we do not apply the previous "trace_remove_event_call() should
> fail if call/file is in use" patch, then everything is fine:
> 
> 
> > 				   write(fd, "0", 1)
> 
> this will fail with ENODEV.

Currently it does not, because the failure in probe_remove_event_call()
due to the event being busy wont remove the event (event_remove() is
never called). Thus the event is still alive and the write will still
have access to it.

> 
> Let's consider another race:
> 
> 	CPU 0					CPU 1
> 	-----					-----
> 
> 	probes_open()
> 	trace_probe_is_enabled() == F;
> 
> 						sys_perf_event_open(attr.config == id)
> 
> 
> 	...
> 	trace_remove_event_call()
> 
> Whatever we do, we should abort. We could even do TRACE_REG_PERF_UNREGISTER
> (although the current code doesn't do this), but we have no way to cleanup
> the perf event's which have ->>tp_event = call.
> 
> trace_remove_event_call() was already changed to return the error.

Right, and that's what this patch is about. The bug is that
trace_remove_event_call() returns an error which makes
unregister_probe_event() fail silently, which means that there's still a
reference to the tp and the write (which does happen) references it.

> 
> And. Since it can fail, this obviously means that it should be checked,
> we can't blindly do free_trace_probe().

Right! That's what this patch does :-)

What you showed is the same race with perf as I have tested with ftrace.

> 
> IOW, the changelog could be very simple, I think. Either
> trace_remove_event_call() should always succeed or we should check the
> possible failure.

I can update the change log to remove some of the functions that are
being called to be less confusing.

> 
> But I won't argue with this changelog. The only important thing is that
> we all seem to agree that we do have the races here which can be fixed
> by this and the previous change.
> 
> And just in case. I believe that the patch is fine.

OK, I'm currently running this through my tests. I'm hoping to get an
Acked-by from Srikar for uprobes. Time is running out for 3.11.

> 
> Just one off-topic note,
> 
> > @@ -632,7 +635,9 @@ static int release_all_trace_probes(void)
> >  	/* TODO: Use batch unregistration */
> >  	while (!list_empty(&probe_list)) {
> >  		tp = list_entry(probe_list.next, struct trace_probe, list);
> > -		unregister_trace_probe(tp);
> > +		ret = unregister_trace_probe(tp);
> > +		if (ret)
> > +			goto end;
> >  		free_trace_probe(tp);
> >  	}
> 
> This obviously breaks all-or-nothing semantics (I mean, this breaks
> the intent, the current code is buggy).
> 

I agree, this isn't really nice, but for now we have to deal with it.

> I think we can't avoid this, and I hope this is fine. But then perhaps
> we should simply remove the "list_for_each_entry" check above?

I think this can be pushed for 3.12 to fix.

Thanks,

-- Steve


