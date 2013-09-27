Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3I0NbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:31:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab3I0N2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:28:49 -0400
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 60/63] mm: numa: revert temporarily disabling of NUMA migration
Date: Fri, 27 Sep 2013 14:27:45 +0100
Message-Id: <1380288468-5551-61-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380288468-5551-1-git-send-email-mgorman@suse.de>
References: <1380288468-5551-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

With the scan rate code working (at least for multi-instance specjbb),
the large hammer that is "sched: Do not migrate memory immediately after
switching node" can be replaced with something smarter. Revert temporarily
migration disabling and all traces of numa_migrate_seq.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/sched.h |  1 -
 kernel/sched/core.c   |  2 --
 kernel/sched/fair.c   | 25 +------------------------
 mm/mempolicy.c        | 12 ------------
 4 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 918baf3..33c53d6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1331,7 +1331,6 @@ struct task_struct {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	int numa_scan_seq;
-	int numa_migrate_seq;
 	unsigned int numa_scan_period;
 	unsigned int numa_scan_period_max;
 	unsigned long numa_migrate_retry;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3d60433..b7cf574 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1738,7 +1738,6 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	p->node_stamp = 0ULL;
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
-	p->numa_migrate_seq = 1;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
 	p->numa_faults = NULL;
@@ -4505,7 +4504,6 @@ void sched_setnuma(struct task_struct *p, int nid)
 		p->sched_class->put_prev_task(rq, p);
 
 	p->numa_preferred_nid = nid;
-	p->numa_migrate_seq = 1;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c362f9..9bca073 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1261,16 +1261,8 @@ static void numa_migrate_preferred(struct task_struct *p)
 {
 	/* Success if task is already running on preferred CPU */
 	p->numa_migrate_retry = 0;
-	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid) {
-		/*
-		 * If migration is temporarily disabled due to a task migration
-		 * then re-enable it now as the task is running on its
-		 * preferred node and memory should migrate locally
-		 */
-		if (!p->numa_migrate_seq)
-			p->numa_migrate_seq++;
+	if (cpu_to_node(task_cpu(p)) == p->numa_preferred_nid)
 		return;
-	}
 
 	/* This task has no NUMA fault statistics yet */
 	if (unlikely(p->numa_preferred_nid == -1))
@@ -1367,7 +1359,6 @@ static void task_numa_placement(struct task_struct *p)
 	if (p->numa_scan_seq == seq)
 		return;
 	p->numa_scan_seq = seq;
-	p->numa_migrate_seq++;
 	p->numa_scan_period_max = task_scan_max(p);
 
 	/* If the task is part of a group prevent parallel updates to group stats */
@@ -4683,20 +4674,6 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 	set_task_cpu(p, env->dst_cpu);
 	activate_task(env->dst_rq, p, 0);
 	check_preempt_curr(env->dst_rq, p, 0);
-#ifdef CONFIG_NUMA_BALANCING
-	if (p->numa_preferred_nid != -1) {
-		int src_nid = cpu_to_node(env->src_cpu);
-		int dst_nid = cpu_to_node(env->dst_cpu);
-
-		/*
-		 * If the load balancer has moved the task then limit
-		 * migrations from taking place in the short term in
-		 * case this is a short-lived migration.
-		 */
-		if (src_nid != dst_nid && dst_nid != p->numa_preferred_nid)
-			p->numa_migrate_seq = 0;
-	}
-#endif
 }
 
 /*
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 07db309..e554587 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2348,18 +2348,6 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 		last_cpupid = page_cpupid_xchg_last(page, this_cpupid);
 		if (!cpupid_pid_unset(last_cpupid) && cpupid_to_nid(last_cpupid) != thisnid)
 			goto out;
-
-#ifdef CONFIG_NUMA_BALANCING
-		/*
-		 * If the scheduler has just moved us away from our
-		 * preferred node, do not bother migrating pages yet.
-		 * This way a short and temporary process migration will
-		 * not cause excessive memory migration.
-		 */
-		if (thisnid != current->numa_preferred_nid &&
-				!current->numa_migrate_seq)
-			goto out;
-#endif
 	}
 
 	if (curnid != polnid)
-- 
1.8.1.4

