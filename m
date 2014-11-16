Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaKPMcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:32:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35494 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKPMcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:32:03 -0500
Date: Sun, 16 Nov 2014 04:31:27 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-753899183c53aa609375b214ea8e040da89119c3@git.kernel.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        ktkhai@parallels.com, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org
Reply-To: hpa@zytor.com, ktkhai@parallels.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de
In-Reply-To: <1415358456.28592.17.camel@tkhai>
References: <1415358456.28592.17.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Kill task_struct::
 numa_entry and numa_group::task_list
Git-Commit-ID: 753899183c53aa609375b214ea8e040da89119c3
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

Commit-ID:  753899183c53aa609375b214ea8e040da89119c3
Gitweb:     http://git.kernel.org/tip/753899183c53aa609375b214ea8e040da89119c3
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Fri, 7 Nov 2014 14:07:36 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:58:48 +0100

sched/fair: Kill task_struct::numa_entry and numa_group::task_list

Nobody iterates over numa_group::task_list, this just confuses the readers.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415358456.28592.17.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 1 -
 kernel/sched/fair.c | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 960f704..3ccdce1 100644
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
index cf80643..d11c57d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -873,7 +873,6 @@ struct numa_group {
 	spinlock_t lock; /* nr_tasks, tasks */
 	int nr_tasks;
 	pid_t gid;
-	struct list_head task_list;
 
 	struct rcu_head rcu;
 	nodemask_t active_nodes;
@@ -1906,7 +1905,6 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 		atomic_set(&grp->refcount, 1);
 		spin_lock_init(&grp->lock);
-		INIT_LIST_HEAD(&grp->task_list);
 		grp->gid = p->pid;
 		/* Second half of the array tracks nids where faults happen */
 		grp->faults_cpu = grp->faults + NR_NUMA_HINT_FAULT_TYPES *
@@ -1919,7 +1917,6 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 
 		grp->total_faults = p->total_numa_faults;
 
-		list_add(&p->numa_entry, &grp->task_list);
 		grp->nr_tasks++;
 		rcu_assign_pointer(p->numa_group, grp);
 	}
@@ -1980,7 +1977,6 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	my_grp->total_faults -= p->total_numa_faults;
 	grp->total_faults += p->total_numa_faults;
 
-	list_move(&p->numa_entry, &grp->task_list);
 	my_grp->nr_tasks--;
 	grp->nr_tasks++;
 
@@ -2010,7 +2006,6 @@ void task_numa_free(struct task_struct *p)
 			grp->faults[i] -= p->numa_faults[i];
 		grp->total_faults -= p->total_numa_faults;
 
-		list_del(&p->numa_entry);
 		grp->nr_tasks--;
 		spin_unlock_irqrestore(&grp->lock, flags);
 		RCU_INIT_POINTER(p->numa_group, NULL);
