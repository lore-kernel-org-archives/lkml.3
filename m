Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955Ab3FSRNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:13:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20427 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934924Ab3FSRNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:13:13 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-5d-51c1e6a6a92e
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
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH v4 2/7] cpufreq: Add boost frequency support in core
Date: Wed, 19 Jun 2013 19:12:43 +0200
Message-id: <1371661969-7660-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jQd3lzw4GGvxsYbT483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbS43biCzaJ/YS+TxZOH
	fWwWHUe+MVts/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXxtEbj1kKpkZUbN7/l7mB8ZxHFyMnh4SAicSR32uYIGwxiQv31rN1MXJx
	CAlMZ5T4un8XC0hCSKCLSeLxhDgQm01AT+Lz3adgDSICvhI9yw4xgTQwC+xjkZj6rYMVJCEs
	4CLxdWkDI4jNIqAq8ef6K7AGXgFXiSn/37JCbJOXeHq/jw3E5hRwkzj+rQtqcyOjxNoND5gn
	MPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcts+kdjCubLA4xCjAwajEw6tx+WCg
	EGtiWXFl7iFGCQ5mJRHepUeBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqem
	FqQWwWSZODilGhhzrkZGhv/tbVL/7LzrSnOKjmrdXtVyi9S897HiEk9395/slvF1enpWe7J+
	/G9G5VmvWfZcvhNxwSfLa4f91RxtI9Xuxc2zLt/dc/3zG78FZ/R/iPOk2X3qteKOfl7WE9CX
	s8D6AY+q/v62Vz9CT3T+njr/QYP8tu0q/1/tuJ44deqGU4t+TRdUYinOSDTUYi4qTgQAtxCl
	sVcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds boost frequency support in cpufreq core (Hardware &
Software).
Some SoC (like Exynos4 - e.g. 4x12) allow setting frequency above
its normal operation limits. Such a mode shall be only used for a short
time.

Overclocking (boost) support is essentially provided by platform
dependent cpufreq driver.

This commit unifies support for SW and HW (Intel) over clocking solutions
in the core cpufreq driver. Previously the "boost" sysfs attribute was
defined at acpi driver code.
Boost sysfs attribute is always exported (to support legacy API). By
default boost is exported as read only. One global attribute is available at:
/sys/devices/system/cpu/cpufreq/boost.

Under the hood frequencies dedicated for boosting are marked with a
special flag (CPUFREQ_BOOST_FREQ) at driver's frequency table.
It is the user's concern to enable/disable overclocking with proper call to
sysfs.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Changes for v4:
- Remove boost parameter from cpufreq_frequency_table_cpuinfo() function
- Introduce cpufreq_boost_supported() method
- Use of cpufreq_boost_supported() and cpufreq_boost_enabled() to decide
  if frequency shall be skipped
- Rename set_boost_freq() to enable_boost()
- cpufreq_attr_available_freq() moved to freq_table.c
- Use policy list to get access to cpufreq policies
- Rename global boost flag (cpufreq_boost_enabled -> boost_enabled)
- pr_err corrected ( %sable)
- Remove sanity check at cpufreq_boost_trigger_state() entrance [to test if
  boost is supported]
- Use either HW (boost_enable) callback or SW managed boost
- Introduce new cpufreq_boost_trigger_state_sw() method to handle boost
  at SW.
- Protect boost_enabled manipulation with lock
- Always export boost attribute (preserve legacy behaviour). When boost
  is not supported this attribute is read only

Changes for v3:
- Method for reading boost status
- Removal of cpufreq_frequency_table_max()
- Extent cpufreq_frequency_table_cpuinfo() to support boost parameter
- boost_supported flag added to cpufreq_driver struct
- "boost" sysfs attribute control flag removed
- One global flag describing state of the boost defined at cpufreq core
- Rename cpufreq_driver's low_level_boost field to set_boost_freq()
- Usage of cpufreq_sysfs_{remove|add}_file() routines

Changes for v2:
- Removal of cpufreq_boost structure and move its fields to cpufreq_driver
  structure
- Flag to indicate if global boost attribute is already defined
- Extent the pr_{err|debbug} functions to show current function names
---
 drivers/cpufreq/cpufreq.c    |   95 ++++++++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/freq_table.c |   43 +++++++++++++++----
 include/linux/cpufreq.h      |   11 +++++
 3 files changed, 142 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 665e641..9141d33 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -40,6 +40,7 @@
  * also protects the cpufreq_cpu_data array.
  */
 static struct cpufreq_driver *cpufreq_driver;
+static bool boost_enabled;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
@@ -316,6 +317,29 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
+ssize_t show_boost(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", boost_enabled);
+}
+
+static ssize_t store_boost(struct kobject *kobj, struct attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret, enable;
+
+	ret = sscanf(buf, "%d", &enable);
+	if (ret != 1 || enable < 0 || enable > 1)
+		return -EINVAL;
+
+	if (cpufreq_boost_trigger_state(enable)) {
+		pr_err("%s: Cannot enable boost!\n", __func__);
+		return -EINVAL;
+	}
+
+	return count;
+}
+define_one_global_rw(boost);
 
 static struct cpufreq_governor *__find_governor(const char *str_governor)
 {
@@ -1898,6 +1922,65 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
 };
 
 /*********************************************************************
+ *               BOOST						     *
+ *********************************************************************/
+static int cpufreq_boost_trigger_state_sw(void)
+{
+	struct cpufreq_frequency_table *freq_table;
+	struct cpufreq_policy *policy;
+	int ret = -EINVAL;
+
+	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
+		freq_table = cpufreq_frequency_get_table(policy->cpu);
+		if (freq_table)
+			ret = cpufreq_frequency_table_cpuinfo(policy,
+							freq_table);
+	}
+
+	return ret;
+
+}
+int cpufreq_boost_trigger_state(int state)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (boost_enabled != state) {
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		boost_enabled = state;
+		if (cpufreq_driver->enable_boost)
+			ret = cpufreq_driver->enable_boost(state);
+		else
+			ret = cpufreq_boost_trigger_state_sw();
+
+		if (ret) {
+			boost_enabled = 0;
+			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+			pr_err("%s: BOOST cannot enable (%d)\n",
+			       __func__, ret);
+
+			return ret;
+		}
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+		pr_debug("%s: cpufreq BOOST %s\n", __func__,
+			 state ? "enabled" : "disabled");
+	}
+
+	return 0;
+}
+
+int cpufreq_boost_supported(void)
+{
+	return cpufreq_driver->boost_supported;
+}
+
+int cpufreq_boost_enabled(void)
+{
+	return boost_enabled;
+}
+
+/*********************************************************************
  *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
  *********************************************************************/
 
@@ -1936,6 +2019,16 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	if (!cpufreq_driver->boost_supported)
+		boost.attr.mode = 0444;
+
+	ret = cpufreq_sysfs_create_file(&(boost.attr));
+	if (ret) {
+		pr_err("%s: cannot register global boost sysfs file\n",
+		       __func__);
+		goto err_null_driver;
+	}
+
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
@@ -1992,6 +2085,8 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	pr_debug("unregistering driver %s\n", driver->name);
 
 	subsys_interface_unregister(&cpufreq_interface);
+
+	cpufreq_sysfs_remove_file(&(boost.attr));
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	list_del(&cpufreq_policy_list);
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index d7a7966..9c8e71e 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -34,6 +34,11 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 
 			continue;
 		}
+		if (cpufreq_boost_supported())
+			if (!cpufreq_boost_enabled()
+			    && table[i].index == CPUFREQ_BOOST_FREQ)
+				continue;
+
 		pr_debug("table entry %u: %u kHz, %u index\n",
 					i, freq, table[i].index);
 		if (freq < min_freq)
@@ -171,7 +176,8 @@ static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
-static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
+static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
+				    int show_boost)
 {
 	unsigned int i = 0;
 	unsigned int cpu = policy->cpu;
@@ -186,6 +192,9 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
+		if (show_boost ^ (table[i].index == CPUFREQ_BOOST_FREQ))
+			continue;
+
 		count += sprintf(&buf[count], "%d ", table[i].frequency);
 	}
 	count += sprintf(&buf[count], "\n");
@@ -194,14 +203,34 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 
 }
 
-struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
-	.attr = { .name = "scaling_available_frequencies",
-		  .mode = 0444,
-		},
-	.show = show_available_freqs,
-};
+#define cpufreq_attr_available_freq(_name)	  \
+struct freq_attr cpufreq_freq_attr_##_name##_freqs =     \
+__ATTR_RO(_name##_frequencies)
+
+/**
+ * show_scaling_available_frequencies - show normal boost frequencies for
+ * the specified CPU
+ */
+static ssize_t scaling_available_frequencies_show(struct cpufreq_policy *policy,
+						  char *buf)
+{
+	return show_available_freqs(policy, buf, 0);
+}
+cpufreq_attr_available_freq(scaling_available);
 EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_available_freqs);
 
+/**
+ * show_available_boost_freqs - show available boost frequencies for
+ * the specified CPU
+ */
+static ssize_t scaling_boost_frequencies_show(struct cpufreq_policy *policy,
+					      char *buf)
+{
+	return show_available_freqs(policy, buf, 1);
+}
+cpufreq_attr_available_freq(scaling_boost);
+EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_boost_freqs);
+
 /*
  * if you use these, you must assure that the frequency table is valid
  * all the time between get_attr and put_attr!
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 5348981..4783c4c 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -267,6 +267,10 @@ struct cpufreq_driver {
 	int	(*suspend)	(struct cpufreq_policy *policy);
 	int	(*resume)	(struct cpufreq_policy *policy);
 	struct freq_attr	**attr;
+
+	/* platform specific boost support code */
+	bool                    boost_supported;
+	int (*enable_boost)    (int state);
 };
 
 /* flags */
@@ -408,6 +412,9 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_ENTRY_INVALID ~0
 #define CPUFREQ_TABLE_END     ~1
 
+/* Define index for boost frequency */
+#define CPUFREQ_BOOST_FREQ    ~2
+
 struct cpufreq_frequency_table {
 	unsigned int	index;     /* any */
 	unsigned int	frequency; /* kHz - doesn't need to be in ascending
@@ -426,11 +433,15 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int relation,
 				   unsigned int *index);
 
+int cpufreq_boost_trigger_state(int state);
+int cpufreq_boost_supported(void);
+int cpufreq_boost_enabled(void);
 /* the following 3 funtions are for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
+extern struct freq_attr cpufreq_freq_attr_scaling_boost_freqs;
 
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
-- 
1.7.10.4

