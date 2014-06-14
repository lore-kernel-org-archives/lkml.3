Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaFNTkK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:40:10 -0400
Received: from shelob.surriel.com ([74.92.59.67]:45556 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaFNTkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:40:06 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH 3/3] sched,numa: use effective_load to balance NUMA loads
Date: Sat, 14 Jun 2014 15:18:59 -0400
Message-Id: <1402773539-6466-4-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1402773539-6466-1-git-send-email-riel@redhat.com>
References: <1402773539-6466-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

When CONFIG_FAIR_GROUP_SCHED is enabled, the load that a task places
on a CPU is determined by the group the task is in. This is conveniently
calculated for us by effective_load(), which task_numa_compare should
use.

The active groups on the source and destination CPU can be different,
so the calculation needs to be done separately for each CPU.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 976dd73..aafc37c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1151,6 +1151,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	struct rq *src_rq = cpu_rq(env->src_cpu);
 	struct rq *dst_rq = cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
+	struct task_group *tg;
 	long src_load, dst_load;
 	long load;
 	long imp = (groupimp > 0) ? groupimp : taskimp;
@@ -1225,14 +1226,21 @@ static void task_numa_compare(struct task_numa_env *env,
 	 * In the overloaded case, try and keep the load balanced.
 	 */
 balance:
+	src_load = env->src_stats.load;
+	dst_load = env->dst_stats.load;
+
+	/* Calculate the effect of moving env->p from src to dst. */
 	load = task_h_load(env->p);
-	dst_load = env->dst_stats.load + load;
-	src_load = env->src_stats.load - load;
+	tg = task_group(env->p);
+	src_load += effective_load(tg, env->src_cpu, -load, -load);
+	dst_load += effective_load(tg, env->dst_cpu, load, load);
 
 	if (cur) {
+		/* Cur moves in the opposite direction. */
 		load = task_h_load(cur);
-		dst_load -= load;
-		src_load += load;
+		tg = task_group(cur);
+		src_load += effective_load(tg, env->src_cpu, load, load);
+		dst_load += effective_load(tg, env->dst_cpu, -load, -load);
 	}
 
 	if (load_too_imbalanced(src_load, dst_load, env))
-- 
1.8.5.3

