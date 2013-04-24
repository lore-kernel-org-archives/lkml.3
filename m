Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab3DXJgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:36:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39309 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab3DXJgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:36:35 -0400
Date: Wed, 24 Apr 2013 02:36:14 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-d31980846f9688db3ee3e5863525c6ff8ace4c7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, davidlohr.bueso@hp.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jason.low2@hp.com,
        iamjoonsoo.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1366705662-3587-5-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-5-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Move up affinity check to mitigate useless redoing overhead
Git-Commit-ID: d31980846f9688db3ee3e5863525c6ff8ace4c7c
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

Commit-ID:  d31980846f9688db3ee3e5863525c6ff8ace4c7c
Gitweb:     http://git.kernel.org/tip/d31980846f9688db3ee3e5863525c6ff8ace4c7c
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 23 Apr 2013 17:27:40 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Apr 2013 08:52:44 +0200

sched: Move up affinity check to mitigate useless redoing overhead

Currently, LBF_ALL_PINNED is cleared after affinity check is
passed. So, if task migration is skipped by small load value or
small imbalance value in move_tasks(), we don't clear
LBF_ALL_PINNED. At last, we trigger 'redo' in load_balance().

Imbalance value is often so small that any tasks cannot be moved
to other cpus and, of course, this situation may be continued
after we change the target cpu. So this patch move up affinity
check code and clear LBF_ALL_PINNED before evaluating load value
in order to mitigate useless redoing overhead.

In addition, re-order some comments correctly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jason Low <jason.low2@hp.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366705662-3587-5-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dfa92b7..b8ef321 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3896,10 +3896,14 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	int tsk_cache_hot = 0;
 	/*
 	 * We do not migrate tasks that are:
-	 * 1) running (obviously), or
+	 * 1) throttled_lb_pair, or
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
-	 * 3) are cache-hot on their current CPU.
+	 * 3) running (obviously), or
+	 * 4) are cache-hot on their current CPU.
 	 */
+	if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
+		return 0;
+
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
 		int new_dst_cpu;
 
@@ -3967,9 +3971,6 @@ static int move_one_task(struct lb_env *env)
 	struct task_struct *p, *n;
 
 	list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
-		if (throttled_lb_pair(task_group(p), env->src_rq->cpu, env->dst_cpu))
-			continue;
-
 		if (!can_migrate_task(p, env))
 			continue;
 
@@ -4021,7 +4022,7 @@ static int move_tasks(struct lb_env *env)
 			break;
 		}
 
-		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
+		if (!can_migrate_task(p, env))
 			goto next;
 
 		load = task_h_load(p);
@@ -4032,9 +4033,6 @@ static int move_tasks(struct lb_env *env)
 		if ((load / 2) > env->imbalance)
 			goto next;
 
-		if (!can_migrate_task(p, env))
-			goto next;
-
 		move_task(p, env);
 		pulled++;
 		env->imbalance -= load;
