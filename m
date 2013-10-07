Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3JGKlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:41:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab3JGKaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:30:04 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 23/63] sched: Resist moving tasks towards nodes with fewer hinting faults
Date: Mon,  7 Oct 2013 11:29:01 +0100
Message-Id: <1381141781-10992-24-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381141781-10992-1-git-send-email-mgorman@suse.de>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as "sched: Favour moving tasks towards the preferred node" favours
moving tasks towards nodes with a higher number of recorded NUMA hinting
faults, this patch resists moving tasks towards nodes with lower faults.

[mgorman@suse.de: changelog]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 kernel/sched/fair.c     | 33 +++++++++++++++++++++++++++++++++
 kernel/sched/features.h |  8 ++++++++
 2 files changed, 41 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8c2b779..21cad59 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4106,12 +4106,43 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 
 	return false;
 }
+
+
+static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
+{
+	int src_nid, dst_nid;
+
+	if (!sched_feat(NUMA) || !sched_feat(NUMA_RESIST_LOWER))
+		return false;
+
+	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
+		return false;
+
+	src_nid = cpu_to_node(env->src_cpu);
+	dst_nid = cpu_to_node(env->dst_cpu);
+
+	if (src_nid == dst_nid ||
+	    p->numa_migrate_seq >= sysctl_numa_balancing_settle_count)
+		return false;
+
+	if (p->numa_faults[dst_nid] < p->numa_faults[src_nid])
+		return true;
+
+	return false;
+}
+
 #else
 static inline bool migrate_improves_locality(struct task_struct *p,
 					     struct lb_env *env)
 {
 	return false;
 }
+
+static inline bool migrate_degrades_locality(struct task_struct *p,
+					     struct lb_env *env)
+{
+	return false;
+}
 #endif
 
 /*
@@ -4174,6 +4205,8 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 3) too many balance attempts have failed.
 	 */
 	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
+	if (!tsk_cache_hot)
+		tsk_cache_hot = migrate_degrades_locality(p, env);
 
 	if (migrate_improves_locality(p, env)) {
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index d9278ce..5716929 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -74,4 +74,12 @@ SCHED_FEAT(NUMA,	false)
  * balancing.
  */
 SCHED_FEAT(NUMA_FAVOUR_HIGHER, true)
+
+/*
+ * NUMA_RESIST_LOWER will resist moving tasks towards nodes where a
+ * lower number of hinting faults have been recorded. As this has
+ * the potential to prevent a task ever migrating to a new node
+ * due to CPU overload it is disabled by default.
+ */
+SCHED_FEAT(NUMA_RESIST_LOWER, false)
 #endif
-- 
1.8.4

