Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3CNWzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:55:18 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:61050 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3CNWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:55:15 -0400
Date: Thu, 14 Mar 2013 15:55:08 -0700
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH REPOST v3.9-rc1] sched: replace PF_THREAD_BOUND with
 PF_NO_SETAFFINITY
Message-ID: <20130314225508.GC9400@htj.dyndns.org>
References: <20130308204518.GR14556@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308204518.GR14556@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PF_THREAD_BOUND was originally used to mark kernel threads which were
bound to a specific CPU using kthread_bind() and a task with the flag
set allows cpus_allowed modifications only to itself.  Workqueue is
currently abusing it to prevent userland from meddling with
cpus_allowed of workqueue workers.

What we need is a flag to prevent userland from messing with
cpus_allowed of certain kernel tasks.  In kernel, anyone can
(incorrectly) squash the flag, and, for worker-type usages,
restricting cpus_allowed modification to the task itself doesn't
provide meaningful extra proection as other tasks can inject work
items to the task anyway.

This patch replaces PF_THREAD_BOUND with PF_NO_SETAFFINITY.
sched_setaffinity() checks the flag and return -EINVAL if set.
set_cpus_allowed_ptr() is no longer affected by the flag.

This will allow simplifying workqueue worker CPU affinity management.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
Reposted because the original posting forgot to cc lkml.

Thanks.

 include/linux/sched.h |    2 +-
 kernel/cgroup.c       |    4 ++--
 kernel/cpuset.c       |   16 ++++++++--------
 kernel/kthread.c      |    2 +-
 kernel/sched/core.c   |    9 ++++-----
 kernel/workqueue.c    |    6 +++---
 6 files changed, 19 insertions(+), 20 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1793,7 +1793,7 @@ extern void thread_group_cputime_adjuste
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
-#define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
+#define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2224,11 +2224,11 @@ retry_find_task:
 		tsk = tsk->group_leader;
 
 	/*
-	 * Workqueue threads may acquire PF_THREAD_BOUND and become
+	 * Workqueue threads may acquire PF_NO_SETAFFINITY and become
 	 * trapped in a cpuset, or RT worker may be born in a cgroup
 	 * with no rt_runtime allocated.  Just say no.
 	 */
-	if (tsk == kthreadd_task || (tsk->flags & PF_THREAD_BOUND)) {
+	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
 		ret = -EINVAL;
 		rcu_read_unlock();
 		goto out_unlock_cgroup;
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1388,16 +1388,16 @@ static int cpuset_can_attach(struct cgro
 
 	cgroup_taskset_for_each(task, cgrp, tset) {
 		/*
-		 * Kthreads bound to specific cpus cannot be moved to a new
-		 * cpuset; we cannot change their cpu affinity and
-		 * isolating such threads by their set of allowed nodes is
-		 * unnecessary.  Thus, cpusets are not applicable for such
-		 * threads.  This prevents checking for success of
-		 * set_cpus_allowed_ptr() on all attached tasks before
-		 * cpus_allowed may be changed.
+		 * Kthreads which disallow setaffinity shouldn't be moved
+		 * to a new cpuset; we don't want to change their cpu
+		 * affinity and isolating such threads by their set of
+		 * allowed nodes is unnecessary.  Thus, cpusets are not
+		 * applicable for such threads.  This prevents checking for
+		 * success of set_cpus_allowed_ptr() on all attached tasks
+		 * before cpus_allowed may be changed.
 		 */
 		ret = -EINVAL;
-		if (task->flags & PF_THREAD_BOUND)
+		if (task->flags & PF_NO_SETAFFINITY)
 			goto out_unlock;
 		ret = security_task_setscheduler(task);
 		if (ret)
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -260,7 +260,7 @@ static void __kthread_bind(struct task_s
 {
 	/* It's safe because the task is inactive. */
 	do_set_cpus_allowed(p, cpumask_of(cpu));
-	p->flags |= PF_THREAD_BOUND;
+	p->flags |= PF_NO_SETAFFINITY;
 }
 
 /**
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4126,6 +4126,10 @@ long sched_setaffinity(pid_t pid, const
 	get_task_struct(p);
 	rcu_read_unlock();
 
+	if (p->flags & PF_NO_SETAFFINITY) {
+		retval = -EINVAL;
+		goto out_put_task;
+	}
 	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
 		retval = -ENOMEM;
 		goto out_put_task;
@@ -4772,11 +4776,6 @@ int set_cpus_allowed_ptr(struct task_str
 		ret = -EINVAL;
 		goto out;
 	}
-
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current)) {
-		ret = -EINVAL;
-		goto out;
-	}
 
 	do_set_cpus_allowed(p, new_mask);
 
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1741,12 +1741,12 @@ static struct worker *create_worker(stru
 	 * above the flag definition for details.
 	 *
 	 * As an unbound worker may later become a regular one if CPU comes
-	 * online, make sure every worker has %PF_THREAD_BOUND set.
+	 * online, make sure every worker has %PF_NO_SETAFFINITY set.
 	 */
 	if (!(pool->flags & POOL_DISASSOCIATED)) {
 		kthread_bind(worker->task, pool->cpu);
 	} else {
-		worker->task->flags |= PF_THREAD_BOUND;
+		worker->task->flags |= PF_NO_SETAFFINITY;
 		worker->flags |= WORKER_UNBOUND;
 	}
 
@@ -3219,7 +3219,7 @@ struct workqueue_struct *__alloc_workque
 		if (IS_ERR(rescuer->task))
 			goto err;
 
-		rescuer->task->flags |= PF_THREAD_BOUND;
+		rescuer->task->flags |= PF_NO_SETAFFINITY;
 		wake_up_process(rescuer->task);
 	}
 
