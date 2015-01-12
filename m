Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbbALVbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:31:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbbALVbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:31:46 -0500
Date: Mon, 12 Jan 2015 16:30:39 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mgorman@suse.de, peterz@infradead.org, mingo@redhat.com
Subject: [PATCH] sched,numa: do not move past the balance point if
 unbalanced
Message-ID: <20150112163039.7eb9a9e0@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a subtle interaction between the logic introduced in commit
e63da03639cc9e6e83b62e7ef8ffdbb92421416a, the way the load balancer
counts the load on each NUMA node, and the way NUMA hinting faults are
done.

Specifically, the load balancer only counts currently running tasks
in the load, while NUMA hinting faults may cause tasks to stop, if
the page is locked by another task.

This could cause all of the threads of a large single instance workload,
like SPECjbb2005, to migrate to the same NUMA node. This was possible
because occasionally they all fault on the same few pages, and only one
of the threads remains runnable. That thread can move to the process's
preferred NUMA node without making the imbalance worse, because nothing
else is running at that time.

The fix is to check the direction of the net moving of load, and to
refuse a NUMA move if it would cause the system to move past the point
of balance.  In an unbalanced state, only moves that bring us closer
to the balance point are allowed.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 40667cb..5b07eef 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1197,9 +1197,11 @@ static void task_numa_assign(struct task_numa_env *env,
 static bool load_too_imbalanced(long src_load, long dst_load,
 				struct task_numa_env *env)
 {
-	long imb, old_imb;
-	long orig_src_load, orig_dst_load;
 	long src_capacity, dst_capacity;
+	long orig_src_load;
+	long load_a, load_b;
+	long moved_load;
+	long imb;
 
 	/*
 	 * The load is corrected for the CPU capacity available on each node.
@@ -1212,30 +1214,38 @@ static bool load_too_imbalanced(long src_load, long dst_load,
 	dst_capacity = env->dst_stats.compute_capacity;
 
 	/* We care about the slope of the imbalance, not the direction. */
-	if (dst_load < src_load)
-		swap(dst_load, src_load);
+	load_a = dst_load;
+	load_b = src_load;
+	if (load_a < load_b)
+		swap(load_a, load_b);
 
 	/* Is the difference below the threshold? */
-	imb = dst_load * src_capacity * 100 -
-	      src_load * dst_capacity * env->imbalance_pct;
+	imb = load_a * src_capacity * 100 -
+	      load_b * dst_capacity * env->imbalance_pct;
 	if (imb <= 0)
 		return false;
 
 	/*
 	 * The imbalance is above the allowed threshold.
-	 * Compare it with the old imbalance.
+	 * Allow the move if it brings us closer to a balanced situation,
+	 * without moving things past the point of balance.
 	 */
 	orig_src_load = env->src_stats.load;
-	orig_dst_load = env->dst_stats.load;
 
-	if (orig_dst_load < orig_src_load)
-		swap(orig_dst_load, orig_src_load);
-
-	old_imb = orig_dst_load * src_capacity * 100 -
-		  orig_src_load * dst_capacity * env->imbalance_pct;
+	/*
+	 * In a task swap, there will be one load moving from src to dst,
+	 * and another moving back. This is the net sum of both moves.
+	 * Allow the move if it brings the system closer to a balanced
+	 * situation, without crossing over the balance point.
+	 */
+	moved_load = orig_src_load - src_load;
 
-	/* Would this change make things worse? */
-	return (imb > old_imb);
+	if (moved_load > 0)
+		/* Moving src -> dst. Did we overshoot balance? */
+		return src_load < dst_load;
+	else
+		/* Moving dst -> src. Did we overshoot balance? */
+		return dst_load < src_load;
 }
 
 /*
