Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab3BUTir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:38:47 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47734 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab3BUTip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:38:45 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Subject: Re: [RFC/PATCH 2/5] kernel_cpustat: convert to atomic 64-bit accessors
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
	<1361389302-11968-3-git-send-email-khilman@linaro.org>
Date: Thu, 21 Feb 2013 11:38:42 -0800
In-Reply-To: <1361389302-11968-3-git-send-email-khilman@linaro.org> (Kevin
	Hilman's message of "Wed, 20 Feb 2013 11:41:39 -0800")
Message-ID: <87y5ehmp8d.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Hilman <khilman@linaro.org> writes:

> Use the atomic64_* accessors for all the kernel_cpustat fields to
> ensure atomic access on non-64 bit platforms.
>
> Thanks to Mats Liljegren for CGROUP_CPUACCT related fixes.
>
> Cc: Mats Liljegren <mats.liljegren@enea.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>

The kbuild test bot reported some build errors where I missed some
conversions (e.g. drivers/cpufreq and arch/s390/appldata).

Below is an updated patch that adds in those changes.

I've updated my branch with this version.

Kevin

>From fff74c8e41bb68f48639441484dd0ad4fc7137aa Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Thu, 14 Feb 2013 17:46:08 -0800
Subject: [PATCH 2/5] kernel_cpustat: convert to atomic 64-bit accessors

Use the atomic64_* accessors for all the kernel_cpustat fields to
ensure atomic access on non-64 bit platforms.

Thanks to Mats Liljegren for CGROUP_CPUACCT related fixes.

Cc: Mats Liljegren <mats.liljegren@enea.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/s390/appldata/appldata_os.c   | 41 +++++++++++++++++++++++---------------
 drivers/cpufreq/cpufreq_governor.c | 18 ++++++++---------
 drivers/cpufreq/cpufreq_ondemand.c |  2 +-
 drivers/macintosh/rack-meter.c     |  6 +++---
 fs/proc/stat.c                     | 40 ++++++++++++++++++-------------------
 fs/proc/uptime.c                   |  2 +-
 include/linux/kernel_stat.h        |  2 +-
 kernel/sched/core.c                | 10 +++++-----
 kernel/sched/cputime.c             | 38 +++++++++++++++++------------------
 9 files changed, 84 insertions(+), 75 deletions(-)

diff --git a/arch/s390/appldata/appldata_os.c b/arch/s390/appldata/appldata_os.c
index 87521ba..008b180 100644
--- a/arch/s390/appldata/appldata_os.c
+++ b/arch/s390/appldata/appldata_os.c
@@ -99,6 +99,7 @@ static void appldata_get_os_data(void *data)
 	int i, j, rc;
 	struct appldata_os_data *os_data;
 	unsigned int new_size;
+	u64 val;
 
 	os_data = data;
 	os_data->sync_count_1++;
@@ -112,22 +113,30 @@ static void appldata_get_os_data(void *data)
 
 	j = 0;
 	for_each_online_cpu(i) {
-		os_data->os_cpu[j].per_cpu_user =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_USER]);
-		os_data->os_cpu[j].per_cpu_nice =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
-		os_data->os_cpu[j].per_cpu_system =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
-		os_data->os_cpu[j].per_cpu_idle =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
-		os_data->os_cpu[j].per_cpu_irq =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
-		os_data->os_cpu[j].per_cpu_softirq =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
-		os_data->os_cpu[j].per_cpu_iowait =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_IOWAIT]);
-		os_data->os_cpu[j].per_cpu_steal =
-			cputime_to_jiffies(kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
+		val = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_USER]);
+		os_data->os_cpu[j].per_cpu_user = cputime_to_jiffies(val);
+			
+		val = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
+		os_data->os_cpu[j].per_cpu_nice = cputime_to_jiffies(val);
+
+		val = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
+		os_data->os_cpu[j].per_cpu_system = cputime_to_jiffies(val);
+
+		val = atomci64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
+		os_data->os_cpu[j].per_cpu_idle = cputime_to_jiffies(val);
+
+		val = atomci64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
+		os_data->os_cpu[j].per_cpu_irq = cputime_to_jiffies(val);
+
+		val = atomci64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
+		os_data->os_cpu[j].per_cpu_softirq = cputime_to_jiffies(val);
+
+		val = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IOWAIT]);
+		os_data->os_cpu[j].per_cpu_iowait = cputime_to_jiffies(val);
+
+		val = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
+		os_data->os_cpu[j].per_cpu_steal = cputime_to_jiffies(val);
+
 		os_data->os_cpu[j].cpu_id = i;
 		j++;
 	}
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 6c5f1d3..a239f8c 100644
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
+	busy_time = atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_USER]);
+	busy_time += atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM]);
+	busy_time += atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ]);
+	busy_time += atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ]);
+	busy_time += atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL]);
+	busy_time += atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_NICE]);
 
 	idle_time = cur_wall_time - busy_time;
 	if (wall)
@@ -103,7 +103,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			u64 cur_nice;
 			unsigned long cur_nice_jiffies;
 
-			cur_nice = kcpustat_cpu(j).cpustat[CPUTIME_NICE] -
+			cur_nice = atomic64_read(&kcpustat_cpu(j).cpustat[CPUTIME_NICE]) -
 					 cdbs->prev_cpu_nice;
 			/*
 			 * Assumption: nice time between sampling periods will
@@ -113,7 +113,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 					cputime64_to_jiffies64(cur_nice);
 
 			cdbs->prev_cpu_nice =
-				kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+				atomic64_read(&kcpustat_cpu(j).cpustat[CPUTIME_NICE]);
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
@@ -216,7 +216,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 					&j_cdbs->prev_cpu_wall);
 			if (ignore_nice)
 				j_cdbs->prev_cpu_nice =
-					kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+					atomic64_read(&kcpustat_cpu(j).cpustat[CPUTIME_NICE]);
 		}
 
 		/*
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 7731f7c..d761c9f 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -403,7 +403,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 						&dbs_info->cdbs.prev_cpu_wall);
 		if (od_tuners.ignore_nice)
 			dbs_info->cdbs.prev_cpu_nice =
-				kcpustat_cpu(j).cpustat[CPUTIME_NICE];
+				atomic64_read(&kcpustat_cpu(j).cpustat[CPUTIME_NICE]);
 
 	}
 	return count;
diff --git a/drivers/macintosh/rack-meter.c b/drivers/macintosh/rack-meter.c
index cad0e19..597fe20 100644
--- a/drivers/macintosh/rack-meter.c
+++ b/drivers/macintosh/rack-meter.c
@@ -83,11 +83,11 @@ static inline cputime64_t get_cpu_idle_time(unsigned int cpu)
 {
 	u64 retval;
 
-	retval = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE] +
-		 kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+	retval = atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE]) +
+ 		 atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT]);
 
 	if (rackmeter_ignore_nice)
-		retval += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
+		retval += atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_NICE]);
 
 	return retval;
 }
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index e296572..93f7f30 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -25,7 +25,7 @@ static cputime64_t get_idle_time(int cpu)
 {
 	cputime64_t idle;
 
-	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+	idle = atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE]);
 	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
 		idle += arch_idle_time(cpu);
 	return idle;
@@ -35,7 +35,7 @@ static cputime64_t get_iowait_time(int cpu)
 {
 	cputime64_t iowait;
 
-	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+	iowait = atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT]);
 	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
 		iowait += arch_idle_time(cpu);
 	return iowait;
@@ -52,7 +52,7 @@ static u64 get_idle_time(int cpu)
 
 	if (idle_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
-		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+		idle = atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE]);
 	else
 		idle = usecs_to_cputime64(idle_time);
 
@@ -68,7 +68,7 @@ static u64 get_iowait_time(int cpu)
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
-		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+		iowait = atomic64_read(&kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT]);
 	else
 		iowait = usecs_to_cputime64(iowait_time);
 
@@ -95,16 +95,16 @@ static int show_stat(struct seq_file *p, void *v)
 	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
-		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
-		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
-		system += kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
+		user += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_USER]);
+		nice += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
+		system += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
 		idle += get_idle_time(i);
 		iowait += get_iowait_time(i);
-		irq += kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
-		softirq += kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
-		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
-		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		irq += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
+		softirq += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
+		steal += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
+		guest += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_GUEST]);
+		guest_nice += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE]);
 		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
@@ -132,16 +132,16 @@ static int show_stat(struct seq_file *p, void *v)
 
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
-		nice = kcpustat_cpu(i).cpustat[CPUTIME_NICE];
-		system = kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
+		user = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_USER]);
+		nice = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_NICE]);
+		system = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM]);
 		idle = get_idle_time(i);
 		iowait = get_iowait_time(i);
-		irq = kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
-		softirq = kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
-		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
-		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
+		irq = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IRQ]);
+		softirq = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ]);
+		steal = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_STEAL]);
+		guest = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_GUEST]);
+		guest_nice = atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE]);
 		seq_printf(p, "cpu%d", i);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 9610ac7..10c0f6e 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -18,7 +18,7 @@ static int uptime_proc_show(struct seq_file *m, void *v)
 
 	idletime = 0;
 	for_each_possible_cpu(i)
-		idletime += (__force u64) kcpustat_cpu(i).cpustat[CPUTIME_IDLE];
+		idletime += atomic64_read(&kcpustat_cpu(i).cpustat[CPUTIME_IDLE]);
 
 	do_posix_clock_monotonic_gettime(&uptime);
 	monotonic_to_bootbased(&uptime);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ed5f6ed..45b9f71 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -32,7 +32,7 @@ enum cpu_usage_stat {
 };
 
 struct kernel_cpustat {
-	u64 cpustat[NR_STATS];
+	atomic64_t cpustat[NR_STATS];
 };
 
 struct kernel_stat {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2fad439..5415e85 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8168,8 +8168,8 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 
 	for_each_online_cpu(cpu) {
 		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_USER];
-		val += kcpustat->cpustat[CPUTIME_NICE];
+		val += atomic64_read(&kcpustat->cpustat[CPUTIME_USER]);
+		val += atomic64_read(&kcpustat->cpustat[CPUTIME_NICE]);
 	}
 	val = cputime64_to_clock_t(val);
 	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
@@ -8177,9 +8177,9 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 	val = 0;
 	for_each_online_cpu(cpu) {
 		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_SYSTEM];
-		val += kcpustat->cpustat[CPUTIME_IRQ];
-		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
+		val += atomic64_read(&kcpustat->cpustat[CPUTIME_SYSTEM]);
+		val += atomic64_read(&kcpustat->cpustat[CPUTIME_IRQ]);
+		val += atomic64_read(&kcpustat->cpustat[CPUTIME_SOFTIRQ]);
 	}
 
 	val = cputime64_to_clock_t(val);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ccff275..4c639ee 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -78,14 +78,14 @@ EXPORT_SYMBOL_GPL(irqtime_account_irq);
 
 static int irqtime_account_hi_update(void)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_hardirq_time);
-	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_IRQ])
+	if (nsecs_to_cputime64(latest_ns) > atomic64_read(&cpustat[CPUTIME_IRQ]));
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -93,14 +93,14 @@ static int irqtime_account_hi_update(void)
 
 static int irqtime_account_si_update(void)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 	unsigned long flags;
 	u64 latest_ns;
 	int ret = 0;
 
 	local_irq_save(flags);
 	latest_ns = this_cpu_read(cpu_softirq_time);
-	if (nsecs_to_cputime64(latest_ns) > cpustat[CPUTIME_SOFTIRQ])
+	if (nsecs_to_cputime64(latest_ns) > atomic64_read(&cpustat[CPUTIME_SOFTIRQ]))
 		ret = 1;
 	local_irq_restore(flags);
 	return ret;
@@ -125,7 +125,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	 * is the only cgroup, then nothing else should be necessary.
 	 *
 	 */
-	__get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
+	atomic64_add(tmp, &__get_cpu_var(kernel_cpustat).cpustat[index]);
 
 #ifdef CONFIG_CGROUP_CPUACCT
 	if (unlikely(!cpuacct_subsys.active))
@@ -135,7 +135,7 @@ static inline void task_group_account_field(struct task_struct *p, int index,
 	ca = task_ca(p);
 	while (ca && (ca != &root_cpuacct)) {
 		kcpustat = this_cpu_ptr(ca->cpustat);
-		kcpustat->cpustat[index] += tmp;
+		atomic64_add(tmp, &kcpustat->cpustat[index]);
 		ca = parent_ca(ca);
 	}
 	rcu_read_unlock();
@@ -176,7 +176,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 static void account_guest_time(struct task_struct *p, cputime_t cputime,
 			       cputime_t cputime_scaled)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 
 	/* Add guest time to process. */
 	p->utime += cputime;
@@ -186,11 +186,11 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add guest time to cpustat. */
 	if (TASK_NICE(p) > 0) {
-		cpustat[CPUTIME_NICE] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST_NICE] += (__force u64) cputime;
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_NICE]);
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_GUEST_NICE]);
 	} else {
-		cpustat[CPUTIME_USER] += (__force u64) cputime;
-		cpustat[CPUTIME_GUEST] += (__force u64) cputime;
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_USER]);
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_GUEST]);
 	}
 }
 
@@ -250,9 +250,9 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  */
 void account_steal_time(cputime_t cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 
-	cpustat[CPUTIME_STEAL] += (__force u64) cputime;
+	atomic64_add((__force u64) cputime, &cpustat[CPUTIME_STEAL]);
 }
 
 /*
@@ -261,13 +261,13 @@ void account_steal_time(cputime_t cputime)
  */
 void account_idle_time(cputime_t cputime)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_IOWAIT]);
 	else
-		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
+		atomic64_add((__force u64) cputime, &cpustat[CPUTIME_IDLE]);
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -345,15 +345,15 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 						struct rq *rq)
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
+	atomic64_t *cpustat = kcpustat_this_cpu->cpustat;
 
 	if (steal_account_process_tick())
 		return;
 
 	if (irqtime_account_hi_update()) {
-		cpustat[CPUTIME_IRQ] += (__force u64) cputime_one_jiffy;
+		atomic64_add((__force u64) cputime_one_jiffy, &cpustat[CPUTIME_IRQ]);
 	} else if (irqtime_account_si_update()) {
-		cpustat[CPUTIME_SOFTIRQ] += (__force u64) cputime_one_jiffy;
+		atomic64_add((__force u64) cputime_one_jiffy, &cpustat[CPUTIME_SOFTIRQ]);
 	} else if (this_cpu_ksoftirqd() == p) {
 		/*
 		 * ksoftirqd time do not get accounted in cpu_softirq_time.
-- 
1.8.1.2

