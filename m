Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbbA2Or4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:47:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:55568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbA2Orz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:47:55 -0500
Date: Thu, 29 Jan 2015 15:47:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: vincent.weaver@maine.edu, eranian@gmail.com, jolsa@redhat.com,
        mark.rutland@arm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [RFC][PATCH 2/3] perf: Add a bit of paranoia
Message-ID: <20150129144749.GC24151@twins.programming.kicks-ass.net>
References: <20150123125159.696530128@infradead.org>
 <20150123125834.150481799@infradead.org>
 <20150126162639.GA21418@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126162639.GA21418@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 05:26:39PM +0100, Peter Zijlstra wrote:
> On Fri, Jan 23, 2015 at 01:52:01PM +0100, Peter Zijlstra wrote:
> Jiri reported triggering that WARN_ON_ONCE over the weekend:
> 
>  event_sched_out.isra.79+0x2b9/0x2d0
>  group_sched_out+0x69/0xc0
>  ctx_sched_out+0x106/0x130
>  task_ctx_sched_out+0x37/0x70
>  __perf_install_in_context+0x70/0x1a0
>  remote_function+0x48/0x60
>  generic_exec_single+0x15b/0x1d0
>  smp_call_function_single+0x67/0xa0
>  task_function_call+0x53/0x80
>  perf_install_in_context+0x8b/0x110
> 
> 
> I think the below should cure this; if we install a group leader it will
> iterate the (still intact) group list and find its siblings and try and
> install those too -- even though those still have the old event->ctx --
> in the new ctx.
> 
> Upon installing the first group sibling we'd try and schedule out the
> group and trigger the above warn.
> 
> Fix this by installing the group leader last, installing siblings would
> have no effect, they're not reachable through the group lists and
> therefore we don't schedule them.
> 
> Also delay resetting the state until we're absolutely sure the events
> are quiescent -- which raises the question; should perf_pmu_migrate()
> not also have perf_event__state_init() calls in?

So perf_pmu_migrate_context() does an explicit OFF->INACTIVE change on
the install side, which seems good enough.

That said, it does need to do that sibling first leaders later install
order too. So I've put the below on top.

---
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7817,8 +7817,35 @@ void perf_pmu_migrate_context(struct pmu
 		list_add(&event->migrate_entry, &events);
 	}
 
+	/*
+	 * Wait for the events to quiesce before re-instating them.
+	 */
 	synchronize_rcu();
 
+	/*
+	 * Re-instate events in 2 passes.
+	 *
+	 * Skip over group leaders and only install siblings on this first
+	 * pass, siblings will not get enabled without a leader, however a
+	 * leader will enable its siblings, even if those are still on the old
+	 * context.
+	 */
+	list_for_each_entry_safe(event, tmp, &events, migrate_entry) {
+		if (event->group_leader == event)
+			continue;
+
+		list_del(&event->migrate_entry);
+		if (event->state >= PERF_EVENT_STATE_OFF)
+			event->state = PERF_EVENT_STATE_INACTIVE;
+		account_event_cpu(event, dst_cpu);
+		perf_install_in_context(dst_ctx, event, dst_cpu);
+		get_ctx(dst_ctx);
+	}
+
+	/*
+	 * Once all the siblings are setup properly, install the group leaders
+	 * to make it go.
+	 */
 	list_for_each_entry_safe(event, tmp, &events, migrate_entry) {
 		list_del(&event->migrate_entry);
 		if (event->state >= PERF_EVENT_STATE_OFF)
