Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3CNXCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:02:52 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:63890 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3CNXBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:01:41 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH REVIEW_ONLY 1/5] sched: replace PF_THREAD_BOUND with PF_NO_SETAFFINITY
Date: Thu, 14 Mar 2013 16:01:26 -0700
Message-Id: <1363302090-16117-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363302090-16117-1-git-send-email-tj@kernel.org>
References: <1363302090-16117-1-git-send-email-tj@kernel.org>
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

FOR-REVIEW-ONLY
---
This patch doesn't belong in this series.  It's posted separately and
should be routed through -tip.  Included here only to help review.

Thanks.

 include/linux/sched.h |  2 +-
 kernel/cgroup.c       |  4 ++--
 kernel/cpuset.c       | 16 ++++++++--------
 kernel/kthread.c      |  2 +-
 kernel/sched/core.c   |  9 ++++-----
 kernel/workqueue.c    | 10 +++-------
 6 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..e5c64f7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1793,7 +1793,7 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
-#define PF_THREAD_BOUND	0x04000000	/* Thread bound to specific cpu */
+#define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f943..3852d92 100644
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
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4f9dfe4..f22e947 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1388,16 +1388,16 @@ static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 
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
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 691dc2e..a2fbbb7 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -260,7 +260,7 @@ static void __kthread_bind(struct task_struct *p, unsigned int cpu)
 {
 	/* It's safe because the task is inactive. */
 	do_set_cpus_allowed(p, cpumask_of(cpu));
-	p->flags |= PF_THREAD_BOUND;
+	p->flags |= PF_NO_SETAFFINITY;
 }
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..23606ee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4126,6 +4126,10 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	get_task_struct(p);
 	rcu_read_unlock();
 
+	if (p->flags & PF_NO_SETAFFINITY) {
+		retval = -EINVAL;
+		goto out_put_task;
+	}
 	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
 		retval = -ENOMEM;
 		goto out_put_task;
@@ -4773,11 +4777,6 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	do_set_cpus_allowed(p, new_mask);
 
 	/* Can the task run on the task's current CPU? If so, we're done */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 969be0b..39a591f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1757,12 +1757,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	set_user_nice(worker->task, pool->attrs->nice);
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
-	/*
-	 * %PF_THREAD_BOUND is used to prevent userland from meddling with
-	 * cpumask of workqueue workers.  This is an abuse.  We need
-	 * %PF_NO_SETAFFINITY.
-	 */
-	worker->task->flags |= PF_THREAD_BOUND;
+	/* prevent userland from meddling with cpumask of workqueue workers */
+	worker->task->flags |= PF_NO_SETAFFINITY;
 
 	/*
 	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
@@ -3876,7 +3872,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		}
 
 		wq->rescuer = rescuer;
-		rescuer->task->flags |= PF_THREAD_BOUND;
+		rescuer->task->flags |= PF_NO_SETAFFINITY;
 		wake_up_process(rescuer->task);
 	}
 
-- 
1.8.1.4

