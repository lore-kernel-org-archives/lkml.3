Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaJMG4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:56:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60059 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbaJMG4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:56:07 -0400
Date: Mon, 13 Oct 2014 08:56:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes, leftover from v3.17
Message-ID: <20141013065602.GA12670@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 9c2b9d30e28559a78c9e431cdd7f2c6bf5a9ee67 perf: Fix perf bug in fork()

Two leftover fixes from the v3.17 cycle - these will be forwarded 
to -stable as well, if they prove problem-free in wider testing 
as well.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (2):
      perf: Fix unclone_ctx() vs. locking
      perf: Fix perf bug in fork()


 kernel/events/core.c | 58 ++++++++++++++++++++++++++++++----------------------
 kernel/fork.c        |  5 +++--
 2 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d640a8b4dcbc..658f232af04c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -902,13 +902,23 @@ static void put_ctx(struct perf_event_context *ctx)
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
@@ -2210,6 +2220,9 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 static int context_equiv(struct perf_event_context *ctx1,
 			 struct perf_event_context *ctx2)
 {
+	lockdep_assert_held(&ctx1->lock);
+	lockdep_assert_held(&ctx2->lock);
+
 	/* Pinning disables the swap optimization */
 	if (ctx1->pin_count || ctx2->pin_count)
 		return 0;
@@ -2943,6 +2956,7 @@ static int event_enable_on_exec(struct perf_event *event,
  */
 static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 {
+	struct perf_event_context *clone_ctx = NULL;
 	struct perf_event *event;
 	unsigned long flags;
 	int enabled = 0;
@@ -2974,7 +2988,7 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	 * Unclone this context if we enabled any event.
 	 */
 	if (enabled)
-		unclone_ctx(ctx);
+		clone_ctx = unclone_ctx(ctx);
 
 	raw_spin_unlock(&ctx->lock);
 
@@ -2984,6 +2998,9 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
+
+	if (clone_ctx)
+		put_ctx(clone_ctx);
 }
 
 void perf_event_exec(void)
@@ -3135,7 +3152,7 @@ find_lively_task_by_vpid(pid_t vpid)
 static struct perf_event_context *
 find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 {
-	struct perf_event_context *ctx;
+	struct perf_event_context *ctx, *clone_ctx = NULL;
 	struct perf_cpu_context *cpuctx;
 	unsigned long flags;
 	int ctxn, err;
@@ -3169,9 +3186,12 @@ find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
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
@@ -7523,7 +7543,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event *child_event, *next;
-	struct perf_event_context *child_ctx, *parent_ctx;
+	struct perf_event_context *child_ctx, *clone_ctx = NULL;
 	unsigned long flags;
 
 	if (likely(!child->perf_event_ctxp[ctxn])) {
@@ -7550,28 +7570,16 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
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
@@ -7948,8 +7956,10 @@ int perf_event_init_task(struct task_struct *child)
 
 	for_each_task_context_nr(ctxn) {
 		ret = perf_event_init_context(child, ctxn);
-		if (ret)
+		if (ret) {
+			perf_event_free_task(child);
 			return ret;
+		}
 	}
 
 	return 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb6e491..a91e47d86de2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1360,7 +1360,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_policy;
 	retval = audit_alloc(p);
 	if (retval)
-		goto bad_fork_cleanup_policy;
+		goto bad_fork_cleanup_perf;
 	/* copy all the process information */
 	shm_init_task(p);
 	retval = copy_semundo(clone_flags, p);
@@ -1566,8 +1566,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
-bad_fork_cleanup_policy:
+bad_fork_cleanup_perf:
 	perf_event_free_task(p);
+bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_threadgroup_lock:
