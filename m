Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaBJRpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:45:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63581 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753645AbaBJRo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:44:58 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, dave.martin@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Cc: Ingo Molnar" <mingo@redhat.com>
Subject: [PATCH 4/7] perf: be less pessimistic when scheduling events
Date: Mon, 10 Feb 2014 17:44:21 +0000
Message-Id: <1392054264-23570-5-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ctx_flexible_sched_in assumes that the pmu is full as soon as
a single group fails to schedule. This is not necessarily true, and
leads to sub-optimal event scheduling in a couple of scenarios.

If heterogeneous hw pmus are registered (e.g. in a big.LITTLE system),
they will share the same perf_event_context, though each event will only
be possible to schedule on a subset of cpus, and thus some events may
fail to schedule in ctx_flexible_sched_in. If these events are early in
the flexible_groups list they will prevent viable events from being
scheduled until the list is sufficiently rotated. For short running
tasks its possible that sufficient rotation never occurs and events are
never counted even when all counters in the pmu are free.

Even on a single-pmu system it is possible for an permanently
unschedulable event group to starve a permanently schedulable event
group. Assume the pmu has N counters, and one of these counters is in
active use by a pinned event (e.g. a perf top session). Create two event
groups, one with N events (never schedulable) and one with N-1 (always
schedulable). While the former group is at the head of the
flexible_groups list it will prevent the latter from being scheduled. On
average the always-schedulable group will only be scheduled for half of
the time it's possible to schedule it for.

This patch makes ctx_flexible_sched_in attempt to schedule every group
in the flexible_groups list even when earlier groups failed to schedule,
enabling more groups to be scheduled simultaneously. The events are
still scheduled in list order, so no events scheduled under the old
behaviour will be rejected under the new behaviour. The existing
rotation of the flexible_groups list ensures that each group will be
scheduled given sufficient time, as with the current implementation.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/events/core.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e2fcf1b..13ede70 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1781,8 +1781,7 @@ group_error:
  * Work out whether we can put this event group on the CPU now.
  */
 static int group_can_go_on(struct perf_event *event,
-			   struct perf_cpu_context *cpuctx,
-			   int can_add_hw)
+			   struct perf_cpu_context *cpuctx)
 {
 	/*
 	 * Groups consisting entirely of software events can always go on.
@@ -1802,10 +1801,9 @@ static int group_can_go_on(struct perf_event *event,
 	if (event->attr.exclusive && cpuctx->active_oncpu)
 		return 0;
 	/*
-	 * Otherwise, try to add it if all previous groups were able
-	 * to go on.
+	 * Otherwise, try to add it.
 	 */
-	return can_add_hw;
+	return 1;
 }
 
 static void add_event_to_ctx(struct perf_event *event,
@@ -2024,7 +2022,7 @@ static int __perf_event_enable(void *info)
 	if (leader != event && leader->state != PERF_EVENT_STATE_ACTIVE)
 		goto unlock;
 
-	if (!group_can_go_on(event, cpuctx, 1)) {
+	if (!group_can_go_on(event, cpuctx)) {
 		err = -EEXIST;
 	} else {
 		if (event == leader)
@@ -2409,7 +2407,7 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 		if (is_cgroup_event(event))
 			perf_cgroup_mark_enabled(event, ctx);
 
-		if (group_can_go_on(event, cpuctx, 1))
+		if (group_can_go_on(event, cpuctx))
 			group_sched_in(event, cpuctx, ctx);
 
 		/*
@@ -2428,7 +2426,6 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		      struct perf_cpu_context *cpuctx)
 {
 	struct perf_event *event;
-	int can_add_hw = 1;
 
 	list_for_each_entry(event, &ctx->flexible_groups, group_entry) {
 		/* Ignore events in OFF or ERROR state */
@@ -2445,10 +2442,8 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		if (is_cgroup_event(event))
 			perf_cgroup_mark_enabled(event, ctx);
 
-		if (group_can_go_on(event, cpuctx, can_add_hw)) {
-			if (group_sched_in(event, cpuctx, ctx))
-				can_add_hw = 0;
-		}
+		if (group_can_go_on(event, cpuctx))
+			group_sched_in(event, cpuctx, ctx);
 	}
 }
 
-- 
1.8.1.1

