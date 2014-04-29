Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbaD2Jqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:46:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:57683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbaD2Jqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:46:37 -0400
Date: Tue, 29 Apr 2014 11:46:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140429094632.GP27561@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu>
 <20140417145418.GM11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu>
 <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net>
 <20140418171516.GR13658@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 03:38:38PM -0400, Vince Weaver wrote:
> 
> OK, this is my current theory as to what's going on.  I'd appreciate any 
> comments.
> 
> 
> We have an event, let's call it #16.
> 
> Event #16 is a SW event created and running in the parent on CPU0.

A regular software one, right? Not a timer one.

> CPU0 (parent): calls fork()
> 
> CPU6 (child): SW Event #16 is still running on CPU0 but is visible
> 	on CPU6 because the fd passed through with fork
> 
> CPU0 (parent) close #16.  Event not deallocated because
>         still visible in child
> 
> CPU0 (parent) kill child

OK so far..

> CPU6 (child) shutting down.
>    last user of event #16
>    perf_release() called on event
>    which eventually calls event_sched_out()
>    which calls pmu->del which removes event from swevent_htable
>    *but only on CPU6*

So on fork() we'll also clone the counter; after which there's two. One
will run on each task.

Because of a context switch optimization they can actually flip around
(the below patch disables that).

So there's (possibly) two events being killed here:

 1) the event that is attached to the child process, it will be detached
 and freed. do_exit() -> perf_event_exit_task() ->
 perf_event_exit_task_context() -> __perf_event_exit_task()

 If this is the cloned event, it will put the original event and be
 freed here.

 If the child ran the cloned event; then:
 2) the closing of the fd, coupled with the put of 1) will drop the
 refcount of the original event to 0 and it too will be removed and
 freed.

IF however the original and cloned events were flipped at the time; the
child exit will detach the original event, but since the parent will
still have a cloned event attached, the clone will keep the event alive.

In this case no events will be freed until the parent too exits; at
which point the cloned event will get detached and freed. That will put
the last reference on the actual event, and that too will go.


Now, seeing that you actually see an event getting freed, we'll have to
assume the former situation, where the original event is on the parent
process and the cloned event is on the child process.

> **** some sort of race happens with CPU0 (possibly with 
> 	event_sched_in() and event->state==PERF_EVENT_STATE_INACTIVE)
> 	That has event #16 in the cpu0 swevent_htable but not
> 	freed the next time ctx_sched_out() happens ****

So on do_exit(), exit_files() happens first, it will drop the refcount
of the original event to 1.

After that, perf_event_exit_task() happens, it will (as per the
callchain above) end up in __perf_event_exit_task().

__perf_event_exit_task() will call perf_group_detach, however no groups
involved here afaik, so that's quickly done.

It will then call perf_remove_from_context() which will try to
deschedule (which is likely already done by
perf_event_exit_task_context() which de-schedules the entire context in
one go), and then remove the event from the context.

Since it is the cloned event; it will then call sync_child_event(),
whicih will push whatever counts it has gathered into the original
(parent) event, and detach itself from the parent.

This will have done put_event(parent_event), which will drop the
refcount of the original event to 0. put_event() will in turn call the
same things: perf_group_detach() -- no groups, done quickly.
perf_remove_from_context(), this will IPI from CPU6 to CPU0, and
deschedule the original event, calling ->del() on CPU0, and as per the
above continue doing list_del_event() detaching itself from the context.

After the IPI put_event() will continue with _free_event() and we'll
call ->destroy() and call_rcu and the event will be no more.

After all that, the child continues calling free_event() which will also
call ->desotry() (but on the child event) and do the same call_rcu()
also freeing this event.

Nothing left.

> CPU6 (idle) grace period expires, kfree happens
> 
> the CPU0 hlist still has in the list the now freed (and poisoned)
>   event which causes problems, especially as new events added to
>   the list over-write bytes starting at 0x48 with pprev values.

Right, so clearly something's gone funny.. above you speculate on a race
against event_sched_in(), but both paths serialize on event->ctx->lock.

__perf_remove_from_context() takes ctx->lock, as do the sched_in/out
paths.

quite the puzzle this one
