Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaCCQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:29:16 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:59322 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbaCCQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:29:13 -0500
Date: Mon, 3 Mar 2014 17:29:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20140303162908.GA17725@gmail.com>
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

   # HEAD: faa5993736d9b44b508cab4f1f3a77d66641c6f4 sched/deadline: Prevent rt_time growth to infinity

Misc fixes, most of them SCHED_DEADLINE fallout.

 Thanks,

	Ingo

------------------>
George McCollister (1):
      sched: Fix double normalization of vruntime

Juri Lelli (2):
      sched/deadline: Switch CPU's presence test order
      sched/deadline: Prevent rt_time growth to infinity

Kirill Tkhai (1):
      sched/deadline: Cleanup RT leftovers from {inc/dec}_dl_migration


 kernel/sched/cpudeadline.c |  4 ++--
 kernel/sched/deadline.c    | 10 ++++++----
 kernel/sched/fair.c        |  8 ++++----
 kernel/sched/rt.c          |  8 ++++++++
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index 5b8838b..5b9bb42 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -70,7 +70,7 @@ static void cpudl_heapify(struct cpudl *cp, int idx)
 
 static void cpudl_change_key(struct cpudl *cp, int idx, u64 new_dl)
 {
-	WARN_ON(!cpu_present(idx) || idx == IDX_INVALID);
+	WARN_ON(idx == IDX_INVALID || !cpu_present(idx));
 
 	if (dl_time_before(new_dl, cp->elements[idx].dl)) {
 		cp->elements[idx].dl = new_dl;
@@ -117,7 +117,7 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
 	}
 
 out:
-	WARN_ON(!cpu_present(best_cpu) && best_cpu != -1);
+	WARN_ON(best_cpu != -1 && !cpu_present(best_cpu));
 
 	return best_cpu;
 }
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 15cbc17..6e79b3f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -135,7 +135,6 @@ static void update_dl_migration(struct dl_rq *dl_rq)
 static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
 	struct task_struct *p = dl_task_of(dl_se);
-	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
 
 	if (p->nr_cpus_allowed > 1)
 		dl_rq->dl_nr_migratory++;
@@ -146,7 +145,6 @@ static void inc_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 static void dec_dl_migration(struct sched_dl_entity *dl_se, struct dl_rq *dl_rq)
 {
 	struct task_struct *p = dl_task_of(dl_se);
-	dl_rq = &rq_of_dl_rq(dl_rq)->dl;
 
 	if (p->nr_cpus_allowed > 1)
 		dl_rq->dl_nr_migratory--;
@@ -564,6 +562,8 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 	return 1;
 }
 
+extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
+
 /*
  * Update the current task's runtime statistics (provided it is still
  * a -deadline task and has not been removed from the dl_rq).
@@ -627,11 +627,13 @@ static void update_curr_dl(struct rq *rq)
 		struct rt_rq *rt_rq = &rq->rt;
 
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_time += delta_exec;
 		/*
 		 * We'll let actual RT tasks worry about the overflow here, we
-		 * have our own CBS to keep us inline -- see above.
+		 * have our own CBS to keep us inline; only account when RT
+		 * bandwidth is relevant.
 		 */
+		if (sched_rt_bandwidth_account(rt_rq))
+			rt_rq->rt_time += delta_exec;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7815709..9b4c4f3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7001,15 +7001,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
 	/*
-	 * Ensure the task's vruntime is normalized, so that when its
+	 * Ensure the task's vruntime is normalized, so that when it's
 	 * switched back to the fair class the enqueue_entity(.flags=0) will
 	 * do the right thing.
 	 *
-	 * If it was on_rq, then the dequeue_entity(.flags=0) will already
-	 * have normalized the vruntime, if it was !on_rq, then only when
+	 * If it's on_rq, then the dequeue_entity(.flags=0) will already
+	 * have normalized the vruntime, if it's !on_rq, then only when
 	 * the task is sleeping will it still have non-normalized vruntime.
 	 */
-	if (!se->on_rq && p->state != TASK_RUNNING) {
+	if (!p->on_rq && p->state != TASK_RUNNING) {
 		/*
 		 * Fix up our vruntime so that the current sleep doesn't
 		 * cause 'unlimited' sleep bonus.
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a2740b7..1999021 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -538,6 +538,14 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+bool sched_rt_bandwidth_account(struct rt_rq *rt_rq)
+{
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+	return (hrtimer_active(&rt_b->rt_period_timer) ||
+		rt_rq->rt_time < rt_b->rt_runtime);
+}
+
 #ifdef CONFIG_SMP
 /*
  * We ran out of runtime, see if we can borrow some from our neighbours.
