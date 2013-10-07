Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3JGQnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:43:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40905 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3JGQnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:43:11 -0400
Date: Mon, 7 Oct 2013 18:42:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>
Subject: Re: PERF_EVENT_IOC_SET_OUTPUT
Message-ID: <20131007164257.GH3081@twins.programming.kicks-ass.net>
References: <524B1E7C.3070108@intel.com>
 <20131002100350.GO3081@twins.programming.kicks-ass.net>
 <20131002102954.GD7941@localhost.localdomain>
 <20131002112730.GQ3081@twins.programming.kicks-ass.net>
 <20131002122900.GA27811@gmail.com>
 <20131002124023.GC28601@twins.programming.kicks-ass.net>
 <20131003064351.GG25345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003064351.GG25345@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 08:43:51AM +0200, Ingo Molnar wrote:
> If you find time to send an updated version that boots then I can try to 
> trace it to figure out where it fails, if it still fails.

Can you give the below a spin?

---
Subject: perf: Fix the perf context switch optimization
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Oct 7 17:12:48 CEST 2013

Currently we only optimize the context switch between two contexts that
have the same parent; this forgoes the optimization between parent and
child context, even though these contexts could be equivalent too.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/events/core.c |   64 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 18 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -899,6 +899,7 @@ static void unclone_ctx(struct perf_even
 		put_ctx(ctx->parent_ctx);
 		ctx->parent_ctx = NULL;
 	}
+	ctx->generation++;
 }
 
 static u32 perf_event_pid(struct perf_event *event, struct task_struct *p)
@@ -1136,6 +1137,8 @@ list_add_event(struct perf_event *event,
 	ctx->nr_events++;
 	if (event->attr.inherit_stat)
 		ctx->nr_stat++;
+
+	ctx->generation++;
 }
 
 /*
@@ -1313,6 +1316,8 @@ list_del_event(struct perf_event *event,
 	 */
 	if (event->state > PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_OFF;
+
+	ctx->generation++;
 }
 
 static void perf_group_detach(struct perf_event *event)
@@ -2149,22 +2154,38 @@ static void ctx_sched_out(struct perf_ev
 }
 
 /*
- * Test whether two contexts are equivalent, i.e. whether they
- * have both been cloned from the same version of the same context
- * and they both have the same number of enabled events.
- * If the number of enabled events is the same, then the set
- * of enabled events should be the same, because these are both
- * inherited contexts, therefore we can't access individual events
- * in them directly with an fd; we can only enable/disable all
- * events via prctl, or enable/disable all events in a family
- * via ioctl, which will have the same effect on both contexts.
+ * Test whether two contexts are equivalent, i.e. whether they have both been
+ * cloned from the same version of the same context.
+ *
+ * Equivalence is measured using a generation number in the context that is
+ * incremented on each modification to it; see unclone_ctx(), list_add_event()
+ * and list_del_event().
  */
 static int context_equiv(struct perf_event_context *ctx1,
 			 struct perf_event_context *ctx2)
 {
-	return ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx
-		&& ctx1->parent_gen == ctx2->parent_gen
-		&& !ctx1->pin_count && !ctx2->pin_count;
+	/* Pinning disables the swap optimization */
+	if (ctx1->pin_count || ctx2->pin_count)
+		return 0;
+
+	/* If ctx1 is the parent of ctx2 */
+	if (ctx1 == ctx2->parent_ctx && ctx1->generation == ctx2->parent_gen)
+		return 1;
+
+	/* If ctx2 is the parent of ctx1 */
+	if (ctx1->parent_ctx == ctx2 && ctx1->parent_gen == ctx2->generation)
+		return 1;
+
+	/*
+	 * If ctx1 and ctx2 have the same parent; we flatten the parent
+	 * hierarchy, see perf_event_init_context().
+	 */
+	if (ctx1->parent_ctx && ctx1->parent_ctx == ctx2->parent_ctx &&
+			ctx1->parent_gen == ctx2->parent_gen)
+		return 1;
+
+	/* Unmatched */
+	return 0;
 }
 
 static void __perf_event_sync_stat(struct perf_event *event,
@@ -2247,7 +2268,7 @@ static void perf_event_context_sched_out
 {
 	struct perf_event_context *ctx = task->perf_event_ctxp[ctxn];
 	struct perf_event_context *next_ctx;
-	struct perf_event_context *parent;
+	struct perf_event_context *parent, *next_parent;
 	struct perf_cpu_context *cpuctx;
 	int do_switch = 1;
 
@@ -2259,10 +2280,18 @@ static void perf_event_context_sched_out
 		return;
 
 	rcu_read_lock();
-	parent = rcu_dereference(ctx->parent_ctx);
 	next_ctx = next->perf_event_ctxp[ctxn];
-	if (parent && next_ctx &&
-	    rcu_dereference(next_ctx->parent_ctx) == parent) {
+	if (!next_ctx)
+		goto unlock;
+
+	parent = rcu_dereference(ctx->parent_ctx);
+	next_parent = rcu_dereference(next_ctx->parent_ctx);
+
+	/* If neither context have a parent context; they cannot be clones. */
+	if (!parent && !next_parent)
+		goto unlock;
+
+	if (next_parent == ctx || next_ctx == parent || next_parent == parent) {
 		/*
 		 * Looks like the two contexts are clones, so we might be
 		 * able to optimize the context switch.  We lock both
@@ -2290,6 +2319,7 @@ static void perf_event_context_sched_out
 		raw_spin_unlock(&next_ctx->lock);
 		raw_spin_unlock(&ctx->lock);
 	}
+unlock:
 	rcu_read_unlock();
 
 	if (do_switch) {
@@ -7128,7 +7158,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	}
 
 	perf_install_in_context(ctx, event, event->cpu);
-	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
@@ -7211,7 +7240,6 @@ perf_event_create_kernel_counter(struct
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
-	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
