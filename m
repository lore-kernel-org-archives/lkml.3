Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3BKHvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 02:51:15 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40704 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3BKHu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 02:50:26 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/4] cpufreq: governor: Implement per policy instances of governors
Date: Mon, 11 Feb 2013 13:20:01 +0530
Message-Id: <eada017a865d03fe67df39c4672f258fb2d71447.1360568193.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1360568193.git.viresh.kumar@linaro.org>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1360568193.git.viresh.kumar@linaro.org>
References: <cover.1360568193.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 11 Feb 2013 07:50:23.0672 (UTC) FILETIME=[72BA5380:01CE082C]
X-MC-Unique: 113021107502410101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1B7pKEF015043

Currently, there can't be multiple instances of single governor_type. If we have
a multi-package system, where we have multiple instances of struct policy (per
package), we can't have multiple instances of same governor. i.e. We can't have
multiple instances of ondemand governor for multiple packages.

Governors directory in sysfs is created at /sys/devices/system/cpu/cpufreq/
governor-name/. Which again reflects that there can be only one instance of a
governor_type in the system.

This is a bottleneck for multicluster system, where we want different packages
to use same governor type, but with different tunables.

This patch uses the infrastructure provided by earlier patch and implements
init/exit routines for ondemand and conservative governors.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c              |   6 -
 drivers/cpufreq/cpufreq_conservative.c | 148 +++++++++++++---------
 drivers/cpufreq/cpufreq_governor.c     | 159 ++++++++++++++----------
 drivers/cpufreq/cpufreq_governor.h     |  43 +++++--
 drivers/cpufreq/cpufreq_ondemand.c     | 216 +++++++++++++++++++--------------
 include/linux/cpufreq.h                |  17 ++-
 6 files changed, 353 insertions(+), 236 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 40f7083..a9e5840 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1564,11 +1564,6 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 						policy->cpu, event);
 	ret = policy->governor->governor(policy, event);
 
-	if (event == CPUFREQ_GOV_START)
-		policy->governor->initialized++;
-	else if (event == CPUFREQ_GOV_STOP)
-		policy->governor->initialized--;
-
 	/* we keep one module reference alive for
 			each CPU governed by this CPU */
 	if ((event != CPUFREQ_GOV_START) || ret)
@@ -1592,7 +1587,6 @@ int cpufreq_register_governor(struct cpufreq_governor *governor)
 
 	mutex_lock(&cpufreq_governor_mutex);
 
-	governor->initialized = 0;
 	err = -EBUSY;
 	if (__find_governor(governor->name) == NULL) {
 		err = 0;
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index e8bb915..5d03577 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/notifier.h>
 #include <linux/percpu-defs.h>
+#include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
 
@@ -31,17 +32,8 @@
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
 #define MAX_SAMPLING_DOWN_FACTOR		(10)
 
-static struct dbs_data cs_dbs_data;
 static DEFINE_PER_CPU(struct cs_cpu_dbs_info_s, cs_cpu_dbs_info);
 
-static struct cs_dbs_tuners cs_tuners = {
-	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
-	.down_threshold = DEF_FREQUENCY_DOWN_THRESHOLD,
-	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
-	.ignore_nice = 0,
-	.freq_step = 5,
-};
-
 /*
  * Every sampling_rate, we check, if current idle time is less than 20%
  * (default), then we try to increase frequency Every sampling_rate *
@@ -55,24 +47,26 @@ static void cs_check_cpu(int cpu, unsigned int load)
 {
 	struct cs_cpu_dbs_info_s *dbs_info = &per_cpu(cs_cpu_dbs_info, cpu);
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	unsigned int freq_target;
 
 	/*
 	 * break out if we 'cannot' reduce the speed as the user might
 	 * want freq_step to be zero
 	 */
-	if (cs_tuners.freq_step == 0)
+	if (cs_tuners->freq_step == 0)
 		return;
 
 	/* Check for frequency increase */
-	if (load > cs_tuners.up_threshold) {
+	if (load > cs_tuners->up_threshold) {
 		dbs_info->down_skip = 0;
 
 		/* if we are already at full speed then break out early */
 		if (dbs_info->requested_freq == policy->max)
 			return;
 
-		freq_target = (cs_tuners.freq_step * policy->max) / 100;
+		freq_target = (cs_tuners->freq_step * policy->max) / 100;
 
 		/* max freq cannot be less than 100. But who knows.... */
 		if (unlikely(freq_target == 0))
@@ -92,8 +86,8 @@ static void cs_check_cpu(int cpu, unsigned int load)
 	 * support the current CPU usage without triggering the up policy. To be
 	 * safe, we focus 10 points under the threshold.
 	 */
-	if (load < (cs_tuners.down_threshold - 10)) {
-		freq_target = (cs_tuners.freq_step * policy->max) / 100;
+	if (load < (cs_tuners->down_threshold - 10)) {
+		freq_target = (cs_tuners->freq_step * policy->max) / 100;
 
 		dbs_info->requested_freq -= freq_target;
 		if (dbs_info->requested_freq < policy->min)
@@ -119,11 +113,13 @@ static void cs_dbs_timer(struct work_struct *work)
 	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
 	struct cs_cpu_dbs_info_s *core_dbs_info = &per_cpu(cs_cpu_dbs_info,
 			cpu);
-	int delay = delay_for_sampling_rate(cs_tuners.sampling_rate);
+	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
+	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+	int delay = delay_for_sampling_rate(cs_tuners->sampling_rate);
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
-	if (need_load_eval(&core_dbs_info->cdbs, cs_tuners.sampling_rate))
-		dbs_check_cpu(&cs_dbs_data, cpu);
+	if (need_load_eval(&core_dbs_info->cdbs, cs_tuners->sampling_rate))
+		dbs_check_cpu(dbs_data, cpu);
 
 	schedule_delayed_work_on(smp_processor_id(), dw, delay);
 	mutex_unlock(&core_dbs_info->cdbs.timer_mutex);
@@ -154,16 +150,11 @@ static int dbs_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 }
 
 /************************** sysfs interface ************************/
-static ssize_t show_sampling_rate_min(struct kobject *kobj,
-				      struct attribute *attr, char *buf)
-{
-	return sprintf(buf, "%u\n", cs_dbs_data.min_sampling_rate);
-}
-
-static ssize_t store_sampling_down_factor(struct kobject *a,
-					  struct attribute *b,
-					  const char *buf, size_t count)
+static ssize_t store_sampling_down_factor(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
@@ -171,13 +162,15 @@ static ssize_t store_sampling_down_factor(struct kobject *a,
 	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
 		return -EINVAL;
 
-	cs_tuners.sampling_down_factor = input;
+	cs_tuners->sampling_down_factor = input;
 	return count;
 }
 
-static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
-				   const char *buf, size_t count)
+static ssize_t store_sampling_rate(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
@@ -185,43 +178,49 @@ static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
 	if (ret != 1)
 		return -EINVAL;
 
-	cs_tuners.sampling_rate = max(input, cs_dbs_data.min_sampling_rate);
+	cs_tuners->sampling_rate = max(input, dbs_data->min_sampling_rate);
 	return count;
 }
 
-static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
-				  const char *buf, size_t count)
+static ssize_t store_up_threshold(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
-	if (ret != 1 || input > 100 || input <= cs_tuners.down_threshold)
+	if (ret != 1 || input > 100 || input <= cs_tuners->down_threshold)
 		return -EINVAL;
 
-	cs_tuners.up_threshold = input;
+	cs_tuners->up_threshold = input;
 	return count;
 }
 
-static ssize_t store_down_threshold(struct kobject *a, struct attribute *b,
-				    const char *buf, size_t count)
+static ssize_t store_down_threshold(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
 	/* cannot be lower than 11 otherwise freq will not fall */
 	if (ret != 1 || input < 11 || input > 100 ||
-			input >= cs_tuners.up_threshold)
+			input >= cs_tuners->up_threshold)
 		return -EINVAL;
 
-	cs_tuners.down_threshold = input;
+	cs_tuners->down_threshold = input;
 	return count;
 }
 
-static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
-				      const char *buf, size_t count)
+static ssize_t store_ignore_nice(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	unsigned int input, j;
 	int ret;
 
@@ -232,10 +231,10 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 	if (input > 1)
 		input = 1;
 
-	if (input == cs_tuners.ignore_nice) /* nothing to do */
+	if (input == cs_tuners->ignore_nice) /* nothing to do */
 		return count;
 
-	cs_tuners.ignore_nice = input;
+	cs_tuners->ignore_nice = input;
 
 	/* we need to re-evaluate prev_cpu_idle */
 	for_each_online_cpu(j) {
@@ -243,16 +242,18 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info = &per_cpu(cs_cpu_dbs_info, j);
 		dbs_info->cdbs.prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->cdbs.prev_cpu_wall);
-		if (cs_tuners.ignore_nice)
+		if (cs_tuners->ignore_nice)
 			dbs_info->cdbs.prev_cpu_nice =
 				kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 	}
 	return count;
 }
 
-static ssize_t store_freq_step(struct kobject *a, struct attribute *b,
-			       const char *buf, size_t count)
+static ssize_t store_freq_step(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
@@ -267,7 +268,7 @@ static ssize_t store_freq_step(struct kobject *a, struct attribute *b,
 	 * no need to test here if freq_step is zero as the user might actually
 	 * want this, they would be crazy though :)
 	 */
-	cs_tuners.freq_step = input;
+	cs_tuners->freq_step = input;
 	return count;
 }
 
@@ -275,16 +276,17 @@ show_one(cs, sampling_rate, sampling_rate);
 show_one(cs, sampling_down_factor, sampling_down_factor);
 show_one(cs, up_threshold, up_threshold);
 show_one(cs, down_threshold, down_threshold);
-show_one(cs, ignore_nice_load, ignore_nice);
+show_one(cs, ignore_nice, ignore_nice);
 show_one(cs, freq_step, freq_step);
+declare_show_sampling_rate_min();
 
-define_one_global_rw(sampling_rate);
-define_one_global_rw(sampling_down_factor);
-define_one_global_rw(up_threshold);
-define_one_global_rw(down_threshold);
-define_one_global_rw(ignore_nice_load);
-define_one_global_rw(freq_step);
-define_one_global_ro(sampling_rate_min);
+cpufreq_freq_attr_rw(sampling_rate);
+cpufreq_freq_attr_rw(sampling_down_factor);
+cpufreq_freq_attr_rw(up_threshold);
+cpufreq_freq_attr_rw(down_threshold);
+cpufreq_freq_attr_rw(ignore_nice);
+cpufreq_freq_attr_rw(freq_step);
+cpufreq_freq_attr_ro(sampling_rate_min);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_min.attr,
@@ -292,7 +294,7 @@ static struct attribute *dbs_attributes[] = {
 	&sampling_down_factor.attr,
 	&up_threshold.attr,
 	&down_threshold.attr,
-	&ignore_nice_load.attr,
+	&ignore_nice.attr,
 	&freq_step.attr,
 	NULL
 };
@@ -304,6 +306,34 @@ static struct attribute_group cs_attr_group = {
 
 /************************** sysfs end ************************/
 
+static int cs_init(struct dbs_data *dbs_data)
+{
+	struct cs_dbs_tuners *tuners;
+
+	tuners = kzalloc(sizeof(struct cs_dbs_tuners), GFP_KERNEL);
+	if (!tuners) {
+		pr_err("%s: kzalloc failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	tuners->up_threshold = DEF_FREQUENCY_UP_THRESHOLD;
+	tuners->down_threshold = DEF_FREQUENCY_DOWN_THRESHOLD;
+	tuners->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
+	tuners->ignore_nice = 0;
+	tuners->freq_step = 5;
+
+	dbs_data->tuners = tuners;
+	dbs_data->min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
+		jiffies_to_usecs(10);
+	mutex_init(&dbs_data->mutex);
+	return 0;
+}
+
+static void cs_exit(struct dbs_data *dbs_data)
+{
+	kfree(dbs_data->tuners);
+}
+
 define_get_cpu_dbs_routines(cs_cpu_dbs_info);
 
 static struct notifier_block cs_cpufreq_notifier_block = {
@@ -314,21 +344,22 @@ static struct cs_ops cs_ops = {
 	.notifier_block = &cs_cpufreq_notifier_block,
 };
 
-static struct dbs_data cs_dbs_data = {
+static struct common_dbs_data cs_dbs_cdata = {
 	.governor = GOV_CONSERVATIVE,
 	.attr_group = &cs_attr_group,
-	.tuners = &cs_tuners,
 	.get_cpu_cdbs = get_cpu_cdbs,
 	.get_cpu_dbs_info_s = get_cpu_dbs_info_s,
 	.gov_dbs_timer = cs_dbs_timer,
 	.gov_check_cpu = cs_check_cpu,
 	.gov_ops = &cs_ops,
+	.init = cs_init,
+	.exit = cs_exit,
 };
 
 static int cs_cpufreq_governor_dbs(struct cpufreq_policy *policy,
 				   unsigned int event)
 {
-	return cpufreq_governor_dbs(&cs_dbs_data, policy, event);
+	return cpufreq_governor_dbs(policy, &cs_dbs_cdata, event);
 }
 
 #ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
@@ -343,7 +374,6 @@ struct cpufreq_governor cpufreq_gov_conservative = {
 
 static int __init cpufreq_gov_dbs_init(void)
 {
-	mutex_init(&cs_dbs_data.mutex);
 	return cpufreq_register_governor(&cpufreq_gov_conservative);
 }
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5a76086..7722505 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/kernel_stat.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/tick.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
@@ -65,7 +66,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time);
 
 void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 {
-	struct cpu_dbs_common_info *cdbs = dbs_data->get_cpu_cdbs(cpu);
+	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
 	struct cpufreq_policy *policy;
@@ -73,7 +74,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 	unsigned int ignore_nice;
 	unsigned int j;
 
-	if (dbs_data->governor == GOV_ONDEMAND)
+	if (dbs_data->cdata->governor == GOV_ONDEMAND)
 		ignore_nice = od_tuners->ignore_nice;
 	else
 		ignore_nice = cs_tuners->ignore_nice;
@@ -87,7 +88,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 		unsigned int idle_time, wall_time, iowait_time;
 		unsigned int load;
 
-		j_cdbs = dbs_data->get_cpu_cdbs(j);
+		j_cdbs = dbs_data->cdata->get_cpu_cdbs(j);
 
 		cur_idle_time = get_cpu_idle_time(j, &cur_wall_time);
 
@@ -117,9 +118,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			idle_time += jiffies_to_usecs(cur_nice_jiffies);
 		}
 
-		if (dbs_data->governor == GOV_ONDEMAND) {
+		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
 			struct od_cpu_dbs_info_s *od_j_dbs_info =
-				dbs_data->get_cpu_dbs_info_s(cpu);
+				dbs_data->cdata->get_cpu_dbs_info_s(cpu);
 
 			cur_iowait_time = get_cpu_iowait_time_us(j,
 					&cur_wall_time);
@@ -145,7 +146,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 
 		load = 100 * (wall_time - idle_time) / wall_time;
 
-		if (dbs_data->governor == GOV_ONDEMAND) {
+		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
 			int freq_avg = __cpufreq_driver_getavg(policy, j);
 			if (freq_avg <= 0)
 				freq_avg = policy->cur;
@@ -157,7 +158,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			max_load = load;
 	}
 
-	dbs_data->gov_check_cpu(cpu, max_load);
+	dbs_data->cdata->gov_check_cpu(cpu, max_load);
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
 
@@ -165,14 +166,14 @@ static inline void dbs_timer_init(struct dbs_data *dbs_data, int cpu,
 				  unsigned int sampling_rate)
 {
 	int delay = delay_for_sampling_rate(sampling_rate);
-	struct cpu_dbs_common_info *cdbs = dbs_data->get_cpu_cdbs(cpu);
+	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
 
 	schedule_delayed_work_on(cpu, &cdbs->work, delay);
 }
 
 static inline void dbs_timer_exit(struct dbs_data *dbs_data, int cpu)
 {
-	struct cpu_dbs_common_info *cdbs = dbs_data->get_cpu_cdbs(cpu);
+	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
 
 	cancel_delayed_work_sync(&cdbs->work);
 }
@@ -196,31 +197,84 @@ bool need_load_eval(struct cpu_dbs_common_info *cdbs,
 }
 EXPORT_SYMBOL_GPL(need_load_eval);
 
-int cpufreq_governor_dbs(struct dbs_data *dbs_data,
-		struct cpufreq_policy *policy, unsigned int event)
+static void set_sampling_rate(struct dbs_data *dbs_data,
+		unsigned int sampling_rate)
 {
+	if (dbs_data->cdata->governor == GOV_CONSERVATIVE) {
+		struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+		cs_tuners->sampling_rate = sampling_rate;
+	} else {
+		struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+		od_tuners->sampling_rate = sampling_rate;
+	}
+}
+
+int cpufreq_governor_dbs(struct cpufreq_policy *policy,
+		struct common_dbs_data *cdata, unsigned int event)
+{
+	struct dbs_data *dbs_data = policy->governor_data;
 	struct od_cpu_dbs_info_s *od_dbs_info = NULL;
 	struct cs_cpu_dbs_info_s *cs_dbs_info = NULL;
 	struct cs_ops *cs_ops = NULL;
 	struct od_ops *od_ops = NULL;
-	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
-	struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+	struct od_dbs_tuners *od_tuners = NULL;
+	struct cs_dbs_tuners *cs_tuners = NULL;
 	struct cpu_dbs_common_info *cpu_cdbs;
-	unsigned int *sampling_rate, latency, ignore_nice, j, cpu = policy->cpu;
+	unsigned int sampling_rate, latency, ignore_nice, j, cpu = policy->cpu;
 	int rc;
 
-	cpu_cdbs = dbs_data->get_cpu_cdbs(cpu);
+	WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));
+
+	switch (event) {
+	case CPUFREQ_GOV_POLICY_INIT:
+		WARN_ON(dbs_data);
+		dbs_data = kzalloc(sizeof(*dbs_data), GFP_KERNEL);
+		if (!dbs_data) {
+			pr_err("%s: POLICY_INIT: kzalloc failed\n", __func__);
+			return -ENOMEM;
+		}
+
+		dbs_data->cdata = cdata;
+		rc = cdata->init(dbs_data);
+		if (rc) {
+			pr_err("%s: POLICY_INIT: init() failed\n", __func__);
+			kfree(dbs_data);
+			return rc;
+		}
+		policy->governor_data = dbs_data;
+
+		/* policy latency is in nS. Convert it to uS first */
+		latency = policy->cpuinfo.transition_latency / 1000;
+		if (latency == 0)
+			latency = 1;
+
+		/* Bring kernel and HW constraints together */
+		dbs_data->min_sampling_rate = max(dbs_data->min_sampling_rate,
+				MIN_LATENCY_MULTIPLIER * latency);
+		set_sampling_rate(dbs_data, max(dbs_data->min_sampling_rate,
+					latency * LATENCY_MULTIPLIER));
+		return 0;
+	case CPUFREQ_GOV_POLICY_EXIT:
+		cdata->exit(dbs_data);
+		kfree(dbs_data);
+		policy->governor_data = NULL;
+		return 0;
+	}
 
-	if (dbs_data->governor == GOV_CONSERVATIVE) {
-		cs_dbs_info = dbs_data->get_cpu_dbs_info_s(cpu);
-		sampling_rate = &cs_tuners->sampling_rate;
+	cpu_cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
+
+	if (dbs_data->cdata->governor == GOV_CONSERVATIVE) {
+		cs_tuners = dbs_data->tuners;
+		cs_dbs_info = dbs_data->cdata->get_cpu_dbs_info_s(cpu);
+		sampling_rate = cs_tuners->sampling_rate;
 		ignore_nice = cs_tuners->ignore_nice;
-		cs_ops = dbs_data->gov_ops;
+		cs_ops = dbs_data->cdata->gov_ops;
 	} else {
-		od_dbs_info = dbs_data->get_cpu_dbs_info_s(cpu);
-		sampling_rate = &od_tuners->sampling_rate;
+		od_tuners = dbs_data->tuners;
+		od_dbs_info = dbs_data->cdata->get_cpu_dbs_info_s(cpu);
+		sampling_rate = od_tuners->sampling_rate;
 		ignore_nice = od_tuners->ignore_nice;
-		od_ops = dbs_data->gov_ops;
+		od_ops = dbs_data->cdata->gov_ops;
 	}
 
 	switch (event) {
@@ -232,7 +286,7 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 
 		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_common_info *j_cdbs =
-				dbs_data->get_cpu_cdbs(j);
+				dbs_data->cdata->get_cpu_cdbs(j);
 
 			j_cdbs->cpu = j;
 			j_cdbs->cur_policy = policy;
@@ -244,69 +298,44 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
 
 			mutex_init(&j_cdbs->timer_mutex);
 			INIT_DEFERRABLE_WORK(&j_cdbs->work,
-					     dbs_data->gov_dbs_timer);
+					     dbs_data->cdata->gov_dbs_timer);
 		}
 
-		if (!policy->governor->initialized) {
-			rc = sysfs_create_group(cpufreq_global_kobject,
-					dbs_data->attr_group);
-			if (rc) {
-				mutex_unlock(&dbs_data->mutex);
-				return rc;
-			}
+		rc = sysfs_create_group(get_governor_parent_kobj(policy),
+				dbs_data->cdata->attr_group);
+		if (rc) {
+			mutex_unlock(&dbs_data->mutex);
+			return rc;
 		}
 
 		/*
 		 * conservative does not implement micro like ondemand
 		 * governor, thus we are bound to jiffes/HZ
 		 */
-		if (dbs_data->governor == GOV_CONSERVATIVE) {
+		if (dbs_data->cdata->governor == GOV_CONSERVATIVE) {
 			cs_dbs_info->down_skip = 0;
 			cs_dbs_info->enable = 1;
 			cs_dbs_info->requested_freq = policy->cur;
 
-			if (!policy->governor->initialized) {
-				cpufreq_register_notifier(cs_ops->notifier_block,
-						CPUFREQ_TRANSITION_NOTIFIER);
-
-				dbs_data->min_sampling_rate =
-					MIN_SAMPLING_RATE_RATIO *
-					jiffies_to_usecs(10);
-			}
+			cpufreq_register_notifier(cs_ops->notifier_block,
+					CPUFREQ_TRANSITION_NOTIFIER);
 		} else {
 			od_dbs_info->rate_mult = 1;
 			od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
 			od_ops->powersave_bias_init_cpu(cpu);
-
-			if (!policy->governor->initialized)
-				od_tuners->io_is_busy = od_ops->io_busy();
 		}
 
-		if (policy->governor->initialized)
-			goto unlock;
-
-		/* policy latency is in nS. Convert it to uS first */
-		latency = policy->cpuinfo.transition_latency / 1000;
-		if (latency == 0)
-			latency = 1;
-
-		/* Bring kernel and HW constraints together */
-		dbs_data->min_sampling_rate = max(dbs_data->min_sampling_rate,
-				MIN_LATENCY_MULTIPLIER * latency);
-		*sampling_rate = max(dbs_data->min_sampling_rate, latency *
-				LATENCY_MULTIPLIER);
-unlock:
 		mutex_unlock(&dbs_data->mutex);
 
 		/* Initiate timer time stamp */
 		cpu_cdbs->time_stamp = ktime_get();
 
 		for_each_cpu(j, policy->cpus)
-			dbs_timer_init(dbs_data, j, *sampling_rate);
+			dbs_timer_init(dbs_data, j, sampling_rate);
 		break;
 
 	case CPUFREQ_GOV_STOP:
-		if (dbs_data->governor == GOV_CONSERVATIVE)
+		if (dbs_data->cdata->governor == GOV_CONSERVATIVE)
 			cs_dbs_info->enable = 0;
 
 		for_each_cpu(j, policy->cpus)
@@ -315,13 +344,11 @@ unlock:
 		mutex_lock(&dbs_data->mutex);
 		mutex_destroy(&cpu_cdbs->timer_mutex);
 
-		if (policy->governor->initialized == 1) {
-			sysfs_remove_group(cpufreq_global_kobject,
-					dbs_data->attr_group);
-			if (dbs_data->governor == GOV_CONSERVATIVE)
-				cpufreq_unregister_notifier(cs_ops->notifier_block,
-						CPUFREQ_TRANSITION_NOTIFIER);
-		}
+		sysfs_remove_group(get_governor_parent_kobj(policy),
+				dbs_data->cdata->attr_group);
+		if (dbs_data->cdata->governor == GOV_CONSERVATIVE)
+			cpufreq_unregister_notifier(cs_ops->notifier_block,
+					CPUFREQ_TRANSITION_NOTIFIER);
 		mutex_unlock(&dbs_data->mutex);
 
 		break;
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index d2ac911..6301790 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -43,9 +43,11 @@ enum {OD_NORMAL_SAMPLE, OD_SUB_SAMPLE};
 /* Macro creating sysfs show routines */
 #define show_one(_gov, file_name, object)				\
 static ssize_t show_##file_name						\
-(struct kobject *kobj, struct attribute *attr, char *buf)		\
+(struct cpufreq_policy *policy, char *buf)				\
 {									\
-	return sprintf(buf, "%u\n", _gov##_tuners.object);		\
+	struct dbs_data *dbs_data = policy->governor_data;		\
+	struct _gov##_dbs_tuners *tuners = dbs_data->tuners;		\
+	return sprintf(buf, "%u\n", tuners->file_name);			\
 }
 
 #define define_get_cpu_dbs_routines(_dbs_info)				\
@@ -103,7 +105,7 @@ struct cs_cpu_dbs_info_s {
 	unsigned int enable:1;
 };
 
-/* Governers sysfs tunables */
+/* Per policy Governers sysfs tunables */
 struct od_dbs_tuners {
 	unsigned int ignore_nice;
 	unsigned int sampling_rate;
@@ -123,31 +125,38 @@ struct cs_dbs_tuners {
 	unsigned int freq_step;
 };
 
-/* Per Governer data */
-struct dbs_data {
+/* Common Governer data across policies */
+struct dbs_data;
+struct common_dbs_data {
 	/* Common across governors */
 	#define GOV_ONDEMAND		0
 	#define GOV_CONSERVATIVE	1
 	int governor;
-	unsigned int min_sampling_rate;
 	struct attribute_group *attr_group;
-	void *tuners;
-
-	/* dbs_mutex protects dbs_enable in governor start/stop */
-	struct mutex mutex;
 
 	struct cpu_dbs_common_info *(*get_cpu_cdbs)(int cpu);
 	void *(*get_cpu_dbs_info_s)(int cpu);
 	void (*gov_dbs_timer)(struct work_struct *work);
 	void (*gov_check_cpu)(int cpu, unsigned int load);
+	int (*init)(struct dbs_data *dbs_data);
+	void (*exit)(struct dbs_data *dbs_data);
 
 	/* Governor specific ops, see below */
 	void *gov_ops;
 };
 
+/* Governer Per policy data */
+struct dbs_data {
+	struct common_dbs_data *cdata;
+	unsigned int min_sampling_rate;
+	void *tuners;
+
+	/* dbs_mutex protects dbs_enable in governor start/stop */
+	struct mutex mutex;
+};
+
 /* Governor specific ops, will be passed to dbs_data->gov_ops */
 struct od_ops {
-	int (*io_busy)(void);
 	void (*powersave_bias_init_cpu)(int cpu);
 	unsigned int (*powersave_bias_target)(struct cpufreq_policy *policy,
 			unsigned int freq_next, unsigned int relation);
@@ -169,10 +178,18 @@ static inline int delay_for_sampling_rate(unsigned int sampling_rate)
 	return delay;
 }
 
+#define declare_show_sampling_rate_min()				\
+static ssize_t show_sampling_rate_min(struct cpufreq_policy *policy,	\
+		char *buf)						\
+{									\
+	struct dbs_data *dbs_data = policy->governor_data;		\
+	return sprintf(buf, "%u\n", dbs_data->min_sampling_rate);	\
+}
+
 u64 get_cpu_idle_time(unsigned int cpu, u64 *wall);
 void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
 bool need_load_eval(struct cpu_dbs_common_info *cdbs,
 		unsigned int sampling_rate);
-int cpufreq_governor_dbs(struct dbs_data *dbs_data,
-		struct cpufreq_policy *policy, unsigned int event);
+int cpufreq_governor_dbs(struct cpufreq_policy *policy,
+		struct common_dbs_data *cdata, unsigned int event);
 #endif /* _CPUFREQ_GOVERNER_H */
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 09b27ae..f2539e0 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/percpu-defs.h>
+#include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/tick.h>
 #include <linux/types.h>
@@ -37,22 +38,12 @@
 #define MIN_FREQUENCY_UP_THRESHOLD		(11)
 #define MAX_FREQUENCY_UP_THRESHOLD		(100)
 
-static struct dbs_data od_dbs_data;
 static DEFINE_PER_CPU(struct od_cpu_dbs_info_s, od_cpu_dbs_info);
 
 #ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
 static struct cpufreq_governor cpufreq_gov_ondemand;
 #endif
 
-static struct od_dbs_tuners od_tuners = {
-	.up_threshold = DEF_FREQUENCY_UP_THRESHOLD,
-	.sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR,
-	.adj_up_threshold = DEF_FREQUENCY_UP_THRESHOLD -
-			    DEF_FREQUENCY_DOWN_DIFFERENTIAL,
-	.ignore_nice = 0,
-	.powersave_bias = 0,
-};
-
 static void ondemand_powersave_bias_init_cpu(int cpu)
 {
 	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
@@ -98,6 +89,8 @@ static unsigned int powersave_bias_target(struct cpufreq_policy *policy,
 	unsigned int jiffies_total, jiffies_hi, jiffies_lo;
 	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info,
 						   policy->cpu);
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 
 	if (!dbs_info->freq_table) {
 		dbs_info->freq_lo = 0;
@@ -108,7 +101,7 @@ static unsigned int powersave_bias_target(struct cpufreq_policy *policy,
 	cpufreq_frequency_table_target(policy, dbs_info->freq_table, freq_next,
 			relation, &index);
 	freq_req = dbs_info->freq_table[index].frequency;
-	freq_reduc = freq_req * od_tuners.powersave_bias / 1000;
+	freq_reduc = freq_req * od_tuners->powersave_bias / 1000;
 	freq_avg = freq_req - freq_reduc;
 
 	/* Find freq bounds for freq_avg in freq_table */
@@ -127,7 +120,7 @@ static unsigned int powersave_bias_target(struct cpufreq_policy *policy,
 		dbs_info->freq_lo_jiffies = 0;
 		return freq_lo;
 	}
-	jiffies_total = usecs_to_jiffies(od_tuners.sampling_rate);
+	jiffies_total = usecs_to_jiffies(od_tuners->sampling_rate);
 	jiffies_hi = (freq_avg - freq_lo) * jiffies_total;
 	jiffies_hi += ((freq_hi - freq_lo) / 2);
 	jiffies_hi /= (freq_hi - freq_lo);
@@ -148,12 +141,15 @@ static void ondemand_powersave_bias_init(void)
 
 static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 {
-	if (od_tuners.powersave_bias)
+	struct dbs_data *dbs_data = p->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+
+	if (od_tuners->powersave_bias)
 		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
 	else if (p->cur == p->max)
 		return;
 
-	__cpufreq_driver_target(p, freq, od_tuners.powersave_bias ?
+	__cpufreq_driver_target(p, freq, od_tuners->powersave_bias ?
 			CPUFREQ_RELATION_L : CPUFREQ_RELATION_H);
 }
 
@@ -170,15 +166,17 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 {
 	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 
 	dbs_info->freq_lo = 0;
 
 	/* Check for frequency increase */
-	if (load_freq > od_tuners.up_threshold * policy->cur) {
+	if (load_freq > od_tuners->up_threshold * policy->cur) {
 		/* If switching to max speed, apply sampling_down_factor */
 		if (policy->cur < policy->max)
 			dbs_info->rate_mult =
-				od_tuners.sampling_down_factor;
+				od_tuners->sampling_down_factor;
 		dbs_freq_increase(policy, policy->max);
 		return;
 	}
@@ -193,9 +191,10 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 	 * support the current CPU usage without triggering the up policy. To be
 	 * safe, we focus 10 points under the threshold.
 	 */
-	if (load_freq < od_tuners.adj_up_threshold * policy->cur) {
+	if (load_freq < od_tuners->adj_up_threshold
+			* policy->cur) {
 		unsigned int freq_next;
-		freq_next = load_freq / od_tuners.adj_up_threshold;
+		freq_next = load_freq / od_tuners->adj_up_threshold;
 
 		/* No longer fully busy, reset rate_mult */
 		dbs_info->rate_mult = 1;
@@ -203,7 +202,7 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 		if (freq_next < policy->min)
 			freq_next = policy->min;
 
-		if (!od_tuners.powersave_bias) {
+		if (!od_tuners->powersave_bias) {
 			__cpufreq_driver_target(policy, freq_next,
 					CPUFREQ_RELATION_L);
 		} else {
@@ -223,12 +222,14 @@ static void od_dbs_timer(struct work_struct *work)
 	unsigned int cpu = dbs_info->cdbs.cur_policy->cpu;
 	struct od_cpu_dbs_info_s *core_dbs_info = &per_cpu(od_cpu_dbs_info,
 			cpu);
+	struct dbs_data *dbs_data = dbs_info->cdbs.cur_policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	int delay, sample_type = core_dbs_info->sample_type;
 	bool eval_load;
 
 	mutex_lock(&core_dbs_info->cdbs.timer_mutex);
 	eval_load = need_load_eval(&core_dbs_info->cdbs,
-			od_tuners.sampling_rate);
+			od_tuners->sampling_rate);
 
 	/* Common NORMAL_SAMPLE setup */
 	core_dbs_info->sample_type = OD_NORMAL_SAMPLE;
@@ -240,13 +241,13 @@ static void od_dbs_timer(struct work_struct *work)
 						CPUFREQ_RELATION_H);
 	} else {
 		if (eval_load)
-			dbs_check_cpu(&od_dbs_data, cpu);
+			dbs_check_cpu(dbs_data, cpu);
 		if (core_dbs_info->freq_lo) {
 			/* Setup timer for SUB_SAMPLE */
 			core_dbs_info->sample_type = OD_SUB_SAMPLE;
 			delay = core_dbs_info->freq_hi_jiffies;
 		} else {
-			delay = delay_for_sampling_rate(od_tuners.sampling_rate
+			delay = delay_for_sampling_rate(od_tuners->sampling_rate
 						* core_dbs_info->rate_mult);
 		}
 	}
@@ -256,13 +257,6 @@ static void od_dbs_timer(struct work_struct *work)
 }
 
 /************************** sysfs interface ************************/
-
-static ssize_t show_sampling_rate_min(struct kobject *kobj,
-				      struct attribute *attr, char *buf)
-{
-	return sprintf(buf, "%u\n", od_dbs_data.min_sampling_rate);
-}
-
 /**
  * update_sampling_rate - update sampling rate effective immediately if needed.
  * @new_rate: new sampling rate
@@ -276,12 +270,14 @@ static ssize_t show_sampling_rate_min(struct kobject *kobj,
  * reducing the sampling rate, we need to make the new value effective
  * immediately.
  */
-static void update_sampling_rate(unsigned int new_rate)
+static void update_sampling_rate(struct dbs_data *dbs_data,
+		unsigned int new_rate)
 {
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	int cpu;
 
-	od_tuners.sampling_rate = new_rate = max(new_rate,
-			od_dbs_data.min_sampling_rate);
+	od_tuners->sampling_rate = new_rate = max(new_rate,
+			dbs_data->min_sampling_rate);
 
 	for_each_online_cpu(cpu) {
 		struct cpufreq_policy *policy;
@@ -322,34 +318,39 @@ static void update_sampling_rate(unsigned int new_rate)
 	}
 }
 
-static ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
-				   const char *buf, size_t count)
+static ssize_t store_sampling_rate(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 	if (ret != 1)
 		return -EINVAL;
-	update_sampling_rate(input);
+	update_sampling_rate(dbs_data, input);
 	return count;
 }
 
-static ssize_t store_io_is_busy(struct kobject *a, struct attribute *b,
-				   const char *buf, size_t count)
+static ssize_t store_io_is_busy(struct cpufreq_policy *policy, const char *buf,
+		size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 
 	ret = sscanf(buf, "%u", &input);
 	if (ret != 1)
 		return -EINVAL;
-	od_tuners.io_is_busy = !!input;
+	od_tuners->io_is_busy = !!input;
 	return count;
 }
 
-static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
-				  const char *buf, size_t count)
+static ssize_t store_up_threshold(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
@@ -359,23 +360,25 @@ static ssize_t store_up_threshold(struct kobject *a, struct attribute *b,
 		return -EINVAL;
 	}
 	/* Calculate the new adj_up_threshold */
-	od_tuners.adj_up_threshold += input;
-	od_tuners.adj_up_threshold -= od_tuners.up_threshold;
+	od_tuners->adj_up_threshold += input;
+	od_tuners->adj_up_threshold -= od_tuners->up_threshold;
 
-	od_tuners.up_threshold = input;
+	od_tuners->up_threshold = input;
 	return count;
 }
 
-static ssize_t store_sampling_down_factor(struct kobject *a,
-			struct attribute *b, const char *buf, size_t count)
+static ssize_t store_sampling_down_factor(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	unsigned int input, j;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
 
 	if (ret != 1 || input > MAX_SAMPLING_DOWN_FACTOR || input < 1)
 		return -EINVAL;
-	od_tuners.sampling_down_factor = input;
+	od_tuners->sampling_down_factor = input;
 
 	/* Reset down sampling multiplier in case it was active */
 	for_each_online_cpu(j) {
@@ -386,9 +389,11 @@ static ssize_t store_sampling_down_factor(struct kobject *a,
 	return count;
 }
 
-static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
-				      const char *buf, size_t count)
+static ssize_t store_ignore_nice(struct cpufreq_policy *policy, const char *buf,
+		size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 
@@ -401,10 +406,10 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 	if (input > 1)
 		input = 1;
 
-	if (input == od_tuners.ignore_nice) { /* nothing to do */
+	if (input == od_tuners->ignore_nice) { /* nothing to do */
 		return count;
 	}
-	od_tuners.ignore_nice = input;
+	od_tuners->ignore_nice = input;
 
 	/* we need to re-evaluate prev_cpu_idle */
 	for_each_online_cpu(j) {
@@ -412,7 +417,7 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 		dbs_info = &per_cpu(od_cpu_dbs_info, j);
 		dbs_info->cdbs.prev_cpu_idle = get_cpu_idle_time(j,
 						&dbs_info->cdbs.prev_cpu_wall);
-		if (od_tuners.ignore_nice)
+		if (od_tuners->ignore_nice)
 			dbs_info->cdbs.prev_cpu_nice =
 				kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 
@@ -420,9 +425,11 @@ static ssize_t store_ignore_nice_load(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-static ssize_t store_powersave_bias(struct kobject *a, struct attribute *b,
-				    const char *buf, size_t count)
+static ssize_t store_powersave_bias(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
+	struct dbs_data *dbs_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 	unsigned int input;
 	int ret;
 	ret = sscanf(buf, "%u", &input);
@@ -433,7 +440,7 @@ static ssize_t store_powersave_bias(struct kobject *a, struct attribute *b,
 	if (input > 1000)
 		input = 1000;
 
-	od_tuners.powersave_bias = input;
+	od_tuners->powersave_bias = input;
 	ondemand_powersave_bias_init();
 	return count;
 }
@@ -442,23 +449,24 @@ show_one(od, sampling_rate, sampling_rate);
 show_one(od, io_is_busy, io_is_busy);
 show_one(od, up_threshold, up_threshold);
 show_one(od, sampling_down_factor, sampling_down_factor);
-show_one(od, ignore_nice_load, ignore_nice);
+show_one(od, ignore_nice, ignore_nice);
 show_one(od, powersave_bias, powersave_bias);
+declare_show_sampling_rate_min();
 
-define_one_global_rw(sampling_rate);
-define_one_global_rw(io_is_busy);
-define_one_global_rw(up_threshold);
-define_one_global_rw(sampling_down_factor);
-define_one_global_rw(ignore_nice_load);
-define_one_global_rw(powersave_bias);
-define_one_global_ro(sampling_rate_min);
+cpufreq_freq_attr_rw(sampling_rate);
+cpufreq_freq_attr_rw(io_is_busy);
+cpufreq_freq_attr_rw(up_threshold);
+cpufreq_freq_attr_rw(sampling_down_factor);
+cpufreq_freq_attr_rw(ignore_nice);
+cpufreq_freq_attr_rw(powersave_bias);
+cpufreq_freq_attr_ro(sampling_rate_min);
 
 static struct attribute *dbs_attributes[] = {
 	&sampling_rate_min.attr,
 	&sampling_rate.attr,
 	&up_threshold.attr,
 	&sampling_down_factor.attr,
-	&ignore_nice_load.attr,
+	&ignore_nice.attr,
 	&powersave_bias.attr,
 	&io_is_busy.attr,
 	NULL
@@ -471,30 +479,81 @@ static struct attribute_group od_attr_group = {
 
 /************************** sysfs end ************************/
 
+static int od_init(struct dbs_data *dbs_data)
+{
+	struct od_dbs_tuners *tuners;
+	u64 idle_time;
+	int cpu;
+
+	tuners = kzalloc(sizeof(struct od_dbs_tuners), GFP_KERNEL);
+	if (!tuners) {
+		pr_err("%s: kzalloc failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	cpu = get_cpu();
+	idle_time = get_cpu_idle_time_us(cpu, NULL);
+	put_cpu();
+	if (idle_time != -1ULL) {
+		/* Idle micro accounting is supported. Use finer thresholds */
+		tuners->up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
+		tuners->adj_up_threshold = MICRO_FREQUENCY_UP_THRESHOLD -
+			MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
+		/*
+		 * In nohz/micro accounting case we set the minimum frequency
+		 * not depending on HZ, but fixed (very low). The deferred
+		 * timer might skip some samples if idle/sleeping as needed.
+		*/
+		dbs_data->min_sampling_rate = MICRO_FREQUENCY_MIN_SAMPLE_RATE;
+	} else {
+		tuners->up_threshold = DEF_FREQUENCY_UP_THRESHOLD;
+		tuners->adj_up_threshold = DEF_FREQUENCY_UP_THRESHOLD -
+			DEF_FREQUENCY_DOWN_DIFFERENTIAL;
+
+		/* For correct statistics, we need 10 ticks for each measure */
+		dbs_data->min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
+			jiffies_to_usecs(10);
+	}
+
+	tuners->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
+	tuners->ignore_nice = 0;
+	tuners->powersave_bias = 0;
+	tuners->io_is_busy = should_io_be_busy();
+
+	dbs_data->tuners = tuners;
+	mutex_init(&dbs_data->mutex);
+	return 0;
+}
+
+static void od_exit(struct dbs_data *dbs_data)
+{
+	kfree(dbs_data->tuners);
+}
+
 define_get_cpu_dbs_routines(od_cpu_dbs_info);
 
 static struct od_ops od_ops = {
-	.io_busy = should_io_be_busy,
 	.powersave_bias_init_cpu = ondemand_powersave_bias_init_cpu,
 	.powersave_bias_target = powersave_bias_target,
 	.freq_increase = dbs_freq_increase,
 };
 
-static struct dbs_data od_dbs_data = {
+static struct common_dbs_data od_dbs_cdata = {
 	.governor = GOV_ONDEMAND,
 	.attr_group = &od_attr_group,
-	.tuners = &od_tuners,
 	.get_cpu_cdbs = get_cpu_cdbs,
 	.get_cpu_dbs_info_s = get_cpu_dbs_info_s,
 	.gov_dbs_timer = od_dbs_timer,
 	.gov_check_cpu = od_check_cpu,
 	.gov_ops = &od_ops,
+	.init = od_init,
+	.exit = od_exit,
 };
 
 static int od_cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		unsigned int event)
 {
-	return cpufreq_governor_dbs(&od_dbs_data, policy, event);
+	return cpufreq_governor_dbs(policy, &od_dbs_cdata, event);
 }
 
 #ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
@@ -509,29 +568,6 @@ struct cpufreq_governor cpufreq_gov_ondemand = {
 
 static int __init cpufreq_gov_dbs_init(void)
 {
-	u64 idle_time;
-	int cpu = get_cpu();
-
-	mutex_init(&od_dbs_data.mutex);
-	idle_time = get_cpu_idle_time_us(cpu, NULL);
-	put_cpu();
-	if (idle_time != -1ULL) {
-		/* Idle micro accounting is supported. Use finer thresholds */
-		od_tuners.up_threshold = MICRO_FREQUENCY_UP_THRESHOLD;
-		od_tuners.adj_up_threshold = MICRO_FREQUENCY_UP_THRESHOLD -
-					     MICRO_FREQUENCY_DOWN_DIFFERENTIAL;
-		/*
-		 * In nohz/micro accounting case we set the minimum frequency
-		 * not depending on HZ, but fixed (very low). The deferred
-		 * timer might skip some samples if idle/sleeping as needed.
-		*/
-		od_dbs_data.min_sampling_rate = MICRO_FREQUENCY_MIN_SAMPLE_RATE;
-	} else {
-		/* For correct statistics, we need 10 ticks for each measure */
-		od_dbs_data.min_sampling_rate = MIN_SAMPLING_RATE_RATIO *
-			jiffies_to_usecs(10);
-	}
-
 	return cpufreq_register_governor(&cpufreq_gov_ondemand);
 }
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 3b822ce..c5ac9a5 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,6 +107,11 @@ struct cpufreq_policy {
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
+	/* This should be set by init() of platforms having multiple
+	 * clock-domains, i.e.  supporting multiple policies. With this sysfs
+	 * directories of governor would be created in cpu/cpu<num>/cpufreq/
+	 * directory */
+	bool			have_multiple_policies;
 
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */
@@ -134,6 +139,15 @@ static inline bool policy_is_shared(struct cpufreq_policy *policy)
 	return cpumask_weight(policy->cpus) > 1;
 }
 
+static inline struct kobject *
+get_governor_parent_kobj(struct cpufreq_policy *policy)
+{
+	if (policy->have_multiple_policies)
+		return &policy->kobj;
+	else
+		return cpufreq_global_kobject;
+}
+
 /******************** cpufreq transition notifiers *******************/
 
 #define CPUFREQ_PRECHANGE	(0)
@@ -183,11 +197,10 @@ static inline unsigned long cpufreq_scale(unsigned long old, u_int div, u_int mu
 #define CPUFREQ_GOV_STOP	2
 #define CPUFREQ_GOV_LIMITS	3
 #define CPUFREQ_GOV_POLICY_INIT	4
-#define CPUFREQ_GOV_POLICY_EXIT	4
+#define CPUFREQ_GOV_POLICY_EXIT	5
 
 struct cpufreq_governor {
 	char	name[CPUFREQ_NAME_LEN];
-	int	initialized;
 	int	(*governor)	(struct cpufreq_policy *policy,
 				 unsigned int event);
 	ssize_t	(*show_setspeed)	(struct cpufreq_policy *policy,
-- 
1.7.12.rc2.18.g61b472e


