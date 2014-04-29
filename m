Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbaD2SSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:18:24 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:43088 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612AbaD2SSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:18:23 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 29 Apr 2014 14:21:56 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140429094632.GP27561@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1404171037590.22226@vincent-weaver-1.um.maine.edu> <20140417145418.GM11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404181042320.26918@vincent-weaver-1.um.maine.edu> <20140418152314.GY11182@twins.programming.kicks-ass.net>
 <20140418165958.GQ13658@twins.programming.kicks-ass.net> <20140418171516.GR13658@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404231643420.30955@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Peter Zijlstra wrote:

> > Event #16 is a SW event created and running in the parent on CPU0.
> 
> A regular software one, right? Not a timer one.

Maybe.  From traces I have it looks like it's a regular one (i.e. calls 
 perf_swevent_add() ) but who knows at this point.

When I actually got a trace with perf_event_open() instrumented to print 
some attr values it looked like things were being caused by
PERF_COUNT_SW_TASK_CLOCK which makes no sense.

> > CPU6 (child) shutting down.
> >    last user of event #16
> >    perf_release() called on event
> >    which eventually calls event_sched_out()
> >    which calls pmu->del which removes event from swevent_htable
> >    *but only on CPU6*
> 
> So on fork() we'll also clone the counter; after which there's two. One
> will run on each task.

even if inherit isn't set?

> Because of a context switch optimization they can actually flip around
> (the below patch disables that).

ENOPATCH?

> quite the puzzle this one

yes.

I'm tediously working on trying to get a good trace of this happening.

I have a random seed that will trigger the bug in the fuzzer around 1 time 
in 10.

Unfortunately many of the times it crashes so hard/quickly there's no 
chance of getting the trace data (dump trace on oops never holds enough 
state, and often the fuzzing triggers its own random trace events that 
clutter those logs).

Also trace-cmd is a pain to use.  Any suggested events I should trace 
beyond the obvious?

Part of the problem is that despite what the documentation says it doesn't 
look like you can combine the "-P pid" and "-c" children option, which 
makes debugging a forking problem like this a lot harder to trace.

It's sort of possible to get around that with a really complicated -F ""
command line that does sudo back to me (don't want to fuzz as root) and 
such, but still awkward.

Vince
