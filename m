Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965363AbaGEKqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:46:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965314AbaGEKpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:45:39 -0400
Date: Sat, 5 Jul 2014 03:44:51 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-6dc1a672ab15604947361dcd02e459effa09bad5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1403538378-31571-3-git-send-email-riel@redhat.com>
References: <1403538378-31571-3-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Use effective_load()
  to balance NUMA loads
Git-Commit-ID: 6dc1a672ab15604947361dcd02e459effa09bad5
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

Commit-ID:  6dc1a672ab15604947361dcd02e459effa09bad5
Gitweb:     http://git.kernel.org/tip/6dc1a672ab15604947361dcd02e459effa09bad5
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 23 Jun 2014 11:46:14 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:35 +0200

sched/numa: Use effective_load() to balance NUMA loads

When CONFIG_FAIR_GROUP_SCHED is enabled, the load that a task places
on a CPU is determined by the group the task is in. The active groups
on the source and destination CPU can be different, resulting in a
different load contribution by the same task at its source and at its
destination. As a result, the load needs to be calculated separately
for each CPU, instead of estimated once with task_h_load().

Getting this calculation right allows some workloads to converge,
where previously the last thread could get stuck on another node,
without being able to migrate to its final destination.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403538378-31571-3-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f287d0b..d6526d2 100644
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
-	load = task_h_load(env->p);
-	dst_load = env->dst_stats.load + load;
-	src_load = env->src_stats.load - load;
+	src_load = env->src_stats.load;
+	dst_load = env->dst_stats.load;
+
+	/* Calculate the effect of moving env->p from src to dst. */
+	load = env->p->se.load.weight;
+	tg = task_group(env->p);
+	src_load += effective_load(tg, env->src_cpu, -load, -load);
+	dst_load += effective_load(tg, env->dst_cpu, load, load);
 
 	if (cur) {
-		load = task_h_load(cur);
-		dst_load -= load;
-		src_load += load;
+		/* Cur moves in the opposite direction. */
+		load = cur->se.load.weight;
+		tg = task_group(cur);
+		src_load += effective_load(tg, env->src_cpu, load, load);
+		dst_load += effective_load(tg, env->dst_cpu, -load, -load);
 	}
 
 	if (load_too_imbalanced(src_load, dst_load, env))
