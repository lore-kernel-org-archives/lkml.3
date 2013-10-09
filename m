Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3JIRbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:31:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab3JIRbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:31:46 -0400
Date: Wed, 9 Oct 2013 10:31:03 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8c8a743c5087bac9caac8155b8f3b367e75cdd0b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        srikar@linux.vnet.ibm.com, aarcange@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-44-git-send-email-mgorman@suse.de>
References: <1381141781-10992-44-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Use {cpu,
  pid} to create task groups for shared faults
Git-Commit-ID: 8c8a743c5087bac9caac8155b8f3b367e75cdd0b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:31:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c8a743c5087bac9caac8155b8f3b367e75cdd0b
Gitweb:     http://git.kernel.org/tip/8c8a743c5087bac9caac8155b8f3b367e75cdd0b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 7 Oct 2013 11:29:21 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 14:47:47 +0200

sched/numa: Use {cpu, pid} to create task groups for shared faults

While parallel applications tend to align their data on the cache
boundary, they tend not to align on the page or THP boundary.
Consequently tasks that partition their data can still "false-share"
pages presenting a problem for optimal NUMA placement.

This patch uses NUMA hinting faults to chain tasks together into
numa_groups. As well as storing the NID a task was running on when
accessing a page a truncated representation of the faulting PID is
stored. If subsequent faults are from different PIDs it is reasonable
to assume that those two tasks share a page and are candidates for
being grouped together. Note that this patch makes no scheduling
decisions based on the grouping information.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1381141781-10992-44-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/mm.h    |  11 ++++
 include/linux/sched.h |   3 +
 kernel/sched/core.c   |   3 +
 kernel/sched/fair.c   | 165 +++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched/sched.h  |   5 +-
 mm/memory.c           |   8 +++
 6 files changed, 182 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ce464cd..81443d5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -691,6 +691,12 @@ static inline bool cpupid_cpu_unset(int cpupid)
 	return cpupid_to_cpu(cpupid) == (-1 & LAST__CPU_MASK);
 }
 
+static inline bool __cpupid_match_pid(pid_t task_pid, int cpupid)
+{
+	return (task_pid & LAST__PID_MASK) == cpupid_to_pid(cpupid);
+}
+
+#define cpupid_match_pid(task, cpupid) __cpupid_match_pid(task->pid, cpupid)
 #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
 static inline int page_cpupid_xchg_last(struct page *page, int cpupid)
 {
@@ -760,6 +766,11 @@ static inline bool cpupid_pid_unset(int cpupid)
 static inline void page_cpupid_reset_last(struct page *page)
 {
 }
+
+static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
+{
+	return false;
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 static inline struct zone *page_zone(const struct page *page)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b661979..f587ded 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1347,6 +1347,9 @@ struct task_struct {
 	u64 node_stamp;			/* migration stamp  */
 	struct callback_head numa_work;
 
+	struct list_head numa_entry;
+	struct numa_group *numa_group;
+
 	/*
 	 * Exponential decaying average of faults on a per-node basis.
 	 * Scheduling placement decisions are made based on the these counts.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1fe59da..51092d5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1733,6 +1733,9 @@ static void __sched_fork(struct task_struct *p)
 	p->numa_work.next = &p->numa_work;
 	p->numa_faults = NULL;
 	p->numa_faults_buffer = NULL;
+
+	INIT_LIST_HEAD(&p->numa_entry);
+	p->numa_group = NULL;
 #endif /* CONFIG_NUMA_BALANCING */
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dbe0f62..8556505 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -888,6 +888,17 @@ static unsigned int task_scan_max(struct task_struct *p)
  */
 unsigned int sysctl_numa_balancing_settle_count __read_mostly = 4;
 
+struct numa_group {
+	atomic_t refcount;
+
+	spinlock_t lock; /* nr_tasks, tasks */
+	int nr_tasks;
+	struct list_head task_list;
+
+	struct rcu_head rcu;
+	atomic_long_t faults[0];
+};
+
 static inline int task_faults_idx(int nid, int priv)
 {
 	return 2 * nid + priv;
@@ -1182,7 +1193,10 @@ static void task_numa_placement(struct task_struct *p)
 		int priv, i;
 
 		for (priv = 0; priv < 2; priv++) {
+			long diff;
+
 			i = task_faults_idx(nid, priv);
+			diff = -p->numa_faults[i];
 
 			/* Decay existing window, copy faults since last scan */
 			p->numa_faults[i] >>= 1;
@@ -1190,6 +1204,11 @@ static void task_numa_placement(struct task_struct *p)
 			p->numa_faults_buffer[i] = 0;
 
 			faults += p->numa_faults[i];
+			diff += p->numa_faults[i];
+			if (p->numa_group) {
+				/* safe because we can only change our own group */
+				atomic_long_add(diff, &p->numa_group->faults[i]);
+			}
 		}
 
 		if (faults > max_faults) {
@@ -1207,6 +1226,131 @@ static void task_numa_placement(struct task_struct *p)
 	}
 }
 
+static inline int get_numa_group(struct numa_group *grp)
+{
+	return atomic_inc_not_zero(&grp->refcount);
+}
+
+static inline void put_numa_group(struct numa_group *grp)
+{
+	if (atomic_dec_and_test(&grp->refcount))
+		kfree_rcu(grp, rcu);
+}
+
+static void double_lock(spinlock_t *l1, spinlock_t *l2)
+{
+	if (l1 > l2)
+		swap(l1, l2);
+
+	spin_lock(l1);
+	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
+}
+
+static void task_numa_group(struct task_struct *p, int cpupid)
+{
+	struct numa_group *grp, *my_grp;
+	struct task_struct *tsk;
+	bool join = false;
+	int cpu = cpupid_to_cpu(cpupid);
+	int i;
+
+	if (unlikely(!p->numa_group)) {
+		unsigned int size = sizeof(struct numa_group) +
+				    2*nr_node_ids*sizeof(atomic_long_t);
+
+		grp = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		if (!grp)
+			return;
+
+		atomic_set(&grp->refcount, 1);
+		spin_lock_init(&grp->lock);
+		INIT_LIST_HEAD(&grp->task_list);
+
+		for (i = 0; i < 2*nr_node_ids; i++)
+			atomic_long_set(&grp->faults[i], p->numa_faults[i]);
+
+		list_add(&p->numa_entry, &grp->task_list);
+		grp->nr_tasks++;
+		rcu_assign_pointer(p->numa_group, grp);
+	}
+
+	rcu_read_lock();
+	tsk = ACCESS_ONCE(cpu_rq(cpu)->curr);
+
+	if (!cpupid_match_pid(tsk, cpupid))
+		goto unlock;
+
+	grp = rcu_dereference(tsk->numa_group);
+	if (!grp)
+		goto unlock;
+
+	my_grp = p->numa_group;
+	if (grp == my_grp)
+		goto unlock;
+
+	/*
+	 * Only join the other group if its bigger; if we're the bigger group,
+	 * the other task will join us.
+	 */
+	if (my_grp->nr_tasks > grp->nr_tasks)
+		goto unlock;
+
+	/*
+	 * Tie-break on the grp address.
+	 */
+	if (my_grp->nr_tasks == grp->nr_tasks && my_grp > grp)
+		goto unlock;
+
+	if (!get_numa_group(grp))
+		goto unlock;
+
+	join = true;
+
+unlock:
+	rcu_read_unlock();
+
+	if (!join)
+		return;
+
+	for (i = 0; i < 2*nr_node_ids; i++) {
+		atomic_long_sub(p->numa_faults[i], &my_grp->faults[i]);
+		atomic_long_add(p->numa_faults[i], &grp->faults[i]);
+	}
+
+	double_lock(&my_grp->lock, &grp->lock);
+
+	list_move(&p->numa_entry, &grp->task_list);
+	my_grp->nr_tasks--;
+	grp->nr_tasks++;
+
+	spin_unlock(&my_grp->lock);
+	spin_unlock(&grp->lock);
+
+	rcu_assign_pointer(p->numa_group, grp);
+
+	put_numa_group(my_grp);
+}
+
+void task_numa_free(struct task_struct *p)
+{
+	struct numa_group *grp = p->numa_group;
+	int i;
+
+	if (grp) {
+		for (i = 0; i < 2*nr_node_ids; i++)
+			atomic_long_sub(p->numa_faults[i], &grp->faults[i]);
+
+		spin_lock(&grp->lock);
+		list_del(&p->numa_entry);
+		grp->nr_tasks--;
+		spin_unlock(&grp->lock);
+		rcu_assign_pointer(p->numa_group, NULL);
+		put_numa_group(grp);
+	}
+
+	kfree(p->numa_faults);
+}
+
 /*
  * Got a PROT_NONE fault for a page on @node.
  */
@@ -1222,15 +1366,6 @@ void task_numa_fault(int last_cpupid, int node, int pages, bool migrated)
 	if (!p->mm)
 		return;
 
-	/*
-	 * First accesses are treated as private, otherwise consider accesses
-	 * to be private if the accessing pid has not changed
-	 */
-	if (!cpupid_pid_unset(last_cpupid))
-		priv = ((p->pid & LAST__PID_MASK) == cpupid_to_pid(last_cpupid));
-	else
-		priv = 1;
-
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults)) {
 		int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
@@ -1245,6 +1380,18 @@ void task_numa_fault(int last_cpupid, int node, int pages, bool migrated)
 	}
 
 	/*
+	 * First accesses are treated as private, otherwise consider accesses
+	 * to be private if the accessing pid has not changed
+	 */
+	if (unlikely(last_cpupid == (-1 & LAST_CPUPID_MASK))) {
+		priv = 1;
+	} else {
+		priv = cpupid_match_pid(p, last_cpupid);
+		if (!priv)
+			task_numa_group(p, last_cpupid);
+	}
+
+	/*
 	 * If pages are properly placed (did not migrate) then scan slower.
 	 * This is reset periodically in case of phase changes
 	 */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 691e969..8037b10 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -559,10 +559,7 @@ static inline u64 rq_clock_task(struct rq *rq)
 #ifdef CONFIG_NUMA_BALANCING
 extern int migrate_task_to(struct task_struct *p, int cpu);
 extern int migrate_swap(struct task_struct *, struct task_struct *);
-static inline void task_numa_free(struct task_struct *p)
-{
-	kfree(p->numa_faults);
-}
+extern void task_numa_free(struct task_struct *p);
 #else /* CONFIG_NUMA_BALANCING */
 static inline void task_numa_free(struct task_struct *p)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 5162e6d..c57efa2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2719,6 +2719,14 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		get_page(dirty_page);
 
 reuse:
+		/*
+		 * Clear the pages cpupid information as the existing
+		 * information potentially belongs to a now completely
+		 * unrelated process.
+		 */
+		if (old_page)
+			page_cpupid_xchg_last(old_page, (1 << LAST_CPUPID_SHIFT) - 1);
+
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = pte_mkyoung(orig_pte);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
