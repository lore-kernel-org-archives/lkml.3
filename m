Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaFFMSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:18:30 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:33037 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaFFMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:18:29 -0400
Date: Fri, 6 Jun 2014 14:18:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes for v3.15
Message-ID: <20140606121824.GA8951@gmail.com>
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

   # HEAD: 09dc4ab03936df5c5aa711d27c81283c6d09f495 sched/fair: Fix tg_set_cfs_bandwidth() deadlock on rq->lock

Four misc fixes: each was deemed serious enough to warrant v3.15 
inclusion.

 Thanks,

	Ingo

------------------>
Kirill Tkhai (1):
      sched/dl: Fix race in dl_task_timer()

Richard Weinberger (1):
      sched: Fix sched_policy < 0 comparison

Roman Gushchin (1):
      sched/fair: Fix tg_set_cfs_bandwidth() deadlock on rq->lock

Steven Rostedt (1):
      sched/numa: Fix use of spin_{un}lock_irq() when interrupts are disabled


 kernel/sched/core.c     |  5 ++---
 kernel/sched/deadline.c | 10 +++++++++-
 kernel/sched/fair.c     | 15 ++++++++-------
 kernel/sched/sched.h    |  2 +-
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 86f3890..f3f48e7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3685,7 +3685,7 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr,
 	if (retval)
 		return retval;
 
-	if (attr.sched_policy < 0)
+	if ((int)attr.sched_policy < 0)
 		return -EINVAL;
 
 	rcu_read_lock();
@@ -7751,8 +7751,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	/* restart the period timer (if active) to handle new period expiry */
 	if (runtime_enabled && cfs_b->timer_active) {
 		/* force a reprogram */
-		cfs_b->timer_active = 0;
-		__start_cfs_bandwidth(cfs_b);
+		__start_cfs_bandwidth(cfs_b, true);
 	}
 	raw_spin_unlock_irq(&cfs_b->lock);
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 800e99b..14bc348 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -513,9 +513,17 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 						     struct sched_dl_entity,
 						     dl_timer);
 	struct task_struct *p = dl_task_of(dl_se);
-	struct rq *rq = task_rq(p);
+	struct rq *rq;
+again:
+	rq = task_rq(p);
 	raw_spin_lock(&rq->lock);
 
+	if (rq != task_rq(p)) {
+		/* Task was moved, retrying. */
+		raw_spin_unlock(&rq->lock);
+		goto again;
+	}
+
 	/*
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0fdb96d..8cbe2d2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1707,18 +1707,19 @@ no_join:
 void task_numa_free(struct task_struct *p)
 {
 	struct numa_group *grp = p->numa_group;
-	int i;
 	void *numa_faults = p->numa_faults_memory;
+	unsigned long flags;
+	int i;
 
 	if (grp) {
-		spin_lock_irq(&grp->lock);
+		spin_lock_irqsave(&grp->lock, flags);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
 			grp->faults[i] -= p->numa_faults_memory[i];
 		grp->total_faults -= p->total_numa_faults;
 
 		list_del(&p->numa_entry);
 		grp->nr_tasks--;
-		spin_unlock_irq(&grp->lock);
+		spin_unlock_irqrestore(&grp->lock, flags);
 		rcu_assign_pointer(p->numa_group, NULL);
 		put_numa_group(grp);
 	}
@@ -3129,7 +3130,7 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 		 */
 		if (!cfs_b->timer_active) {
 			__refill_cfs_bandwidth_runtime(cfs_b);
-			__start_cfs_bandwidth(cfs_b);
+			__start_cfs_bandwidth(cfs_b, false);
 		}
 
 		if (cfs_b->runtime > 0) {
@@ -3308,7 +3309,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	if (!cfs_b->timer_active)
-		__start_cfs_bandwidth(cfs_b);
+		__start_cfs_bandwidth(cfs_b, false);
 	raw_spin_unlock(&cfs_b->lock);
 }
 
@@ -3690,7 +3691,7 @@ static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 }
 
 /* requires cfs_b->lock, may release to reprogram timer */
-void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
+void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b, bool force)
 {
 	/*
 	 * The timer may be active because we're trying to set a new bandwidth
@@ -3705,7 +3706,7 @@ void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 		cpu_relax();
 		raw_spin_lock(&cfs_b->lock);
 		/* if someone else restarted the timer then we're done */
-		if (cfs_b->timer_active)
+		if (!force && cfs_b->timer_active)
 			return;
 	}
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 456e492..369b4d6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -278,7 +278,7 @@ extern void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 
 extern void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b);
-extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b);
+extern void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b, bool force);
 extern void unthrottle_cfs_rq(struct cfs_rq *cfs_rq);
 
 extern void free_rt_sched_group(struct task_group *tg);
