Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3LBPaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:30:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45790 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3LBPaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:30:03 -0500
Date: Mon, 2 Dec 2013 16:29:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org
Cc: Tejun Heo <htejun@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sched: Revert 14a40ffccd61 ("sched: replace PF_THREAD_BOUND
 with PF_NO_SETAFFINITY")
Message-ID: <20131202152956.GI16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Revert 14a40ffccd61 ("sched: replace PF_THREAD_BOUND with PF_NO_SETAFFINITY")

PF_NO_SETAFFINITY, which crudely turns off affinity control and cgroups
access to tasks, and which is in use by every workqueue thread in Linux (!),
is conceptually wrong on many levels:

 - We should strive to never consciously place artificial limitations on
   kernel functionality; our main reason to place limitations should be
   correctness.

   There are cases where limiting affinity is justified: for example the
   case of single cpu workqueue threads, which are special for their
   limited concurrency, esp. when coupled with per-cpu resources --
   allowing such threads to run on other cpus is a correctness violation
   and can crash the kernel.

 - But using it outside this case is overly broad; it dis-allows usage
   that is functionally fine and in some cases desired.

   In particular; tj argues ( http://lkml.kernel.org/r/20131128143848.GD3925@htj.dyndns.org )

   "That's just inviting people to do weirdest things and then
   reporting things like "crypt jobs on some of our 500 machines end up
   stuck on a single cpu once in a while" which will eventually be
   tracked down to some weird shell script setting affinity on workers
   doing something else."

   While that is exactly what HPC/RT people _want_ in order to avoid
   disturbing the other CPUs with said crypt work.

 - Furthermore, the above example is also wrong in that you should not
   protect root from itself; there's plenty root can do to shoot his
   own foot off, let alone shoot his head off.

   Setting affinities is limited to root, and if root messes up the
   system he can keep the pieces. But limiting in an overly broad
   fashion stifles the functionality of the system.

 - Lastly; the flag actually blocks entry into cgroups as well as
   sched_setaffinity(), so the name is misleading at best.

The right fix is to only set PF_THREAD_BOUND on per-cpu workers:

 --- a/kernel/workqueue.c
 +++ b/kernel/workqueue.c

         set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);

 -       /* prevent userland from meddling with cpumask of workqueue workers */
 -       worker->task->flags |= PF_NO_SETAFFINITY;
 -
         /*
          * The caller is responsible for ensuring %POOL_DISASSOCIATED
          * remains stable across this function.  See the comments above the
          * flag definition for details.
          */
 -       if (pool->flags & POOL_DISASSOCIATED)
 +       if (pool->flags & POOL_DISASSOCIATED) {
                 worker->flags |= WORKER_UNBOUND;
 +       } else {
 +               /*
 +                * Prevent userland from meddling with cpumask of workqueue
 +                * workers:
 +                */
 +               worker->task->flags |= PF_THREAD_BOUND;
 +       }

Therefore revert the patch and add an annoying but non-destructive warning
check against abuse.

Cc: Tejun Heo <htejun@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/sched.h |  2 +-
 kernel/cgroup.c       |  4 ++--
 kernel/cpuset.c       |  2 +-
 kernel/kthread.c      |  2 +-
 kernel/reboot.c       |  2 +-
 kernel/sched/core.c   | 18 +++++++++++++++++-
 kernel/workqueue.c    |  4 ++--
 7 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 768b037dfacb..ecf29700f4db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1693,7 +1693,7 @@ extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut,
 #define PF_SWAPWRITE	0x00800000	/* Allowed to write to swap */
 #define PF_SPREAD_PAGE	0x01000000	/* Spread page cache over cpuset */
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
-#define PF_NO_SETAFFINITY 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
+#define PF_THREAD_BOUND 0x04000000	/* Userland is not allowed to meddle with cpus_allowed */
 #define PF_MCE_EARLY    0x08000000      /* Early kill for mce process policy */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4c62513fe19f..b0f88306955e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2151,11 +2151,11 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 		tsk = tsk->group_leader;
 
 	/*
-	 * Workqueue threads may acquire PF_NO_SETAFFINITY and become
+	 * Workqueue threads may acquire PF_THREAD_BOUND and become
 	 * trapped in a cpuset, or RT worker may be born in a cgroup
 	 * with no rt_runtime allocated.  Just say no.
 	 */
-	if (tsk == kthreadd_task || (tsk->flags & PF_NO_SETAFFINITY)) {
+	if (tsk == kthreadd_task || (tsk->flags & PF_THREAD_BOUND)) {
 		ret = -EINVAL;
 		rcu_read_unlock();
 		goto out_unlock_cgroup;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 6bf981e13c43..aa9b4ac9fc28 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1475,7 +1475,7 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 		 * before cpus_allowed may be changed.
 		 */
 		ret = -EINVAL;
-		if (task->flags & PF_NO_SETAFFINITY)
+		if (task->flags & PF_THREAD_BOUND)
 			goto out_unlock;
 		ret = security_task_setscheduler(task);
 		if (ret)
diff --git a/kernel/kthread.c b/kernel/kthread.c
index b5ae3ee860a9..626dbba190c8 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -334,7 +334,7 @@ static void __kthread_bind(struct task_struct *p, unsigned int cpu, long state)
 	}
 	/* It's safe because the task is inactive. */
 	do_set_cpus_allowed(p, cpumask_of(cpu));
-	p->flags |= PF_NO_SETAFFINITY;
+	p->flags |= PF_THREAD_BOUND;
 }
 
 /**
diff --git a/kernel/reboot.c b/kernel/reboot.c
index f813b3474646..de0911160e5a 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -116,7 +116,7 @@ static void migrate_to_reboot_cpu(void)
 		cpu = cpumask_first(cpu_online_mask);
 
 	/* Prevent races with other tasks migrating this task */
-	current->flags |= PF_NO_SETAFFINITY;
+	current->flags |= PF_THREAD_BOUND;
 
 	/* Make certain I only run on the appropriate processor */
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 718730dd0480..37f544ef95a7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2407,6 +2407,18 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
 }
 
+static noinline void __schedule_bound_bug(struct task_struct *prev)
+{
+	if (oops_in_progress)
+		return;
+
+	printk(KERN_ERR "BUG: PF_THREAD_BOUND set on an unbound thread: %s/%d\n",
+			prev->comm, prev->pid);
+
+	prev->flags &= ~PF_THREAD_BOUND;
+	add_taint(TAINT_WARN, LOCKDEP_STILL_OK);
+}
+
 /*
  * Various schedule()-time debugging checks and statistics:
  */
@@ -2421,6 +2433,10 @@ static inline void schedule_debug(struct task_struct *prev)
 		__schedule_bug(prev);
 	rcu_sleep_check();
 
+	if (unlikely((prev->flags & PF_THREAD_BOUND) && 
+		     prev->nr_cpus_allowed != 1))
+		__schedule_bound_bug(prev);
+
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
 	schedstat_inc(this_rq(), sched_count);
@@ -3350,7 +3366,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	get_task_struct(p);
 	rcu_read_unlock();
 
-	if (p->flags & PF_NO_SETAFFINITY) {
+	if (p->flags & PF_THREAD_BOUND) {
 		retval = -EINVAL;
 		goto out_put_task;
 	}
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d03ebc..89314c0b3285 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1744,7 +1744,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
 	/* prevent userland from meddling with cpumask of workqueue workers */
-	worker->task->flags |= PF_NO_SETAFFINITY;
+	worker->task->flags |= PF_THREAD_BOUND;
 
 	/*
 	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
@@ -4215,7 +4215,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		}
 
 		wq->rescuer = rescuer;
-		rescuer->task->flags |= PF_NO_SETAFFINITY;
+		rescuer->task->flags |= PF_THREAD_BOUND;
 		wake_up_process(rescuer->task);
 	}
 
