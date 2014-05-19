Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbaESNL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:11:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbaESNL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:11:57 -0400
Date: Mon, 19 May 2014 06:10:58 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-b1fda183e09d70ea75d478ea055e2b6059476eff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140514132221.274b3463@annuminas.surriel.com>
References: <20140514132221.274b3463@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched,numa:
  Allow task switch if load imbalance improves
Git-Commit-ID: b1fda183e09d70ea75d478ea055e2b6059476eff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1fda183e09d70ea75d478ea055e2b6059476eff
Gitweb:     http://git.kernel.org/tip/b1fda183e09d70ea75d478ea055e2b6059476eff
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Wed, 14 May 2014 13:22:21 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:42 +0900

sched,numa: Allow task switch if load imbalance improves

Currently the NUMA balancing code only allows moving tasks between NUMA
nodes when the load on both nodes is in balance. This breaks down when
the load was imbalanced to begin with.

Allow tasks to be moved between NUMA nodes if the imbalance is small,
or if the new imbalance is be smaller than the original one.

Cc: mingo@kernel.org
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140514132221.274b3463@annuminas.surriel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c | 46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f7cac2b..b899613 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1095,6 +1095,34 @@ static void task_numa_assign(struct task_numa_env *env,
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
@@ -1107,7 +1135,8 @@ static void task_numa_compare(struct task_numa_env *env,
 	struct rq *src_rq = cpu_rq(env->src_cpu);
 	struct rq *dst_rq = cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
-	long dst_load, src_load;
+	long orig_src_load, src_load;
+	long orig_dst_load, dst_load;
 	long load;
 	long imp = (groupimp > 0) ? groupimp : taskimp;
 
@@ -1181,13 +1210,13 @@ static void task_numa_compare(struct task_numa_env *env,
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
@@ -1195,11 +1224,8 @@ balance:
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
