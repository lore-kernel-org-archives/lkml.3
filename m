Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3JIR2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:28:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56122 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3JIR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:28:20 -0400
Date: Wed, 9 Oct 2013 10:27:42 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-7a0f308337d11fd5caa9f845c6d08cc5d6067988@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-24-git-send-email-mgorman@suse.de>
References: <1381141781-10992-24-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Resist moving tasks towards nodes with fewer hinting faults
Git-Commit-ID: 7a0f308337d11fd5caa9f845c6d08cc5d6067988
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:27:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a0f308337d11fd5caa9f845c6d08cc5d6067988
Gitweb:     http://git.kernel.org/tip/7a0f308337d11fd5caa9f845c6d08cc5d6067988
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:01 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:27 +0200

sched/numa: Resist moving tasks towards nodes with fewer hinting faults

Just as "sched: Favour moving tasks towards the preferred node" favours
moving tasks towards nodes with a higher number of recorded NUMA hinting
faults, this patch resists moving tasks towards nodes with lower faults.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-24-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c     | 33 +++++++++++++++++++++++++++++++++
 kernel/sched/features.h |  8 ++++++++
 2 files changed, 41 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6ffddca..8943124 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4107,12 +4107,43 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 
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
@@ -4177,6 +4208,8 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
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
