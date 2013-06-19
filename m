Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3FSPdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756641Ab3FSPdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:33:51 -0400
Date: Wed, 19 Jun 2013 17:28:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing/perf: perf_trace_buf/perf_xxx hacks.
Message-ID: <20130619152844.GA9176@redhat.com>
References: <20130618192147.GA19443@redhat.com> <20130619121039.GA19225@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619121039.GA19225@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Peter Zijlstra wrote:
>
> I'm probably missing something obviuos, but what are we trying to do?

Say, "perf record -e sched:sched_switch -p1".

Every task except /sbin/init will do perf_trace_sched_switch() and
perf_trace_buf_prepare() + perf_trace_buf_submit for no reason(),
it doesn't have a counter.

So it makes sense to add the fast-path check at the start of
perf_trace_##call(),

	if (hlist_empty(event_call->perf_events))
		return;

The problem is, we should not do this if __task != NULL (iow, if
DECLARE_EVENT_CLASS() uses __perf_task()), perf_tp_event() has the
additional code for this case.

So we should do

	if (!__task && hlist_empty(event_call->perf_events))
		return;

But __task is changed by "{ assign; }" block right before
perf_trace_buf_submit(). Too late for the fast-path check,
we already called perf_trace_buf_prepare/fetch_regs.

So. After 2/3 __perf_task() (and __perf_count/addr) is called
when ftrace_get_offsets_##call(args) evaluates the arguments,
and we can check !__task && hlist_empty() right after that.

Oleg.

