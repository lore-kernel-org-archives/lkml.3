Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3BNFtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:49:51 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62764 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3BNFsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:50 -0500
X-AuditID: 9c93016f-b7b1fae000006419-23-511c7abf13b8
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 5/8] sched: move up affinity check to mitigate useless redoing overhead
Date: Thu, 14 Feb 2013 14:48:38 +0900
Message-Id: <1360820921-2513-6-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, LBF_ALL_PINNED is cleared after affinity check is passed.
So, if can_migrate_task() is failed by small load value or small
imbalance value, we don't clear LBF_ALL_PINNED. At last, we trigger
'redo' in load_balance().

Imbalance value is often so small that any tasks cannot be moved
to other cpus and, of course, this situaltion may be continued after
we change the target cpu. So this patch clear LBF_ALL_PINNED in order
to mitigate useless redoing overhead, if can_migrate_task() is failed
by above reason.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 849bc8e..bb373f4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3888,9 +3888,9 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env,
 	/*
 	 * We do not migrate tasks that are:
 	 * 1) throttled_lb_pair, or
-	 * 2) task's load is too low, or
-	 * 3) task's too large to imbalance, or
-	 * 4) cannot be migrated to this CPU due to cpus_allowed, or
+	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
+	 * 3) task's load is too low, or
+	 * 4) task's too large to imbalance, or
 	 * 5) running (obviously), or
 	 * 6) are cache-hot on their current CPU.
 	 */
@@ -3898,16 +3898,6 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env,
 	if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
 		return 0;
 
-	if (!lb_active) {
-		*load = task_h_load(p);
-		if (sched_feat(LB_MIN) &&
-			*load < 16 && !env->sd->nr_balance_failed)
-			return 0;
-
-		if ((*load / 2) > env->imbalance)
-			return 0;
-	}
-
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
 		int new_dst_cpu;
 
@@ -3936,6 +3926,16 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env,
 	/* Record that we found atleast one task that could run on dst_cpu */
 	env->flags &= ~LBF_ALL_PINNED;
 
+	if (!lb_active) {
+		*load = task_h_load(p);
+		if (sched_feat(LB_MIN) &&
+			*load < 16 && !env->sd->nr_balance_failed)
+			return 0;
+
+		if ((*load / 2) > env->imbalance)
+			return 0;
+	}
+
 	if (task_running(env->src_rq, p)) {
 		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
 		return 0;
-- 
1.7.9.5

