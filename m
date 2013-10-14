Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3JNKsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:48:30 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:50057 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3JNKok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:44:40 -0400
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org, tglx@linutronix.de
Cc: mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: [PATCH 12/14] sched: make dl_bw a sub-quota of rt_bw
Date: Mon, 14 Oct 2013 12:43:44 +0200
Message-Id: <1381747426-31334-13-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change real-time bandwidth management as to make dl_bw a sub-quota
of rt_bw. This patch leaves rt_bw at its default value and sets
dl_bw at 40% of rt_bw. It also remove sched_dl_period_us control
knob using sched_rt_period_us as common period for both rt_bw and
dl_bw.

Checks are made when the user tries to change dl_bw sub-quota as to
not fall below what currently used. Since dl_bw now depends upon
rt_bw, similar checks are performed when the users modifies rt_bw
and dl_bw is changed accordingly. Setting rt_bw sysctl variable to
-1 (actually disabling rt throttling) disables dl_bw checks as well.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 include/linux/sched/sysctl.h |    2 -
 kernel/sched/core.c          |  285 ++++++++++++++++++++----------------------
 kernel/sched/deadline.c      |    5 +-
 kernel/sched/sched.h         |   24 ++--
 kernel/sysctl.c              |    7 --
 5 files changed, 147 insertions(+), 176 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 33fbf32..444a257 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -86,10 +86,8 @@ extern int sysctl_sched_rt_runtime;
 /*
  *  control SCHED_DEADLINE reservations:
  *
- *  /proc/sys/kernel/sched_dl_period_us
  *  /proc/sys/kernel/sched_dl_runtime_us
  */
-extern unsigned int sysctl_sched_dl_period;
 extern int sysctl_sched_dl_runtime;
 
 #ifdef CONFIG_CFS_BANDWIDTH
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ee0ba8b..ddc1f49 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -297,13 +297,12 @@ __read_mostly int scheduler_running;
 int sysctl_sched_rt_runtime = 950000;
 
 /*
- * Maximum bandwidth available for all -deadline tasks and groups
- * (if group scheduling is configured) on each CPU.
+ * Sub-quota or rt bandwidth available for all -deadline tasks
+ * on each CPU.
  *
- * default: 5%
+ * default: 40%
  */
-unsigned int sysctl_sched_dl_period = 1000000;
-int sysctl_sched_dl_runtime = 50000;
+int sysctl_sched_dl_runtime = 400000;
 
 
 
@@ -6816,6 +6815,8 @@ LIST_HEAD(task_groups);
 
 DECLARE_PER_CPU(cpumask_var_t, load_balance_mask);
 
+static u64 actual_dl_runtime(void);
+
 void __init sched_init(void)
 {
 	int i, j;
@@ -6863,8 +6864,7 @@ void __init sched_init(void)
 
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
-	init_dl_bandwidth(&def_dl_bandwidth,
-			global_dl_period(), global_dl_runtime());
+	init_dl_bandwidth(&def_dl_bandwidth, actual_dl_runtime());
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	init_rt_bandwidth(&root_task_group.rt_bandwidth,
@@ -7264,6 +7264,93 @@ void sched_move_task(struct task_struct *tsk)
 }
 #endif /* CONFIG_CGROUP_SCHED */
 
+static u64 actual_dl_runtime(void)
+{
+	u64 dl_runtime = global_dl_runtime();
+	u64 rt_runtime = global_rt_runtime();
+	u64 period = global_rt_period();
+
+	/*
+	 * We want to calculate the sub-quota of rt_bw actually available
+	 * for -dl tasks. It is a percentage of percentage. By default 95%
+	 * of system bandwidth is allocate to -rt tasks; among this, a 40%
+	 * quota is reserved for -dl tasks. To have the actual quota a simple
+	 * multiplication is needed: .95 * .40 = .38 (38% of system bandwidth
+	 * for deadline tasks).
+	 * What follows is basically the same, but using unsigned integers.
+	 *
+	 *                   dl_runtime   rt_runtime
+	 * actual_runtime =  ---------- * ---------- * period
+	 *                     period       period
+	 */
+	if (dl_runtime == RUNTIME_INF)
+		return RUNTIME_INF;
+
+	return div64_u64 (dl_runtime * rt_runtime, period);
+}
+
+static int check_dl_bw(void)
+{
+	int i;
+	u64 period = global_rt_period();
+	u64 dl_actual_runtime = def_dl_bandwidth.dl_runtime;
+	u64 new_bw = to_ratio(period, dl_actual_runtime);
+
+	/*
+	 * Here we want to check the bandwidth not being set to some
+	 * value smaller than the currently allocated bandwidth in
+	 * any of the root_domains.
+	 *
+	 * FIXME: Cycling on all the CPUs is overdoing, but simpler than
+	 * cycling on root_domains... Discussion on different/better
+	 * solutions is welcome!
+	 */
+	for_each_possible_cpu(i) {
+#ifdef CONFIG_SMP
+		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
+#else
+		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
+#endif
+		raw_spin_lock(&dl_b->lock);
+		if (new_bw < dl_b->total_bw) {
+			raw_spin_unlock(&dl_b->lock);
+			return -EBUSY;
+		}
+		raw_spin_unlock(&dl_b->lock);
+	}
+
+	return 0;
+}
+
+static void update_dl_bw(void)
+{
+	u64 new_bw;
+	int i;
+
+	def_dl_bandwidth.dl_runtime = actual_dl_runtime();
+	if (def_dl_bandwidth.dl_runtime == RUNTIME_INF ||
+	    global_rt_runtime() == RUNTIME_INF)
+		new_bw = -1;
+	else {
+		new_bw = to_ratio(global_rt_period(),
+				  def_dl_bandwidth.dl_runtime);
+	}
+	/*
+	 * FIXME: As above...
+	 */
+	for_each_possible_cpu(i) {
+#ifdef CONFIG_SMP
+		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
+#else
+		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
+#endif
+
+		raw_spin_lock(&dl_b->lock);
+		dl_b->bw = new_bw;
+		raw_spin_unlock(&dl_b->lock);
+	}
+}
+
 #ifdef CONFIG_RT_GROUP_SCHED
 /*
  * Ensure that the real time constraints are schedulable.
@@ -7437,48 +7524,10 @@ static long sched_group_rt_period(struct task_group *tg)
 	do_div(rt_period_us, NSEC_PER_USEC);
 	return rt_period_us;
 }
-#endif /* CONFIG_RT_GROUP_SCHED */
 
-/*
- * Coupling of -rt and -deadline bandwidth.
- *
- * Here we check if the new -rt bandwidth value is consistent
- * with the system settings for the bandwidth available
- * to -deadline tasks.
- *
- * IOW, we want to enforce that
- *
- *   rt_bandwidth + dl_bandwidth <= 100%
- *
- * is always true.
- */
-static bool __sched_rt_dl_global_constraints(u64 rt_bw)
-{
-	unsigned long flags;
-	u64 dl_bw;
-	bool ret;
-
-	raw_spin_lock_irqsave(&def_dl_bandwidth.dl_runtime_lock, flags);
-	if (global_rt_runtime() == RUNTIME_INF ||
-	    global_dl_runtime() == RUNTIME_INF) {
-		ret = true;
-		goto unlock;
-	}
-
-	dl_bw = to_ratio(def_dl_bandwidth.dl_period,
-			 def_dl_bandwidth.dl_runtime);
-
-	ret = rt_bw + dl_bw <= to_ratio(RUNTIME_INF, RUNTIME_INF);
-unlock:
-	raw_spin_unlock_irqrestore(&def_dl_bandwidth.dl_runtime_lock, flags);
-
-	return ret;
-}
-
-#ifdef CONFIG_RT_GROUP_SCHED
 static int sched_rt_global_constraints(void)
 {
-	u64 runtime, period, bw;
+	u64 runtime, period;
 	int ret = 0;
 
 	if (sysctl_sched_rt_period <= 0)
@@ -7493,9 +7542,13 @@ static int sched_rt_global_constraints(void)
 	if (runtime > period && runtime != RUNTIME_INF)
 		return -EINVAL;
 
-	bw = to_ratio(period, runtime);
-	if (!__sched_rt_dl_global_constraints(bw))
-		return -EINVAL;
+	/*
+	 * Check if changing rt_bw could have negative effects
+	 * on dl_bw
+	 */
+	ret = check_dl_bw();
+	if (ret)
+		return ret;
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
@@ -7519,18 +7572,27 @@ static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 static int sched_rt_global_constraints(void)
 {
 	unsigned long flags;
-	int i, ret = 0;
-	u64 bw;
+	int i, ret;
 
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
+	/*
+	 * There's always some RT tasks in the root group
+	 * -- migration, kstopmachine etc..
+	 */
+	if (sysctl_sched_rt_runtime == 0)
+		return -EBUSY;
+
+	/*
+	 * Check if changing rt_bw could have negative effects
+	 * on dl_bw
+	 */
+	ret = check_dl_bw();
+	if (ret)
+		return ret;
+
 	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
-	bw = to_ratio(global_rt_period(), global_rt_runtime());
-	if (!__sched_rt_dl_global_constraints(bw)) {
-		ret = -EINVAL;
-		goto unlock;
-	}
 
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
@@ -7539,48 +7601,12 @@ static int sched_rt_global_constraints(void)
 		rt_rq->rt_runtime = global_rt_runtime();
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
-unlock:
 	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
 
-	return ret;
+	return 0;
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-/*
- * Coupling of -dl and -rt bandwidth.
- *
- * Here we check, while setting the system wide bandwidth available
- * for -dl tasks and groups, if the new values are consistent with
- * the system settings for the bandwidth available to -rt entities.
- *
- * IOW, we want to enforce that
- *
- *   rt_bandwidth + dl_bandwidth <= 100%
- *
- * is always true.
- */
-static bool __sched_dl_rt_global_constraints(u64 dl_bw)
-{
-	u64 rt_bw;
-	bool ret;
-
-	raw_spin_lock(&def_rt_bandwidth.rt_runtime_lock);
-	if (global_dl_runtime() == RUNTIME_INF ||
-	    global_rt_runtime() == RUNTIME_INF) {
-		ret = true;
-		goto unlock;
-	}
-
-	rt_bw = to_ratio(ktime_to_ns(def_rt_bandwidth.rt_period),
-			 def_rt_bandwidth.rt_runtime);
-
-	ret = rt_bw + dl_bw <= to_ratio(RUNTIME_INF, RUNTIME_INF);
-unlock:
-	raw_spin_unlock(&def_rt_bandwidth.rt_runtime_lock);
-
-	return ret;
-}
-
 static bool __sched_dl_global_constraints(u64 runtime, u64 period)
 {
 	if (!period || (runtime != RUNTIME_INF && runtime > period))
@@ -7591,40 +7617,17 @@ static bool __sched_dl_global_constraints(u64 runtime, u64 period)
 
 static int sched_dl_global_constraints(void)
 {
-	u64 runtime = global_dl_runtime();
-	u64 period = global_dl_period();
-	u64 new_bw = to_ratio(period, runtime);
-	int ret, i;
+	u64 period = global_rt_period();
+	u64 dl_actual_runtime = def_dl_bandwidth.dl_runtime;
+	int ret;
 
-	ret = __sched_dl_global_constraints(runtime, period);
+	ret = __sched_dl_global_constraints(dl_actual_runtime, period);
 	if (ret)
 		return ret;
 
-	if (!__sched_dl_rt_global_constraints(new_bw))
-		return -EINVAL;
-
-	/*
-	 * Here we want to check the bandwidth not being set to some
-	 * value smaller than the currently allocated bandwidth in
-	 * any of the root_domains.
-	 *
-	 * FIXME: Cycling on all the CPUs is overdoing, but simpler than
-	 * cycling on root_domains... Discussion on different/better
-	 * solutions is welcome!
-	 */
-	for_each_possible_cpu(i) {
-#ifdef CONFIG_SMP
-		struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
-#else
-		struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
-#endif
-		raw_spin_lock(&dl_b->lock);
-		if (new_bw < dl_b->total_bw) {
-			raw_spin_unlock(&dl_b->lock);
-			return -EBUSY;
-		}
-		raw_spin_unlock(&dl_b->lock);
-	}
+	ret = check_dl_bw();
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -7655,6 +7658,7 @@ int sched_rt_handler(struct ctl_table *table, int write,
 	int ret;
 	int old_period, old_runtime;
 	static DEFINE_MUTEX(mutex);
+	unsigned long flags;
 
 	mutex_lock(&mutex);
 	old_period = sysctl_sched_rt_period;
@@ -7664,6 +7668,8 @@ int sched_rt_handler(struct ctl_table *table, int write,
 
 	if (!ret && write) {
 		ret = sched_rt_global_constraints();
+		raw_spin_lock_irqsave(&def_dl_bandwidth.dl_runtime_lock,
+				      flags);
 		if (ret) {
 			sysctl_sched_rt_period = old_period;
 			sysctl_sched_rt_runtime = old_runtime;
@@ -7671,7 +7677,11 @@ int sched_rt_handler(struct ctl_table *table, int write,
 			def_rt_bandwidth.rt_runtime = global_rt_runtime();
 			def_rt_bandwidth.rt_period =
 				ns_to_ktime(global_rt_period());
+
+			update_dl_bw();
 		}
+		raw_spin_unlock_irqrestore(&def_dl_bandwidth.dl_runtime_lock,
+					   flags);
 	}
 	mutex_unlock(&mutex);
 
@@ -7683,12 +7693,11 @@ int sched_dl_handler(struct ctl_table *table, int write,
 		loff_t *ppos)
 {
 	int ret;
-	int old_period, old_runtime;
+	int old_runtime;
 	static DEFINE_MUTEX(mutex);
 	unsigned long flags;
 
 	mutex_lock(&mutex);
-	old_period = sysctl_sched_dl_period;
 	old_runtime = sysctl_sched_dl_runtime;
 
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
@@ -7699,33 +7708,9 @@ int sched_dl_handler(struct ctl_table *table, int write,
 
 		ret = sched_dl_global_constraints();
 		if (ret) {
-			sysctl_sched_dl_period = old_period;
 			sysctl_sched_dl_runtime = old_runtime;
 		} else {
-			u64 new_bw;
-			int i;
-
-			def_dl_bandwidth.dl_period = global_dl_period();
-			def_dl_bandwidth.dl_runtime = global_dl_runtime();
-			if (global_dl_runtime() == RUNTIME_INF)
-				new_bw = -1;
-			else
-				new_bw = to_ratio(global_dl_period(),
-						  global_dl_runtime());
-			/*
-			 * FIXME: As above...
-			 */
-			for_each_possible_cpu(i) {
-#ifdef CONFIG_SMP
-				struct dl_bw *dl_b = &cpu_rq(i)->rd->dl_bw;
-#else
-				struct dl_bw *dl_b = &cpu_rq(i)->dl.dl_bw;
-#endif
-
-				raw_spin_lock(&dl_b->lock);
-				dl_b->bw = new_bw;
-				raw_spin_unlock(&dl_b->lock);
-			}
+			update_dl_bw();
 		}
 
 		raw_spin_unlock_irqrestore(&def_dl_bandwidth.dl_runtime_lock,
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 35d7c2d..ca20110 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -48,10 +48,9 @@ static inline int is_leftmost(struct task_struct *p, struct dl_rq *dl_rq)
 	return dl_rq->rb_leftmost == &dl_se->rb_node;
 }
 
-void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime)
+void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 runtime)
 {
 	raw_spin_lock_init(&dl_b->dl_runtime_lock);
-	dl_b->dl_period = period;
 	dl_b->dl_runtime = runtime;
 }
 
@@ -64,7 +63,7 @@ void init_dl_bw(struct dl_bw *dl_b)
 	if (global_dl_runtime() == RUNTIME_INF)
 		dl_b->bw = -1;
 	else
-		dl_b->bw = to_ratio(global_dl_period(), global_dl_runtime());
+		dl_b->bw = to_ratio(global_rt_period(), global_dl_runtime());
 	raw_spin_unlock(&def_dl_bandwidth.dl_runtime_lock);
 	dl_b->total_bw = 0;
 }
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 08931a6..bf4acf8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -142,20 +142,20 @@ struct rt_bandwidth {
 	struct hrtimer		rt_period_timer;
 };
 /*
- * To keep the bandwidth of -deadline tasks and groups under control
- * we need some place where:
- *  - store the maximum -deadline bandwidth of the system (the group);
+ * To keep the bandwidth of -deadline tasks under control we need some
+ * place where:
+ *  - store the maximum -deadline bandwidth of the system;
  *  - cache the fraction of that bandwidth that is currently allocated.
  *
  * This is all done in the data structure below. It is similar to the
  * one used for RT-throttling (rt_bandwidth), with the main difference
  * that, since here we are only interested in admission control, we
- * do not decrease any runtime while the group "executes", neither we
+ * do not decrease any runtime while the task "executes", neither we
  * need a timer to replenish it.
  *
  * With respect to SMP, the bandwidth is given on a per-CPU basis,
  * meaning that:
- *  - dl_bw (< 100%) is the bandwidth of the system (group) on each CPU;
+ *  - dl_bw (< 100%) is the bandwidth of the system on each CPU;
  *  - dl_total_bw array contains, in the i-eth element, the currently
  *    allocated bandwidth on the i-eth CPU.
  * Moreover, groups consume bandwidth on each CPU, while tasks only
@@ -168,7 +168,6 @@ struct rt_bandwidth {
 struct dl_bandwidth {
 	raw_spinlock_t dl_runtime_lock;
 	u64 dl_runtime;
-	u64 dl_period;
 };
 
 static inline int dl_bandwidth_enabled(void)
@@ -178,10 +177,12 @@ static inline int dl_bandwidth_enabled(void)
 
 struct dl_bw {
 	raw_spinlock_t lock;
-	u64 bw, total_bw;
+	/* default value */
+	u64 bw;
+	/* allocated */
+	u64 total_bw;
 };
 
-static inline u64 global_dl_period(void);
 static inline u64 global_dl_runtime(void);
 
 extern struct mutex sched_domains_mutex;
@@ -924,11 +925,6 @@ static inline u64 global_rt_runtime(void)
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-static inline u64 global_dl_period(void)
-{
-	return (u64)sysctl_sched_dl_period * NSEC_PER_USEC;
-}
-
 static inline u64 global_dl_runtime(void)
 {
 	if (sysctl_sched_dl_runtime < 0)
@@ -1192,7 +1188,7 @@ extern struct rt_bandwidth def_rt_bandwidth;
 extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime);
 
 extern struct dl_bandwidth def_dl_bandwidth;
-extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
+extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 runtime);
 extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
 
 unsigned long to_ratio(u64 period, u64 runtime);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f0cf6d6..8159e7e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -415,13 +415,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= sched_rr_handler,
 	},
 	{
-		.procname	= "sched_dl_period_us",
-		.data		= &sysctl_sched_dl_period,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sched_dl_handler,
-	},
-	{
 		.procname	= "sched_dl_runtime_us",
 		.data		= &sysctl_sched_dl_runtime,
 		.maxlen		= sizeof(int),
-- 
1.7.9.5

