Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3CRPBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:01:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56669 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab3CRPBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:01:33 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit <b-cousson@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 4/8] staging: rename omap-thermal driver to ti-soc-thermal
Date: Mon, 18 Mar 2013 10:59:12 -0400
Message-ID: <1363618756-15851-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because this driver will support also OMAP derivatives,
this patch does a big rename inside this driver, so it
better fits its usage.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Benoit <b-cousson@ti.com>
Cc: Nishanth Menon <nm@ti.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

 delete mode 100644 drivers/staging/omap-thermal/Makefile
 delete mode 100644 drivers/staging/omap-thermal/omap-thermal-common.c
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/Kconfig (82%)
 create mode 100644 drivers/staging/ti-soc-thermal/Makefile
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/TODO (100%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4-thermal-data.c (85%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap4xxx-bandgap.h (100%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5-thermal-data.c (96%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap5xxx-bandgap.h (100%)
 rename drivers/staging/{omap-thermal => ti-soc-thermal}/omap_bandgap.txt (100%)
 rename drivers/staging/{omap-thermal/omap-bandgap.c => ti-soc-thermal/ti-bandgap.c} (67%)
 rename drivers/staging/{omap-thermal/omap-bandgap.h => ti-soc-thermal/ti-bandgap.h} (79%)
 create mode 100644 drivers/staging/ti-soc-thermal/ti-thermal-common.c
 rename drivers/staging/{omap-thermal/omap-thermal.h => ti-soc-thermal/ti-thermal.h} (72%)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index d4775a5..5e62d00 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -120,7 +120,7 @@ source "drivers/staging/gdm72xx/Kconfig"
 
 source "drivers/staging/csr/Kconfig"
 
-source "drivers/staging/omap-thermal/Kconfig"
+source "drivers/staging/ti-soc-thermal/Kconfig"
 
 source "drivers/staging/silicom/Kconfig"
 
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index e1ed6ad..b6d15ec 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -53,7 +53,7 @@ obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
 obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
 obj-$(CONFIG_CSR_WIFI)		+= csr/
-obj-$(CONFIG_OMAP_BANDGAP)	+= omap-thermal/
+obj-$(CONFIG_TI_SOC_THERMAL)	+= ti-soc-thermal/
 obj-$(CONFIG_NET_VENDOR_SILICOM)	+= silicom/
 obj-$(CONFIG_CED1401)		+= ced1401/
 obj-$(CONFIG_DRM_IMX)		+= imx-drm/
diff --git a/drivers/staging/omap-thermal/Makefile b/drivers/staging/omap-thermal/Makefile
deleted file mode 100644
index fbd14d1..0000000
--- a/drivers/staging/omap-thermal/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-obj-$(CONFIG_OMAP_BANDGAP)	+= omap-thermal.o
-omap-thermal-y			:= omap-bandgap.o
-omap-thermal-$(CONFIG_OMAP_THERMAL)	+= omap-thermal-common.o
-omap-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
-omap-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/staging/omap-thermal/omap-thermal-common.c b/drivers/staging/omap-thermal/omap-thermal-common.c
deleted file mode 100644
index 8aebc6a..0000000
--- a/drivers/staging/omap-thermal/omap-thermal-common.c
+++ /dev/null
@@ -1,338 +0,0 @@
-/*
- * OMAP thermal driver interface
- *
- * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
- * Contact:
- *   Eduardo Valentin <eduardo.valentin@ti.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/mutex.h>
-#include <linux/gfp.h>
-#include <linux/kernel.h>
-#include <linux/workqueue.h>
-#include <linux/thermal.h>
-#include <linux/cpufreq.h>
-#include <linux/cpumask.h>
-#include <linux/cpu_cooling.h>
-
-#include "omap-thermal.h"
-#include "omap-bandgap.h"
-
-/* common data structures */
-struct omap_thermal_data {
-	struct thermal_zone_device *omap_thermal;
-	struct thermal_cooling_device *cool_dev;
-	struct omap_bandgap *bg_ptr;
-	enum thermal_device_mode mode;
-	struct work_struct thermal_wq;
-	int sensor_id;
-};
-
-static void omap_thermal_work(struct work_struct *work)
-{
-	struct omap_thermal_data *data = container_of(work,
-					struct omap_thermal_data, thermal_wq);
-
-	thermal_zone_device_update(data->omap_thermal);
-
-	dev_dbg(&data->omap_thermal->device, "updated thermal zone %s\n",
-		data->omap_thermal->type);
-}
-
-/**
- * omap_thermal_hotspot_temperature - returns sensor extrapolated temperature
- * @t:	omap sensor temperature
- * @s:	omap sensor slope value
- * @c:	omap sensor const value
- */
-static inline int omap_thermal_hotspot_temperature(int t, int s, int c)
-{
-	int delta = t * s / 1000 + c;
-
-	if (delta < 0)
-		delta = 0;
-
-	return t + delta;
-}
-
-/* thermal zone ops */
-/* Get temperature callback function for thermal zone*/
-static inline int omap_thermal_get_temp(struct thermal_zone_device *thermal,
-					 unsigned long *temp)
-{
-	struct omap_thermal_data *data = thermal->devdata;
-	struct omap_bandgap *bg_ptr;
-	struct omap_temp_sensor *s;
-	int ret, tmp, pcb_temp, slope, constant;
-
-	if (!data)
-		return 0;
-
-	bg_ptr = data->bg_ptr;
-	s = &bg_ptr->conf->sensors[data->sensor_id];
-
-	ret = omap_bandgap_read_temperature(bg_ptr, data->sensor_id, &tmp);
-	if (ret)
-		return ret;
-
-	pcb_temp = 0;
-	/* TODO: Introduce pcb temperature lookup */
-	/* In case pcb zone is available, use the extrapolation rule with it */
-	if (pcb_temp) {
-		tmp -= pcb_temp;
-		slope = s->slope_pcb;
-		constant = s->constant_pcb;
-	} else {
-		slope = s->slope;
-		constant = s->constant;
-	}
-	*temp = omap_thermal_hotspot_temperature(tmp, slope, constant);
-
-	return ret;
-}
-
-/* Bind callback functions for thermal zone */
-static int omap_thermal_bind(struct thermal_zone_device *thermal,
-			      struct thermal_cooling_device *cdev)
-{
-	struct omap_thermal_data *data = thermal->devdata;
-	int id;
-
-	if (IS_ERR_OR_NULL(data))
-		return -ENODEV;
-
-	/* check if this is the cooling device we registered */
-	if (data->cool_dev != cdev)
-		return 0;
-
-	id = data->sensor_id;
-
-	/* TODO: bind with min and max states */
-	/* Simple thing, two trips, one passive another critical */
-	return thermal_zone_bind_cooling_device(thermal, 0, cdev,
-						THERMAL_NO_LIMIT,
-						THERMAL_NO_LIMIT);
-}
-
-/* Unbind callback functions for thermal zone */
-static int omap_thermal_unbind(struct thermal_zone_device *thermal,
-				struct thermal_cooling_device *cdev)
-{
-	struct omap_thermal_data *data = thermal->devdata;
-
-	if (IS_ERR_OR_NULL(data))
-		return -ENODEV;
-
-	/* check if this is the cooling device we registered */
-	if (data->cool_dev != cdev)
-		return 0;
-
-	/* Simple thing, two trips, one passive another critical */
-	return thermal_zone_unbind_cooling_device(thermal, 0, cdev);
-}
-
-/* Get mode callback functions for thermal zone */
-static int omap_thermal_get_mode(struct thermal_zone_device *thermal,
-				  enum thermal_device_mode *mode)
-{
-	struct omap_thermal_data *data = thermal->devdata;
-
-	if (data)
-		*mode = data->mode;
-
-	return 0;
-}
-
-/* Set mode callback functions for thermal zone */
-static int omap_thermal_set_mode(struct thermal_zone_device *thermal,
-				  enum thermal_device_mode mode)
-{
-	struct omap_thermal_data *data = thermal->devdata;
-
-	if (!data->omap_thermal) {
-		dev_notice(&thermal->device, "thermal zone not registered\n");
-		return 0;
-	}
-
-	mutex_lock(&data->omap_thermal->lock);
-
-	if (mode == THERMAL_DEVICE_ENABLED)
-		data->omap_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
-	else
-		data->omap_thermal->polling_delay = 0;
-
-	mutex_unlock(&data->omap_thermal->lock);
-
-	data->mode = mode;
-	thermal_zone_device_update(data->omap_thermal);
-	dev_dbg(&thermal->device, "thermal polling set for duration=%d msec\n",
-		data->omap_thermal->polling_delay);
-
-	return 0;
-}
-
-/* Get trip type callback functions for thermal zone */
-static int omap_thermal_get_trip_type(struct thermal_zone_device *thermal,
-				       int trip, enum thermal_trip_type *type)
-{
-	if (!omap_thermal_is_valid_trip(trip))
-		return -EINVAL;
-
-	if (trip + 1 == OMAP_TRIP_NUMBER)
-		*type = THERMAL_TRIP_CRITICAL;
-	else
-		*type = THERMAL_TRIP_PASSIVE;
-
-	return 0;
-}
-
-/* Get trip temperature callback functions for thermal zone */
-static int omap_thermal_get_trip_temp(struct thermal_zone_device *thermal,
-				       int trip, unsigned long *temp)
-{
-	if (!omap_thermal_is_valid_trip(trip))
-		return -EINVAL;
-
-	*temp = omap_thermal_get_trip_value(trip);
-
-	return 0;
-}
-
-/* Get critical temperature callback functions for thermal zone */
-static int omap_thermal_get_crit_temp(struct thermal_zone_device *thermal,
-				       unsigned long *temp)
-{
-	/* shutdown zone */
-	return omap_thermal_get_trip_temp(thermal, OMAP_TRIP_NUMBER - 1, temp);
-}
-
-static struct thermal_zone_device_ops omap_thermal_ops = {
-	.get_temp = omap_thermal_get_temp,
-	/* TODO: add .get_trend */
-	.bind = omap_thermal_bind,
-	.unbind = omap_thermal_unbind,
-	.get_mode = omap_thermal_get_mode,
-	.set_mode = omap_thermal_set_mode,
-	.get_trip_type = omap_thermal_get_trip_type,
-	.get_trip_temp = omap_thermal_get_trip_temp,
-	.get_crit_temp = omap_thermal_get_crit_temp,
-};
-
-static struct omap_thermal_data
-*omap_thermal_build_data(struct omap_bandgap *bg_ptr, int id)
-{
-	struct omap_thermal_data *data;
-
-	data = devm_kzalloc(bg_ptr->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(bg_ptr->dev, "kzalloc fail\n");
-		return NULL;
-	}
-	data->sensor_id = id;
-	data->bg_ptr = bg_ptr;
-	data->mode = THERMAL_DEVICE_ENABLED;
-	INIT_WORK(&data->thermal_wq, omap_thermal_work);
-
-	return data;
-}
-
-int omap_thermal_expose_sensor(struct omap_bandgap *bg_ptr, int id,
-			       char *domain)
-{
-	struct omap_thermal_data *data;
-
-	data = omap_bandgap_get_sensor_data(bg_ptr, id);
-
-	if (IS_ERR_OR_NULL(data))
-		data = omap_thermal_build_data(bg_ptr, id);
-
-	if (!data)
-		return -EINVAL;
-
-	/* TODO: remove TC1 TC2 */
-	/* Create thermal zone */
-	data->omap_thermal = thermal_zone_device_register(domain,
-				OMAP_TRIP_NUMBER, 0, data, &omap_thermal_ops,
-				NULL, FAST_TEMP_MONITORING_RATE,
-				FAST_TEMP_MONITORING_RATE);
-	if (IS_ERR_OR_NULL(data->omap_thermal)) {
-		dev_err(bg_ptr->dev, "thermal zone device is NULL\n");
-		return PTR_ERR(data->omap_thermal);
-	}
-	data->omap_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
-	omap_bandgap_set_sensor_data(bg_ptr, id, data);
-
-	return 0;
-}
-
-int omap_thermal_remove_sensor(struct omap_bandgap *bg_ptr, int id)
-{
-	struct omap_thermal_data *data;
-
-	data = omap_bandgap_get_sensor_data(bg_ptr, id);
-
-	thermal_zone_device_unregister(data->omap_thermal);
-
-	return 0;
-}
-
-int omap_thermal_report_sensor_temperature(struct omap_bandgap *bg_ptr, int id)
-{
-	struct omap_thermal_data *data;
-
-	data = omap_bandgap_get_sensor_data(bg_ptr, id);
-
-	schedule_work(&data->thermal_wq);
-
-	return 0;
-}
-
-int omap_thermal_register_cpu_cooling(struct omap_bandgap *bg_ptr, int id)
-{
-	struct omap_thermal_data *data;
-
-	data = omap_bandgap_get_sensor_data(bg_ptr, id);
-	if (IS_ERR_OR_NULL(data))
-		data = omap_thermal_build_data(bg_ptr, id);
-
-	if (!data)
-		return -EINVAL;
-
-	/* Register cooling device */
-	data->cool_dev = cpufreq_cooling_register(cpu_present_mask);
-	if (IS_ERR_OR_NULL(data->cool_dev)) {
-		dev_err(bg_ptr->dev,
-			"Failed to register cpufreq cooling device\n");
-		return PTR_ERR(data->cool_dev);
-	}
-	omap_bandgap_set_sensor_data(bg_ptr, id, data);
-
-	return 0;
-}
-
-int omap_thermal_unregister_cpu_cooling(struct omap_bandgap *bg_ptr, int id)
-{
-	struct omap_thermal_data *data;
-
-	data = omap_bandgap_get_sensor_data(bg_ptr, id);
-	cpufreq_cooling_unregister(data->cool_dev);
-
-	return 0;
-}
diff --git a/drivers/staging/omap-thermal/Kconfig b/drivers/staging/ti-soc-thermal/Kconfig
similarity index 82%
rename from drivers/staging/omap-thermal/Kconfig
rename to drivers/staging/ti-soc-thermal/Kconfig
index 52170bf..d97ad25 100644
--- a/drivers/staging/omap-thermal/Kconfig
+++ b/drivers/staging/ti-soc-thermal/Kconfig
@@ -1,5 +1,5 @@
-config OMAP_BANDGAP
-	tristate "Texas Instruments OMAP4+ temperature sensor driver"
+config TI_SOC_THERMAL
+	tristate "Texas Instruments SoCs temperature sensor driver"
 	depends on THERMAL
 	depends on ARCH_HAS_BANDGAP
 	help
@@ -10,9 +10,9 @@ config OMAP_BANDGAP
 	  This includes alert interrupts generation and also the TSHUT
 	  support.
 
-config OMAP_THERMAL
-	bool "Texas Instruments OMAP4+ thermal framework support"
-	depends on OMAP_BANDGAP
+config TI_THERMAL
+	bool "Texas Instruments SoCs thermal framework support"
+	depends on TI_SOC_THERMAL
 	depends on CPU_THERMAL
 	help
 	  If you say yes here you want to get support for generic thermal
@@ -21,7 +21,7 @@ config OMAP_THERMAL
 
 config OMAP4_THERMAL
 	bool "Texas Instruments OMAP4 thermal support"
-	depends on OMAP_BANDGAP
+	depends on TI_SOC_THERMAL
 	depends on ARCH_OMAP4
 	help
 	  If you say yes here you get thermal support for the Texas Instruments
@@ -35,7 +35,7 @@ config OMAP4_THERMAL
 
 config OMAP5_THERMAL
 	bool "Texas Instruments OMAP5 thermal support"
-	depends on OMAP_BANDGAP
+	depends on TI_SOC_THERMAL
 	depends on SOC_OMAP5
 	help
 	  If you say yes here you get thermal support for the Texas Instruments
diff --git a/drivers/staging/ti-soc-thermal/Makefile b/drivers/staging/ti-soc-thermal/Makefile
new file mode 100644
index 0000000..0ca034f
--- /dev/null
+++ b/drivers/staging/ti-soc-thermal/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_TI_SOC_THERMAL)		+= ti-soc-thermal.o
+ti-soc-thermal-y			:= ti-bandgap.o
+ti-soc-thermal-$(CONFIG_TI_THERMAL)	+= ti-thermal-common.o
+ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
+ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
diff --git a/drivers/staging/omap-thermal/TODO b/drivers/staging/ti-soc-thermal/TODO
similarity index 100%
rename from drivers/staging/omap-thermal/TODO
rename to drivers/staging/ti-soc-thermal/TODO
diff --git a/drivers/staging/omap-thermal/omap4-thermal-data.c b/drivers/staging/ti-soc-thermal/omap4-thermal-data.c
similarity index 85%
rename from drivers/staging/omap-thermal/omap4-thermal-data.c
rename to drivers/staging/ti-soc-thermal/omap4-thermal-data.c
index 88ed014..49d0324 100644
--- a/drivers/staging/omap-thermal/omap4-thermal-data.c
+++ b/drivers/staging/ti-soc-thermal/omap4-thermal-data.c
@@ -16,8 +16,8 @@
  *
  */
 
-#include "omap-thermal.h"
-#include "omap-bandgap.h"
+#include "ti-thermal.h"
+#include "ti-bandgap.h"
 #include "omap4xxx-bandgap.h"
 
 /*
@@ -66,17 +66,17 @@ omap4430_adc_to_temp[OMAP4430_ADC_END_VALUE - OMAP4430_ADC_START_VALUE + 1] = {
 };
 
 /* OMAP4430 data */
-const struct omap_bandgap_data omap4430_data = {
-	.features = OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH,
+const struct ti_bandgap_data omap4430_data = {
+	.features = TI_BANDGAP_FEATURE_MODE_CONFIG |
+			TI_BANDGAP_FEATURE_CLK_CTRL |
+			TI_BANDGAP_FEATURE_POWER_SWITCH,
 	.fclock_name = "bandgap_fclk",
 	.div_ck_name = "bandgap_fclk",
 	.conv_table = omap4430_adc_to_temp,
 	.adc_start_val = OMAP4430_ADC_START_VALUE,
 	.adc_end_val = OMAP4430_ADC_END_VALUE,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
 	.sensors = {
 		{
 		.registers = &omap4430_mpu_temp_sensor_registers,
@@ -86,8 +86,8 @@ const struct omap_bandgap_data omap4430_data = {
 		.constant = 20000,
 		.slope_pcb = 0,
 		.constant_pcb = 20000,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.register_cooling = ti_thermal_register_cpu_cooling,
+		.unregister_cooling = ti_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
@@ -201,21 +201,21 @@ omap4460_adc_to_temp[OMAP4460_ADC_END_VALUE - OMAP4460_ADC_START_VALUE + 1] = {
 };
 
 /* OMAP4460 data */
-const struct omap_bandgap_data omap4460_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT |
-			OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_TALERT |
-			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_COUNTER,
+const struct ti_bandgap_data omap4460_data = {
+	.features = TI_BANDGAP_FEATURE_TSHUT |
+			TI_BANDGAP_FEATURE_TSHUT_CONFIG |
+			TI_BANDGAP_FEATURE_TALERT |
+			TI_BANDGAP_FEATURE_MODE_CONFIG |
+			TI_BANDGAP_FEATURE_POWER_SWITCH |
+			TI_BANDGAP_FEATURE_CLK_CTRL |
+			TI_BANDGAP_FEATURE_COUNTER,
 	.fclock_name = "bandgap_ts_fclk",
 	.div_ck_name = "div_ts_ck",
 	.conv_table = omap4460_adc_to_temp,
 	.adc_start_val = OMAP4460_ADC_START_VALUE,
 	.adc_end_val = OMAP4460_ADC_END_VALUE,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
 	.sensors = {
 		{
 		.registers = &omap4460_mpu_temp_sensor_registers,
@@ -225,29 +225,29 @@ const struct omap_bandgap_data omap4460_data = {
 		.constant = OMAP_GRADIENT_CONST_4460,
 		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4460,
 		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4460,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.register_cooling = ti_thermal_register_cpu_cooling,
+		.unregister_cooling = ti_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
 };
 
 /* OMAP4470 data */
-const struct omap_bandgap_data omap4470_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT |
-			OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_TALERT |
-			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_COUNTER,
+const struct ti_bandgap_data omap4470_data = {
+	.features = TI_BANDGAP_FEATURE_TSHUT |
+			TI_BANDGAP_FEATURE_TSHUT_CONFIG |
+			TI_BANDGAP_FEATURE_TALERT |
+			TI_BANDGAP_FEATURE_MODE_CONFIG |
+			TI_BANDGAP_FEATURE_POWER_SWITCH |
+			TI_BANDGAP_FEATURE_CLK_CTRL |
+			TI_BANDGAP_FEATURE_COUNTER,
 	.fclock_name = "bandgap_ts_fclk",
 	.div_ck_name = "div_ts_ck",
 	.conv_table = omap4460_adc_to_temp,
 	.adc_start_val = OMAP4460_ADC_START_VALUE,
 	.adc_end_val = OMAP4460_ADC_END_VALUE,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
 	.sensors = {
 		{
 		.registers = &omap4460_mpu_temp_sensor_registers,
@@ -257,8 +257,8 @@ const struct omap_bandgap_data omap4470_data = {
 		.constant = OMAP_GRADIENT_CONST_4470,
 		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4470,
 		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4470,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.register_cooling = ti_thermal_register_cpu_cooling,
+		.unregister_cooling = ti_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
diff --git a/drivers/staging/omap-thermal/omap4xxx-bandgap.h b/drivers/staging/ti-soc-thermal/omap4xxx-bandgap.h
similarity index 100%
rename from drivers/staging/omap-thermal/omap4xxx-bandgap.h
rename to drivers/staging/ti-soc-thermal/omap4xxx-bandgap.h
diff --git a/drivers/staging/omap-thermal/omap5-thermal-data.c b/drivers/staging/ti-soc-thermal/omap5-thermal-data.c
similarity index 96%
rename from drivers/staging/omap-thermal/omap5-thermal-data.c
rename to drivers/staging/ti-soc-thermal/omap5-thermal-data.c
index a48c286..0afe9c8 100644
--- a/drivers/staging/omap-thermal/omap5-thermal-data.c
+++ b/drivers/staging/ti-soc-thermal/omap5-thermal-data.c
@@ -16,9 +16,9 @@
  *
  */
 
-#include "omap-bandgap.h"
+#include "ti-thermal.h"
+#include "ti-bandgap.h"
 #include "omap5xxx-bandgap.h"
-#include "omap-thermal.h"
 
 /*
  * OMAP5430 has three instances of thermal sensor for MPU, GPU & CORE,
@@ -312,24 +312,24 @@ omap5430_adc_to_temp[
 
 /* OMAP54xx ES2.0 data */
 /* TODO : Need to update the slope/constant for ES2.0 silicon */
-const struct omap_bandgap_data omap5430_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_FREEZE_BIT |
-			OMAP_BANDGAP_FEATURE_TALERT,
+const struct ti_bandgap_data omap5430_data = {
+	.features = TI_BANDGAP_FEATURE_TSHUT_CONFIG |
+			TI_BANDGAP_FEATURE_FREEZE_BIT |
+			TI_BANDGAP_FEATURE_TALERT,
 	.fclock_name = "l3instr_ts_gclk_div",
 	.div_ck_name = "l3instr_ts_gclk_div",
 	.conv_table = omap5430_adc_to_temp,
 	.adc_start_val = OMAP5430_ADC_START_VALUE,
 	.adc_end_val = OMAP5430_ADC_END_VALUE,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
 	.sensors = {
 		{
 		.registers = &omap5430_mpu_temp_sensor_registers,
 		.ts_data = &omap5430_mpu_temp_sensor_data,
 		.domain = "cpu",
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.register_cooling = ti_thermal_register_cpu_cooling,
+		.unregister_cooling = ti_thermal_unregister_cpu_cooling,
 		.slope = OMAP_GRADIENT_SLOPE_5430_CPU,
 		.constant = OMAP_GRADIENT_CONST_5430_CPU,
 		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_CPU,
diff --git a/drivers/staging/omap-thermal/omap5xxx-bandgap.h b/drivers/staging/ti-soc-thermal/omap5xxx-bandgap.h
similarity index 100%
rename from drivers/staging/omap-thermal/omap5xxx-bandgap.h
rename to drivers/staging/ti-soc-thermal/omap5xxx-bandgap.h
diff --git a/drivers/staging/omap-thermal/omap_bandgap.txt b/drivers/staging/ti-soc-thermal/omap_bandgap.txt
similarity index 100%
rename from drivers/staging/omap-thermal/omap_bandgap.txt
rename to drivers/staging/ti-soc-thermal/omap_bandgap.txt
diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
similarity index 67%
rename from drivers/staging/omap-thermal/omap-bandgap.c
rename to drivers/staging/ti-soc-thermal/ti-bandgap.c
index 89361fe..6a0b1ac 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -1,5 +1,5 @@
 /*
- * OMAP4 Bandgap temperature sensor driver
+ * TI Bandgap temperature sensor driver
  *
  * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
  * Author: J Keerthy <j-keerthy@ti.com>
@@ -40,32 +40,32 @@
 #include <linux/of_irq.h>
 #include <linux/io.h>
 
-#include "omap-bandgap.h"
+#include "ti-bandgap.h"
 
 /***   Helper functions to access registers and their bitfields   ***/
 
 /**
- * omap_bandgap_readl() - simple read helper function
- * @bgp: pointer to omap_bandgap structure
+ * ti_bandgap_readl() - simple read helper function
+ * @bgp: pointer to ti_bandgap structure
  * @reg: desired register (offset) to be read
  *
  * Helper function to read bandgap registers. It uses the io remapped area.
  * Returns the register value.
  */
-static u32 omap_bandgap_readl(struct omap_bandgap *bgp, u32 reg)
+static u32 ti_bandgap_readl(struct ti_bandgap *bgp, u32 reg)
 {
 	return readl(bgp->base + reg);
 }
 
 /**
- * omap_bandgap_writel() - simple write helper function
- * @bgp: pointer to omap_bandgap structure
+ * ti_bandgap_writel() - simple write helper function
+ * @bgp: pointer to ti_bandgap structure
  * @val: desired register value to be written
  * @reg: desired register (offset) to be written
  *
  * Helper function to write bandgap registers. It uses the io remapped area.
  */
-static void omap_bandgap_writel(struct omap_bandgap *bgp, u32 val, u32 reg)
+static void ti_bandgap_writel(struct ti_bandgap *bgp, u32 val, u32 reg)
 {
 	writel(val, bgp->base + reg);
 }
@@ -82,27 +82,27 @@ do {								\
 	u32 r;							\
 								\
 	t = bgp->conf->sensors[(id)].registers;		\
-	r = omap_bandgap_readl(bgp, t->reg);			\
+	r = ti_bandgap_readl(bgp, t->reg);			\
 	r &= ~t->mask;						\
 	r |= (val) << __ffs(t->mask);				\
-	omap_bandgap_writel(bgp, r, t->reg);			\
+	ti_bandgap_writel(bgp, r, t->reg);			\
 } while (0)
 
 /***   Basic helper functions   ***/
 
 /**
- * omap_bandgap_power() - controls the power state of a bandgap device
- * @bgp: pointer to omap_bandgap structure
+ * ti_bandgap_power() - controls the power state of a bandgap device
+ * @bgp: pointer to ti_bandgap structure
  * @on: desired power state (1 - on, 0 - off)
  *
  * Used to power on/off a bandgap device instance. Only used on those
  * that features tempsoff bit.
  */
-static int omap_bandgap_power(struct omap_bandgap *bgp, bool on)
+static int ti_bandgap_power(struct ti_bandgap *bgp, bool on)
 {
 	int i;
 
-	if (!OMAP_BANDGAP_HAS(bgp, POWER_SWITCH))
+	if (!TI_BANDGAP_HAS(bgp, POWER_SWITCH))
 		goto exit;
 
 	for (i = 0; i < bgp->conf->sensor_count; i++)
@@ -114,8 +114,8 @@ exit:
 }
 
 /**
- * omap_bandgap_read_temp() - helper function to read sensor temperature
- * @bgp: pointer to omap_bandgap structure
+ * ti_bandgap_read_temp() - helper function to read sensor temperature
+ * @bgp: pointer to ti_bandgap structure
  * @id: bandgap sensor id
  *
  * Function to concentrate the steps to read sensor temperature register.
@@ -123,7 +123,7 @@ exit:
  * it might be needed to freeze the bandgap state machine, before fetching
  * the register value.
  */
-static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
+static u32 ti_bandgap_read_temp(struct ti_bandgap *bgp, int id)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, reg;
@@ -131,7 +131,7 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
 	tsr = bgp->conf->sensors[id].registers;
 	reg = tsr->temp_sensor_ctrl;
 
-	if (OMAP_BANDGAP_HAS(bgp, FREEZE_BIT)) {
+	if (TI_BANDGAP_HAS(bgp, FREEZE_BIT)) {
 		RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 1);
 		/*
 		 * In case we cannot read from cur_dtemp / dtemp_0,
@@ -141,10 +141,10 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
 	}
 
 	/* read temperature */
-	temp = omap_bandgap_readl(bgp, reg);
+	temp = ti_bandgap_readl(bgp, reg);
 	temp &= tsr->bgap_dtemp_mask;
 
-	if (OMAP_BANDGAP_HAS(bgp, FREEZE_BIT))
+	if (TI_BANDGAP_HAS(bgp, FREEZE_BIT))
 		RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 0);
 
 	return temp;
@@ -153,9 +153,9 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
 /***   IRQ handlers   ***/
 
 /**
- * omap_bandgap_talert_irq_handler() - handles Temperature alert IRQs
+ * ti_bandgap_talert_irq_handler() - handles Temperature alert IRQs
  * @irq: IRQ number
- * @data: private data (struct omap_bandgap *)
+ * @data: private data (struct ti_bandgap *)
  *
  * This is the Talert handler. Use it only if bandgap device features
  * HAS(TALERT). This handler goes over all sensors and checks their
@@ -163,9 +163,9 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
  * it will reset the event mask to wait for the opposite event (next event).
  * Every time there is a new event, it will be reported to thermal layer.
  */
-static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
+static irqreturn_t ti_bandgap_talert_irq_handler(int irq, void *data)
 {
-	struct omap_bandgap *bgp = data;
+	struct ti_bandgap *bgp = data;
 	struct temp_sensor_registers *tsr;
 	u32 t_hot = 0, t_cold = 0, ctrl;
 	unsigned long flags;
@@ -174,7 +174,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 	spin_lock_irqsave(&bgp->lock, flags);
 	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		tsr = bgp->conf->sensors[i].registers;
-		ctrl = omap_bandgap_readl(bgp, tsr->bgap_status);
+		ctrl = ti_bandgap_readl(bgp, tsr->bgap_status);
 
 		/* Read the status of t_hot */
 		t_hot = ctrl & tsr->status_hot_mask;
@@ -185,7 +185,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 		if (!t_cold && !t_hot)
 			continue;
 
-		ctrl = omap_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
+		ctrl = ti_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
 		/*
 		 * One TALERT interrupt: Two sources
 		 * If the interrupt is due to t_hot then mask t_hot and
@@ -199,7 +199,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 			ctrl |= tsr->mask_hot_mask;
 		}
 
-		omap_bandgap_writel(bgp, ctrl, tsr->bgap_mask_ctrl);
+		ti_bandgap_writel(bgp, ctrl, tsr->bgap_mask_ctrl);
 
 		dev_dbg(bgp->dev,
 			"%s: IRQ from %s sensor: hotevent %d coldevent %d\n",
@@ -216,7 +216,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 }
 
 /**
- * omap_bandgap_tshut_irq_handler() - handles Temperature shutdown signal
+ * ti_bandgap_tshut_irq_handler() - handles Temperature shutdown signal
  * @irq: IRQ number
  * @data: private data (unused)
  *
@@ -224,7 +224,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
  * HAS(TSHUT). If any sensor fires the Tshut signal, we simply shutdown
  * the system.
  */
-static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
+static irqreturn_t ti_bandgap_tshut_irq_handler(int irq, void *data)
 {
 	pr_emerg("%s: TSHUT temperature reached. Needs shut down...\n",
 		 __func__);
@@ -237,8 +237,8 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
 /***   Helper functions which manipulate conversion ADC <-> mi Celsius   ***/
 
 /**
- * omap_bandgap_adc_to_mcelsius() - converts an ADC value to mCelsius scale
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_adc_to_mcelsius() - converts an ADC value to mCelsius scale
+ * @bgp: struct ti_bandgap pointer
  * @adc_val: value in ADC representation
  * @t: address where to write the resulting temperature in mCelsius
  *
@@ -247,10 +247,9 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
  * The conversion table is indexed by the ADC values.
  */
 static
-int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bgp,
-				 int adc_val, int *t)
+int ti_bandgap_adc_to_mcelsius(struct ti_bandgap *bgp, int adc_val, int *t)
 {
-	struct omap_bandgap_data *conf = bgp->conf;
+	struct ti_bandgap_data *conf = bgp->conf;
 	int ret = 0;
 
 	/* look up for temperature in the table and return the temperature */
@@ -266,8 +265,8 @@ exit:
 }
 
 /**
- * omap_bandgap_mcelsius_to_adc() - converts a mCelsius value to ADC scale
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_mcelsius_to_adc() - converts a mCelsius value to ADC scale
+ * @bgp: struct ti_bandgap pointer
  * @temp: value in mCelsius
  * @adc: address where to write the resulting temperature in ADC representation
  *
@@ -276,10 +275,9 @@ exit:
  * The conversion table is indexed by the ADC values.
  */
 static
-int omap_bandgap_mcelsius_to_adc(struct omap_bandgap *bgp, long temp,
-				 int *adc)
+int ti_bandgap_mcelsius_to_adc(struct ti_bandgap *bgp, long temp, int *adc)
 {
-	struct omap_bandgap_data *conf = bgp->conf;
+	struct ti_bandgap_data *conf = bgp->conf;
 	const int *conv_table = bgp->conf->conv_table;
 	int high, low, mid, ret = 0;
 
@@ -307,8 +305,8 @@ exit:
 }
 
 /**
- * omap_bandgap_add_hyst() - add hysteresis (in mCelsius) to an ADC value
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_add_hyst() - add hysteresis (in mCelsius) to an ADC value
+ * @bgp: struct ti_bandgap pointer
  * @adc_val: temperature value in ADC representation
  * @hyst_val: hysteresis value in mCelsius
  * @sum: address where to write the resulting temperature (in ADC scale)
@@ -317,8 +315,8 @@ exit:
  * Returns 0 on success, -ERANGE otherwise.
  */
 static
-int omap_bandgap_add_hyst(struct omap_bandgap *bgp, int adc_val,
-			  int hyst_val, u32 *sum)
+int ti_bandgap_add_hyst(struct ti_bandgap *bgp, int adc_val,
+			int hyst_val, u32 *sum)
 {
 	int temp, ret;
 
@@ -326,13 +324,13 @@ int omap_bandgap_add_hyst(struct omap_bandgap *bgp, int adc_val,
 	 * Need to add in the mcelsius domain, so we have a temperature
 	 * the conv_table range
 	 */
-	ret = omap_bandgap_adc_to_mcelsius(bgp, adc_val, &temp);
+	ret = ti_bandgap_adc_to_mcelsius(bgp, adc_val, &temp);
 	if (ret < 0)
 		goto exit;
 
 	temp += hyst_val;
 
-	ret = omap_bandgap_mcelsius_to_adc(bgp, temp, sum);
+	ret = ti_bandgap_mcelsius_to_adc(bgp, temp, sum);
 
 exit:
 	return ret;
@@ -341,25 +339,25 @@ exit:
 /***   Helper functions handling device Alert/Shutdown signals   ***/
 
 /**
- * omap_bandgap_unmask_interrupts() - unmasks the events of thot & tcold
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_unmask_interrupts() - unmasks the events of thot & tcold
+ * @bgp: struct ti_bandgap pointer
  * @t_hot: hot temperature value to trigger alert signal
  * @t_cold: cold temperature value to trigger alert signal
  *
  * Checks the requested t_hot and t_cold values and configures the IRQ event
  * masks accordingly. Call this function only if bandgap features HAS(TALERT).
  */
-static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bgp, int id,
-					   u32 t_hot, u32 t_cold)
+static void ti_bandgap_unmask_interrupts(struct ti_bandgap *bgp, int id,
+					 u32 t_hot, u32 t_cold)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, reg_val;
 
 	/* Read the current on die temperature */
-	temp = omap_bandgap_read_temp(bgp, id);
+	temp = ti_bandgap_read_temp(bgp, id);
 
 	tsr = bgp->conf->sensors[id].registers;
-	reg_val = omap_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
+	reg_val = ti_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
 
 	if (temp < t_hot)
 		reg_val |= tsr->mask_hot_mask;
@@ -370,12 +368,12 @@ static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bgp, int id,
 		reg_val |= tsr->mask_cold_mask;
 	else
 		reg_val &= ~tsr->mask_cold_mask;
-	omap_bandgap_writel(bgp, reg_val, tsr->bgap_mask_ctrl);
+	ti_bandgap_writel(bgp, reg_val, tsr->bgap_mask_ctrl);
 }
 
 /**
- * omap_bandgap_update_alert_threshold() - sequence to update thresholds
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_update_alert_threshold() - sequence to update thresholds
+ * @bgp: struct ti_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (ADC) of a new threshold
  * @hot: desired threshold to be updated. true if threshold hot, false if
@@ -388,7 +386,7 @@ static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bgp, int id,
  * Call this function only if bandgap features HAS(TALERT).
  */
 static
-int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
+int ti_bandgap_update_alert_threshold(struct ti_bandgap *bgp, int id,
 					int val, bool hot)
 {
 	struct temp_sensor_data *ts_data = bgp->conf->sensors[id].ts_data;
@@ -399,7 +397,7 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 	tsr = bgp->conf->sensors[id].registers;
 
 	/* obtain the current value */
-	thresh_val = omap_bandgap_readl(bgp, tsr->bgap_threshold);
+	thresh_val = ti_bandgap_readl(bgp, tsr->bgap_threshold);
 	t_cold = (thresh_val & tsr->threshold_tcold_mask) >>
 		__ffs(tsr->threshold_tcold_mask);
 	t_hot = (thresh_val & tsr->threshold_thot_mask) >>
@@ -411,13 +409,13 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 
 	if (t_cold < t_hot) {
 		if (hot)
-			err = omap_bandgap_add_hyst(bgp, t_hot,
-						    -ts_data->hyst_val,
-						    &t_cold);
+			err = ti_bandgap_add_hyst(bgp, t_hot,
+						  -ts_data->hyst_val,
+						  &t_cold);
 		else
-			err = omap_bandgap_add_hyst(bgp, t_cold,
-						    ts_data->hyst_val,
-						    &t_hot);
+			err = ti_bandgap_add_hyst(bgp, t_cold,
+						  ts_data->hyst_val,
+						  &t_hot);
 	}
 
 	/* write the new threshold values */
@@ -425,7 +423,7 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 	reg_val |= (t_hot << __ffs(tsr->threshold_thot_mask));
 	reg_val |= thresh_val & ~tsr->threshold_tcold_mask;
 	reg_val |= (t_cold << __ffs(tsr->threshold_tcold_mask));
-	omap_bandgap_writel(bgp, reg_val, tsr->bgap_threshold);
+	ti_bandgap_writel(bgp, reg_val, tsr->bgap_threshold);
 
 	if (err) {
 		dev_err(bgp->dev, "failed to reprogram thot threshold\n");
@@ -433,20 +431,20 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 		goto exit;
 	}
 
-	omap_bandgap_unmask_interrupts(bgp, id, t_hot, t_cold);
+	ti_bandgap_unmask_interrupts(bgp, id, t_hot, t_cold);
 exit:
 	return err;
 }
 
 /**
- * omap_bandgap_validate() - helper to check the sanity of a struct omap_bandgap
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_validate() - helper to check the sanity of a struct ti_bandgap
+ * @bgp: struct ti_bandgap pointer
  * @id: bandgap sensor id
  *
  * Checks if the bandgap pointer is valid and if the sensor id is also
  * applicable.
  */
-static inline int omap_bandgap_validate(struct omap_bandgap *bgp, int id)
+static inline int ti_bandgap_validate(struct ti_bandgap *bgp, int id)
 {
 	int ret = 0;
 
@@ -467,8 +465,8 @@ exit:
 }
 
 /**
- * _omap_bandgap_write_threshold() - helper to update TALERT t_cold or t_hot
- * @bgp: struct omap_bandgap pointer
+ * _ti_bandgap_write_threshold() - helper to update TALERT t_cold or t_hot
+ * @bgp: struct ti_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (mCelsius) of a new threshold
  * @hot: desired threshold to be updated. true if threshold hot, false if
@@ -479,19 +477,19 @@ exit:
  * Validates the mCelsius range and update the requested threshold.
  * Call this function only if bandgap features HAS(TALERT).
  */
-int _omap_bandgap_write_threshold(struct omap_bandgap *bgp, int id, int val,
-				  bool hot)
+int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
+				bool hot)
 {
 	struct temp_sensor_data *ts_data;
 	struct temp_sensor_registers *tsr;
 	u32 adc_val;
 	int ret;
 
-	ret = omap_bandgap_validate(bgp, id);
+	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		goto exit;
 
-	if (!OMAP_BANDGAP_HAS(bgp, TALERT)) {
+	if (!TI_BANDGAP_HAS(bgp, TALERT)) {
 		ret = -ENOTSUPP;
 		goto exit;
 	}
@@ -509,12 +507,12 @@ int _omap_bandgap_write_threshold(struct omap_bandgap *bgp, int id, int val,
 	if (ret)
 		goto exit;
 
-	ret = omap_bandgap_mcelsius_to_adc(bgp, val, &adc_val);
+	ret = ti_bandgap_mcelsius_to_adc(bgp, val, &adc_val);
 	if (ret < 0)
 		goto exit;
 
 	spin_lock(&bgp->lock);
-	omap_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
+	ti_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
 	spin_unlock(&bgp->lock);
 
 exit:
@@ -522,8 +520,8 @@ exit:
 }
 
 /**
- * _omap_bandgap_read_threshold() - helper to read TALERT t_cold or t_hot
- * @bgp: struct omap_bandgap pointer
+ * _ti_bandgap_read_threshold() - helper to read TALERT t_cold or t_hot
+ * @bgp: struct ti_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (mCelsius) of a threshold
  * @hot: desired threshold to be read. true if threshold hot, false if
@@ -533,18 +531,18 @@ exit:
  * This function can be used to read t_hot or t_cold, depending on @hot value.
  * Call this function only if bandgap features HAS(TALERT).
  */
-int _omap_bandgap_read_threshold(struct omap_bandgap *bgp, int id,
-				 int *val, bool hot)
+int _ti_bandgap_read_threshold(struct ti_bandgap *bgp, int id, int *val,
+			       bool hot)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, mask;
 	int ret = 0;
 
-	ret = omap_bandgap_validate(bgp, id);
+	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		goto exit;
 
-	if (!OMAP_BANDGAP_HAS(bgp, TALERT)) {
+	if (!TI_BANDGAP_HAS(bgp, TALERT)) {
 		ret = -ENOTSUPP;
 		goto exit;
 	}
@@ -555,9 +553,9 @@ int _omap_bandgap_read_threshold(struct omap_bandgap *bgp, int id,
 	else
 		mask = tsr->threshold_tcold_mask;
 
-	temp = omap_bandgap_readl(bgp, tsr->bgap_threshold);
+	temp = ti_bandgap_readl(bgp, tsr->bgap_threshold);
 	temp = (temp & mask) >> __ffs(mask);
-	ret |= omap_bandgap_adc_to_mcelsius(bgp, temp, &temp);
+	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret) {
 		dev_err(bgp->dev, "failed to read thot\n");
 		ret = -EIO;
@@ -573,83 +571,81 @@ exit:
 /***   Exposed APIs   ***/
 
 /**
- * omap_bandgap_read_thot() - reads sensor current thot
+ * ti_bandgap_read_thot() - reads sensor current thot
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @thot - resulting current thot value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_thot(struct omap_bandgap *bgp, int id,
-			   int *thot)
+int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot)
 {
-	return _omap_bandgap_read_threshold(bgp, id, thot, true);
+	return _ti_bandgap_read_threshold(bgp, id, thot, true);
 }
 
 /**
- * omap_bandgap_write_thot() - sets sensor current thot
+ * ti_bandgap_write_thot() - sets sensor current thot
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @val - desired thot value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_thot(struct omap_bandgap *bgp, int id, int val)
+int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val)
 {
-	return _omap_bandgap_write_threshold(bgp, id, val, true);
+	return _ti_bandgap_write_threshold(bgp, id, val, true);
 }
 
 /**
- * omap_bandgap_read_tcold() - reads sensor current tcold
+ * ti_bandgap_read_tcold() - reads sensor current tcold
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @tcold - resulting current tcold value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_tcold(struct omap_bandgap *bgp, int id,
-			    int *tcold)
+int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold)
 {
-	return _omap_bandgap_read_threshold(bgp, id, tcold, false);
+	return _ti_bandgap_read_threshold(bgp, id, tcold, false);
 }
 
 /**
- * omap_bandgap_write_tcold() - sets the sensor tcold
+ * ti_bandgap_write_tcold() - sets the sensor tcold
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @val - desired tcold value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_tcold(struct omap_bandgap *bgp, int id, int val)
+int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val)
 {
-	return _omap_bandgap_write_threshold(bgp, id, val, false);
+	return _ti_bandgap_write_threshold(bgp, id, val, false);
 }
 
 /**
- * omap_bandgap_read_update_interval() - read the sensor update interval
+ * ti_bandgap_read_update_interval() - read the sensor update interval
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @interval - resulting update interval in miliseconds
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_update_interval(struct omap_bandgap *bgp, int id,
-					 int *interval)
+int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
+				    int *interval)
 {
 	struct temp_sensor_registers *tsr;
 	u32 time;
 	int ret;
 
-	ret = omap_bandgap_validate(bgp, id);
+	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
-	if (!OMAP_BANDGAP_HAS(bgp, COUNTER))
+	if (!TI_BANDGAP_HAS(bgp, COUNTER))
 		return -ENOTSUPP;
 
 	tsr = bgp->conf->sensors[id].registers;
-	time = omap_bandgap_readl(bgp, tsr->bgap_counter);
+	time = ti_bandgap_readl(bgp, tsr->bgap_counter);
 	time = (time & tsr->counter_mask) >> __ffs(tsr->counter_mask);
 	time = time * 1000 / bgp->clk_rate;
 
@@ -659,21 +655,21 @@ int omap_bandgap_read_update_interval(struct omap_bandgap *bgp, int id,
 }
 
 /**
- * omap_bandgap_write_update_interval() - set the update interval
+ * ti_bandgap_write_update_interval() - set the update interval
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @interval - desired update interval in miliseconds
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_update_interval(struct omap_bandgap *bgp,
-				       int id, u32 interval)
+int ti_bandgap_write_update_interval(struct ti_bandgap *bgp,
+				     int id, u32 interval)
 {
-	int ret = omap_bandgap_validate(bgp, id);
+	int ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
-	if (!OMAP_BANDGAP_HAS(bgp, COUNTER))
+	if (!TI_BANDGAP_HAS(bgp, COUNTER))
 		return -ENOTSUPP;
 
 	interval = interval * bgp->clk_rate / 1000;
@@ -685,28 +681,28 @@ int omap_bandgap_write_update_interval(struct omap_bandgap *bgp,
 }
 
 /**
- * omap_bandgap_read_temperature() - report current temperature
+ * ti_bandgap_read_temperature() - report current temperature
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @temperature - resulting temperature
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_temperature(struct omap_bandgap *bgp, int id,
-				  int *temperature)
+int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
+				int *temperature)
 {
 	u32 temp;
 	int ret;
 
-	ret = omap_bandgap_validate(bgp, id);
+	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
 	spin_lock(&bgp->lock);
-	temp = omap_bandgap_read_temp(bgp, id);
+	temp = ti_bandgap_read_temp(bgp, id);
 	spin_unlock(&bgp->lock);
 
-	ret |= omap_bandgap_adc_to_mcelsius(bgp, temp, &temp);
+	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret)
 		return -EIO;
 
@@ -716,7 +712,7 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bgp, int id,
 }
 
 /**
- * omap_bandgap_set_sensor_data() - helper function to store thermal
+ * ti_bandgap_set_sensor_data() - helper function to store thermal
  * framework related data.
  * @bgp - pointer to bandgap instance
  * @id - sensor id
@@ -724,10 +720,9 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bgp, int id,
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_set_sensor_data(struct omap_bandgap *bgp, int id,
-				 void *data)
+int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
 {
-	int ret = omap_bandgap_validate(bgp, id);
+	int ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
@@ -737,16 +732,16 @@ int omap_bandgap_set_sensor_data(struct omap_bandgap *bgp, int id,
 }
 
 /**
- * omap_bandgap_get_sensor_data() - helper function to get thermal
+ * ti_bandgap_get_sensor_data() - helper function to get thermal
  * framework related data.
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  *
  * returns data stored by set function with sensor id on success or NULL
  */
-void *omap_bandgap_get_sensor_data(struct omap_bandgap *bgp, int id)
+void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
 {
-	int ret = omap_bandgap_validate(bgp, id);
+	int ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -756,29 +751,29 @@ void *omap_bandgap_get_sensor_data(struct omap_bandgap *bgp, int id)
 /***   Helper functions used during device initialization   ***/
 
 /**
- * omap_bandgap_force_single_read() - executes 1 single ADC conversion
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_force_single_read() - executes 1 single ADC conversion
+ * @bgp: pointer to struct ti_bandgap
  * @id: sensor id which it is desired to read 1 temperature
  *
  * Used to initialize the conversion state machine and set it to a valid
  * state. Called during device initialization and context restore events.
  */
 static int
-omap_bandgap_force_single_read(struct omap_bandgap *bgp, int id)
+ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id)
 {
 	u32 temp = 0, counter = 1000;
 
 	/* Select single conversion mode */
-	if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
+	if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
 		RMW_BITS(bgp, id, bgap_mode_ctrl, mode_ctrl_mask, 0);
 
 	/* Start of Conversion = 1 */
 	RMW_BITS(bgp, id, temp_sensor_ctrl, bgap_soc_mask, 1);
 	/* Wait until DTEMP is updated */
-	temp = omap_bandgap_read_temp(bgp, id);
+	temp = ti_bandgap_read_temp(bgp, id);
 
 	while ((temp == 0) && --counter)
-		temp = omap_bandgap_read_temp(bgp, id);
+		temp = ti_bandgap_read_temp(bgp, id);
 	/* REVISIT: Check correct condition for end of conversion */
 
 	/* Start of Conversion = 0 */
@@ -788,21 +783,21 @@ omap_bandgap_force_single_read(struct omap_bandgap *bgp, int id)
 }
 
 /**
- * omap_bandgap_set_continous_mode() - One time enabling of continuous mode
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_set_continous_mode() - One time enabling of continuous mode
+ * @bgp: pointer to struct ti_bandgap
  *
  * Call this function only if HAS(MODE_CONFIG) is set. As this driver may
  * be used for junction temperature monitoring, it is desirable that the
  * sensors are operational all the time, so that alerts are generated
  * properly.
  */
-static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bgp)
+static int ti_bandgap_set_continuous_mode(struct ti_bandgap *bgp)
 {
 	int i;
 
 	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		/* Perform a single read just before enabling continuous */
-		omap_bandgap_force_single_read(bgp, i);
+		ti_bandgap_force_single_read(bgp, i);
 		RMW_BITS(bgp, i, bgap_mode_ctrl, mode_ctrl_mask, 1);
 	}
 
@@ -810,8 +805,8 @@ static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bgp)
 }
 
 /**
- * omap_bandgap_tshut_init() - setup and initialize tshut handling
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_tshut_init() - setup and initialize tshut handling
+ * @bgp: pointer to struct ti_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Call this function only in case the bandgap features HAS(TSHUT).
@@ -821,8 +816,8 @@ static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bgp)
  * one of the bandgap sensors violates the TSHUT high/hot threshold.
  * And in that case, the system must go off.
  */
-static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
-				   struct platform_device *pdev)
+static int ti_bandgap_tshut_init(struct ti_bandgap *bgp,
+				 struct platform_device *pdev)
 {
 	int gpio_nr = bgp->tshut_gpio;
 	int status;
@@ -830,21 +825,17 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
 	/* Request for gpio_86 line */
 	status = gpio_request(gpio_nr, "tshut");
 	if (status < 0) {
-		dev_err(bgp->dev,
-			"Could not request for TSHUT GPIO:%i\n", 86);
+		dev_err(bgp->dev, "Could not request for TSHUT GPIO:%i\n", 86);
 		return status;
 	}
 	status = gpio_direction_input(gpio_nr);
 	if (status) {
-		dev_err(bgp->dev,
-			"Cannot set input TSHUT GPIO %d\n", gpio_nr);
+		dev_err(bgp->dev, "Cannot set input TSHUT GPIO %d\n", gpio_nr);
 		return status;
 	}
 
-	status = request_irq(gpio_to_irq(gpio_nr),
-			     omap_bandgap_tshut_irq_handler,
-			     IRQF_TRIGGER_RISING, "tshut",
-			     NULL);
+	status = request_irq(gpio_to_irq(gpio_nr), ti_bandgap_tshut_irq_handler,
+			     IRQF_TRIGGER_RISING, "tshut", NULL);
 	if (status) {
 		gpio_free(gpio_nr);
 		dev_err(bgp->dev, "request irq failed for TSHUT");
@@ -854,8 +845,8 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
 }
 
 /**
- * omap_bandgap_alert_init() - setup and initialize talert handling
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_alert_init() - setup and initialize talert handling
+ * @bgp: pointer to struct ti_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Call this function only in case the bandgap features HAS(TALERT).
@@ -864,8 +855,8 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
  * are violated. In these situation, the driver must reprogram the thresholds,
  * accordingly to specified policy.
  */
-static int omap_bandgap_talert_init(struct omap_bandgap *bgp,
-				    struct platform_device *pdev)
+static int ti_bandgap_talert_init(struct ti_bandgap *bgp,
+				  struct platform_device *pdev)
 {
 	int ret;
 
@@ -875,7 +866,7 @@ static int omap_bandgap_talert_init(struct omap_bandgap *bgp,
 		return bgp->irq;
 	}
 	ret = request_threaded_irq(bgp->irq, NULL,
-				   omap_bandgap_talert_irq_handler,
+				   ti_bandgap_talert_irq_handler,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "talert", bgp);
 	if (ret) {
@@ -887,20 +878,20 @@ static int omap_bandgap_talert_init(struct omap_bandgap *bgp,
 }
 
 /**
- * omap_bandgap_build() - parse DT and setup a struct omap_bandgap
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_build() - parse DT and setup a struct ti_bandgap
+ * @bgp: pointer to struct ti_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Used to read the device tree properties accordingly to the bandgap
  * matching version. Based on bandgap version and its capabilities it
- * will build a struct omap_bandgap out of the required DT entries.
+ * will build a struct ti_bandgap out of the required DT entries.
  */
-static const struct of_device_id of_omap_bandgap_match[];
-static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
+static const struct of_device_id of_ti_bandgap_match[];
+static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
 	const struct of_device_id *of_id;
-	struct omap_bandgap *bgp;
+	struct ti_bandgap *bgp;
 	struct resource *res;
 	u32 prop;
 	int i;
@@ -911,14 +902,14 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	bgp = devm_kzalloc(&pdev->dev, sizeof(struct omap_bandgap),
+	bgp = devm_kzalloc(&pdev->dev, sizeof(struct ti_bandgap),
 				    GFP_KERNEL);
 	if (!bgp) {
 		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-	of_id = of_match_device(of_omap_bandgap_match, &pdev->dev);
+	of_id = of_match_device(of_ti_bandgap_match, &pdev->dev);
 	if (of_id)
 		bgp->conf = of_id->data;
 
@@ -938,7 +929,7 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 		i++;
 	} while (res);
 
-	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
 		if (of_property_read_u32(node, "ti,tshut-gpio", &prop) < 0) {
 			dev_err(&pdev->dev, "missing tshut gpio in device tree\n");
 			return ERR_PTR(-EINVAL);
@@ -957,20 +948,20 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 /***   Device driver call backs   ***/
 
 static
-int omap_bandgap_probe(struct platform_device *pdev)
+int ti_bandgap_probe(struct platform_device *pdev)
 {
-	struct omap_bandgap *bgp;
+	struct ti_bandgap *bgp;
 	int clk_rate, ret = 0, i;
 
-	bgp = omap_bandgap_build(pdev);
+	bgp = ti_bandgap_build(pdev);
 	if (IS_ERR_OR_NULL(bgp)) {
 		dev_err(&pdev->dev, "failed to fetch platform data\n");
 		return PTR_ERR(bgp);
 	}
 	bgp->dev = &pdev->dev;
 
-	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
-		ret = omap_bandgap_tshut_init(bgp, pdev);
+	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
+		ret = ti_bandgap_tshut_init(bgp, pdev);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"failed to initialize system tshut IRQ\n");
@@ -1003,7 +994,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		 * it is an untrimmed sample and the temperatures
 		 * may not be accurate
 		 */
-		val = omap_bandgap_readl(bgp, tsr->bgap_efuse);
+		val = ti_bandgap_readl(bgp, tsr->bgap_efuse);
 		if (ret || !val)
 			dev_info(&pdev->dev,
 				 "Non-trimmed BGAP, Temp not accurate\n");
@@ -1023,7 +1014,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Cannot re-set clock rate. Continuing\n");
 
 	bgp->clk_rate = clk_rate;
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_prepare_enable(bgp->fclock);
 
 
@@ -1031,10 +1022,10 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	bgp->dev = &pdev->dev;
 	platform_set_drvdata(pdev, bgp);
 
-	omap_bandgap_power(bgp, true);
+	ti_bandgap_power(bgp, true);
 
 	/* Set default counter to 1 for now */
-	if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+	if (TI_BANDGAP_HAS(bgp, COUNTER))
 		for (i = 0; i < bgp->conf->sensor_count; i++)
 			RMW_BITS(bgp, i, bgap_counter, counter_mask, 1);
 
@@ -1044,7 +1035,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 
 		ts_data = bgp->conf->sensors[i].ts_data;
 
-		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
+		if (TI_BANDGAP_HAS(bgp, TALERT)) {
 			/* Set initial Talert thresholds */
 			RMW_BITS(bgp, i, bgap_threshold,
 				 threshold_tcold_mask, ts_data->t_cold);
@@ -1055,7 +1046,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 			RMW_BITS(bgp, i, bgap_mask_ctrl, mask_cold_mask, 1);
 		}
 
-		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG)) {
+		if (TI_BANDGAP_HAS(bgp, TSHUT_CONFIG)) {
 			/* Set initial Tshut thresholds */
 			RMW_BITS(bgp, i, tshut_threshold,
 				 tshut_hot_mask, ts_data->tshut_hot);
@@ -1064,11 +1055,11 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
-		omap_bandgap_set_continuous_mode(bgp);
+	if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
+		ti_bandgap_set_continuous_mode(bgp);
 
 	/* Set .250 seconds time as default counter */
-	if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+	if (TI_BANDGAP_HAS(bgp, COUNTER))
 		for (i = 0; i < bgp->conf->sensor_count; i++)
 			RMW_BITS(bgp, i, bgap_counter, counter_mask,
 				 bgp->clk_rate / 4);
@@ -1090,8 +1081,8 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	 * might be called as soon as it is enabled where as rest of framework
 	 * is still getting initialised.
 	 */
-	if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
-		ret = omap_bandgap_talert_init(bgp, pdev);
+	if (TI_BANDGAP_HAS(bgp, TALERT)) {
+		ret = ti_bandgap_talert_init(bgp, pdev);
 		if (ret) {
 			dev_err(&pdev->dev, "failed to initialize Talert IRQ\n");
 			i = bgp->conf->sensor_count;
@@ -1102,13 +1093,13 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	return 0;
 
 disable_clk:
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_disable_unprepare(bgp->fclock);
 put_clks:
 	clk_put(bgp->fclock);
 	clk_put(bgp->div_clk);
 free_irqs:
-	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
 		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
 		gpio_free(bgp->tshut_gpio);
 	}
@@ -1117,9 +1108,9 @@ free_irqs:
 }
 
 static
-int omap_bandgap_remove(struct platform_device *pdev)
+int ti_bandgap_remove(struct platform_device *pdev)
 {
-	struct omap_bandgap *bgp = platform_get_drvdata(pdev);
+	struct ti_bandgap *bgp = platform_get_drvdata(pdev);
 	int i;
 
 	/* First thing is to remove sensor interfaces */
@@ -1131,17 +1122,17 @@ int omap_bandgap_remove(struct platform_device *pdev)
 			bgp->conf->remove_sensor(bgp, i);
 	}
 
-	omap_bandgap_power(bgp, false);
+	ti_bandgap_power(bgp, false);
 
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_disable_unprepare(bgp->fclock);
 	clk_put(bgp->fclock);
 	clk_put(bgp->div_clk);
 
-	if (OMAP_BANDGAP_HAS(bgp, TALERT))
+	if (TI_BANDGAP_HAS(bgp, TALERT))
 		free_irq(bgp->irq, bgp);
 
-	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
 		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
 		gpio_free(bgp->tshut_gpio);
 	}
@@ -1150,7 +1141,7 @@ int omap_bandgap_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int omap_bandgap_save_ctxt(struct omap_bandgap *bgp)
+static int ti_bandgap_save_ctxt(struct ti_bandgap *bgp)
 {
 	int i;
 
@@ -1161,28 +1152,28 @@ static int omap_bandgap_save_ctxt(struct omap_bandgap *bgp)
 		rval = &bgp->conf->sensors[i].regval;
 		tsr = bgp->conf->sensors[i].registers;
 
-		if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
-			rval->bg_mode_ctrl = omap_bandgap_readl(bgp,
+		if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
+			rval->bg_mode_ctrl = ti_bandgap_readl(bgp,
 							tsr->bgap_mode_ctrl);
-		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
-			rval->bg_counter = omap_bandgap_readl(bgp,
+		if (TI_BANDGAP_HAS(bgp, COUNTER))
+			rval->bg_counter = ti_bandgap_readl(bgp,
 							tsr->bgap_counter);
-		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
-			rval->bg_threshold = omap_bandgap_readl(bgp,
+		if (TI_BANDGAP_HAS(bgp, TALERT)) {
+			rval->bg_threshold = ti_bandgap_readl(bgp,
 							tsr->bgap_threshold);
-			rval->bg_ctrl = omap_bandgap_readl(bgp,
+			rval->bg_ctrl = ti_bandgap_readl(bgp,
 						   tsr->bgap_mask_ctrl);
 		}
 
-		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG))
-			rval->tshut_threshold = omap_bandgap_readl(bgp,
+		if (TI_BANDGAP_HAS(bgp, TSHUT_CONFIG))
+			rval->tshut_threshold = ti_bandgap_readl(bgp,
 						   tsr->tshut_threshold);
 	}
 
 	return 0;
 }
 
-static int omap_bandgap_restore_ctxt(struct omap_bandgap *bgp)
+static int ti_bandgap_restore_ctxt(struct ti_bandgap *bgp)
 {
 	int i;
 
@@ -1194,70 +1185,70 @@ static int omap_bandgap_restore_ctxt(struct omap_bandgap *bgp)
 		rval = &bgp->conf->sensors[i].regval;
 		tsr = bgp->conf->sensors[i].registers;
 
-		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
-			val = omap_bandgap_readl(bgp, tsr->bgap_counter);
+		if (TI_BANDGAP_HAS(bgp, COUNTER))
+			val = ti_bandgap_readl(bgp, tsr->bgap_counter);
 
-		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG))
-			omap_bandgap_writel(bgp, rval->tshut_threshold,
-					    tsr->tshut_threshold);
+		if (TI_BANDGAP_HAS(bgp, TSHUT_CONFIG))
+			ti_bandgap_writel(bgp, rval->tshut_threshold,
+					  tsr->tshut_threshold);
 		/* Force immediate temperature measurement and update
 		 * of the DTEMP field
 		 */
-		omap_bandgap_force_single_read(bgp, i);
-
-		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
-			omap_bandgap_writel(bgp, rval->bg_counter,
-					    tsr->bgap_counter);
-		if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
-			omap_bandgap_writel(bgp, rval->bg_mode_ctrl,
-					    tsr->bgap_mode_ctrl);
-		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
-			omap_bandgap_writel(bgp, rval->bg_threshold,
-					    tsr->bgap_threshold);
-			omap_bandgap_writel(bgp, rval->bg_ctrl,
-					    tsr->bgap_mask_ctrl);
+		ti_bandgap_force_single_read(bgp, i);
+
+		if (TI_BANDGAP_HAS(bgp, COUNTER))
+			ti_bandgap_writel(bgp, rval->bg_counter,
+					  tsr->bgap_counter);
+		if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
+			ti_bandgap_writel(bgp, rval->bg_mode_ctrl,
+					  tsr->bgap_mode_ctrl);
+		if (TI_BANDGAP_HAS(bgp, TALERT)) {
+			ti_bandgap_writel(bgp, rval->bg_threshold,
+					  tsr->bgap_threshold);
+			ti_bandgap_writel(bgp, rval->bg_ctrl,
+					  tsr->bgap_mask_ctrl);
 		}
 	}
 
 	return 0;
 }
 
-static int omap_bandgap_suspend(struct device *dev)
+static int ti_bandgap_suspend(struct device *dev)
 {
-	struct omap_bandgap *bgp = dev_get_drvdata(dev);
+	struct ti_bandgap *bgp = dev_get_drvdata(dev);
 	int err;
 
-	err = omap_bandgap_save_ctxt(bgp);
-	omap_bandgap_power(bgp, false);
+	err = ti_bandgap_save_ctxt(bgp);
+	ti_bandgap_power(bgp, false);
 
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_disable_unprepare(bgp->fclock);
 
 	return err;
 }
 
-static int omap_bandgap_resume(struct device *dev)
+static int ti_bandgap_resume(struct device *dev)
 {
-	struct omap_bandgap *bgp = dev_get_drvdata(dev);
+	struct ti_bandgap *bgp = dev_get_drvdata(dev);
 
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_prepare_enable(bgp->fclock);
 
-	omap_bandgap_power(bgp, true);
+	ti_bandgap_power(bgp, true);
 
-	return omap_bandgap_restore_ctxt(bgp);
+	return ti_bandgap_restore_ctxt(bgp);
 }
-static const struct dev_pm_ops omap_bandgap_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(omap_bandgap_suspend,
-				omap_bandgap_resume)
+static const struct dev_pm_ops ti_bandgap_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ti_bandgap_suspend,
+				ti_bandgap_resume)
 };
 
-#define DEV_PM_OPS	(&omap_bandgap_dev_pm_ops)
+#define DEV_PM_OPS	(&ti_bandgap_dev_pm_ops)
 #else
 #define DEV_PM_OPS	NULL
 #endif
 
-static const struct of_device_id of_omap_bandgap_match[] = {
+static const struct of_device_id of_ti_bandgap_match[] = {
 #ifdef CONFIG_OMAP4_THERMAL
 	{
 		.compatible = "ti,omap4430-bandgap",
@@ -1281,21 +1272,21 @@ static const struct of_device_id of_omap_bandgap_match[] = {
 	/* Sentinel */
 	{ },
 };
-MODULE_DEVICE_TABLE(of, of_omap_bandgap_match);
+MODULE_DEVICE_TABLE(of, of_ti_bandgap_match);
 
-static struct platform_driver omap_bandgap_sensor_driver = {
-	.probe = omap_bandgap_probe,
-	.remove = omap_bandgap_remove,
+static struct platform_driver ti_bandgap_sensor_driver = {
+	.probe = ti_bandgap_probe,
+	.remove = ti_bandgap_remove,
 	.driver = {
-			.name = "omap-bandgap",
+			.name = "ti-bandgap",
 			.pm = DEV_PM_OPS,
-			.of_match_table	= of_omap_bandgap_match,
+			.of_match_table	= of_ti_bandgap_match,
 	},
 };
 
-module_platform_driver(omap_bandgap_sensor_driver);
+module_platform_driver(ti_bandgap_sensor_driver);
 
-MODULE_DESCRIPTION("OMAP4+ bandgap temperature sensor driver");
+MODULE_DESCRIPTION("TI bandgap temperature sensor driver");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:omap-bandgap");
+MODULE_ALIAS("platform:ti-bandgap");
 MODULE_AUTHOR("Texas Instrument Inc.");
diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/ti-soc-thermal/ti-bandgap.h
similarity index 79%
rename from drivers/staging/omap-thermal/omap-bandgap.h
rename to drivers/staging/ti-soc-thermal/ti-bandgap.h
index 5700586..00d7596 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.h
@@ -20,8 +20,8 @@
  * 02110-1301 USA
  *
  */
-#ifndef __OMAP_BANDGAP_H
-#define __OMAP_BANDGAP_H
+#ifndef __TI_BANDGAP_H
+#define __TI_BANDGAP_H
 
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -30,21 +30,21 @@
 /**
  * DOC: bandgap driver data structure
  * ==================================
- *   +---------------------+   +-----------------+
- *   | struct omap_bandgap |-->| struct device * |
- *   +----------+----------+   +-----------------+
+ *   +-------------------+   +-----------------+
+ *   | struct ti_bandgap |-->| struct device * |
+ *   +--------+----------+   +-----------------+
  *              |
  *              |
  *              V
- *   +--------------------------+
- *   | struct omap_bandgap_data |
- *   +--------------------------+
+ *   +------------------------+
+ *   | struct ti_bandgap_data |
+ *   +------------------------+
  *              |
  *              |
  *              * (Array of)
  * +------------+------------------------------------------------------+
  * | +----------+--------------+   +-------------------------+         |
- * | | struct omap_temp_sensor |-->| struct temp_sensor_data |         |
+ * | | struct ti_temp_sensor |-->| struct temp_sensor_data |         |
  * | +-------------------------+   +------------+------------+         |
  * |            |                                                      |
  * |            +--------------------------+                           |
@@ -56,7 +56,7 @@
  * +-------------------------------------------------------------------+
  *
  * Above is a simple diagram describing how the data structure below
- * are organized. For each bandgap device there should be a omap_bandgap_data
+ * are organized. For each bandgap device there should be a ti_bandgap_data
  * containing the device instance configuration, as well as, an array of
  * sensors, representing every sensor instance present in this bandgap.
  */
@@ -187,16 +187,16 @@ struct temp_sensor_data {
 	u32     update_int2; /* not used */
 };
 
-struct omap_bandgap_data;
+struct ti_bandgap_data;
 
 /**
- * struct omap_bandgap - bandgap device structure
+ * struct ti_bandgap - bandgap device structure
  * @dev: struct device pointer
  * @base: io memory base address
  * @conf: struct with bandgap configuration set (# sensors, conv_table, etc)
  * @fclock: pointer to functional clock of temperature sensor
  * @div_clk: pointer to divider clock of temperature sensor fclk
- * @bg_mutex: mutex for omap_bandgap structure
+ * @bg_mutex: mutex for ti_bandgap structure
  * @irq: MPU IRQ number for thermal alert
  * @tshut_gpio: GPIO where Tshut signal is routed
  * @clk_rate: Holds current clock rate
@@ -205,10 +205,10 @@ struct omap_bandgap_data;
  * It holds most of the dynamic stuff. Configurations and sensor specific
  * entries are inside the @conf structure.
  */
-struct omap_bandgap {
+struct ti_bandgap {
 	struct device			*dev;
 	void __iomem			*base;
-	struct omap_bandgap_data	*conf;
+	struct ti_bandgap_data	*conf;
 	struct clk			*fclock;
 	struct clk			*div_clk;
 	spinlock_t			lock; /* shields this struct */
@@ -237,7 +237,7 @@ struct temp_sensor_regval {
 };
 
 /**
- * struct omap_temp_sensor - bandgap temperature sensor configuration data
+ * struct ti_temp_sensor - bandgap temperature sensor configuration data
  * @ts_data: pointer to struct with thresholds, limits of temperature sensor
  * @registers: pointer to the list of register offsets and bitfields
  * @regval: temperature sensor register values
@@ -258,7 +258,7 @@ struct temp_sensor_regval {
  * assess the gradient from hotspot, how to cooldown the domain when sensor
  * reports too hot temperature.
  */
-struct omap_temp_sensor {
+struct ti_temp_sensor {
 	struct temp_sensor_data		*ts_data;
 	struct temp_sensor_registers	*registers;
 	struct temp_sensor_regval	regval;
@@ -269,56 +269,56 @@ struct omap_temp_sensor {
 	const int			slope_pcb;
 	const int			constant_pcb;
 	void				*data;
-	int (*register_cooling)(struct omap_bandgap *bg_ptr, int id);
-	int (*unregister_cooling)(struct omap_bandgap *bg_ptr, int id);
+	int (*register_cooling)(struct ti_bandgap *bg_ptr, int id);
+	int (*unregister_cooling)(struct ti_bandgap *bg_ptr, int id);
 };
 
 /**
  * DOC: omap bandgap feature types
  *
- * OMAP_BANDGAP_FEATURE_TSHUT - used when the thermal shutdown signal output
+ * TI_BANDGAP_FEATURE_TSHUT - used when the thermal shutdown signal output
  *      of a bandgap device instance is routed to the processor. This means
  *      the system must react and perform the shutdown by itself (handle an
  *      IRQ, for instance).
  *
- * OMAP_BANDGAP_FEATURE_TSHUT_CONFIG - used when the bandgap device has control
+ * TI_BANDGAP_FEATURE_TSHUT_CONFIG - used when the bandgap device has control
  *      over the thermal shutdown configuration. This means that the thermal
  *      shutdown thresholds are programmable, for instance.
  *
- * OMAP_BANDGAP_FEATURE_TALERT - used when the bandgap device instance outputs
+ * TI_BANDGAP_FEATURE_TALERT - used when the bandgap device instance outputs
  *      a signal representing violation of programmable alert thresholds.
  *
- * OMAP_BANDGAP_FEATURE_MODE_CONFIG - used when it is possible to choose which
+ * TI_BANDGAP_FEATURE_MODE_CONFIG - used when it is possible to choose which
  *      mode, continuous or one shot, the bandgap device instance will operate.
  *
- * OMAP_BANDGAP_FEATURE_COUNTER - used when the bandgap device instance allows
+ * TI_BANDGAP_FEATURE_COUNTER - used when the bandgap device instance allows
  *      programming the update interval of its internal state machine.
  *
- * OMAP_BANDGAP_FEATURE_POWER_SWITCH - used when the bandgap device allows
+ * TI_BANDGAP_FEATURE_POWER_SWITCH - used when the bandgap device allows
  *      itself to be switched on/off.
  *
- * OMAP_BANDGAP_FEATURE_CLK_CTRL - used when the clocks feeding the bandgap
+ * TI_BANDGAP_FEATURE_CLK_CTRL - used when the clocks feeding the bandgap
  *      device are gateable or not.
  *
- * OMAP_BANDGAP_FEATURE_FREEZE_BIT - used when the bandgap device features
+ * TI_BANDGAP_FEATURE_FREEZE_BIT - used when the bandgap device features
  *      a history buffer that its update can be freezed/unfreezed.
  *
- * OMAP_BANDGAP_HAS(b, f) - macro to check if a bandgap device is capable of a
+ * TI_BANDGAP_HAS(b, f) - macro to check if a bandgap device is capable of a
  *      specific feature (above) or not. Return non-zero, if yes.
  */
-#define OMAP_BANDGAP_FEATURE_TSHUT		BIT(0)
-#define OMAP_BANDGAP_FEATURE_TSHUT_CONFIG	BIT(1)
-#define OMAP_BANDGAP_FEATURE_TALERT		BIT(2)
-#define OMAP_BANDGAP_FEATURE_MODE_CONFIG	BIT(3)
-#define OMAP_BANDGAP_FEATURE_COUNTER		BIT(4)
-#define OMAP_BANDGAP_FEATURE_POWER_SWITCH	BIT(5)
-#define OMAP_BANDGAP_FEATURE_CLK_CTRL		BIT(6)
-#define OMAP_BANDGAP_FEATURE_FREEZE_BIT		BIT(7)
-#define OMAP_BANDGAP_HAS(b, f)			\
-			((b)->conf->features & OMAP_BANDGAP_FEATURE_ ## f)
+#define TI_BANDGAP_FEATURE_TSHUT		BIT(0)
+#define TI_BANDGAP_FEATURE_TSHUT_CONFIG		BIT(1)
+#define TI_BANDGAP_FEATURE_TALERT		BIT(2)
+#define TI_BANDGAP_FEATURE_MODE_CONFIG		BIT(3)
+#define TI_BANDGAP_FEATURE_COUNTER		BIT(4)
+#define TI_BANDGAP_FEATURE_POWER_SWITCH		BIT(5)
+#define TI_BANDGAP_FEATURE_CLK_CTRL		BIT(6)
+#define TI_BANDGAP_FEATURE_FREEZE_BIT		BIT(7)
+#define TI_BANDGAP_HAS(b, f)			\
+			((b)->conf->features & TI_BANDGAP_FEATURE_ ## f)
 
 /**
- * struct omap_bandgap_data - omap bandgap data configuration structure
+ * struct ti_bandgap_data - omap bandgap data configuration structure
  * @features: a bitwise flag set to describe the device features
  * @conv_table: Pointer to ADC to temperature conversion table
  * @adc_start_val: ADC conversion table starting value
@@ -337,7 +337,7 @@ struct omap_temp_sensor {
  * their configuration representation, and how to export and unexport them to
  * a thermal API.
  */
-struct omap_bandgap_data {
+struct ti_bandgap_data {
 	unsigned int			features;
 	const int			*conv_table;
 	u32				adc_start_val;
@@ -345,32 +345,32 @@ struct omap_bandgap_data {
 	char				*fclock_name;
 	char				*div_ck_name;
 	int				sensor_count;
-	int (*report_temperature)(struct omap_bandgap *bg_ptr, int id);
-	int (*expose_sensor)(struct omap_bandgap *bg_ptr, int id, char *domain);
-	int (*remove_sensor)(struct omap_bandgap *bg_ptr, int id);
+	int (*report_temperature)(struct ti_bandgap *bg_ptr, int id);
+	int (*expose_sensor)(struct ti_bandgap *bg_ptr, int id, char *domain);
+	int (*remove_sensor)(struct ti_bandgap *bg_ptr, int id);
 
 	/* this needs to be at the end */
-	struct omap_temp_sensor		sensors[];
+	struct ti_temp_sensor		sensors[];
 };
 
-int omap_bandgap_read_thot(struct omap_bandgap *bg_ptr, int id, int *thot);
-int omap_bandgap_write_thot(struct omap_bandgap *bg_ptr, int id, int val);
-int omap_bandgap_read_tcold(struct omap_bandgap *bg_ptr, int id, int *tcold);
-int omap_bandgap_write_tcold(struct omap_bandgap *bg_ptr, int id, int val);
-int omap_bandgap_read_update_interval(struct omap_bandgap *bg_ptr, int id,
+int ti_bandgap_read_thot(struct ti_bandgap *bg_ptr, int id, int *thot);
+int ti_bandgap_write_thot(struct ti_bandgap *bg_ptr, int id, int val);
+int ti_bandgap_read_tcold(struct ti_bandgap *bg_ptr, int id, int *tcold);
+int ti_bandgap_write_tcold(struct ti_bandgap *bg_ptr, int id, int val);
+int ti_bandgap_read_update_interval(struct ti_bandgap *bg_ptr, int id,
 				      int *interval);
-int omap_bandgap_write_update_interval(struct omap_bandgap *bg_ptr, int id,
+int ti_bandgap_write_update_interval(struct ti_bandgap *bg_ptr, int id,
 				       u32 interval);
-int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
+int ti_bandgap_read_temperature(struct ti_bandgap *bg_ptr, int id,
 				  int *temperature);
-int omap_bandgap_set_sensor_data(struct omap_bandgap *bg_ptr, int id,
+int ti_bandgap_set_sensor_data(struct ti_bandgap *bg_ptr, int id,
 				 void *data);
-void *omap_bandgap_get_sensor_data(struct omap_bandgap *bg_ptr, int id);
+void *ti_bandgap_get_sensor_data(struct ti_bandgap *bg_ptr, int id);
 
 #ifdef CONFIG_OMAP4_THERMAL
-extern const struct omap_bandgap_data omap4430_data;
-extern const struct omap_bandgap_data omap4460_data;
-extern const struct omap_bandgap_data omap4470_data;
+extern const struct ti_bandgap_data omap4430_data;
+extern const struct ti_bandgap_data omap4460_data;
+extern const struct ti_bandgap_data omap4470_data;
 #else
 #define omap4430_data					NULL
 #define omap4460_data					NULL
@@ -378,7 +378,7 @@ extern const struct omap_bandgap_data omap4470_data;
 #endif
 
 #ifdef CONFIG_OMAP5_THERMAL
-extern const struct omap_bandgap_data omap5430_data;
+extern const struct ti_bandgap_data omap5430_data;
 #else
 #define omap5430_data					NULL
 #endif
diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
new file mode 100644
index 0000000..fb50e7e
--- /dev/null
+++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
@@ -0,0 +1,338 @@
+/*
+ * OMAP thermal driver interface
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Contact:
+ *   Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/workqueue.h>
+#include <linux/thermal.h>
+#include <linux/cpufreq.h>
+#include <linux/cpumask.h>
+#include <linux/cpu_cooling.h>
+
+#include "ti-thermal.h"
+#include "ti-bandgap.h"
+
+/* common data structures */
+struct ti_thermal_data {
+	struct thermal_zone_device *ti_thermal;
+	struct thermal_cooling_device *cool_dev;
+	struct ti_bandgap *bgp;
+	enum thermal_device_mode mode;
+	struct work_struct thermal_wq;
+	int sensor_id;
+};
+
+static void ti_thermal_work(struct work_struct *work)
+{
+	struct ti_thermal_data *data = container_of(work,
+					struct ti_thermal_data, thermal_wq);
+
+	thermal_zone_device_update(data->ti_thermal);
+
+	dev_dbg(&data->ti_thermal->device, "updated thermal zone %s\n",
+		data->ti_thermal->type);
+}
+
+/**
+ * ti_thermal_hotspot_temperature - returns sensor extrapolated temperature
+ * @t:	omap sensor temperature
+ * @s:	omap sensor slope value
+ * @c:	omap sensor const value
+ */
+static inline int ti_thermal_hotspot_temperature(int t, int s, int c)
+{
+	int delta = t * s / 1000 + c;
+
+	if (delta < 0)
+		delta = 0;
+
+	return t + delta;
+}
+
+/* thermal zone ops */
+/* Get temperature callback function for thermal zone*/
+static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
+				      unsigned long *temp)
+{
+	struct ti_thermal_data *data = thermal->devdata;
+	struct ti_bandgap *bgp;
+	struct ti_temp_sensor *s;
+	int ret, tmp, pcb_temp, slope, constant;
+
+	if (!data)
+		return 0;
+
+	bgp = data->bgp;
+	s = &bgp->conf->sensors[data->sensor_id];
+
+	ret = ti_bandgap_read_temperature(bgp, data->sensor_id, &tmp);
+	if (ret)
+		return ret;
+
+	pcb_temp = 0;
+	/* TODO: Introduce pcb temperature lookup */
+	/* In case pcb zone is available, use the extrapolation rule with it */
+	if (pcb_temp) {
+		tmp -= pcb_temp;
+		slope = s->slope_pcb;
+		constant = s->constant_pcb;
+	} else {
+		slope = s->slope;
+		constant = s->constant;
+	}
+	*temp = ti_thermal_hotspot_temperature(tmp, slope, constant);
+
+	return ret;
+}
+
+/* Bind callback functions for thermal zone */
+static int ti_thermal_bind(struct thermal_zone_device *thermal,
+			   struct thermal_cooling_device *cdev)
+{
+	struct ti_thermal_data *data = thermal->devdata;
+	int id;
+
+	if (IS_ERR_OR_NULL(data))
+		return -ENODEV;
+
+	/* check if this is the cooling device we registered */
+	if (data->cool_dev != cdev)
+		return 0;
+
+	id = data->sensor_id;
+
+	/* TODO: bind with min and max states */
+	/* Simple thing, two trips, one passive another critical */
+	return thermal_zone_bind_cooling_device(thermal, 0, cdev,
+						THERMAL_NO_LIMIT,
+						THERMAL_NO_LIMIT);
+}
+
+/* Unbind callback functions for thermal zone */
+static int ti_thermal_unbind(struct thermal_zone_device *thermal,
+			     struct thermal_cooling_device *cdev)
+{
+	struct ti_thermal_data *data = thermal->devdata;
+
+	if (IS_ERR_OR_NULL(data))
+		return -ENODEV;
+
+	/* check if this is the cooling device we registered */
+	if (data->cool_dev != cdev)
+		return 0;
+
+	/* Simple thing, two trips, one passive another critical */
+	return thermal_zone_unbind_cooling_device(thermal, 0, cdev);
+}
+
+/* Get mode callback functions for thermal zone */
+static int ti_thermal_get_mode(struct thermal_zone_device *thermal,
+			       enum thermal_device_mode *mode)
+{
+	struct ti_thermal_data *data = thermal->devdata;
+
+	if (data)
+		*mode = data->mode;
+
+	return 0;
+}
+
+/* Set mode callback functions for thermal zone */
+static int ti_thermal_set_mode(struct thermal_zone_device *thermal,
+			       enum thermal_device_mode mode)
+{
+	struct ti_thermal_data *data = thermal->devdata;
+
+	if (!data->ti_thermal) {
+		dev_notice(&thermal->device, "thermal zone not registered\n");
+		return 0;
+	}
+
+	mutex_lock(&data->ti_thermal->lock);
+
+	if (mode == THERMAL_DEVICE_ENABLED)
+		data->ti_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
+	else
+		data->ti_thermal->polling_delay = 0;
+
+	mutex_unlock(&data->ti_thermal->lock);
+
+	data->mode = mode;
+	thermal_zone_device_update(data->ti_thermal);
+	dev_dbg(&thermal->device, "thermal polling set for duration=%d msec\n",
+		data->ti_thermal->polling_delay);
+
+	return 0;
+}
+
+/* Get trip type callback functions for thermal zone */
+static int ti_thermal_get_trip_type(struct thermal_zone_device *thermal,
+				    int trip, enum thermal_trip_type *type)
+{
+	if (!ti_thermal_is_valid_trip(trip))
+		return -EINVAL;
+
+	if (trip + 1 == OMAP_TRIP_NUMBER)
+		*type = THERMAL_TRIP_CRITICAL;
+	else
+		*type = THERMAL_TRIP_PASSIVE;
+
+	return 0;
+}
+
+/* Get trip temperature callback functions for thermal zone */
+static int ti_thermal_get_trip_temp(struct thermal_zone_device *thermal,
+				    int trip, unsigned long *temp)
+{
+	if (!ti_thermal_is_valid_trip(trip))
+		return -EINVAL;
+
+	*temp = ti_thermal_get_trip_value(trip);
+
+	return 0;
+}
+
+/* Get critical temperature callback functions for thermal zone */
+static int ti_thermal_get_crit_temp(struct thermal_zone_device *thermal,
+				    unsigned long *temp)
+{
+	/* shutdown zone */
+	return ti_thermal_get_trip_temp(thermal, OMAP_TRIP_NUMBER - 1, temp);
+}
+
+static struct thermal_zone_device_ops ti_thermal_ops = {
+	.get_temp = ti_thermal_get_temp,
+	/* TODO: add .get_trend */
+	.bind = ti_thermal_bind,
+	.unbind = ti_thermal_unbind,
+	.get_mode = ti_thermal_get_mode,
+	.set_mode = ti_thermal_set_mode,
+	.get_trip_type = ti_thermal_get_trip_type,
+	.get_trip_temp = ti_thermal_get_trip_temp,
+	.get_crit_temp = ti_thermal_get_crit_temp,
+};
+
+static struct ti_thermal_data
+*ti_thermal_build_data(struct ti_bandgap *bgp, int id)
+{
+	struct ti_thermal_data *data;
+
+	data = devm_kzalloc(bgp->dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		dev_err(bgp->dev, "kzalloc fail\n");
+		return NULL;
+	}
+	data->sensor_id = id;
+	data->bgp = bgp;
+	data->mode = THERMAL_DEVICE_ENABLED;
+	INIT_WORK(&data->thermal_wq, ti_thermal_work);
+
+	return data;
+}
+
+int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
+			     char *domain)
+{
+	struct ti_thermal_data *data;
+
+	data = ti_bandgap_get_sensor_data(bgp, id);
+
+	if (IS_ERR_OR_NULL(data))
+		data = ti_thermal_build_data(bgp, id);
+
+	if (!data)
+		return -EINVAL;
+
+	/* TODO: remove TC1 TC2 */
+	/* Create thermal zone */
+	data->ti_thermal = thermal_zone_device_register(domain,
+				OMAP_TRIP_NUMBER, 0, data, &ti_thermal_ops,
+				NULL, FAST_TEMP_MONITORING_RATE,
+				FAST_TEMP_MONITORING_RATE);
+	if (IS_ERR_OR_NULL(data->ti_thermal)) {
+		dev_err(bgp->dev, "thermal zone device is NULL\n");
+		return PTR_ERR(data->ti_thermal);
+	}
+	data->ti_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
+	ti_bandgap_set_sensor_data(bgp, id, data);
+
+	return 0;
+}
+
+int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
+{
+	struct ti_thermal_data *data;
+
+	data = ti_bandgap_get_sensor_data(bgp, id);
+
+	thermal_zone_device_unregister(data->ti_thermal);
+
+	return 0;
+}
+
+int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int id)
+{
+	struct ti_thermal_data *data;
+
+	data = ti_bandgap_get_sensor_data(bgp, id);
+
+	schedule_work(&data->thermal_wq);
+
+	return 0;
+}
+
+int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
+{
+	struct ti_thermal_data *data;
+
+	data = ti_bandgap_get_sensor_data(bgp, id);
+	if (IS_ERR_OR_NULL(data))
+		data = ti_thermal_build_data(bgp, id);
+
+	if (!data)
+		return -EINVAL;
+
+	/* Register cooling device */
+	data->cool_dev = cpufreq_cooling_register(cpu_present_mask);
+	if (IS_ERR_OR_NULL(data->cool_dev)) {
+		dev_err(bgp->dev,
+			"Failed to register cpufreq cooling device\n");
+		return PTR_ERR(data->cool_dev);
+	}
+	ti_bandgap_set_sensor_data(bgp, id, data);
+
+	return 0;
+}
+
+int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id)
+{
+	struct ti_thermal_data *data;
+
+	data = ti_bandgap_get_sensor_data(bgp, id);
+	cpufreq_cooling_unregister(data->cool_dev);
+
+	return 0;
+}
diff --git a/drivers/staging/omap-thermal/omap-thermal.h b/drivers/staging/ti-soc-thermal/ti-thermal.h
similarity index 72%
rename from drivers/staging/omap-thermal/omap-thermal.h
rename to drivers/staging/ti-soc-thermal/ti-thermal.h
index 0dd2184..0af0f68 100644
--- a/drivers/staging/omap-thermal/omap-thermal.h
+++ b/drivers/staging/ti-soc-thermal/ti-thermal.h
@@ -23,7 +23,7 @@
 #ifndef __OMAP_THERMAL_H
 #define __OMAP_THERMAL_H
 
-#include "omap-bandgap.h"
+#include "ti-bandgap.h"
 
 /* sensors gradient and offsets */
 #define OMAP_GRADIENT_SLOPE_4460				348
@@ -60,47 +60,45 @@
 
 /* helper macros */
 /**
- * omap_thermal_get_trip_value - returns trip temperature based on index
+ * ti_thermal_get_trip_value - returns trip temperature based on index
  * @i:	trip index
  */
-#define omap_thermal_get_trip_value(i)					\
+#define ti_thermal_get_trip_value(i)					\
 	(OMAP_TRIP_HOT + ((i) * OMAP_TRIP_STEP))
 
 /**
- * omap_thermal_is_valid_trip - check for trip index
+ * ti_thermal_is_valid_trip - check for trip index
  * @i:	trip index
  */
-#define omap_thermal_is_valid_trip(trip)				\
+#define ti_thermal_is_valid_trip(trip)				\
 	((trip) >= 0 && (trip) < OMAP_TRIP_NUMBER)
 
-#ifdef CONFIG_OMAP_THERMAL
-int omap_thermal_expose_sensor(struct omap_bandgap *bg_ptr, int id,
-			       char *domain);
-int omap_thermal_remove_sensor(struct omap_bandgap *bg_ptr, int id);
-int omap_thermal_register_cpu_cooling(struct omap_bandgap *bg_ptr, int id);
-int omap_thermal_unregister_cpu_cooling(struct omap_bandgap *bg_ptr, int id);
+#ifdef CONFIG_TI_THERMAL
+int ti_thermal_expose_sensor(struct ti_bandgap *bg_ptr, int id, char *domain);
+int ti_thermal_remove_sensor(struct ti_bandgap *bg_ptr, int id);
+int ti_thermal_register_cpu_cooling(struct ti_bandgap *bg_ptr, int id);
+int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bg_ptr, int id);
 #else
 static inline
-int omap_thermal_expose_sensor(struct omap_bandgap *bg_ptr, int id,
-			       char *domain)
+int ti_thermal_expose_sensor(struct ti_bandgap *bg_ptr, int id, char *domain)
 {
 	return 0;
 }
 
 static inline
-int omap_thermal_remove_sensor(struct omap_bandgap *bg_ptr, int id)
+int ti_thermal_remove_sensor(struct ti_bandgap *bg_ptr, int id)
 {
 	return 0;
 }
 
 static inline
-int omap_thermal_register_cpu_cooling(struct omap_bandgap *bg_ptr, int id)
+int ti_thermal_register_cpu_cooling(struct ti_bandgap *bg_ptr, int id)
 {
 	return 0;
 }
 
 static inline
-int omap_thermal_unregister_cpu_cooling(struct omap_bandgap *bg_ptr, int id)
+int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bg_ptr, int id)
 {
 	return 0;
 }
-- 
1.7.7.1.488.ge8e1c

