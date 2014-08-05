Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaHEV4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbaHEV4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:56:32 -0400
Date: Tue, 5 Aug 2014 17:55:30 -0400
From: Rik van Riel <riel@redhat.com>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@kernel.org
Subject: [PATCH] sched,numa: fix "Examine a task move when examining a task
 swap"
Message-ID: <20140805175530.59a9a46e@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in changeset 83230590 can occasionally get tripped up
by the "src_rq->nr_running == 1 && dst_rq->nr_running == 1"
check, and lead to undesirable and/or useless task moves, as
well as idle CPUs.

Luckily this bug can be avoided in a way that also simplifies
the code.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 376bc07c..32edd2c56 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1159,7 +1159,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	long src_load, dst_load;
 	long load;
 	long imp = env->p->numa_group ? groupimp : taskimp;
-	long moveimp = imp;
+	long moveimp = imp - 1;
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
@@ -1206,8 +1206,18 @@ static void task_numa_compare(struct task_numa_env *env,
 		}
 	}
 
-	if (imp <= env->best_imp && moveimp <= env->best_imp)
-		goto unlock;
+	if (imp <= env->best_imp) {
+		if (moveimp <= env->best_imp)
+			goto unlock;
+
+		/*
+		 * A task swap is not going to work; a task move may be
+		 * required to consolidate this workload, especially if
+		 * both nodes are overloaded and there are no idle CPUs.
+		 */
+		imp = moveimp;
+		cur = NULL;
+	}
 
 	if (!cur) {
 		/* Is there capacity at our destination? */
@@ -1231,23 +1241,6 @@ static void task_numa_compare(struct task_numa_env *env,
 	dst_load = env->dst_stats.load + load;
 	src_load = env->src_stats.load - load;
 
-	if (moveimp > imp && moveimp > env->best_imp) {
-		/*
-		 * If the improvement from just moving env->p direction is
-		 * better than swapping tasks around, check if a move is
-		 * possible. Store a slightly smaller score than moveimp,
-		 * so an actually idle CPU will win.
-		 */
-		if (!load_too_imbalanced(src_load, dst_load, env)) {
-			imp = moveimp - 1;
-			cur = NULL;
-			goto assign;
-		}
-	}
-
-	if (imp <= env->best_imp)
-		goto unlock;
-
 	if (cur) {
 		load = task_h_load(cur);
 		dst_load -= load;

