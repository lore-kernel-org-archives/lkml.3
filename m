Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbaFQNYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:24:18 -0400
Received: from relay.parallels.com ([195.214.232.42]:34366 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbaFQNYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:24:15 -0400
Message-ID: <1403011450.27674.44.camel@tkhai>
Subject: [PATCH 1/3] sched/fair: Disable runtime_enabled on dying rq
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Mike Galbraith" <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>
Date: Tue, 17 Jun 2014 17:24:10 +0400
In-Reply-To: <20140617130442.29933.54945.stgit@tkhai>
References: <20140617130442.29933.54945.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..f120525 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3775,6 +3775,19 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
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
@@ -3790,6 +3803,12 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 		cfs_rq->runtime_remaining = 1;
 		if (cfs_rq_throttled(cfs_rq))
 			unthrottle_cfs_rq(cfs_rq);
+
+		/*
+		 * Offline rq is schedulable till cpu is completely disabled
+		 * in take_cpu_down(), so we prevent new cfs throttling here.
+		 */
+		cfs_rq->runtime_enabled = 0;
 	}
 }
 
@@ -3831,6 +3850,7 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+static inline void update_runtime_enabled(struct rq *rq) {}
 static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
@@ -7325,6 +7345,8 @@ void trigger_load_balance(struct rq *rq)
 static void rq_online_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	update_runtime_enabled(rq);
 }
 
 static void rq_offline_fair(struct rq *rq)



