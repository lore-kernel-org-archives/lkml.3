Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3EQL0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:26:49 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60262 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3EQL0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:26:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: Move get_cpu_idle_time() to cpufreq.c
Date: Fri, 17 May 2013 16:56:32 +0530
Message-Id: <8bf03cb4a42864802800188fde78adf9b498455f.1368789952.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Governors other than ondemand and conservative can also use get_cpu_idle_time()
and they aren't required to compile cpufreq_governor.c. So, move these
independent routines to cpufreq.c instead.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Bot Targeted for 3.11

 drivers/cpufreq/cpufreq.c          | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/cpufreq_governor.c | 36 ------------------------------------
 drivers/cpufreq/cpufreq_governor.h |  1 -
 include/linux/cpufreq.h            |  1 +
 4 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2d5a829..e3d7112 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -17,7 +17,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <asm/cputime.h>
 #include <linux/kernel.h>
+#include <linux/kernel_stat.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/notifier.h>
@@ -25,6 +27,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/tick.h>
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
@@ -143,6 +146,41 @@ struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy)
 }
 EXPORT_SYMBOL_GPL(get_governor_parent_kobj);
 
+static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
+{
+	u64 idle_time;
+	u64 cur_wall_time;
+	u64 busy_time;
+
+	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
+
+	busy_time = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
+	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
+
+	idle_time = cur_wall_time - busy_time;
+	if (wall)
+		*wall = cputime_to_usecs(cur_wall_time);
+
+	return cputime_to_usecs(idle_time);
+}
+
+u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
+{
+	u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
+
+	if (idle_time == -1ULL)
+		return get_cpu_idle_time_jiffy(cpu, wall);
+	else if (!io_busy)
+		idle_time += get_cpu_iowait_time_us(cpu, wall);
+
+	return idle_time;
+}
+EXPORT_SYMBOL_GPL(get_cpu_idle_time);
+
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
 	struct cpufreq_policy *data;
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index d1421b4..b6cfd55 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -23,7 +23,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/tick.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
@@ -37,41 +36,6 @@ static struct attribute_group *get_sysfs_attr(struct dbs_data *dbs_data)
 		return dbs_data->cdata->attr_group_gov_sys;
 }
 
-static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
-{
-	u64 idle_time;
-	u64 cur_wall_time;
-	u64 busy_time;
-
-	cur_wall_time = jiffies64_to_cputime64(get_jiffies_64());
-
-	busy_time = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
-	busy_time += kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
-
-	idle_time = cur_wall_time - busy_time;
-	if (wall)
-		*wall = cputime_to_usecs(cur_wall_time);
-
-	return cputime_to_usecs(idle_time);
-}
-
-u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)
-{
-	u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
-
-	if (idle_time == -1ULL)
-		return get_cpu_idle_time_jiffy(cpu, wall);
-	else if (!io_busy)
-		idle_time += get_cpu_iowait_time_us(cpu, wall);
-
-	return idle_time;
-}
-EXPORT_SYMBOL_GPL(get_cpu_idle_time);
-
 void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 {
 	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index e16a961..e7bbf76 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -256,7 +256,6 @@ static ssize_t show_sampling_rate_min_gov_pol				\
 	return sprintf(buf, "%u\n", dbs_data->min_sampling_rate);	\
 }
 
-u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy);
 void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
 bool need_load_eval(struct cpu_dbs_common_info *cdbs,
 		unsigned int sampling_rate);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 7ffb4d5..cbdf5a4 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -337,6 +337,7 @@ const char *cpufreq_get_current_driver(void);
 /*********************************************************************
  *                        CPUFREQ 2.6. INTERFACE                     *
  *********************************************************************/
+u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy);
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
 bool have_governor_per_policy(void);
-- 
1.7.12.rc2.18.g61b472e

