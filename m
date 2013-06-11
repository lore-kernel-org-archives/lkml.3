Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3FKJEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:04:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17014 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3FKJEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:04:52 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-7f-51b6e833a9b2
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
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v2 1/3] cpufreq:boost: CPU frequency boost code unification for
 software and hardware solutions
Date: Tue, 11 Jun 2013 11:03:26 +0200
Message-id: <1370941408-29304-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jQV3jF9sCDea9UbX483Y5q8XTph/s
	FvM+y1p0nn3CbNG74CqbxZtH3BZvHm5mtLi8aw6bxefeI4wWtxtXsFn0L+xlsug48o3ZYuNX
	DwdejzvX9rB5rJv2ltmjb8sqRo9Hi1sYPT5vkgtgjeKySUnNySxLLdK3S+DKmPtDtGChb8Wc
	RROZGxg/2HUxcnJICJhI7PmwlgXCFpO4cG89G4gtJDCdUWL3h3gIu4tJYmGbJIjNJqAn8fnu
	UyYQW0TAV6Jn2SEgm4uDWeAts8S3hX+BHA4OYYFCiX/bA0FqWARUJZou7mUFsXkF3CT2/bnP
	DrFLXuLp/T6wXZwC7hKPX++C2tvEKLHzS84ERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYLD8Jn0DsZVDRaHGAU4GJV4eBMYtwUKsSaWFVfmHmKU4GBWEuE13Q4U4k1JrKxKLcqP
	LyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLjMdfHGIHXPvkSOlU/a2M/d
	vd69u1LKLOsy96kjQrf6J81b+FSFc4HXlCPrOn+ILpmofe1mTkL5q1cblN/sZFVeWR3pG8Ba
	LtI58Z/O0k4J70UqU60npadvu3rZ6YAo//bqyOdfc4yvVh19qrf3ROol3TD7vZO6C+zOzF3w
	N/1lVLzxxVb73Z5KLMUZiYZazEXFiQCL1mhAPwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for software based frequency boosting.
Some SoC (like Exynos4 - e.g. 4x12) allow setting frequency above
its normal condition limits. Such a change shall be only done for a short
time.

Overclocking (boost) support is essentially provided by platform
dependent cpufreq driver.

This commit unifies support for SW and HW (Intel) over clocking solutions
in the core cpufreq driver. Previously the "boost" sysfs attribute was
defined at acpi driver code.
By default boost is disabled. One global attribute is available at:
/sys/devices/system/cpu/cpufreq/boost.
It only shows up when cpufreq driver supports overclocking.
Under the hood frequencies dedicated for boosting are marked with a
special flag (CPUFREQ_BOOST_FREQ) at driver's frequency table.
It is the user's concern to enable/disable overclocking with proper call to
sysfs.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
Changes for v2:
- Removal of cpufreq_boost structure and move its fields to cpufreq_driver
  structure
- Flag to indicate if global boost attribute is already defined
- Extent the pr_{err|debbug} functions to show current function names
---
 drivers/cpufreq/cpufreq.c    |   69 ++++++++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/freq_table.c |   57 ++++++++++++++++++++++++++++++++--
 include/linux/cpufreq.h      |   12 ++++++++
 3 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1b8a48e..98ba5f1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -40,6 +40,7 @@
  * also protects the cpufreq_cpu_data array.
  */
 static struct cpufreq_driver *cpufreq_driver;
+static bool cpufreq_boost_sysfs_defined;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
@@ -315,6 +316,33 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
+ssize_t show_boost_status(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", cpufreq_driver->boost_en);
+}
+
+static ssize_t store_boost_status(struct kobject *kobj, struct attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret, enable;
+
+	ret = sscanf(buf, "%d", &enable);
+	if (ret != 1 || enable < 0 || enable > 1)
+		return -EINVAL;
+
+	if (cpufreq_boost_trigger_state(enable)) {
+		pr_err("%s: Cannot %sable boost!\n", __func__,
+		       enable ? "en" : "dis");
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static struct global_attr global_boost = __ATTR(boost, 0644,
+						show_boost_status,
+						store_boost_status);
 
 static struct cpufreq_governor *__find_governor(const char *str_governor)
 {
@@ -754,6 +782,17 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 			goto err_out_kobj_put;
 		drv_attr++;
 	}
+	if (cpufreq_driver->low_level_boost && !cpufreq_boost_sysfs_defined) {
+		ret = sysfs_create_file(cpufreq_global_kobject,
+					&(global_boost.attr));
+		if (ret) {
+			pr_err("%s: cannot register global boost sysfs file\n",
+				__func__);
+			goto err_out_kobj_put;
+		}
+		cpufreq_boost_sysfs_defined = 1;
+	}
+
 	if (cpufreq_driver->get) {
 		ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
 		if (ret)
@@ -1853,6 +1892,30 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
 };
 
 /*********************************************************************
+ *               BOOST						     *
+ *********************************************************************/
+int cpufreq_boost_trigger_state(int state)
+{
+	int ret = 0;
+
+	if (!cpufreq_driver->low_level_boost)
+		return -ENODEV;
+
+	if (cpufreq_driver->boost_en != state) {
+		ret = cpufreq_driver->low_level_boost(state);
+		if (ret) {
+			pr_err("%s: BOOST cannot %sable low level code (%d)\n",
+			       __func__, state ? "en" : "dis", ret);
+			return ret;
+		}
+	}
+
+	pr_debug("%s: cpufreq BOOST %sabled\n", __func__, state ? "en" : "dis");
+
+	return 0;
+}
+
+/*********************************************************************
  *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
  *********************************************************************/
 
@@ -1947,6 +2010,12 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	pr_debug("unregistering driver %s\n", driver->name);
 
 	subsys_interface_unregister(&cpufreq_interface);
+
+	if (cpufreq_driver->low_level_boost && cpufreq_boost_sysfs_defined) {
+		sysfs_remove_file(cpufreq_global_kobject, &(global_boost.attr));
+		cpufreq_boost_sysfs_defined = 0;
+	}
+
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index d7a7966..4e4f692 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -20,6 +20,27 @@
  *                     FREQUENCY TABLE HELPERS                       *
  *********************************************************************/
 
+unsigned int
+cpufreq_frequency_table_max(struct cpufreq_frequency_table *freq_table,
+			    int boost)
+{
+	int i = 0, boost_freq_max = 0, freq_max = 0;
+
+	for (; freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
+		if (freq_table[i].index == CPUFREQ_BOOST_FREQ) {
+			if (freq_table[i].frequency > boost_freq_max)
+				boost_freq_max = freq_table[i].frequency;
+		} else {
+			if (freq_table[i].frequency > freq_max)
+				freq_max = freq_table[i].frequency;
+		}
+	}
+
+	return boost ? boost_freq_max : freq_max;
+
+}
+EXPORT_SYMBOL_GPL(cpufreq_frequency_table_max);
+
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 				    struct cpufreq_frequency_table *table)
 {
@@ -171,7 +192,8 @@ static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
-static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
+static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
+				    int show_boost)
 {
 	unsigned int i = 0;
 	unsigned int cpu = policy->cpu;
@@ -186,22 +208,53 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
+		if (show_boost)
+			if (table[i].index != CPUFREQ_BOOST_FREQ)
+				continue;
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
+					   char *buf)
+{
+	return show_available_freqs(policy, buf, 0);
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
+	return show_available_freqs(policy, buf, 1);
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
index 037d36a..d045da2 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -262,6 +262,10 @@ struct cpufreq_driver {
 	int	(*suspend)	(struct cpufreq_policy *policy);
 	int	(*resume)	(struct cpufreq_policy *policy);
 	struct freq_attr	**attr;
+
+	/* platform specific boost support code */
+	bool                    boost_en;
+	int (*low_level_boost)  (int state);
 };
 
 /* flags */
@@ -403,6 +407,9 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_ENTRY_INVALID ~0
 #define CPUFREQ_TABLE_END     ~1
 
+/* Define index for boost frequency */
+#define CPUFREQ_BOOST_FREQ    ~2
+
 struct cpufreq_frequency_table {
 	unsigned int	index;     /* any */
 	unsigned int	frequency; /* kHz - doesn't need to be in ascending
@@ -421,11 +428,16 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int relation,
 				   unsigned int *index);
 
+unsigned int
+cpufreq_frequency_table_max(struct cpufreq_frequency_table *freq_table, int);
+int cpufreq_boost_trigger_state(int state);
+
 /* the following 3 funtions are for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
+extern struct freq_attr cpufreq_freq_attr_boost_available_freqs;
 
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
-- 
1.7.10.4

