Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3ENKFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:05:25 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:41808 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3ENKAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:00:25 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 13/30] thermal: exynos: Add support for instance based register/unregister
Date: Tue, 14 May 2013 15:28:43 +0530
Message-Id: <1368525540-15034-14-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code modifies the thermal driver to have multiple thermal zone
support by replacing the global thermal zone variable with device data
member of thermal_zone_device.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c |   36 ++++++++++++++--------
 drivers/thermal/samsung/exynos_thermal_common.h |    9 +++--
 drivers/thermal/samsung/exynos_tmu.c            |   15 +++++----
 3 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index dd49c9f..2af1e3b 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -36,12 +36,11 @@ struct exynos_thermal_zone {
 	bool bind;
 };
 
-static struct exynos_thermal_zone *th_zone;
-
 /* Get mode callback functions for thermal zone */
 static int exynos_get_mode(struct thermal_zone_device *thermal,
 			enum thermal_device_mode *mode)
 {
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
 	if (th_zone)
 		*mode = th_zone->mode;
 	return 0;
@@ -51,25 +50,26 @@ static int exynos_get_mode(struct thermal_zone_device *thermal,
 static int exynos_set_mode(struct thermal_zone_device *thermal,
 			enum thermal_device_mode mode)
 {
-	if (!th_zone->therm_dev) {
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
+	if (!th_zone) {
 		pr_notice("thermal zone not registered\n");
 		return 0;
 	}
 
-	mutex_lock(&th_zone->therm_dev->lock);
+	mutex_lock(&thermal->lock);
 
 	if (mode == THERMAL_DEVICE_ENABLED &&
 		!th_zone->sensor_conf->trip_data.trigger_falling)
-		th_zone->therm_dev->polling_delay = IDLE_INTERVAL;
+		thermal->polling_delay = IDLE_INTERVAL;
 	else
-		th_zone->therm_dev->polling_delay = 0;
+		thermal->polling_delay = 0;
 
-	mutex_unlock(&th_zone->therm_dev->lock);
+	mutex_unlock(&thermal->lock);
 
 	th_zone->mode = mode;
-	thermal_zone_device_update(th_zone->therm_dev);
+	thermal_zone_device_update(thermal);
 	pr_info("thermal polling set for duration=%d msec\n",
-				th_zone->therm_dev->polling_delay);
+				thermal->polling_delay);
 	return 0;
 }
 
@@ -96,6 +96,8 @@ static int exynos_get_trip_type(struct thermal_zone_device *thermal, int trip,
 static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 				unsigned long *temp)
 {
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
+
 	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
 		return -EINVAL;
 
@@ -122,6 +124,7 @@ static int exynos_bind(struct thermal_zone_device *thermal,
 {
 	int ret = 0, i, tab_size, level;
 	struct freq_clip_table *tab_ptr, *clip_data;
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
 	struct thermal_sensor_conf *data = th_zone->sensor_conf;
 
 	tab_ptr = (struct freq_clip_table *)data->cooling_data.freq_data;
@@ -168,6 +171,7 @@ static int exynos_unbind(struct thermal_zone_device *thermal,
 			struct thermal_cooling_device *cdev)
 {
 	int ret = 0, i, tab_size;
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
 	struct thermal_sensor_conf *data = th_zone->sensor_conf;
 
 	if (th_zone->bind == false)
@@ -210,6 +214,7 @@ static int exynos_unbind(struct thermal_zone_device *thermal,
 static int exynos_get_temp(struct thermal_zone_device *thermal,
 			unsigned long *temp)
 {
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
 	void *data;
 
 	if (!th_zone->sensor_conf) {
@@ -229,6 +234,7 @@ static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
 {
 	void *data;
 	int ret = -EINVAL;
+	struct exynos_thermal_zone *th_zone = thermal->devdata;
 
 	if (!th_zone->sensor_conf) {
 		pr_info("Temperature sensor not initialised\n");
@@ -276,11 +282,12 @@ static struct thermal_zone_device_ops const exynos_dev_ops = {
  * This function may be called from interrupt based temperature sensor
  * when threshold is changed.
  */
-void exynos_report_trigger(void)
+void exynos_report_trigger(struct thermal_sensor_conf *conf)
 {
 	unsigned int i;
 	char data[10];
 	char *envp[] = { data, NULL };
+	struct exynos_thermal_zone *th_zone = conf->pzone_data;
 
 	if (!th_zone || !th_zone->therm_dev)
 		return;
@@ -321,6 +328,7 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 {
 	int ret;
 	struct cpumask mask_val;
+	struct exynos_thermal_zone *th_zone;
 
 	if (!sensor_conf || !sensor_conf->read_temperature) {
 		pr_err("Temperature sensor not initialised\n");
@@ -342,7 +350,7 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 	th_zone->cool_dev_size++;
 
 	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
-			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, NULL, 0,
+			EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops, NULL, 0,
 			sensor_conf->trip_data.trigger_falling ?
 			0 : IDLE_INTERVAL);
 
@@ -352,20 +360,22 @@ int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
 		goto err_unregister;
 	}
 	th_zone->mode = THERMAL_DEVICE_ENABLED;
+	sensor_conf->pzone_data = th_zone;
 
 	pr_info("Exynos: Kernel Thermal management registered\n");
 
 	return 0;
 
 err_unregister:
-	exynos_unregister_thermal();
+	exynos_unregister_thermal(sensor_conf);
 	return ret;
 }
 
 /* Un-Register with the in-kernel thermal management */
-void exynos_unregister_thermal(void)
+void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf)
 {
 	int i;
+	struct exynos_thermal_zone *th_zone = sensor_conf->pzone_data;
 
 	if (!th_zone)
 		return;
diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 068f56c..89ae078 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -77,22 +77,23 @@ struct thermal_sensor_conf {
 	struct thermal_trip_point_conf trip_data;
 	struct thermal_cooling_conf cooling_data;
 	void *private_data;
+	void *pzone_data;
 };
 
 /*Functions used exynos based thermal sensor driver*/
 #ifdef CONFIG_EXYNOS_THERMAL_CORE
-void exynos_unregister_thermal(void);
+void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf);
 int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
-void exynos_report_trigger(void);
+void exynos_report_trigger(struct thermal_sensor_conf *sensor_conf);
 #else
 static inline void
-exynos_unregister_thermal(void) { return; }
+exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf) { return; }
 
 static inline int
 exynos_register_thermal(struct thermal_sensor_conf *sensor_conf) { return 0; }
 
 static inline void
-exynos_report_trigger(void) { return; }
+exynos_report_trigger(struct thermal_sensor_conf *sensor_conf) { return; }
 
 #endif /* CONFIG_EXYNOS_THERMAL_CORE */
 #endif /* _EXYNOS_THERMAL_COMMON_H */
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 41e0bf9..a1dc402 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -315,6 +315,12 @@ static int exynos_tmu_set_emulation(void *drv_data,	unsigned long temp)
 	{ return -EINVAL; }
 #endif/*CONFIG_THERMAL_EMULATION*/
 
+static struct thermal_sensor_conf exynos_sensor_conf = {
+	.name			= "exynos-therm",
+	.read_temperature	= (int (*)(void *))exynos_tmu_read,
+	.write_emul_temp	= exynos_tmu_set_emulation,
+};
+
 static void exynos_tmu_work(struct work_struct *work)
 {
 	struct exynos_tmu_data *data = container_of(work,
@@ -323,7 +329,7 @@ static void exynos_tmu_work(struct work_struct *work)
 	const struct exynos_tmu_registers *reg = pdata->registers;
 	unsigned int val_irq;
 
-	exynos_report_trigger();
+	exynos_report_trigger(&exynos_sensor_conf);
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
@@ -347,11 +353,6 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
 
 	return IRQ_HANDLED;
 }
-static struct thermal_sensor_conf exynos_sensor_conf = {
-	.name			= "exynos-therm",
-	.read_temperature	= (int (*)(void *))exynos_tmu_read,
-	.write_emul_temp	= exynos_tmu_set_emulation,
-};
 
 #ifdef CONFIG_OF
 static const struct of_device_id exynos_tmu_match[] = {
@@ -517,7 +518,7 @@ static int exynos_tmu_remove(struct platform_device *pdev)
 
 	exynos_tmu_control(pdev, false);
 
-	exynos_unregister_thermal();
+	exynos_unregister_thermal(&exynos_sensor_conf);
 
 	clk_unprepare(data->clk);
 
-- 
1.7.1

