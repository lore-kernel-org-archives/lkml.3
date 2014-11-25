Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaKYKlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaKYKln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Cong Wang <cwang@twopensource.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 092/254] perf: Fix unclone_ctx() vs. locking
Date: Tue, 25 Nov 2014 10:37:22 +0000
Message-Id: <1416912004-5928-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 211de6eba8960521e2be450a7d07db85fba4604c upstream.

The idiot who did 4a1c0f262f88 ("perf: Fix lockdep warning on process exit")
forgot to pay attention and fix all similar cases. Do so now.

In particular, unclone_ctx() must be called while holding ctx->lock,
therefore all such sites are broken for the same reason. Pull the
put_ctx() call out from under ctx->lock.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Probably-also-reported-by: Vince Weaver <vincent.weaver@maine.edu>
Fixes: 4a1c0f262f88 ("perf: Fix lockdep warning on process exit")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Cong Wang <cwang@twopensource.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140930172308.GI4241@worktop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/core.c | 54 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2065959042ea..5dfa199971d2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -901,13 +901,23 @@ static void put_ctx(struct perf_event_context *ctx)
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
@@ -2209,6 +2219,9 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 static int context_equiv(struct perf_event_context *ctx1,
 			 struct perf_event_context *ctx2)
 {
+	lockdep_assert_held(&ctx1->lock);
+	lockdep_assert_held(&ctx2->lock);
+
 	/* Pinning disables the swap optimization */
 	if (ctx1->pin_count || ctx2->pin_count)
 		return 0;
@@ -2942,6 +2955,7 @@ static int event_enable_on_exec(struct perf_event *event,
  */
 static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 {
+	struct perf_event_context *clone_ctx = NULL;
 	struct perf_event *event;
 	unsigned long flags;
 	int enabled = 0;
@@ -2973,7 +2987,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	 * Unclone this context if we enabled any event.
 	 */
 	if (enabled)
-		unclone_ctx(ctx);
+		clone_ctx = unclone_ctx(ctx);
 
 	raw_spin_unlock(&ctx->lock);
 
@@ -2983,6 +2997,9 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
+
+	if (clone_ctx)
+		put_ctx(clone_ctx);
 }
 
 void perf_event_exec(void)
@@ -3134,7 +3151,7 @@ errout:
 static struct perf_event_context *
 find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 {
-	struct perf_event_context *ctx;
+	struct perf_event_context *ctx, *clone_ctx = NULL;
 	struct perf_cpu_context *cpuctx;
 	unsigned long flags;
 	int ctxn, err;
@@ -3168,9 +3185,12 @@ find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
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
@@ -7496,7 +7516,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event *child_event, *next;
-	struct perf_event_context *child_ctx, *parent_ctx;
+	struct perf_event_context *child_ctx, *clone_ctx = NULL;
 	unsigned long flags;
 
 	if (likely(!child->perf_event_ctxp[ctxn])) {
@@ -7523,28 +7543,16 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
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
-- 
2.1.0

