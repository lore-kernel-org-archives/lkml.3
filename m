Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3FFHJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:09:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11234 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab3FFHJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:09:24 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-52-51b035a21c83
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 2/5] cpufreq:boost: Add support for software based CPU
 frequency boost
Date: Thu, 06 Jun 2013 09:07:49 +0200
Message-id: <1370502472-7249-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jQd1FphsCDTZOUbb483Y5q8XTph/s
	FvM+y1p0nn3CbPHmEbfFm4ebGS0u75rDZvG59wijxe3GFWwW/Qt7mSw6jnxjttj41cOBx+PO
	tT1sHuumvWX26NuyitHj0eIWRo/Pm+QCWKO4bFJSczLLUov07RK4Mm5OfshecKqy4uvzCUwN
	jJ8Tuxg5OSQETCROnT/OAmGLSVy4t56ti5GLQ0hgOqPEne7vrBBOF5PEp8Mz2EGq2AT0JD7f
	fcoEYosI+Er0LDsEZjMLnGSWuHssEMQWFoiQ2Nh6Dmwqi4CqxOVjh8F6eQVcJd4d2csKsU1e
	4un9PjYQm1PATWLupxdgthBQzc0PK1kmMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREcgs+kdjCubLA4xCjAwajEwysRsD5QiDWxrLgy9xCjBAezkghvrMiGQCHelMTKqtSi/Pii
	0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2MASldph/kai5zPZX4WmT/b/LT
	oAtdqw++XbJqcZOFu97kSZs+fbc1CGX5u98hJSz4wzalEqbS6C7WgPVOveerJhvM2pvL9U/p
	Qabp4m8OoRqB4dkfs5adeLpsqrsIe+PjC0e2PPNWm5vhdd2zeG2K7CeR+/l2Fb3TX/mYt9pb
	RQbKp2p9n31LiaU4I9FQi7moOBEAe0QWGj0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for software based frequency boosting.
Exynos4 SoCs (e.g. 4x12) allow setting of frequency above its normal
condition limits. This can be done for some short time.

Overclocking (boost) support came from cpufreq driver (which is platform
dependent). Hence the data structure describing it is defined at its file.

To allow support for either SW and HW (Intel) based boosting, the cpufreq
core code has been extended to support both solutions.

The main boost switch has been put at /sys/devices/system/cpu/cpufreq/boost.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/cpufreq.c    |  156 ++++++++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/freq_table.c |   87 ++++++++++++++++++++++-
 include/linux/cpufreq.h      |   35 +++++++++-
 3 files changed, 275 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ca74e27..8cf9a92 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -133,6 +133,11 @@ bool have_governor_per_policy(void)
 	return cpufreq_driver->have_governor_per_policy;
 }
 
+/**
+ * Global definition of cpufreq_boost structure
+ */
+struct cpufreq_boost *cpufreq_boost;
+
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
 	struct cpufreq_policy *data;
@@ -315,6 +320,45 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
+ssize_t show_boost_status(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
+{
+	struct cpufreq_boost *boost = cpufreq_boost;
+
+	if (!boost)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", boost->status);
+}
+
+static ssize_t store_boost_status(struct kobject *kobj, struct attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct cpufreq_boost *boost = cpufreq_boost;
+	struct cpufreq_policy *p;
+	int ret, enable;
+
+	if (!boost)
+		return -ENODEV;
+
+	ret = sscanf(buf, "%d", &enable);
+	if (ret != 1 || enable < 0 || enable > 1)
+		return -EINVAL;
+
+	/* Adjust all policies to support boost */
+	list_for_each_entry(p, &boost->policies, boost_list)
+		if (cpufreq_boost_trigger_state(p, enable)) {
+			pr_err("Cannot %sable boost (policy 0x%p)!\n",
+			       enable ? "en" : "dis", p);
+			return -EINVAL;
+		}
+
+	return count;
+}
+
+static struct global_attr global_boost = __ATTR(boost, 0644,
+						show_boost_status,
+						store_boost_status);
 
 static struct cpufreq_governor *__find_governor(const char *str_governor)
 {
@@ -761,6 +805,18 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 	if (cpufreq_set_drv_attr_files(policy, cpufreq_driver->attr))
 		goto err_out_kobj_put;
 
+	if (cpufreq_driver->boost) {
+		if (sysfs_create_file(cpufreq_global_kobject,
+				      &(global_boost.attr)))
+			pr_warn("could not register global boost sysfs file\n");
+		else
+			pr_debug("registered global boost sysfs file\n");
+
+		if (cpufreq_set_drv_attr_files(policy,
+					       cpufreq_driver->boost->attr))
+			goto err_out_kobj_put;
+	}
+
 	if (cpufreq_driver->get) {
 		ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
 		if (ret)
@@ -923,6 +979,8 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
+	cpufreq_boost_init(policy);
+
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
@@ -1860,6 +1918,100 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
 };
 
 /*********************************************************************
+ *               BOOST						     *
+ *********************************************************************/
+int cpufreq_boost_trigger_state(struct cpufreq_policy *policy, int state)
+{
+	struct cpufreq_boost *boost;
+	unsigned long flags;
+	int ret = 0;
+
+	if (!policy || !policy->boost || !policy->boost->low_level_boost)
+		return -ENODEV;
+
+	boost = policy->boost;
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+
+	if (boost->status != state) {
+		policy->boost->status = state;
+		ret = boost->low_level_boost(policy, state);
+		if (ret) {
+			pr_err("BOOST cannot %sable low level code (%d)\n",
+			       state ? "en" : "dis", ret);
+			return ret;
+		}
+	}
+
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+	pr_debug("cpufreq BOOST %sabled\n", state ? "en" : "dis");
+
+	return 0;
+}
+
+/**
+ * cpufreq_boost_notifier - notifier callback for cpufreq policy change.
+ *  <at> nb:	struct notifier_block * with callback info.
+ *  <at> event: value showing cpufreq event for which this function invoked.
+ *  <at> data: callback-specific data
+ */
+static int cpufreq_boost_notifier(struct notifier_block *nb,
+				  unsigned long event, void *data)
+{
+	struct cpufreq_policy *policy = data;
+
+	if (event == CPUFREQ_INCOMPATIBLE) {
+		if (!policy || !policy->boost)
+			return -ENODEV;
+
+		if (policy->boost->status == CPUFREQ_BOOST_EN) {
+			pr_info("NOTIFIER BOOST: MAX: %d e:%lu cpu: %d\n",
+				policy->max, event, policy->cpu);
+			cpufreq_boost_trigger_state(policy, 0);
+		}
+	}
+
+	return 0;
+}
+
+/* Notifier for cpufreq policy change */
+static struct notifier_block cpufreq_boost_notifier_block = {
+	.notifier_call = cpufreq_boost_notifier,
+};
+
+int cpufreq_boost_init(struct cpufreq_policy *policy)
+{
+	int ret = 0;
+
+	if (!policy)
+		return -EINVAL;
+
+	if (!cpufreq_driver->boost) {
+		pr_err("Boost mode not supported on this device\n");
+		return -ENODEV;
+	}
+
+	policy->boost = cpufreq_boost = cpufreq_driver->boost;
+
+	/* disable boost for newly created policy - as we e.g. change
+	   governor */
+	policy->boost->status = CPUFREQ_BOOST_DIS;
+
+	/* register policy notifier */
+	ret = cpufreq_register_notifier(&cpufreq_boost_notifier_block,
+					CPUFREQ_POLICY_NOTIFIER);
+	if (ret) {
+		pr_err("CPUFREQ BOOST notifier not registered.\n");
+		return ret;
+	}
+	/* add policy to policies list headed at struct cpufreq_boost */
+	list_add_tail(&policy->boost_list, &cpufreq_boost->policies);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpufreq_boost_init);
+
+/*********************************************************************
  *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
  *********************************************************************/
 
@@ -1954,6 +2106,10 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	pr_debug("unregistering driver %s\n", driver->name);
 
 	subsys_interface_unregister(&cpufreq_interface);
+
+	if (cpufreq_driver->boost)
+		sysfs_remove_file(cpufreq_global_kobject, &(global_boost.attr));
+
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index d7a7966..0e95524 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -3,6 +3,8 @@
  *
  * Copyright (C) 2002 - 2003 Dominik Brodowski
  *
+ * Copyright (C) 2013 Lukasz Majewski <l.majewski@samsung.com>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -20,6 +22,36 @@
  *                     FREQUENCY TABLE HELPERS                       *
  *********************************************************************/
 
+/*********************************************************************
+ *                     BOOST FREQ HELPERS                            *
+ *********************************************************************/
+static int cpufreq_frequency_table_skip_boost(struct cpufreq_policy *policy,
+					      unsigned int index)
+{
+	if (index == CPUFREQ_BOOST)
+		if (!policy->boost ||
+		    policy->boost->status == CPUFREQ_BOOST_DIS)
+			return 1;
+
+	return 0;
+}
+
+unsigned int
+cpufreq_frequency_table_boost_max(struct cpufreq_frequency_table *freq_table)
+{
+	int index, boost_freq_max;
+
+	for (index = 0, boost_freq_max = 0;
+		freq_table[index].frequency != CPUFREQ_TABLE_END; index++)
+		if (freq_table[index].index == CPUFREQ_BOOST) {
+			if (freq_table[index].frequency > boost_freq_max)
+				boost_freq_max = freq_table[index].frequency;
+		}
+
+	return boost_freq_max;
+}
+EXPORT_SYMBOL_GPL(cpufreq_frequency_table_boost_max);
+
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 				    struct cpufreq_frequency_table *table)
 {
@@ -34,6 +66,10 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 
 			continue;
 		}
+		if (cpufreq_frequency_table_skip_boost(policy,
+						       table[i].index))
+			continue;
+
 		pr_debug("table entry %u: %u kHz, %u index\n",
 					i, freq, table[i].index);
 		if (freq < min_freq)
@@ -70,6 +106,9 @@ int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 		unsigned int freq = table[i].frequency;
 		if (freq == CPUFREQ_ENTRY_INVALID)
 			continue;
+		if (cpufreq_frequency_table_skip_boost(policy,
+						       table[i].index))
+			continue;
 		if ((freq >= policy->min) && (freq <= policy->max))
 			count++;
 		else if ((next_larger > freq) && (freq > policy->max))
@@ -122,6 +161,9 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		unsigned int freq = table[i].frequency;
 		if (freq == CPUFREQ_ENTRY_INVALID)
 			continue;
+		if (cpufreq_frequency_table_skip_boost(policy,
+						       table[i].index))
+			continue;
 		if ((freq < policy->min) || (freq > policy->max))
 			continue;
 		switch (relation) {
@@ -167,11 +209,15 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
 
+#define CPUFREQ_SHOW_NORMAL 0
+#define CPUFREQ_SHOW_BOOST  1
+
 static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
-static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
+static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
+				    int show_boost)
 {
 	unsigned int i = 0;
 	unsigned int cpu = policy->cpu;
@@ -186,22 +232,59 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
+
+		if (show_boost) {
+			if (table[i].index != CPUFREQ_BOOST)
+				continue;
+		} else {
+			if (cpufreq_frequency_table_skip_boost(policy,
+							       table[i].index))
+				continue;
+		}
+
 		count += sprintf(&buf[count], "%d ", table[i].frequency);
 	}
 	count += sprintf(&buf[count], "\n");
 
 	return count;
+}
 
+/**
+ * show_available_normal_freqs - show normal boost frequencies for
+ * the specified CPU
+ */
+static ssize_t show_available_normal_freqs(struct cpufreq_policy *policy,
+					  char *buf)
+{
+	return show_available_freqs(policy, buf, CPUFREQ_SHOW_NORMAL);
 }
 
 struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
 	.attr = { .name = "scaling_available_frequencies",
 		  .mode = 0444,
 		},
-	.show = show_available_freqs,
+	.show = show_available_normal_freqs,
 };
 EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_available_freqs);
 
+/**
+ * show_available_boost_freqs - show available boost frequencies for
+ * the specified CPU
+ */
+static ssize_t show_available_boost_freqs(struct cpufreq_policy *policy,
+					  char *buf)
+{
+	return show_available_freqs(policy, buf, CPUFREQ_SHOW_BOOST);
+}
+
+struct freq_attr cpufreq_freq_attr_boost_available_freqs = {
+	.attr = { .name = "scaling_boost_frequencies",
+		  .mode = 0444,
+		},
+	.show = show_available_boost_freqs,
+};
+EXPORT_SYMBOL_GPL(cpufreq_freq_attr_boost_available_freqs);
+
 /*
  * if you use these, you must assure that the frequency table is valid
  * all the time between get_attr and put_attr!
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 037d36a..1294c8c 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -88,6 +88,25 @@ struct cpufreq_real_policy {
 	struct cpufreq_governor	*governor; /* see below */
 };
 
+#define CPUFREQ_BOOST_DIS            (0)
+#define CPUFREQ_BOOST_EN             (1)
+
+struct cpufreq_policy;
+struct cpufreq_boost {
+	unsigned int            max_boost_freq; /* maximum value of
+						 * boosted freq */
+	unsigned int            max_normal_freq; /* non boost max freq */
+	int                     status; /* status of boost */
+
+	/* boost sysfs attributies */
+	struct freq_attr	**attr;
+
+	/* low-level trigger for boost */
+	int (*low_level_boost) (struct cpufreq_policy *policy, int state);
+
+	struct list_head        policies;
+};
+
 struct cpufreq_policy {
 	/* CPUs sharing clock, require sw coordination */
 	cpumask_var_t		cpus;	/* Online CPUs only */
@@ -113,6 +132,9 @@ struct cpufreq_policy {
 
 	struct cpufreq_real_policy	user_policy;
 
+	struct cpufreq_boost    *boost;
+	struct list_head        boost_list;
+
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 };
@@ -262,6 +284,9 @@ struct cpufreq_driver {
 	int	(*suspend)	(struct cpufreq_policy *policy);
 	int	(*resume)	(struct cpufreq_policy *policy);
 	struct freq_attr	**attr;
+
+	/* platform specific boost support code */
+	struct cpufreq_boost	*boost;
 };
 
 /* flags */
@@ -277,7 +302,6 @@ struct cpufreq_driver {
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
-
 void cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state);
 
@@ -403,6 +427,9 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_ENTRY_INVALID ~0
 #define CPUFREQ_TABLE_END     ~1
 
+/* Define index for boost frequency */
+#define CPUFREQ_BOOST         ~2
+
 struct cpufreq_frequency_table {
 	unsigned int	index;     /* any */
 	unsigned int	frequency; /* kHz - doesn't need to be in ascending
@@ -421,11 +448,17 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int relation,
 				   unsigned int *index);
 
+unsigned int
+cpufreq_frequency_table_boost_max(struct cpufreq_frequency_table *freq_table);
+int cpufreq_boost_init(struct cpufreq_policy *policy);
+
 /* the following 3 funtions are for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
+int cpufreq_boost_trigger_state(struct cpufreq_policy *policy, int state);
 
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
+extern struct freq_attr cpufreq_freq_attr_boost_available_freqs;
 
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
-- 
1.7.10.4

