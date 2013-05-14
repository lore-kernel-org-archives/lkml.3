Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3ENKEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:04:15 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33232 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab3ENKAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:00:51 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 19/30] thermal: exynos: use device resource management infrastructure
Date: Tue, 14 May 2013 15:28:49 +0530
Message-Id: <1368525540-15034-20-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch stores the device pointer in the configuration structure
and uses it for dev_* prints and devm API's.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c |   39 ++++++++++++++--------
 drivers/thermal/samsung/exynos_thermal_common.h |    1 +
 drivers/thermal/samsung/exynos_tmu.c            |    2 +-
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index 2369417..f41390e 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -52,7 +52,8 @@ static int exynos_set_mode(struct thermal_zone_device *thermal,
 {
 	struct exynos_thermal_zone *th_zone = thermal->devdata;
 	if (!th_zone) {
-		pr_notice("thermal zone not registered\n");
+		dev_err(th_zone->sensor_conf->dev,
+			"thermal zone not registered\n");
 		return 0;
 	}
 
@@ -68,8 +69,9 @@ static int exynos_set_mode(struct thermal_zone_device *thermal,
 
 	th_zone->mode = mode;
 	thermal_zone_device_update(thermal);
-	pr_info("thermal polling set for duration=%d msec\n",
-				thermal->polling_delay);
+	dev_dbg(th_zone->sensor_conf->dev,
+		"thermal polling set for duration=%d msec\n",
+		thermal->polling_delay);
 	return 0;
 }
 
@@ -153,7 +155,8 @@ static int exynos_bind(struct thermal_zone_device *thermal,
 		case WARN_ZONE:
 			if (thermal_zone_bind_cooling_device(thermal, i, cdev,
 								level, 0)) {
-				pr_err("error binding cdev inst %d\n", i);
+				dev_err(data->dev,
+					"error unbinding cdev inst=%d\n", i);
 				ret = -EINVAL;
 			}
 			th_zone->bind = true;
@@ -198,7 +201,8 @@ static int exynos_unbind(struct thermal_zone_device *thermal,
 		case WARN_ZONE:
 			if (thermal_zone_unbind_cooling_device(thermal, i,
 								cdev)) {
-				pr_err("error unbinding cdev inst=%d\n", i);
+				dev_err(data->dev,
+					"error unbinding cdev inst=%d\n", i);
 				ret = -EINVAL;
 			}
 			th_zone->bind = false;
@@ -218,7 +222,8 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
 	void *data;
 
 	if (!th_zone->sensor_conf) {
-		pr_info("Temperature sensor not initialised\n");
+		dev_err(th_zone->sensor_conf->dev,
+			"Temperature sensor not initialised\n");
 		return -EINVAL;
 	}
 	data = th_zone->sensor_conf->driver_data;
@@ -237,7 +242,8 @@ static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
 	struct exynos_thermal_zone *th_zone = thermal->devdata;
 
 	if (!th_zone->sensor_conf) {
-		pr_info("Temperature sensor not initialised\n");
+		dev_err(th_zone->sensor_conf->dev,
+			"Temperature sensor not initialised\n");
 		return -EINVAL;
 	}
 	data = th_zone->sensor_conf->driver_data;
@@ -331,11 +337,13 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 	struct exynos_thermal_zone *th_zone;
 
 	if (!sensor_conf || !sensor_conf->read_temperature) {
-		pr_err("Temperature sensor not initialised\n");
+		dev_err(sensor_conf->dev,
+				"Temperature sensor not initialised\n");
 		return -EINVAL;
 	}
 
-	th_zone = kzalloc(sizeof(struct exynos_thermal_zone), GFP_KERNEL);
+	th_zone = devm_kzalloc(sensor_conf->dev,
+				sizeof(struct exynos_thermal_zone), GFP_KERNEL);
 	if (!th_zone)
 		return -ENOMEM;
 
@@ -344,7 +352,8 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 		cpumask_set_cpu(0, &mask_val);
 		th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
 		if (IS_ERR(th_zone->cool_dev[0])) {
-			pr_err("Failed to register cpufreq cooling device\n");
+			dev_err(sensor_conf->dev,
+				"Failed to register cpufreq cooling device\n");
 			ret = -EINVAL;
 			goto err_unregister;
 		}
@@ -358,14 +367,16 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 			IDLE_INTERVAL);
 
 	if (IS_ERR(th_zone->therm_dev)) {
-		pr_err("Failed to register thermal zone device\n");
+		dev_err(sensor_conf->dev,
+			"Failed to register thermal zone device\n");
 		ret = PTR_ERR(th_zone->therm_dev);
 		goto err_unregister;
 	}
 	th_zone->mode = THERMAL_DEVICE_ENABLED;
 	sensor_conf->pzone_data = th_zone;
 
-	pr_info("Exynos: Kernel Thermal management registered\n");
+	dev_info(sensor_conf->dev,
+		"Exynos: Thermal zone(%s) registered\n", sensor_conf->name);
 
 	return 0;
 
@@ -391,6 +402,6 @@ void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf)
 			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
 	}
 
-	kfree(th_zone);
-	pr_info("Exynos: Kernel Thermal management unregistered\n");
+	dev_info(sensor_conf->dev,
+		"Exynos: Kernel Thermal management unregistered\n");
 }
diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 7b938e1..ea4cd3f 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -76,6 +76,7 @@ struct thermal_sensor_conf {
 	struct thermal_cooling_conf cooling_data;
 	void *driver_data;
 	void *pzone_data;
+	struct device *dev;
 };
 
 /*Functions used exynos based thermal sensor driver*/
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index de98312..e627150 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -545,7 +545,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		sensor_conf->cooling_data.freq_data[i].temp_level =
 					pdata->freq_tab[i].temp_level;
 	}
-
+	sensor_conf->dev = &pdev->dev;
 	/* Register the sensor with thermal management interface */
 	ret = exynos_register_thermal(sensor_conf);
 	if (ret) {
-- 
1.7.1

