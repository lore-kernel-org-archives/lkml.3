Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934493Ab3GSHns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:43:48 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:48758 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934280Ab3GSHnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:43:43 -0400
Date: Fri, 19 Jul 2013 09:43:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] Teach perf_trace_##call() to check
 hlist_empty(perf_events)
Message-ID: <20130719074339.GA22597@gmail.com>
References: <20130718183018.GA4043@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718183018.GA4043@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Hello.
> 
> The patches are the same, I only tried to update the changelogs a bit.
> I am also quoting my old email below, to explain what this hack tries
> to do.
> 
> 	Say, "perf record -e sched:sched_switch -p1".
> 
> 	Every task except /sbin/init will do perf_trace_sched_switch() and
> 	perf_trace_buf_prepare() + perf_trace_buf_submit for no reason(),
> 	it doesn't have a counter.
> 
> 	So it makes sense to add the fast-path check at the start of
> 	perf_trace_##call(),
> 
> 		if (hlist_empty(event_call->perf_events))
> 			return;
> 
> 	The problem is, we should not do this if __task != NULL (iow, if
> 	DECLARE_EVENT_CLASS() uses __perf_task()), perf_tp_event() has the
> 	additional code for this case.
> 
> 	So we should do
> 
> 		if (!__task && hlist_empty(event_call->perf_events))
> 			return;
> 
> 	But __task is changed by "{ assign; }" block right before
> 	perf_trace_buf_submit(). Too late for the fast-path check,
> 	we already called perf_trace_buf_prepare/fetch_regs.
> 
> 	So. After 2/3 __perf_task() (and __perf_count/addr) is called
> 	when ftrace_get_offsets_##call(args) evaluates the arguments,
> 	and we can check !__task && hlist_empty() right after that.
> 
> Oleg.

Nice improvement.

Peter, Steve, any objections?

Thanks,

	Ingo
