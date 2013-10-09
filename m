Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab3JIRdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:33:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab3JIRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:33:47 -0400
Date: Wed, 9 Oct 2013 10:32:42 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-887c290e82e8950d854730c084904c115fc367ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-54-git-send-email-mgorman@suse.de>
References: <1381141781-10992-54-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Decide whether to favour task or group weights based on swap candidate relationships
Git-Commit-ID: 887c290e82e8950d854730c084904c115fc367ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:32:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  887c290e82e8950d854730c084904c115fc367ac
Gitweb:     http://git.kernel.org/tip/887c290e82e8950d854730c084904c115fc367ac
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:06 +0200

sched/numa: Decide whether to favour task or group weights based on swap candidate relationships

This patch separately considers task and group affinities when searching
for swap candidates during task NUMA placement. If tasks are not part of
a group or the same group then the task weights are considered.
Otherwise the group weights are compared.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-54-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 59 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2876a37..6f45461 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1039,13 +1039,15 @@ static void task_numa_assign(struct task_numa_env *env,
  * into account that it might be best if task running on the dst_cpu should
  * be exchanged with the source task
  */
-static void task_numa_compare(struct task_numa_env *env, long imp)
+static void task_numa_compare(struct task_numa_env *env,
+			      long taskimp, long groupimp)
 {
 	struct rq *src_rq = cpu_rq(env->src_cpu);
 	struct rq *dst_rq = cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
 	long dst_load, src_load;
 	long load;
+	long imp = (groupimp > 0) ? groupimp : taskimp;
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
@@ -1064,10 +1066,19 @@ static void task_numa_compare(struct task_numa_env *env, long imp)
 		if (!cpumask_test_cpu(env->src_cpu, tsk_cpus_allowed(cur)))
 			goto unlock;
 
-		imp += task_weight(cur, env->src_nid) +
-		       group_weight(cur, env->src_nid) -
-		       task_weight(cur, env->dst_nid) -
-		       group_weight(cur, env->dst_nid);
+		/*
+		 * If dst and source tasks are in the same NUMA group, or not
+		 * in any group then look only at task weights otherwise give
+		 * priority to the group weights.
+		 */
+		if (!cur->numa_group || !env->p->numa_group ||
+		    cur->numa_group == env->p->numa_group) {
+			imp = taskimp + task_weight(cur, env->src_nid) -
+			      task_weight(cur, env->dst_nid);
+		} else {
+			imp = groupimp + group_weight(cur, env->src_nid) -
+			       group_weight(cur, env->dst_nid);
+		}
 	}
 
 	if (imp < env->best_imp)
@@ -1117,7 +1128,8 @@ unlock:
 	rcu_read_unlock();
 }
 
-static void task_numa_find_cpu(struct task_numa_env *env, long imp)
+static void task_numa_find_cpu(struct task_numa_env *env,
+				long taskimp, long groupimp)
 {
 	int cpu;
 
@@ -1127,7 +1139,7 @@ static void task_numa_find_cpu(struct task_numa_env *env, long imp)
 			continue;
 
 		env->dst_cpu = cpu;
-		task_numa_compare(env, imp);
+		task_numa_compare(env, taskimp, groupimp);
 	}
 }
 
@@ -1146,9 +1158,9 @@ static int task_numa_migrate(struct task_struct *p)
 		.best_cpu = -1
 	};
 	struct sched_domain *sd;
-	unsigned long weight;
+	unsigned long taskweight, groupweight;
 	int nid, ret;
-	long imp;
+	long taskimp, groupimp;
 
 	/*
 	 * Pick the lowest SD_NUMA domain, as that would have the smallest
@@ -1163,15 +1175,17 @@ static int task_numa_migrate(struct task_struct *p)
 	env.imbalance_pct = 100 + (sd->imbalance_pct - 100) / 2;
 	rcu_read_unlock();
 
-	weight = task_weight(p, env.src_nid) + group_weight(p, env.src_nid);
+	taskweight = task_weight(p, env.src_nid);
+	groupweight = group_weight(p, env.src_nid);
 	update_numa_stats(&env.src_stats, env.src_nid);
 	env.dst_nid = p->numa_preferred_nid;
-	imp = task_weight(p, env.dst_nid) + group_weight(p, env.dst_nid) - weight;
+	taskimp = task_weight(p, env.dst_nid) - taskweight;
+	groupimp = group_weight(p, env.dst_nid) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
 	/* If the preferred nid has capacity, try to use it. */
 	if (env.dst_stats.has_capacity)
-		task_numa_find_cpu(&env, imp);
+		task_numa_find_cpu(&env, taskimp, groupimp);
 
 	/* No space available on the preferred nid. Look elsewhere. */
 	if (env.best_cpu == -1) {
@@ -1180,13 +1194,14 @@ static int task_numa_migrate(struct task_struct *p)
 				continue;
 
 			/* Only consider nodes where both task and groups benefit */
-			imp = task_weight(p, nid) + group_weight(p, nid) - weight;
-			if (imp < 0)
+			taskimp = task_weight(p, nid) - taskweight;
+			groupimp = group_weight(p, nid) - groupweight;
+			if (taskimp < 0 && groupimp < 0)
 				continue;
 
 			env.dst_nid = nid;
 			update_numa_stats(&env.dst_stats, env.dst_nid);
-			task_numa_find_cpu(&env, imp);
+			task_numa_find_cpu(&env, taskimp, groupimp);
 		}
 	}
 
@@ -4679,10 +4694,9 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 	if (dst_nid == p->numa_preferred_nid)
 		return true;
 
-	/* After the task has settled, check if the new node is better. */
-	if (p->numa_migrate_seq >= sysctl_numa_balancing_settle_count &&
-			task_weight(p, dst_nid) + group_weight(p, dst_nid) >
-			task_weight(p, src_nid) + group_weight(p, src_nid))
+	/* If both task and group weight improve, this move is a winner. */
+	if (task_weight(p, dst_nid) > task_weight(p, src_nid) &&
+	    group_weight(p, dst_nid) > group_weight(p, src_nid))
 		return true;
 
 	return false;
@@ -4709,10 +4723,9 @@ static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	if (src_nid == p->numa_preferred_nid)
 		return true;
 
-	/* After the task has settled, check if the new node is worse. */
-	if (p->numa_migrate_seq >= sysctl_numa_balancing_settle_count &&
-			task_weight(p, dst_nid) + group_weight(p, dst_nid) <
-			task_weight(p, src_nid) + group_weight(p, src_nid))
+	/* If either task or group weight get worse, don't do it. */
+	if (task_weight(p, dst_nid) < task_weight(p, src_nid) ||
+	    group_weight(p, dst_nid) < group_weight(p, src_nid))
 		return true;
 
 	return false;
