Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3ITQBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:01:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25873 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3ITQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:01:38 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-df-523c71601a9f
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH RESEND v8 1/7] cpufreq: Add boost frequency support in core
Date: Fri, 20 Sep 2013 18:00:58 +0200
Message-id: <1379692864-4954-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1379692864-4954-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1379692864-4954-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jAd2EQpsggw9zRS02zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aLN4+4Ld483MxocXnXHDaLz71HGC1uN65gs+hf2Mtk8eRh
	H5vFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZcw5tJ6x4GRxxY2fDewNjCfiuxg5OSQETCSenFrMCmGLSVy4t56ti5GLQ0hgEaPE
	39OfWSGcLiaJVWfWM4JUsQnoSXy++5QJxBYRmMMoceeoO4jNLLCLWeLSJV0QW1jAW+LW82aw
	ehYBVYn+T6/ZQGxeAVeJ49/XMUJsk5d4er8PLM4p4Cbx+PM8FohljYwSb2ctYp3AyLuAkWEV
	o2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCwPpPawbiyweIQowAHoxIPb0eQTZAQa2JZcWXu
	IUYJDmYlEd7aAqAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYO
	TqkGxpWrv752/i3xYQZfl2T/bcan/9epCaYu3sbFfevXrX0vLAs5MkUXzDNUvM5z6+Fstnzl
	vWopiypkd681/7u7+KihpqNqjqf2JZdP6a+VXr1Pr+z9mNMt3i105s9ZOQvmqc/LPuluT/t6
	VpzhhNRCl7u6dfdSajTcpVfc0hX3f/pet8pKsEWnVYmlOCPRUIu5qDgRAL9ZVndSAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds boost frequency support in cpufreq core (Hardware &
Software). Some SoCs (like Exynos4 - e.g. 4x12) allow setting frequency
above its normal operation limits. Such mode shall be only used for a
short time.

Overclocking (boost) support is essentially provided by platform
dependent cpufreq driver.

This commit unifies support for SW and HW (Intel) overclocking solutions
in the core cpufreq driver. Previously the "boost" sysfs attribute was
defined at acpi driver code. By default boost is disabled. One global
attribute is available at: /sys/devices/system/cpu/cpufreq/boost.

It only shows up when cpufreq driver supports overclocking.
Under the hood frequencies dedicated for boosting are marked with a
special flag (CPUFREQ_BOOST_FREQ) at driver's frequency table.
It is the user's concern to enable/disable overclocking with a proper call
to sysfs.

The cpufreq_boost_trigger_state() function is defined non static on purpose.
It is used later with thermal subsystem to provide automatic enable/disable
of the BOOST feature.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v8:
- Correction of error message at cpufreq_boost_trigger_state() function
- Rewrite the cpufreq_boost_set_sw() function to print error message and
  break the loop when policy adjustment fails

Changes for v7:
- Properly change cpufreq_driver->boost_enabled when set_boost() fails
  (=0 to =!state)
- Add likely() around cpufreq_driver
- Remove parenthesis around boost.attr

Changes for v6:
- Remove sysfs boost attribute when subsys_iterface_unregister() fails
- Move global boost_enabled variable from cpufreq.c to platform dependent
  struct cpufreq_driver
- pr_err() message is also printed when boost disable fails
- Call __cpufreq_governor() to force recalculation of next frequency when
  boost is triggered. It is needed with i.e. performance class of governors
- Change cpufreq_boost_enable_sw() -> cpufreq_boost_set_sw()
- Rename .enable_boost function pointer to .set_boost

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

 drivers/cpufreq/cpufreq.c    |  118 +++++++++++++++++++++++++++++++++++++++++-
 drivers/cpufreq/freq_table.c |   53 ++++++++++++++++---
 include/linux/cpufreq.h      |   25 +++++++++
 3 files changed, 188 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5c75e31..b8b70a1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -344,6 +344,33 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
+ssize_t show_boost(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", cpufreq_driver->boost_enabled);
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
+		pr_err("%s: Cannot %s BOOST!\n", __func__,
+		       enable ? "enable" : "disable");
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
@@ -2010,6 +2037,73 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
 };
 
 /*********************************************************************
+ *               BOOST						     *
+ *********************************************************************/
+static int cpufreq_boost_set_sw(int state)
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
+			if (ret) {
+				pr_err("%s: Policy frequency update failed\n",
+				       __func__);
+				break;
+			}
+			policy->user_policy.max = policy->max;
+			__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
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
+	if (cpufreq_driver->boost_enabled == state)
+		return 0;
+
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	cpufreq_driver->boost_enabled = state;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+	ret = cpufreq_driver->set_boost(state);
+	if (ret) {
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		cpufreq_driver->boost_enabled = !state;
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+		pr_err("%s: Cannot %s BOOST\n", __func__,
+		       state ? "enable" : "disable");
+	}
+
+	return ret;
+}
+
+int cpufreq_boost_supported(void)
+{
+	if (likely(cpufreq_driver))
+		return cpufreq_driver->boost_supported;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cpufreq_boost_supported);
+
+int cpufreq_boost_enabled(void)
+{
+	return cpufreq_driver->boost_enabled;
+}
+EXPORT_SYMBOL_GPL(cpufreq_boost_enabled);
+
+/*********************************************************************
  *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
  *********************************************************************/
 
@@ -2048,9 +2142,25 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	if (cpufreq_boost_supported()) {
+		/*
+		 * Check if driver provides function to enable boost -
+		 * if not, use cpufreq_boost_set_sw as default
+		 */
+		if (!cpufreq_driver->set_boost)
+			cpufreq_driver->set_boost = cpufreq_boost_set_sw;
+
+		ret = cpufreq_sysfs_create_file(&boost.attr);
+		if (ret) {
+			pr_err("%s: cannot register global BOOST sysfs file\n",
+				__func__);
+			goto err_null_driver;
+		}
+	}
+
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
-		goto err_null_driver;
+		goto err_boost_unreg;
 
 	if (!(cpufreq_driver->flags & CPUFREQ_STICKY)) {
 		int i;
@@ -2077,6 +2187,9 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	return 0;
 err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
+err_boost_unreg:
+	if (cpufreq_boost_supported())
+		cpufreq_sysfs_remove_file(&boost.attr);
 err_null_driver:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
@@ -2103,6 +2216,9 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	pr_debug("unregistering driver %s\n", driver->name);
 
 	subsys_interface_unregister(&cpufreq_interface);
+	if (cpufreq_boost_supported())
+		cpufreq_sysfs_remove_file(&boost.attr);
+
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	down_write(&cpufreq_rwsem);
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index f111454a..d7eed63 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -32,6 +32,10 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 
 			continue;
 		}
+		if (!cpufreq_boost_enabled()
+		    && table[i].driver_data == CPUFREQ_BOOST_FREQ)
+			continue;
+
 		pr_debug("table entry %u: %u kHz, %u driver_data\n",
 					i, freq, table[i].driver_data);
 		if (freq < min_freq)
@@ -169,7 +173,8 @@ static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
-static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
+static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
+				    bool show_boost)
 {
 	unsigned int i = 0;
 	unsigned int cpu = policy->cpu;
@@ -184,6 +189,20 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
+		/*
+		 * show_boost = true and driver_data = BOOST freq
+		 * display BOOST freqs
+		 *
+		 * show_boost = false and driver_data = BOOST freq
+		 * show_boost = true and driver_data != BOOST freq
+		 * continue - do not display anything
+		 *
+		 * show_boost = false and driver_data != BOOST freq
+		 * display NON BOOST freqs
+		 */
+		if (show_boost ^ (table[i].driver_data == CPUFREQ_BOOST_FREQ))
+			continue;
+
 		count += sprintf(&buf[count], "%d ", table[i].frequency);
 	}
 	count += sprintf(&buf[count], "\n");
@@ -192,14 +211,34 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 
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
+	return show_available_freqs(policy, buf, false);
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
+	return show_available_freqs(policy, buf, true);
+}
+cpufreq_attr_available_freq(scaling_boost);
+EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_boost_freqs);
+
 /*
  * if you use these, you must assure that the frequency table is valid
  * all the time between get_attr and put_attr!
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index d568f39..541d032 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -209,6 +209,11 @@ struct cpufreq_driver {
 	int	(*suspend)	(struct cpufreq_policy *policy);
 	int	(*resume)	(struct cpufreq_policy *policy);
 	struct freq_attr	**attr;
+
+	/* platform specific boost support code */
+	bool                    boost_supported;
+	bool                    boost_enabled;
+	int     (*set_boost)    (int state);
 };
 
 /* flags */
@@ -381,6 +386,7 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
 
 #define CPUFREQ_ENTRY_INVALID ~0
 #define CPUFREQ_TABLE_END     ~1
+#define CPUFREQ_BOOST_FREQ    ~2
 
 struct cpufreq_frequency_table {
 	unsigned int	driver_data; /* driver specific data, not used by core */
@@ -403,11 +409,30 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);
 ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);
 
+#ifdef CONFIG_CPU_FREQ
+int cpufreq_boost_trigger_state(int state);
+int cpufreq_boost_supported(void);
+int cpufreq_boost_enabled(void);
+#else
+static inline int cpufreq_boost_trigger_state(int state)
+{
+	return 0;
+}
+static inline int cpufreq_boost_supported(void)
+{
+	return 0;
+}
+static inline int cpufreq_boost_enabled(void)
+{
+	return 0;
+}
+#endif
 /* the following funtion is for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
+extern struct freq_attr cpufreq_freq_attr_scaling_boost_freqs;
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
 void cpufreq_frequency_table_put_attr(unsigned int cpu);
-- 
1.7.10.4

