Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342AbaGEKpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:45:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaGEKpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:45:47 -0400
Date: Sat, 5 Jul 2014 03:45:18 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-ggthh0rnh0yua6o5o3p6cr1o@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Examine a task move when examining a task swap
Git-Commit-ID: 0132c3e1777ceabc24c7d209b7cbe78c28c03c09
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

Commit-ID:  0132c3e1777ceabc24c7d209b7cbe78c28c03c09
Gitweb:     http://git.kernel.org/tip/0132c3e1777ceabc24c7d209b7cbe78c28c03c09
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 23 Jun 2014 11:46:16 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:38 +0200

sched/numa: Examine a task move when examining a task swap

Running "perf bench numa mem -0 -m -P 1000 -p 8 -t 20" on a 4
node system results in 160 runnable threads on a system with 80
CPU threads.

Once a process has nearly converged, with 39 threads on one node
and 1 thread on another node, the remaining thread will be unable
to migrate to its preferred node through a task swap.

However, a simple task move would make the workload converge,
witout causing an imbalance.

Test for this unlikely occurrence, and attempt a task move to
the preferred nid when it happens.

 # Running main, "perf bench numa mem -p 8 -t 20 -0 -m -P 1000"

 ###
 # 160 tasks will execute (on 4 nodes, 80 CPUs):
 #         -1x     0MB global  shared mem operations
 #         -1x  1000MB process shared mem operations
 #         -1x     0MB thread  local  mem operations
 ###

 ###
 #
 #    0.0%  [0.2 mins]  0/0   1/1  36/2   0/0  [36/3 ] l:  0-0   (  0) {0-2}
 #    0.0%  [0.3 mins] 43/3  37/2  39/2  41/3  [ 6/10] l:  0-1   (  1) {1-2}
 #    0.0%  [0.4 mins] 42/3  38/2  40/2  40/2  [ 4/9 ] l:  1-2   (  1) [50.0%] {1-2}
 #    0.0%  [0.6 mins] 41/3  39/2  40/2  40/2  [ 2/9 ] l:  2-4   (  2) [50.0%] {1-2}
 #    0.0%  [0.7 mins] 40/2  40/2  40/2  40/2  [ 0/8 ] l:  3-5   (  2) [40.0%] (  41.8s converged)

Without this patch, this same perf bench numa mem run had to
rely on the scheduler load balancer to first balance out the
load (moving a random task), before a task swap could complete
the NUMA convergence.

The load balancer does not normally take action unless the load

difference exceeds 25%. Convergence times of over half an hour
have been observed without this patch.

With this patch, the NUMA balancing code will simply migrate the
task, if that does not cause an imbalance.

Also skip examining a CPU in detail if the improvement on that CPU
is no more than the best we already have.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: chegu_vinod@hp.com
Cc: mgorman@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-ggthh0rnh0yua6o5o3p6cr1o@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cebb312..9d1734a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1155,6 +1155,7 @@ static void task_numa_compare(struct task_numa_env *env,
 	long src_load, dst_load;
 	long load;
 	long imp = env->p->numa_group ? groupimp : taskimp;
+	long moveimp = imp;
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
@@ -1201,7 +1202,7 @@ static void task_numa_compare(struct task_numa_env *env,
 		}
 	}
 
-	if (imp < env->best_imp)
+	if (imp <= env->best_imp && moveimp <= env->best_imp)
 		goto unlock;
 
 	if (!cur) {
@@ -1214,7 +1215,8 @@ static void task_numa_compare(struct task_numa_env *env,
 	}
 
 	/* Balance doesn't matter much if we're running a task per cpu */
-	if (src_rq->nr_running == 1 && dst_rq->nr_running == 1)
+	if (imp > env->best_imp && src_rq->nr_running == 1 &&
+			dst_rq->nr_running == 1)
 		goto assign;
 
 	/*
@@ -1230,6 +1232,23 @@ balance:
 	src_load += effective_load(tg, env->src_cpu, -load, -load);
 	dst_load += effective_load(tg, env->dst_cpu, load, load);
 
+	if (moveimp > imp && moveimp > env->best_imp) {
+		/*
+		 * If the improvement from just moving env->p direction is
+		 * better than swapping tasks around, check if a move is
+		 * possible. Store a slightly smaller score than moveimp,
+		 * so an actually idle CPU will win.
+		 */
+		if (!load_too_imbalanced(src_load, dst_load, env)) {
+			imp = moveimp - 1;
+			cur = NULL;
+			goto assign;
+		}
+	}
+
+	if (imp <= env->best_imp)
+		goto unlock;
+
 	if (cur) {
 		/* Cur moves in the opposite direction. */
 		load = cur->se.load.weight;
