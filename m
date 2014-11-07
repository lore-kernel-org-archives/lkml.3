Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaKGLHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:07:47 -0500
Received: from relay.parallels.com ([195.214.232.42]:40126 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaKGLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:07:43 -0500
Message-ID: <1415358456.28592.17.camel@tkhai>
Subject: [PATCH] sched/fair: Kill task_struct::numa_entry and
 numa_group::task_list
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Date: Fri, 7 Nov 2014 14:07:36 +0300
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nobody iterates over numa_group::task_list, this just confuses a reader.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/core.c |    1 -
 kernel/sched/fair.c |    5 -----
 2 files changed, 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2e7578a..7662d59 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1861,7 +1861,6 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->last_task_numa_placement = 0;
 	p->last_sum_exec_runtime = 0;
 
-	INIT_LIST_HEAD(&p->numa_entry);
 	p->numa_group = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 826fdf3..fc91348 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -868,7 +868,6 @@ struct numa_group {
 	spinlock_t lock; /* nr_tasks, tasks */
 	int nr_tasks;
 	pid_t gid;
-	struct list_head task_list;
 
 	struct rcu_head rcu;
 	nodemask_t active_nodes;
@@ -1894,7 +1893,6 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 		atomic_set(&grp->refcount, 1);
 		spin_lock_init(&grp->lock);
-		INIT_LIST_HEAD(&grp->task_list);
 		grp->gid = p->pid;
 		/* Second half of the array tracks nids where faults happen */
 		grp->faults_cpu = grp->faults + NR_NUMA_HINT_FAULT_TYPES *
@@ -1907,7 +1905,6 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 		grp->total_faults = p->total_numa_faults;
 
-		list_add(&p->numa_entry, &grp->task_list);
 		grp->nr_tasks++;
 		rcu_assign_pointer(p->numa_group, grp);
 	}
@@ -1968,7 +1965,6 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	my_grp->total_faults -= p->total_numa_faults;
 	grp->total_faults += p->total_numa_faults;
 
-	list_move(&p->numa_entry, &grp->task_list);
 	my_grp->nr_tasks--;
 	grp->nr_tasks++;
 
@@ -1998,7 +1994,6 @@ void task_numa_free(struct task_struct *p)
 			grp->faults[i] -= p->numa_faults[i];
 		grp->total_faults -= p->total_numa_faults;
 
-		list_del(&p->numa_entry);
 		grp->nr_tasks--;
 		spin_unlock_irqrestore(&grp->lock, flags);
 		RCU_INIT_POINTER(p->numa_group, NULL);



