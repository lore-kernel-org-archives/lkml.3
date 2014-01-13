Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaAMPzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:55:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaAMPzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:55:43 -0500
Date: Mon, 13 Jan 2014 07:55:09 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-zpyqbqds1r0vyxtxza1e7rdc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Remove the sysctl_sched_dl knobs
Git-Commit-ID: 1724813d9f2c7ff702b46d3e4a4f6d9b10a8f8c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:55:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1724813d9f2c7ff702b46d3e4a4f6d9b10a8f8c2
Gitweb:     http://git.kernel.org/tip/1724813d9f2c7ff702b46d3e4a4f6d9b10a8f8c2
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 17 Dec 2013 12:44:49 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:23 +0100

sched/deadline: Remove the sysctl_sched_dl knobs

Remove the deadline specific sysctls for now. The problem with them is
that the interaction with the exisiting rt knobs is nearly impossible
to get right.

The current (as per before this patch) situation is that the rt and dl
bandwidth is completely separate and we enforce rt+dl < 100%. This is
undesirable because this means that the rt default of 95% leaves us
hardly any room, even though dl tasks are saver than rt tasks.

Another proposed solution was (a discarted patch) to have the dl
bandwidth be a fraction of the rt bandwidth. This is highly
confusing imo.

Furthermore neither proposal is consistent with the situation we
actually want; which is rt tasks ran from a dl server. In which case
the rt bandwidth is a direct subset of dl.

So whichever way we go, the introduction of dl controls at this point
is painful. Therefore remove them and instead share the rt budget.

This means that for now the rt knobs are used for dl admission control
and the dl runtime is accounted against the rt runtime. I realise that
this isn't entirely desirable either; but whatever we do we appear to
need to change the interface later, so better have a small interface
for now.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-zpyqbqds1r0vyxtxza1e7rdc@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/sysctl.h |  13 ---
 kernel/sched/core.c          | 259 ++++++++++++-------------------------------
 kernel/sched/deadline.c      |  27 ++++-
 kernel/sched/sched.h         |  18 +--
 kernel/sysctl.c              |  14 ---
 5 files changed, 97 insertions(+), 234 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index 8070a83..31e0193 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -81,15 +81,6 @@ static inline unsigned int get_sysctl_timer_migration(void)
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
-/*
- *  control SCHED_DEADLINE reservations:
- *
- *  /proc/sys/kernel/sched_dl_period_us
- *  /proc/sys/kernel/sched_dl_runtime_us
- */
-extern unsigned int sysctl_sched_dl_period;
-extern int sysctl_sched_dl_runtime;
-
 #ifdef CONFIG_CFS_BANDWIDTH
 extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 #endif
@@ -108,8 +99,4 @@ extern int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
-int sched_dl_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp,
-		loff_t *ppos);
-
 #endif /* _SCHED_SYSCTL_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 27c6375..1d33eb8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6771,7 +6771,7 @@ void __init sched_init(void)
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
 	init_dl_bandwidth(&def_dl_bandwidth,
-			global_dl_period(), global_dl_runtime());
+			global_rt_period(), global_rt_runtime());
 
 #ifdef CONFIG_SMP
 	init_defrootdomain();
@@ -7354,64 +7354,11 @@ static long sched_group_rt_period(struct task_group *tg)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
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
 #ifdef CONFIG_RT_GROUP_SCHED
 static int sched_rt_global_constraints(void)
 {
-	u64 runtime, period, bw;
 	int ret = 0;
 
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
-
-	runtime = global_rt_runtime();
-	period = global_rt_period();
-
-	/*
-	 * Sanity check on the sysctl variables.
-	 */
-	if (runtime > period && runtime != RUNTIME_INF)
-		return -EINVAL;
-
-	bw = to_ratio(period, runtime);
-	if (!__sched_rt_dl_global_constraints(bw))
-		return -EINVAL;
-
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
 	ret = __rt_schedulable(NULL, 0, 0);
@@ -7435,18 +7382,8 @@ static int sched_rt_global_constraints(void)
 {
 	unsigned long flags;
 	int i, ret = 0;
-	u64 bw;
-
-	if (sysctl_sched_rt_period <= 0)
-		return -EINVAL;
 
 	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
-	bw = to_ratio(global_rt_period(), global_rt_runtime());
-	if (!__sched_rt_dl_global_constraints(bw)) {
-		ret = -EINVAL;
-		goto unlock;
-	}
-
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
 
@@ -7454,69 +7391,18 @@ static int sched_rt_global_constraints(void)
 		rt_rq->rt_runtime = global_rt_runtime();
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
-unlock:
 	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
 
 	return ret;
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
-static bool __sched_dl_global_constraints(u64 runtime, u64 period)
-{
-	if (!period || (runtime != RUNTIME_INF && runtime > period))
-		return -EINVAL;
-
-	return 0;
-}
-
 static int sched_dl_global_constraints(void)
 {
-	u64 runtime = global_dl_runtime();
-	u64 period = global_dl_period();
+	u64 runtime = global_rt_runtime();
+	u64 period = global_rt_period();
 	u64 new_bw = to_ratio(period, runtime);
-	int ret, i;
-
-	ret = __sched_dl_global_constraints(runtime, period);
-	if (ret)
-		return ret;
-
-	if (!__sched_dl_rt_global_constraints(new_bw))
-		return -EINVAL;
+	int cpu, ret = 0;
 
 	/*
 	 * Here we want to check the bandwidth not being set to some
@@ -7527,46 +7413,68 @@ static int sched_dl_global_constraints(void)
 	 * cycling on root_domains... Discussion on different/better
 	 * solutions is welcome!
 	 */
-	for_each_possible_cpu(i) {
-		struct dl_bw *dl_b = dl_bw_of(i);
+	for_each_possible_cpu(cpu) {
+		struct dl_bw *dl_b = dl_bw_of(cpu);
 
 		raw_spin_lock(&dl_b->lock);
-		if (new_bw < dl_b->total_bw) {
-			raw_spin_unlock(&dl_b->lock);
-			return -EBUSY;
-		}
+		if (new_bw < dl_b->total_bw)
+			ret = -EBUSY;
 		raw_spin_unlock(&dl_b->lock);
+
+		if (ret)
+			break;
 	}
 
-	return 0;
+	return ret;
 }
 
-int sched_rr_handler(struct ctl_table *table, int write,
-		void __user *buffer, size_t *lenp,
-		loff_t *ppos)
+static void sched_dl_do_global(void)
 {
-	int ret;
-	static DEFINE_MUTEX(mutex);
+	u64 new_bw = -1;
+	int cpu;
 
-	mutex_lock(&mutex);
-	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-	/* make sure that internally we keep jiffies */
-	/* also, writing zero resets timeslice to default */
-	if (!ret && write) {
-		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
-			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+	def_dl_bandwidth.dl_period = global_rt_period();
+	def_dl_bandwidth.dl_runtime = global_rt_runtime();
+
+	if (global_rt_runtime() != RUNTIME_INF)
+		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
+
+	/*
+	 * FIXME: As above...
+	 */
+	for_each_possible_cpu(cpu) {
+		struct dl_bw *dl_b = dl_bw_of(cpu);
+
+		raw_spin_lock(&dl_b->lock);
+		dl_b->bw = new_bw;
+		raw_spin_unlock(&dl_b->lock);
 	}
-	mutex_unlock(&mutex);
-	return ret;
+}
+
+static int sched_rt_global_validate(void)
+{
+	if (sysctl_sched_rt_period <= 0)
+		return -EINVAL;
+
+	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void sched_rt_do_global(void)
+{
+	def_rt_bandwidth.rt_runtime = global_rt_runtime();
+	def_rt_bandwidth.rt_period = ns_to_ktime(global_rt_period());
 }
 
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
-	int ret;
 	int old_period, old_runtime;
 	static DEFINE_MUTEX(mutex);
+	int ret;
 
 	mutex_lock(&mutex);
 	old_period = sysctl_sched_rt_period;
@@ -7575,72 +7483,47 @@ int sched_rt_handler(struct ctl_table *table, int write,
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 
 	if (!ret && write) {
+		ret = sched_rt_global_validate();
+		if (ret)
+			goto undo;
+
 		ret = sched_rt_global_constraints();
-		if (ret) {
-			sysctl_sched_rt_period = old_period;
-			sysctl_sched_rt_runtime = old_runtime;
-		} else {
-			def_rt_bandwidth.rt_runtime = global_rt_runtime();
-			def_rt_bandwidth.rt_period =
-				ns_to_ktime(global_rt_period());
-		}
+		if (ret)
+			goto undo;
+
+		ret = sched_dl_global_constraints();
+		if (ret)
+			goto undo;
+
+		sched_rt_do_global();
+		sched_dl_do_global();
+	}
+	if (0) {
+undo:
+		sysctl_sched_rt_period = old_period;
+		sysctl_sched_rt_runtime = old_runtime;
 	}
 	mutex_unlock(&mutex);
 
 	return ret;
 }
 
-int sched_dl_handler(struct ctl_table *table, int write,
+int sched_rr_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
 	int ret;
-	int old_period, old_runtime;
 	static DEFINE_MUTEX(mutex);
-	unsigned long flags;
 
 	mutex_lock(&mutex);
-	old_period = sysctl_sched_dl_period;
-	old_runtime = sysctl_sched_dl_runtime;
-
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
-
+	/* make sure that internally we keep jiffies */
+	/* also, writing zero resets timeslice to default */
 	if (!ret && write) {
-		raw_spin_lock_irqsave(&def_dl_bandwidth.dl_runtime_lock,
-				      flags);
-
-		ret = sched_dl_global_constraints();
-		if (ret) {
-			sysctl_sched_dl_period = old_period;
-			sysctl_sched_dl_runtime = old_runtime;
-		} else {
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
-				struct dl_bw *dl_b = dl_bw_of(i);
-
-				raw_spin_lock(&dl_b->lock);
-				dl_b->bw = new_bw;
-				raw_spin_unlock(&dl_b->lock);
-			}
-		}
-
-		raw_spin_unlock_irqrestore(&def_dl_bandwidth.dl_runtime_lock,
-					   flags);
+		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
+			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
 	}
 	mutex_unlock(&mutex);
-
 	return ret;
 }
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0c6b1d0..ee25361 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -63,10 +63,10 @@ void init_dl_bw(struct dl_bw *dl_b)
 {
 	raw_spin_lock_init(&dl_b->lock);
 	raw_spin_lock(&def_dl_bandwidth.dl_runtime_lock);
-	if (global_dl_runtime() == RUNTIME_INF)
+	if (global_rt_runtime() == RUNTIME_INF)
 		dl_b->bw = -1;
 	else
-		dl_b->bw = to_ratio(global_dl_period(), global_dl_runtime());
+		dl_b->bw = to_ratio(global_rt_period(), global_rt_runtime());
 	raw_spin_unlock(&def_dl_bandwidth.dl_runtime_lock);
 	dl_b->total_bw = 0;
 }
@@ -612,6 +612,29 @@ static void update_curr_dl(struct rq *rq)
 		if (!is_leftmost(curr, &rq->dl))
 			resched_task(curr);
 	}
+
+	/*
+	 * Because -- for now -- we share the rt bandwidth, we need to
+	 * account our runtime there too, otherwise actual rt tasks
+	 * would be able to exceed the shared quota.
+	 *
+	 * Account to the root rt group for now.
+	 *
+	 * The solution we're working towards is having the RT groups scheduled
+	 * using deadline servers -- however there's a few nasties to figure
+	 * out before that can happen.
+	 */
+	if (rt_bandwidth_enabled()) {
+		struct rt_rq *rt_rq = &rq->rt;
+
+		raw_spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_time += delta_exec;
+		/*
+		 * We'll let actual RT tasks worry about the overflow here, we
+		 * have our own CBS to keep us inline -- see above.
+		 */
+		raw_spin_unlock(&rt_rq->rt_runtime_lock);
+	}
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 2b7421d..890339099 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -176,7 +176,7 @@ struct dl_bandwidth {
 
 static inline int dl_bandwidth_enabled(void)
 {
-	return sysctl_sched_dl_runtime >= 0;
+	return sysctl_sched_rt_runtime >= 0;
 }
 
 extern struct dl_bw *dl_bw_of(int i);
@@ -186,9 +186,6 @@ struct dl_bw {
 	u64 bw, total_bw;
 };
 
-static inline u64 global_dl_period(void);
-static inline u64 global_dl_runtime(void);
-
 extern struct mutex sched_domains_mutex;
 
 #ifdef CONFIG_CGROUP_SCHED
@@ -953,19 +950,6 @@ static inline u64 global_rt_runtime(void)
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-static inline u64 global_dl_period(void)
-{
-	return (u64)sysctl_sched_dl_period * NSEC_PER_USEC;
-}
-
-static inline u64 global_dl_runtime(void)
-{
-	if (sysctl_sched_dl_runtime < 0)
-		return RUNTIME_INF;
-
-	return (u64)sysctl_sched_dl_runtime * NSEC_PER_USEC;
-}
-
 static inline int task_current(struct rq *rq, struct task_struct *p)
 {
 	return rq->curr == p;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c7fb079..c8da99f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -414,20 +414,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rr_handler,
 	},
-	{
-		.procname	= "sched_dl_period_us",
-		.data		= &sysctl_sched_dl_period,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= sched_dl_handler,
-	},
-	{
-		.procname	= "sched_dl_runtime_us",
-		.data		= &sysctl_sched_dl_runtime,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= sched_dl_handler,
-	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
