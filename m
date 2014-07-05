Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763AbaGEKrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:47:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58102 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbaGEKrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:47:00 -0400
Date: Sat, 5 Jul 2014 03:45:57 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-0e59bdaea75f12a7d7c03672f4ac22c0119a1bc0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, ktkhai@parallels.com,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, pjt@google.com, umgwanakikbuti@gmail.com,
        khorenko@parallels.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        bsegall@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, peterz@infradead.org,
        khorenko@parallels.com, umgwanakikbuti@gmail.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <1403684382.3462.42.camel@tkhai>
References: <1403684382.3462.42.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Disable runtime_enabled on dying rq
Git-Commit-ID: 0e59bdaea75f12a7d7c03672f4ac22c0119a1bc0
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

Commit-ID:  0e59bdaea75f12a7d7c03672f4ac22c0119a1bc0
Gitweb:     http://git.kernel.org/tip/0e59bdaea75f12a7d7c03672f4ac22c0119a1bc0
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Wed, 25 Jun 2014 12:19:42 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:42 +0200

sched/fair: Disable runtime_enabled on dying rq

We kill rq->rd on the CPU_DOWN_PREPARE stage:

	cpuset_cpu_inactive -> cpuset_update_active_cpus -> partition_sched_domains ->
	-> cpu_attach_domain -> rq_attach_root -> set_rq_offline

This unthrottles all throttled cfs_rqs.

But the cpu is still able to call schedule() till

	take_cpu_down->__cpu_disable()

is called from stop_machine.

This case the tasks from just unthrottled cfs_rqs are pickable
in a standard scheduler way, and they are picked by dying cpu.
The cfs_rqs becomes throttled again, and migrate_tasks()
in migration_call skips their tasks (one more unthrottle
in migrate_tasks()->CPU_DYING does not happen, because rq->rd
is already NULL).

Patch sets runtime_enabled to zero. This guarantees, the runtime
is not accounted, and the cfs_rqs won't exceed given
cfs_rq->runtime_remaining = 1, and tasks will be pickable
in migrate_tasks(). runtime_enabled is recalculated again
when rq becomes online again.

Ben Segall also noticed, we always enable runtime in
tg_set_cfs_bandwidth(). Actually, we should do that for online
cpus only. To prevent races with unthrottle_offline_cfs_rqs()
we take get_online_cpus() lock.

Reviewed-by: Ben Segall <bsegall@google.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Konstantin Khorenko <khorenko@parallels.com>
CC: Paul Turner <pjt@google.com>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403684382.3462.42.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |  8 +++++++-
 kernel/sched/fair.c | 22 ++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e50234b..2dbc63d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7817,6 +7817,11 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	if (period > max_cfs_quota_period)
 		return -EINVAL;
 
+	/*
+	 * Prevent race between setting of cfs_rq->runtime_enabled and
+	 * unthrottle_offline_cfs_rqs().
+	 */
+	get_online_cpus();
 	mutex_lock(&cfs_constraints_mutex);
 	ret = __cfs_schedulable(tg, period, quota);
 	if (ret)
@@ -7842,7 +7847,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	}
 	raw_spin_unlock_irq(&cfs_b->lock);
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
 		struct rq *rq = cfs_rq->rq;
 
@@ -7858,6 +7863,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 		cfs_bandwidth_usage_dec();
 out_unlock:
 	mutex_unlock(&cfs_constraints_mutex);
+	put_online_cpus();
 
 	return ret;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a140c6a..923fe32 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3798,6 +3798,19 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
+static void __maybe_unused update_runtime_enabled(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct cfs_bandwidth *cfs_b = &cfs_rq->tg->cfs_bandwidth;
+
+		raw_spin_lock(&cfs_b->lock);
+		cfs_rq->runtime_enabled = cfs_b->quota != RUNTIME_INF;
+		raw_spin_unlock(&cfs_b->lock);
+	}
+}
+
 static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
@@ -3811,6 +3824,12 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 		 * there's some valid quota amount
 		 */
 		cfs_rq->runtime_remaining = 1;
+		/*
+		 * Offline rq is schedulable till cpu is completely disabled
+		 * in take_cpu_down(), so we prevent new cfs throttling here.
+		 */
+		cfs_rq->runtime_enabled = 0;
+
 		if (cfs_rq_throttled(cfs_rq))
 			unthrottle_cfs_rq(cfs_rq);
 	}
@@ -3854,6 +3873,7 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+static inline void update_runtime_enabled(struct rq *rq) {}
 static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
@@ -7362,6 +7382,8 @@ void trigger_load_balance(struct rq *rq)
 static void rq_online_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	update_runtime_enabled(rq);
 }
 
 static void rq_offline_fair(struct rq *rq)
