Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3FNHjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:39:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48049 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3FNHj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:39:27 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-23-51bac8ad5ada
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
Subject: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
Date: Fri, 14 Jun 2013 09:38:58 +0200
Message-id: <1371195540-2991-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jQd21J3YFGlxqV7P483Y5q8XTph/s
	FvM+y1p0nn3CbNG74CqbxZtH3BZvHm5mtLi8aw6bxefeI4wWtxtXsFn0L+xlsug48o3ZYuNX
	DwdejzvX9rB5rJv2ltmjb8sqRo9Hi1sYPT5vkgtgjeKySUnNySxLLdK3S+DK2PPoMlPBosVM
	Fc8u9TM2MG76wtjFyMEhIWAi8XF2dhcjJ5ApJnHh3nq2LkYuDiGB6YwSy8/NZQNJCAl0MUl8
	7E4CsdkE9CQ+333KBGKLCPhK9Cw7xATSwCzwllni28K/YAlhAReJqY/OsoPYLAKqEufbpzKD
	2LwCrhLfvk1mh9gmL/H0fh/YAk4BN4lpOx6yQGxuZJR4fuQd0wRG3gWMDKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxggPymfQOxlUNFocYBTgYlXh4Ey7sDBRiTSwrrsw9xCjBwawkwhv+
	FyjEm5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBsVbzs1zv
	ZqlAJRXz0x4zfklKTPXe8t6HT3axptWOV5er2E2m9Uxec85q71IO756sd+8XTxU91cFiI/XH
	tzv7d5Bx86Qdx6eLvTH4lJzYmXh1de6z2ynPr3zlv3Gq8XC+nujvfD+Vzf807PI5b76Ztecl
	t8eNAycmfrob+67FX9/uC/MvVc/SY0osxRmJhlrMRcWJAGwIXRhEAgAA
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

Changes for v2:
- Removal of cpufreq_boost structure and move its fields to cpufreq_driver
  structure
- Flag to indicate if global boost attribute is already defined
- Extent the pr_{err|debbug} functions to show current function names

Changes for v3:
- Method for reading boost status
- Removal of cpufreq_frequency_table_max()
- Extent cpufreq_frequency_table_cpuinfo() to support boost parameter
- boost_supported flag added to cpufreq_driver struct
- "boost" sysfs attribute control flag removed
- One global flag describing state of the boost defined at cpufreq core
- Rename cpufreq_driver's low_level_boost field to set_boost_freq()
- Usage of cpufreq_sysfs_{remove|add}_file() routines

---
 arch/arm/mach-s3c24xx/cpufreq.c              |    2 +-
 arch/powerpc/platforms/pasemi/cpufreq.c      |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_32.c |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c |    2 +-
 drivers/cpufreq/acpi-cpufreq.c               |    2 +-
 drivers/cpufreq/arm_big_little.c             |    3 +-
 drivers/cpufreq/blackfin-cpufreq.c           |    2 +-
 drivers/cpufreq/cpufreq-cpu0.c               |    2 +-
 drivers/cpufreq/cpufreq.c                    |   87 ++++++++++++++++++++++++++
 drivers/cpufreq/cris-artpec3-cpufreq.c       |    2 +-
 drivers/cpufreq/cris-etraxfs-cpufreq.c       |    2 +-
 drivers/cpufreq/davinci-cpufreq.c            |    2 +-
 drivers/cpufreq/dbx500-cpufreq.c             |    2 +-
 drivers/cpufreq/e_powersaver.c               |    3 +-
 drivers/cpufreq/elanfreq.c                   |    2 +-
 drivers/cpufreq/exynos-cpufreq.c             |    3 +-
 drivers/cpufreq/exynos5440-cpufreq.c         |    2 +-
 drivers/cpufreq/freq_table.c                 |   44 ++++++++++---
 drivers/cpufreq/ia64-acpi-cpufreq.c          |    2 +-
 drivers/cpufreq/imx6q-cpufreq.c              |    2 +-
 drivers/cpufreq/kirkwood-cpufreq.c           |    3 +-
 drivers/cpufreq/longhaul.c                   |    2 +-
 drivers/cpufreq/loongson2_cpufreq.c          |    2 +-
 drivers/cpufreq/maple-cpufreq.c              |    2 +-
 drivers/cpufreq/omap-cpufreq.c               |    2 +-
 drivers/cpufreq/p4-clockmod.c                |    2 +-
 drivers/cpufreq/powernow-k6.c                |    2 +-
 drivers/cpufreq/powernow-k7.c                |    2 +-
 drivers/cpufreq/powernow-k8.c                |    2 +-
 drivers/cpufreq/ppc_cbe_cpufreq.c            |    2 +-
 drivers/cpufreq/pxa2xx-cpufreq.c             |    4 +-
 drivers/cpufreq/pxa3xx-cpufreq.c             |    2 +-
 drivers/cpufreq/s3c2416-cpufreq.c            |    2 +-
 drivers/cpufreq/s3c64xx-cpufreq.c            |    2 +-
 drivers/cpufreq/s5pv210-cpufreq.c            |    2 +-
 drivers/cpufreq/sc520_freq.c                 |    2 +-
 drivers/cpufreq/sh-cpufreq.c                 |    2 +-
 drivers/cpufreq/sparc-us2e-cpufreq.c         |    2 +-
 drivers/cpufreq/sparc-us3-cpufreq.c          |    2 +-
 drivers/cpufreq/spear-cpufreq.c              |    3 +-
 drivers/cpufreq/speedstep-centrino.c         |    2 +-
 drivers/cpufreq/speedstep-ich.c              |    2 +-
 drivers/cpufreq/speedstep-smi.c              |    2 +-
 drivers/cpufreq/tegra-cpufreq.c              |    4 +-
 include/linux/cpufreq.h                      |   18 +++++-
 45 files changed, 187 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/cpufreq.c b/arch/arm/mach-s3c24xx/cpufreq.c
index 3c0e78e..882fcb5 100644
--- a/arch/arm/mach-s3c24xx/cpufreq.c
+++ b/arch/arm/mach-s3c24xx/cpufreq.c
@@ -387,7 +387,7 @@ static int s3c_cpufreq_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = cpu_cur.info->latency;
 
 	if (ftab)
-		cpufreq_frequency_table_cpuinfo(policy, ftab);
+		cpufreq_frequency_table_cpuinfo(policy, ftab, 0);
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/pasemi/cpufreq.c b/arch/powerpc/platforms/pasemi/cpufreq.c
index be1e795..3d2fcc7 100644
--- a/arch/powerpc/platforms/pasemi/cpufreq.c
+++ b/arch/powerpc/platforms/pasemi/cpufreq.c
@@ -223,7 +223,7 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	/* this ensures that policy->cpuinfo_min and policy->cpuinfo_max
 	 * are set correctly
 	 */
-	return cpufreq_frequency_table_cpuinfo(policy, pas_freqs);
+	return cpufreq_frequency_table_cpuinfo(policy, pas_freqs, 0);
 
 out_unmap_sdcpwr:
 	iounmap(sdcpwr_mapbase);
diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/arch/powerpc/platforms/powermac/cpufreq_32.c
index 3104fad..f9805c6 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -408,7 +408,7 @@ static int pmac_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	policy->cur = cur_freq;
 
 	cpufreq_frequency_table_get_attr(pmac_cpu_freqs, policy->cpu);
-	return cpufreq_frequency_table_cpuinfo(policy, pmac_cpu_freqs);
+	return cpufreq_frequency_table_cpuinfo(policy, pmac_cpu_freqs, 0);
 }
 
 static u32 read_gpio(struct device_node *np)
diff --git a/arch/powerpc/platforms/powermac/cpufreq_64.c b/arch/powerpc/platforms/powermac/cpufreq_64.c
index 7ba4234..cb7869b 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_64.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_64.c
@@ -365,7 +365,7 @@ static int g5_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	cpufreq_frequency_table_get_attr(g5_cpu_freqs, policy->cpu);
 
 	return cpufreq_frequency_table_cpuinfo(policy,
-		g5_cpu_freqs);
+					       g5_cpu_freqs, 0);
 }
 
 
diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 2845566..abca529 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -819,7 +819,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	data->freq_table[valid_states].frequency = CPUFREQ_TABLE_END;
 	perf->state = 0;
 
-	result = cpufreq_frequency_table_cpuinfo(policy, data->freq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, data->freq_table, 0);
 	if (result)
 		goto err_freqfree;
 
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 5d7f53f..f06567e 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -167,7 +167,8 @@ static int bL_cpufreq_init(struct cpufreq_policy *policy)
 	if (ret)
 		return ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table[cur_cluster]);
+	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table[cur_cluster],
+					      0);
 	if (ret) {
 		dev_err(cpu_dev, "CPU %d, cluster: %d invalid freq table\n",
 				policy->cpu, cur_cluster);
diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 995511e80..65fc627 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -211,7 +211,7 @@ static int __bfin_cpu_init(struct cpufreq_policy *policy)
 
 	policy->cur = cclk;
 	cpufreq_frequency_table_get_attr(bfin_freq_table, policy->cpu);
-	return cpufreq_frequency_table_cpuinfo(policy, bfin_freq_table);
+	return cpufreq_frequency_table_cpuinfo(policy, bfin_freq_table, 0);
 }
 
 static struct freq_attr *bfin_freq_attr[] = {
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ad1fde2..fd2f5f3 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -128,7 +128,7 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table, 0);
 	if (ret) {
 		pr_err("invalid frequency table: %d\n", ret);
 		return ret;
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2ce86ed..02e57db 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -40,6 +40,7 @@
  * also protects the cpufreq_cpu_data array.
  */
 static struct cpufreq_driver *cpufreq_driver;
+static bool cpufreq_boost_enabled;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
@@ -315,6 +316,30 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
+ssize_t show_boost(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", cpufreq_boost_enabled);
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
+		pr_err("%s: Cannot %sable boost!\n", __func__,
+		       enable ? "en" : "dis");
+		return -EINVAL;
+	}
+
+	return count;
+}
+define_one_global_rw(boost);
 
 static struct cpufreq_governor *__find_governor(const char *str_governor)
 {
@@ -1896,6 +1921,55 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
 };
 
 /*********************************************************************
+ *               BOOST						     *
+ *********************************************************************/
+int cpufreq_boost_trigger_state(int state)
+{
+	struct cpufreq_frequency_table *freq_table;
+	struct cpufreq_policy *policy;
+	unsigned long flags;
+	int ret = 0, cpu;
+
+	if (!cpufreq_driver->boost_supported)
+		return -ENODEV;
+
+	if (cpufreq_boost_enabled != state) {
+		if (cpufreq_driver->set_boost_freq) {
+			ret = cpufreq_driver->set_boost_freq(state);
+			if (ret) {
+				pr_err("%s: BOOST cannot enable (%d)\n",
+				       __func__, ret);
+				return ret;
+			}
+		}
+
+		for_each_possible_cpu(cpu) {
+			policy = cpufreq_cpu_get(cpu);
+			freq_table = cpufreq_frequency_get_table(cpu);
+			if (policy && freq_table) {
+				write_lock_irqsave(&cpufreq_driver_lock, flags);
+				cpufreq_frequency_table_cpuinfo(policy,
+								freq_table,
+								state);
+				cpufreq_boost_enabled = state;
+				write_unlock_irqrestore(&cpufreq_driver_lock,
+							flags);
+			}
+		}
+	}
+
+	pr_debug("%s: cpufreq BOOST %s\n", __func__,
+		 state ? "enabled" : "disabled");
+
+	return 0;
+}
+
+int cpufreq_boost_state(void)
+{
+	return cpufreq_boost_enabled;
+}
+
+/*********************************************************************
  *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
  *********************************************************************/
 
@@ -1934,6 +2008,15 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	if (cpufreq_driver->boost_supported) {
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
@@ -1990,6 +2073,10 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	pr_debug("unregistering driver %s\n", driver->name);
 
 	subsys_interface_unregister(&cpufreq_interface);
+
+	if (cpufreq_driver->boost_supported)
+		cpufreq_sysfs_remove_file(&(boost.attr));
+
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index ee142c4..a50b6f5 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -82,7 +82,7 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 1000000; /* 1ms */
 	policy->cur = cris_freq_get_cpu_frequency(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, cris_freq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, cris_freq_table, 0);
 	if (result)
 		return (result);
 
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index 1295223..3e09693 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -81,7 +81,7 @@ static int cris_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 1000000;	/* 1ms */
 	policy->cur = cris_freq_get_cpu_frequency(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, cris_freq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, cris_freq_table, 0);
 	if (result)
 		return (result);
 
diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index c33c76c..e1ec64f 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -137,7 +137,7 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
 
 	policy->cur = davinci_getspeed(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, freq_table, 0);
 	if (result) {
 		pr_err("%s: cpufreq_frequency_table_cpuinfo() failed",
 				__func__);
diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 6ec6539..30b89eb 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -87,7 +87,7 @@ static int __cpuinit dbx500_cpufreq_init(struct cpufreq_policy *policy)
 	int res;
 
 	/* get policy fields based on the table */
-	res = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	res = cpufreq_frequency_table_cpuinfo(policy, freq_table, 0);
 	if (!res)
 		cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
 	else {
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 37380fb..1eea205 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -400,7 +400,8 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 140000; /* 844mV -> 700mV in ns */
 	policy->cur = fsb * current_multiplier;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, &centaur->freq_table[0]);
+	ret = cpufreq_frequency_table_cpuinfo(policy, &centaur->freq_table[0],
+					      0);
 	if (ret) {
 		kfree(centaur);
 		return ret;
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 658d860..6700524 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -223,7 +223,7 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = elanfreq_get_cpu_frequency(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, elanfreq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, elanfreq_table, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 3197d88..32ec2f6 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -253,7 +253,8 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	cpumask_setall(policy->cpus);
 
-	return cpufreq_frequency_table_cpuinfo(policy, exynos_info->freq_table);
+	return cpufreq_frequency_table_cpuinfo(policy, exynos_info->freq_table,
+					       0);
 }
 
 static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 0c74018..936e239 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -323,7 +323,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, dvfs_info->freq_table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, dvfs_info->freq_table, 0);
 	if (ret) {
 		dev_err(dvfs_info->dev, "Invalid frequency table: %d\n", ret);
 		return ret;
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index d7a7966..f1a4d785 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -21,7 +21,8 @@
  *********************************************************************/
 
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
-				    struct cpufreq_frequency_table *table)
+				    struct cpufreq_frequency_table *table,
+				    int boost)
 {
 	unsigned int min_freq = ~0;
 	unsigned int max_freq = 0;
@@ -31,9 +32,11 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 		unsigned int freq = table[i].frequency;
 		if (freq == CPUFREQ_ENTRY_INVALID) {
 			pr_debug("table entry %u is invalid, skipping\n", i);
-
 			continue;
 		}
+		if (!boost && table[i].index == CPUFREQ_BOOST_FREQ)
+			continue;
+
 		pr_debug("table entry %u: %u kHz, %u index\n",
 					i, freq, table[i].index);
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
@@ -186,22 +190,42 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
+		if (show_boost && table[i].index != CPUFREQ_BOOST_FREQ)
+			continue;
+		if (!show_boost && table[i].index == CPUFREQ_BOOST_FREQ)
+			continue;
+
 		count += sprintf(&buf[count], "%d ", table[i].frequency);
 	}
 	count += sprintf(&buf[count], "\n");
 
 	return count;
-
 }
 
-struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
-	.attr = { .name = "scaling_available_frequencies",
-		  .mode = 0444,
-		},
-	.show = show_available_freqs,
-};
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
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index c0075db..7a29a92 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -335,7 +335,7 @@ acpi_cpufreq_cpu_init (
 		}
 	}
 
-	result = cpufreq_frequency_table_cpuinfo(policy, data->freq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, data->freq_table, 0);
 	if (result) {
 		goto err_freqfree;
 	}
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index b78bc35..9d09c29 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -172,7 +172,7 @@ static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table, 0);
 	if (ret) {
 		dev_err(cpu_dev, "invalid frequency table: %d\n", ret);
 		return ret;
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index b2644af..03b95bd 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -131,7 +131,8 @@ static int kirkwood_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 5000; /* 5uS */
 	policy->cur = kirkwood_cpufreq_get_cpu_frequency(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, kirkwood_freq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, kirkwood_freq_table,
+						 0);
 	if (result)
 		return result;
 
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index b448638..ef2cea3 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -921,7 +921,7 @@ static int __cpuinit longhaul_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 200000;	/* nsec */
 	policy->cur = calc_speed(longhaul_get_cpu_mult());
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, longhaul_table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, longhaul_table, 0);
 	if (ret)
 		return ret;
 
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index d539127..fc8bcbb 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -136,7 +136,7 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 					 policy->cpu);
 
 	return cpufreq_frequency_table_cpuinfo(policy,
-					    &loongson2_clockmod_table[0]);
+					       &loongson2_clockmod_table[0], 0);
 }
 
 static int loongson2_cpufreq_verify(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index cdd6291..1b35285 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -184,7 +184,7 @@ static int maple_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	cpufreq_frequency_table_get_attr(maple_cpu_freqs, policy->cpu);
 
 	return cpufreq_frequency_table_cpuinfo(policy,
-		maple_cpu_freqs);
+					       maple_cpu_freqs, 0);
 }
 
 
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 0279d18..30473ae 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -191,7 +191,7 @@ static int __cpuinit omap_cpu_init(struct cpufreq_policy *policy)
 
 	atomic_inc_return(&freq_table_users);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, freq_table, 0);
 	if (result)
 		goto fail_table;
 
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 421ef37..8f36e69 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -239,7 +239,7 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 10000001;
 	policy->cur = stock_freq;
 
-	return cpufreq_frequency_table_cpuinfo(policy, &p4clockmod_table[0]);
+	return cpufreq_frequency_table_cpuinfo(policy, &p4clockmod_table[0], 0);
 }
 
 
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index ea0222a..4ffe7d5 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -167,7 +167,7 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 200000;
 	policy->cur = busfreq * max_multiplier;
 
-	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio);
+	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 53888da..73c8345 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -683,7 +683,7 @@ static int __cpuinit powernow_cpu_init(struct cpufreq_policy *policy)
 
 	cpufreq_frequency_table_get_attr(powernow_table, policy->cpu);
 
-	return cpufreq_frequency_table_cpuinfo(policy, powernow_table);
+	return cpufreq_frequency_table_cpuinfo(policy, powernow_table, 0);
 }
 
 static int powernow_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index b828efe..67d3283 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1156,7 +1156,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	pr_debug("policy current frequency %d kHz\n", pol->cur);
 
 	/* min/max the cpu is capable of */
-	if (cpufreq_frequency_table_cpuinfo(pol, data->powernow_table)) {
+	if (cpufreq_frequency_table_cpuinfo(pol, data->powernow_table), 0) {
 		printk(KERN_ERR FW_BUG PFX "invalid powernow_table\n");
 		powernow_k8_cpu_exit_acpi(data);
 		kfree(data->powernow_table);
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index e577a1d..b50d9f1 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -127,7 +127,7 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	/* this ensures that policy->cpuinfo_min
 	 * and policy->cpuinfo_max are set correctly */
-	return cpufreq_frequency_table_cpuinfo(policy, cbe_freqs);
+	return cpufreq_frequency_table_cpuinfo(policy, cbe_freqs, 0);
 }
 
 static int cbe_cpufreq_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 9e5bc8e..cd5d74a 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -453,10 +453,10 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 		find_freq_tables(&pxa255_freq_table, &pxa255_freqs);
 		pr_info("PXA255 cpufreq using %s frequency table\n",
 			pxa255_turbo_table ? "turbo" : "run");
-		cpufreq_frequency_table_cpuinfo(policy, pxa255_freq_table);
+		cpufreq_frequency_table_cpuinfo(policy, pxa255_freq_table, 0);
 	}
 	else if (cpu_is_pxa27x())
-		cpufreq_frequency_table_cpuinfo(policy, pxa27x_freq_table);
+		cpufreq_frequency_table_cpuinfo(policy, pxa27x_freq_table, 0);
 
 	printk(KERN_INFO "PXA CPU frequency change support initialized\n");
 
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 15d60f8..c16d3f8 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -108,7 +108,7 @@ static int setup_freqs_table(struct cpufreq_policy *policy,
 	pxa3xx_freqs_num = num;
 	pxa3xx_freqs_table = table;
 
-	return cpufreq_frequency_table_cpuinfo(policy, table);
+	return cpufreq_frequency_table_cpuinfo(policy, table, 0);
 }
 
 static void __update_core_freq(struct pxa3xx_freq_info *info)
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 4f1881e..ea2b626 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -494,7 +494,7 @@ static int __init s3c2416_cpufreq_driver_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = (500 * 1000) +
 					     s3c_freq->regulator_latency;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, s3c_freq->freq_table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, s3c_freq->freq_table, 0);
 	if (ret)
 		goto err_freq_table;
 
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 27cacb5..137d29b 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -247,7 +247,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 	 */
 	policy->cpuinfo.transition_latency = (500 * 1000) + regulator_latency;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, s3c64xx_freq_table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, s3c64xx_freq_table, 0);
 	if (ret != 0) {
 		pr_err("Failed to configure frequency table: %d\n",
 		       ret);
diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 5c77570..8b7c790 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -557,7 +557,7 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 
 	policy->cpuinfo.transition_latency = 40000;
 
-	return cpufreq_frequency_table_cpuinfo(policy, s5pv210_freq_table);
+	return cpufreq_frequency_table_cpuinfo(policy, s5pv210_freq_table, 0);
 
 out_dmc1:
 	clk_put(dmc0_clk);
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index f740b13..d809fd0 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -117,7 +117,7 @@ static int sc520_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 1000000; /* 1ms */
 	policy->cur = sc520_freq_get_cpu_frequency(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, sc520_freq_table);
+	result = cpufreq_frequency_table_cpuinfo(policy, sc520_freq_table, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
index 73adb64..c064d7c 100644
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -120,7 +120,7 @@ static int sh_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (freq_table) {
 		int result;
 
-		result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+		result = cpufreq_frequency_table_cpuinfo(policy, freq_table, 0);
 		if (!result)
 			cpufreq_frequency_table_get_attr(freq_table, cpu);
 	} else {
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 306ae46..c0345c4 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -324,7 +324,7 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 
-	return cpufreq_frequency_table_cpuinfo(policy, table);
+	return cpufreq_frequency_table_cpuinfo(policy, table, 0);
 }
 
 static int us2e_freq_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index c71ee14..27a03b6 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -181,7 +181,7 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 
-	return cpufreq_frequency_table_cpuinfo(policy, table);
+	return cpufreq_frequency_table_cpuinfo(policy, table, 0);
 }
 
 static int us3_freq_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 156829f..517e19c 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -178,7 +178,8 @@ static int spear_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, spear_cpufreq.freq_tbl);
+	ret = cpufreq_frequency_table_cpuinfo(policy, spear_cpufreq.freq_tbl,
+					      0);
 	if (ret) {
 		pr_err("cpufreq_frequency_table_cpuinfo() failed");
 		return ret;
diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 618e6f4..85b981b 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -403,7 +403,7 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 	pr_debug("centrino_cpu_init: cur=%dkHz\n", policy->cur);
 
 	ret = cpufreq_frequency_table_cpuinfo(policy,
-		per_cpu(centrino_model, policy->cpu)->op_points);
+			per_cpu(centrino_model, policy->cpu)->op_points, 0);
 	if (ret)
 		return (ret);
 
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index e2e5aa9..711c973 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -349,7 +349,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 	/* cpuinfo and default policy values */
 	policy->cur = speed;
 
-	result = cpufreq_frequency_table_cpuinfo(policy, speedstep_freqs);
+	result = cpufreq_frequency_table_cpuinfo(policy, speedstep_freqs, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index f5a6b70..569e75e 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -329,7 +329,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = speed;
 
-	result = cpufreq_frequency_table_cpuinfo(policy, speedstep_freqs);
+	result = cpufreq_frequency_table_cpuinfo(policy, speedstep_freqs, 0);
 	if (result)
 		return result;
 
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index c74c0e1..8bf95e0 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -216,7 +216,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	clk_prepare_enable(emc_clk);
 	clk_prepare_enable(cpu_clk);
 
-	cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	cpufreq_frequency_table_cpuinfo(policy, freq_table, 0);
 	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
 	policy->cur = tegra_getspeed(policy->cpu);
 	target_cpu_speed[policy->cpu] = policy->cur;
@@ -234,7 +234,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 
 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	cpufreq_frequency_table_cpuinfo(policy, freq_table, 0);
 	clk_disable_unprepare(emc_clk);
 	return 0;
 }
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ab1932c..027442d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -266,6 +266,10 @@ struct cpufreq_driver {
 	int	(*suspend)	(struct cpufreq_policy *policy);
 	int	(*resume)	(struct cpufreq_policy *policy);
 	struct freq_attr	**attr;
+
+	/* platform specific boost support code */
+	bool                    boost_supported;
+	int (*set_boost_freq)   (int state);
 };
 
 /* flags */
@@ -318,6 +322,10 @@ __ATTR(_name, _perm, show_##_name, NULL)
 static struct freq_attr _name =			\
 __ATTR(_name, 0644, show_##_name, store_##_name)
 
+#define cpufreq_attr_available_freq(_name)	  \
+struct freq_attr cpufreq_freq_attr_##_name##_freqs =     \
+__ATTR_RO(_name##_frequencies)
+
 struct global_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct kobject *kobj,
@@ -407,6 +415,9 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
 #define CPUFREQ_ENTRY_INVALID ~0
 #define CPUFREQ_TABLE_END     ~1
 
+/* Define index for boost frequency */
+#define CPUFREQ_BOOST_FREQ    ~2
+
 struct cpufreq_frequency_table {
 	unsigned int	index;     /* any */
 	unsigned int	frequency; /* kHz - doesn't need to be in ascending
@@ -414,7 +425,8 @@ struct cpufreq_frequency_table {
 };
 
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
-				    struct cpufreq_frequency_table *table);
+				    struct cpufreq_frequency_table *table,
+				    int boost);
 
 int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 				   struct cpufreq_frequency_table *table);
@@ -425,11 +437,15 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int relation,
 				   unsigned int *index);
 
+int cpufreq_boost_trigger_state(int state);
+int cpufreq_boost_state(void);
+
 /* the following 3 funtions are for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
+extern struct freq_attr cpufreq_freq_attr_scaling_boost_freqs;
 
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
-- 
1.7.10.4

