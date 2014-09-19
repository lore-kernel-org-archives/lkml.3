Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaISJXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:23:13 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40310 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaISJWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:22:40 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, juri.lelli@gmail.com, raistlin@linux.it,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        daniel.wagner@bmw-carit.de, vincent@legout.info, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@arm.com>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating tasks between exclusive cpusets
Date: Fri, 19 Sep 2014 10:22:40 +0100
Message-Id: <1411118561-26323-3-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 19 Sep 2014 09:22:35.0725 (UTC) FILETIME=[3FBE5FD0:01CFD3EB]
X-MC-Unique: 114091910223801501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s8J9NIki015349

Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
affinity (performing what is commonly called clustered scheduling).
Unfortunately, such thing is currently broken for two reasons:

 - No check is performed when the user tries to attach a task to
   an exlusive cpuset (recall that exclusive cpusets have an
   associated maximum allowed bandwidth).

 - Bandwidths of source and destination cpusets are not correctly
   updated after a task is migrated between them.

This patch fixes both things at once, as they are opposite faces
of the same coin.

The check is performed in cpuset_can_attach(), as there aren't any
points of failure after that function. The updated is split in two
halves. We first reserve bandwidth in the destination cpuset, after
we pass the check in cpuset_can_attach(). And we then release
bandwidth from the source cpuset when the task's affinity is
actually changed. Even if there can be time windows when sched_setattr()
may erroneously fail in the source cpuset, we are fine with it, as
we can't perfom an atomic update of both cpusets at once.

Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Reported-by: Vincent Legout <vincent@legout.info>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Michael Trimarchi <michael@amarulasolutions.com>
Cc: Fabio Checconi <fchecconi@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
---
 include/linux/sched.h   |  2 ++
 kernel/cpuset.c         | 13 ++-------
 kernel/sched/core.c     | 70 +++++++++++++++++++++++++++++++++++--------------
 kernel/sched/deadline.c | 25 ++++++++++++++++--
 kernel/sched/sched.h    | 19 ++++++++++++++
 5 files changed, 97 insertions(+), 32 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..3a65995 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2029,6 +2029,8 @@ static inline void tsk_restore_flags(struct task_struct *task,
 	task->flags |= orig_flags & flags;
 }
 
+extern int task_can_attach(struct task_struct *p,
+			   const struct cpumask *cs_cpus_allowed);
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p,
 			       const struct cpumask *new_mask);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 22874d7..ab9be24 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1428,17 +1428,8 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, tset) {
-		/*
-		 * Kthreads which disallow setaffinity shouldn't be moved
-		 * to a new cpuset; we don't want to change their cpu
-		 * affinity and isolating such threads by their set of
-		 * allowed nodes is unnecessary.  Thus, cpusets are not
-		 * applicable for such threads.  This prevents checking for
-		 * success of set_cpus_allowed_ptr() on all attached tasks
-		 * before cpus_allowed may be changed.
-		 */
-		ret = -EINVAL;
-		if (task->flags & PF_NO_SETAFFINITY)
+		ret = task_can_attach(task, cs->cpus_allowed);
+		if (ret)
 			goto out_unlock;
 		ret = security_task_setscheduler(task);
 		if (ret)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 581a429..092143d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2013,25 +2013,6 @@ static inline int dl_bw_cpus(int i)
 }
 #endif
 
-static inline
-void __dl_clear(struct dl_bw *dl_b, u64 tsk_bw)
-{
-	dl_b->total_bw -= tsk_bw;
-}
-
-static inline
-void __dl_add(struct dl_bw *dl_b, u64 tsk_bw)
-{
-	dl_b->total_bw += tsk_bw;
-}
-
-static inline
-bool __dl_overflow(struct dl_bw *dl_b, int cpus, u64 old_bw, u64 new_bw)
-{
-	return dl_b->bw != -1 &&
-	       dl_b->bw * cpus < dl_b->total_bw - old_bw + new_bw;
-}
-
 /*
  * We must be sure that accepting a new task (or allowing changing the
  * parameters of an existing one) is consistent with the bandwidth
@@ -4606,6 +4587,57 @@ void init_idle(struct task_struct *idle, int cpu)
 #endif
 }
 
+int task_can_attach(struct task_struct *p,
+		    const struct cpumask *cs_cpus_allowed)
+{
+	int ret = 0;
+
+	/*
+	 * Kthreads which disallow setaffinity shouldn't be moved
+	 * to a new cpuset; we don't want to change their cpu
+	 * affinity and isolating such threads by their set of
+	 * allowed nodes is unnecessary.  Thus, cpusets are not
+	 * applicable for such threads.  This prevents checking for
+	 * success of set_cpus_allowed_ptr() on all attached tasks
+	 * before cpus_allowed may be changed.
+	 */
+	if (p->flags & PF_NO_SETAFFINITY) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+#ifdef CONFIG_SMP
+	if (dl_task(p) && !cpumask_intersects(task_rq(p)->rd->span,
+					      cs_cpus_allowed)) {
+		unsigned int dest_cpu = cpumask_any_and(cpu_active_mask,
+							cs_cpus_allowed);
+		struct dl_bw *dl_b = dl_bw_of(dest_cpu);
+		bool overflow;
+		int cpus;
+		unsigned long flags;
+
+		raw_spin_lock_irqsave(&dl_b->lock, flags);
+		cpus = dl_bw_cpus(dest_cpu);
+		overflow = __dl_overflow(dl_b, cpus, 0, p->dl.dl_bw);
+		if (overflow)
+			ret = -EBUSY;
+		else {
+			/*
+			 * We reserve space for this task in the destination
+			 * root_domain, as we can't fail after this point.
+			 * We will free resources in the source root_domain
+			 * later on (see set_cpus_allowed_dl()).
+			 */
+			__dl_add(dl_b, p->dl.dl_bw);
+		}
+		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+	}
+#endif
+out:
+	return ret;
+}
+
 #ifdef CONFIG_SMP
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 4a51b14..56cb157 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1495,10 +1495,33 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 				const struct cpumask *new_mask)
 {
 	struct rq *rq;
+	struct root_domain *src_rd;
 	int weight;
 
 	BUG_ON(!dl_task(p));
 
+	rq = task_rq(p);
+	src_rd = rq->rd;
+	/*
+	 * Migrating a SCHED_DEADLINE task between exclusive
+	 * cpusets (different root_domains) entails a bandwidth
+	 * update. We already made space for us in the destination
+	 * domain (see cpuset_can_attach()).
+	 */
+	if (!cpumask_intersects(src_rd->span, new_mask)) {
+		struct dl_bw *src_dl_b;
+
+		src_dl_b = dl_bw_of(cpu_of(rq));
+		/*
+		 * We now free resources of the root_domain we are migrating
+		 * off. In the worst case, sched_setattr() may temporary fail
+		 * until we complete the update.
+		 */
+		raw_spin_lock(&src_dl_b->lock);
+		__dl_clear(src_dl_b, p->dl.dl_bw);
+		raw_spin_unlock(&src_dl_b->lock);
+	}
+
 	/*
 	 * Update only if the task is actually running (i.e.,
 	 * it is on the rq AND it is not throttled).
@@ -1515,8 +1538,6 @@ static void set_cpus_allowed_dl(struct task_struct *p,
 	if ((p->nr_cpus_allowed > 1) == (weight > 1))
 		return;
 
-	rq = task_rq(p);
-
 	/*
 	 * The process used to be able to migrate OR it can now migrate
 	 */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4890484..a0e9e81 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -171,6 +171,25 @@ struct dl_bw {
 	u64 bw, total_bw;
 };
 
+static inline
+void __dl_clear(struct dl_bw *dl_b, u64 tsk_bw)
+{
+	dl_b->total_bw -= tsk_bw;
+}
+
+static inline
+void __dl_add(struct dl_bw *dl_b, u64 tsk_bw)
+{
+	dl_b->total_bw += tsk_bw;
+}
+
+static inline
+bool __dl_overflow(struct dl_bw *dl_b, int cpus, u64 old_bw, u64 new_bw)
+{
+	return dl_b->bw != -1 &&
+	       dl_b->bw * cpus < dl_b->total_bw - old_bw + new_bw;
+}
+
 extern struct mutex sched_domains_mutex;
 
 #ifdef CONFIG_CGROUP_SCHED
-- 
2.1.0


