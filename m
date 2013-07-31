Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597Ab3GaUpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab3GaUpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:45:39 -0400
Date: Wed, 31 Jul 2013 22:40:03 +0200
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
Message-ID: <20130731204003.GA30188@redhat.com>
References: <20130704033347.807661713@goodmis.org> <20130704034038.819592356@goodmis.org> <1375300192.5418.17.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375300192.5418.17.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Steven Rostedt wrote:
>
> On Wed, 2013-07-03 at 23:33 -0400, Steven Rostedt wrote:
> > The above will corrupt the kprobe system, as the write to the enable
> > file will happen after the kprobe was deleted.
>
> Oleg,
>
> The above no longer triggers the bug due to your changes. The race is
> much tighter now

Yes, the changelog should be updated...

> and requires a process with the enable file opened and
> races with a write to enable it where the removal of the trace file
> checks the trace disabled, sees that it is, continues, but then the
> write enables it just as it gets deleted.

This should be fine. Either event_remove() path takes event_mutex
first and then ->write() fails, or ftrace_event_enable_disable()
actually disables this even successfully.

> Do you know of a way to trigger this bug?

I'll try to think more tomorrow, but most probably no. The race is
unlikely.

We need perf_trace_event_init() or ":enable_event:this-event" right
before trace_remove_event_call() takes the mutex.

And right after the caller (kprobes) checks "disabled".

> Hmm, what happens without this patch now? If it is active, and we delete
> it? It will call back into the kprobes and access a tracepoint that does
> not exist? Would this cause a crash?

I think yes, the crash is possible.

perf or FL_SOFT_MODE, this call/file has the external references, and
we are going to free it.

Oleg.

