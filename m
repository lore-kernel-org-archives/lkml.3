Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3HAOip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:38:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab3HAOio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:38:44 -0400
Date: Thu, 1 Aug 2013 16:33:07 +0200
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
Message-ID: <20130801143307.GA12031@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <1375300192.5418.17.camel@gandalf.local.home> <20130731204003.GA30188@redhat.com> <1375310548.5418.21.camel@gandalf.local.home> <1375322866.5418.46.camel@gandalf.local.home> <1375325414.5418.50.camel@gandalf.local.home> <20130801133455.GB8703@redhat.com> <1375366669.1152.23.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375366669.1152.23.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Steven Rostedt wrote:
>
> On Thu, 2013-08-01 at 15:34 +0200, Oleg Nesterov wrote:
> > >
> > >   __unregister_trace_probe(tp);
> > >   list_del(&tp->list)
> > >   unregister_probe_event(tp) <-- fails!
> > >   free_trace_probe(tp)
> >
> > Yes. But again, this doesn't explain why unregister_probe_event()->
> > __trace_remove_event_call() can't simply proceed and
> > do ftrace_event_enable_disable() + remove_event_from_tracers().
>
> The problem is with the soft disable.

Exactly! This is another (also unlikely) race we need to prevent.

> so the
> i_private wont work.

Yes, and this is another reason why trace_remove_event_call() can't
always succeed, and the comment/changelog in probe_remove_event_call()
(added by the previous change) even tries to document the problems
with FL_SOFT_MODE.

> > IOW, if we do not apply the previous "trace_remove_event_call() should
> > fail if call/file is in use" patch, then everything is fine:
> >
> > > 				   write(fd, "0", 1)
> >
> > this will fail with ENODEV.
>
> Currently it does not, because the failure in probe_remove_event_call()
> due to the event being busy wont remove the event (event_remove() is
> never called). Thus the event is still alive and the write will still
> have access to it.

Yes, yes. That is why the changelog says "Both trace_kprobe.c/trace_uprobe.c
need the additional changes".

IOW, the previous change itself adds the new races fixed by this patch
(and the similar change in trace_uprobe.c). Hopefully this is fine because
the code is buggy anyway.

> I can update the change log to remove some of the functions that are
> being called to be less confusing.

I am fine either way. Just I wanted to be sure that we understand each
other and I didn't miss something.

> I agree, this isn't really nice, but for now we have to deal with it.

Yes, yes, this is not for 3.11.

Oleg.

