Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaFSMh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:37:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaFSMh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:37:26 -0400
Date: Thu, 19 Jun 2014 05:36:22 -0700
From: tip-bot for Hillf Danton <tipbot@zytor.com>
Message-ID: <tip-5d5e2b1bcbdc996e72815c03fdc5ea82c4642397@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mgalbraith@suse.de, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        dhillf@gmail.com, tglx@linutronix.de, hillf.zj@alibaba-inc.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, dhillf@gmail.com, tglx@linutronix.de,
        hillf.zj@alibaba-inc.com
In-Reply-To: <20140607090452.4696E301D2@webmail.sinamail.sina.com.cn>
References: <20140607090452.4696E301D2@webmail.sinamail.sina.com.cn>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix CACHE_HOT_BUDY condition
Git-Commit-ID: 5d5e2b1bcbdc996e72815c03fdc5ea82c4642397
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

Commit-ID:  5d5e2b1bcbdc996e72815c03fdc5ea82c4642397
Gitweb:     http://git.kernel.org/tip/5d5e2b1bcbdc996e72815c03fdc5ea82c4642397
Author:     Hillf Danton <dhillf@gmail.com>
AuthorDate: Tue, 10 Jun 2014 10:58:43 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:29:59 +0200

sched: Fix CACHE_HOT_BUDY condition

When computing cache hot, we should check if the migration dst cpu is idle,
instead of the current cpu. Though they are same in normal balancing, that
is false nowadays in nohz idle balancing at least.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Galbraith <mgalbraith@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140607090452.4696E301D2@webmail.sinamail.sina.com.cn
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3fa3e18..1f9c457 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5095,8 +5095,7 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 /*
  * Is this task likely cache-hot:
  */
-static int
-task_hot(struct task_struct *p, u64 now)
+static int task_hot(struct task_struct *p, struct lb_env *env)
 {
 	s64 delta;
 
@@ -5109,7 +5108,7 @@ task_hot(struct task_struct *p, u64 now)
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
+	if (sched_feat(CACHE_HOT_BUDDY) && env->dst_rq->nr_running &&
 			(&p->se == cfs_rq_of(&p->se)->next ||
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
@@ -5119,7 +5118,7 @@ task_hot(struct task_struct *p, u64 now)
 	if (sysctl_sched_migration_cost == 0)
 		return 0;
 
-	delta = now - p->se.exec_start;
+	delta = rq_clock_task(env->src_rq) - p->se.exec_start;
 
 	return delta < (s64)sysctl_sched_migration_cost;
 }
@@ -5273,7 +5272,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) task is cache cold, or
 	 * 3) too many balance attempts have failed.
 	 */
-	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq));
+	tsk_cache_hot = task_hot(p, env);
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
