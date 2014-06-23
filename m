Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaFWWan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaFWWal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:30:41 -0400
Date: Mon, 23 Jun 2014 18:30:11 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.org, mgorman@suse.de,
        mingo@kernel.org
Subject: [PATCH 8/7] sched,numa: do not let a move increase the imbalance
Message-ID: <20140623183011.28555a7c@annuminas.surriel.com>
In-Reply-To: <1403538095-31256-1-git-send-email-riel@redhat.com>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HP DL980 system has a different NUMA topology from the 8 node
system I am testing on, and showed some bad behaviour I have not
managed to reproduce. This patch makes sure workloads converge.

When both a task swap and a task move are possible, do not let the
task move cause an increase in the load imbalance. Forcing task swaps
can help untangle workloads that have gotten stuck fighting over the
same nodes, like this run of "perf bench numa -m -0 -p 1000 -p 16 -t 15":

Per-node process memory usage (in MBs)
38035 (process 0      2      0      0      1   1000      0      0      0  1003
38036 (process 1      2      0      0      1      0   1000      0      0  1003
38037 (process 2    230    772      0      1      0      0      0      0  1003
38038 (process 3      1      0      0   1003      0      0      0      0  1004
38039 (process 4      2      0      0      1      0      0    994      6  1003
38040 (process 5      2      0      0      1    994      0      0      6  1003
38041 (process 6      2      0   1000      1      0      0      0      0  1003
38042 (process 7   1003      0      0      1      0      0      0      0  1004
38043 (process 8      2      0      0      1      0   1000      0      0  1003
38044 (process 9      2      0      0      1      0      0      0   1000  1003
38045 (process 1   1002      0      0      1      0      0      0      0  1003
38046 (process 1      3      0    954      1      0      0      0     46  1004
38047 (process 1      2   1000      0      1      0      0      0      0  1003
38048 (process 1      2      0      0      1      0      0   1000      0  1003
38049 (process 1      2      0      0   1001      0      0      0      0  1003
38050 (process 1      2    934      0     67      0      0      0      0  1003

Allowing task moves to increase the imbalance even slightly causes
tasks to move towards node 1, and not towards node 7, which prevents
the workload from converging once the above scenario has been reached.

Reported-and-tested-by: Vinod Chegu <chegu_vinod@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4723234..e98d290 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1314,6 +1314,12 @@ static void task_numa_compare(struct task_numa_env *env,
 
 	if (moveimp > imp && moveimp > env->best_imp) {
 		/*
+		 * A task swap is possible, do not let a task move
+		 * increase the imbalance.
+		 */
+		int imbalance_pct = env->imbalance_pct;
+		env->imbalance_pct = 100;
+		/*
 		 * If the improvement from just moving env->p direction is
 		 * better than swapping tasks around, check if a move is
 		 * possible. Store a slightly smaller score than moveimp,
@@ -1324,6 +1330,8 @@ static void task_numa_compare(struct task_numa_env *env,
 			cur = NULL;
 			goto assign;
 		}
+
+		env->imbalance_pct = imbalance_pct;
 	}
 
 	if (imp <= env->best_imp)

