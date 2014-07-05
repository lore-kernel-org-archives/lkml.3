Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965327AbaGEKpk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:45:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965289AbaGEKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:45:35 -0400
Date: Sat, 5 Jul 2014 03:44:37 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-28a21745190a0ca613cab817bfe3dc65373158bf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1403538378-31571-2-git-send-email-riel@redhat.com>
References: <1403538378-31571-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Move power adjustment into load_too_imbalanced()
Git-Commit-ID: 28a21745190a0ca613cab817bfe3dc65373158bf
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

Commit-ID:  28a21745190a0ca613cab817bfe3dc65373158bf
Gitweb:     http://git.kernel.org/tip/28a21745190a0ca613cab817bfe3dc65373158bf
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 23 Jun 2014 11:46:13 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:34 +0200

sched/numa: Move power adjustment into load_too_imbalanced()

Currently the NUMA code scales the load on each node with the
amount of CPU power available on that node, but it does not
apply any adjustment to the load of the task that is being
moved over.

On systems with SMT/HT, this results in a task being weighed
much more heavily than a CPU core, and a task move that would
even out the load between nodes being disallowed.

The correct thing is to apply the power correction to the
numbers after we have first applied the move of the tasks'
loads to them.

This also allows us to do the power correction with a multiplication,
rather than a division.

Also drop two function arguments for load_too_unbalanced, since it
takes various factors from env already.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: chegu_vinod@hp.com
Cc: mgorman@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403538378-31571-2-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 96b2d39..f287d0b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1062,7 +1062,6 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	if (!cpus)
 		return;
 
-	ns->load = (ns->load * SCHED_CAPACITY_SCALE) / ns->compute_capacity;
 	ns->task_capacity =
 		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE);
 	ns->has_free_capacity = (ns->nr_running < ns->task_capacity);
@@ -1096,18 +1095,30 @@ static void task_numa_assign(struct task_numa_env *env,
 	env->best_cpu = env->dst_cpu;
 }
 
-static bool load_too_imbalanced(long orig_src_load, long orig_dst_load,
-				long src_load, long dst_load,
+static bool load_too_imbalanced(long src_load, long dst_load,
 				struct task_numa_env *env)
 {
 	long imb, old_imb;
+	long orig_src_load, orig_dst_load;
+	long src_capacity, dst_capacity;
+
+	/*
+	 * The load is corrected for the CPU capacity available on each node.
+	 *
+	 * src_load        dst_load
+	 * ------------ vs ---------
+	 * src_capacity    dst_capacity
+	 */
+	src_capacity = env->src_stats.compute_capacity;
+	dst_capacity = env->dst_stats.compute_capacity;
 
 	/* We care about the slope of the imbalance, not the direction. */
 	if (dst_load < src_load)
 		swap(dst_load, src_load);
 
 	/* Is the difference below the threshold? */
-	imb = dst_load * 100 - src_load * env->imbalance_pct;
+	imb = dst_load * src_capacity * 100 -
+	      src_load * dst_capacity * env->imbalance_pct;
 	if (imb <= 0)
 		return false;
 
@@ -1115,10 +1126,14 @@ static bool load_too_imbalanced(long orig_src_load, long orig_dst_load,
 	 * The imbalance is above the allowed threshold.
 	 * Compare it with the old imbalance.
 	 */
+	orig_src_load = env->src_stats.load;
+	orig_dst_load = env->dst_stats.load;
+
 	if (orig_dst_load < orig_src_load)
 		swap(orig_dst_load, orig_src_load);
 
-	old_imb = orig_dst_load * 100 - orig_src_load * env->imbalance_pct;
+	old_imb = orig_dst_load * src_capacity * 100 -
+		  orig_src_load * dst_capacity * env->imbalance_pct;
 
 	/* Would this change make things worse? */
 	return (imb > old_imb);
@@ -1136,8 +1151,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	struct rq *src_rq = cpu_rq(env->src_cpu);
 	struct rq *dst_rq = cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
-	long orig_src_load, src_load;
-	long orig_dst_load, dst_load;
+	long src_load, dst_load;
 	long load;
 	long imp = (groupimp > 0) ? groupimp : taskimp;
 
@@ -1211,13 +1225,9 @@ static void task_numa_compare(struct task_numa_env *env,
 	 * In the overloaded case, try and keep the load balanced.
 	 */
 balance:
-	orig_dst_load = env->dst_stats.load;
-	orig_src_load = env->src_stats.load;
-
-	/* XXX missing capacity terms */
 	load = task_h_load(env->p);
-	dst_load = orig_dst_load + load;
-	src_load = orig_src_load - load;
+	dst_load = env->dst_stats.load + load;
+	src_load = env->src_stats.load - load;
 
 	if (cur) {
 		load = task_h_load(cur);
@@ -1225,8 +1235,7 @@ balance:
 		src_load += load;
 	}
 
-	if (load_too_imbalanced(orig_src_load, orig_dst_load,
-				src_load, dst_load, env))
+	if (load_too_imbalanced(src_load, dst_load, env))
 		goto unlock;
 
 assign:
