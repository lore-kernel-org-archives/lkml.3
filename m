Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaAMRSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:18:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60795 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbaAMPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:55:24 -0500
Date: Mon, 13 Jan 2014 07:54:49 -0800
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-6bfd6d72f51c51177676f2b1ba113fe0a85fdae4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1383831828-15501-14-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-14-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  speed up SCHED_DEADLINE pushes with a push-heap
Git-Commit-ID: 6bfd6d72f51c51177676f2b1ba113fe0a85fdae4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:54:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bfd6d72f51c51177676f2b1ba113fe0a85fdae4
Gitweb:     http://git.kernel.org/tip/6bfd6d72f51c51177676f2b1ba113fe0a85fdae4
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Thu, 7 Nov 2013 14:43:47 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:46:46 +0100

sched/deadline: speed up SCHED_DEADLINE pushes with a push-heap

Data from tests confirmed that the original active load balancing
logic didn't scale neither in the number of CPU nor in the number of
tasks (as sched_rt does).

Here we provide a global data structure to keep track of deadlines
of the running tasks in the system. The structure is composed by
a bitmask showing the free CPUs and a max-heap, needed when the system
is heavily loaded.

The implementation and concurrent access scheme are kept simple by
design. However, our measurements show that we can compete with sched_rt
on large multi-CPUs machines [1].

Only the push path is addressed, the extension to use this structure
also for pull decisions is straightforward. However, we are currently
evaluating different (in order to decrease/avoid contention) data
structures to solve possibly both problems. We are also going to re-run
tests considering recent changes inside cpupri [2].

 [1] http://retis.sssup.it/~jlelli/papers/Ospert11Lelli.pdf
 [2] http://www.spinics.net/lists/linux-rt-users/msg06778.html

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1383831828-15501-14-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/Makefile      |   2 +-
 kernel/sched/core.c        |   3 +
 kernel/sched/cpudeadline.c | 216 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/cpudeadline.h |  33 +++++++
 kernel/sched/deadline.c    |  53 +++--------
 kernel/sched/sched.h       |   2 +
 6 files changed, 269 insertions(+), 40 deletions(-)

diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index b039035..9a95c8c 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -14,7 +14,7 @@ endif
 obj-y += core.o proc.o clock.o cputime.o
 obj-y += idle_task.o fair.o rt.o deadline.o stop_task.o
 obj-y += wait.o completion.o
-obj-$(CONFIG_SMP) += cpupri.o
+obj-$(CONFIG_SMP) += cpupri.o cpudeadline.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c7c68e6..e30356d6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5287,6 +5287,7 @@ static void free_rootdomain(struct rcu_head *rcu)
 	struct root_domain *rd = container_of(rcu, struct root_domain, rcu);
 
 	cpupri_cleanup(&rd->cpupri);
+	cpudl_cleanup(&rd->cpudl);
 	free_cpumask_var(rd->dlo_mask);
 	free_cpumask_var(rd->rto_mask);
 	free_cpumask_var(rd->online);
@@ -5345,6 +5346,8 @@ static int init_rootdomain(struct root_domain *rd)
 		goto free_dlo_mask;
 
 	init_dl_bw(&rd->dl_bw);
+	if (cpudl_init(&rd->cpudl) != 0)
+		goto free_dlo_mask;
 
 	if (cpupri_init(&rd->cpupri) != 0)
 		goto free_rto_mask;
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
new file mode 100644
index 0000000..3bcade5
--- /dev/null
+++ b/kernel/sched/cpudeadline.c
@@ -0,0 +1,216 @@
+/*
+ *  kernel/sched/cpudl.c
+ *
+ *  Global CPU deadline management
+ *
+ *  Author: Juri Lelli <j.lelli@sssup.it>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; version 2
+ *  of the License.
+ */
+
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include "cpudeadline.h"
+
+static inline int parent(int i)
+{
+	return (i - 1) >> 1;
+}
+
+static inline int left_child(int i)
+{
+	return (i << 1) + 1;
+}
+
+static inline int right_child(int i)
+{
+	return (i << 1) + 2;
+}
+
+static inline int dl_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
+void cpudl_exchange(struct cpudl *cp, int a, int b)
+{
+	int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
+
+	swap(cp->elements[a], cp->elements[b]);
+	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
+}
+
+void cpudl_heapify(struct cpudl *cp, int idx)
+{
+	int l, r, largest;
+
+	/* adapted from lib/prio_heap.c */
+	while(1) {
+		l = left_child(idx);
+		r = right_child(idx);
+		largest = idx;
+
+		if ((l < cp->size) && dl_time_before(cp->elements[idx].dl,
+							cp->elements[l].dl))
+			largest = l;
+		if ((r < cp->size) && dl_time_before(cp->elements[largest].dl,
+							cp->elements[r].dl))
+			largest = r;
+		if (largest == idx)
+			break;
+
+		/* Push idx down the heap one level and bump one up */
+		cpudl_exchange(cp, largest, idx);
+		idx = largest;
+	}
+}
+
+void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
+{
+	WARN_ON(idx > num_present_cpus() || idx == IDX_INVALID);
+
+	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
+		cp->elements[idx].dl = new_dl;
+		cpudl_heapify(cp, idx);
+	} else {
+		cp->elements[idx].dl = new_dl;
+		while (idx > 0 && dl_time_before(cp->elements[parent(idx)].dl,
+					cp->elements[idx].dl)) {
+			cpudl_exchange(cp, idx, parent(idx));
+			idx = parent(idx);
+		}
+	}
+}
+
+static inline int cpudl_maximum(struct cpudl *cp)
+{
+	return cp->elements[0].cpu;
+}
+
+/*
+ * cpudl_find - find the best (later-dl) CPU in the system
+ * @cp: the cpudl max-heap context
+ * @p: the task
+ * @later_mask: a mask to fill in with the selected CPUs (or NULL)
+ *
+ * Returns: int - best CPU (heap maximum if suitable)
+ */
+int cpudl_find(struct cpudl *cp, struct task_struct *p,
+	       struct cpumask *later_mask)
+{
+	int best_cpu = -1;
+	const struct sched_dl_entity *dl_se = &p->dl;
+
+	if (later_mask && cpumask_and(later_mask, cp->free_cpus,
+			&p->cpus_allowed) && cpumask_and(later_mask,
+			later_mask, cpu_active_mask)) {
+		best_cpu = cpumask_any(later_mask);
+		goto out;
+	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
+			dl_time_before(dl_se->deadline, cp->elements[0].dl)) {
+		best_cpu = cpudl_maximum(cp);
+		if (later_mask)
+			cpumask_set_cpu(best_cpu, later_mask);
+	}
+
+out:
+	WARN_ON(best_cpu > num_present_cpus() && best_cpu != -1);
+
+	return best_cpu;
+}
+
+/*
+ * cpudl_set - update the cpudl max-heap
+ * @cp: the cpudl max-heap context
+ * @cpu: the target cpu
+ * @dl: the new earliest deadline for this cpu
+ *
+ * Notes: assumes cpu_rq(cpu)->lock is locked
+ *
+ * Returns: (void)
+ */
+void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
+{
+	int old_idx, new_cpu;
+	unsigned long flags;
+
+	WARN_ON(cpu > num_present_cpus());
+
+	raw_spin_lock_irqsave(&cp->lock, flags);
+	old_idx = cp->cpu_to_idx[cpu];
+	if (!is_valid) {
+		/* remove item */
+		if (old_idx == IDX_INVALID) {
+			/*
+			 * Nothing to remove if old_idx was invalid.
+			 * This could happen if a rq_offline_dl is
+			 * called for a CPU without -dl tasks running.
+			 */
+			goto out;
+		}
+		new_cpu = cp->elements[cp->size - 1].cpu;
+		cp->elements[old_idx].dl = cp->elements[cp->size - 1].dl;
+		cp->elements[old_idx].cpu = new_cpu;
+		cp->size--;
+		cp->cpu_to_idx[new_cpu] = old_idx;
+		cp->cpu_to_idx[cpu] = IDX_INVALID;
+		while (old_idx > 0 && dl_time_before(
+				cp->elements[parent(old_idx)].dl,
+				cp->elements[old_idx].dl)) {
+			cpudl_exchange(cp, old_idx, parent(old_idx));
+			old_idx = parent(old_idx);
+		}
+		cpumask_set_cpu(cpu, cp->free_cpus);
+                cpudl_heapify(cp, old_idx);
+
+		goto out;
+	}
+
+	if (old_idx == IDX_INVALID) {
+		cp->size++;
+		cp->elements[cp->size - 1].dl = 0;
+		cp->elements[cp->size - 1].cpu = cpu;
+		cp->cpu_to_idx[cpu] = cp->size - 1;
+		cpudl_change_key(cp, cp->size - 1, dl);
+		cpumask_clear_cpu(cpu, cp->free_cpus);
+	} else {
+		cpudl_change_key(cp, old_idx, dl);
+	}
+
+out:
+	raw_spin_unlock_irqrestore(&cp->lock, flags);
+}
+
+/*
+ * cpudl_init - initialize the cpudl structure
+ * @cp: the cpudl max-heap context
+ */
+int cpudl_init(struct cpudl *cp)
+{
+	int i;
+
+	memset(cp, 0, sizeof(*cp));
+	raw_spin_lock_init(&cp->lock);
+	cp->size = 0;
+	for (i = 0; i < NR_CPUS; i++)
+		cp->cpu_to_idx[i] = IDX_INVALID;
+	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_setall(cp->free_cpus);
+
+	return 0;
+}
+
+/*
+ * cpudl_cleanup - clean up the cpudl structure
+ * @cp: the cpudl max-heap context
+ */
+void cpudl_cleanup(struct cpudl *cp)
+{
+	/*
+	 * nothing to do for the moment
+	 */
+}
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
new file mode 100644
index 0000000..a202789
--- /dev/null
+++ b/kernel/sched/cpudeadline.h
@@ -0,0 +1,33 @@
+#ifndef _LINUX_CPUDL_H
+#define _LINUX_CPUDL_H
+
+#include <linux/sched.h>
+
+#define IDX_INVALID     -1
+
+struct array_item {
+	u64 dl;
+	int cpu;
+};
+
+struct cpudl {
+	raw_spinlock_t lock;
+	int size;
+	int cpu_to_idx[NR_CPUS];
+	struct array_item elements[NR_CPUS];
+	cpumask_var_t free_cpus;
+};
+
+
+#ifdef CONFIG_SMP
+int cpudl_find(struct cpudl *cp, struct task_struct *p,
+	       struct cpumask *later_mask);
+void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid);
+int cpudl_init(struct cpudl *cp);
+void cpudl_cleanup(struct cpudl *cp);
+#else
+#define cpudl_set(cp, cpu, dl) do { } while (0)
+#define cpudl_init() do { } while (0)
+#endif /* CONFIG_SMP */
+
+#endif /* _LINUX_CPUDL_H */
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 802188f..0c6b1d0 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -16,6 +16,8 @@
  */
 #include "sched.h"
 
+#include <linux/slab.h>
+
 struct dl_bandwidth def_dl_bandwidth;
 
 static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se)
@@ -640,6 +642,7 @@ static void inc_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 		 */
 		dl_rq->earliest_dl.next = dl_rq->earliest_dl.curr;
 		dl_rq->earliest_dl.curr = deadline;
+		cpudl_set(&rq->rd->cpudl, rq->cpu, deadline, 1);
 	} else if (dl_rq->earliest_dl.next == 0 ||
 		   dl_time_before(deadline, dl_rq->earliest_dl.next)) {
 		/*
@@ -663,6 +666,7 @@ static void dec_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 	if (!dl_rq->dl_nr_running) {
 		dl_rq->earliest_dl.curr = 0;
 		dl_rq->earliest_dl.next = 0;
+		cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
 	} else {
 		struct rb_node *leftmost = dl_rq->rb_leftmost;
 		struct sched_dl_entity *entry;
@@ -670,6 +674,7 @@ static void dec_dl_deadline(struct dl_rq *dl_rq, u64 deadline)
 		entry = rb_entry(leftmost, struct sched_dl_entity, rb_node);
 		dl_rq->earliest_dl.curr = entry->deadline;
 		dl_rq->earliest_dl.next = next_deadline(rq);
+		cpudl_set(&rq->rd->cpudl, rq->cpu, entry->deadline, 1);
 	}
 }
 
@@ -855,9 +860,6 @@ static void yield_task_dl(struct rq *rq)
 #ifdef CONFIG_SMP
 
 static int find_later_rq(struct task_struct *task);
-static int latest_cpu_find(struct cpumask *span,
-			   struct task_struct *task,
-			   struct cpumask *later_mask);
 
 static int
 select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
@@ -904,7 +906,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * let's hope p can move out.
 	 */
 	if (rq->curr->nr_cpus_allowed == 1 ||
-	    latest_cpu_find(rq->rd->span, rq->curr, NULL) == -1)
+	    cpudl_find(&rq->rd->cpudl, rq->curr, NULL) == -1)
 		return;
 
 	/*
@@ -912,7 +914,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	 * see if it is pushed or pulled somewhere else.
 	 */
 	if (p->nr_cpus_allowed != 1 &&
-	    latest_cpu_find(rq->rd->span, p, NULL) != -1)
+	    cpudl_find(&rq->rd->cpudl, p, NULL) != -1)
 		return;
 
 	resched_task(rq->curr);
@@ -1085,39 +1087,6 @@ next_node:
 	return NULL;
 }
 
-static int latest_cpu_find(struct cpumask *span,
-			   struct task_struct *task,
-			   struct cpumask *later_mask)
-{
-	const struct sched_dl_entity *dl_se = &task->dl;
-	int cpu, found = -1, best = 0;
-	u64 max_dl = 0;
-
-	for_each_cpu(cpu, span) {
-		struct rq *rq = cpu_rq(cpu);
-		struct dl_rq *dl_rq = &rq->dl;
-
-		if (cpumask_test_cpu(cpu, &task->cpus_allowed) &&
-		    (!dl_rq->dl_nr_running || dl_time_before(dl_se->deadline,
-		     dl_rq->earliest_dl.curr))) {
-			if (later_mask)
-				cpumask_set_cpu(cpu, later_mask);
-			if (!best && !dl_rq->dl_nr_running) {
-				best = 1;
-				found = cpu;
-			} else if (!best &&
-				   dl_time_before(max_dl,
-						  dl_rq->earliest_dl.curr)) {
-				max_dl = dl_rq->earliest_dl.curr;
-				found = cpu;
-			}
-		} else if (later_mask)
-			cpumask_clear_cpu(cpu, later_mask);
-	}
-
-	return found;
-}
-
 static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
 
 static int find_later_rq(struct task_struct *task)
@@ -1134,7 +1103,8 @@ static int find_later_rq(struct task_struct *task)
 	if (task->nr_cpus_allowed == 1)
 		return -1;
 
-	best_cpu = latest_cpu_find(task_rq(task)->rd->span, task, later_mask);
+	best_cpu = cpudl_find(&task_rq(task)->rd->cpudl,
+			task, later_mask);
 	if (best_cpu == -1)
 		return -1;
 
@@ -1510,6 +1480,9 @@ static void rq_online_dl(struct rq *rq)
 {
 	if (rq->dl.overloaded)
 		dl_set_overload(rq);
+
+	if (rq->dl.dl_nr_running > 0)
+		cpudl_set(&rq->rd->cpudl, rq->cpu, rq->dl.earliest_dl.curr, 1);
 }
 
 /* Assumes rq->lock is held */
@@ -1517,6 +1490,8 @@ static void rq_offline_dl(struct rq *rq)
 {
 	if (rq->dl.overloaded)
 		dl_clear_overload(rq);
+
+	cpudl_set(&rq->rd->cpudl, rq->cpu, 0, 0);
 }
 
 void init_sched_dl_class(void)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ad4f4fb..2b7421d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 
 #include "cpupri.h"
+#include "cpudeadline.h"
 #include "cpuacct.h"
 
 struct rq;
@@ -503,6 +504,7 @@ struct root_domain {
 	cpumask_var_t dlo_mask;
 	atomic_t dlo_count;
 	struct dl_bw dl_bw;
+	struct cpudl cpudl;
 
 	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
