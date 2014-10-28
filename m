Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbaJ1LFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:05:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaJ1LFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:05:39 -0400
Date: Tue, 28 Oct 2014 04:04:37 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-7bd953206b0b5e0a3aded871982367410b42e1b1@git.kernel.org>
Cc: chegu_vinod@hp.com, torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        riel@redhat.com, hpa@zytor.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org, chegu_vinod@hp.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, peterz@infradead.org,
        riel@redhat.com, hpa@zytor.com
In-Reply-To: <1413530994-9732-4-git-send-email-riel@redhat.com>
References: <1413530994-9732-4-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Prepare for complex topology placement
Git-Commit-ID: 7bd953206b0b5e0a3aded871982367410b42e1b1
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

Commit-ID:  7bd953206b0b5e0a3aded871982367410b42e1b1
Gitweb:     http://git.kernel.org/tip/7bd953206b0b5e0a3aded871982367410b42e1b1
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 17 Oct 2014 03:29:51 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:49 +0100

sched/numa: Prepare for complex topology placement

Preparatory patch for adding NUMA placement on systems with
complex NUMA topology. Also fix a potential divide by zero
in group_weight()

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1413530994-9732-4-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 57 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 34baa60..0af3bed 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -931,9 +931,10 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
  * larger multiplier, in order to group tasks together that are almost
  * evenly spread out between numa nodes.
  */
-static inline unsigned long task_weight(struct task_struct *p, int nid)
+static inline unsigned long task_weight(struct task_struct *p, int nid,
+					int dist)
 {
-	unsigned long total_faults;
+	unsigned long faults, total_faults;
 
 	if (!p->numa_faults_memory)
 		return 0;
@@ -943,15 +944,25 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
 	if (!total_faults)
 		return 0;
 
-	return 1000 * task_faults(p, nid) / total_faults;
+	faults = task_faults(p, nid);
+	return 1000 * faults / total_faults;
 }
 
-static inline unsigned long group_weight(struct task_struct *p, int nid)
+static inline unsigned long group_weight(struct task_struct *p, int nid,
+					 int dist)
 {
-	if (!p->numa_group || !p->numa_group->total_faults)
+	unsigned long faults, total_faults;
+
+	if (!p->numa_group)
+		return 0;
+
+	total_faults = p->numa_group->total_faults;
+
+	if (!total_faults)
 		return 0;
 
-	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
+	faults = group_faults(p, nid);
+	return 1000 * faults / total_faults;
 }
 
 bool should_numa_migrate_memory(struct task_struct *p, struct page * page,
@@ -1084,6 +1095,7 @@ struct task_numa_env {
 	struct numa_stats src_stats, dst_stats;
 
 	int imbalance_pct;
+	int dist;
 
 	struct task_struct *best_task;
 	long best_imp;
@@ -1163,6 +1175,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	long load;
 	long imp = env->p->numa_group ? groupimp : taskimp;
 	long moveimp = imp;
+	int dist = env->dist;
 
 	rcu_read_lock();
 
@@ -1196,8 +1209,8 @@ static void task_numa_compare(struct task_numa_env *env,
 		 * in any group then look only at task weights.
 		 */
 		if (cur->numa_group == env->p->numa_group) {
-			imp = taskimp + task_weight(cur, env->src_nid) -
-			      task_weight(cur, env->dst_nid);
+			imp = taskimp + task_weight(cur, env->src_nid, dist) -
+			      task_weight(cur, env->dst_nid, dist);
 			/*
 			 * Add some hysteresis to prevent swapping the
 			 * tasks within a group over tiny differences.
@@ -1211,11 +1224,11 @@ static void task_numa_compare(struct task_numa_env *env,
 			 * instead.
 			 */
 			if (cur->numa_group)
-				imp += group_weight(cur, env->src_nid) -
-				       group_weight(cur, env->dst_nid);
+				imp += group_weight(cur, env->src_nid, dist) -
+				       group_weight(cur, env->dst_nid, dist);
 			else
-				imp += task_weight(cur, env->src_nid) -
-				       task_weight(cur, env->dst_nid);
+				imp += task_weight(cur, env->src_nid, dist) -
+				       task_weight(cur, env->dst_nid, dist);
 		}
 	}
 
@@ -1314,7 +1327,7 @@ static int task_numa_migrate(struct task_struct *p)
 	};
 	struct sched_domain *sd;
 	unsigned long taskweight, groupweight;
-	int nid, ret;
+	int nid, ret, dist;
 	long taskimp, groupimp;
 
 	/*
@@ -1342,12 +1355,13 @@ static int task_numa_migrate(struct task_struct *p)
 		return -EINVAL;
 	}
 
-	taskweight = task_weight(p, env.src_nid);
-	groupweight = group_weight(p, env.src_nid);
-	update_numa_stats(&env.src_stats, env.src_nid);
 	env.dst_nid = p->numa_preferred_nid;
-	taskimp = task_weight(p, env.dst_nid) - taskweight;
-	groupimp = group_weight(p, env.dst_nid) - groupweight;
+	dist = env.dist = node_distance(env.src_nid, env.dst_nid);
+	taskweight = task_weight(p, env.src_nid, dist);
+	groupweight = group_weight(p, env.src_nid, dist);
+	update_numa_stats(&env.src_stats, env.src_nid);
+	taskimp = task_weight(p, env.dst_nid, dist) - taskweight;
+	groupimp = group_weight(p, env.dst_nid, dist) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
 	/* Try to find a spot on the preferred nid. */
@@ -1359,12 +1373,15 @@ static int task_numa_migrate(struct task_struct *p)
 			if (nid == env.src_nid || nid == p->numa_preferred_nid)
 				continue;
 
+			dist = node_distance(env.src_nid, env.dst_nid);
+
 			/* Only consider nodes where both task and groups benefit */
-			taskimp = task_weight(p, nid) - taskweight;
-			groupimp = group_weight(p, nid) - groupweight;
+			taskimp = task_weight(p, nid, dist) - taskweight;
+			groupimp = group_weight(p, nid, dist) - groupweight;
 			if (taskimp < 0 && groupimp < 0)
 				continue;
 
+			env.dist = dist;
 			env.dst_nid = nid;
 			update_numa_stats(&env.dst_stats, env.dst_nid);
 			task_numa_find_cpu(&env, taskimp, groupimp);
