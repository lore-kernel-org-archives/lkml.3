Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab3JIReg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:34:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56595 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3JIRe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:34:29 -0400
Date: Wed, 9 Oct 2013 10:33:51 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-1e3646ffc64b232cb14a5ef01d7b98997c1b73f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-61-git-send-email-mgorman@suse.de>
References: <1381141781-10992-61-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: numa:
  Revert temporarily disabling of NUMA migration
Git-Commit-ID: 1e3646ffc64b232cb14a5ef01d7b98997c1b73f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:33:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e3646ffc64b232cb14a5ef01d7b98997c1b73f9
Gitweb:     http://git.kernel.org/tip/1e3646ffc64b232cb14a5ef01d7b98997c1b73f9
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:48:20 +0200

mm: numa: Revert temporarily disabling of NUMA migration

With the scan rate code working (at least for multi-instance specjbb),
the large hammer that is "sched: Do not migrate memory immediately after
switching node" can be replaced with something smarter. Revert temporarily
migration disabling and all traces of numa_migrate_seq.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-61-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h |  1 -
 kernel/sched/core.c   |  2 --
 kernel/sched/fair.c   | 25 +------------------------
 mm/mempolicy.c        | 12 ------------
 4 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2292f6c..d24f70f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1340,7 +1340,6 @@ struct task_struct {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	int numa_scan_seq;
-	int numa_migrate_seq;
 	unsigned int numa_scan_period;
 	unsigned int numa_scan_period_max;
 	unsigned long numa_migrate_retry;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 89c5ae8..0c3feeb 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1731,7 +1731,6 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	p->node_stamp = 0ULL;
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
-	p->numa_migrate_seq = 1;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
 	p->numa_faults = NULL;
@@ -4488,7 +4487,6 @@ void sched_setnuma(struct task_struct *p, int nid)
 		p->sched_class->put_prev_task(rq, p);
 
 	p->numa_preferred_nid = nid;
-	p->numa_migrate_seq = 1;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index da6fa22..8454c38 100644
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
@@ -4730,20 +4721,6 @@ static void move_task(struct task_struct *p, struct lb_env *env)
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
index a5867ef..2929c24 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2404,18 +2404,6 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
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
