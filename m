Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab3IRQTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:19:47 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:41080 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3IRQTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:19:46 -0400
Date: Wed, 18 Sep 2013 18:19:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20130918161942.GA10628@gmail.com>
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

   HEAD: 13b62e46d5407c7d619aea1dc9c3e0991b631b57 sched: Fix comment for sched_info_depart

Misc fixes.

 Thanks,

	Ingo

------------------>
Daisuke Nishimura (1):
      sched/fair: Fix small race where child->se.parent,cfs_rq might point to invalid ones

Li Bin (1):
      sched/Documentation: Update sched-design-CFS.txt documentation

Michael S. Tsirkin (1):
      sched: Fix comment for sched_info_depart

Peter Zijlstra (1):
      sched/debug: Take PID namespace into account


 Documentation/scheduler/sched-design-CFS.txt |  4 +---
 kernel/sched/debug.c                         |  6 +++---
 kernel/sched/fair.c                          | 14 +++++++++-----
 kernel/sched/stats.h                         |  5 +++--
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index d529e02d..f14f493 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -66,9 +66,7 @@ rq->cfs.load value, which is the sum of the weights of the tasks queued on the
 runqueue.
 
 CFS maintains a time-ordered rbtree, where all runnable tasks are sorted by the
-p->se.vruntime key (there is a subtraction using rq->cfs.min_vruntime to
-account for possible wraparounds).  CFS picks the "leftmost" task from this
-tree and sticks to it.
+p->se.vruntime key. CFS picks the "leftmost" task from this tree and sticks to it.
 As the system progresses forwards, the executed tasks are put into the tree
 more and more to the right --- slowly but surely giving a chance for every task
 to become the "leftmost task" and thus get on the CPU within a deterministic
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e076bdd..1965599 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -124,7 +124,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 		SEQ_printf(m, " ");
 
 	SEQ_printf(m, "%15s %5d %9Ld.%06ld %9Ld %5d ",
-		p->comm, p->pid,
+		p->comm, task_pid_nr(p),
 		SPLIT_NS(p->se.vruntime),
 		(long long)(p->nvcsw + p->nivcsw),
 		p->prio);
@@ -289,7 +289,7 @@ do {									\
 	P(nr_load_updates);
 	P(nr_uninterruptible);
 	PN(next_balance);
-	P(curr->pid);
+	SEQ_printf(m, "  .%-30s: %ld\n", "curr->pid", (long)(task_pid_nr(rq->curr)));
 	PN(clock);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
@@ -492,7 +492,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 {
 	unsigned long nr_switches;
 
-	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid,
+	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, task_pid_nr(p),
 						get_nr_threads(p));
 	SEQ_printf(m,
 		"---------------------------------------------------------"
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b3fe1c..11cd136 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5928,11 +5928,15 @@ static void task_fork_fair(struct task_struct *p)
 	cfs_rq = task_cfs_rq(current);
 	curr = cfs_rq->curr;
 
-	if (unlikely(task_cpu(p) != this_cpu)) {
-		rcu_read_lock();
-		__set_task_cpu(p, this_cpu);
-		rcu_read_unlock();
-	}
+	/*
+	 * Not only the cpu but also the task_group of the parent might have
+	 * been changed after parent->se.parent,cfs_rq were copied to
+	 * child->se.parent,cfs_rq. So call __set_task_cpu() to make those
+	 * of child point to valid ones.
+	 */
+	rcu_read_lock();
+	__set_task_cpu(p, this_cpu);
+	rcu_read_unlock();
 
 	update_curr(cfs_rq);
 
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 5aef494..c7edee7 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -104,8 +104,9 @@ static inline void sched_info_queued(struct task_struct *t)
 }
 
 /*
- * Called when a process ceases being the active-running process, either
- * voluntarily or involuntarily.  Now we can calculate how long we ran.
+ * Called when a process ceases being the active-running process involuntarily
+ * due, typically, to expiring its time slice (this may also be called when
+ * switching to the idle task).  Now we can calculate how long we ran.
  * Also, if the process is still in the TASK_RUNNING state, call
  * sched_info_queued() to mark that it has now again started waiting on
  * the runqueue.
