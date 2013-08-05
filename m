Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3HEQ4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3HEQ4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:56:36 -0400
Date: Mon, 5 Aug 2013 18:50:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Teach perf_trace_##call() to check
	hlist_empty(perf_events)
Message-ID: <20130805165034.GA6344@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for double post, forgot to cc lkml...

On 07/19, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Hello.
> >
> > The patches are the same, I only tried to update the changelogs a bit.
> > I am also quoting my old email below, to explain what this hack tries
> > to do.
> >
> > 	Say, "perf record -e sched:sched_switch -p1".
> >
> > 	Every task except /sbin/init will do perf_trace_sched_switch() and
> > 	perf_trace_buf_prepare() + perf_trace_buf_submit for no reason(),
> > 	it doesn't have a counter.
> >
> > 	So it makes sense to add the fast-path check at the start of
> > 	perf_trace_##call(),
> >
> > 		if (hlist_empty(event_call->perf_events))
> > 			return;
> >
> > 	The problem is, we should not do this if __task != NULL (iow, if
> > 	DECLARE_EVENT_CLASS() uses __perf_task()), perf_tp_event() has the
> > 	additional code for this case.
> >
> > 	So we should do
> >
> > 		if (!__task && hlist_empty(event_call->perf_events))
> > 			return;
> >
> > 	But __task is changed by "{ assign; }" block right before
> > 	perf_trace_buf_submit(). Too late for the fast-path check,
> > 	we already called perf_trace_buf_prepare/fetch_regs.
> >
> > 	So. After 2/3 __perf_task() (and __perf_count/addr) is called
> > 	when ftrace_get_offsets_##call(args) evaluates the arguments,
> > 	and we can check !__task && hlist_empty() right after that.
> >
> > Oleg.
>
> Nice improvement.
>
> Peter, Steve, any objections?

Ingo,

It seems that everybody agree with this hack but it was forgotten,
let me resend it again.

The only change is that I added the following tags:

	Tested-by: David Ahern <dsahern@gmail.com>
	Reviewed-and-Acked-by: Steven Rostedt <rostedt@goodmis.org>

Oleg.

 include/trace/events/sched.h |   22 ++++++++--------------
 include/trace/ftrace.h       |   33 ++++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 27 deletions(-)

