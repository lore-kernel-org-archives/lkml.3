Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaBVTUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 14:20:14 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42688 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaBVTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 14:20:12 -0500
Date: Sat, 22 Feb 2014 20:20:06 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140222192006.GA20769@gmail.com>
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

   # HEAD: 995b9ea440862def83e8fcb1b498e68f93d4af59 sched/deadline: Remove useless dl_nr_total

Misc fixlets: a fair number of them resulting from the new 
SCHED_DEADLINE code.

Sorry about the weekend pull request ... :-/

 Thanks,

	Ingo

------------------>
Boris Ostrovsky (1):
      sched/deadline: Test for CPU's presence explicitly

Juri Lelli (3):
      sched/deadline: Fix bad accounting of nr_running
      sched/core: Fix sched_rt_global_validate
      sched/core: Make dl_b->lock IRQ safe

Kirill Tkhai (1):
      sched/deadline: Remove useless dl_nr_total

Peter Zijlstra (1):
      sched: Add 'flags' argument to sched_{set,get}attr() syscalls

Rik van Riel (1):
      sched,numa: add cond_resched to task_numa_work

Steven Rostedt (1):
      sched/deadline: Fix overflow to handle period==0 and deadline!=0

Vegard Nossum (1):
      sched: Fix information leak in sys_sched_getattr()


 include/linux/syscalls.h   |  6 ++++--
 kernel/sched/core.c        | 28 ++++++++++++++++------------
 kernel/sched/cpudeadline.c |  6 +++---
 kernel/sched/deadline.c    | 10 +++-------
 kernel/sched/fair.c        |  2 ++
 kernel/sched/sched.h       |  1 -
 6 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40ed9e9..a747a77 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -281,13 +281,15 @@ asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
 asmlinkage long sys_sched_setattr(pid_t pid,
-					struct sched_attr __user *attr);
+					struct sched_attr __user *attr,
+					unsigned int flags);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
 asmlinkage long sys_sched_getattr(pid_t pid,
 					struct sched_attr __user *attr,
-					unsigned int size);
+					unsigned int size,
+					unsigned int flags);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..6edbef2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1952,7 +1952,7 @@ static int dl_overflow(struct task_struct *p, int policy,
 {
 
 	struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
-	u64 period = attr->sched_period;
+	u64 period = attr->sched_period ?: attr->sched_deadline;
 	u64 runtime = attr->sched_runtime;
 	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
 	int cpus, err = -1;
@@ -3661,13 +3661,14 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
  * @pid: the pid in question.
  * @uattr: structure containing the extended parameters.
  */
-SYSCALL_DEFINE2(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr)
+SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
+			       unsigned int, flags)
 {
 	struct sched_attr attr;
 	struct task_struct *p;
 	int retval;
 
-	if (!uattr || pid < 0)
+	if (!uattr || pid < 0 || flags)
 		return -EINVAL;
 
 	if (sched_copy_attr(uattr, &attr))
@@ -3786,7 +3787,7 @@ static int sched_read_attr(struct sched_attr __user *uattr,
 		attr->size = usize;
 	}
 
-	ret = copy_to_user(uattr, attr, usize);
+	ret = copy_to_user(uattr, attr, attr->size);
 	if (ret)
 		return -EFAULT;
 
@@ -3804,8 +3805,8 @@ err_size:
  * @uattr: structure containing the extended parameters.
  * @size: sizeof(attr) for fwd/bwd comp.
  */
-SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
-		unsigned int, size)
+SYSCALL_DEFINE4(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
+		unsigned int, size, unsigned int, flags)
 {
 	struct sched_attr attr = {
 		.size = sizeof(struct sched_attr),
@@ -3814,7 +3815,7 @@ SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
 	int retval;
 
 	if (!uattr || pid < 0 || size > PAGE_SIZE ||
-	    size < SCHED_ATTR_SIZE_VER0)
+	    size < SCHED_ATTR_SIZE_VER0 || flags)
 		return -EINVAL;
 
 	rcu_read_lock();
@@ -7422,6 +7423,7 @@ static int sched_dl_global_constraints(void)
 	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
 	int cpu, ret = 0;
+	unsigned long flags;
 
 	/*
 	 * Here we want to check the bandwidth not being set to some
@@ -7435,10 +7437,10 @@ static int sched_dl_global_constraints(void)
 	for_each_possible_cpu(cpu) {
 		struct dl_bw *dl_b = dl_bw_of(cpu);
 
-		raw_spin_lock(&dl_b->lock);
+		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		if (new_bw < dl_b->total_bw)
 			ret = -EBUSY;
-		raw_spin_unlock(&dl_b->lock);
+		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
 		if (ret)
 			break;
@@ -7451,6 +7453,7 @@ static void sched_dl_do_global(void)
 {
 	u64 new_bw = -1;
 	int cpu;
+	unsigned long flags;
 
 	def_dl_bandwidth.dl_period = global_rt_period();
 	def_dl_bandwidth.dl_runtime = global_rt_runtime();
@@ -7464,9 +7467,9 @@ static void sched_dl_do_global(void)
 	for_each_possible_cpu(cpu) {
 		struct dl_bw *dl_b = dl_bw_of(cpu);
 
-		raw_spin_lock(&dl_b->lock);
+		raw_spin_lock_irqsave(&dl_b->lock, flags);
 		dl_b->bw = new_bw;
-		raw_spin_unlock(&dl_b->lock);
+		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 	}
 }
 
@@ -7475,7 +7478,8 @@ static int sched_rt_global_validate(void)
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
-	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
+	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
+		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
 		return -EINVAL;
 
 	return 0;
diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 045fc74..5b8838b 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -70,7 +70,7 @@ static void cpudl_heapify(struct cpudl *cp, int idx)
 
 static void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
 {
-	WARN_ON(idx > num_present_cpus() || idx == IDX_INVALID);
+	WARN_ON(!cpu_present(idx) || idx == IDX_INVALID);
 
 	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
 		cp->elements[idx].dl = new_dl;
@@ -117,7 +117,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	}
 
 out:
-	WARN_ON(best_cpu > num_present_cpus() && best_cpu != -1);
+	WARN_ON(!cpu_present(best_cpu) && best_cpu != -1);
 
 	return best_cpu;
 }
@@ -137,7 +137,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 	int old_idx, new_cpu;
 	unsigned long flags;
 
-	WARN_ON(cpu > num_present_cpus());
+	WARN_ON(!cpu_present(cpu));
 
 	raw_spin_lock_irqsave(&cp->lock, flags);
 	old_idx = cp->cpu_to_idx[cpu];
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0dd5e09..15cbc17 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -121,7 +121,7 @@ static inline void dl_clear_overload(struct rq *rq)
 
 static void update_dl_migration(struct dl_rq *dl_rq)
 {
-	if (dl_rq->dl_nr_migratory && dl_rq->dl_nr_total > 1) {
+	if (dl_rq->dl_nr_migratory && dl_rq->dl_nr_running > 1) {
 		if (!dl_rq->overloaded) {
 			dl_set_overload(rq_of_dl_rq(dl_rq));
 			dl_rq->overloaded = 1;
@@ -137,7 +137,6 @@ static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 	struct task_struct *p = dl_task_of(dl_se);
 	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
 
-	dl_rq->dl_nr_total++;
 	if (p->nr_cpus_allowed > 1)
 		dl_rq->dl_nr_migratory++;
 
@@ -149,7 +148,6 @@ static void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 	struct task_struct *p = dl_task_of(dl_se);
 	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
 
-	dl_rq->dl_nr_total--;
 	if (p->nr_cpus_allowed > 1)
 		dl_rq->dl_nr_migratory--;
 
@@ -717,6 +715,7 @@ void inc_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 
 	WARN_ON(!dl_prio(prio));
 	dl_rq->dl_nr_running++;
+	inc_nr_running(rq_of_dl_rq(dl_rq));
 
 	inc_dl_deadline(dl_rq, deadline);
 	inc_dl_migration(dl_se, dl_rq);
@@ -730,6 +729,7 @@ void dec_dl_tasks(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 	WARN_ON(!dl_prio(prio));
 	WARN_ON(!dl_rq->dl_nr_running);
 	dl_rq->dl_nr_running--;
+	dec_nr_running(rq_of_dl_rq(dl_rq));
 
 	dec_dl_deadline(dl_rq, dl_se->deadline);
 	dec_dl_migration(dl_se, dl_rq);
@@ -836,8 +836,6 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_dl_task(rq, p);
-
-	inc_nr_running(rq);
 }
 
 static void __dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
@@ -850,8 +848,6 @@ static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 {
 	update_curr_dl(rq);
 	__dequeue_task_dl(rq, p, flags);
-
-	dec_nr_running(rq);
 }
 
 /*
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 966cc2b..7815709 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1757,6 +1757,8 @@ void task_numa_work(struct callback_head *work)
 			start = end;
 			if (pages <= 0)
 				goto out;
+
+			cond_resched();
 		} while (end != vma->vm_end);
 	}
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2119fd..f964add 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -462,7 +462,6 @@ struct dl_rq {
 	} earliest_dl;
 
 	unsigned long dl_nr_migratory;
-	unsigned long dl_nr_total;
 	int overloaded;
 
 	/*
