Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaK0ONK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:13:10 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:41215 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaK0ONI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:13:08 -0500
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
Subject: [PATCHv2 1/1] thermal: cpu_cooling: check for the readiness of cpufreq layer
Date: Thu, 27 Nov 2014 10:12:57 -0400
Message-Id: <1417097577-3548-1-git-send-email-edubezval@gmail.com>
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
 drivers/thermal/cpu_cooling.c                      | 5 +++++
 drivers/thermal/db8500_cpufreq_cooling.c           | 5 -----
 drivers/thermal/imx_thermal.c                      | 5 -----
 drivers/thermal/samsung/exynos_thermal_common.c    | 2 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 6 ------
 5 files changed, 6 insertions(+), 17 deletions(-)
---
(I'm sorry VireshK, I am still using my normal practice) :-)

Changes from V1:
 - As per Viresh K. suggestion's, the check for cpufreq layer readiness is now
   only a simple fetch for cpufreq table.

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 1ab0018..bed3fa2 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -440,6 +440,11 @@ __cpufreq_cooling_register(struct device_node *np,
 	int ret = 0, i;
 	struct cpufreq_policy policy;
 
+	if (!cpufreq_frequency_get_table(0)) {
+		pr_err("cpu_cooling: cpufreq layer not ready! Deferring.\n");
+		return ERR_PTR(-EPROBE_DEFER);
+	}
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
index 3f5ad25..f84975e 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -373,7 +373,7 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 		if (IS_ERR(th_zone->cool_dev[th_zone->cool_dev_size])) {
 			dev_err(sensor_conf->dev,
 				"Failed to register cpufreq cooling device\n");
-			ret = -EINVAL;
+			ret = PTR_ERR(th_zone->cool_dev[th_zone->cool_dev_size]);
 			goto err_unregister;
 		}
 		th_zone->cool_dev_size++;
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

