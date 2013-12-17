Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3LQMtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:49:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41666 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3LQMqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:46:10 -0500
Message-Id: <20131217123353.318177450@infradead.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Dec 2013 13:27:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/13] sched: Remove sched_setscheduler2()
References: <20131217122720.950475833@infradead.org>
Content-Disposition: inline; filename=peterz-sched-attr-more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand sched_{set,get}attr() to include the policy and nice value.

This obviates the need for sched_setscheduler2().

The new sched_setattr() call now covers the functionality of:

  sched_setscheduler(),
  sched_setparam(),
  setpriority(.which = PRIO_PROCESS)

And sched_getattr() now covers:

  sched_getscheduler(),
  sched_getparam(),
  getpriority(.which = PRIO_PROCESS)

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/arm/include/asm/unistd.h      |    2 
 arch/arm/include/uapi/asm/unistd.h |    5 -
 arch/arm/kernel/calls.S            |    3 
 arch/x86/syscalls/syscall_32.tbl   |    1 
 arch/x86/syscalls/syscall_64.tbl   |    1 
 include/linux/sched.h              |   24 +++--
 include/linux/syscalls.h           |    2 
 kernel/sched/core.c                |  173 +++++++++++++++++++------------------
 kernel/sched/sched.h               |   13 +-
 9 files changed, 119 insertions(+), 105 deletions(-)

--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -15,7 +15,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define __NR_syscalls  (383)
+#define __NR_syscalls  (382)
 #define __ARM_NR_cmpxchg		(__ARM_NR_BASE+0x00fff0)
 
 #define __ARCH_WANT_STAT64
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -406,9 +406,8 @@
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
 #define __NR_kcmp			(__NR_SYSCALL_BASE+378)
 #define __NR_finit_module		(__NR_SYSCALL_BASE+379)
-#define __NR_sched_setscheduler2	(__NR_SYSCALL_BASE+380)
-#define __NR_sched_setattr		(__NR_SYSCALL_BASE+381)
-#define __NR_sched_getattr		(__NR_SYSCALL_BASE+382)
+#define __NR_sched_setattr		(__NR_SYSCALL_BASE+380)
+#define __NR_sched_getattr		(__NR_SYSCALL_BASE+381)
 
 /*
  * This may need to be greater than __NR_last_syscall+1 in order to
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -389,8 +389,7 @@
 		CALL(sys_process_vm_writev)
 		CALL(sys_kcmp)
 		CALL(sys_finit_module)
-/* 380 */	CALL(sys_sched_setscheduler2)
-		CALL(sys_sched_setattr)
+/* 380 */	CALL(sys_sched_setattr)
 		CALL(sys_sched_getattr)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -359,4 +359,3 @@
 350	i386	finit_module		sys_finit_module
 351	i386	sched_setattr		sys_sched_setattr
 352	i386	sched_getattr		sys_sched_getattr
-353	i386	sched_setscheduler2	sys_sched_setscheduler2
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -322,7 +322,6 @@
 313	common	finit_module		sys_finit_module
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
-316	common	sched_setscheduler2	sys_sched_setscheduler2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -57,7 +57,7 @@ struct sched_param {
 
 #include <asm/processor.h>
 
-#define SCHED_ATTR_SIZE_VER0	40	/* sizeof first published struct */
+#define SCHED_ATTR_SIZE_VER0	48	/* sizeof first published struct */
 
 /*
  * Extended scheduling parameters data structure.
@@ -85,7 +85,9 @@ struct sched_param {
  *
  * This is reflected by the actual fields of the sched_attr structure:
  *
- *  @sched_priority     task's priority (might still be useful)
+ *  @sched_policy	task's scheduling policy
+ *  @sched_nice		task's nice value      (SCHED_NORMAL/BATCH)
+ *  @sched_priority     task's static priority (SCHED_FIFO/RR)
  *  @sched_flags        for customizing the scheduler behaviour
  *  @sched_deadline     representative of the task's deadline
  *  @sched_runtime      representative of the task's runtime
@@ -102,15 +104,21 @@ struct sched_param {
  * available in the scheduling class file or in Documentation/.
  */
 struct sched_attr {
-	int sched_priority;
-	unsigned int sched_flags;
+	u32 size;
+
+	u32 sched_policy;
+	u64 sched_flags;
+
+	/* SCHED_NORMAL, SCHED_BATCH */
+	s32 sched_nice;
+
+	/* SCHED_FIFO, SCHED_RR */
+	u32 sched_priority;
+
+	/* SCHED_DEADLINE */
 	u64 sched_runtime;
 	u64 sched_deadline;
 	u64 sched_period;
-	u32 size;
-
-	/* Align to u64. */
-	u32 __reserved;
 };
 
 struct exec_domain;
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -278,8 +278,6 @@ asmlinkage long sys_clock_nanosleep(cloc
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
-asmlinkage long sys_sched_setscheduler2(pid_t pid, int policy,
-					struct sched_attr __user *attr);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
 asmlinkage long sys_sched_setattr(pid_t pid,
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2973,6 +2973,7 @@ void rt_mutex_setprio(struct task_struct
 	__task_rq_unlock(rq);
 }
 #endif
+
 void set_user_nice(struct task_struct *p, long nice)
 {
 	int old_prio, delta, on_rq;
@@ -3147,24 +3148,6 @@ static struct task_struct *find_process_
 	return pid ? find_task_by_vpid(pid) : current;
 }
 
-/* Actually do priority change: must hold rq lock. */
-static void
-__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
-{
-	p->policy = policy;
-	p->rt_priority = prio;
-	p->normal_prio = normal_prio(p);
-	/* we are holding p->pi_lock already */
-	p->prio = rt_mutex_getprio(p);
-	if (dl_prio(p->prio))
-		p->sched_class = &dl_sched_class;
-	else if (rt_prio(p->prio))
-		p->sched_class = &rt_sched_class;
-	else
-		p->sched_class = &fair_sched_class;
-	set_load_weight(p);
-}
-
 /*
  * This function initializes the sched_dl_entity of a newly becoming
  * SCHED_DEADLINE task.
@@ -3188,6 +3171,34 @@ __setparam_dl(struct task_struct *p, con
 	dl_se->dl_new = 1;
 }
 
+/* Actually do priority change: must hold pi & rq lock. */
+static void __setscheduler(struct rq *rq, struct task_struct *p,
+			   const struct sched_attr *attr)
+{
+	int policy = attr->sched_policy;
+
+	p->policy = policy;
+
+	if (fair_policy(policy))
+		p->static_prio = NICE_TO_PRIO(attr->sched_nice);
+	if (rt_policy(policy))
+		p->rt_priority = attr->sched_priority;
+	if (dl_policy(policy))
+		__setparam_dl(p, attr);
+
+	p->normal_prio = normal_prio(p);
+	p->prio = rt_mutex_getprio(p);
+
+	if (dl_prio(p->prio))
+		p->sched_class = &dl_sched_class;
+	else if (rt_prio(p->prio))
+		p->sched_class = &rt_sched_class;
+	else
+		p->sched_class = &fair_sched_class;
+
+	set_load_weight(p);
+}
+
 static void
 __getparam_dl(struct task_struct *p, struct sched_attr *attr)
 {
@@ -3234,11 +3245,12 @@ static bool check_same_owner(struct task
 	return match;
 }
 
-static int __sched_setscheduler(struct task_struct *p, int policy,
+static int __sched_setscheduler(struct task_struct *p,
 				const struct sched_attr *attr,
 				bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
+	int policy = attr->sched_policy;
 	unsigned long flags;
 	const struct sched_class *prev_class;
 	struct rq *rq;
@@ -3271,6 +3283,7 @@ static int __sched_setscheduler(struct t
 	    (p->mm && attr->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && attr->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
+
 	if ((dl_policy(policy) && !__checkparam_dl(attr)) ||
 	    (rt_policy(policy) != (attr->sched_priority != 0)))
 		return -EINVAL;
@@ -3279,6 +3292,11 @@ static int __sched_setscheduler(struct t
 	 * Allow unprivileged RT tasks to decrease priority:
 	 */
 	if (user && !capable(CAP_SYS_NICE)) {
+		if (fair_policy(policy)) {
+			if (!can_nice(p, attr->sched_nice))
+				return -EPERM;
+		}
+
 		if (rt_policy(policy)) {
 			unsigned long rlim_rtprio =
 					task_rlimit(p, RLIMIT_RTPRIO);
@@ -3337,12 +3355,18 @@ static int __sched_setscheduler(struct t
 	/*
 	 * If not changing anything there's no need to proceed further:
 	 */
-	if (unlikely(policy == p->policy && (!rt_policy(policy) ||
-			attr->sched_priority == p->rt_priority) &&
-			!dl_policy(policy))) {
+	if (unlikely(policy == p->policy)) {
+		if (fair_policy(policy) && attr->sched_nice != TASK_NICE(p))
+			goto change;
+		if (rt_policy(policy) && attr->sched_priority != p->rt_priority)
+			goto change;
+		if (dl_policy(policy))
+			goto change;
+
 		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
+change:
 
 	if (user) {
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -3399,8 +3423,7 @@ static int __sched_setscheduler(struct t
 	 */
 	if ((dl_policy(policy) || dl_task(p)) &&
 	    dl_overflow(p, policy, attr)) {
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		return -EBUSY;
 	}
 
@@ -3415,9 +3438,7 @@ static int __sched_setscheduler(struct t
 
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	if (dl_policy(policy))
-		__setparam_dl(p, attr);
-	__setscheduler(rq, p, policy, attr->sched_priority);
+	__setscheduler(rq, p, attr);
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
@@ -3446,18 +3467,18 @@ int sched_setscheduler(struct task_struc
 		       const struct sched_param *param)
 {
 	struct sched_attr attr = {
+		.sched_policy   = policy,
 		.sched_priority = param->sched_priority
 	};
-	return __sched_setscheduler(p, policy, &attr, true);
+	return __sched_setscheduler(p, &attr, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
 
-int sched_setscheduler2(struct task_struct *p, int policy,
-			const struct sched_attr *attr)
+int sched_setattr(struct task_struct *p, const struct sched_attr *attr)
 {
-	return __sched_setscheduler(p, policy, attr, true);
+	return __sched_setscheduler(p, attr, true);
 }
-EXPORT_SYMBOL_GPL(sched_setscheduler2);
+EXPORT_SYMBOL_GPL(sched_setattr);
 
 /**
  * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread from kernelspace.
@@ -3476,9 +3497,10 @@ int sched_setscheduler_nocheck(struct ta
 			       const struct sched_param *param)
 {
 	struct sched_attr attr = {
+		.sched_policy   = policy,
 		.sched_priority = param->sched_priority
 	};
-	return __sched_setscheduler(p, policy, &attr, false);
+	return __sched_setscheduler(p, &attr, false);
 }
 
 static int
@@ -3561,6 +3583,12 @@ static int sched_copy_attr(struct sched_
 	if (ret)
 		return -EFAULT;
 
+	/*
+	 * XXX: do we want to be lenient like existing syscalls; or do we want
+	 * to be strict and return an error on out-of-bounds values?
+	 */
+	attr->sched_nice = clamp(attr->sched_nice, -20, 19);
+
 out:
 	return ret;
 
@@ -3570,33 +3598,6 @@ static int sched_copy_attr(struct sched_
 	goto out;
 }
 
-static int
-do_sched_setscheduler2(pid_t pid, int policy,
-		       struct sched_attr __user *attr_uptr)
-{
-	struct sched_attr attr;
-	struct task_struct *p;
-	int retval;
-
-	if (!attr_uptr || pid < 0)
-		return -EINVAL;
-
-	if (sched_copy_attr(attr_uptr, &attr))
-		return -EFAULT;
-
-	rcu_read_lock();
-	retval = -ESRCH;
-	p = find_process_by_pid(pid);
-	if (p != NULL) {
-		if (dl_policy(policy))
-			attr.sched_priority = 0;
-		retval = sched_setscheduler2(p, policy, &attr);
-	}
-	rcu_read_unlock();
-
-	return retval;
-}
-
 /**
  * sys_sched_setscheduler - set/change the scheduler policy and RT priority
  * @pid: the pid in question.
@@ -3616,21 +3617,6 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_
 }
 
 /**
- * sys_sched_setscheduler2 - same as above, but with extended sched_param
- * @pid: the pid in question.
- * @policy: new policy (could use extended sched_param).
- * @attr: structure containg the extended parameters.
- */
-SYSCALL_DEFINE3(sched_setscheduler2, pid_t, pid, int, policy,
-		struct sched_attr __user *, attr)
-{
-	if (policy < 0)
-		return -EINVAL;
-
-	return do_sched_setscheduler2(pid, policy, attr);
-}
-
-/**
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
@@ -3647,10 +3633,26 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, p
  * @pid: the pid in question.
  * @attr: structure containing the extended parameters.
  */
-SYSCALL_DEFINE2(sched_setattr, pid_t, pid,
-		struct sched_attr __user *, attr)
+SYSCALL_DEFINE2(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr)
 {
-	return do_sched_setscheduler2(pid, -1, attr);
+	struct sched_attr attr;
+	struct task_struct *p;
+	int retval;
+
+	if (!uattr || pid < 0)
+		return -EINVAL;
+
+	if (sched_copy_attr(uattr, &attr))
+		return -EFAULT;
+
+	rcu_read_lock();
+	retval = -ESRCH;
+	p = find_process_by_pid(pid);
+	if (p != NULL)
+		retval = sched_setattr(p, &attr);
+	rcu_read_unlock();
+
+	return retval;
 }
 
 /**
@@ -3797,8 +3799,14 @@ SYSCALL_DEFINE3(sched_getattr, pid_t, pi
 	if (retval)
 		goto out_unlock;
 
-	__getparam_dl(p, &attr);
-	attr.sched_priority = p->rt_priority;
+	attr.sched_policy = p->policy;
+	if (task_has_dl_policy(p))
+		__getparam_dl(p, &attr);
+	else if (task_has_rt_policy(p))
+		attr.sched_priority = p->rt_priority;
+	else
+		attr.sched_nice = TASK_NICE(p);
+
 	rcu_read_unlock();
 
 	retval = sched_read_attr(uattr, &attr, size);
@@ -6948,13 +6956,16 @@ EXPORT_SYMBOL(__might_sleep);
 static void normalize_task(struct rq *rq, struct task_struct *p)
 {
 	const struct sched_class *prev_class = p->sched_class;
+	struct sched_attr attr = {
+		.sched_policy = SCHED_NORMAL,
+	};
 	int old_prio = p->prio;
 	int on_rq;
 
 	on_rq = p->on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
-	__setscheduler(rq, p, SCHED_NORMAL, 0);
+	__setscheduler(rq, p, &attr);
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
 		resched_task(rq->curr);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -90,18 +90,19 @@ extern void update_cpu_load_active(struc
  */
 #define DL_SCALE (10)
 
+static inline int fair_policy(int policy)
+{
+	return policy == SCHED_NORMAL || policy == SCHED_BATCH;
+}
+
 static inline int rt_policy(int policy)
 {
-	if (policy == SCHED_FIFO || policy == SCHED_RR)
-		return 1;
-	return 0;
+	return policy == SCHED_FIFO || policy == SCHED_RR;
 }
 
 static inline int dl_policy(int policy)
 {
-	if (unlikely(policy == SCHED_DEADLINE))
-		return 1;
-	return 0;
+	return unlikely(policy == SCHED_DEADLINE);
 }
 
 static inline int task_has_rt_policy(struct task_struct *p)


