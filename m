Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3JIR3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:29:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3JIR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:29:33 -0400
Date: Wed, 9 Oct 2013 10:28:52 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-6fe6b2d6dabf392aceb3ad3a5e859b46a04465c6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-31-git-send-email-mgorman@suse.de>
References: <1381141781-10992-31-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Do not migrate memory immediately after switching node
Git-Commit-ID: 6fe6b2d6dabf392aceb3ad3a5e859b46a04465c6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:28:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6fe6b2d6dabf392aceb3ad3a5e859b46a04465c6
Gitweb:     http://git.kernel.org/tip/6fe6b2d6dabf392aceb3ad3a5e859b46a04465c6
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 7 Oct 2013 11:29:08 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:36 +0200

sched/numa: Do not migrate memory immediately after switching node

The load balancer can move tasks between nodes and does not take NUMA
locality into account. With automatic NUMA balancing this may result in the
tasks working set being migrated to the new node. However, as the fault
buffer will still store faults from the old node the schduler may decide to
reset the preferred node and migrate the task back resulting in more
migrations.

The ideal would be that the scheduler did not migrate tasks with a heavy
memory footprint but this may result nodes being overloaded. We could
also discard the fault information on task migration but this would still
cause all the tasks working set to be migrated. This patch simply avoids
migrating the memory for a short time after a task is migrated.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-31-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |  2 +-
 kernel/sched/fair.c | 18 ++++++++++++++++--
 mm/mempolicy.c      | 12 ++++++++++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 66b878e..9060a7f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1631,7 +1631,7 @@ static void __sched_fork(struct task_struct *p)
 
 	p->node_stamp = 0ULL;
 	p->numa_scan_seq = p->mm ? p->mm->numa_scan_seq : 0;
-	p->numa_migrate_seq = 0;
+	p->numa_migrate_seq = 1;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_preferred_nid = -1;
 	p->numa_work.next = &p->numa_work;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b1de7c5..61ec0d4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -884,7 +884,7 @@ static unsigned int task_scan_max(struct task_struct *p)
  * the preferred node but still allow the scheduler to move the task again if
  * the nodes CPUs are overloaded.
  */
-unsigned int sysctl_numa_balancing_settle_count __read_mostly = 3;
+unsigned int sysctl_numa_balancing_settle_count __read_mostly = 4;
 
 static inline int task_faults_idx(int nid, int priv)
 {
@@ -980,7 +980,7 @@ static void task_numa_placement(struct task_struct *p)
 
 		/* Update the preferred nid and migrate task if possible */
 		p->numa_preferred_nid = max_nid;
-		p->numa_migrate_seq = 0;
+		p->numa_migrate_seq = 1;
 		migrate_task_to(p, preferred_cpu);
 	}
 }
@@ -4121,6 +4121,20 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 	set_task_cpu(p, env->dst_cpu);
 	activate_task(env->dst_rq, p, 0);
 	check_preempt_curr(env->dst_rq, p, 0);
+#ifdef CONFIG_NUMA_BALANCING
+	if (p->numa_preferred_nid != -1) {
+		int src_nid = cpu_to_node(env->src_cpu);
+		int dst_nid = cpu_to_node(env->dst_cpu);
+
+		/*
+		 * If the load balancer has moved the task then limit
+		 * migrations from taking place in the short term in
+		 * case this is a short-lived migration.
+		 */
+		if (src_nid != dst_nid && dst_nid != p->numa_preferred_nid)
+			p->numa_migrate_seq = 0;
+	}
+#endif
 }
 
 /*
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index aff1f1e..196d8da 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2378,6 +2378,18 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 		last_nidpid = page_nidpid_xchg_last(page, this_nidpid);
 		if (!nidpid_pid_unset(last_nidpid) && nidpid_to_nid(last_nidpid) != polnid)
 			goto out;
+
+#ifdef CONFIG_NUMA_BALANCING
+		/*
+		 * If the scheduler has just moved us away from our
+		 * preferred node, do not bother migrating pages yet.
+		 * This way a short and temporary process migration will
+		 * not cause excessive memory migration.
+		 */
+		if (polnid != current->numa_preferred_nid &&
+				!current->numa_migrate_seq)
+			goto out;
+#endif
 	}
 
 	if (curnid != polnid)
