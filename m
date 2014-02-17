Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaBQP3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:29:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44582 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaBQP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:29:07 -0500
Date: Mon, 17 Feb 2014 16:28:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: x86_pmu_start WARN_ON.
Message-ID: <20140217152859.GF15586@twins.programming.kicks-ass.net>
References: <20140130190253.GA11819@redhat.com>
 <alpine.DEB.2.10.1402101620170.29602@vincent-weaver-1.um.maine.edu>
 <20140211132956.GY9987@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 05:13:20PM -0500, Vince Weaver wrote:
> On Thu, 13 Feb 2014, Vince Weaver wrote:
> 
> > The plot thickens.  The WARN_ON is not caused by the cycles event that we 
> > open, but it's caused by the NMI Watchdog cycles event.
> 
> The WARN_ON_ONCE at line 1076 in perf_event.c is triggering because
> in x86_pmu_enable() is calling x86_pmu_start() for all of the active x86 
> events (three plus the NMI watchdog) the NMI watchdog is unexpectedly
> not having PERF_HES_STOPPED set (it's hw.state is 0).

Cute, that is indeed unexpected.

> What's the deal with the PERF_HES_STOPPED name?  Is HES an acronym?
> Or is it just a male event?  

Hardware Event State

> Also it's not really clear what PERF_HES_ARCH indicates.

I ran out of names it seems; its used in the reschedule case where we
relocate a stopped event. We save the STOPPED state into ARCH (because
we're going to destroy the STOPPED state by stopping everybody), so that
we know not to (re)enable the event when its on its new location.

The comment in x86_pmu_enable() near where we set ARCH was supposed to
communicate this.

> Things rapidly get complicated beyond that, as the NMI watchdog is a 
> kernel-created event bound to the CPU, wheras 2 of the events are x86 hw 
> events with a breakpoint-event groupleader (and the fact one of the events 
> has precise set).

For this code that _should_ not matter much; they're 3 events and we
mapped them into hardware counters.

So the precise has to run on cnt0 on Core2, the NMI is simple enough to
fit (and we prefer) fixed purpose counters. So there _should_ not be a
reshuffle.

Although I should probably assert these _should_ thingies.

> From the stacktrace it looks like it is the close of a completely 
> unrelated tracepoint event that triggers this all off, but I'm not
> sure why a list_del_event() call of the tracepoint name would
> trigger a schedule_timeout() and an ensuing __perf_event_task_sched_in()
> which is what eventually triggers the problem.

Enable CONFIG_FRAME_POINTER for better stack traces; I suspect the
list_del_event() is just random stack garbage. The path that makes sense
is:
  wait_rcu()->__wait_for_common()->schedule_timeout()

> Scattering printks around doesn't see to work because a lot of the related 
> calls are happening in contexts where printks don't really work.
> 
> Anyway I just wanted to summarize my findings as I might not have a chance 
> to look at this again for a while.  For completion I'm including the 
> backtrace below.

Sure, much appreciated. I'll go read up on the event schedule code, its
been a while since I stared at that in too much detail.
