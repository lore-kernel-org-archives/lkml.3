Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaBKTK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:10:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbaBKTIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Boonstoppel <pboonstoppel@nvidia.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.4 26/30] sched: Unthrottle rt runqueues in __disable_runtime()
Date: Tue, 11 Feb 2014 11:06:26 -0800
Message-Id: <20140211184647.891254567@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[ lizf: backported to 3.4: adjust context ]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c  |    3 ---
 kernel/sched/fair.c  |    7 +++++--
 kernel/sched/rt.c    |    1 +
 kernel/sched/sched.h |    1 -
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5301,9 +5301,6 @@ static void migrate_tasks(unsigned int d
 	 */
 	rq->stop = NULL;
 
-	/* Ensure any throttled groups are reachable by pick_next_task */
-	unthrottle_offline_cfs_rqs(rq);
-
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2071,7 +2071,7 @@ static void destroy_cfs_bandwidth(struct
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
@@ -2125,7 +2125,7 @@ static inline struct cfs_bandwidth *tg_c
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
-void unthrottle_offline_cfs_rqs(struct rq *rq) {}
+static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
 
@@ -5171,6 +5171,9 @@ static void rq_online_fair(struct rq *rq
 static void rq_offline_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	/* Ensure any throttled groups are reachable by pick_next_task */
+	unthrottle_offline_cfs_rqs(rq);
 }
 
 #endif /* CONFIG_SMP */
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -685,6 +685,7 @@ balanced:
 		 * runtime - in which case borrowing doesn't make sense.
 		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
+		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
 	}
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1138,7 +1138,6 @@ extern void print_rt_stats(struct seq_fi
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
-extern void unthrottle_offline_cfs_rqs(struct rq *rq);
 
 extern void cfs_bandwidth_usage_inc(void);
 extern void cfs_bandwidth_usage_dec(void);


