Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaBJRo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:44:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63576 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbaBJRoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:44:55 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, dave.martin@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/7] perf: kill perf_event_context_type
Date: Mon, 10 Feb 2014 17:44:20 +0000
Message-Id: <1392054264-23570-4-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf_event_context::type is used to determine whether a
context is cpu-bound or task-bound. However perf_event_context::task can
be used to determine this just as cheaply, and requires no additional
initialisation.

This patch removes perf_event_context::type, and modifies existing users
to check check perf_event_context::task instead. The now unused enum
perf_event_context_type is removed.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/perf_event.h | 6 ------
 kernel/events/core.c       | 3 +--
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f..df3d34a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -440,11 +440,6 @@ struct perf_event {
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
@@ -452,7 +447,6 @@ enum perf_event_context_type {
  */
 struct perf_event_context {
 	struct pmu			*pmu;
-	enum perf_event_context_type	type;
 	/*
 	 * Protect the states of the events in the list,
 	 * nr_active, and the list:
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 15fe6fc..e2fcf1b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6493,7 +6493,6 @@ skip_type:
 		__perf_event_init_context(&cpuctx->ctx);
 		lockdep_set_class(&cpuctx->ctx.mutex, &cpuctx_mutex);
 		lockdep_set_class(&cpuctx->ctx.lock, &cpuctx_lock);
-		cpuctx->ctx.type = cpu_context;
 		cpuctx->ctx.pmu = pmu;
 
 		__perf_cpu_hrtimer_init(cpuctx, cpu);
@@ -7130,7 +7129,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		 * task or CPU context:
 		 */
 		if (move_group) {
-			if (group_leader->ctx->type != ctx->type)
+			if (group_leader->ctx->task != ctx->task)
 				goto err_context;
 		} else {
 			if (group_leader->ctx != ctx)
-- 
1.8.1.1

