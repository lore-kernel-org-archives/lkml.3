Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935275AbaGPTZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:25:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935204AbaGPTYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:24:06 -0400
Date: Wed, 16 Jul 2014 12:23:33 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-u6odkgkw8wz3m7orgsjfo5pi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Revert "Use effective_load()
  to balance NUMA loads"
Git-Commit-ID: e720fff6341fe4b95e5a93c939bd3c77fa55ced4
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

Commit-ID:  e720fff6341fe4b95e5a93c939bd3c77fa55ced4
Gitweb:     http://git.kernel.org/tip/e720fff6341fe4b95e5a93c939bd3c77fa55ced4
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 11 Jul 2014 16:01:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:38:23 +0200

sched/numa: Revert "Use effective_load() to balance NUMA loads"

Due to divergent trees, Rik find that this patch is no longer
required.

Requested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-u6odkgkw8wz3m7orgsjfo5pi@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f5f0cc9..45943b2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1151,7 +1151,6 @@ static void task_numa_compare(struct task_numa_env *env,
 	struct rq *src_rq = cpu_rq(env->src_cpu);
 	struct rq *dst_rq = cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
-	struct task_group *tg;
 	long src_load, dst_load;
 	long load;
 	long imp = env->p->numa_group ? groupimp : taskimp;
@@ -1223,14 +1222,9 @@ static void task_numa_compare(struct task_numa_env *env,
 	 * In the overloaded case, try and keep the load balanced.
 	 */
 balance:
-	src_load = env->src_stats.load;
-	dst_load = env->dst_stats.load;
-
-	/* Calculate the effect of moving env->p from src to dst. */
-	load = env->p->se.load.weight;
-	tg = task_group(env->p);
-	src_load += effective_load(tg, env->src_cpu, -load, -load);
-	dst_load += effective_load(tg, env->dst_cpu, load, load);
+	load = task_h_load(env->p);
+	dst_load = env->dst_stats.load + load;
+	src_load = env->src_stats.load - load;
 
 	if (moveimp > imp && moveimp > env->best_imp) {
 		/*
@@ -1250,11 +1244,9 @@ balance:
 		goto unlock;
 
 	if (cur) {
-		/* Cur moves in the opposite direction. */
-		load = cur->se.load.weight;
-		tg = task_group(cur);
-		src_load += effective_load(tg, env->src_cpu, load, load);
-		dst_load += effective_load(tg, env->dst_cpu, -load, -load);
+		load = task_h_load(cur);
+		dst_load -= load;
+		src_load += load;
 	}
 
 	if (load_too_imbalanced(src_load, dst_load, env))
