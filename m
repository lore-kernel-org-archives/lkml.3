Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaEBBHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 21:07:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35613 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaEBBHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 21:07:40 -0400
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Nishanth Menon <nm@ti.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        Kevin Hilman <khilman@deeprootsystems.com>, <cpufreq@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] PM / OPP: move cpufreq specific OPP functions out of generic OPP library
Date: Thu, 1 May 2014 20:06:50 -0500
Message-ID: <1398992810-14957-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFREQ specific functions for OPP (Operating Performance Points) can
be isolated to just cpufreq. This allows for independent modifications
as needed. The functionality desired by cpufreq can easily be provided
by existing functions and any future "special handling" needed for
cpufreq drivers can similarly be handled.

With this change the internal storage order of OPP entries are no
longer a limiting factor for how we need cpufreq table to look like.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: cpufreq@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
patch based on v3.15-rc1 tag.

Test log: OMAP5uEVM: http://slexy.org/view/s20WzLXI7K

 drivers/base/power/opp.c               |   91 ----------------------------
 drivers/cpufreq/Kconfig                |    5 ++
 drivers/cpufreq/Makefile               |    2 +
 drivers/cpufreq/arm_big_little.c       |    2 +-
 drivers/cpufreq/arm_big_little_dt.c    |    2 +-
 drivers/cpufreq/cpufreq-cpu0.c         |    3 +-
 drivers/cpufreq/cpufreq_opp.c          |  102 ++++++++++++++++++++++++++++++++
 drivers/cpufreq/cpufreq_opp.h          |   39 ++++++++++++
 drivers/cpufreq/exynos5440-cpufreq.c   |    3 +-
 drivers/cpufreq/imx6q-cpufreq.c        |    3 +-
 drivers/cpufreq/omap-cpufreq.c         |    3 +-
 drivers/cpufreq/vexpress-spc-cpufreq.c |    2 +-
 include/linux/pm_opp.h                 |   20 -------
 13 files changed, 159 insertions(+), 118 deletions(-)
 create mode 100644 drivers/cpufreq/cpufreq_opp.c
 create mode 100644 drivers/cpufreq/cpufreq_opp.h

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 2553867..d9e376a 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -15,7 +15,6 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/slab.h>
-#include <linux/cpufreq.h>
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
@@ -596,96 +595,6 @@ int dev_pm_opp_disable(struct device *dev, unsigned long freq)
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
 
-#ifdef CONFIG_CPU_FREQ
-/**
- * dev_pm_opp_init_cpufreq_table() - create a cpufreq table for a device
- * @dev:	device for which we do this operation
- * @table:	Cpufreq table returned back to caller
- *
- * Generate a cpufreq table for a provided device- this assumes that the
- * opp list is already initialized and ready for usage.
- *
- * This function allocates required memory for the cpufreq table. It is
- * expected that the caller does the required maintenance such as freeing
- * the table as required.
- *
- * Returns -EINVAL for bad pointers, -ENODEV if the device is not found, -ENOMEM
- * if no memory available for the operation (table is not populated), returns 0
- * if successful and table is populated.
- *
- * WARNING: It is  important for the callers to ensure refreshing their copy of
- * the table if any of the mentioned functions have been invoked in the interim.
- *
- * Locking: The internal device_opp and opp structures are RCU protected.
- * To simplify the logic, we pretend we are updater and hold relevant mutex here
- * Callers should ensure that this function is *NOT* called under RCU protection
- * or in contexts where mutex locking cannot be used.
- */
-int dev_pm_opp_init_cpufreq_table(struct device *dev,
-			    struct cpufreq_frequency_table **table)
-{
-	struct device_opp *dev_opp;
-	struct dev_pm_opp *opp;
-	struct cpufreq_frequency_table *freq_table;
-	int i = 0;
-
-	/* Pretend as if I am an updater */
-	mutex_lock(&dev_opp_list_lock);
-
-	dev_opp = find_device_opp(dev);
-	if (IS_ERR(dev_opp)) {
-		int r = PTR_ERR(dev_opp);
-		mutex_unlock(&dev_opp_list_lock);
-		dev_err(dev, "%s: Device OPP not found (%d)\n", __func__, r);
-		return r;
-	}
-
-	freq_table = kzalloc(sizeof(struct cpufreq_frequency_table) *
-			     (dev_pm_opp_get_opp_count(dev) + 1), GFP_KERNEL);
-	if (!freq_table) {
-		mutex_unlock(&dev_opp_list_lock);
-		dev_warn(dev, "%s: Unable to allocate frequency table\n",
-			__func__);
-		return -ENOMEM;
-	}
-
-	list_for_each_entry(opp, &dev_opp->opp_list, node) {
-		if (opp->available) {
-			freq_table[i].driver_data = i;
-			freq_table[i].frequency = opp->rate / 1000;
-			i++;
-		}
-	}
-	mutex_unlock(&dev_opp_list_lock);
-
-	freq_table[i].driver_data = i;
-	freq_table[i].frequency = CPUFREQ_TABLE_END;
-
-	*table = &freq_table[0];
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(dev_pm_opp_init_cpufreq_table);
-
-/**
- * dev_pm_opp_free_cpufreq_table() - free the cpufreq table
- * @dev:	device for which we do this operation
- * @table:	table to free
- *
- * Free up the table allocated by dev_pm_opp_init_cpufreq_table
- */
-void dev_pm_opp_free_cpufreq_table(struct device *dev,
-				struct cpufreq_frequency_table **table)
-{
-	if (!table)
-		return;
-
-	kfree(*table);
-	*table = NULL;
-}
-EXPORT_SYMBOL_GPL(dev_pm_opp_free_cpufreq_table);
-#endif		/* CONFIG_CPU_FREQ */
-
 /**
  * dev_pm_opp_get_notifier() - find notifier_head of the device with opp
  * @dev:	device pointer used to lookup device OPPs.
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 1fbe11f..281ccfb 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -17,6 +17,11 @@ config CPU_FREQ
 
 if CPU_FREQ
 
+config CPU_FREQ_PM_OPP
+	bool
+	depends on PM_OPP
+	default y
+
 config CPU_FREQ_GOV_COMMON
 	bool
 
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 0dbb963..16eea68 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -1,5 +1,7 @@
 # CPUfreq core
 obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o freq_table.o
+obj-$(CONFIG_CPU_FREQ_PM_OPP)		+= cpufreq_opp.o
+
 # CPUfreq stats
 obj-$(CONFIG_CPU_FREQ_STAT)             += cpufreq_stats.o
 
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index bad2ed3..258ee9e 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -26,13 +26,13 @@
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/of_platform.h>
-#include <linux/pm_opp.h>
 #include <linux/slab.h>
 #include <linux/topology.h>
 #include <linux/types.h>
 #include <asm/bL_switcher.h>
 
 #include "arm_big_little.h"
+#include "cpufreq_opp.h"
 
 /* Currently we support only two clusters */
 #define A15_CLUSTER	0
diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
index 8d9d591..2bbefd0 100644
--- a/drivers/cpufreq/arm_big_little_dt.c
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -24,11 +24,11 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
-#include <linux/pm_opp.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include "arm_big_little.h"
+#include "cpufreq_opp.h"
 
 /* get cpu node with valid operating-points */
 static struct device_node *get_cpu_node_with_valid_op(int cpu)
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 1bf6bba..2353993 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -19,12 +19,13 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/pm_opp.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/thermal.h>
 
+#include "cpufreq_opp.h"
+
 static unsigned int transition_latency;
 static unsigned int voltage_tolerance; /* in percentage */
 
diff --git a/drivers/cpufreq/cpufreq_opp.c b/drivers/cpufreq/cpufreq_opp.c
new file mode 100644
index 0000000..2602ff8
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_opp.c
@@ -0,0 +1,102 @@
+/*
+ * Generic OPP Interface for CPUFREQ drivers
+ *
+ * Copyright (C) 2009-2014 Texas Instruments Incorporated.
+ *	Nishanth Menon
+ *	Romit Dasgupta
+ *	Kevin Hilman
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/slab.h>
+
+#include "cpufreq_opp.h"
+
+/**
+ * dev_pm_opp_init_cpufreq_table() - create a cpufreq table for a device
+ * @dev:	device for which we do this operation
+ * @table:	Cpufreq table returned back to caller
+ *
+ * Generate a cpufreq table for a provided device- this assumes that the
+ * opp list is already initialized and ready for usage.
+ *
+ * This function allocates required memory for the cpufreq table. It is
+ * expected that the caller does the required maintenance such as freeing
+ * the table as required.
+ *
+ * Returns -EINVAL for bad pointers, -ENODEV if the device is not found, -ENOMEM
+ * if no memory available for the operation (table is not populated), returns 0
+ * if successful and table is populated.
+ *
+ * WARNING: It is  important for the callers to ensure refreshing their copy of
+ * the table if any of the mentioned functions have been invoked in the interim.
+ *
+ * LOCKING: This holds it's own RCU locks and external locks are not necessary.
+ */
+int dev_pm_opp_init_cpufreq_table(struct device *dev,
+				  struct cpufreq_frequency_table **table)
+{
+	struct dev_pm_opp *opp;
+	struct cpufreq_frequency_table *freq_table = NULL;
+	int i, max_opps, ret = 0;
+	unsigned long rate;
+
+	rcu_read_lock();
+
+	max_opps = dev_pm_opp_get_opp_count(dev);
+	if (max_opps <= 0) {
+		ret = max_opps ? max_opps : -ENODATA;
+		goto out;
+	}
+
+	freq_table = kzalloc(sizeof(*freq_table) * (max_opps + 1), GFP_KERNEL);
+	if (!freq_table) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0, rate = 0; i < max_opps; i++, rate++) {
+		/* find next rate */
+		opp = dev_pm_opp_find_freq_ceil(dev, &rate);
+		if (IS_ERR(opp)) {
+			ret = PTR_ERR(opp);
+			goto out;
+		}
+		freq_table[i].driver_data = i;
+		freq_table[i].frequency = rate / 1000;
+	}
+
+	freq_table[i].driver_data = i;
+	freq_table[i].frequency = CPUFREQ_TABLE_END;
+
+	*table = &freq_table[0];
+
+out:
+	rcu_read_unlock();
+	if (ret)
+		kfree(freq_table);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_init_cpufreq_table);
+
+/**
+ * dev_pm_opp_free_cpufreq_table() - free the cpufreq table
+ * @dev:	device for which we do this operation
+ * @table:	table to free
+ *
+ * Free up the table allocated by dev_pm_opp_init_cpufreq_table
+ */
+void dev_pm_opp_free_cpufreq_table(struct device *dev,
+				   struct cpufreq_frequency_table **table)
+{
+	if (!table)
+		return;
+
+	kfree(*table);
+	*table = NULL;
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_free_cpufreq_table);
diff --git a/drivers/cpufreq/cpufreq_opp.h b/drivers/cpufreq/cpufreq_opp.h
new file mode 100644
index 0000000..5dbc9b4
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_opp.h
@@ -0,0 +1,39 @@
+/*
+ * Generic OPP Interface for CPUFREQ drivers
+ *
+ * Copyright (C) 2009-2014 Texas Instruments Incorporated.
+ *	Nishanth Menon
+ *	Romit Dasgupta
+ *	Kevin Hilman
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __CPUFREQ_OPP_H__
+#define __CPUFREQ_OPP_H__
+
+#include <linux/cpufreq.h>
+#include <linux/pm_opp.h>
+
+#if defined(CONFIG_CPU_FREQ) && defined(CONFIG_PM_OPP)
+int dev_pm_opp_init_cpufreq_table(struct device *dev,
+				  struct cpufreq_frequency_table **table);
+void dev_pm_opp_free_cpufreq_table(struct device *dev,
+				   struct cpufreq_frequency_table **table);
+#else
+static inline int dev_pm_opp_init_cpufreq_table(struct device *dev,
+						struct cpufreq_frequency_table
+						**table)
+{
+	return -EINVAL;
+}
+
+static inline void dev_pm_opp_free_cpufreq_table(struct device *dev,
+						 struct cpufreq_frequency_table
+						 **table)
+{
+}
+#endif				/* CONFIG_CPU_FREQ */
+
+#endif				/* __CPUFREQ_OPP_H__ */
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index a6b8214..7d59b39 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -20,10 +20,11 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
-#include <linux/pm_opp.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
+#include "cpufreq_opp.h"
+
 /* Register definitions */
 #define XMU_DVFS_CTRL		0x0060
 #define XMU_PMU_P0_7		0x0064
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index e27fca8..e4e777c 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -13,10 +13,11 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/pm_opp.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 
+#include "cpufreq_opp.h"
+
 #define PU_SOC_VOLTAGE_NORMAL	1250000
 #define PU_SOC_VOLTAGE_HIGH	1275000
 #define FREQ_1P2_GHZ		1200000000
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 5f69c9a..ba93935 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -22,7 +22,6 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
-#include <linux/pm_opp.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -31,6 +30,8 @@
 #include <asm/smp_plat.h>
 #include <asm/cpu.h>
 
+#include "cpufreq_opp.h"
+
 /* OPP tolerance in percentage */
 #define	OPP_TOLERANCE	4
 
diff --git a/drivers/cpufreq/vexpress-spc-cpufreq.c b/drivers/cpufreq/vexpress-spc-cpufreq.c
index 7f7c9c0..3d71a57 100644
--- a/drivers/cpufreq/vexpress-spc-cpufreq.c
+++ b/drivers/cpufreq/vexpress-spc-cpufreq.c
@@ -21,10 +21,10 @@
 #include <linux/cpufreq.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include <linux/pm_opp.h>
 #include <linux/types.h>
 
 #include "arm_big_little.h"
+#include "cpufreq_opp.h"
 
 static int ve_spc_init_opp_table(struct device *cpu_dev)
 {
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index 5151b00..0330217 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -15,7 +15,6 @@
 #define __LINUX_OPP_H__
 
 #include <linux/err.h>
-#include <linux/cpufreq.h>
 #include <linux/notifier.h>
 
 struct dev_pm_opp;
@@ -117,23 +116,4 @@ static inline int of_init_opp_table(struct device *dev)
 }
 #endif
 
-#if defined(CONFIG_CPU_FREQ) && defined(CONFIG_PM_OPP)
-int dev_pm_opp_init_cpufreq_table(struct device *dev,
-			    struct cpufreq_frequency_table **table);
-void dev_pm_opp_free_cpufreq_table(struct device *dev,
-				struct cpufreq_frequency_table **table);
-#else
-static inline int dev_pm_opp_init_cpufreq_table(struct device *dev,
-			    struct cpufreq_frequency_table **table)
-{
-	return -EINVAL;
-}
-
-static inline
-void dev_pm_opp_free_cpufreq_table(struct device *dev,
-				struct cpufreq_frequency_table **table)
-{
-}
-#endif		/* CONFIG_CPU_FREQ */
-
 #endif		/* __LINUX_OPP_H__ */
-- 
1.7.9.5

