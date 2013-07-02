Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3GBVm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:42:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab3GBVm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:42:56 -0400
Date: Tue, 2 Jul 2013 23:38:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH? trace_remove_event_call() should fail if call is active
Message-ID: <20130702213808.GA24757@redhat.com>
References: <20130625172359.GA8523@redhat.com> <20130626185205.GA27894@redhat.com> <51CBEE3E.70103@hitachi.com> <20130627161716.GA17889@redhat.com> <51CCF8BA.4030601@hitachi.com> <20130628180946.GA30838@redhat.com> <51D16E1D.5040904@hitachi.com> <20130702190037.GA6289@redhat.com> <20130702193425.GA8813@redhat.com> <1372799087.22688.58.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372799087.22688.58.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Steven Rostedt wrote:
>
> On Tue, 2013-07-02 at 21:34 +0200, Oleg Nesterov wrote:
> >
> > To simplify, lets ignore trace_module_remove_events() which calls
> > __trace_remove_event_call() too, although at first glance this
> > case should be fine too.
>
> We can't ignore modules. If it fails to be removed, then it will leak
> memory.

Ah, but I only meant "ignore for the moment", to simplify the discussion.
We can add the "force" argument for trace_module_remove_events(), or
we can add another do_for_each_event_file/FTRACE_EVENT_FL_ENABLED loop
into trace_remove_event_call() before __trace_remove_event_call().
This is trivial.

So please ignore modules ;)

> > It really seems to me that trace_remove_event_call() should not
> > succeed if this ftrace_event_call is "active". Even if we forget
> > about perf, ftrace_event_enable_disable(file, 0) doesn't guarantee
> > reg(call, TRACE_REG_UNREGISTER) if SOFT_MODE is set.
> >
> >
> >
> > If something like this patch can work then we can fix trace_kprobe.
> > unregister_trace_probe() can do unregister_probe_event() first and
> > abort if trace_remove_event_call() fails.
> >
> > As for release_all_trace_probes(), we lose the all-or-nothing
> > semantics, but probably this is fine.
> >
> > Or I misunderstood this logic completely?
>
> I'm actually worried about this change.

Me too.

But again. Any reason trace_remove_event_call() should succeed if
this this ftrace_event_call is active?

> But what if we simply add a new event file flag called
> FTRACE_EVENT_FL_SHUTDOWN. Which will not allow the event to be enabled
> anymore. What do you think about this patch?

It is too late for me to even try to read this patch...

But at first glance, how this patch can protect from the subsequent
perf_trace_event_open/perf_trace_add which can use this ->tp_event?

> We set the SHUTDOWN flag, which is done under the event_mutex, and then
> we can check the trace_probe_is_enabled(), as that gets set under the
> event_mutex, and only if the SHUTDOWN flag was not previously set. If we
> fail, then we just re-enable the event and return.

Heh. As a from-time-to-time reader of this code I am not worried ;)
This doesn't look simple. And if nothing else FL_SHUTDOWN doesn't
cover perf_trace_init() ?

Oleg.

