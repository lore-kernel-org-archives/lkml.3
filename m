Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaIDQcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:32:42 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:35883 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754456AbaIDQbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:20 -0400
X-Yandex-Uniq: b78d68c9-2102-4b16-a233-54620cb24670
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 09/19] smart: throttle CFS tasks by affinning to first SMT thread
Date: Thu,  4 Sep 2014 20:30:55 +0400
Message-Id: <1409848265-17150-9-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

Normal ("CFS") tasks can affect the performance of rt tasks by loading
other SMT threads on the same core. If we want to have a guaranteed
performance for rt tasks, it's unacceptable.
So, this patch denies enqueuing of CFS tasks if there are running rt
tasks on the same core.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/fair.c  | 25 ++++++++++++++++++++-----
 kernel/sched/rt.c    |  4 ++++
 kernel/sched/sched.h | 21 +++++++++++++++++++++
 kernel/sysctl.c      |  4 ++++
 4 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7ab8ea..629aa0d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3285,6 +3285,9 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 
 	/* Traverse only the allowed CPUs */
 	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
+		if (!cpu_allowed_for_cfs(i))
+			continue;
+
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -3305,13 +3308,14 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	struct sched_group *sg;
 	int i = task_cpu(p);
 
-	if (idle_cpu(target))
+	if (idle_cpu(target) && cpu_allowed_for_cfs(target))
 		return target;
 
 	/*
 	 * If the prevous cpu is cache affine and idle, don't be stupid.
 	 */
-	if (i != target && cpus_share_cache(i, target) && idle_cpu(i))
+	if (i != target && cpus_share_cache(i, target) && idle_cpu(i) &&
+	    cpu_allowed_for_cfs(i))
 		return i;
 
 	/*
@@ -3326,12 +3330,15 @@ static int select_idle_sibling(struct task_struct *p, int target)
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (i == target || !idle_cpu(i))
+				if (i == target || !idle_cpu(i) ||
+				    !cpu_allowed_for_cfs(i))
 					goto next;
 			}
 
 			target = cpumask_first_and(sched_group_cpus(sg),
 					tsk_cpus_allowed(p));
+			if (!cpu_allowed_for_cfs(target))
+				goto next;
 			goto done;
 next:
 			sg = sg->next;
@@ -3366,7 +3373,8 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 		return prev_cpu;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
+		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)) &&
+		    cpu_allowed_for_cfs(cpu))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
@@ -3931,6 +3939,9 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
 		return 0;
 
+	if (!cpu_allowed_for_cfs(env->dst_cpu))
+		return 0;
+
 	if (!cpumask_test_cpu(env->dst_cpu, tsk_cpus_allowed(p))) {
 		int cpu;
 
@@ -5191,7 +5202,8 @@ more_balance:
 			 * moved to this_cpu
 			 */
 			if (!cpumask_test_cpu(this_cpu,
-					tsk_cpus_allowed(busiest->curr))) {
+					tsk_cpus_allowed(busiest->curr)) ||
+			    !cpu_allowed_for_cfs(this_cpu)) {
 				raw_spin_unlock_irqrestore(&busiest->lock,
 							    flags);
 				env.flags |= LBF_ALL_PINNED;
@@ -5270,6 +5282,9 @@ void idle_balance(int this_cpu, struct rq *this_rq)
 
 	this_rq->idle_stamp = this_rq->clock;
 
+	if (!cpu_allowed_for_cfs(this_cpu))
+		return;
+
 	if (this_rq->avg_idle < sysctl_sched_migration_cost)
 		return;
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7ef0fd0..8621443 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1436,7 +1436,11 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	if (!rt_rq->rt_nr_running)
 		return NULL;
 
+#ifdef CONFIG_SMART
+	if (rt_rq_throttled(rt_rq) && rq->cfs.h_nr_running)
+#else
 	if (rt_rq_throttled(rt_rq))
+#endif
 		return NULL;
 
 	do {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 463fdbe..c7c1cdc 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1396,6 +1396,7 @@ struct smart_node_data {
 
 extern struct static_key __smart_initialized;
 extern struct static_key __smart_enabled;
+extern struct static_key smart_cfs_throttle;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(struct smart_core_data, smart_core_data);
 extern struct smart_node_data smart_node_data[MAX_NUMNODES];
@@ -1454,6 +1455,21 @@ static inline int node_running(int node)
 	return atomic_read(&smart_node_data[node].nr_rt_running);
 }
 
+static inline bool cpu_allowed_for_cfs(int cpu)
+{
+	struct rq *rq;
+	int core = cpu_core_id(cpu);
+
+	if (!smart_enabled() || !static_key_true(&smart_cfs_throttle))
+		return true;
+
+	if (cpu == core)
+		return true;
+
+	rq = cpu_rq(core);
+	return (!rq->rt.rt_nr_running || rq->rt.rt_throttled);
+}
+
 static inline int core_is_rt_free(int core)
 {
 	struct rq *rq;
@@ -1599,4 +1615,9 @@ static inline void reset_smart_score(struct sched_rt_entity *rt_se)
 {
 }
 
+static inline bool cpu_allowed_for_cfs(int cpu)
+{
+	return true;
+}
+
 #endif /* CONFIG_SMART */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9469f4c..7ee22ef 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -175,6 +175,10 @@ extern int unaligned_dump_stack;
 extern int no_unaligned_warning;
 #endif
 
+#ifdef CONFIG_SMART
+struct static_key smart_cfs_throttle = STATIC_KEY_INIT_TRUE;
+#endif
+
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
-- 
1.9.3

