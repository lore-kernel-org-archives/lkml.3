Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaFAIRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 04:17:46 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:50122 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaFAIRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 04:17:43 -0400
Date: Sun, 1 Jun 2014 10:17:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140601081736.GA16511@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: 6acbfb96976fc3350e30d964acb1dbbdf876d55e sched: Fix hotplug vs. set_cpus_allowed_ptr()

Various fixlets, mostly related to the (root-only) SCHED_DEADLINE 
policy, but also a hotplug bug fix and a fix for a NR_CPUS related 
overallocation bug causing a suspend/resume regression.

 Thanks,

	Ingo

------------------>
Juri Lelli (1):
      sched/deadline: Restrict user params max value to 2^63 ns

Lai Jiangshan (1):
      sched: Fix hotplug vs. set_cpus_allowed_ptr()

Michael Kerrisk (1):
      sched: Make sched_setattr() correctly return -EFBIG

Peter Zijlstra (4):
      sched: Disallow sched_attr::sched_policy < 0
      sched/deadline: Change sched_getparam() behaviour vs SCHED_DEADLINE
      sched/deadline: Replace NR_CPUS arrays
      sched/cpupri: Replace NR_CPUS arrays


 kernel/cpu.c               |  6 +++--
 kernel/sched/core.c        | 55 ++++++++++++++++++++++++++++++++--------------
 kernel/sched/cpudeadline.c | 33 ++++++++++++++++++++--------
 kernel/sched/cpudeadline.h |  6 ++---
 kernel/sched/cpupri.c      |  7 ++++++
 kernel/sched/cpupri.h      |  2 +-
 6 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a9e710e..247979a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -726,10 +726,12 @@ void set_cpu_present(unsigned int cpu, bool present)
 
 void set_cpu_online(unsigned int cpu, bool online)
 {
-	if (online)
+	if (online) {
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
-	else
+		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+	} else {
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+	}
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 13584f1..86f3890 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3195,17 +3195,40 @@ __getparam_dl(struct task_struct *p, struct sched_attr *attr)
  * We ask for the deadline not being zero, and greater or equal
  * than the runtime, as well as the period of being zero or
  * greater than deadline. Furthermore, we have to be sure that
- * user parameters are above the internal resolution (1us); we
- * check sched_runtime only since it is always the smaller one.
+ * user parameters are above the internal resolution of 1us (we
+ * check sched_runtime only since it is always the smaller one) and
+ * below 2^63 ns (we have to check both sched_deadline and
+ * sched_period, as the latter can be zero).
  */
 static bool
 __checkparam_dl(const struct sched_attr *attr)
 {
-	return attr && attr->sched_deadline != 0 &&
-		(attr->sched_period == 0 ||
-		(s64)(attr->sched_period   - attr->sched_deadline) >= 0) &&
-		(s64)(attr->sched_deadline - attr->sched_runtime ) >= 0  &&
-		attr->sched_runtime >= (2 << (DL_SCALE - 1));
+	/* deadline != 0 */
+	if (attr->sched_deadline == 0)
+		return false;
+
+	/*
+	 * Since we truncate DL_SCALE bits, make sure we're at least
+	 * that big.
+	 */
+	if (attr->sched_runtime < (1ULL << DL_SCALE))
+		return false;
+
+	/*
+	 * Since we use the MSB for wrap-around and sign issues, make
+	 * sure it's not set (mind that period can be equal to zero).
+	 */
+	if (attr->sched_deadline & (1ULL << 63) ||
+	    attr->sched_period & (1ULL << 63))
+		return false;
+
+	/* runtime <= deadline <= period (if period != 0) */
+	if ((attr->sched_period != 0 &&
+	     attr->sched_period < attr->sched_deadline) ||
+	    attr->sched_deadline < attr->sched_runtime)
+		return false;
+
+	return true;
 }
 
 /*
@@ -3658,8 +3681,12 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	if (!uattr || pid < 0 || flags)
 		return -EINVAL;
 
-	if (sched_copy_attr(uattr, &attr))
-		return -EFAULT;
+	retval = sched_copy_attr(uattr, &attr);
+	if (retval)
+		return retval;
+
+	if (attr.sched_policy < 0)
+		return -EINVAL;
 
 	rcu_read_lock();
 	retval = -ESRCH;
@@ -3709,7 +3736,7 @@ SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
  */
 SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 {
-	struct sched_param lp;
+	struct sched_param lp = { .sched_priority = 0 };
 	struct task_struct *p;
 	int retval;
 
@@ -3726,11 +3753,8 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
 	if (retval)
 		goto out_unlock;
 
-	if (task_has_dl_policy(p)) {
-		retval = -EINVAL;
-		goto out_unlock;
-	}
-	lp.sched_priority = p->rt_priority;
+	if (task_has_rt_policy(p))
+		lp.sched_priority = p->rt_priority;
 	rcu_read_unlock();
 
 	/*
@@ -5052,7 +5076,6 @@ static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index ab001b5..bd95963 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -13,6 +13,7 @@
 
 #include <linux/gfp.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include "cpudeadline.h"
 
 static inline int parent(int i)
@@ -39,8 +40,10 @@ static void cpudl_exchange(struct cpudl *cp, int a, int b)
 {
 	int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
 
-	swap(cp->elements[a], cp->elements[b]);
-	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
+	swap(cp->elements[a].cpu, cp->elements[b].cpu);
+	swap(cp->elements[a].dl , cp->elements[b].dl );
+
+	swap(cp->elements[cpu_a].idx, cp->elements[cpu_b].idx);
 }
 
 static void cpudl_heapify(struct cpudl *cp, int idx)
@@ -140,7 +143,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 	WARN_ON(!cpu_present(cpu));
 
 	raw_spin_lock_irqsave(&cp->lock, flags);
-	old_idx = cp->cpu_to_idx[cpu];
+	old_idx = cp->elements[cpu].idx;
 	if (!is_valid) {
 		/* remove item */
 		if (old_idx == IDX_INVALID) {
@@ -155,8 +158,8 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 		cp->elements[old_idx].dl = cp->elements[cp->size - 1].dl;
 		cp->elements[old_idx].cpu = new_cpu;
 		cp->size--;
-		cp->cpu_to_idx[new_cpu] = old_idx;
-		cp->cpu_to_idx[cpu] = IDX_INVALID;
+		cp->elements[new_cpu].idx = old_idx;
+		cp->elements[cpu].idx = IDX_INVALID;
 		while (old_idx > 0 && dl_time_before(
 				cp->elements[parent(old_idx)].dl,
 				cp->elements[old_idx].dl)) {
@@ -173,7 +176,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 		cp->size++;
 		cp->elements[cp->size - 1].dl = 0;
 		cp->elements[cp->size - 1].cpu = cpu;
-		cp->cpu_to_idx[cpu] = cp->size - 1;
+		cp->elements[cpu].idx = cp->size - 1;
 		cpudl_change_key(cp, cp->size - 1, dl);
 		cpumask_clear_cpu(cpu, cp->free_cpus);
 	} else {
@@ -195,10 +198,21 @@ int cpudl_init(struct cpudl *cp)
 	memset(cp, 0, sizeof(*cp));
 	raw_spin_lock_init(&cp->lock);
 	cp->size = 0;
-	for (i = 0; i < NR_CPUS; i++)
-		cp->cpu_to_idx[i] = IDX_INVALID;
-	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
+
+	cp->elements = kcalloc(nr_cpu_ids,
+			       sizeof(struct cpudl_item),
+			       GFP_KERNEL);
+	if (!cp->elements)
+		return -ENOMEM;
+
+	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
+		kfree(cp->elements);
 		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(i)
+		cp->elements[i].idx = IDX_INVALID;
+
 	cpumask_setall(cp->free_cpus);
 
 	return 0;
@@ -211,4 +225,5 @@ int cpudl_init(struct cpudl *cp)
 void cpudl_cleanup(struct cpudl *cp)
 {
 	free_cpumask_var(cp->free_cpus);
+	kfree(cp->elements);
 }
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index a202789..538c979 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -5,17 +5,17 @@
 
 #define IDX_INVALID     -1
 
-struct array_item {
+struct cpudl_item {
 	u64 dl;
 	int cpu;
+	int idx;
 };
 
 struct cpudl {
 	raw_spinlock_t lock;
 	int size;
-	int cpu_to_idx[NR_CPUS];
-	struct array_item elements[NR_CPUS];
 	cpumask_var_t free_cpus;
+	struct cpudl_item *elements;
 };
 
 
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 3031bac..8834243 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -30,6 +30,7 @@
 #include <linux/gfp.h>
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
+#include <linux/slab.h>
 #include "cpupri.h"
 
 /* Convert between a 140 based task->prio, and our 102 based cpupri */
@@ -218,8 +219,13 @@ int cpupri_init(struct cpupri *cp)
 			goto cleanup;
 	}
 
+	cp->cpu_to_pri = kcalloc(nr_cpu_ids, sizeof(int), GFP_KERNEL);
+	if (!cp->cpu_to_pri)
+		goto cleanup;
+
 	for_each_possible_cpu(i)
 		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+
 	return 0;
 
 cleanup:
@@ -236,6 +242,7 @@ void cpupri_cleanup(struct cpupri *cp)
 {
 	int i;
 
+	kfree(cp->cpu_to_pri);
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++)
 		free_cpumask_var(cp->pri_to_cpu[i].mask);
 }
diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
index f6d7561..6b03334 100644
--- a/kernel/sched/cpupri.h
+++ b/kernel/sched/cpupri.h
@@ -17,7 +17,7 @@ struct cpupri_vec {
 
 struct cpupri {
 	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
-	int               cpu_to_pri[NR_CPUS];
+	int *cpu_to_pri;
 };
 
 #ifdef CONFIG_SMP
