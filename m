Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3ISVFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:05:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47627 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab3ISVFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:05:46 -0400
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/3] PM / OPP: rename functions to dev_pm_opp*
Date: Thu, 19 Sep 2013 16:03:50 -0500
Message-ID: <1379624632-17356-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379624632-17356-1-git-send-email-nm@ti.com>
References: <1379624632-17356-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Operating Performance Points(OPP) functions are specific to
device specific power management, be specific and rename opp_*
accessors in OPP library with dev_pm_opp_* equivalent.

Impacted functions are:
opp_get_voltage
opp_get_freq
opp_get_opp_count
opp_find_freq_exact
opp_find_freq_floor
opp_find_freq_ceil
opp_add
opp_enable
opp_disable
opp_get_notifier
opp_init_cpufreq_table
opp_free_cpufreq_table

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 Documentation/power/opp.txt             |  102 +++++++++++++++----------------
 arch/arm/mach-imx/mach-imx6q.c          |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c |    8 +--
 arch/arm/mach-omap2/opp.c               |    4 +-
 arch/arm/mach-omap2/pm.c                |    4 +-
 drivers/base/power/opp.c                |   82 ++++++++++++-------------
 drivers/cpufreq/arm_big_little.c        |    6 +-
 drivers/cpufreq/cpufreq-cpu0.c          |   18 +++---
 drivers/cpufreq/exynos5440-cpufreq.c    |   13 ++--
 drivers/cpufreq/imx6q-cpufreq.c         |   20 +++---
 drivers/cpufreq/omap-cpufreq.c          |    8 +--
 drivers/devfreq/devfreq.c               |   14 ++---
 drivers/devfreq/exynos/exynos4_bus.c    |   21 ++++---
 drivers/devfreq/exynos/exynos5_bus.c    |   18 +++---
 include/linux/opp.h                     |   50 +++++++--------
 15 files changed, 187 insertions(+), 183 deletions(-)

diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
index 425c51d..185367b 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.txt
@@ -71,14 +71,14 @@ operations until that OPP could be re-enabled if possible.
 
 OPP library facilitates this concept in it's implementation. The following
 operational functions operate only on available opps:
-opp_find_freq_{ceil, floor}, opp_get_voltage, opp_get_freq, opp_get_opp_count
-and opp_init_cpufreq_table
+opp_find_freq_{ceil, floor}, dev_pm_opp_get_voltage, dev_pm_opp_get_freq, dev_pm_opp_get_opp_count
+and dev_pm_opp_init_cpufreq_table
 
-opp_find_freq_exact is meant to be used to find the opp pointer which can then
-be used for opp_enable/disable functions to make an opp available as required.
+dev_pm_opp_find_freq_exact is meant to be used to find the opp pointer which can then
+be used for dev_pm_opp_enable/disable functions to make an opp available as required.
 
 WARNING: Users of OPP library should refresh their availability count using
-get_opp_count if opp_enable/disable functions are invoked for a device, the
+get_opp_count if dev_pm_opp_enable/disable functions are invoked for a device, the
 exact mechanism to trigger these or the notification mechanism to other
 dependent subsystems such as cpufreq are left to the discretion of the SoC
 specific framework which uses the OPP library. Similar care needs to be taken
@@ -96,24 +96,24 @@ using RCU read locks. The opp_find_freq_{exact,ceil,floor},
 opp_get_{voltage, freq, opp_count} fall into this category.
 
 opp_{add,enable,disable} are updaters which use mutex and implement it's own
-RCU locking mechanisms. opp_init_cpufreq_table acts as an updater and uses
+RCU locking mechanisms. dev_pm_opp_init_cpufreq_table acts as an updater and uses
 mutex to implment RCU updater strategy. These functions should *NOT* be called
 under RCU locks and other contexts that prevent blocking functions in RCU or
 mutex operations from working.
 
 2. Initial OPP List Registration
 ================================
-The SoC implementation calls opp_add function iteratively to add OPPs per
+The SoC implementation calls dev_pm_opp_add function iteratively to add OPPs per
 device. It is expected that the SoC framework will register the OPP entries
 optimally- typical numbers range to be less than 5. The list generated by
 registering the OPPs is maintained by OPP library throughout the device
 operation. The SoC framework can subsequently control the availability of the
-OPPs dynamically using the opp_enable / disable functions.
+OPPs dynamically using the dev_pm_opp_enable / disable functions.
 
-opp_add - Add a new OPP for a specific domain represented by the device pointer.
+dev_pm_opp_add - Add a new OPP for a specific domain represented by the device pointer.
 	The OPP is defined using the frequency and voltage. Once added, the OPP
 	is assumed to be available and control of it's availability can be done
-	with the opp_enable/disable functions. OPP library internally stores
+	with the dev_pm_opp_enable/disable functions. OPP library internally stores
 	and manages this information in the opp struct. This function may be
 	used by SoC framework to define a optimal list as per the demands of
 	SoC usage environment.
@@ -124,7 +124,7 @@ opp_add - Add a new OPP for a specific domain represented by the device pointer.
 	 soc_pm_init()
 	 {
 		/* Do things */
-		r = opp_add(mpu_dev, 1000000, 900000);
+		r = dev_pm_opp_add(mpu_dev, 1000000, 900000);
 		if (!r) {
 			pr_err("%s: unable to register mpu opp(%d)\n", r);
 			goto no_cpufreq;
@@ -143,44 +143,44 @@ functions return the matching pointer representing the opp if a match is
 found, else returns error. These errors are expected to be handled by standard
 error checks such as IS_ERR() and appropriate actions taken by the caller.
 
-opp_find_freq_exact - Search for an OPP based on an *exact* frequency and
+dev_pm_opp_find_freq_exact - Search for an OPP based on an *exact* frequency and
 	availability. This function is especially useful to enable an OPP which
 	is not available by default.
 	Example: In a case when SoC framework detects a situation where a
 	higher frequency could be made available, it can use this function to
-	find the OPP prior to call the opp_enable to actually make it available.
+	find the OPP prior to call the dev_pm_opp_enable to actually make it available.
 	 rcu_read_lock();
-	 opp = opp_find_freq_exact(dev, 1000000000, false);
+	 opp = dev_pm_opp_find_freq_exact(dev, 1000000000, false);
 	 rcu_read_unlock();
 	 /* dont operate on the pointer.. just do a sanity check.. */
 	 if (IS_ERR(opp)) {
 		pr_err("frequency not disabled!\n");
 		/* trigger appropriate actions.. */
 	 } else {
-		opp_enable(dev,1000000000);
+		dev_pm_opp_enable(dev,1000000000);
 	 }
 
 	NOTE: This is the only search function that operates on OPPs which are
 	not available.
 
-opp_find_freq_floor - Search for an available OPP which is *at most* the
+dev_pm_opp_find_freq_floor - Search for an available OPP which is *at most* the
 	provided frequency. This function is useful while searching for a lesser
 	match OR operating on OPP information in the order of decreasing
 	frequency.
 	Example: To find the highest opp for a device:
 	 freq = ULONG_MAX;
 	 rcu_read_lock();
-	 opp_find_freq_floor(dev, &freq);
+	 dev_pm_opp_find_freq_floor(dev, &freq);
 	 rcu_read_unlock();
 
-opp_find_freq_ceil - Search for an available OPP which is *at least* the
+dev_pm_opp_find_freq_ceil - Search for an available OPP which is *at least* the
 	provided frequency. This function is useful while searching for a
 	higher match OR operating on OPP information in the order of increasing
 	frequency.
 	Example 1: To find the lowest opp for a device:
 	 freq = 0;
 	 rcu_read_lock();
-	 opp_find_freq_ceil(dev, &freq);
+	 dev_pm_opp_find_freq_ceil(dev, &freq);
 	 rcu_read_unlock();
 	Example 2: A simplified implementation of a SoC cpufreq_driver->target:
 	 soc_cpufreq_target(..)
@@ -188,7 +188,7 @@ opp_find_freq_ceil - Search for an available OPP which is *at least* the
 		/* Do stuff like policy checks etc. */
 		/* Find the best frequency match for the req */
 		rcu_read_lock();
-		opp = opp_find_freq_ceil(dev, &freq);
+		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
 		rcu_read_unlock();
 		if (!IS_ERR(opp))
 			soc_switch_to_freq_voltage(freq);
@@ -208,34 +208,34 @@ as thermal considerations (e.g. don't use OPPx until the temperature drops).
 
 WARNING: Do not use these functions in interrupt context.
 
-opp_enable - Make a OPP available for operation.
+dev_pm_opp_enable - Make a OPP available for operation.
 	Example: Lets say that 1GHz OPP is to be made available only if the
 	SoC temperature is lower than a certain threshold. The SoC framework
 	implementation might choose to do something as follows:
 	 if (cur_temp < temp_low_thresh) {
 		/* Enable 1GHz if it was disabled */
 		rcu_read_lock();
-		opp = opp_find_freq_exact(dev, 1000000000, false);
+		opp = dev_pm_opp_find_freq_exact(dev, 1000000000, false);
 		rcu_read_unlock();
 		/* just error check */
 		if (!IS_ERR(opp))
-			ret = opp_enable(dev, 1000000000);
+			ret = dev_pm_opp_enable(dev, 1000000000);
 		else
 			goto try_something_else;
 	 }
 
-opp_disable - Make an OPP to be not available for operation
+dev_pm_opp_disable - Make an OPP to be not available for operation
 	Example: Lets say that 1GHz OPP is to be disabled if the temperature
 	exceeds a threshold value. The SoC framework implementation might
 	choose to do something as follows:
 	 if (cur_temp > temp_high_thresh) {
 		/* Disable 1GHz if it was enabled */
 		rcu_read_lock();
-		opp = opp_find_freq_exact(dev, 1000000000, true);
+		opp = dev_pm_opp_find_freq_exact(dev, 1000000000, true);
 		rcu_read_unlock();
 		/* just error check */
 		if (!IS_ERR(opp))
-			ret = opp_disable(dev, 1000000000);
+			ret = dev_pm_opp_disable(dev, 1000000000);
 		else
 			goto try_something_else;
 	 }
@@ -247,7 +247,7 @@ information from the OPP structure is necessary. Once an OPP pointer is
 retrieved using the search functions, the following functions can be used by SoC
 framework to retrieve the information represented inside the OPP layer.
 
-opp_get_voltage - Retrieve the voltage represented by the opp pointer.
+dev_pm_opp_get_voltage - Retrieve the voltage represented by the opp pointer.
 	Example: At a cpufreq transition to a different frequency, SoC
 	framework requires to set the voltage represented by the OPP using
 	the regulator framework to the Power Management chip providing the
@@ -256,15 +256,15 @@ opp_get_voltage - Retrieve the voltage represented by the opp pointer.
 	 {
 		/* do things */
 		rcu_read_lock();
-		opp = opp_find_freq_ceil(dev, &freq);
-		v = opp_get_voltage(opp);
+		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
+		v = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
 		if (v)
 			regulator_set_voltage(.., v);
 		/* do other things */
 	 }
 
-opp_get_freq - Retrieve the freq represented by the opp pointer.
+dev_pm_opp_get_freq - Retrieve the freq represented by the opp pointer.
 	Example: Lets say the SoC framework uses a couple of helper functions
 	we could pass opp pointers instead of doing additional parameters to
 	handle quiet a bit of data parameters.
@@ -273,8 +273,8 @@ opp_get_freq - Retrieve the freq represented by the opp pointer.
 		/* do things.. */
 		 max_freq = ULONG_MAX;
 		 rcu_read_lock();
-		 max_opp = opp_find_freq_floor(dev,&max_freq);
-		 requested_opp = opp_find_freq_ceil(dev,&freq);
+		 max_opp = dev_pm_opp_find_freq_floor(dev,&max_freq);
+		 requested_opp = dev_pm_opp_find_freq_ceil(dev,&freq);
 		 if (!IS_ERR(max_opp) && !IS_ERR(requested_opp))
 			r = soc_test_validity(max_opp, requested_opp);
 		 rcu_read_unlock();
@@ -282,25 +282,25 @@ opp_get_freq - Retrieve the freq represented by the opp pointer.
 	 }
 	 soc_test_validity(..)
 	 {
-		 if(opp_get_voltage(max_opp) < opp_get_voltage(requested_opp))
+		 if(dev_pm_opp_get_voltage(max_opp) < dev_pm_opp_get_voltage(requested_opp))
 			 return -EINVAL;
-		 if(opp_get_freq(max_opp) < opp_get_freq(requested_opp))
+		 if(dev_pm_opp_get_freq(max_opp) < dev_pm_opp_get_freq(requested_opp))
 			 return -EINVAL;
 		/* do things.. */
 	 }
 
-opp_get_opp_count - Retrieve the number of available opps for a device
+dev_pm_opp_get_opp_count - Retrieve the number of available opps for a device
 	Example: Lets say a co-processor in the SoC needs to know the available
 	frequencies in a table, the main processor can notify as following:
 	 soc_notify_coproc_available_frequencies()
 	 {
 		/* Do things */
 		rcu_read_lock();
-		num_available = opp_get_opp_count(dev);
+		num_available = dev_pm_opp_get_opp_count(dev);
 		speeds = kzalloc(sizeof(u32) * num_available, GFP_KERNEL);
 		/* populate the table in increasing order */
 		freq = 0;
-		while (!IS_ERR(opp = opp_find_freq_ceil(dev, &freq))) {
+		while (!IS_ERR(opp = dev_pm_opp_find_freq_ceil(dev, &freq))) {
 			speeds[i] = freq;
 			freq++;
 			i++;
@@ -313,7 +313,7 @@ opp_get_opp_count - Retrieve the number of available opps for a device
 
 6. Cpufreq Table Generation
 ===========================
-opp_init_cpufreq_table - cpufreq framework typically is initialized with
+dev_pm_opp_init_cpufreq_table - cpufreq framework typically is initialized with
 	cpufreq_frequency_table_cpuinfo which is provided with the list of
 	frequencies that are available for operation. This function provides
 	a ready to use conversion routine to translate the OPP layer's internal
@@ -326,7 +326,7 @@ opp_init_cpufreq_table - cpufreq framework typically is initialized with
 	 soc_pm_init()
 	 {
 		/* Do things */
-		r = opp_init_cpufreq_table(dev, &freq_table);
+		r = dev_pm_opp_init_cpufreq_table(dev, &freq_table);
 		if (!r)
 			cpufreq_frequency_table_cpuinfo(policy, freq_table);
 		/* Do other things */
@@ -336,7 +336,7 @@ opp_init_cpufreq_table - cpufreq framework typically is initialized with
 	addition to CONFIG_PM as power management feature is required to
 	dynamically scale voltage and frequency in a system.
 
-opp_free_cpufreq_table - Free up the table allocated by opp_init_cpufreq_table
+dev_pm_opp_free_cpufreq_table - Free up the table allocated by dev_pm_opp_init_cpufreq_table
 
 7. Data Structures
 ==================
@@ -366,8 +366,8 @@ struct opp - The internal data structure of OPP library which is used to
 	identifier for OPP in the interactions with OPP layer.
 
 	WARNING: The struct opp pointer should not be parsed or modified by the
-	users. The defaults of for an instance is populated by opp_add, but the
-	availability of the OPP can be modified by opp_enable/disable functions.
+	users. The defaults of for an instance is populated by dev_pm_opp_add, but the
+	availability of the OPP can be modified by dev_pm_opp_enable/disable functions.
 
 struct device - This is used to identify a domain to the OPP layer. The
 	nature of the device and it's implementation is left to the user of
@@ -377,19 +377,19 @@ Overall, in a simplistic view, the data structure operations is represented as
 following:
 
 Initialization / modification:
-            +-----+        /- opp_enable
-opp_add --> | opp | <-------
-  |         +-----+        \- opp_disable
+            +-----+        /- dev_pm_opp_enable
+dev_pm_opp_add --> | opp | <-------
+  |         +-----+        \- dev_pm_opp_disable
   \-------> domain_info(device)
 
 Search functions:
-             /-- opp_find_freq_ceil  ---\   +-----+
-domain_info<---- opp_find_freq_exact -----> | opp |
-             \-- opp_find_freq_floor ---/   +-----+
+             /-- dev_pm_opp_find_freq_ceil  ---\   +-----+
+domain_info<---- dev_pm_opp_find_freq_exact -----> | opp |
+             \-- dev_pm_opp_find_freq_floor ---/   +-----+
 
 Retrieval functions:
-+-----+     /- opp_get_voltage
++-----+     /- dev_pm_opp_get_voltage
 | opp | <---
-+-----+     \- opp_get_freq
++-----+     \- dev_pm_opp_get_freq
 
-domain_info <- opp_get_opp_count
+domain_info <- dev_pm_opp_get_opp_count
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 85a1b51..dfbf6f2 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -226,7 +226,7 @@ static void __init imx6q_opp_check_1p2ghz(struct device *cpu_dev)
 	val = readl_relaxed(base + OCOTP_CFG3);
 	val >>= OCOTP_CFG3_SPEED_SHIFT;
 	if ((val & 0x3) != OCOTP_CFG3_SPEED_1P2GHZ)
-		if (opp_disable(cpu_dev, 1200000000))
+		if (dev_pm_opp_disable(cpu_dev, 1200000000))
 			pr_warn("failed to disable 1.2 GHz OPP\n");
 
 put_node:
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index f269184..33969e5 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -522,11 +522,11 @@ static int __init beagle_opp_init(void)
 			return -ENODEV;
 		}
 		/* Enable MPU 1GHz and lower opps */
-		r = opp_enable(mpu_dev, 800000000);
+		r = dev_pm_opp_enable(mpu_dev, 800000000);
 		/* TODO: MPU 1GHz needs SR and ABB */
 
 		/* Enable IVA 800MHz and lower opps */
-		r |= opp_enable(iva_dev, 660000000);
+		r |= dev_pm_opp_enable(iva_dev, 660000000);
 		/* TODO: DSP 800MHz needs SR and ABB */
 		if (r) {
 			pr_err("%s: failed to enable higher opp %d\n",
@@ -535,8 +535,8 @@ static int __init beagle_opp_init(void)
 			 * Cleanup - disable the higher freqs - we dont care
 			 * about the results
 			 */
-			opp_disable(mpu_dev, 800000000);
-			opp_disable(iva_dev, 660000000);
+			dev_pm_opp_disable(mpu_dev, 800000000);
+			dev_pm_opp_disable(iva_dev, 660000000);
 		}
 	}
 	return 0;
diff --git a/arch/arm/mach-omap2/opp.c b/arch/arm/mach-omap2/opp.c
index bd41d59..7b04637 100644
--- a/arch/arm/mach-omap2/opp.c
+++ b/arch/arm/mach-omap2/opp.c
@@ -81,14 +81,14 @@ int __init omap_init_opp_table(struct omap_opp_def *opp_def,
 			dev = &oh->od->pdev->dev;
 		}
 
-		r = opp_add(dev, opp_def->freq, opp_def->u_volt);
+		r = dev_pm_opp_add(dev, opp_def->freq, opp_def->u_volt);
 		if (r) {
 			dev_err(dev, "%s: add OPP %ld failed for %s [%d] result=%d\n",
 				__func__, opp_def->freq,
 				opp_def->hwmod_name, i, r);
 		} else {
 			if (!opp_def->default_available)
-				r = opp_disable(dev, opp_def->freq);
+				r = dev_pm_opp_disable(dev, opp_def->freq);
 			if (r)
 				dev_err(dev, "%s: disable %ld failed for %s [%d] result=%d\n",
 					__func__, opp_def->freq,
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index e742118..937744c 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -172,7 +172,7 @@ static int __init omap2_set_init_voltage(char *vdd_name, char *clk_name,
 	clk_put(clk);
 
 	rcu_read_lock();
-	opp = opp_find_freq_ceil(dev, &freq);
+	opp = dev_pm_opp_find_freq_ceil(dev, &freq);
 	if (IS_ERR(opp)) {
 		rcu_read_unlock();
 		pr_err("%s: unable to find boot up OPP for vdd_%s\n",
@@ -180,7 +180,7 @@ static int __init omap2_set_init_voltage(char *vdd_name, char *clk_name,
 		goto exit;
 	}
 
-	bootup_volt = opp_get_voltage(opp);
+	bootup_volt = dev_pm_opp_get_voltage(opp);
 	rcu_read_unlock();
 	if (!bootup_volt) {
 		pr_err("%s: unable to find voltage corresponding to the bootup OPP for vdd_%s\n",
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index ef89897..00c6a44 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -136,7 +136,7 @@ static struct device_opp *find_device_opp(struct device *dev)
 }
 
 /**
- * opp_get_voltage() - Gets the voltage corresponding to an available opp
+ * dev_pm_opp_get_voltage() - Gets the voltage corresponding to an available opp
  * @opp:	opp for which voltage has to be returned for
  *
  * Return voltage in micro volt corresponding to the opp, else
@@ -150,7 +150,7 @@ static struct device_opp *find_device_opp(struct device *dev)
  * prior to unlocking with rcu_read_unlock() to maintain the integrity of the
  * pointer.
  */
-unsigned long opp_get_voltage(struct opp *opp)
+unsigned long dev_pm_opp_get_voltage(struct opp *opp)
 {
 	struct opp *tmp_opp;
 	unsigned long v = 0;
@@ -163,10 +163,10 @@ unsigned long opp_get_voltage(struct opp *opp)
 
 	return v;
 }
-EXPORT_SYMBOL_GPL(opp_get_voltage);
+EXPORT_SYMBOL_GPL(dev_pm_opp_get_voltage);
 
 /**
- * opp_get_freq() - Gets the frequency corresponding to an available opp
+ * dev_pm_opp_get_freq() - Gets the frequency corresponding to an available opp
  * @opp:	opp for which frequency has to be returned for
  *
  * Return frequency in hertz corresponding to the opp, else
@@ -180,7 +180,7 @@ EXPORT_SYMBOL_GPL(opp_get_voltage);
  * prior to unlocking with rcu_read_unlock() to maintain the integrity of the
  * pointer.
  */
-unsigned long opp_get_freq(struct opp *opp)
+unsigned long dev_pm_opp_get_freq(struct opp *opp)
 {
 	struct opp *tmp_opp;
 	unsigned long f = 0;
@@ -193,10 +193,10 @@ unsigned long opp_get_freq(struct opp *opp)
 
 	return f;
 }
-EXPORT_SYMBOL_GPL(opp_get_freq);
+EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq);
 
 /**
- * opp_get_opp_count() - Get number of opps available in the opp list
+ * dev_pm_opp_get_opp_count() - Get number of opps available in the opp list
  * @dev:	device for which we do this operation
  *
  * This function returns the number of available opps if there are any,
@@ -206,7 +206,7 @@ EXPORT_SYMBOL_GPL(opp_get_freq);
  * internally references two RCU protected structures: device_opp and opp which
  * are safe as long as we are under a common RCU locked section.
  */
-int opp_get_opp_count(struct device *dev)
+int dev_pm_opp_get_opp_count(struct device *dev)
 {
 	struct device_opp *dev_opp;
 	struct opp *temp_opp;
@@ -226,10 +226,10 @@ int opp_get_opp_count(struct device *dev)
 
 	return count;
 }
-EXPORT_SYMBOL_GPL(opp_get_opp_count);
+EXPORT_SYMBOL_GPL(dev_pm_opp_get_opp_count);
 
 /**
- * opp_find_freq_exact() - search for an exact frequency
+ * dev_pm_opp_find_freq_exact() - search for an exact frequency
  * @dev:		device for which we do this operation
  * @freq:		frequency to search for
  * @available:		true/false - match for available opp
@@ -254,7 +254,7 @@ EXPORT_SYMBOL_GPL(opp_get_opp_count);
  * under the locked area. The pointer returned must be used prior to unlocking
  * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
-struct opp *opp_find_freq_exact(struct device *dev, unsigned long freq,
+struct opp *dev_pm_opp_find_freq_exact(struct device *dev, unsigned long freq,
 				bool available)
 {
 	struct device_opp *dev_opp;
@@ -277,10 +277,10 @@ struct opp *opp_find_freq_exact(struct device *dev, unsigned long freq,
 
 	return opp;
 }
-EXPORT_SYMBOL_GPL(opp_find_freq_exact);
+EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_exact);
 
 /**
- * opp_find_freq_ceil() - Search for an rounded ceil freq
+ * dev_pm_opp_find_freq_ceil() - Search for an rounded ceil freq
  * @dev:	device for which we do this operation
  * @freq:	Start frequency
  *
@@ -300,7 +300,7 @@ EXPORT_SYMBOL_GPL(opp_find_freq_exact);
  * under the locked area. The pointer returned must be used prior to unlocking
  * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
-struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
+struct opp *dev_pm_opp_find_freq_ceil(struct device *dev, unsigned long *freq)
 {
 	struct device_opp *dev_opp;
 	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
@@ -324,10 +324,10 @@ struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq)
 
 	return opp;
 }
-EXPORT_SYMBOL_GPL(opp_find_freq_ceil);
+EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_ceil);
 
 /**
- * opp_find_freq_floor() - Search for a rounded floor freq
+ * dev_pm_opp_find_freq_floor() - Search for a rounded floor freq
  * @dev:	device for which we do this operation
  * @freq:	Start frequency
  *
@@ -347,7 +347,7 @@ EXPORT_SYMBOL_GPL(opp_find_freq_ceil);
  * under the locked area. The pointer returned must be used prior to unlocking
  * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
-struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
+struct opp *dev_pm_opp_find_freq_floor(struct device *dev, unsigned long *freq)
 {
 	struct device_opp *dev_opp;
 	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
@@ -375,17 +375,17 @@ struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq)
 
 	return opp;
 }
-EXPORT_SYMBOL_GPL(opp_find_freq_floor);
+EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
 
 /**
- * opp_add()  - Add an OPP table from a table definitions
+ * dev_pm_opp_add()  - Add an OPP table from a table definitions
  * @dev:	device for which we do this operation
  * @freq:	Frequency in Hz for this OPP
  * @u_volt:	Voltage in uVolts for this OPP
  *
  * This function adds an opp definition to the opp list and returns status.
  * The opp is made available by default and it can be controlled using
- * opp_enable/disable functions.
+ * dev_pm_opp_enable/disable functions.
  *
  * Locking: The internal device_opp and opp structures are RCU protected.
  * Hence this function internally uses RCU updater strategy with mutex locks
@@ -393,7 +393,7 @@ EXPORT_SYMBOL_GPL(opp_find_freq_floor);
  * that this function is *NOT* called under RCU protection or in contexts where
  * mutex cannot be locked.
  */
-int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
+int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 {
 	struct device_opp *dev_opp = NULL;
 	struct opp *opp, *new_opp;
@@ -460,7 +460,7 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(opp_add);
+EXPORT_SYMBOL_GPL(dev_pm_opp_add);
 
 /**
  * opp_set_availability() - helper to set the availability of an opp
@@ -552,13 +552,13 @@ unlock:
 }
 
 /**
- * opp_enable() - Enable a specific OPP
+ * dev_pm_opp_enable() - Enable a specific OPP
  * @dev:	device for which we do this operation
  * @freq:	OPP frequency to enable
  *
  * Enables a provided opp. If the operation is valid, this returns 0, else the
  * corresponding error value. It is meant to be used for users an OPP available
- * after being temporarily made unavailable with opp_disable.
+ * after being temporarily made unavailable with dev_pm_opp_disable.
  *
  * Locking: The internal device_opp and opp structures are RCU protected.
  * Hence this function indirectly uses RCU and mutex locks to keep the
@@ -566,21 +566,21 @@ unlock:
  * this function is *NOT* called under RCU protection or in contexts where
  * mutex locking or synchronize_rcu() blocking calls cannot be used.
  */
-int opp_enable(struct device *dev, unsigned long freq)
+int dev_pm_opp_enable(struct device *dev, unsigned long freq)
 {
 	return opp_set_availability(dev, freq, true);
 }
-EXPORT_SYMBOL_GPL(opp_enable);
+EXPORT_SYMBOL_GPL(dev_pm_opp_enable);
 
 /**
- * opp_disable() - Disable a specific OPP
+ * dev_pm_opp_disable() - Disable a specific OPP
  * @dev:	device for which we do this operation
  * @freq:	OPP frequency to disable
  *
  * Disables a provided opp. If the operation is valid, this returns
  * 0, else the corresponding error value. It is meant to be a temporary
  * control by users to make this OPP not available until the circumstances are
- * right to make it available again (with a call to opp_enable).
+ * right to make it available again (with a call to dev_pm_opp_enable).
  *
  * Locking: The internal device_opp and opp structures are RCU protected.
  * Hence this function indirectly uses RCU and mutex locks to keep the
@@ -588,15 +588,15 @@ EXPORT_SYMBOL_GPL(opp_enable);
  * this function is *NOT* called under RCU protection or in contexts where
  * mutex locking or synchronize_rcu() blocking calls cannot be used.
  */
-int opp_disable(struct device *dev, unsigned long freq)
+int dev_pm_opp_disable(struct device *dev, unsigned long freq)
 {
 	return opp_set_availability(dev, freq, false);
 }
-EXPORT_SYMBOL_GPL(opp_disable);
+EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
 
 #ifdef CONFIG_CPU_FREQ
 /**
- * opp_init_cpufreq_table() - create a cpufreq table for a device
+ * dev_pm_opp_init_cpufreq_table() - create a cpufreq table for a device
  * @dev:	device for which we do this operation
  * @table:	Cpufreq table returned back to caller
  *
@@ -619,7 +619,7 @@ EXPORT_SYMBOL_GPL(opp_disable);
  * Callers should ensure that this function is *NOT* called under RCU protection
  * or in contexts where mutex locking cannot be used.
  */
-int opp_init_cpufreq_table(struct device *dev,
+int dev_pm_opp_init_cpufreq_table(struct device *dev,
 			    struct cpufreq_frequency_table **table)
 {
 	struct device_opp *dev_opp;
@@ -639,7 +639,7 @@ int opp_init_cpufreq_table(struct device *dev,
 	}
 
 	freq_table = kzalloc(sizeof(struct cpufreq_frequency_table) *
-			     (opp_get_opp_count(dev) + 1), GFP_KERNEL);
+			     (dev_pm_opp_get_opp_count(dev) + 1), GFP_KERNEL);
 	if (!freq_table) {
 		mutex_unlock(&dev_opp_list_lock);
 		dev_warn(dev, "%s: Unable to allocate frequency table\n",
@@ -663,16 +663,16 @@ int opp_init_cpufreq_table(struct device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(opp_init_cpufreq_table);
+EXPORT_SYMBOL_GPL(dev_pm_opp_init_cpufreq_table);
 
 /**
- * opp_free_cpufreq_table() - free the cpufreq table
+ * dev_pm_opp_free_cpufreq_table() - free the cpufreq table
  * @dev:	device for which we do this operation
  * @table:	table to free
  *
- * Free up the table allocated by opp_init_cpufreq_table
+ * Free up the table allocated by dev_pm_opp_init_cpufreq_table
  */
-void opp_free_cpufreq_table(struct device *dev,
+void dev_pm_opp_free_cpufreq_table(struct device *dev,
 				struct cpufreq_frequency_table **table)
 {
 	if (!table)
@@ -681,14 +681,14 @@ void opp_free_cpufreq_table(struct device *dev,
 	kfree(*table);
 	*table = NULL;
 }
-EXPORT_SYMBOL_GPL(opp_free_cpufreq_table);
+EXPORT_SYMBOL_GPL(dev_pm_opp_free_cpufreq_table);
 #endif		/* CONFIG_CPU_FREQ */
 
 /**
- * opp_get_notifier() - find notifier_head of the device with opp
+ * dev_pm_opp_get_notifier() - find notifier_head of the device with opp
  * @dev:	device pointer used to lookup device OPPs.
  */
-struct srcu_notifier_head *opp_get_notifier(struct device *dev)
+struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev)
 {
 	struct device_opp *dev_opp = find_device_opp(dev);
 
@@ -732,7 +732,7 @@ int of_init_opp_table(struct device *dev)
 		unsigned long freq = be32_to_cpup(val++) * 1000;
 		unsigned long volt = be32_to_cpup(val++);
 
-		if (opp_add(dev, freq, volt)) {
+		if (dev_pm_opp_add(dev, freq, volt)) {
 			dev_warn(dev, "%s: Failed to add OPP %ld\n",
 				 __func__, freq);
 			continue;
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 3549f07..9e82a9d 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -98,7 +98,7 @@ static void put_cluster_clk_and_freq_table(struct device *cpu_dev)
 
 	if (!atomic_dec_return(&cluster_usage[cluster])) {
 		clk_put(clk[cluster]);
-		opp_free_cpufreq_table(cpu_dev, &freq_table[cluster]);
+		dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table[cluster]);
 		dev_dbg(cpu_dev, "%s: cluster: %d\n", __func__, cluster);
 	}
 }
@@ -119,7 +119,7 @@ static int get_cluster_clk_and_freq_table(struct device *cpu_dev)
 		goto atomic_dec;
 	}
 
-	ret = opp_init_cpufreq_table(cpu_dev, &freq_table[cluster]);
+	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table[cluster]);
 	if (ret) {
 		dev_err(cpu_dev, "%s: failed to init cpufreq table, cpu: %d, err: %d\n",
 				__func__, cpu_dev->id, ret);
@@ -138,7 +138,7 @@ static int get_cluster_clk_and_freq_table(struct device *cpu_dev)
 	dev_err(cpu_dev, "%s: Failed to get clk for cpu: %d, cluster: %d\n",
 			__func__, cpu_dev->id, cluster);
 	ret = PTR_ERR(clk[cluster]);
-	opp_free_cpufreq_table(cpu_dev, &freq_table[cluster]);
+	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table[cluster]);
 
 atomic_dec:
 	atomic_dec(&cluster_usage[cluster]);
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index cbfffa9..caf3e36 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -71,7 +71,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 
 	if (!IS_ERR(cpu_reg)) {
 		rcu_read_lock();
-		opp = opp_find_freq_ceil(cpu_dev, &freq_Hz);
+		opp = dev_pm_opp_find_freq_ceil(cpu_dev, &freq_Hz);
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			pr_err("failed to find OPP for %ld\n", freq_Hz);
@@ -79,7 +79,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 			ret = PTR_ERR(opp);
 			goto post_notify;
 		}
-		volt = opp_get_voltage(opp);
+		volt = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
 		tol = volt * voltage_tolerance / 100;
 		volt_old = regulator_get_voltage(cpu_reg);
@@ -213,7 +213,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		goto out_put_node;
 	}
 
-	ret = opp_init_cpufreq_table(cpu_dev, &freq_table);
+	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
 		pr_err("failed to init cpufreq table: %d\n", ret);
 		goto out_put_node;
@@ -237,12 +237,12 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
 			;
 		rcu_read_lock();
-		opp = opp_find_freq_exact(cpu_dev,
+		opp = dev_pm_opp_find_freq_exact(cpu_dev,
 				freq_table[0].frequency * 1000, true);
-		min_uV = opp_get_voltage(opp);
-		opp = opp_find_freq_exact(cpu_dev,
+		min_uV = dev_pm_opp_get_voltage(opp);
+		opp = dev_pm_opp_find_freq_exact(cpu_dev,
 				freq_table[i-1].frequency * 1000, true);
-		max_uV = opp_get_voltage(opp);
+		max_uV = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
 		ret = regulator_set_voltage_time(cpu_reg, min_uV, max_uV);
 		if (ret > 0)
@@ -259,7 +259,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	return 0;
 
 out_free_table:
-	opp_free_cpufreq_table(cpu_dev, &freq_table);
+	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 out_put_node:
 	of_node_put(np);
 	return ret;
@@ -268,7 +268,7 @@ out_put_node:
 static int cpu0_cpufreq_remove(struct platform_device *pdev)
 {
 	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
-	opp_free_cpufreq_table(cpu_dev, &freq_table);
+	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index d514c15..cac0be2 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -123,7 +123,7 @@ static int init_div_table(void)
 	rcu_read_lock();
 	for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
 
-		opp = opp_find_freq_exact(dvfs_info->dev,
+		opp = dev_pm_opp_find_freq_exact(dvfs_info->dev,
 					freq_tbl[i].frequency * 1000, true);
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
@@ -142,7 +142,7 @@ static int init_div_table(void)
 					<< P0_7_CSCLKDEV_SHIFT;
 
 		/* Calculate EMA */
-		volt_id = opp_get_voltage(opp);
+		volt_id = dev_pm_opp_get_voltage(opp);
 		volt_id = (MAX_VOLTAGE - volt_id) / VOLTAGE_STEP;
 		if (volt_id < PMIC_HIGH_VOLT) {
 			ema_div = (CPUEMA_HIGH << P0_7_CPUEMA_SHIFT) |
@@ -399,13 +399,14 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 		goto err_put_node;
 	}
 
-	ret = opp_init_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
+	ret = dev_pm_opp_init_cpufreq_table(dvfs_info->dev,
+					    &dvfs_info->freq_table);
 	if (ret) {
 		dev_err(dvfs_info->dev,
 			"failed to init cpufreq table: %d\n", ret);
 		goto err_put_node;
 	}
-	dvfs_info->freq_count = opp_get_opp_count(dvfs_info->dev);
+	dvfs_info->freq_count = dev_pm_opp_get_opp_count(dvfs_info->dev);
 	exynos_sort_descend_freq_table();
 
 	if (of_property_read_u32(np, "clock-latency", &dvfs_info->latency))
@@ -454,7 +455,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 	return 0;
 
 err_free_table:
-	opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
+	dev_pm_opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
 err_put_node:
 	of_node_put(np);
 	dev_err(dvfs_info->dev, "%s: failed initialization\n", __func__);
@@ -464,7 +465,7 @@ err_put_node:
 static int exynos_cpufreq_remove(struct platform_device *pdev)
 {
 	cpufreq_unregister_driver(&exynos_driver);
-	opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
+	dev_pm_opp_free_cpufreq_table(dvfs_info->dev, &dvfs_info->freq_table);
 	return 0;
 }
 
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 3e39654..b4bf127 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -69,14 +69,14 @@ static int imx6q_set_target(struct cpufreq_policy *policy,
 		return 0;
 
 	rcu_read_lock();
-	opp = opp_find_freq_ceil(cpu_dev, &freq_hz);
+	opp = dev_pm_opp_find_freq_ceil(cpu_dev, &freq_hz);
 	if (IS_ERR(opp)) {
 		rcu_read_unlock();
 		dev_err(cpu_dev, "failed to find OPP for %ld\n", freq_hz);
 		return PTR_ERR(opp);
 	}
 
-	volt = opp_get_voltage(opp);
+	volt = dev_pm_opp_get_voltage(opp);
 	rcu_read_unlock();
 	volt_old = regulator_get_voltage(arm_reg);
 
@@ -232,14 +232,14 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	}
 
 	/* We expect an OPP table supplied by platform */
-	num = opp_get_opp_count(cpu_dev);
+	num = dev_pm_opp_get_opp_count(cpu_dev);
 	if (num < 0) {
 		ret = num;
 		dev_err(cpu_dev, "no OPP table is found: %d\n", ret);
 		goto put_node;
 	}
 
-	ret = opp_init_cpufreq_table(cpu_dev, &freq_table);
+	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
 		dev_err(cpu_dev, "failed to init cpufreq table: %d\n", ret);
 		goto put_node;
@@ -254,12 +254,12 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	 * same order.
 	 */
 	rcu_read_lock();
-	opp = opp_find_freq_exact(cpu_dev,
+	opp = dev_pm_opp_find_freq_exact(cpu_dev,
 				  freq_table[0].frequency * 1000, true);
-	min_volt = opp_get_voltage(opp);
-	opp = opp_find_freq_exact(cpu_dev,
+	min_volt = dev_pm_opp_get_voltage(opp);
+	opp = dev_pm_opp_find_freq_exact(cpu_dev,
 				  freq_table[--num].frequency * 1000, true);
-	max_volt = opp_get_voltage(opp);
+	max_volt = dev_pm_opp_get_voltage(opp);
 	rcu_read_unlock();
 	ret = regulator_set_voltage_time(arm_reg, min_volt, max_volt);
 	if (ret > 0)
@@ -287,7 +287,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	return 0;
 
 free_freq_table:
-	opp_free_cpufreq_table(cpu_dev, &freq_table);
+	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 put_node:
 	of_node_put(np);
 	return ret;
@@ -296,7 +296,7 @@ put_node:
 static int imx6q_cpufreq_remove(struct platform_device *pdev)
 {
 	cpufreq_unregister_driver(&imx6q_cpufreq_driver);
-	opp_free_cpufreq_table(cpu_dev, &freq_table);
+	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index f31fcfc..c5e31d2 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -105,14 +105,14 @@ static int omap_target(struct cpufreq_policy *policy,
 
 	if (mpu_reg) {
 		rcu_read_lock();
-		opp = opp_find_freq_ceil(mpu_dev, &freq);
+		opp = dev_pm_opp_find_freq_ceil(mpu_dev, &freq);
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			dev_err(mpu_dev, "%s: unable to find MPU OPP for %d\n",
 				__func__, freqs.new);
 			return -EINVAL;
 		}
-		volt = opp_get_voltage(opp);
+		volt = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
 		tol = volt * OPP_TOLERANCE / 100;
 		volt_old = regulator_get_voltage(mpu_reg);
@@ -162,7 +162,7 @@ done:
 static inline void freq_table_free(void)
 {
 	if (atomic_dec_and_test(&freq_table_users))
-		opp_free_cpufreq_table(mpu_dev, &freq_table);
+		dev_pm_opp_free_cpufreq_table(mpu_dev, &freq_table);
 }
 
 static int omap_cpu_init(struct cpufreq_policy *policy)
@@ -181,7 +181,7 @@ static int omap_cpu_init(struct cpufreq_policy *policy)
 	policy->cur = omap_getspeed(policy->cpu);
 
 	if (!freq_table)
-		result = opp_init_cpufreq_table(mpu_dev, &freq_table);
+		result = dev_pm_opp_init_cpufreq_table(mpu_dev, &freq_table);
 
 	if (result) {
 		dev_err(mpu_dev, "%s: cpu%d: failed creating freq table[%d]\n",
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index c99c00d..f798edc 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -908,7 +908,7 @@ static ssize_t available_frequencies_show(struct device *d,
 
 	rcu_read_lock();
 	do {
-		opp = opp_find_freq_ceil(dev, &freq);
+		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
 		if (IS_ERR(opp))
 			break;
 
@@ -1036,18 +1036,18 @@ struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
 
 	if (flags & DEVFREQ_FLAG_LEAST_UPPER_BOUND) {
 		/* The freq is an upper bound. opp should be lower */
-		opp = opp_find_freq_floor(dev, freq);
+		opp = dev_pm_opp_find_freq_floor(dev, freq);
 
 		/* If not available, use the closest opp */
 		if (opp == ERR_PTR(-ERANGE))
-			opp = opp_find_freq_ceil(dev, freq);
+			opp = dev_pm_opp_find_freq_ceil(dev, freq);
 	} else {
 		/* The freq is an lower bound. opp should be higher */
-		opp = opp_find_freq_ceil(dev, freq);
+		opp = dev_pm_opp_find_freq_ceil(dev, freq);
 
 		/* If not available, use the closest opp */
 		if (opp == ERR_PTR(-ERANGE))
-			opp = opp_find_freq_floor(dev, freq);
+			opp = dev_pm_opp_find_freq_floor(dev, freq);
 	}
 
 	return opp;
@@ -1066,7 +1066,7 @@ int devfreq_register_opp_notifier(struct device *dev, struct devfreq *devfreq)
 	int ret = 0;
 
 	rcu_read_lock();
-	nh = opp_get_notifier(dev);
+	nh = dev_pm_opp_get_notifier(dev);
 	if (IS_ERR(nh))
 		ret = PTR_ERR(nh);
 	rcu_read_unlock();
@@ -1092,7 +1092,7 @@ int devfreq_unregister_opp_notifier(struct device *dev, struct devfreq *devfreq)
 	int ret = 0;
 
 	rcu_read_lock();
-	nh = opp_get_notifier(dev);
+	nh = dev_pm_opp_get_notifier(dev);
 	if (IS_ERR(nh))
 		ret = PTR_ERR(nh);
 	rcu_read_unlock();
diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index c5f86d8..33c0e05 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -650,8 +650,8 @@ static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
 		rcu_read_unlock();
 		return PTR_ERR(opp);
 	}
-	new_oppinfo.rate = opp_get_freq(opp);
-	new_oppinfo.volt = opp_get_voltage(opp);
+	new_oppinfo.rate = dev_pm_opp_get_freq(opp);
+	new_oppinfo.volt = dev_pm_opp_get_voltage(opp);
 	rcu_read_unlock();
 	freq = new_oppinfo.rate;
 
@@ -873,7 +873,7 @@ static int exynos4210_init_tables(struct busfreq_data *data)
 		exynos4210_busclk_table[i].volt = exynos4210_asv_volt[mgrp][i];
 
 	for (i = LV_0; i < EX4210_LV_NUM; i++) {
-		err = opp_add(data->dev, exynos4210_busclk_table[i].clk,
+		err = dev_pm_opp_add(data->dev, exynos4210_busclk_table[i].clk,
 			      exynos4210_busclk_table[i].volt);
 		if (err) {
 			dev_err(data->dev, "Cannot add opp entries.\n");
@@ -940,7 +940,7 @@ static int exynos4x12_init_tables(struct busfreq_data *data)
 	}
 
 	for (i = 0; i < EX4x12_LV_NUM; i++) {
-		ret = opp_add(data->dev, exynos4x12_mifclk_table[i].clk,
+		ret = dev_pm_opp_add(data->dev, exynos4x12_mifclk_table[i].clk,
 			      exynos4x12_mifclk_table[i].volt);
 		if (ret) {
 			dev_err(data->dev, "Fail to add opp entries.\n");
@@ -969,7 +969,7 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
 		data->disabled = true;
 
 		rcu_read_lock();
-		opp = opp_find_freq_floor(data->dev, &maxfreq);
+		opp = dev_pm_opp_find_freq_floor(data->dev, &maxfreq);
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			dev_err(data->dev, "%s: unable to find a min freq\n",
@@ -977,8 +977,8 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
 			mutex_unlock(&data->lock);
 			return PTR_ERR(opp);
 		}
-		new_oppinfo.rate = opp_get_freq(opp);
-		new_oppinfo.volt = opp_get_voltage(opp);
+		new_oppinfo.rate = dev_pm_opp_get_freq(opp);
+		new_oppinfo.volt = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
 
 		err = exynos4_bus_setvolt(data, &new_oppinfo,
@@ -1065,15 +1065,16 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	}
 
 	rcu_read_lock();
-	opp = opp_find_freq_floor(dev, &exynos4_devfreq_profile.initial_freq);
+	opp = dev_pm_opp_find_freq_floor(dev,
+					 &exynos4_devfreq_profile.initial_freq);
 	if (IS_ERR(opp)) {
 		rcu_read_unlock();
 		dev_err(dev, "Invalid initial frequency %lu kHz.\n",
 			exynos4_devfreq_profile.initial_freq);
 		return PTR_ERR(opp);
 	}
-	data->curr_oppinfo.rate = opp_get_freq(opp);
-	data->curr_oppinfo.volt = opp_get_voltage(opp);
+	data->curr_oppinfo.rate = dev_pm_opp_get_freq(opp);
+	data->curr_oppinfo.volt = dev_pm_opp_get_voltage(opp);
 	rcu_read_unlock();
 
 	platform_set_drvdata(pdev, data);
diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index 574b16b..b0e4592 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -144,8 +144,8 @@ static int exynos5_busfreq_int_target(struct device *dev, unsigned long *_freq,
 		return PTR_ERR(opp);
 	}
 
-	freq = opp_get_freq(opp);
-	volt = opp_get_voltage(opp);
+	freq = dev_pm_opp_get_freq(opp);
+	volt = dev_pm_opp_get_voltage(opp);
 	rcu_read_unlock();
 
 	old_freq = data->curr_freq;
@@ -246,7 +246,7 @@ static int exynos5250_init_int_tables(struct busfreq_data_int *data)
 	int i, err = 0;
 
 	for (i = LV_0; i < _LV_END; i++) {
-		err = opp_add(data->dev, exynos5_int_opp_table[i].clk,
+		err = dev_pm_opp_add(data->dev, exynos5_int_opp_table[i].clk,
 				exynos5_int_opp_table[i].volt);
 		if (err) {
 			dev_err(data->dev, "Cannot add opp entries.\n");
@@ -276,14 +276,14 @@ static int exynos5_busfreq_int_pm_notifier_event(struct notifier_block *this,
 		data->disabled = true;
 
 		rcu_read_lock();
-		opp = opp_find_freq_floor(data->dev, &maxfreq);
+		opp = dev_pm_opp_find_freq_floor(data->dev, &maxfreq);
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			err = PTR_ERR(opp);
 			goto unlock;
 		}
-		freq = opp_get_freq(opp);
-		volt = opp_get_voltage(opp);
+		freq = dev_pm_opp_get_freq(opp);
+		volt = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
 
 		err = exynos5_int_setvolt(data, volt);
@@ -368,7 +368,7 @@ static int exynos5_busfreq_int_probe(struct platform_device *pdev)
 	}
 
 	rcu_read_lock();
-	opp = opp_find_freq_floor(dev,
+	opp = dev_pm_opp_find_freq_floor(dev,
 			&exynos5_devfreq_int_profile.initial_freq);
 	if (IS_ERR(opp)) {
 		rcu_read_unlock();
@@ -377,8 +377,8 @@ static int exynos5_busfreq_int_probe(struct platform_device *pdev)
 		err = PTR_ERR(opp);
 		goto err_opp_add;
 	}
-	initial_freq = opp_get_freq(opp);
-	initial_volt = opp_get_voltage(opp);
+	initial_freq = dev_pm_opp_get_freq(opp);
+	initial_volt = dev_pm_opp_get_voltage(opp);
 	rcu_read_unlock();
 	data->curr_freq = initial_freq;
 
diff --git a/include/linux/opp.h b/include/linux/opp.h
index 3aca2b8..2066ae5 100644
--- a/include/linux/opp.h
+++ b/include/linux/opp.h
@@ -27,77 +27,79 @@ enum opp_event {
 
 #if defined(CONFIG_PM_OPP)
 
-unsigned long opp_get_voltage(struct opp *opp);
+unsigned long dev_pm_opp_get_voltage(struct opp *opp);
 
-unsigned long opp_get_freq(struct opp *opp);
+unsigned long dev_pm_opp_get_freq(struct opp *opp);
 
-int opp_get_opp_count(struct device *dev);
+int dev_pm_opp_get_opp_count(struct device *dev);
 
-struct opp *opp_find_freq_exact(struct device *dev, unsigned long freq,
+struct opp *dev_pm_opp_find_freq_exact(struct device *dev, unsigned long freq,
 				bool available);
 
-struct opp *opp_find_freq_floor(struct device *dev, unsigned long *freq);
+struct opp *dev_pm_opp_find_freq_floor(struct device *dev, unsigned long *freq);
 
-struct opp *opp_find_freq_ceil(struct device *dev, unsigned long *freq);
+struct opp *dev_pm_opp_find_freq_ceil(struct device *dev, unsigned long *freq);
 
-int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt);
+int dev_pm_opp_add(struct device *dev, unsigned long freq,
+		   unsigned long u_volt);
 
-int opp_enable(struct device *dev, unsigned long freq);
+int dev_pm_opp_enable(struct device *dev, unsigned long freq);
 
-int opp_disable(struct device *dev, unsigned long freq);
+int dev_pm_opp_disable(struct device *dev, unsigned long freq);
 
-struct srcu_notifier_head *opp_get_notifier(struct device *dev);
+struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev);
 #else
-static inline unsigned long opp_get_voltage(struct opp *opp)
+static inline unsigned long dev_pm_opp_get_voltage(struct opp *opp)
 {
 	return 0;
 }
 
-static inline unsigned long opp_get_freq(struct opp *opp)
+static inline unsigned long dev_pm_opp_get_freq(struct opp *opp)
 {
 	return 0;
 }
 
-static inline int opp_get_opp_count(struct device *dev)
+static inline int dev_pm_opp_get_opp_count(struct device *dev)
 {
 	return 0;
 }
 
-static inline struct opp *opp_find_freq_exact(struct device *dev,
+static inline struct opp *dev_pm_opp_find_freq_exact(struct device *dev,
 					unsigned long freq, bool available)
 {
 	return ERR_PTR(-EINVAL);
 }
 
-static inline struct opp *opp_find_freq_floor(struct device *dev,
+static inline struct opp *dev_pm_opp_find_freq_floor(struct device *dev,
 					unsigned long *freq)
 {
 	return ERR_PTR(-EINVAL);
 }
 
-static inline struct opp *opp_find_freq_ceil(struct device *dev,
+static inline struct opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 					unsigned long *freq)
 {
 	return ERR_PTR(-EINVAL);
 }
 
-static inline int opp_add(struct device *dev, unsigned long freq,
+static inline int dev_pm_opp_add(struct device *dev, unsigned long freq,
 					unsigned long u_volt)
 {
 	return -EINVAL;
 }
 
-static inline int opp_enable(struct device *dev, unsigned long freq)
+static inline int dev_pm_opp_enable(struct device *dev, unsigned long freq)
 {
 	return 0;
 }
 
-static inline int opp_disable(struct device *dev, unsigned long freq)
+static inline int dev_pm_opp_disable(struct device *dev, unsigned long freq)
 {
 	return 0;
 }
 
-static inline struct srcu_notifier_head *opp_get_notifier(struct device *dev)
+static inline struct srcu_notifier_head *dev_pm_opp_get_notifier(
+							struct device *dev)
 {
 	return ERR_PTR(-EINVAL);
 }
@@ -113,19 +115,19 @@ static inline int of_init_opp_table(struct device *dev)
 #endif
 
 #if defined(CONFIG_CPU_FREQ) && defined(CONFIG_PM_OPP)
-int opp_init_cpufreq_table(struct device *dev,
+int dev_pm_opp_init_cpufreq_table(struct device *dev,
 			    struct cpufreq_frequency_table **table);
-void opp_free_cpufreq_table(struct device *dev,
+void dev_pm_opp_free_cpufreq_table(struct device *dev,
 				struct cpufreq_frequency_table **table);
 #else
-static inline int opp_init_cpufreq_table(struct device *dev,
+static inline int dev_pm_opp_init_cpufreq_table(struct device *dev,
 			    struct cpufreq_frequency_table **table)
 {
 	return -EINVAL;
 }
 
 static inline
-void opp_free_cpufreq_table(struct device *dev,
+void dev_pm_opp_free_cpufreq_table(struct device *dev,
 				struct cpufreq_frequency_table **table)
 {
 }
-- 
1.7.9.5

