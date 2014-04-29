Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997AbaD2TBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:01:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:60085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaD2TBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:01:12 -0400
Date: Tue, 29 Apr 2014 21:01:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140429190108.GB30445@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
 <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net>
 <20140418171516.GR13658@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
 <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 02:21:56PM -0400, Vince Weaver wrote:
> On Tue, 29 Apr 2014, Peter Zijlstra wrote:
> 
> > > Event #16 is a SW event created and running in the parent on CPU0.
> > 
> > A regular software one, right? Not a timer one.
> 
> Maybe.  From traces I have it looks like it's a regular one (i.e. calls 
>  perf_swevent_add() ) but who knows at this point.
> 
> When I actually got a trace with perf_event_open() instrumented to print 
> some attr values it looked like things were being caused by
> PERF_COUNT_SW_TASK_CLOCK which makes no sense.
> 
> > > CPU6 (child) shutting down.
> > >    last user of event #16
> > >    perf_release() called on event
> > >    which eventually calls event_sched_out()
> > >    which calls pmu->del which removes event from swevent_htable
> > >    *but only on CPU6*
> > 
> > So on fork() we'll also clone the counter; after which there's two. One
> > will run on each task.
> 
> even if inherit isn't set?

Fair point, nope not in that case. If you can trigger this without ever
using .inherit=1 this would exclude a lot of funny code.

> > Because of a context switch optimization they can actually flip around
> > (the below patch disables that).
> 
> ENOPATCH?

urgh.. fail.


diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5129b1201050..0d6a58950a3b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2293,6 +2291,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	if (!cpuctx->task_ctx)
 		return;
 
+#if 0
 	rcu_read_lock();
 	next_ctx = next->perf_event_ctxp[ctxn];
 	if (!next_ctx)
@@ -2335,6 +2334,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	}
 unlock:
 	rcu_read_unlock();
+#endif
 
 	if (do_switch) {
 		raw_spin_lock(&ctx->lock);

> > quite the puzzle this one
> 
> yes.
> 
> I'm tediously working on trying to get a good trace of this happening.
> 
> I have a random seed that will trigger the bug in the fuzzer around 1 time 
> in 10.
> 
> Unfortunately many of the times it crashes so hard/quickly there's no 
> chance of getting the trace data (dump trace on oops never holds enough 
> state, and often the fuzzing triggers its own random trace events that 
> clutter those logs).
> 
> Also trace-cmd is a pain to use.  Any suggested events I should trace 
> beyond the obvious?

I've never used trace-cmd :/ What I do in the crashing hard case is try
and make dump_ftrace_on_oops work, although capturing a full trace
buffer over serial is exceedingly painful -- maxcpus= might work if you
have too many CPUs, I forgot.

Anyway, I can make the fuzzer to weird shit, but it doesn't look like
the thing you're seeing, but who knows.
