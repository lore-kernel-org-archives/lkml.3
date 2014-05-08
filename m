Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaEHOhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:37:55 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61075 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaEHOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:37:52 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
Cc: lenb@kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        rjw@rjwysocki.net
Subject: [RFC PATCH 1/5] thermal: cpu_cooling: Support passing driver private data.
Date: Thu,  8 May 2014 20:07:56 +0530
Message-Id: <1399559880-20562-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
References: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is in preparation to add notfication support for cpufrequency
cooling changes. This change also removes the unnecessary exposing of
internal housekeeping structure via thermal_cooling_device->devdata to the
users of cpufreq cooling APIs.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/cpu_cooling.c                      |   79 +++++++++++++++----
 drivers/thermal/db8500_cpufreq_cooling.c           |    2 +-
 drivers/thermal/samsung/exynos_thermal_common.c    |    2 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |    2 +-
 include/linux/cpu_cooling.h                        |    5 +-
 5 files changed, 68 insertions(+), 22 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 4246262..21f44d4 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -50,16 +50,18 @@ struct cpufreq_cooling_device {
 	unsigned int cpufreq_state;
 	unsigned int cpufreq_val;
 	struct cpumask allowed_cpus;
+	struct list_head node;
 };
 static DEFINE_IDR(cpufreq_idr);
 static DEFINE_MUTEX(cooling_cpufreq_lock);
 
-static unsigned int cpufreq_dev_count;
-
 /* notify_table passes value to the CPUFREQ_ADJUST callback function. */
 #define NOTIFY_INVALID NULL
 static struct cpufreq_cooling_device *notify_device;
 
+/* A list to hold all the cpufreq cooling devices registered */
+static LIST_HEAD(cpufreq_cooling_list);
+
 /**
  * get_idr - function to get a unique id.
  * @idr: struct idr * handle used to create a id.
@@ -357,12 +359,23 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
 static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
 				 unsigned long *state)
 {
-	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
-	struct cpumask *mask = &cpufreq_device->allowed_cpus;
+	struct cpufreq_cooling_device *cpufreq_device = NULL;
+	struct cpumask *mask = NULL;
 	unsigned int cpu;
 	unsigned int count = 0;
 	int ret;
 
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cpufreq_cooling_list, node)
+		if (cpufreq_device->cool_dev == cdev)
+			break;
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device) {
+		/* Cooling device pointer not found */
+		return -EINVAL;
+	}
+
+	mask = &cpufreq_device->allowed_cpus;
 	cpu = cpumask_any(mask);
 
 	ret = get_property(cpu, 0, &count, GET_MAXL);
@@ -386,7 +399,17 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
 static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long *state)
 {
-	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
+	struct cpufreq_cooling_device *cpufreq_device = NULL;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cpufreq_cooling_list, node)
+		if (cpufreq_device->cool_dev == cdev)
+			break;
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device) {
+		/* Cooling device pointer not found */
+		return -EINVAL;
+	}
 
 	*state = cpufreq_device->cpufreq_state;
 
@@ -406,7 +429,17 @@ static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
 static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long state)
 {
-	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
+	struct cpufreq_cooling_device *cpufreq_device = NULL;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	list_for_each_entry(cpufreq_device, &cpufreq_cooling_list, node)
+		if (cpufreq_device->cool_dev == cdev)
+			break;
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device) {
+		/* Cooling device pointer not found */
+		return -EINVAL;
+	}
 
 	return cpufreq_apply_cooling(cpufreq_device, state);
 }
@@ -427,6 +460,7 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
  * __cpufreq_cooling_register - helper function to create cpufreq cooling device
  * @np: a valid struct device_node to the cooling device device tree node
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
+ * @devdata: driver data pointer
  *
  * This interface function registers the cpufreq cooling device with the name
  * "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
@@ -438,7 +472,7 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
  */
 static struct thermal_cooling_device *
 __cpufreq_cooling_register(struct device_node *np,
-			   const struct cpumask *clip_cpus)
+			   const struct cpumask *clip_cpus, void *devdata)
 {
 	struct thermal_cooling_device *cool_dev;
 	struct cpufreq_cooling_device *cpufreq_dev = NULL;
@@ -477,7 +511,7 @@ __cpufreq_cooling_register(struct device_node *np,
 	snprintf(dev_name, sizeof(dev_name), "thermal-cpufreq-%d",
 		 cpufreq_dev->id);
 
-	cool_dev = thermal_of_cooling_device_register(np, dev_name, cpufreq_dev,
+	cool_dev = thermal_of_cooling_device_register(np, dev_name, devdata,
 						      &cpufreq_cooling_ops);
 	if (IS_ERR(cool_dev)) {
 		release_idr(&cpufreq_idr, cpufreq_dev->id);
@@ -489,10 +523,11 @@ __cpufreq_cooling_register(struct device_node *np,
 	mutex_lock(&cooling_cpufreq_lock);
 
 	/* Register the notifier for first cpufreq cooling device */
-	if (cpufreq_dev_count == 0)
+	if (list_empty(&cpufreq_cooling_list))
 		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
 					  CPUFREQ_POLICY_NOTIFIER);
-	cpufreq_dev_count++;
+
+	list_add(&cpufreq_dev->node, &cpufreq_cooling_list);
 
 	mutex_unlock(&cooling_cpufreq_lock);
 
@@ -502,6 +537,7 @@ __cpufreq_cooling_register(struct device_node *np,
 /**
  * cpufreq_cooling_register - function to create cpufreq cooling device.
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
+ * @devdata: driver data pointer
  *
  * This interface function registers the cpufreq cooling device with the name
  * "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
@@ -511,9 +547,9 @@ __cpufreq_cooling_register(struct device_node *np,
  * on failure, it returns a corresponding ERR_PTR().
  */
 struct thermal_cooling_device *
-cpufreq_cooling_register(const struct cpumask *clip_cpus)
+cpufreq_cooling_register(const struct cpumask *clip_cpus, void *devdata)
 {
-	return __cpufreq_cooling_register(NULL, clip_cpus);
+	return __cpufreq_cooling_register(NULL, clip_cpus, devdata);
 }
 EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
 
@@ -537,7 +573,7 @@ of_cpufreq_cooling_register(struct device_node *np,
 	if (!np)
 		return ERR_PTR(-EINVAL);
 
-	return __cpufreq_cooling_register(np, clip_cpus);
+	return __cpufreq_cooling_register(np, clip_cpus, NULL);
 }
 EXPORT_SYMBOL_GPL(of_cpufreq_cooling_register);
 
@@ -554,17 +590,26 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	if (!cdev)
 		return;
 
-	cpufreq_dev = cdev->devdata;
 	mutex_lock(&cooling_cpufreq_lock);
-	cpufreq_dev_count--;
+
+	list_for_each_entry(cpufreq_dev, &cpufreq_cooling_list, node)
+		if (cpufreq_dev->cool_dev == cdev)
+			break;
+
+	if (!cpufreq_dev) {
+		/* Cooling device pointer not found */
+		mutex_unlock(&cooling_cpufreq_lock);
+		return;
+	}
+	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
+	list_del(&cpufreq_dev->node);
 
 	/* Unregister the notifier for the last cpufreq cooling device */
-	if (cpufreq_dev_count == 0)
+	if (list_empty(&cpufreq_cooling_list))
 		cpufreq_unregister_notifier(&thermal_cpufreq_notifier_block,
 					    CPUFREQ_POLICY_NOTIFIER);
 	mutex_unlock(&cooling_cpufreq_lock);
 
-	thermal_cooling_device_unregister(cpufreq_dev->cool_dev);
 	release_idr(&cpufreq_idr, cpufreq_dev->id);
 	kfree(cpufreq_dev);
 }
diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
index 786d192..abb9bdd 100644
--- a/drivers/thermal/db8500_cpufreq_cooling.c
+++ b/drivers/thermal/db8500_cpufreq_cooling.c
@@ -35,7 +35,7 @@ static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 
 	cpumask_set_cpu(0, &mask_val);
-	cdev = cpufreq_cooling_register(&mask_val);
+	cdev = cpufreq_cooling_register(&mask_val, NULL);
 
 	if (IS_ERR(cdev)) {
 		dev_err(&pdev->dev, "Failed to register cooling device\n");
diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index 3f5ad25..a7306fa 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -369,7 +369,7 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 	if (sensor_conf->cooling_data.freq_clip_count > 0) {
 		cpumask_set_cpu(0, &mask_val);
 		th_zone->cool_dev[th_zone->cool_dev_size] =
-					cpufreq_cooling_register(&mask_val);
+				cpufreq_cooling_register(&mask_val, NULL);
 		if (IS_ERR(th_zone->cool_dev[th_zone->cool_dev_size])) {
 			dev_err(sensor_conf->dev,
 				"Failed to register cpufreq cooling device\n");
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 9eec26d..7809db6 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -409,7 +409,7 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 	}
 
 	/* Register cooling device */
-	data->cool_dev = cpufreq_cooling_register(cpu_present_mask);
+	data->cool_dev = cpufreq_cooling_register(cpu_present_mask, NULL);
 	if (IS_ERR(data->cool_dev)) {
 		dev_err(bgp->dev,
 			"Failed to register cpufreq cooling device\n");
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index c303d38..aaef7d8 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -32,9 +32,10 @@
 /**
  * cpufreq_cooling_register - function to create cpufreq cooling device.
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen
+ * @devdata: driver data pointer
  */
 struct thermal_cooling_device *
-cpufreq_cooling_register(const struct cpumask *clip_cpus);
+cpufreq_cooling_register(const struct cpumask *clip_cpus, void *devdata);
 
 /**
  * of_cpufreq_cooling_register - create cpufreq cooling device based on DT.
@@ -63,7 +64,7 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
 unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq);
 #else /* !CONFIG_CPU_THERMAL */
 static inline struct thermal_cooling_device *
-cpufreq_cooling_register(const struct cpumask *clip_cpus)
+cpufreq_cooling_register(const struct cpumask *clip_cpus, void *devdata)
 {
 	return NULL;
 }
-- 
1.7.1

