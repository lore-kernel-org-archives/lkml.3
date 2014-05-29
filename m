Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbaE2IRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:17:21 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:36106 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaE2IQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:16:09 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, edubezval@gmail.com, rjw@rjwysocki.net,
        linux-arm-kernel@lists.infradead.org, lenb@kernel.org
Subject: [PATCH v1 4/6] thermal: cpu_cooling: Add support to find up/low frequency levels.
Date: Thu, 29 May 2014 13:45:32 +0530
Message-Id: <1401351334-11210-5-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to get P state ceil/floor level for nearest frequency.
This will be used for consolidating ACPI cpufreq cooling via the generic cpu
cooling framework.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 Documentation/thermal/cpu-cooling-api.txt       |   15 +++++++++
 drivers/thermal/cpu_cooling.c                   |   39 +++++++++++++++++------
 drivers/thermal/samsung/exynos_thermal_common.c |    3 +-
 include/linux/cpu_cooling.h                     |   13 ++++++-
 4 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/Documentation/thermal/cpu-cooling-api.txt b/Documentation/thermal/cpu-cooling-api.txt
index aaa07c6..a1f93b8 100644
--- a/Documentation/thermal/cpu-cooling-api.txt
+++ b/Documentation/thermal/cpu-cooling-api.txt
@@ -31,3 +31,18 @@ the user. The registration APIs returns the cooling device pointer.
     This interface function unregisters the "thermal-cpufreq-%x" cooling device.
 
     cdev: Cooling device pointer which has to be unregistered.
+
+1.1.3 unsigned long cpufreq_cooling_get_level(unsigned int cpu,
+			unsigned int freq, enum cpufreq_cooling_property)
+
+    This interface gets the frequency level for the absolute frequency by
+    matching in grequency table.
+
+    cpu: cpu for which the frequency level is expected.
+    freq: absolute input frequency as found in cpu freq table.
+    cpufreq_cooling_property:
+	.GET_LEVEL_CEIL: returns the ceil of the frequency level.
+	.GET_LEVEL_FLOOR: returns the floor of the frequency level.
+	.GET_LEVEL_EXACT: returns the exact frequency level if found.
+	.GET_MAXL: returns the max frequency level.
+
diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 6d145d5..4ce8803 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -120,11 +120,7 @@ cpufreq_cooling_get_info(struct thermal_cooling_device *cdev)
 	return cpufreq_dev;
 }
 
-enum cpufreq_cooling_property {
-	GET_LEVEL,
-	GET_FREQ,
-	GET_MAXL,
-};
+#define GET_FREQ (sizeof(enum cpufreq_cooling_property) + 1)
 
 /**
  * get_property - fetch a property of interest for a give cpu.
@@ -207,15 +203,37 @@ static int get_property(unsigned int cpu, unsigned long input,
 		/* now we have a valid frequency entry */
 		freq = table[i].frequency;
 
-		if (property == GET_LEVEL && (unsigned int)input == freq) {
+		if (property == GET_LEVEL_EXACT &&
+						(unsigned int)input == freq) {
 			/* get level by frequency */
 			*output = descend ? j : (max_level - j);
 			return 0;
-		}
-		if (property == GET_FREQ && level == j) {
+		} else if (property == GET_FREQ && level == j) {
 			/* get frequency by level */
 			*output = freq;
 			return 0;
+		} else if (property == GET_LEVEL_FLOOR) {
+			/* get minimum possible level by frequency */
+			if (descend && freq <= input) {
+				*output = j;
+				return 0;
+			} else if (!descend) {
+				if (freq <= input)
+					*output = (max_level - j);
+				else
+					return 0;
+			}
+		} else if (property == GET_LEVEL_CEIL) {
+			/* get maximum possible level by frequency */
+			if (!descend && freq >= input) {
+				*output = (max_level - j);
+				return 0;
+			} else if (descend) {
+				if (freq >= input)
+					*output = j;
+				else
+					return 0;
+			}
 		}
 		j++;
 	}
@@ -234,11 +252,12 @@ static int get_property(unsigned int cpu, unsigned long input,
  * Return: The matched cooling level on success or THERMAL_CSTATE_INVALID
  * otherwise.
  */
-unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
+unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq,
+			enum cpufreq_cooling_property property)
 {
 	unsigned int val;
 
-	if (get_property(cpu, (unsigned long)freq, &val, GET_LEVEL))
+	if (get_property(cpu, (unsigned long)freq, &val, property))
 		return THERMAL_CSTATE_INVALID;
 
 	return (unsigned long)val;
diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index a7306fa..aa4696b 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -156,7 +156,8 @@ static int exynos_bind(struct thermal_zone_device *thermal,
 	/* Bind the thermal zone to the cpufreq cooling device */
 	for (i = 0; i < tab_size; i++) {
 		clip_data = (struct freq_clip_table *)&(tab_ptr[i]);
-		level = cpufreq_cooling_get_level(0, clip_data->freq_clip_max);
+		level = cpufreq_cooling_get_level(0, clip_data->freq_clip_max,
+						GET_LEVEL_EXACT);
 		if (level == THERMAL_CSTATE_INVALID)
 			return 0;
 		switch (GET_ZONE(i)) {
diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index aaef7d8..dba52c9 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -28,6 +28,13 @@
 #include <linux/thermal.h>
 #include <linux/cpumask.h>
 
+enum cpufreq_cooling_property {
+	GET_LEVEL_CEIL,
+	GET_LEVEL_FLOOR,
+	GET_LEVEL_EXACT,
+	GET_MAXL,
+};
+
 #ifdef CONFIG_CPU_THERMAL
 /**
  * cpufreq_cooling_register - function to create cpufreq cooling device.
@@ -61,7 +68,8 @@ of_cpufreq_cooling_register(struct device_node *np,
  */
 void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev);
 
-unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq);
+unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq,
+					enum cpufreq_cooling_property);
 #else /* !CONFIG_CPU_THERMAL */
 static inline struct thermal_cooling_device *
 cpufreq_cooling_register(const struct cpumask *clip_cpus, void *devdata)
@@ -80,7 +88,8 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	return;
 }
 static inline
-unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
+unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq,
+					enum cpufreq_cooling_property property)
 {
 	return THERMAL_CSTATE_INVALID;
 }
-- 
1.7.1

