Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab3BNFue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:50:34 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54445 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3BNFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:49 -0500
X-AuditID: 9c93016f-b7b1fae000006419-22-511c7abf7529
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/8] sched: clean up move_task() and move_one_task()
Date: Thu, 14 Feb 2013 14:48:37 +0900
Message-Id: <1360820921-2513-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some validation for task moving is performed in move_tasks() and
move_one_task(). We can move these code to can_migrate_task()
which is already exist for this purpose.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 97498f4..849bc8e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3874,19 +3874,40 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	return delta < (s64)sysctl_sched_migration_cost;
 }
 
+static unsigned long task_h_load(struct task_struct *p);
+
 /*
  * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
+ * @load is only meaningful when !@lb_active and return value is true
  */
 static
-int can_migrate_task(struct task_struct *p, struct lb_env *env)
+int can_migrate_task(struct task_struct *p, struct lb_env *env,
+				bool lb_active, unsigned long *load)
 {
 	int tsk_cache_hot = 0;
 	/*
 	 * We do not migrate tasks that are:
-	 * 1) running (obviously), or
-	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
-	 * 3) are cache-hot on their current CPU.
+	 * 1) throttled_lb_pair, or
+	 * 2) task's load is too low, or
+	 * 3) task's too large to imbalance, or
+	 * 4) cannot be migrated to this CPU due to cpus_allowed, or
+	 * 5) running (obviously), or
+	 * 6) are cache-hot on their current CPU.
 	 */
+
+	if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
+		return 0;
+
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
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
 		int new_dst_cpu;
 
@@ -3957,10 +3978,7 @@ static int move_one_task(struct lb_env *env)
 	struct task_struct *p, *n;
 
 	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
-		if (throttled_lb_pair(task_group(p), env->src_rq->cpu, env->dst_cpu))
-			continue;
-
-		if (!can_migrate_task(p, env))
+		if (!can_migrate_task(p, env, true, NULL))
 			continue;
 
 		move_task(p, env);
@@ -3975,8 +3993,6 @@ static int move_one_task(struct lb_env *env)
 	return 0;
 }
 
-static unsigned long task_h_load(struct task_struct *p);
-
 static const unsigned int sched_nr_migrate_break = 32;
 
 /*
@@ -4011,18 +4027,7 @@ static int move_tasks(struct lb_env *env)
 			break;
 		}
 
-		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
-			goto next;
-
-		load = task_h_load(p);
-
-		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
-			goto next;
-
-		if ((load / 2) > env->imbalance)
-			goto next;
-
-		if (!can_migrate_task(p, env))
+		if (!can_migrate_task(p, env, false, &load))
 			goto next;
 
 		move_task(p, env);
-- 
1.7.9.5

