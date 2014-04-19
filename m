Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaDSKz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 06:55:58 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62697 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaDSKz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 06:55:56 -0400
Date: Sat, 19 Apr 2014 12:55:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140419105549.GA4492@gmail.com>
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

   # HEAD: a1d9a3231eac4117cadaf4b6bba5b2902c15a33e sched: Check for stop task appearance when balancing happens

Two fixes:

 - a SCHED_DEADLINE task selection fix
 - a sched/numa related lockdep splat fix

 Thanks,

	Ingo

------------------>
Kirill Tkhai (1):
      sched: Check for stop task appearance when balancing happens

Mike Galbraith (1):
      sched/numa: Fix task_numa_free() lockdep splat


 kernel/sched/deadline.c | 11 ++++++++++-
 kernel/sched/fair.c     | 16 +++++++++-------
 kernel/sched/rt.c       |  7 ++++---
 kernel/sched/sched.h    |  9 +++++++++
 4 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 27ef409..b080957 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1021,8 +1021,17 @@ struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 
 	dl_rq = &rq->dl;
 
-	if (need_pull_dl_task(rq, prev))
+	if (need_pull_dl_task(rq, prev)) {
 		pull_dl_task(rq);
+		/*
+		 * pull_rt_task() can drop (and re-acquire) rq->lock; this
+		 * means a stop task can slip in, in which case we need to
+		 * re-start task selection.
+		 */
+		if (rq->stop && rq->stop->on_rq)
+			return RETRY_TASK;
+	}
+
 	/*
 	 * When prev is DL, we may throttle it in put_prev_task().
 	 * So, we update time before we check for dl_nr_running.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7e9bd0b..7570dd9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1497,7 +1497,7 @@ static void task_numa_placement(struct task_struct *p)
 	/* If the task is part of a group prevent parallel updates to group stats */
 	if (p->numa_group) {
 		group_lock = &p->numa_group->lock;
-		spin_lock(group_lock);
+		spin_lock_irq(group_lock);
 	}
 
 	/* Find the node with the highest number of faults */
@@ -1572,7 +1572,7 @@ static void task_numa_placement(struct task_struct *p)
 			}
 		}
 
-		spin_unlock(group_lock);
+		spin_unlock_irq(group_lock);
 	}
 
 	/* Preferred node as the node with the most faults */
@@ -1677,7 +1677,8 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	if (!join)
 		return;
 
-	double_lock(&my_grp->lock, &grp->lock);
+	BUG_ON(irqs_disabled());
+	double_lock_irq(&my_grp->lock, &grp->lock);
 
 	for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++) {
 		my_grp->faults[i] -= p->numa_faults_memory[i];
@@ -1691,7 +1692,7 @@ static void task_numa_group(struct task_struct *p, int cpupid, int flags,
 	grp->nr_tasks++;
 
 	spin_unlock(&my_grp->lock);
-	spin_unlock(&grp->lock);
+	spin_unlock_irq(&grp->lock);
 
 	rcu_assign_pointer(p->numa_group, grp);
 
@@ -1710,14 +1711,14 @@ void task_numa_free(struct task_struct *p)
 	void *numa_faults = p->numa_faults_memory;
 
 	if (grp) {
-		spin_lock(&grp->lock);
+		spin_lock_irq(&grp->lock);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
 			grp->faults[i] -= p->numa_faults_memory[i];
 		grp->total_faults -= p->total_numa_faults;
 
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
-		spin_unlock(&grp->lock);
+		spin_unlock_irq(&grp->lock);
 		rcu_assign_pointer(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
@@ -6727,7 +6728,8 @@ static int idle_balance(struct rq *this_rq)
 out:
 	/* Is there a task of a high priority class? */
 	if (this_rq->nr_running != this_rq->cfs.h_nr_running &&
-	    (this_rq->dl.dl_nr_running ||
+	    ((this_rq->stop && this_rq->stop->on_rq) ||
+	     this_rq->dl.dl_nr_running ||
 	     (this_rq->rt.rt_nr_running && !rt_rq_throttled(&this_rq->rt))))
 		pulled_task = -1;
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d8cdf16..bd2267a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1362,10 +1362,11 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 		pull_rt_task(rq);
 		/*
 		 * pull_rt_task() can drop (and re-acquire) rq->lock; this
-		 * means a dl task can slip in, in which case we need to
-		 * re-start task selection.
+		 * means a dl or stop task can slip in, in which case we need
+		 * to re-start task selection.
 		 */
-		if (unlikely(rq->dl.dl_nr_running))
+		if (unlikely((rq->stop && rq->stop->on_rq) ||
+			     rq->dl.dl_nr_running))
 			return RETRY_TASK;
 	}
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c9007f2..456e492 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1385,6 +1385,15 @@ static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
 	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
 }
 
+static inline void double_lock_irq(spinlock_t *l1, spinlock_t *l2)
+{
+	if (l1 > l2)
+		swap(l1, l2);
+
+	spin_lock_irq(l1);
+	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
+}
+
 static inline void double_raw_lock(raw_spinlock_t *l1, raw_spinlock_t *l2)
 {
 	if (l1 > l2)
