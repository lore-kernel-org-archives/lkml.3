Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3HOMMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 08:12:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51598 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3HOMMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 08:12:38 -0400
Date: Thu, 15 Aug 2013 14:12:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf: Move throtling flag to perf_event_context
Message-ID: <20130815121217.GS24092@twins.programming.kicks-ass.net>
References: <1376411952-16718-1-git-send-email-jolsa@redhat.com>
 <1376411952-16718-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376411952-16718-3-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 06:39:12PM +0200, Jiri Olsa wrote:
> The current throttling code triggers WARN below via following
> workload (only hit on AMD machine with 48 CPUs):
> 
>   # while [ 1 ]; do perf record perf bench sched messaging; done


> The reason is race in perf_event_task_tick throttling code.
> The race flow (simplified code):
> 
>   - perf_throttled_count is per cpu variable and is
>     CPU throttling flag, here starting with 0
>   - perf_throttled_seq is sequence/domain for allowed
>     count of interrupts within the tick, gets increased
>     each tick
> 
>     on single CPU (CPU bounded event):
> 
>       ... workload
> 
>     perf_event_task_tick:
>     |
>     | T0    inc(perf_throttled_seq)
>     | T1    throttled = xchg(perf_throttled_count, 0) == 0
>      tick gets interrupted:
> 
>             ... event gets throttled under new seq ...
> 
>       T2    last NMI comes, event is throttled - inc(perf_throttled_count)
> 
>      back to tick:
>     | perf_adjust_freq_unthr_context:
>     |
>     | T3    unthrottling is skiped for event (throttled == 0)
>     | T4    event is stop and started via freq adjustment
>     |
>     tick ends
> 
>       ... workload
>       ... no sample is hit for event ...
> 
>     perf_event_task_tick:
>     |
>     | T5    throttled = xchg(perf_throttled_count, 0) != 0 (from T2)
>     | T6    unthrottling is done on event (interrupts == MAX_INTERRUPTS)
>     |       event is already started (from T4) -> WARN
> 
> Fixing this by:
>   - moving the per cpu 'throttle' flag into the event's ctx so the flag
>     is context specific and thus not disturbed (changed) by others

This is an 'unrelated' change purely meant to optimize the tick handler
to not iterate as many events, right? It isn't actually part of the
solution for the above issue afaict. Hence I think it should be
separated into a separate patch. Esp. so because this seems to be the
bulk of the below patch due to the extra allocations/error paths etc.

That said, thinking about it, we might want to use a llist and queue all
throttled events on it from __perf_event_overflow(). That way we can
limit the iteration to all throttled events; a much better proposition
still.

>   - checking the 'throttled' under pmu disabled code again

Might as well remove that and only keep hwc->interrupts ==
MAX_INTERRUPTS; that should be sufficient I think.

In either case, we could have not gotten here on the first tick and a
second tick is needed to unthrottle us.

>   - removing perf_throttled_seq as it's no longer needed

I'm not entirely sure how we got here and your changelog is short of
clues; that said, I think I agree.

>   - keeping perf_throttled_count as perf_event_can_stop_tick flag

... uhu.

Anyway, would something like the below not be a similar fix? It avoids
the entire situation afaic.

---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e82e700..8fffd18 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2712,7 +2712,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 
 		hwc = &event->hw;
 
-		if (needs_unthr && hwc->interrupts == MAX_INTERRUPTS) {
+		if (hwc->interrupts == MAX_INTERRUPTS) {
 			hwc->interrupts = 0;
 			perf_log_throttle(event, 1);
 			event->pmu->start(event, 0);
