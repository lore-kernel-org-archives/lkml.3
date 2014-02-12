Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaBLT65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:58:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48783 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaBLT6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:58:55 -0500
Date: Wed, 12 Feb 2014 20:58:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [RFC][PATCH 4/4] perf/events: Use helper functions in event
 assignment to shrink macro size
Message-ID: <20140212195827.GA6835@laptop.programming.kicks-ass.net>
References: <20140206173910.029355947@goodmis.org>
 <20140206181109.376046894@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206181109.376046894@goodmis.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void *perf_trace_event_setup(struct ftrace_event_call *event_call, 
> +			     struct perf_trace_event *pe)
> +{
> +	pe->head = this_cpu_ptr(event_call->perf_events);
> +	if (pe->constant && hlist_empty(pe->head))
> +		return NULL;
> +
> +	pe->entry_size = ALIGN(pe->entry_size + sizeof(u32), sizeof(u64));
> +	pe->entry_size -= sizeof(u32);
> +	pe->event_call = event_call;
> +
> +	perf_fetch_caller_regs(&pe->regs);

I think this one is wrong, we're getting the wrong caller now.

> +	pe->entry = perf_trace_buf_prepare(pe->entry_size,
> +			event_call->event.type, &pe->regs, &pe->rctx);
> +	return pe->entry;
> +}
> +EXPORT_SYMBOL_GPL(perf_trace_event_setup);


> +void perf_trace_event_submit(struct perf_trace_event *pe)
> +{
> +	perf_trace_buf_submit(pe->entry, pe->entry_size, pe->rctx, pe->addr,
> +			      pe->count, &pe->regs, pe->head, pe->task);
> +}
> +EXPORT_SYMBOL_GPL(perf_trace_event_submit);

This is ridiculous, perf_trace_buf_submit() is already a pointless
wrapper, which you now wrap moar...

It would be nice if we could reduce the api clutter a little and keep
this and the [ku]probe/syscall sites similar.
