Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbaE2IQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:16:41 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64945 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596AbaE2IQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:16:17 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, edubezval@gmail.com, rjw@rjwysocki.net,
        linux-arm-kernel@lists.infradead.org, lenb@kernel.org
Subject: [PATCH v1 6/6] ACPI: thermal: processor: Use the generic cpufreq infrastructure
Date: Thu, 29 May 2014 13:45:34 +0530
Message-Id: <1401351334-11210-7-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch upgrades the ACPI cpufreq cooling portions to use the generic
cpufreq cooling infrastructure. There should not be any functionality
related changes as the same behaviour is provided by the generic
cpufreq APIs with the notifier mechanism.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/acpi/processor_driver.c  |    6 +-
 drivers/acpi/processor_thermal.c |  235 ++++++++++++++++++--------------------
 include/acpi/processor.h         |    3 +-
 3 files changed, 115 insertions(+), 129 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 7f70f31..10aba4a 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -36,6 +36,7 @@
 #include <linux/cpuidle.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/cpu_cooling.h>
 
 #include <acpi/processor.h>
 
@@ -178,8 +179,7 @@ static int __acpi_processor_start(struct acpi_device *device)
 	if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
 		acpi_processor_power_init(pr);
 
-	pr->cdev = thermal_cooling_device_register("Processor", device,
-						   &processor_cooling_ops);
+	pr->cdev = acpi_processor_cooling_register(device);
 	if (IS_ERR(pr->cdev)) {
 		result = PTR_ERR(pr->cdev);
 		goto err_power_exit;
@@ -250,7 +250,7 @@ static int acpi_processor_stop(struct device *dev)
 	if (pr->cdev) {
 		sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
 		sysfs_remove_link(&pr->cdev->device.kobj, "device");
-		thermal_cooling_device_unregister(pr->cdev);
+		cpufreq_cooling_unregister(pr->cdev);
 		pr->cdev = NULL;
 	}
 	return 0;
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index e003663..9fc4a58 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -31,6 +31,7 @@
 #include <linux/init.h>
 #include <linux/cpufreq.h>
 #include <linux/acpi.h>
+#include <linux/cpu_cooling.h>
 #include <acpi/processor.h>
 #include <asm/uaccess.h>
 
@@ -53,27 +54,13 @@ ACPI_MODULE_NAME("processor_thermal");
 
 static DEFINE_PER_CPU(unsigned int, cpufreq_thermal_reduction_pctg);
 static unsigned int acpi_thermal_cpufreq_is_init = 0;
+static struct notifier_block cpufreq_cooling_notifier_block;
+static int phys_package_first_cpu(int cpu);
 
 #define reduction_pctg(cpu) \
 	per_cpu(cpufreq_thermal_reduction_pctg, phys_package_first_cpu(cpu))
 
-/*
- * Emulate "per package data" using per cpu data (which should really be
- * provided elsewhere)
- *
- * Note we can lose a CPU on cpu hotunplug, in this case we forget the state
- * temporarily. Fortunately that's not a big issue here (I hope)
- */
-static int phys_package_first_cpu(int cpu)
-{
-	int i;
-	int id = topology_physical_package_id(cpu);
-
-	for_each_online_cpu(i)
-		if (topology_physical_package_id(i) == id)
-			return i;
-	return 0;
-}
+static DEFINE_PER_CPU(struct acpi_device *, acpi_dev);
 
 static int cpu_has_cpufreq(unsigned int cpu)
 {
@@ -83,30 +70,6 @@ static int cpu_has_cpufreq(unsigned int cpu)
 	return 1;
 }
 
-static int acpi_thermal_cpufreq_notifier(struct notifier_block *nb,
-					 unsigned long event, void *data)
-{
-	struct cpufreq_policy *policy = data;
-	unsigned long max_freq = 0;
-
-	if (event != CPUFREQ_ADJUST)
-		goto out;
-
-	max_freq = (
-	    policy->cpuinfo.max_freq *
-	    (100 - reduction_pctg(policy->cpu) * 20)
-	) / 100;
-
-	cpufreq_verify_within_limits(policy, 0, max_freq);
-
-      out:
-	return 0;
-}
-
-static struct notifier_block acpi_thermal_cpufreq_notifier_block = {
-	.notifier_call = acpi_thermal_cpufreq_notifier,
-};
-
 static int cpufreq_get_max_state(unsigned int cpu)
 {
 	if (!cpu_has_cpufreq(cpu))
@@ -123,34 +86,31 @@ static int cpufreq_get_cur_state(unsigned int cpu)
 	return reduction_pctg(cpu);
 }
 
-static int cpufreq_set_cur_state(unsigned int cpu, int state)
+static int acpi_processor_freq_level(unsigned int cpu, int state)
 {
-	int i;
+	struct cpufreq_policy policy;
+	unsigned long max_freq = 0;
+	int level = 0;
 
-	if (!cpu_has_cpufreq(cpu))
+	if (!acpi_thermal_cpufreq_is_init || cpufreq_get_policy(&policy, cpu))
 		return 0;
 
 	reduction_pctg(cpu) = state;
+	max_freq = (
+	    policy.cpuinfo.max_freq *
+	    (100 - reduction_pctg(cpu) * 20)
+	) / 100;
 
-	/*
-	 * Update all the CPUs in the same package because they all
-	 * contribute to the temperature and often share the same
-	 * frequency.
-	 */
-	for_each_online_cpu(i) {
-		if (topology_physical_package_id(i) ==
-		    topology_physical_package_id(cpu))
-			cpufreq_update_policy(i);
-	}
-	return 0;
+	level =  cpufreq_cooling_get_level(phys_package_first_cpu(cpu),
+						max_freq, GET_LEVEL_FLOOR);
+	return level;
 }
 
 void acpi_thermal_cpufreq_init(void)
 {
 	int i;
 
-	i = cpufreq_register_notifier(&acpi_thermal_cpufreq_notifier_block,
-				      CPUFREQ_POLICY_NOTIFIER);
+	i = thermal_cooling_register_notifier(&cpufreq_cooling_notifier_block);
 	if (!i)
 		acpi_thermal_cpufreq_is_init = 1;
 }
@@ -158,31 +118,30 @@ void acpi_thermal_cpufreq_init(void)
 void acpi_thermal_cpufreq_exit(void)
 {
 	if (acpi_thermal_cpufreq_is_init)
-		cpufreq_unregister_notifier
-		    (&acpi_thermal_cpufreq_notifier_block,
-		     CPUFREQ_POLICY_NOTIFIER);
+		thermal_cooling_unregister_notifier(
+					&cpufreq_cooling_notifier_block);
 
 	acpi_thermal_cpufreq_is_init = 0;
 }
 
-#else				/* ! CONFIG_CPU_FREQ */
-static int cpufreq_get_max_state(unsigned int cpu)
-{
-	return 0;
-}
-
-static int cpufreq_get_cur_state(unsigned int cpu)
+/*
+ * Emulate "per package data" using per cpu data (which should really be
+ * provided elsewhere)
+ *
+ * Note we can lose a CPU on cpu hotunplug, in this case we forget the state
+ * temporarily. Fortunately that's not a big issue here (I hope)
+ */
+static int phys_package_first_cpu(int cpu)
 {
-	return 0;
-}
+	int i;
+	int id = topology_physical_package_id(cpu);
 
-static int cpufreq_set_cur_state(unsigned int cpu, int state)
-{
+	for_each_online_cpu(i)
+		if (topology_physical_package_id(i) == id)
+			return i;
 	return 0;
 }
 
-#endif
-
 /* thermal cooling device callbacks */
 static int acpi_processor_max_state(struct acpi_processor *pr)
 {
@@ -198,57 +157,22 @@ static int acpi_processor_max_state(struct acpi_processor *pr)
 
 	return max_state;
 }
-static int
-processor_get_max_state(struct thermal_cooling_device *cdev,
-			unsigned long *state)
-{
-	struct acpi_device *device = cdev->devdata;
-	struct acpi_processor *pr;
-
-	if (!device)
-		return -EINVAL;
-
-	pr = acpi_driver_data(device);
-	if (!pr)
-		return -EINVAL;
-
-	*state = acpi_processor_max_state(pr);
-	return 0;
-}
 
-static int
-processor_get_cur_state(struct thermal_cooling_device *cdev,
-			unsigned long *cur_state)
+static int acpi_processor_cur_state(struct acpi_processor *pr)
 {
-	struct acpi_device *device = cdev->devdata;
-	struct acpi_processor *pr;
-
-	if (!device)
-		return -EINVAL;
-
-	pr = acpi_driver_data(device);
-	if (!pr)
-		return -EINVAL;
-
-	*cur_state = cpufreq_get_cur_state(pr->id);
+	int cur_state = 0;
+	cur_state = cpufreq_get_cur_state(pr->id);
 	if (pr->flags.throttling)
-		*cur_state += pr->throttling.state;
-	return 0;
+		cur_state += pr->throttling.state;
+	return cur_state;
 }
 
-static int
-processor_set_cur_state(struct thermal_cooling_device *cdev,
-			unsigned long state)
+static int acpi_processor_set_cur_state(struct acpi_processor *pr,
+		struct thermal_cooling_status *cooling,	unsigned long event)
 {
-	struct acpi_device *device = cdev->devdata;
-	struct acpi_processor *pr;
-	int result = 0;
-	int max_pstate;
-
-	if (!device)
-		return -EINVAL;
+	int result = 0, level = 0;
+	int max_pstate, state = cooling->new_state;
 
-	pr = acpi_driver_data(device);
 	if (!pr)
 		return -EINVAL;
 
@@ -257,20 +181,81 @@ processor_set_cur_state(struct thermal_cooling_device *cdev,
 	if (state > acpi_processor_max_state(pr))
 		return -EINVAL;
 
-	if (state <= max_pstate) {
+	if (state <= max_pstate && event == COOLING_SET_STATE_PRE) {
 		if (pr->flags.throttling && pr->throttling.state)
 			result = acpi_processor_set_throttling(pr, 0, false);
-		cpufreq_set_cur_state(pr->id, state);
-	} else {
-		cpufreq_set_cur_state(pr->id, max_pstate);
+	} else if (state > max_pstate && event == COOLING_SET_STATE_POST) {
 		result = acpi_processor_set_throttling(pr,
 				state - max_pstate, false);
 	}
+
+	level = acpi_processor_freq_level(pr->id, state);
+	cooling->new_state = level;
+
 	return result;
 }
 
-const struct thermal_cooling_device_ops processor_cooling_ops = {
-	.get_max_state = processor_get_max_state,
-	.get_cur_state = processor_get_cur_state,
-	.set_cur_state = processor_set_cur_state,
+static int acpi_cpufreq_cooling_notifier(struct notifier_block *nb,
+					 unsigned long event, void *data)
+{
+	struct thermal_cooling_status *cooling = data;
+	struct acpi_device *device = NULL;
+	struct acpi_processor *pr;
+	int i;
+
+	for_each_online_cpu(i)
+		if (per_cpu(acpi_dev, i) == cooling->devdata) {
+			device = cooling->devdata;
+			break;
+		}
+
+	if (device == NULL)
+		return 0; /* notfier for some other client */
+
+	pr = acpi_driver_data(device);
+	switch (event) {
+	case COOLING_SET_STATE_PRE:
+	case COOLING_SET_STATE_POST:
+		acpi_processor_set_cur_state(pr, cooling, event);
+		break;
+	case COOLING_GET_MAX_STATE:
+		cooling->max_state = acpi_processor_max_state(pr);
+		break;
+	case COOLING_GET_CUR_STATE:
+		cooling->cur_state = acpi_processor_cur_state(pr);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct notifier_block cpufreq_cooling_notifier_block = {
+	.notifier_call = acpi_cpufreq_cooling_notifier,
 };
+
+struct thermal_cooling_device *
+acpi_processor_cooling_register(struct acpi_device *device)
+{
+	struct thermal_cooling_device *cdev;
+	struct acpi_processor *pr = acpi_driver_data(device);
+	int cpu = phys_package_first_cpu(pr->id);
+	int i;
+	int id = topology_physical_package_id(cpu);
+	struct cpumask cpus;
+
+	for_each_online_cpu(i)
+		if (topology_physical_package_id(i) == id)
+			cpumask_set_cpu(i, &cpus);
+
+	cdev = cpufreq_cooling_register(&cpus, (void *)device);
+	per_cpu(acpi_dev, id) = device;
+	return cdev;
+}
+#else				/* ! CONFIG_CPU_FREQ */
+struct thermal_cooling_device *
+acpi_processor_cooling_register(struct acpi_device *device)
+{
+	return NULL;
+}
+#endif
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 6eb1d3c..d6e8f67 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -348,7 +348,8 @@ static inline void acpi_processor_syscore_exit(void) {}
 
 /* in processor_thermal.c */
 int acpi_processor_get_limit_info(struct acpi_processor *pr);
-extern const struct thermal_cooling_device_ops processor_cooling_ops;
+struct thermal_cooling_device *
+acpi_processor_cooling_register(struct acpi_device *device);
 #ifdef CONFIG_CPU_FREQ
 void acpi_thermal_cpufreq_init(void);
 void acpi_thermal_cpufreq_exit(void);
-- 
1.7.1

