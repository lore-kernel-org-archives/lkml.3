Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab3JKLJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:09:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab3JKKml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 016/100] perf: Clarify perf_cpu_context::active_pmu usage by renaming it to ::unique_pmu
Date: Fri, 11 Oct 2013 11:40:46 +0100
Message-Id: <1381488130-30235-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 3f1f33206c16c7b3839d71372bc2ac3f305aa802 upstream.

Stephane thought the perf_cpu_context::active_pmu name confusing and
suggested using 'unique_pmu' instead.

This pointer is a pointer to a 'random' pmu sharing the cpuctx
instance, therefore limiting a for_each_pmu loop to those where
cpuctx->unique_pmu matches the pmu we get a loop over unique cpuctx
instances.

Suggested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-kxyjqpfj2fn9gt7kwu5ag9ks@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/perf_event.h |  2 +-
 kernel/events/core.c       | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c65c7d1..3faf0d4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1065,7 +1065,7 @@ struct perf_cpu_context {
 	int				exclusive;
 	struct list_head		rotation_list;
 	int				jiffies_interval;
-	struct pmu			*active_pmu;
+	struct pmu			*unique_pmu;
 	struct perf_cgroup		*cgrp;
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd815c3..b3a6de5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4331,7 +4331,7 @@ static void perf_event_task_event(struct perf_task_event *task_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_task_ctx(&cpuctx->ctx, task_event);
 
@@ -4477,7 +4477,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_comm_ctx(&cpuctx->ctx, comm_event);
 
@@ -4673,7 +4673,7 @@ got_name:
 	rcu_read_lock();
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
 		cpuctx = get_cpu_ptr(pmu->pmu_cpu_context);
-		if (cpuctx->active_pmu != pmu)
+		if (cpuctx->unique_pmu != pmu)
 			goto next;
 		perf_event_mmap_ctx(&cpuctx->ctx, mmap_event,
 					vma->vm_flags & VM_EXEC);
@@ -5748,8 +5748,8 @@ static void update_pmu_context(struct pmu *pmu, struct pmu *old_pmu)
 
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 
-		if (cpuctx->active_pmu == old_pmu)
-			cpuctx->active_pmu = pmu;
+		if (cpuctx->unique_pmu == old_pmu)
+			cpuctx->unique_pmu = pmu;
 	}
 }
 
@@ -5885,7 +5885,7 @@ skip_type:
 		cpuctx->ctx.pmu = pmu;
 		cpuctx->jiffies_interval = 1;
 		INIT_LIST_HEAD(&cpuctx->rotation_list);
-		cpuctx->active_pmu = pmu;
+		cpuctx->unique_pmu = pmu;
 	}
 
 got_cpu_context:
-- 
1.8.3.2

