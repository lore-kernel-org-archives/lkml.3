Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3ENKAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:00:43 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44598 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3ENKAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:00:38 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 16/30] thermal: exynos: Make the zone handling dependent on trip count
Date: Tue, 14 May 2013 15:28:46 +0530
Message-Id: <1368525540-15034-17-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code simplifies the zone handling to use the trip count passed
by the TMU driver. This also helps in adding more zone support.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c |   55 ++++++++++++-----------
 drivers/thermal/samsung/exynos_thermal_common.h |    2 -
 2 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index 86d39aa..2369417 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -78,17 +78,16 @@ static int exynos_set_mode(struct thermal_zone_device *thermal,
 static int exynos_get_trip_type(struct thermal_zone_device *thermal, int trip,
 				 enum thermal_trip_type *type)
 {
-	switch (GET_ZONE(trip)) {
-	case MONITOR_ZONE:
-	case WARN_ZONE:
-		*type = THERMAL_TRIP_ACTIVE;
-		break;
-	case PANIC_ZONE:
-		*type = THERMAL_TRIP_CRITICAL;
-		break;
-	default:
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
+	int max_trip = th_zone->sensor_conf->trip_data.trip_count;
+
+	if (trip < 0 || trip >= max_trip)
 		return -EINVAL;
-	}
+	else if (trip == (max_trip - 1))
+		*type = THERMAL_TRIP_CRITICAL;
+	else
+		*type = THERMAL_TRIP_ACTIVE;
+
 	return 0;
 }
 
@@ -97,8 +96,9 @@ static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 				unsigned long *temp)
 {
 	struct exynos_thermal_zone *th_zone = thermal->devdata;
+	int max_trip = th_zone->sensor_conf->trip_data.trip_count;
 
-	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
+	if (trip < 0 || trip >= max_trip)
 		return -EINVAL;
 
 	*temp = th_zone->sensor_conf->trip_data.trip_val[trip];
@@ -112,10 +112,10 @@ static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
 				unsigned long *temp)
 {
-	int ret;
-	/* Panic zone */
-	ret = exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
-	return ret;
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
+	int max_trip = th_zone->sensor_conf->trip_data.trip_count;
+	/* Get the temp of highest trip*/
+	return exynos_get_trip_temp(thermal, max_trip - 1, temp);
 }
 
 /* Bind callback functions for thermal zone */
@@ -340,19 +340,22 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 		return -ENOMEM;
 
 	th_zone->sensor_conf = sensor_conf;
-	cpumask_set_cpu(0, &mask_val);
-	th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
-	if (IS_ERR(th_zone->cool_dev[0])) {
-		pr_err("Failed to register cpufreq cooling device\n");
-		ret = -EINVAL;
-		goto err_unregister;
+	if (sensor_conf->cooling_data.freq_clip_count > 0) {
+		cpumask_set_cpu(0, &mask_val);
+		th_zone->cool_dev[0] = cpufreq_cooling_register(&mask_val);
+		if (IS_ERR(th_zone->cool_dev[0])) {
+			pr_err("Failed to register cpufreq cooling device\n");
+			ret = -EINVAL;
+			goto err_unregister;
+		}
+		th_zone->cool_dev_size++;
 	}
-	th_zone->cool_dev_size++;
 
-	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
-			EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops, NULL, 0,
-			sensor_conf->trip_data.trigger_falling ?
-			0 : IDLE_INTERVAL);
+	th_zone->therm_dev = thermal_zone_device_register(
+			sensor_conf->name, sensor_conf->trip_data.trip_count,
+			0, th_zone, &exynos_dev_ops, NULL, 0,
+			sensor_conf->trip_data.trigger_falling ? 0 :
+			IDLE_INTERVAL);
 
 	if (IS_ERR(th_zone->therm_dev)) {
 		pr_err("Failed to register thermal zone device\n");
diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 59138ae..7b938e1 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -42,8 +42,6 @@
 #define GET_ZONE(trip) (trip + 2)
 #define GET_TRIP(zone) (zone - 2)
 
-#define EXYNOS_ZONE_COUNT	3
-
 /**
  * struct freq_clip_table
  * @freq_clip_max: maximum frequency allowed for this cooling state.
-- 
1.7.1

