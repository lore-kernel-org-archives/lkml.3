Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaBUSyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:54:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:37392 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750814AbaBUSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:54:00 -0500
Date: Fri, 21 Feb 2014 13:53:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [RFC][PATCH 4/4] perf/events: Use helper functions in event
 assignment to shrink macro size
Message-ID: <20140221135358.2e04106a@gandalf.local.home>
In-Reply-To: <20140212195827.GA6835@laptop.programming.kicks-ass.net>
References: <20140206173910.029355947@goodmis.org>
	<20140206181109.376046894@goodmis.org>
	<20140212195827.GA6835@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014 20:58:27 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> > +void *perf_trace_event_setup(struct ftrace_event_call *event_call, 
> > +			     struct perf_trace_event *pe)
> > +{
> > +	pe->head = this_cpu_ptr(event_call->perf_events);
> > +	if (pe->constant && hlist_empty(pe->head))
> > +		return NULL;
> > +
> > +	pe->entry_size = ALIGN(pe->entry_size + sizeof(u32), sizeof(u64));
> > +	pe->entry_size -= sizeof(u32);
> > +	pe->event_call = event_call;
> > +
> > +	perf_fetch_caller_regs(&pe->regs);
> 
> I think this one is wrong, we're getting the wrong caller now.

Ah, I didn't see the magic CALLER_ADDR() usage there. I guess I could
pass that into this function too. But I think you had a fix for this,
so I'll wait.


> 
> > +	pe->entry = perf_trace_buf_prepare(pe->entry_size,
> > +			event_call->event.type, &pe->regs, &pe->rctx);
> > +	return pe->entry;
> > +}
> > +EXPORT_SYMBOL_GPL(perf_trace_event_setup);
> 
> 
> > +void perf_trace_event_submit(struct perf_trace_event *pe)
> > +{
> > +	perf_trace_buf_submit(pe->entry, pe->entry_size, pe->rctx, pe->addr,
> > +			      pe->count, &pe->regs, pe->head, pe->task);
> > +}
> > +EXPORT_SYMBOL_GPL(perf_trace_event_submit);
> 
> This is ridiculous, perf_trace_buf_submit() is already a pointless
> wrapper, which you now wrap moar...

I did a couple of git greps and found this:

$ git grep perf_trace_buf_submit
include/linux/ftrace_event.h:perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
include/trace/ftrace.h: perf_trace_buf_submit(entry, __entry_size, rctx, __addr,        \
kernel/trace/trace_event_perf.c:        perf_trace_buf_submit(entry, ENTRY_SIZE, rctx, 0,
kernel/trace/trace_kprobe.c:    perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
kernel/trace/trace_kprobe.c:    perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
kernel/trace/trace_syscalls.c:  perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
kernel/trace/trace_syscalls.c:  perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
kernel/trace/trace_uprobe.c:    perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);


$ git grep perf_tp_event
include/linux/ftrace_event.h:   perf_tp_event(addr, count, raw_data, size, regs, head, rctx, task);
include/linux/perf_event.h:extern void perf_tp_event(u64 addr, u64 count, void *record,
kernel/events/core.c:static int perf_tp_event_match(struct perf_event *event,
kernel/events/core.c:void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
kernel/events/core.c:           if (perf_tp_event_match(event, &data, regs))
kernel/events/core.c:                   if (perf_tp_event_match(event, &data, regs))
kernel/events/core.c:EXPORT_SYMBOL_GPL(perf_tp_event);
kernel/events/core.c:static int perf_tp_event_init(struct perf_event *event)
kernel/events/core.c:   .event_init     = perf_tp_event_init,


As perf_tp_event() is only used internally, should we just rename it to
perf_trace_buf_submit, and remove the static inline of it?



> 
> It would be nice if we could reduce the api clutter a little and keep
> this and the [ku]probe/syscall sites similar.

Yeah, looks like this can have a bigger clean up.

I think I'll just put my first three patches in my 3.15 queue, and we
can work on fixing the perf code for 3.16.

-- Steve
