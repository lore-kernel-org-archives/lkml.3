Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab3CZGBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:01:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59821 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3CZGA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:00:59 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-54-515139972cd3
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 4/6] sched: move up affinity check to mitigate useless redoing overhead
Date: Tue, 26 Mar 2013 15:01:38 +0900
Message-Id: <1364277700-7509-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, LBF_ALL_PINNED is cleared after affinity check is passed.
So, if task migration is skipped by small load value or
small imbalance value in move_tasks(), we don't clear LBF_ALL_PINNED.
At last, we trigger 'redo' in load_balance().

Imbalance value is often so small that any tasks cannot be moved
to other cpus and, of course, this situation may be continued after
we change the target cpu. So this patch move up affinity check code and
clear LBF_ALL_PINNED before evaluating load value in order to
mitigate useless redoing overhead.

In addition, re-order some comments correctly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3f8c4f2..d3c6011 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3874,10 +3874,14 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	int tsk_cache_hot = 0;
 	/*
 	 * We do not migrate tasks that are:
-	 * 1) running (obviously), or
+	 * 1) throttled_lb_pair, or
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
-	 * 3) are cache-hot on their current CPU.
+	 * 3) running (obviously), or
+	 * 4) are cache-hot on their current CPU.
 	 */
+	if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
+		return 0;
+
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
 		int new_dst_cpu;
 
@@ -3948,9 +3952,6 @@ static int move_one_task(struct lb_env *env)
 	struct task_struct *p, *n;
 
 	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
-		if (throttled_lb_pair(task_group(p), env->src_rq->cpu, env->dst_cpu))
-			continue;
-
 		if (!can_migrate_task(p, env))
 			continue;
 
@@ -4002,7 +4003,7 @@ static int move_tasks(struct lb_env *env)
 			break;
 		}
 
-		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
+		if (!can_migrate_task(p, env))
 			goto next;
 
 		load = task_h_load(p);
@@ -4013,9 +4014,6 @@ static int move_tasks(struct lb_env *env)
 		if ((load / 2) > env->imbalance)
 			goto next;
 
-		if (!can_migrate_task(p, env))
-			goto next;
-
 		move_task(p, env);
 		pulled++;
 		env->imbalance -= load;
-- 
1.7.9.5

