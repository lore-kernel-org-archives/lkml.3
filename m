Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbaBUNCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:02:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47675 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072AbaBUNCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Boonstoppel <pboonstoppel@nvidia.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 17/60] sched: Unthrottle rt runqueues in __disable_runtime()
Date: Fri, 21 Feb 2014 13:00:44 +0000
Message-Id: <1392987687-15367-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Boonstoppel <pboonstoppel@nvidia.com>

commit a4c96ae319b8047f62dedbe1eac79e321c185749 upstream.

migrate_tasks() uses _pick_next_task_rt() to get tasks from the
real-time runqueues to be migrated. When rt_rq is throttled
_pick_next_task_rt() won't return anything, in which case
migrate_tasks() can't move all threads over and gets stuck in an
infinite loop.

Instead unthrottle rt runqueues before migrating tasks.

Additionally: move unthrottle_offline_cfs_rqs() to rq_offline_fair()

Signed-off-by: Peter Boonstoppel <pboonstoppel@nvidia.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Link: http://lkml.kernel.org/r/5FBF8E85CA34454794F0F7ECBA79798F379D3648B7@HQMAIL04.nvidia.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/core.c  | 3 ---
 kernel/sched/fair.c  | 7 +++++--
 kernel/sched/rt.c    | 1 +
 kernel/sched/sched.h | 1 -
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 281f186..57d8625 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5357,9 +5357,6 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
-	/* Ensure any throttled groups are reachable by pick_next_task */
-	unthrottle_offline_cfs_rqs(rq);
-
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9e2fe1b..7963693 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2071,7 +2071,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
@@ -2125,7 +2125,7 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
 
@@ -4910,6 +4910,9 @@ static void rq_online_fair(struct rq *rq)
 static void rq_offline_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
 }
 
 #endif /* CONFIG_SMP */
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 06c3c6f..ad4787b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -691,6 +691,7 @@ balanced:
 		 * runtime - in which case borrowing doesn't make sense.
 		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
+		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
 	}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 65bd8a8..400391f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1140,7 +1140,6 @@ extern void print_rt_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
-extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void cfs_bandwidth_usage_inc(void);
 extern void cfs_bandwidth_usage_dec(void);
-- 
1.9.0

