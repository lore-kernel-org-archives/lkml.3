Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3G3Ht5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:49:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40729 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3G3Hty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:49:54 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [RFC PATCH 08/10] sched: Prevent a task from migrating immediately after an active balance
Date: Tue, 30 Jul 2013 13:18:23 +0530
Message-Id: <1375170505-5967-9-git-send-email-srikar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073007-5518-0000-0000-000010B92492
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once a task has been carefully chosen to be migrated to a destination
node from a source node, try to avoid some other cpus moving this task
away from the destinagtion node.

If not, tasks might end up being in a ping-pong; one cpu pulling it
because of numa affinity, the other cpu pulling it for the slight
imbalance created because of previous migration (instead of actually
trying to pull a task that might lead to more consolidation)

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    1 +
 kernel/sched/fair.c   |    9 +++++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a77c3cd..ba188f1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1506,6 +1506,7 @@ struct task_struct {
 	unsigned int numa_scan_period;
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
+	int migrate_seq;
 #endif /* CONFIG_NUMA_BALANCING */
 
 	struct rcu_head rcu;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e792312..453d989 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1594,6 +1594,7 @@ static void __sched_fork(struct task_struct *p)
 	p->numa_migrate_seq = p->mm ? p->mm->numa_scan_seq - 1 : 0;
 	p->numa_scan_period = sysctl_numa_balancing_scan_delay;
 	p->numa_work.next = &p->numa_work;
+	p->migrate_seq = 0;
 #endif /* CONFIG_NUMA_BALANCING */
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e04703e..a99aebc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1014,6 +1014,7 @@ static void account_numa_dequeue(struct cfs_rq *cfs_rq, struct task_struct *p)
 	struct rq *rq = rq_of(cfs_rq);
 	int curnode = cpu_to_node(cpu_of(rq));
 
+	p->migrate_seq = 0;
 	if (mm && mm->numa_weights) {
 		atomic_dec(&mm->numa_weights[curnode]);
 		atomic_dec(&mm->numa_weights[nr_node_ids]);
@@ -4037,6 +4038,13 @@ static bool preferred_node(struct task_struct *p, struct lb_env *env)
 	if (!(env->sd->flags & SD_NUMA))
 		return false;
 
+	if (env->iterations) {
+		if (!p->migrate_seq)
+			return true;
+
+		p->migrate_seq--;
+		return false;
+	}
 	return (can_numa_migrate_task(p, env->dst_rq, env->src_rq) == 1);
 }
 #else
@@ -4063,6 +4071,7 @@ static int move_one_task(struct lb_env *env)
 		if (p->on_rq && task_cpu(p) == env->src_rq->cpu) {
 			move_task(p, env);
 			schedstat_inc(env->sd, lb_gained[env->idle]);
+			p->migrate_seq = 3;
 			return 1;
 		}
 		return 0;
-- 
1.7.1

