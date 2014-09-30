Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaI3RXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:23:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaI3RXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:23:21 -0400
Date: Tue, 30 Sep 2014 19:23:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Cong Wang <cwang@twopensource.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
Message-ID: <20140930172308.GI4241@worktop.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>
 <20140910083136.GP6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
 <541059C9.1040200@oracle.com>
 <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu>
 <20140910143306.GD4783@worktop.ger.corp.intel.com>
 <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu>
 <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com>
 <542789E5.7090805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542789E5.7090805@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How about this then?

---
Subject: perf: Fix unclone_ctx() vs locking

The idiot who did 4a1c0f262f88 forgot to pay attention and fix all
similar cases. Do so now.

In particular, unclone_ctx() must be called while holding ctx->lock,
therefore all such sites are broken for the same reason. Pull the
put_ctx() call out from under ctx->lock.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Fixes: 4a1c0f262f88 ("perf: Fix lockdep warning on process exit")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/events/core.c | 54 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a232b4006026..769d8587cf31 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -911,13 +911,23 @@ static void put_ctx(struct perf_event_context *ctx)
 	}
 }
 
-static void unclone_ctx(struct perf_event_context *ctx)
+/*
+ * This must be done under the ctx->lock, such as to serialize against
+ * context_equiv(), therefore we cannot call put_ctx() since that might end up
+ * calling scheduler related locks and ctx->lock nests inside those.
+ */
+static __must_check struct perf_event_context *
+unclone_ctx(struct perf_event_context *ctx)
 {
-	if (ctx->parent_ctx) {
-		put_ctx(ctx->parent_ctx);
+	struct perf_event_context *parent_ctx = ctx->parent_ctx;
+
+	lockdep_assert_held(&ctx->lock);
+
+	if (parent_ctx)
 		ctx->parent_ctx = NULL;
-	}
 	ctx->generation++;
+
+	return parent_ctx;
 }
 
 static u32 perf_event_pid(struct perf_event *event, struct task_struct *p)
@@ -2264,6 +2274,9 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 static int context_equiv(struct perf_event_context *ctx1,
 			 struct perf_event_context *ctx2)
 {
+	lockdep_assert_held(&ctx1->lock);
+	lockdep_assert_held(&ctx2->lock);
+
 	/* Pinning disables the swap optimization */
 	if (ctx1->pin_count || ctx2->pin_count)
 		return 0;
@@ -2997,6 +3010,7 @@ static int event_enable_on_exec(struct perf_event *event,
  */
 static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 {
+	struct perf_event_context *clone_ctx = NULL;
 	struct perf_event *event;
 	unsigned long flags;
 	int enabled = 0;
@@ -3028,7 +3042,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	 * Unclone this context if we enabled any event.
 	 */
 	if (enabled)
-		unclone_ctx(ctx);
+		clone_ctx = unclone_ctx(ctx);
 
 	raw_spin_unlock(&ctx->lock);
 
@@ -3038,6 +3052,9 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
+
+	if (clone_ctx)
+		put_ctx(clone_ctx);
 }
 
 void perf_event_exec(void)
@@ -3190,7 +3207,7 @@ find_lively_task_by_vpid(pid_t vpid)
 static struct perf_event_context *
 find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 {
-	struct perf_event_context *ctx;
+	struct perf_event_context *ctx, *clone_ctx = NULL;
 	struct perf_cpu_context *cpuctx;
 	unsigned long flags;
 	int ctxn, err;
@@ -3224,9 +3241,12 @@ find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 retry:
 	ctx = perf_lock_task_context(task, ctxn, &flags);
 	if (ctx) {
-		unclone_ctx(ctx);
+		clone_ctx = unclone_ctx(ctx);
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
+
+		if (clone_ctx)
+			put_ctx(clone_ctx);
 	} else {
 		ctx = alloc_perf_context(pmu, task);
 		err = -ENOMEM;
@@ -7651,7 +7671,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event *child_event, *next;
-	struct perf_event_context *child_ctx, *parent_ctx;
+	struct perf_event_context *child_ctx, *clone_ctx = NULL;
 	unsigned long flags;
 
 	if (likely(!child->perf_event_ctxp[ctxn])) {
@@ -7678,28 +7698,16 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	child->perf_event_ctxp[ctxn] = NULL;
 
 	/*
-	 * In order to avoid freeing: child_ctx->parent_ctx->task
-	 * under perf_event_context::lock, grab another reference.
-	 */
-	parent_ctx = child_ctx->parent_ctx;
-	if (parent_ctx)
-		get_ctx(parent_ctx);
-
-	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
 	 * the events from it.
 	 */
-	unclone_ctx(child_ctx);
+	clone_ctx = unclone_ctx(child_ctx);
 	update_context_time(child_ctx);
 	raw_spin_unlock_irqrestore(&child_ctx->lock, flags);
 
-	/*
-	 * Now that we no longer hold perf_event_context::lock, drop
-	 * our extra child_ctx->parent_ctx reference.
-	 */
-	if (parent_ctx)
-		put_ctx(parent_ctx);
+	if (clone_ctx)
+		put_ctx(clone_ctx);
 
 	/*
 	 * Report the task dead after unscheduling the events so that we
