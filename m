Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3ISVFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:05:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34695 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab3ISVF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:05:26 -0400
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
Subject: [PATCH 2/3] PM / OPP: rename data structures to dev_pm equivalents
Date: Thu, 19 Sep 2013 16:03:51 -0500
Message-ID: <1379624632-17356-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379624632-17356-1-git-send-email-nm@ti.com>
References: <1379624632-17356-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Operating Performance Points(OPP) data structures are specific
to device specific power management, be specific and rename opp_* data
structures in OPP library with dev_pm_opp_* equivalent.

Impacted structures are:
struct opp
enum opp_event

Minor checkpatch warning fixes as a result of this change was fixed as
well.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 Documentation/power/opp.txt          |    4 ++--
 arch/arm/mach-omap2/pm.c             |    2 +-
 drivers/base/power/opp.c             |   41 ++++++++++++++++++----------------
 drivers/cpufreq/cpufreq-cpu0.c       |    4 ++--
 drivers/cpufreq/exynos5440-cpufreq.c |    2 +-
 drivers/cpufreq/imx6q-cpufreq.c      |    4 ++--
 drivers/cpufreq/omap-cpufreq.c       |    2 +-
 drivers/devfreq/devfreq.c            |    9 ++++----
 drivers/devfreq/exynos/exynos4_bus.c |    6 ++---
 drivers/devfreq/exynos/exynos5_bus.c |    6 ++---
 include/linux/devfreq.h              |    4 ++--
 include/linux/opp.h                  |   29 +++++++++++++-----------
 12 files changed, 60 insertions(+), 53 deletions(-)

diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
index 185367b..7f67e3d 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.txt
@@ -358,14 +358,14 @@ accessed by various functions as described above. However, the structures
 representing the actual OPPs and domains are internal to the OPP library itself
 to allow for suitable abstraction reusable across systems.
 
-struct opp - The internal data structure of OPP library which is used to
+struct dev_pm_opp - The internal data structure of OPP library which is used to
 	represent an OPP. In addition to the freq, voltage, availability
 	information, it also contains internal book keeping information required
 	for the OPP library to operate on.  Pointer to this structure is
 	provided back to the users such as SoC framework to be used as a
 	identifier for OPP in the interactions with OPP layer.
 
-	WARNING: The struct opp pointer should not be parsed or modified by the
+	WARNING: The struct dev_pm_opp pointer should not be parsed or modified by the
 	users. The defaults of for an instance is populated by dev_pm_opp_add, but the
 	availability of the OPP can be modified by dev_pm_opp_enable/disable functions.
 
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 937744c..92901bd 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -131,7 +131,7 @@ static int __init omap2_set_init_voltage(char *vdd_name, char *clk_name,
 {
 	struct voltagedomain *voltdm;
 	struct clk *clk;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	unsigned long freq, bootup_volt;
 	struct device *dev;
 
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 00c6a44..693e14a 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -42,7 +42,7 @@
  */
 
 /**
- * struct opp - Generic OPP description structure
+ * struct dev_pm_opp - Generic OPP description structure
  * @node:	opp list node. The nodes are maintained throughout the lifetime
  *		of boot. It is expected only an optimal set of OPPs are
  *		added to the library by the SoC framework.
@@ -59,7 +59,7 @@
  *
  * This structure stores the OPP information for a given device.
  */
-struct opp {
+struct dev_pm_opp {
 	struct list_head node;
 
 	bool available;
@@ -150,9 +150,9 @@ static struct device_opp *find_device_opp(struct device *dev)
  * prior to unlocking with rcu_read_unlock() to maintain the integrity of the
  * pointer.
  */
-unsigned long dev_pm_opp_get_voltage(struct opp *opp)
+unsigned long dev_pm_opp_get_voltage(struct dev_pm_opp *opp)
 {
-	struct opp *tmp_opp;
+	struct dev_pm_opp *tmp_opp;
 	unsigned long v = 0;
 
 	tmp_opp = rcu_dereference(opp);
@@ -180,9 +180,9 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_voltage);
  * prior to unlocking with rcu_read_unlock() to maintain the integrity of the
  * pointer.
  */
-unsigned long dev_pm_opp_get_freq(struct opp *opp)
+unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
 {
-	struct opp *tmp_opp;
+	struct dev_pm_opp *tmp_opp;
 	unsigned long f = 0;
 
 	tmp_opp = rcu_dereference(opp);
@@ -209,7 +209,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq);
 int dev_pm_opp_get_opp_count(struct device *dev)
 {
 	struct device_opp *dev_opp;
-	struct opp *temp_opp;
+	struct dev_pm_opp *temp_opp;
 	int count = 0;
 
 	dev_opp = find_device_opp(dev);
@@ -254,11 +254,12 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_opp_count);
  * under the locked area. The pointer returned must be used prior to unlocking
  * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
-struct opp *dev_pm_opp_find_freq_exact(struct device *dev, unsigned long freq,
-				bool available)
+struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
+					      unsigned long freq,
+					      bool available)
 {
 	struct device_opp *dev_opp;
-	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
+	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
 	dev_opp = find_device_opp(dev);
 	if (IS_ERR(dev_opp)) {
@@ -300,10 +301,11 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_exact);
  * under the locked area. The pointer returned must be used prior to unlocking
  * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
-struct opp *dev_pm_opp_find_freq_ceil(struct device *dev, unsigned long *freq)
+struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
+					     unsigned long *freq)
 {
 	struct device_opp *dev_opp;
-	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
+	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
 	if (!dev || !freq) {
 		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
@@ -347,10 +349,11 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_ceil);
  * under the locked area. The pointer returned must be used prior to unlocking
  * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
-struct opp *dev_pm_opp_find_freq_floor(struct device *dev, unsigned long *freq)
+struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
+					      unsigned long *freq)
 {
 	struct device_opp *dev_opp;
-	struct opp *temp_opp, *opp = ERR_PTR(-ERANGE);
+	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
 
 	if (!dev || !freq) {
 		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
@@ -396,11 +399,11 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
 int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 {
 	struct device_opp *dev_opp = NULL;
-	struct opp *opp, *new_opp;
+	struct dev_pm_opp *opp, *new_opp;
 	struct list_head *head;
 
 	/* allocate new OPP node */
-	new_opp = kzalloc(sizeof(struct opp), GFP_KERNEL);
+	new_opp = kzalloc(sizeof(*new_opp), GFP_KERNEL);
 	if (!new_opp) {
 		dev_warn(dev, "%s: Unable to create new OPP node\n", __func__);
 		return -ENOMEM;
@@ -485,11 +488,11 @@ static int opp_set_availability(struct device *dev, unsigned long freq,
 		bool availability_req)
 {
 	struct device_opp *tmp_dev_opp, *dev_opp = ERR_PTR(-ENODEV);
-	struct opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
+	struct dev_pm_opp *new_opp, *tmp_opp, *opp = ERR_PTR(-ENODEV);
 	int r = 0;
 
 	/* keep the node allocated */
-	new_opp = kmalloc(sizeof(struct opp), GFP_KERNEL);
+	new_opp = kmalloc(sizeof(*new_opp), GFP_KERNEL);
 	if (!new_opp) {
 		dev_warn(dev, "%s: Unable to create OPP\n", __func__);
 		return -ENOMEM;
@@ -623,7 +626,7 @@ int dev_pm_opp_init_cpufreq_table(struct device *dev,
 			    struct cpufreq_frequency_table **table)
 {
 	struct device_opp *dev_opp;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	struct cpufreq_frequency_table *freq_table;
 	int i = 0;
 
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index caf3e36..ac67ea7 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -43,7 +43,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 			   unsigned int target_freq, unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	unsigned long volt = 0, volt_old = 0, tol = 0;
 	long freq_Hz, freq_exact;
 	unsigned int index;
@@ -225,7 +225,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		transition_latency = CPUFREQ_ETERNAL;
 
 	if (cpu_reg) {
-		struct opp *opp;
+		struct dev_pm_opp *opp;
 		unsigned long min_uV, max_uV;
 		int i;
 
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index cac0be2..070923e 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -118,7 +118,7 @@ static int init_div_table(void)
 	struct cpufreq_frequency_table *freq_tbl = dvfs_info->freq_table;
 	unsigned int tmp, clk_div, ema_div, freq, volt_id;
 	int i = 0;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 
 	rcu_read_lock();
 	for (i = 0; freq_tbl[i].frequency != CPUFREQ_TABLE_END; i++) {
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index b4bf127..0a3b59d 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -48,7 +48,7 @@ static int imx6q_set_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq, unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	unsigned long freq_hz, volt, volt_old;
 	unsigned int index;
 	int ret;
@@ -198,7 +198,7 @@ static struct cpufreq_driver imx6q_cpufreq_driver = {
 static int imx6q_cpufreq_probe(struct platform_device *pdev)
 {
 	struct device_node *np;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	unsigned long min_volt, max_volt;
 	int num, ret;
 
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index c5e31d2..f057d42 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -65,7 +65,7 @@ static int omap_target(struct cpufreq_policy *policy,
 	unsigned int i;
 	int r, ret = 0;
 	struct cpufreq_freqs freqs;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
 
 	if (!freq_table) {
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index f798edc..03530a0 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -902,7 +902,7 @@ static ssize_t available_frequencies_show(struct device *d,
 {
 	struct devfreq *df = to_devfreq(d);
 	struct device *dev = df->dev.parent;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	ssize_t count = 0;
 	unsigned long freq = 0;
 
@@ -1029,10 +1029,11 @@ module_exit(devfreq_exit);
  * under the locked area. The pointer returned must be used prior to unlocking
  * with rcu_read_unlock() to maintain the integrity of the pointer.
  */
-struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
-				    u32 flags)
+struct dev_pm_opp *devfreq_recommended_opp(struct device *dev,
+					   unsigned long *freq,
+					   u32 flags)
 {
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 
 	if (flags & DEVFREQ_FLAG_LEAST_UPPER_BOUND) {
 		/* The freq is an upper bound. opp should be lower */
diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 33c0e05..891becd 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -639,7 +639,7 @@ static int exynos4_bus_target(struct device *dev, unsigned long *_freq,
 	struct platform_device *pdev = container_of(dev, struct platform_device,
 						    dev);
 	struct busfreq_data *data = platform_get_drvdata(pdev);
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	unsigned long freq;
 	unsigned long old_freq = data->curr_oppinfo.rate;
 	struct busfreq_opp_info	new_oppinfo;
@@ -956,7 +956,7 @@ static int exynos4_busfreq_pm_notifier_event(struct notifier_block *this,
 {
 	struct busfreq_data *data = container_of(this, struct busfreq_data,
 						 pm_notifier);
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	struct busfreq_opp_info	new_oppinfo;
 	unsigned long maxfreq = ULONG_MAX;
 	int err = 0;
@@ -1020,7 +1020,7 @@ unlock:
 static int exynos4_busfreq_probe(struct platform_device *pdev)
 {
 	struct busfreq_data *data;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	struct device *dev = &pdev->dev;
 	int err = 0;
 
diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index b0e4592..d06232a 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -132,7 +132,7 @@ static int exynos5_busfreq_int_target(struct device *dev, unsigned long *_freq,
 	struct platform_device *pdev = container_of(dev, struct platform_device,
 						    dev);
 	struct busfreq_data_int *data = platform_get_drvdata(pdev);
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	unsigned long old_freq, freq;
 	unsigned long volt;
 
@@ -262,7 +262,7 @@ static int exynos5_busfreq_int_pm_notifier_event(struct notifier_block *this,
 {
 	struct busfreq_data_int *data = container_of(this,
 					struct busfreq_data_int, pm_notifier);
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	unsigned long maxfreq = ULONG_MAX;
 	unsigned long freq;
 	unsigned long volt;
@@ -316,7 +316,7 @@ unlock:
 static int exynos5_busfreq_int_probe(struct platform_device *pdev)
 {
 	struct busfreq_data_int *data;
-	struct opp *opp;
+	struct dev_pm_opp *opp;
 	struct device *dev = &pdev->dev;
 	struct device_node *np;
 	unsigned long initial_freq;
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 5f1ab92..c8c9953 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -187,7 +187,7 @@ extern int devfreq_suspend_device(struct devfreq *devfreq);
 extern int devfreq_resume_device(struct devfreq *devfreq);
 
 /* Helper functions for devfreq user device driver with OPP. */
-extern struct opp *devfreq_recommended_opp(struct device *dev,
+extern struct dev_pm_opp *devfreq_recommended_opp(struct device *dev,
 					   unsigned long *freq, u32 flags);
 extern int devfreq_register_opp_notifier(struct device *dev,
 					 struct devfreq *devfreq);
@@ -238,7 +238,7 @@ static inline int devfreq_resume_device(struct devfreq *devfreq)
 	return 0;
 }
 
-static inline struct opp *devfreq_recommended_opp(struct device *dev,
+static inline struct dev_pm_opp *devfreq_recommended_opp(struct device *dev,
 					   unsigned long *freq, u32 flags)
 {
 	return ERR_PTR(-EINVAL);
diff --git a/include/linux/opp.h b/include/linux/opp.h
index 2066ae5..5151b00 100644
--- a/include/linux/opp.h
+++ b/include/linux/opp.h
@@ -18,27 +18,30 @@
 #include <linux/cpufreq.h>
 #include <linux/notifier.h>
 
-struct opp;
+struct dev_pm_opp;
 struct device;
 
-enum opp_event {
+enum dev_pm_opp_event {
 	OPP_EVENT_ADD, OPP_EVENT_ENABLE, OPP_EVENT_DISABLE,
 };
 
 #if defined(CONFIG_PM_OPP)
 
-unsigned long dev_pm_opp_get_voltage(struct opp *opp);
+unsigned long dev_pm_opp_get_voltage(struct dev_pm_opp *opp);
 
-unsigned long dev_pm_opp_get_freq(struct opp *opp);
+unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp);
 
 int dev_pm_opp_get_opp_count(struct device *dev);
 
-struct opp *dev_pm_opp_find_freq_exact(struct device *dev, unsigned long freq,
-				bool available);
+struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
+					      unsigned long freq,
+					      bool available);
 
-struct opp *dev_pm_opp_find_freq_floor(struct device *dev, unsigned long *freq);
+struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
+					      unsigned long *freq);
 
-struct opp *dev_pm_opp_find_freq_ceil(struct device *dev, unsigned long *freq);
+struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
+					     unsigned long *freq);
 
 int dev_pm_opp_add(struct device *dev, unsigned long freq,
 		   unsigned long u_volt);
@@ -49,12 +52,12 @@ int dev_pm_opp_disable(struct device *dev, unsigned long freq);
 
 struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev);
 #else
-static inline unsigned long dev_pm_opp_get_voltage(struct opp *opp)
+static inline unsigned long dev_pm_opp_get_voltage(struct dev_pm_opp *opp)
 {
 	return 0;
 }
 
-static inline unsigned long dev_pm_opp_get_freq(struct opp *opp)
+static inline unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
 {
 	return 0;
 }
@@ -64,19 +67,19 @@ static inline int dev_pm_opp_get_opp_count(struct device *dev)
 	return 0;
 }
 
-static inline struct opp *dev_pm_opp_find_freq_exact(struct device *dev,
+static inline struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 					unsigned long freq, bool available)
 {
 	return ERR_PTR(-EINVAL);
 }
 
-static inline struct opp *dev_pm_opp_find_freq_floor(struct device *dev,
+static inline struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 					unsigned long *freq)
 {
 	return ERR_PTR(-EINVAL);
 }
 
-static inline struct opp *dev_pm_opp_find_freq_ceil(struct device *dev,
+static inline struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 					unsigned long *freq)
 {
 	return ERR_PTR(-EINVAL);
-- 
1.7.9.5

