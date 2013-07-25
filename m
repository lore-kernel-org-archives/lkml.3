Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3GYKk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:40:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34806 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab3GYKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:40:24 -0400
Date: Thu, 25 Jul 2013 12:40:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched, numa: migrates_degrades_locality()
Message-ID: <20130725104009.GO27075@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-8-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373901620-2021-8-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: sched, numa: migrates_degrades_locality()
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Jul 22 14:02:54 CEST 2013

It just makes heaps of sense; so add it and make both it and
migrate_improve_locality() a sched_feat().

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-fwfjk3f8a29o3zx03h1ejb0y@git.kernel.org
---
 kernel/sched/fair.c     |   35 +++++++++++++++++++++++++++++++++--
 kernel/sched/features.h |    2 ++
 2 files changed, 35 insertions(+), 2 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4323,7 +4323,7 @@ static bool migrate_improves_locality(st
 {
 	int src_nid, dst_nid;
 
-	if (!sched_feat(NUMA_BALANCE))
+	if (!sched_feat(NUMA_BALANCE) || !sched_feat(NUMA_FAULTS_UP))
 		return false;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -4336,7 +4336,30 @@ static bool migrate_improves_locality(st
 	    p->numa_migrate_seq >= sysctl_numa_balancing_settle_count)
 		return false;
 
-	if (p->numa_preferred_nid == dst_nid)
+	if (task_faults(p, dst_nid) > task_faults(p, src_nid))
+		return true;
+
+	return false;
+}
+
+static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
+{
+	int src_nid, dst_nid;
+
+	if (!sched_feat(NUMA_BALANCE) || !sched_feat(NUMA_FAULTS_DOWN))
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
+	if (task_faults(p, dst_nid) < task_faults(p, src_nid))
 		return true;
 
 	return false;
@@ -4347,6 +4370,12 @@ static inline bool migrate_improves_loca
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
@@ -4409,6 +4438,8 @@ int can_migrate_task(struct task_struct
 	 * 3) too many balance attempts have failed.
 	 */
 	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq), env->sd);
+	if (!tsk_cache_hot)
+		tsk_cache_hot = migrate_degrades_locality(p, env);
 
 	if (migrate_improves_locality(p, env)) {
 #ifdef CONFIG_SCHEDSTATS
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -70,4 +70,6 @@ SCHED_FEAT(LB_MIN, false)
 SCHED_FEAT(NUMA,	false)
 SCHED_FEAT(NUMA_FORCE,	false)
 SCHED_FEAT(NUMA_BALANCE, true)
+SCHED_FEAT(NUMA_FAULTS_UP, true)
+SCHED_FEAT(NUMA_FAULTS_DOWN, false)
 #endif
