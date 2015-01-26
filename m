Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbbAZQ0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:26:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:33060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbbAZQ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:26:44 -0500
Date: Mon, 26 Jan 2015 17:26:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: vincent.weaver@maine.edu, eranian@gmail.com, jolsa@redhat.com,
        mark.rutland@arm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [RFC][PATCH 2/3] perf: Add a bit of paranoia
Message-ID: <20150126162639.GA21418@twins.programming.kicks-ass.net>
References: <20150123125159.696530128@infradead.org>
 <20150123125834.150481799@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123125834.150481799@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 01:52:01PM +0100, Peter Zijlstra wrote:
> @@ -1442,6 +1450,10 @@ event_sched_out(struct perf_event *event
>  {
>  	u64 tstamp = perf_event_time(event);
>  	u64 delta;
> +
> +	WARN_ON_ONCE(event->ctx != ctx);
> +	lockdep_assert_held(&ctx->lock);
> +
>  	/*
>  	 * An event which could not be activated because of
>  	 * filter mismatch still needs to have its timings

Jiri reported triggering that WARN_ON_ONCE over the weekend:

 event_sched_out.isra.79+0x2b9/0x2d0
 group_sched_out+0x69/0xc0
 ctx_sched_out+0x106/0x130
 task_ctx_sched_out+0x37/0x70
 __perf_install_in_context+0x70/0x1a0
 remote_function+0x48/0x60
 generic_exec_single+0x15b/0x1d0
 smp_call_function_single+0x67/0xa0
 task_function_call+0x53/0x80
 perf_install_in_context+0x8b/0x110


I think the below should cure this; if we install a group leader it will
iterate the (still intact) group list and find its siblings and try and
install those too -- even though those still have the old event->ctx --
in the new ctx.

Upon installing the first group sibling we'd try and schedule out the
group and trigger the above warn.

Fix this by installing the group leader last, installing siblings would
have no effect, they're not reachable through the group lists and
therefore we don't schedule them.

Also delay resetting the state until we're absolutely sure the events
are quiescent -- which raises the question; should perf_pmu_migrate()
not also have perf_event__state_init() calls in?

---
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7645,16 +7645,9 @@ SYSCALL_DEFINE5(perf_event_open,
 
 		perf_remove_from_context(group_leader, false);
 
-		/*
-		 * Removing from the context ends up with disabled
-		 * event. What we want here is event in the initial
-		 * startup state, ready to be add into new context.
-		 */
-		perf_event__state_init(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
 			perf_remove_from_context(sibling, false);
-			perf_event__state_init(sibling);
 			put_ctx(gctx);
 		}
 	} else {
@@ -7670,13 +7663,31 @@ SYSCALL_DEFINE5(perf_event_open,
 		 */
 		synchronize_rcu();
 
-		perf_install_in_context(ctx, group_leader, group_leader->cpu);
-		get_ctx(ctx);
+		/*
+		 * Install the group siblings before the group leader.
+		 *
+		 * Because a group leader will try and install the entire group
+		 * (through the sibling list, which is still in-tact), we can
+		 * end up with siblings installed in the wrong context.
+		 *
+		 * By installing siblings first we NO-OP because they're not
+		 * reachable through the group lists.
+		 */
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
+			perf_event__state_init(sibling);
 			perf_install_in_context(ctx, sibling, sibling->cpu);
 			get_ctx(ctx);
 		}
+
+		/*
+		 * Removing from the context ends up with disabled
+		 * event. What we want here is event in the initial
+		 * startup state, ready to be add into new context.
+		 */
+		perf_event__state_init(group_leader);
+		perf_install_in_context(ctx, group_leader, group_leader->cpu);
+		get_ctx(ctx);
 	}
 
 	perf_install_in_context(ctx, event, event->cpu);

