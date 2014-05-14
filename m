Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaENRWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:22:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbaENRWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:22:49 -0400
Date: Wed, 14 May 2014 13:22:21 -0400
From: Rik van Riel <riel@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH] sched,numa: allow task switch if load imbalance improves
Message-ID: <20140514132221.274b3463@annuminas.surriel.com>
In-Reply-To: <20140514152943.GO30445@twins.programming.kicks-ass.net>
References: <20140513195550.315a92bf@annuminas.surriel.com>
	<20140514152943.GO30445@twins.programming.kicks-ass.net>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 17:29:43 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> In that case I think we want to limit the swap such that the imbalance
> improves (ie. gets smaller).
> 
> Something like the below perhaps (entirely untested).

You are absolutely right.

This is what it looks like with a helper function and more comments.

---8<---

Subject: sched,numa: allow task switch if load imbalance improves

Currently the NUMA balancing code only allows moving tasks between NUMA
nodes when the load on both nodes is in balance. This breaks down when
the load was imbalanced to begin with.

Allow tasks to be moved between NUMA nodes if the imbalance is small,
or if the new imbalance is be smaller than the original one.

Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c | 46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b8c6a01..887bd64 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1124,6 +1124,34 @@ static void task_numa_assign(struct task_numa_env *env,
 	env->best_cpu = env->dst_cpu;
 }
 
+static bool load_too_imbalanced(long orig_src_load, long orig_dst_load,
+				long src_load, long dst_load,
+				struct task_numa_env *env)
+{
+	long imb, old_imb;
+
+	/* We care about the slope of the imbalance, not the direction. */
+	if (dst_load < src_load)
+		swap(dst_load, src_load);
+
+	/* Is the difference below the threshold? */
+	imb = dst_load * 100 - src_load * env->imbalance_pct;
+	if (imb <= 0)
+		return false;
+
+	/*
+	 * The imbalance is above the allowed threshold.
+	 * Compare it with the old imbalance.
+	 */
+	if (orig_dst_load < orig_src_load)
+		swap(orig_dst_load, orig_src_load);
+	
+	old_imb = orig_dst_load * 100 - orig_src_load * env->imbalance_pct;
+
+	/* Would this change make things worse? */
+	return (old_imb > imb);
+}
+
 /*
  * This checks if the overall compute and NUMA accesses of the system would
  * be improved if the source tasks was migrated to the target dst_cpu taking
@@ -1136,7 +1164,8 @@ static void task_numa_compare(struct task_numa_env *env,
 	struct rq *src_rq = cpu_rq(env->src_cpu);
 	struct rq *dst_rq = cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
-	long dst_load, src_load;
+	long orig_src_load, src_load;
+	long orig_dst_load, dst_load;
 	long load;
 	long imp = (groupimp > 0) ? groupimp : taskimp;
 
@@ -1210,13 +1239,13 @@ static void task_numa_compare(struct task_numa_env *env,
 	 * In the overloaded case, try and keep the load balanced.
 	 */
 balance:
-	dst_load = env->dst_stats.load;
-	src_load = env->src_stats.load;
+	orig_dst_load = env->dst_stats.load;
+	orig_src_load = env->src_stats.load;
 
 	/* XXX missing power terms */
 	load = task_h_load(env->p);
-	dst_load += load;
-	src_load -= load;
+	dst_load = orig_dst_load + load;
+	src_load = orig_src_load - load;
 
 	if (cur) {
 		load = task_h_load(cur);
@@ -1224,11 +1253,8 @@ static void task_numa_compare(struct task_numa_env *env,
 		src_load += load;
 	}
 
-	/* make src_load the smaller */
-	if (dst_load < src_load)
-		swap(dst_load, src_load);
-
-	if (src_load * env->imbalance_pct < dst_load * 100)
+	if (load_too_imbalanced(orig_src_load, orig_dst_load,
+				src_load, dst_load, env))
 		goto unlock;
 
 assign:

