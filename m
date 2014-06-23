Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaFWIez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:34:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55634 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 019/111] perf: Fix race in removing an event
Date: Mon, 23 Jun 2014 10:30:54 +0200
Message-Id: <c8db9ba0ae861889aaed1cad87483a966fdda818.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 46ce0fe97a6be7532ce6126bb26ce89fed81528c upstream.

When removing a (sibling) event we do:

	raw_spin_lock_irq(&ctx->lock);
	perf_group_detach(event);
	raw_spin_unlock_irq(&ctx->lock);

	<hole>

	perf_remove_from_context(event);
		raw_spin_lock_irq(&ctx->lock);
		...
		raw_spin_unlock_irq(&ctx->lock);

Now, assuming the event is a sibling, it will be 'unreachable' for
things like ctx_sched_out() because that iterates the
groups->siblings, and we just unhooked the sibling.

So, if during <hole> we get ctx_sched_out(), it will miss the event
and not call event_sched_out() on it, leaving it programmed on the
PMU.

The subsequent perf_remove_from_context() call will find the ctx is
inactive and only call list_del_event() to remove the event from all
other lists.

Hereafter we can proceed to free the event; while still programmed!

Close this hole by moving perf_group_detach() inside the same
ctx->lock region(s) perf_remove_from_context() has.

The condition on inherited events only in __perf_event_exit_task() is
likely complete crap because non-inherited events are part of groups
too and we're tearing down just the same. But leave that for another
patch.

Most-likely-Fixes: e03a9a55b4e ("perf: Change close() semantics for group events")
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Much-staring-at-traces-by: Vince Weaver <vincent.weaver@maine.edu>
Much-staring-at-traces-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140505093124.GN17778@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/events/core.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 01eeaf6cc95a..624befa90019 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1426,6 +1426,11 @@ group_sched_out(struct perf_event *group_event,
 		cpuctx->exclusive = 0;
 }
 
+struct remove_event {
+	struct perf_event *event;
+	bool detach_group;
+};
+
 /*
  * Cross CPU call to remove a performance event
  *
@@ -1434,12 +1439,15 @@ group_sched_out(struct perf_event *group_event,
  */
 static int __perf_remove_from_context(void *info)
 {
-	struct perf_event *event = info;
+	struct remove_event *re = info;
+	struct perf_event *event = re->event;
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_cpu_context *cpuctx = __get_cpu_context(ctx);
 
 	raw_spin_lock(&ctx->lock);
 	event_sched_out(event, cpuctx, ctx);
+	if (re->detach_group)
+		perf_group_detach(event);
 	list_del_event(event, ctx);
 	if (!ctx->nr_events && cpuctx->task_ctx == ctx) {
 		ctx->is_active = 0;
@@ -1464,10 +1472,14 @@ static int __perf_remove_from_context(void *info)
  * When called from perf_event_exit_task, it's OK because the
  * context has been detached from its task.
  */
-static void perf_remove_from_context(struct perf_event *event)
+static void perf_remove_from_context(struct perf_event *event, bool detach_group)
 {
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
+	struct remove_event re = {
+		.event = event,
+		.detach_group = detach_group,
+	};
 
 	lockdep_assert_held(&ctx->mutex);
 
@@ -1476,12 +1488,12 @@ static void perf_remove_from_context(struct perf_event *event)
 		 * Per cpu events are removed via an smp call and
 		 * the removal is always successful.
 		 */
-		cpu_function_call(event->cpu, __perf_remove_from_context, event);
+		cpu_function_call(event->cpu, __perf_remove_from_context, &re);
 		return;
 	}
 
 retry:
-	if (!task_function_call(task, __perf_remove_from_context, event))
+	if (!task_function_call(task, __perf_remove_from_context, &re))
 		return;
 
 	raw_spin_lock_irq(&ctx->lock);
@@ -1498,6 +1510,8 @@ retry:
 	 * Since the task isn't running, its safe to remove the event, us
 	 * holding the ctx->lock ensures the task won't get scheduled in.
 	 */
+	if (detach_group)
+		perf_group_detach(event);
 	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 }
@@ -3230,10 +3244,7 @@ int perf_event_release_kernel(struct perf_event *event)
 	 *     to trigger the AB-BA case.
 	 */
 	mutex_lock_nested(&ctx->mutex, SINGLE_DEPTH_NESTING);
-	raw_spin_lock_irq(&ctx->lock);
-	perf_group_detach(event);
-	raw_spin_unlock_irq(&ctx->lock);
-	perf_remove_from_context(event);
+	perf_remove_from_context(event, true);
 	mutex_unlock(&ctx->mutex);
 
 	free_event(event);
@@ -7102,7 +7113,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		struct perf_event_context *gctx = group_leader->ctx;
 
 		mutex_lock(&gctx->mutex);
-		perf_remove_from_context(group_leader);
+		perf_remove_from_context(group_leader, false);
 
 		/*
 		 * Removing from the context ends up with disabled
@@ -7112,7 +7123,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		perf_event__state_init(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_remove_from_context(sibling);
+			perf_remove_from_context(sibling, false);
 			perf_event__state_init(sibling);
 			put_ctx(gctx);
 		}
@@ -7244,7 +7255,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	mutex_lock(&src_ctx->mutex);
 	list_for_each_entry_safe(event, tmp, &src_ctx->event_list,
 				 event_entry) {
-		perf_remove_from_context(event);
+		perf_remove_from_context(event, false);
 		unaccount_event_cpu(event, src_cpu);
 		put_ctx(src_ctx);
 		list_add(&event->migrate_entry, &events);
@@ -7306,13 +7317,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	if (child_event->parent) {
-		raw_spin_lock_irq(&child_ctx->lock);
-		perf_group_detach(child_event);
-		raw_spin_unlock_irq(&child_ctx->lock);
-	}
-
-	perf_remove_from_context(child_event);
+	perf_remove_from_context(child_event, !!child_event->parent);
 
 	/*
 	 * It can happen that the parent exits first, and has events
@@ -7797,14 +7802,14 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
 
 static void __perf_event_exit_context(void *__info)
 {
+	struct remove_event re = { .detach_group = false };
 	struct perf_event_context *ctx = __info;
-	struct perf_event *event;
 
 	perf_pmu_rotate_stop(ctx->pmu);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(event, &ctx->event_list, event_entry)
-		__perf_remove_from_context(event);
+	list_for_each_entry_rcu(re.event, &ctx->event_list, event_entry)
+		__perf_remove_from_context(&re);
 	rcu_read_unlock();
 }
 
-- 
2.0.0

