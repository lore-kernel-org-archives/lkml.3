Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaEHKly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:41:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaEHKlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:41:51 -0400
Date: Thu, 8 May 2014 03:40:25 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-46ce0fe97a6be7532ce6126bb26ce89fed81528c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
In-Reply-To: <20140505093124.GN17778@laptop.programming.kicks-ass.net>
References: <20140505093124.GN17778@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix race in removing an event
Git-Commit-ID: 46ce0fe97a6be7532ce6126bb26ce89fed81528c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46ce0fe97a6be7532ce6126bb26ce89fed81528c
Gitweb:     http://git.kernel.org/tip/46ce0fe97a6be7532ce6126bb26ce89fed81528c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 2 May 2014 16:56:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:33:14 +0200

perf: Fix race in removing an event

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
---
 kernel/events/core.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f83a71a..ea899e2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1443,6 +1443,11 @@ group_sched_out(struct perf_event *group_event,
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
@@ -1451,12 +1456,15 @@ group_sched_out(struct perf_event *group_event,
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
@@ -1481,10 +1489,14 @@ static int __perf_remove_from_context(void *info)
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
 
@@ -1493,12 +1505,12 @@ static void perf_remove_from_context(struct perf_event *event)
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
@@ -1515,6 +1527,8 @@ retry:
 	 * Since the task isn't running, its safe to remove the event, us
 	 * holding the ctx->lock ensures the task won't get scheduled in.
 	 */
+	if (detach_group)
+		perf_group_detach(event);
 	list_del_event(event, ctx);
 	raw_spin_unlock_irq(&ctx->lock);
 }
@@ -3281,10 +3295,7 @@ int perf_event_release_kernel(struct perf_event *event)
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
@@ -7165,7 +7176,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		struct perf_event_context *gctx = group_leader->ctx;
 
 		mutex_lock(&gctx->mutex);
-		perf_remove_from_context(group_leader);
+		perf_remove_from_context(group_leader, false);
 
 		/*
 		 * Removing from the context ends up with disabled
@@ -7175,7 +7186,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		perf_event__state_init(group_leader);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_remove_from_context(sibling);
+			perf_remove_from_context(sibling, false);
 			perf_event__state_init(sibling);
 			put_ctx(gctx);
 		}
@@ -7305,7 +7316,7 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	mutex_lock(&src_ctx->mutex);
 	list_for_each_entry_safe(event, tmp, &src_ctx->event_list,
 				 event_entry) {
-		perf_remove_from_context(event);
+		perf_remove_from_context(event, false);
 		unaccount_event_cpu(event, src_cpu);
 		put_ctx(src_ctx);
 		list_add(&event->migrate_entry, &events);
@@ -7367,13 +7378,7 @@ __perf_event_exit_task(struct perf_event *child_event,
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
@@ -7857,14 +7862,14 @@ static void perf_pmu_rotate_stop(struct pmu *pmu)
 
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
 
