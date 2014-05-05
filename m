Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbaEENe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:34:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49116 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581AbaEENeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:34:22 -0400
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>, <cpufreq@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] PM / OPP: Move cpufreq specific OPP functions out of generic OPP library
Date: Mon, 5 May 2014 08:33:50 -0500
Message-ID: <1399296830-13056-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399296830-13056-1-git-send-email-nm@ti.com>
References: <1399296830-13056-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq specific helper functions for OPP (Operating Performance Points)
now use generic OPP functions that allow CPUFreq to be be moved back
into CPUFreq framework. This allows for independent modifications
or future enhancements as needed isolated to just CPUFreq framework
alone.

Here, we just move relevant code and documentation to make this part of
CPUFreq infrastructure.

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
List of files impacted by this change detected by:
  # check if pm_opp.h header is needed anymore:
  git grep dev_pm_opp_init_cpufreq_table .|cut -d ':' -f1|sort|uniq|xargs
  grep dev_pm_opp |grep -v cpufreq
  # check if any file is missing cpufreq.h header is needed anymore:
 git grep dev_pm_opp_init_cpufreq_table .|cut -d ':' -f1|sort|uniq|xargs
 grep "cpufreq.h"

 Documentation/cpu-freq/core.txt |   29 +++++++++++
 Documentation/power/opp.txt     |   40 ++------------
 drivers/base/power/opp.c        |   92 --------------------------------
 drivers/cpufreq/Makefile        |    2 +
 drivers/cpufreq/cpufreq_opp.c   |  110 +++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h         |   21 ++++++++
 include/linux/pm_opp.h          |   20 -------
 7 files changed, 167 insertions(+), 147 deletions(-)
 create mode 100644 drivers/cpufreq/cpufreq_opp.c

diff --git a/Documentation/cpu-freq/core.txt b/Documentation/cpu-freq/core.txt
index 0060d76..70933ea 100644
--- a/Documentation/cpu-freq/core.txt
+++ b/Documentation/cpu-freq/core.txt
@@ -20,6 +20,7 @@ Contents:
 ---------
 1.  CPUFreq core and interfaces
 2.  CPUFreq notifiers
+3.  CPUFreq Table Generation with Operating Performance Point (OPP)
 
 1. General Information
 =======================
@@ -92,3 +93,31 @@ values:
 cpu	- number of the affected CPU
 old	- old frequency
 new	- new frequency
+
+3. CPUFreq Table Generation with Operating Performance Point (OPP)
+==================================================================
+For details about OPP, see Documentation/power/opp.txt
+
+dev_pm_opp_init_cpufreq_table - cpufreq framework typically is initialized with
+	cpufreq_frequency_table_cpuinfo which is provided with the list of
+	frequencies that are available for operation. This function provides
+	a ready to use conversion routine to translate the OPP layer's internal
+	information about the available frequencies into a format readily
+	providable to cpufreq.
+
+	WARNING: Do not use this function in interrupt context.
+
+	Example:
+	 soc_pm_init()
+	 {
+		/* Do things */
+		r = dev_pm_opp_init_cpufreq_table(dev, &freq_table);
+		if (!r)
+			cpufreq_frequency_table_cpuinfo(policy, freq_table);
+		/* Do other things */
+	 }
+
+	NOTE: This function is available only if CONFIG_CPU_FREQ is enabled in
+	addition to CONFIG_PM_OPP.
+
+dev_pm_opp_free_cpufreq_table - Free up the table allocated by dev_pm_opp_init_cpufreq_table
diff --git a/Documentation/power/opp.txt b/Documentation/power/opp.txt
index b8a907d..a9adad8 100644
--- a/Documentation/power/opp.txt
+++ b/Documentation/power/opp.txt
@@ -10,8 +10,7 @@ Contents
 3. OPP Search Functions
 4. OPP Availability Control Functions
 5. OPP Data Retrieval Functions
-6. Cpufreq Table Generation
-7. Data Structures
+6. Data Structures
 
 1. Introduction
 ===============
@@ -72,7 +71,6 @@ operations until that OPP could be re-enabled if possible.
 OPP library facilitates this concept in it's implementation. The following
 operational functions operate only on available opps:
 opp_find_freq_{ceil, floor}, dev_pm_opp_get_voltage, dev_pm_opp_get_freq, dev_pm_opp_get_opp_count
-and dev_pm_opp_init_cpufreq_table
 
 dev_pm_opp_find_freq_exact is meant to be used to find the opp pointer which can then
 be used for dev_pm_opp_enable/disable functions to make an opp available as required.
@@ -96,10 +94,9 @@ using RCU read locks. The opp_find_freq_{exact,ceil,floor},
 opp_get_{voltage, freq, opp_count} fall into this category.
 
 opp_{add,enable,disable} are updaters which use mutex and implement it's own
-RCU locking mechanisms. dev_pm_opp_init_cpufreq_table acts as an updater and uses
-mutex to implment RCU updater strategy. These functions should *NOT* be called
-under RCU locks and other contexts that prevent blocking functions in RCU or
-mutex operations from working.
+RCU locking mechanisms. These functions should *NOT* be called under RCU locks
+and other contexts that prevent blocking functions in RCU or mutex operations
+from working.
 
 2. Initial OPP List Registration
 ================================
@@ -311,34 +308,7 @@ dev_pm_opp_get_opp_count - Retrieve the number of available opps for a device
 		/* Do other things */
 	 }
 
-6. Cpufreq Table Generation
-===========================
-dev_pm_opp_init_cpufreq_table - cpufreq framework typically is initialized with
-	cpufreq_frequency_table_cpuinfo which is provided with the list of
-	frequencies that are available for operation. This function provides
-	a ready to use conversion routine to translate the OPP layer's internal
-	information about the available frequencies into a format readily
-	providable to cpufreq.
-
-	WARNING: Do not use this function in interrupt context.
-
-	Example:
-	 soc_pm_init()
-	 {
-		/* Do things */
-		r = dev_pm_opp_init_cpufreq_table(dev, &freq_table);
-		if (!r)
-			cpufreq_frequency_table_cpuinfo(policy, freq_table);
-		/* Do other things */
-	 }
-
-	NOTE: This function is available only if CONFIG_CPU_FREQ is enabled in
-	addition to CONFIG_PM as power management feature is required to
-	dynamically scale voltage and frequency in a system.
-
-dev_pm_opp_free_cpufreq_table - Free up the table allocated by dev_pm_opp_init_cpufreq_table
-
-7. Data Structures
+6. Data Structures
 ==================
 Typically an SoC contains multiple voltage domains which are variable. Each
 domain is represented by a device pointer. The relationship to OPP can be
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 38b43bb..d9e376a 100644
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
@@ -596,97 +595,6 @@ int dev_pm_opp_disable(struct device *dev, unsigned long freq)
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
- * Since we just use the regular accessor functions to access the internal data
- * structures, we use RCU read lock inside this function. As a result, users of
- * this function DONOT need to use explicit locks for invoking.
- */
-int dev_pm_opp_init_cpufreq_table(struct device *dev,
-			    struct cpufreq_frequency_table **table)
-{
-	struct dev_pm_opp *opp;
-	struct cpufreq_frequency_table *freq_table = NULL;
-	int i, max_opps, ret = 0;
-	unsigned long rate;
-
-	rcu_read_lock();
-
-	max_opps = dev_pm_opp_get_opp_count(dev);
-	if (max_opps <= 0) {
-		ret = max_opps ? max_opps : -ENODATA;
-		goto out;
-	}
-
-	freq_table = kzalloc(sizeof(*freq_table) * (max_opps + 1), GFP_KERNEL);
-	if (!freq_table) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	for (i = 0, rate = 0; i < max_opps; i++, rate++) {
-		/* find next rate */
-		opp = dev_pm_opp_find_freq_ceil(dev, &rate);
-		if (IS_ERR(opp)) {
-			ret = PTR_ERR(opp);
-			goto out;
-		}
-		freq_table[i].driver_data = i;
-		freq_table[i].frequency = rate / 1000;
-	}
-
-	freq_table[i].driver_data = i;
-	freq_table[i].frequency = CPUFREQ_TABLE_END;
-
-	*table = &freq_table[0];
-
-out:
-	rcu_read_unlock();
-	if (ret)
-		kfree(freq_table);
-
-	return ret;
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
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 0dbb963..738c8b7 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -1,5 +1,7 @@
 # CPUfreq core
 obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o freq_table.o
+obj-$(CONFIG_PM_OPP)			+= cpufreq_opp.o
+
 # CPUfreq stats
 obj-$(CONFIG_CPU_FREQ_STAT)             += cpufreq_stats.o
 
diff --git a/drivers/cpufreq/cpufreq_opp.c b/drivers/cpufreq/cpufreq_opp.c
new file mode 100644
index 0000000..c0c6f4a
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_opp.c
@@ -0,0 +1,110 @@
+/*
+ * Generic OPP helper interface for CPUFreq drivers
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
+#include <linux/cpufreq.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/pm_opp.h>
+#include <linux/rcupdate.h>
+#include <linux/slab.h>
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
+ * Locking: The internal device_opp and opp structures are RCU protected.
+ * Since we just use the regular accessor functions to access the internal data
+ * structures, we use RCU read lock inside this function. As a result, users of
+ * this function DONOT need to use explicit locks for invoking.
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
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 5ae5100..044ec4b 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -468,6 +468,27 @@ struct cpufreq_frequency_table {
 				    * order */
 };
 
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
+#endif
+
+
 int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 				    struct cpufreq_frequency_table *table);
 
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

