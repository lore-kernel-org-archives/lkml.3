Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbaE2IS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:18:27 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52081 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314AbaE2IQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:16:02 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, edubezval@gmail.com, rjw@rjwysocki.net,
        linux-arm-kernel@lists.infradead.org, lenb@kernel.org
Subject: [PATCH v1 2/6] thermal: cpu_cooling: Support passing driver private data.
Date: Thu, 29 May 2014 13:45:30 +0530
Message-Id: <1401351334-11210-3-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the caller of cpufreq cooling APIs to register along
with their driver data which will be useful while receiving any cooling states
notifications.
This patch is in preparation to add notfication support for cpufrequency
cooling changes. This change also removes the unnecessary exposing of
internal housekeeping structure via thermal_cooling_device->devdata to the
users of cpufreq cooling APIs. As part of this implmentation, this private local
structure (cpufreq_dev) is now stored in a list and scanned for each call to
cpu cooling interfaces.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 Documentation/thermal/cpu-cooling-api.txt          |    3 +-
 drivers/thermal/cpu_cooling.c                      |   89 ++++++++++++++++----
 drivers/thermal/db8500_cpufreq_cooling.c           |    2 +-
 drivers/thermal/samsung/exynos_thermal_common.c    |    2 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |    2 +-
 include/linux/cpu_cooling.h                        |    5 +-
 6 files changed, 80 insertions(+), 23 deletions(-)

diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
index fca24c9..aaa07c6 100644
--- a/Documentation/thermal/cpu-cooling-api.txt
+++ b/Documentation/thermal/cpu-cooling-api.txt
@@ -17,13 +17,14 @@ the user. The registration APIs returns the cooling device pointer.
 
 1.1 cpufreq registration/unregistration APIs
 1.1.1 struct thermal_cooling_device *cpufreq_cooling_register(
-	struct cpumask *clip_cpus)
+	struct cpumask *clip_cpus, void *devdata)
 
     This interface function registers the cpufreq cooling device with the name
     "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
     cooling devices.
 
    clip_cpus: cpumask of cpus where the frequency constraints will happen.
+   devdata: driver private data pointer.
 
 1.1.2 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 16388b0..6d145d5 100644
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
 static DEFINE_PER_CPU(struct cpufreq_cooling_device *, notify_device);
 
+/* A list to hold all the cpufreq cooling devices registered */
+static LIST_HEAD(cpufreq_cooling_list);
+
 /**
  * get_idr - function to get a unique id.
  * @idr: struct idr * handle used to create a id.
@@ -98,6 +100,26 @@ static void release_idr(struct idr *idr, int id)
 
 /* Below code defines functions to be used for cpufreq as cooling device */
 
+/**
+ * cpufreq_cooling_get_info - function to cpufreq_dev for the corresponding cdev
+ * @cdev: pointer of the cooling device
+ *
+ * This function will loop through the cpufreq_cooling_device list and
+ * return the matching device
+ *
+ * Return: cpufreq_cooling_device if matched with the cdev or NULL if not
+ * matched.
+ */
+static inline struct cpufreq_cooling_device *
+cpufreq_cooling_get_info(struct thermal_cooling_device *cdev)
+{
+	struct cpufreq_cooling_device *cpufreq_dev = NULL;
+	list_for_each_entry(cpufreq_dev, &cpufreq_cooling_list, node)
+		if (cpufreq_dev->cool_dev == cdev)
+			break;
+	return cpufreq_dev;
+}
+
 enum cpufreq_cooling_property {
 	GET_LEVEL,
 	GET_FREQ,
@@ -349,12 +371,21 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
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
+	cpufreq_device = cpufreq_cooling_get_info(cdev);
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device) {
+		/* Cooling device pointer not found */
+		return -EINVAL;
+	}
+
+	mask = &cpufreq_device->allowed_cpus;
 	cpu = cpumask_any(mask);
 
 	ret = get_property(cpu, 0, &count, GET_MAXL);
@@ -378,7 +409,15 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
 static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long *state)
 {
-	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
+	struct cpufreq_cooling_device *cpufreq_device = NULL;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	cpufreq_device = cpufreq_cooling_get_info(cdev);
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device) {
+		/* Cooling device pointer not found */
+		return -EINVAL;
+	}
 
 	*state = cpufreq_device->cpufreq_state;
 
@@ -398,7 +437,15 @@ static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
 static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long state)
 {
-	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
+	struct cpufreq_cooling_device *cpufreq_device = NULL;
+
+	mutex_lock(&cooling_cpufreq_lock);
+	cpufreq_device = cpufreq_cooling_get_info(cdev);
+	mutex_unlock(&cooling_cpufreq_lock);
+	if (!cpufreq_device) {
+		/* Cooling device pointer not found */
+		return -EINVAL;
+	}
 
 	return cpufreq_apply_cooling(cpufreq_device, state);
 }
@@ -419,6 +466,7 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
  * __cpufreq_cooling_register - helper function to create cpufreq cooling device
  * @np: a valid struct device_node to the cooling device device tree node
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
+ * @devdata: driver data pointer
  *
  * This interface function registers the cpufreq cooling device with the name
  * "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
@@ -430,7 +478,7 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
  */
 static struct thermal_cooling_device *
 __cpufreq_cooling_register(struct device_node *np,
-			   const struct cpumask *clip_cpus)
+			   const struct cpumask *clip_cpus, void *devdata)
 {
 	struct thermal_cooling_device *cool_dev;
 	struct cpufreq_cooling_device *cpufreq_dev = NULL;
@@ -469,7 +517,7 @@ __cpufreq_cooling_register(struct device_node *np,
 	snprintf(dev_name, sizeof(dev_name), "thermal-cpufreq-%d",
 		 cpufreq_dev->id);
 
-	cool_dev = thermal_of_cooling_device_register(np, dev_name, cpufreq_dev,
+	cool_dev = thermal_of_cooling_device_register(np, dev_name, devdata,
 						      &cpufreq_cooling_ops);
 	if (IS_ERR(cool_dev)) {
 		release_idr(&cpufreq_idr, cpufreq_dev->id);
@@ -481,10 +529,11 @@ __cpufreq_cooling_register(struct device_node *np,
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
 
@@ -494,6 +543,7 @@ __cpufreq_cooling_register(struct device_node *np,
 /**
  * cpufreq_cooling_register - function to create cpufreq cooling device.
  * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
+ * @devdata: driver data pointer
  *
  * This interface function registers the cpufreq cooling device with the name
  * "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
@@ -503,9 +553,9 @@ __cpufreq_cooling_register(struct device_node *np,
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
 
@@ -529,7 +579,7 @@ of_cpufreq_cooling_register(struct device_node *np,
 	if (!np)
 		return ERR_PTR(-EINVAL);
 
-	return __cpufreq_cooling_register(np, clip_cpus);
+	return __cpufreq_cooling_register(np, clip_cpus, NULL);
 }
 EXPORT_SYMBOL_GPL(of_cpufreq_cooling_register);
 
@@ -546,17 +596,22 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	if (!cdev)
 		return;
 
-	cpufreq_dev = cdev->devdata;
 	mutex_lock(&cooling_cpufreq_lock);
-	cpufreq_dev_count--;
+	cpufreq_dev = cpufreq_cooling_get_info(cdev);
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

