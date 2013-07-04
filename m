Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab3GDIvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:51:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16724 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933702Ab3GDIvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:51:01 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-70-51d53773e772
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v5 2/7] cpufreq: Add boost frequency support in core
Date: Thu, 04 Jul 2013 10:50:25 +0200
Message-id: <1372927830-2949-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jAd1i86uBBqsb9Cz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4Ld483MxocXnXHDaLz71HGC1uN65gs+hf2Mtk8eRh
	H5vFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZUz7s4q9YEpKxZ1791kbGO8HdTFycEgImEhcaDbsYuQEMsUkLtxbzwZiCwksYpS4
	8T6ii5ELyO5iktjdcIgZJMEmoCfx+e5TJhBbRGAOo8Sdo+4gNrPASmaJE42OILawgIvEvo7N
	YPUsAqoSP95+AhvKK+AqcXn5Z2aIZfIST+/3gcU5BdwkLl/oYYJY1sgosaHjA8sERt4FjAyr
	GEVTC5ILipPSc430ihNzi0vz0vWS83M3MYID9Zn0DsZVDRaHGAU4GJV4eCWsrgQKsSaWFVfm
	HmKU4GBWEuF14rgaKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyW
	iYNTqoExeHOO763O2y3V2sdkTYUuS7oeN/j4Pc1uQSAv4/xdU1e8yN/X+Mqd6cMiLrH6tGTn
	DYmVYo9S1ulP11lkdkD00ra79Yd3au5Ryntx9NdRRsniw9tVJrEvu3Ck82XE+j3vz7UtS7zp
	wnFMZzn/40CmYL7rCXvCph2aICQQsefDPv+U2A2PjmhPVGIpzkg01GIuKk4EAMrL/vpQAgAA
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
Changes for v5:
- Rename cpufreq_boost_trigger_state_sw() to cpufreq_boost_enable_sw()
- Extent cpufreq_register_driver() to check if cpufreq driver provided
  boost_enable callback. If not provided, then use cpufreq_boost_enable_sw()
- Use single call to cpufreq_driver->enable_boost() with cpufreq driver
  provided callback or default SW boost enable routine
- Move pr_debug call to store_boost() from cpufreq_boost_trigger_state()
- Change the user_policy.max value when SW boost is toggled. It is necessary
  for proper operation of e.g. thermal subsystem.
- Add check if cpufreq_driver pointer is not NULL at
  cpufreq_boost_supported() routine
- Add EXPORT_SYMBOL_GPL for cpufreq_boost_supported() and
  cpufreq_boost_enabled()
- Remove extra check for cpufreq_boost_supported() at
  cpufreq_freq_table_cpuinfo()
- Explanation of show boost logic at show_available_freqs()
- Add cpufreq_set_boost_enabled() method to set initial value of boost_enabled
  global flag

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
- Protect boost_enabled manipulation with lock.

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

 drivers/cpufreq/cpufreq.c    |  112 ++++++++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/freq_table.c |   47 +++++++++++++++---
 include/linux/cpufreq.h      |   12 +++++
 3 files changed, 164 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 420ccb5..531189f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -43,6 +43,7 @@
  * also protects the cpufreq_cpu_data array.
  */
 static struct cpufreq_driver *cpufreq_driver;
+static bool boost_enabled;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 static DEFINE_MUTEX(cpufreq_governor_lock);
@@ -377,6 +378,32 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
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
+	pr_debug("%s: cpufreq BOOST %s\n", __func__,
+		 enable ? "enabled" : "disabled");
+
+	return count;
+}
+define_one_global_rw(boost);
 
 static struct cpufreq_governor *__find_governor(const char *str_governor)
 {
@@ -1963,6 +1990,72 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
 };
 
 /*********************************************************************
+ *               BOOST						     *
+ *********************************************************************/
+static int cpufreq_boost_enable_sw(int state)
+{
+	struct cpufreq_frequency_table *freq_table;
+	struct cpufreq_policy *policy;
+	int ret = -EINVAL;
+
+	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
+		freq_table = cpufreq_frequency_get_table(policy->cpu);
+		if (freq_table) {
+			ret = cpufreq_frequency_table_cpuinfo(policy,
+							freq_table);
+			if (!ret)
+				policy->user_policy.max = policy->max;
+		}
+	}
+
+	return ret;
+}
+
+int cpufreq_boost_trigger_state(int state)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (boost_enabled != state) {
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		boost_enabled = state;
+
+		ret = cpufreq_driver->enable_boost(state);
+		if (ret)
+			boost_enabled = 0;
+
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+		if (ret)
+			pr_err("%s: BOOST cannot enable (%d)\n",
+			       __func__, ret);
+	}
+
+	return ret;
+}
+
+int cpufreq_boost_supported(void)
+{
+	if (cpufreq_driver)
+		return cpufreq_driver->boost_supported;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpufreq_boost_supported);
+
+int cpufreq_boost_enabled(void)
+{
+	return boost_enabled;
+}
+EXPORT_SYMBOL_GPL(cpufreq_boost_enabled);
+
+void cpufreq_set_boost_enabled(int state)
+{
+	boost_enabled = state;
+}
+EXPORT_SYMBOL_GPL(cpufreq_set_boost_enabled);
+
+/*********************************************************************
  *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
  *********************************************************************/
 
@@ -2001,6 +2094,22 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	if (cpufreq_driver->boost_supported) {
+		/*
+		 * Check if boost driver provides function to enable boost -
+		 * if not, use cpufreq_boost_enable_sw as default
+		 */
+		if (!cpufreq_driver->enable_boost)
+			cpufreq_driver->enable_boost = &cpufreq_boost_enable_sw;
+
+		ret = cpufreq_sysfs_create_file(&(boost.attr));
+		if (ret) {
+			pr_err("%s: cannot register global boost sysfs file\n",
+				__func__);
+			goto err_null_driver;
+		}
+	}
+
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
@@ -2056,6 +2165,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	pr_debug("unregistering driver %s\n", driver->name);
 
 	subsys_interface_unregister(&cpufreq_interface);
+	if (cpufreq_driver->boost_supported)
+		cpufreq_sysfs_remove_file(&(boost.attr));
+
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	list_del(&cpufreq_policy_list);
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index f0d8741..490518f 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -34,6 +34,9 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 
 			continue;
 		}
+		if (!cpufreq_boost_enabled()
+		    && table[i].driver_data == CPUFREQ_BOOST_FREQ)
+			continue;
 		pr_debug("table entry %u: %u kHz, %u driver_data\n",
 					i, freq, table[i].driver_data);
 		if (freq < min_freq)
@@ -171,7 +174,8 @@ static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
-static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
+static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
+				    int show_boost)
 {
 	unsigned int i = 0;
 	unsigned int cpu = policy->cpu;
@@ -186,6 +190,15 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
+		/*
+		 * show_boost = true and driver_data = BOOST freq ->
+		 * display BOOST
+		 * show_boost = false and driver_data = BOOST freq -> continue
+		 * and display only non BOOST frequencies
+		 */
+		if (show_boost ^ (table[i].driver_data == CPUFREQ_BOOST_FREQ))
+			continue;
+
 		count += sprintf(&buf[count], "%d ", table[i].frequency);
 	}
 	count += sprintf(&buf[count], "\n");
@@ -194,14 +207,34 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 
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
+ * show_scaling_available_frequencies - show available normal frequencies for
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
index d8e30fc..3b50688 100644
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
@@ -411,6 +415,9 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_ENTRY_INVALID ~0
 #define CPUFREQ_TABLE_END     ~1
 
+/* Define index for boost frequency */
+#define CPUFREQ_BOOST_FREQ    ~2
+
 struct cpufreq_frequency_table {
 	unsigned int	driver_data; /* driver specific data, not used by core */
 	unsigned int	frequency; /* kHz - doesn't need to be in ascending
@@ -429,11 +436,16 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int relation,
 				   unsigned int *index);
 
+int cpufreq_boost_trigger_state(int state);
+void cpufreq_set_boost_enabled(int state);
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

