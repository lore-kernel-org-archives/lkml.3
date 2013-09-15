Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3IOWEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 18:04:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37541 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab3IOWEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 18:04:25 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>
CC: <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 03/16] drivers: thermal: cpu_cooling: introduce of_cpufreq_cooling_register
Date: Sun, 15 Sep 2013 18:02:30 -0400
Message-ID: <1379282563-14650-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1379282563-14650-1-git-send-email-eduardo.valentin@ti.com>
References: <1379282563-14650-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces an API to register cpufreq cooling device
based on device tree node.

The registration via device tree node differs from normal
registration due to the fact that it is needed to fill
the device_node structure in order to be able to match
the cooling devices with trip points.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/Kconfig       |  1 +
 drivers/thermal/cpu_cooling.c | 31 +++++++++++++++++++++++++++++++
 include/linux/cpu_cooling.h   | 25 +++++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index dd81eb8..9e7cc3f 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -91,6 +91,7 @@ config THERMAL_GOV_USER_SPACE
 config CPU_THERMAL
 	bool "generic cpu cooling support"
 	depends on CPU_FREQ
+	depends on THERMAL_OF
 	select CPU_FREQ_TABLE
 	help
 	  This implements the generic cpu cooling mechanism through frequency
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index d179028..cd2f532 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -491,6 +491,37 @@ cpufreq_cooling_register(const struct cpumask *clip_cpus)
 EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
 
 /**
+ * of_cpufreq_cooling_register - function to create cpufreq cooling device.
+ * @np: a valid struct device_node to the cooling device device tree node
+ * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
+ *
+ * This interface function registers the cpufreq cooling device with the name
+ * "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
+ * cooling devices.
+ *
+ * Return: a valid struct thermal_cooling_device pointer on success,
+ * on failure, it returns a corresponding ERR_PTR().
+ */
+struct thermal_cooling_device *
+of_cpufreq_cooling_register(struct device_node *np,
+			    const struct cpumask *clip_cpus)
+{
+	struct thermal_cooling_device *cdev;
+
+	if (!np)
+		return ERR_PTR(-EINVAL);
+
+	cdev = cpufreq_cooling_register(clip_cpus);
+	if (IS_ERR(cdev))
+		return cdev;
+
+	cdev->np = np;
+
+	return cdev;
+}
+EXPORT_SYMBOL_GPL(of_cpufreq_cooling_register);
+
+/**
  * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
  * @cdev: thermal cooling device pointer.
  *
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index a5d52ee..c303d38 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -24,6 +24,7 @@
 #ifndef __CPU_COOLING_H__
 #define __CPU_COOLING_H__
 
+#include <linux/of.h>
 #include <linux/thermal.h>
 #include <linux/cpumask.h>
 
@@ -36,6 +37,24 @@ struct thermal_cooling_device *
 cpufreq_cooling_register(const struct cpumask *clip_cpus);
 
 /**
+ * of_cpufreq_cooling_register - create cpufreq cooling device based on DT.
+ * @np: a valid struct device_node to the cooling device device tree node.
+ * @clip_cpus: cpumask of cpus where the frequency constraints will happen
+ */
+#ifdef CONFIG_THERMAL_OF
+struct thermal_cooling_device *
+of_cpufreq_cooling_register(struct device_node *np,
+			    const struct cpumask *clip_cpus);
+#else
+static inline struct thermal_cooling_device *
+of_cpufreq_cooling_register(struct device_node *np,
+			    const struct cpumask *clip_cpus)
+{
+	return NULL;
+}
+#endif
+
+/**
  * cpufreq_cooling_unregister - function to remove cpufreq cooling device.
  * @cdev: thermal cooling device pointer.
  */
@@ -48,6 +67,12 @@ cpufreq_cooling_register(const struct cpumask *clip_cpus)
 {
 	return NULL;
 }
+static inline struct thermal_cooling_device *
+of_cpufreq_cooling_register(struct device_node *np,
+			    const struct cpumask *clip_cpus)
+{
+	return NULL;
+}
 static inline
 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 {
-- 
1.8.2.1.342.gfa7285d

