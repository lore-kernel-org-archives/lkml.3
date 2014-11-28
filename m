Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaK1Q72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:59:28 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:35841 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaK1Q70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:59:26 -0500
From: Eduardo Valentin <edubezval@gmail.com>
To: Linux PM <linux-pm@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCHv3 1/1] thermal: cpu_cooling: check for the readiness of cpufreq layer
Date: Fri, 28 Nov 2014 10:53:30 -0400
Message-Id: <1417186410-24551-1-git-send-email-edubezval@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch, the cpu_cooling code checks for the usability of cpufreq
layer before proceeding with the CPU cooling device registration. The
main reason is: CPU cooling device is not usable if cpufreq cannot
switch frequencies.

Similar checks are spread in thermal drivers. Thus, the advantage now
is to have the check in a single place: cpu cooling device registration.
For this reason, this patch also updates the existing drivers that
depend on CPU cooling to simply propagate the error code of the cpu
cooling registration call. Therefore, in case cpufreq is not ready, the
thermal drivers will still return -EPROBE_DEFER, in an attempt to try
again when cpufreq layer gets ready.

Cc: devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
---
 drivers/thermal/cpu_cooling.c                      | 3 +++
 drivers/thermal/db8500_cpufreq_cooling.c           | 5 -----
 drivers/thermal/imx_thermal.c                      | 5 -----
 drivers/thermal/samsung/exynos_thermal_common.c    | 7 ++++---
 drivers/thermal/samsung/exynos_tmu.c               | 4 +++-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 6 ------
 6 files changed, 10 insertions(+), 20 deletions(-)
---
Changes from V2:
- Removed logging message when returning EPROBE_DEFER. Majority
of the existing code simply do not log. Following the pattern
- Merges Viresh's patch in Exynos driver. Reasoning, the change
in the API behavior goes together with the needed changes in the API
users.

Changes from V1:
 - As per Viresh K. suggestion's, the check for cpufreq layer readiness is now
    only a simple fetch for cpufreq table.

This patch depends on:
(0) - Viresh's change in cpufreq layer and cpufreq-dt (up to patch 4):
https://patchwork.kernel.org/patch/5390731/
https://patchwork.kernel.org/patch/5390741/
https://patchwork.kernel.org/patch/5390751/
https://patchwork.kernel.org/patch/5390761/
(1) - fix of thermal core:
https://patchwork.kernel.org/patch/5326991/


BR,

Eduardo Valentin

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 1ab0018..88d2775 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -440,6 +440,9 @@ __cpufreq_cooling_register(struct device_node *np,
 	int ret = 0, i;
 	struct cpufreq_policy policy;
 
+	if (!cpufreq_frequency_get_table(0))
+		return ERR_PTR(-EPROBE_DEFER);
+
 	/* Verify that all the clip cpus have same freq_min, freq_max limit */
 	for_each_cpu(i, clip_cpus) {
 		/* continue if cpufreq policy not found and not return error */
diff --git a/drivers/thermal/db8500_cpufreq_cooling.c b/drivers/thermal/db8500_cpufreq_cooling.c
index 786d192..1ac7ec6 100644
--- a/drivers/thermal/db8500_cpufreq_cooling.c
+++ b/drivers/thermal/db8500_cpufreq_cooling.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/cpu_cooling.h>
-#include <linux/cpufreq.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -30,10 +29,6 @@ static int db8500_cpufreq_cooling_probe(struct platform_device *pdev)
 	struct thermal_cooling_device *cdev;
 	struct cpumask mask_val;
 
-	/* make sure cpufreq driver has been initialized */
-	if (!cpufreq_frequency_get_table(0))
-		return -EPROBE_DEFER;
-
 	cpumask_set_cpu(0, &mask_val);
 	cdev = cpufreq_cooling_register(&mask_val);
 
diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
index 5a1f107..16405b4 100644
--- a/drivers/thermal/imx_thermal.c
+++ b/drivers/thermal/imx_thermal.c
@@ -9,7 +9,6 @@
 
 #include <linux/clk.h>
 #include <linux/cpu_cooling.h>
-#include <linux/cpufreq.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/init.h>
@@ -459,10 +458,6 @@ static int imx_thermal_probe(struct platform_device *pdev)
 	int measure_freq;
 	int ret;
 
-	if (!cpufreq_get_current_driver()) {
-		dev_dbg(&pdev->dev, "no cpufreq driver!");
-		return -EPROBE_DEFER;
-	}
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index 3f5ad25..d4eaa1b 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -371,9 +371,10 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 		th_zone->cool_dev[th_zone->cool_dev_size] =
 					cpufreq_cooling_register(&mask_val);
 		if (IS_ERR(th_zone->cool_dev[th_zone->cool_dev_size])) {
-			dev_err(sensor_conf->dev,
-				"Failed to register cpufreq cooling device\n");
-			ret = -EINVAL;
+			ret = PTR_ERR(th_zone->cool_dev[th_zone->cool_dev_size]);
+			if (ret != -EPROBE_DEFER)
+				dev_err(sensor_conf->dev,
+					"Failed to register cpufreq cooling device\n");
 			goto err_unregister;
 		}
 		th_zone->cool_dev_size++;
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 2a1c4c7..d4429a5 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -927,7 +927,9 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	/* Register the sensor with thermal management interface */
 	ret = exynos_register_thermal(sensor_conf);
 	if (ret) {
-		dev_err(&pdev->dev, "Failed to register thermal interface\n");
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev,
+				"Failed to register thermal interface\n");
 		goto err_clk;
 	}
 	data->reg_conf = sensor_conf;
diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 5fd0386..cf88585 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -28,7 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
 #include <linux/thermal.h>
-#include <linux/cpufreq.h>
 #include <linux/cpumask.h>
 #include <linux/cpu_cooling.h>
 #include <linux/of.h>
@@ -407,11 +406,6 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 	if (!data)
 		return -EINVAL;
 
-	if (!cpufreq_get_current_driver()) {
-		dev_dbg(bgp->dev, "no cpufreq driver yet\n");
-		return -EPROBE_DEFER;
-	}
-
 	/* Register cooling device */
 	data->cool_dev = cpufreq_cooling_register(cpu_present_mask);
 	if (IS_ERR(data->cool_dev)) {
-- 
2.1.3

