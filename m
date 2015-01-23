Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbbAWNAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:00:42 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbbAWNAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:00:40 -0500
Message-Id: <20150123125834.090683288@infradead.org>
User-Agent: quilt/0.61-1
Date: Fri, 23 Jan 2015 13:52:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: vincent.weaver@maine.edu, eranian@gmail.com, jolsa@redhat.com,
        mark.rutland@arm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org
Subject: [RFC][PATCH 1/3] perf: Tighten (and fix) the grouping condition
References: <20150123125159.696530128@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-perf-fix-grouping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix from 9fc81d87420d ("perf: Fix events installation during
moving group") was incomplete in that it failed to recognise that
creating a group with events for different CPUs is semantically
broken -- they cannot be co-scheduled.

Furthermore, it leads to real breakage where, when we create an event
for CPU Y and then migrate it to form a group on CPU X, the code gets
confused where the counter is programmed -- triggered by the fuzzer.

Fix this by tightening the rules for creating groups. Only allow
grouping of counters that can be co-scheduled in the same context.
This means for the same task and/or the same cpu.

Fixes: 9fc81d87420d ("perf: Fix events installation during moving group")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/perf_event.h |    6 ------
 kernel/events/core.c       |   15 +++++++++++++--
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -450,11 +450,6 @@ struct perf_event {
 #endif /* CONFIG_PERF_EVENTS */
 };
 
-enum perf_event_context_type {
-	task_context,
-	cpu_context,
-};
-
 /**
  * struct perf_event_context - event context structure
  *
@@ -462,7 +457,6 @@ enum perf_event_context_type {
  */
 struct perf_event_context {
 	struct pmu			*pmu;
-	enum perf_event_context_type	type;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6846,7 +6846,6 @@ int perf_pmu_register(struct pmu *pmu, c
 		__perf_event_init_context(&cpuctx->ctx);
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
-		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 
 		__perf_cpu_hrtimer_init(cpuctx, cpu);
@@ -7493,7 +7492,19 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * task or CPU context:
 		 */
 		if (move_group) {
-			if (group_leader->ctx->type != ctx->type)
+			/*
+			 * Make sure we're both on the same task, or both
+			 * per-cpu events.
+			 */
+			if (group_leader->ctx->task != ctx->task)
+				goto err_context;
+
+			/*
+			 * Make sure we're both events for the same CPU;
+			 * grouping events for different CPUs is broken; since
+			 * you can never concurrently schedule them anyhow.
+			 */
+			if (group_leader->cpu != event->cpu)
 				goto err_context;
 		} else {
 			if (group_leader->ctx != ctx)


