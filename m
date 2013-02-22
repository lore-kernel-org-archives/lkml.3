Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3BVF45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:56:57 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:43411 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3BVF4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:56:52 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 1/2] cpustat: use accessor functions for get/set/add
Date: Thu, 21 Feb 2013 21:56:43 -0800
Message-Id: <1361512604-2720-2-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361512604-2720-1-git-send-email-khilman@linaro.org>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some accessor functions in order to facilitate the conversion to
atomic reads/writes of cpustat values.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/s390/appldata/appldata_os.c   | 16 +++++++--------
 drivers/cpufreq/cpufreq_governor.c | 18 ++++++++---------
 drivers/cpufreq/cpufreq_ondemand.c |  2 +-
 drivers/macintosh/rack-meter.c     |  6 +++---
 fs/proc/stat.c                     | 40 +++++++++++++++++++-------------------
 fs/proc/uptime.c                   |  2 +-
 include/linux/kernel_stat.h        |  7 ++++++-
 kernel/sched/core.c                | 12 +++++-------
 kernel/sched/cputime.c             | 29 +++++++++++++--------------
 9 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 87521ba..eff76f8 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -113,21 +113,21 @@ static void appldata_get_os_data(void *data)
 	j = 0;
 	for_each_online_cpu(i) {
 		os_data->os_cpu[j].per_cpu_user =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_USER]);
+			cputime_to_jiffies(kcpustat_cpu_get(i, CPUTIME_USER));
 		os_data->os_cpu[j].per_cpu_nice =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
+			cputime_to_jiffies(kcpustat_cpu_get(i, CPUTIME_NICE));
 		os_data->os_cpu[j].per_cpu_system =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
+			cputime_to_jiffies(kcpustat_cpu_get(i, CPUTIME_SYSTEM));
 		os_data->os_cpu[j].per_cpu_idle =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
+			cputime_to_jiffies(kcpustat_cpu_get(i, CPUTIME_IDLE));
 		os_data->os_cpu[j].per_cpu_irq =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
+			cputime_to_jiffies(kcpustat_cpu_get(i, CPUTIME_IRQ));
 		os_data->os_cpu[j].per_cpu_softirq =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
+			cputime_to_jiffies(kcpustat_cpu_get(i, CPUTIME_SOFTIRQ));
 		os_data->os_cpu[j].per_cpu_iowait =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IOWAIT]);
+			cputime_to_jiffies(kcpustat_cpu_get(i, CPUTIME_IOWAIT));
 		os_data->os_cpu[j].per_cpu_steal =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
+			cputime_to_jiffies(kcpustat_cpu_get(i, CPUTIME_STEAL));
 		os_data->os_cpu[j].cpu_id = i;
 		j++;
 	}
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 6c5f1d3..ec6c315 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -36,12 +36,12 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
 
 	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
 
-	busy_time = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
+	busy_time = kcpustat_cpu_get(cpu, CPUTIME_USER);
+	busy_time += kcpustat_cpu_get(cpu, CPUTIME_SYSTEM);
+	busy_time += kcpustat_cpu_get(cpu, CPUTIME_IRQ);
+	busy_time += kcpustat_cpu_get(cpu, CPUTIME_SOFTIRQ);
+	busy_time += kcpustat_cpu_get(cpu, CPUTIME_STEAL);
+	busy_time += kcpustat_cpu_get(cpu, CPUTIME_NICE);
 
 	idle_time = cur_wall_time - busy_time;
 	if (wall)
@@ -103,7 +103,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			u64 cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE] -
+			cur_nice = kcpustat_cpu_get(j, CPUTIME_NICE) -
 					 cdbs->prev_cpu_nice;
 			/*
 			 * Assumption: nice time between sampling periods will
@@ -113,7 +113,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 					cputime64_to_jiffies64(cur_nice);
 
 			cdbs->prev_cpu_nice =
-				kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+				kcpustat_cpu_get(j, CPUTIME_NICE);
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -216,7 +216,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 					&j_cdbs->prev_cpu_wall);
 			if (ignore_nice)
 				j_cdbs->prev_cpu_nice =
-					kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+					kcpustat_cpu_get(j, CPUTIME_NICE);
 		}
 
 		/*
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 7731f7c..ac5d49f 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -403,7 +403,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 						&dbs_info->cdbs.prev_cpu_wall);
 		if (od_tuners.ignore_nice)
 			dbs_info->cdbs.prev_cpu_nice =
-				kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+				kcpustat_cpu_get(j, CPUTIME_NICE);
 
 	}
 	return count;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index cad0e19..e799f3c 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -83,11 +83,11 @@ static inline cputime64_t get_cpu_idle_time(unsigned int cpu)
 {
 	u64 retval;
 
-	retval = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE] +
-		 kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+	retval = kcpustat_cpu_get(cpu, CPUTIME_IDLE) +
+		 kcpustat_cpu_get(cpu, CPUTIME_IOWAIT);
 
 	if (rackmeter_ignore_nice)
-		retval += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
+		retval += kcpustat_cpu_get(cpu, CPUTIME_NICE);
 
 	return retval;
 }
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index e296572..6a24276 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -25,7 +25,7 @@ static cputime64_t get_idle_time(int cpu)
 {
 	cputime64_t idle;
 
-	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+	idle = kcpustat_cpu_get(cpu, CPUTIME_IDLE);
 	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
 		idle += arch_idle_time(cpu);
 	return idle;
@@ -35,7 +35,7 @@ static cputime64_t get_iowait_time(int cpu)
 {
 	cputime64_t iowait;
 
-	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+	iowait = kcpustat_cpu_get(cpu, CPUTIME_IOWAIT);
 	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
 		iowait += arch_idle_time(cpu);
 	return iowait;
@@ -52,7 +52,7 @@ static u64 get_idle_time(int cpu)
 
 	if (idle_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
-		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+		idle = kcpustat_cpu_get(cpu, CPUTIME_IDLE);
 	else
 		idle = usecs_to_cputime64(idle_time);
 
@@ -68,7 +68,7 @@ static u64 get_iowait_time(int cpu)
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
-		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+		iowait = kcpustat_cpu_get(cpu, CPUTIME_IOWAIT);
 	else
 		iowait = usecs_to_cputime64(iowait_time);
 
@@ -95,16 +95,16 @@ static int show_stat(struct seq_file *p, void *v)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
-		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
-		system += kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
+		user += kcpustat_cpu_get(i, CPUTIME_USER);
+		nice += kcpustat_cpu_get(i, CPUTIME_NICE);
+		system += kcpustat_cpu_get(i, CPUTIME_SYSTEM);
 		idle += get_idle_time(i);
 		iowait += get_iowait_time(i);
-		irq += kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
-		softirq += kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
-		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
-		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		irq += kcpustat_cpu_get(i, CPUTIME_IRQ);
+		softirq += kcpustat_cpu_get(i, CPUTIME_SOFTIRQ);
+		steal += kcpustat_cpu_get(i, CPUTIME_STEAL);
+		guest += kcpustat_cpu_get(i, CPUTIME_GUEST);
+		guest_nice += kcpustat_cpu_get(i, CPUTIME_GUEST_NICE);
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -132,16 +132,16 @@ static int show_stat(struct seq_file *p, void *v)
 
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
-		nice = kcpustat_cpu(i).cpustat[CPUTIME_NICE];
-		system = kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
+		user = kcpustat_cpu_get(i, CPUTIME_USER);
+		nice = kcpustat_cpu_get(i, CPUTIME_NICE);
+		system = kcpustat_cpu_get(i, CPUTIME_SYSTEM);
 		idle = get_idle_time(i);
 		iowait = get_iowait_time(i);
-		irq = kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
-		softirq = kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
-		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
-		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		irq = kcpustat_cpu_get(i, CPUTIME_IRQ);
+		softirq = kcpustat_cpu_get(i, CPUTIME_SOFTIRQ);
+		steal = kcpustat_cpu_get(i, CPUTIME_STEAL);
+		guest = kcpustat_cpu_get(i, CPUTIME_GUEST);
+		guest_nice = kcpustat_cpu_get(i, CPUTIME_GUEST_NICE);
 		seq_printf(p, "cpu%d", i);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 9610ac7..fd9c93d 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -18,7 +18,7 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 
 	idletime = 0;
 	for_each_possible_cpu(i)
-		idletime += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
+		idletime += (__force u64) kcpustat_cpu_get(i, CPUTIME_IDLE);
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 66b7078..df8ad75 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -32,7 +32,7 @@ enum cpu_usage_stat {
 };
 
 struct kernel_cpustat {
-	u64 cpustat[NR_STATS];
+	u64 _cpustat[NR_STATS];
 };
 
 struct kernel_stat {
@@ -51,6 +51,11 @@ DECLARE_PER_CPU(struct kernel_cpustat, kernel_cpustat);
 #define kcpustat_this_cpu (&__get_cpu_var(kernel_cpustat))
 #define kstat_cpu(cpu) per_cpu(kstat, cpu)
 #define kcpustat_cpu(cpu) per_cpu(kernel_cpustat, cpu)
+#define kcpustat_cpu_get(cpu, i) (kcpustat_cpu(cpu)._cpustat[i])
+#define kcpustat_cpu_set(cpu, i, val) (kcpustat_cpu(cpu)._cpustat[i] = (val))
+#define kcpustat_cpu_add(cpu, i, val) (kcpustat_cpu(cpu)._cpustat[i] += (val))
+#define kcpustat_this_cpu_set(i, val) (kcpustat_this_cpu->_cpustat[i] = (val))
+#define kcpustat_this_cpu_add(i, val) (kcpustat_this_cpu->_cpustat[i] += (val))
 
 extern unsigned long long nr_context_switches(void);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..4a8234c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8082,19 +8082,17 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 	s64 val = 0;
 
 	for_each_online_cpu(cpu) {
-		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_USER];
-		val += kcpustat->cpustat[CPUTIME_NICE];
+		val += kcpustat_cpu_get(cpu, CPUTIME_USER);
+		val += kcpustat_cpu_get(cpu, CPUTIME_NICE);
 	}
 	val = cputime64_to_clock_t(val);
 	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
 
 	val = 0;
 	for_each_online_cpu(cpu) {
-		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_SYSTEM];
-		val += kcpustat->cpustat[CPUTIME_IRQ];
-		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
+		val += kcpustat_cpu_get(cpu, CPUTIME_SYSTEM);
+		val += kcpustat_cpu_get(cpu, CPUTIME_IRQ);
+		val += kcpustat_cpu_get(cpu, CPUTIME_SOFTIRQ);
 	}
 
 	val = cputime64_to_clock_t(val);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 293b202..a4c0594 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -124,7 +124,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	 * is the only cgroup, then nothing else should be necessary.
 	 *
 	 */
-	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+	kcpustat_this_cpu_add(index, tmp);
 
 #ifdef CONFIG_CGROUP_CPUACCT
 	if (unlikely(!cpuacct_subsys.active))
@@ -175,8 +175,6 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
 	/* Add guest time to process. */
 	p->utime += cputime;
 	p->utimescaled += cputime_scaled;
@@ -185,11 +183,12 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat[CPUTIME_NICE] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
+		kcpustat_this_cpu_add(CPUTIME_NICE, (__force u64) cputime);
+		kcpustat_this_cpu_add(CPUTIME_GUEST_NICE,
+				      (__force u64) cputime);
 	} else {
-		cpustat[CPUTIME_USER] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
+		kcpustat_this_cpu_add(CPUTIME_USER, (__force u64) cputime);
+		kcpustat_this_cpu_add(CPUTIME_GUEST, (__force u64) cputime);
 	}
 }
 
@@ -249,9 +248,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
-
-	cpustat[CPUTIME_STEAL] += (__force u64) cputime;
+	kcpustat_this_cpu_add(CPUTIME_STEAL, (__force u64) cputime);
 }
 
 /*
@@ -260,13 +257,12 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
+		kcpustat_this_cpu_add(CPUTIME_IOWAIT, (__force u64) cputime);
 	else
-		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
+		kcpustat_this_cpu_add(CPUTIME_IDLE, (__force u64) cputime);
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -344,15 +340,16 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq)
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
 	if (irqtime_account_hi_update()) {
-		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
+		kcpustat_this_cpu_add(CPUTIME_IRQ,
+				      (__force u64) cputime_one_jiffy);
 	} else if (irqtime_account_si_update()) {
-		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
+		kcpustat_this_cpu_add(CPUTIME_SOFTIRQ,
+				      (__force u64) cputime_one_jiffy);
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
-- 
1.8.1.2

