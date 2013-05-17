Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3EQLZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:25:35 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42622 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3EQLZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:25:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: arm_big_little_dt: Register driver only if DT has valid data
Date: Fri, 17 May 2013 16:55:11 +0530
Message-Id: <94a514cbf8edab0f253e0adb1ae0e2e761203ba6.1368789862.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If arm_big_little_dt driver is enabled, then it will always try to register with
big LITTLE cpufreq core driver. In case DT doesn't have relevant data for cpu
nodes, i.e. operating points aren't present, then we should exit early and
shouldn't register with big LITTLE cpufreq core driver. Otherwise we will fail
continuously from the driver->init() routine.

This patch fixes this issue.

Reported-by: Jon Medhurst <tixy@linaro.org>
Reviewed-by: Jon Medhurst <tixy@linaro.org>
Tested-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Targeted one is for 3.10-rc3

 drivers/cpufreq/arm_big_little_dt.c | 73 +++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
index 173ed05..27e2f45 100644
--- a/drivers/cpufreq/arm_big_little_dt.c
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -19,6 +19,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/cpu.h>
 #include <linux/cpufreq.h>
 #include <linux/device.h>
 #include <linux/export.h>
@@ -29,60 +30,63 @@
 #include <linux/types.h>
 #include "arm_big_little.h"
 
-static int dt_init_opp_table(struct device *cpu_dev)
+/* get cpu node with valid operating-points */
+static struct device_node *get_cpu_node_with_valid_op(int cpu)
 {
-	struct device_node *np, *parent;
-	int count = 0, ret;
+	struct device_node *np = NULL, *parent;
+	int count = 0;
 
 	parent = of_find_node_by_path("/cpus");
 	if (!parent) {
 		pr_err("failed to find OF /cpus\n");
-		return -ENOENT;
+		return NULL;
 	}
 
 	for_each_child_of_node(parent, np) {
-		if (count++ != cpu_dev->id)
+		if (count++ != cpu)
 			continue;
 		if (!of_get_property(np, "operating-points", NULL)) {
-			ret = -ENODATA;
-		} else {
-			cpu_dev->of_node = np;
-			ret = of_init_opp_table(cpu_dev);
+			of_node_put(np);
+			np = NULL;
 		}
-		of_node_put(np);
-		of_node_put(parent);
 
-		return ret;
+		break;
 	}
 
-	return -ENODEV;
+	of_node_put(parent);
+	return np;
+}
+
+static int dt_init_opp_table(struct device *cpu_dev)
+{
+	struct device_node *np;
+	int ret;
+
+	np = get_cpu_node_with_valid_op(cpu_dev->id);
+	if (!np)
+		return -ENODATA;
+
+	cpu_dev->of_node = np;
+	ret = of_init_opp_table(cpu_dev);
+	of_node_put(np);
+
+	return ret;
 }
 
 static int dt_get_transition_latency(struct device *cpu_dev)
 {
-	struct device_node *np, *parent;
+	struct device_node *np;
 	u32 transition_latency = CPUFREQ_ETERNAL;
-	int count = 0;
 
-	parent = of_find_node_by_path("/cpus");
-	if (!parent) {
-		pr_info("Failed to find OF /cpus. Use CPUFREQ_ETERNAL transition latency\n");
+	np = get_cpu_node_with_valid_op(cpu_dev->id);
+	if (!np)
 		return CPUFREQ_ETERNAL;
-	}
-
-	for_each_child_of_node(parent, np) {
-		if (count++ != cpu_dev->id)
-			continue;
-
-		of_property_read_u32(np, "clock-latency", &transition_latency);
-		of_node_put(np);
-		of_node_put(parent);
 
-		return transition_latency;
-	}
+	of_property_read_u32(np, "clock-latency", &transition_latency);
+	of_node_put(np);
 
-	pr_info("clock-latency isn't found, use CPUFREQ_ETERNAL transition latency\n");
-	return CPUFREQ_ETERNAL;
+	pr_debug("%s: clock-latency: %d\n", __func__, transition_latency);
+	return transition_latency;
 }
 
 static struct cpufreq_arm_bL_ops dt_bL_ops = {
@@ -93,6 +97,13 @@ static struct cpufreq_arm_bL_ops dt_bL_ops = {
 
 static int generic_bL_init(void)
 {
+	struct device_node *np;
+
+	np = get_cpu_node_with_valid_op(0);
+	if (!np)
+		return -ENODEV;
+
+	of_node_put(np);
 	return bL_cpufreq_register(&dt_bL_ops);
 }
 module_init(generic_bL_init);
-- 
1.7.12.rc2.18.g61b472e

