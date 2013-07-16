Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933863Ab3GPT1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933148Ab3GPT1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:27:35 -0400
Date: Tue, 16 Jul 2013 21:22:00 +0200
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
Subject: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
	opening probe event files and deleting probe
Message-ID: <20130716192200.GA21716@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130715180149.GA15821@redhat.com> <20130716163804.GA30560@redhat.com> <1374001825.6458.44.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374001825.6458.44.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16, Steven Rostedt wrote:
>
> On Tue, 2013-07-16 at 18:38 +0200, Oleg Nesterov wrote:
> > On 07/15, Oleg Nesterov wrote:
> > >
> > > So. As Masami pointed out, this is not enough. Probably we can add more
> > > hacks, but I'd like to discuss the alternative approach.
> > >
> > > Note also that this ref count has the unfortunate property, if someone
> > > keeps the file opened we can't remove an event.
> >
> > And please correct me, but afaics there are similar problems with
> > rmdir instances/xxx.
>
> The instances have their own refcount. And if a file is open, it wont
> remove the directory. Just try it...

I guess you mean "if (tr->ref)" check.

But tracing_open_generic_file()->trace_array_get() is racy, no?
Somehow we need to ensure it is safe to use file / file->tr.

> > > Question: why event_enable_write() needs trace_array_get() ?
> >
> > probably it doesn't...
>
> I'm confused. Which code has event_enable_write doing a
> trace_array_get()?

I meant tracing_open_generic_file(), sorry. I _think_ it can die,
please see RFC I sent.

But let me repeat once again, I do not pretend I understand this
code ;)

> I need to sort these patches out. They are all over the place. What
> exactly do we have for a solution here. Did we figure out which patches
> are needed?

Well, see above. But I think:

	1. We should close open/delete races

	2. We still need probe_remove_event_call() which return -EBUSY
	   if perf_refcount || FTRACE_EVENT_FL_ENABLED

	   2/4 in your series but without TRACE_EVENT_FL_REF_MASK check

	3. We need the changes in trace_kprobes.c (and uprobes but lets
	   ignore it for now). The patch from you (3/4) and another one
	   from Masami (Wait for disabling all running kprobe handlers).

	   However, I think it would be better to discuss 3. later.

Btw, Steven, what about other pending (and orthogonal changes) ?
>From Jovi, from me. I see nothing new in linux-trace.git#for-next...

Oleg.

