Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3I0DQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:16:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33580 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3I0DQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:16:03 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>
CC: <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv4 09/18] thermal: ti-soc-thermal: use thermal DT infrastructure
Date: Thu, 26 Sep 2013 23:13:16 -0400
Message-ID: <1380251605-3804-10-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the ti-soc-thermal driver by adding the
support to build the thermal zones based on DT nodes.

The driver will have two options now to build the thermal
zones. The first option is the zones originally coded
in this driver. So, the driver behavior will be same
if there is no DT node describing the zones. The second
option, when it is found a DT node with thermal data,
will used the common infrastructure to build the thermal
zone and bind its cooling devices.

In case the driver loads thermal data using the legacy
mode, this driver still adds to the system
a cpufreq cooling device. Loading the thermal data from
DT, the driver assumes someone else will add the cpufreq
cooling device, like the cpufreq driver.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 77 +++++++++++++++++-----
 1 file changed, 62 insertions(+), 15 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 4f8b9af..b80b5b8 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -31,6 +31,7 @@
 #include <linux/cpufreq.h>
 #include <linux/cpumask.h>
 #include <linux/cpu_cooling.h>
+#include <linux/of.h>
 
 #include "ti-thermal.h"
 #include "ti-bandgap.h"
@@ -44,6 +45,7 @@ struct ti_thermal_data {
 	enum thermal_device_mode mode;
 	struct work_struct thermal_wq;
 	int sensor_id;
+	bool our_zone;
 };
 
 static void ti_thermal_work(struct work_struct *work)
@@ -75,11 +77,10 @@ static inline int ti_thermal_hotspot_temperature(int t, int s, int c)
 
 /* thermal zone ops */
 /* Get temperature callback function for thermal zone*/
-static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
-				      unsigned long *temp)
+static inline int __ti_thermal_get_temp(void *devdata, long *temp)
 {
 	struct thermal_zone_device *pcb_tz = NULL;
-	struct ti_thermal_data *data = thermal->devdata;
+	struct ti_thermal_data *data = devdata;
 	struct ti_bandgap *bgp;
 	const struct ti_temp_sensor *s;
 	int ret, tmp, slope, constant;
@@ -117,6 +118,14 @@ static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
 	return ret;
 }
 
+static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
+				      unsigned long *temp)
+{
+	struct ti_thermal_data *data = thermal->devdata;
+
+	return __ti_thermal_get_temp(data, temp);
+}
+
 /* Bind callback functions for thermal zone */
 static int ti_thermal_bind(struct thermal_zone_device *thermal,
 			   struct thermal_cooling_device *cdev)
@@ -229,11 +238,9 @@ static int ti_thermal_get_trip_temp(struct thermal_zone_device *thermal,
 	return 0;
 }
 
-/* Get the temperature trend callback functions for thermal zone */
-static int ti_thermal_get_trend(struct thermal_zone_device *thermal,
-				int trip, enum thermal_trend *trend)
+static int __ti_thermal_get_trend(void *p, long *trend)
 {
-	struct ti_thermal_data *data = thermal->devdata;
+	struct ti_thermal_data *data = p;
 	struct ti_bandgap *bgp;
 	int id, tr, ret = 0;
 
@@ -244,6 +251,22 @@ static int ti_thermal_get_trend(struct thermal_zone_device *thermal,
 	if (ret)
 		return ret;
 
+	*trend = tr;
+
+	return 0;
+}
+
+/* Get the temperature trend callback functions for thermal zone */
+static int ti_thermal_get_trend(struct thermal_zone_device *thermal,
+				int trip, enum thermal_trend *trend)
+{
+	int ret;
+	long tr;
+
+	ret = __ti_thermal_get_trend(thermal->devdata, &tr);
+	if (ret)
+		return ret;
+
 	if (tr > 0)
 		*trend = THERMAL_TREND_RAISING;
 	else if (tr < 0)
@@ -307,16 +330,23 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
 	if (!data)
 		return -EINVAL;
 
-	/* Create thermal zone */
-	data->ti_thermal = thermal_zone_device_register(domain,
+	/* in case this is specified by DT */
+	data->ti_thermal = thermal_zone_of_sensor_register(bgp->dev, id,
+					data, __ti_thermal_get_temp,
+					__ti_thermal_get_trend);
+	if (IS_ERR(data->ti_thermal)) {
+		/* Create thermal zone */
+		data->ti_thermal = thermal_zone_device_register(domain,
 				OMAP_TRIP_NUMBER, 0, data, &ti_thermal_ops,
 				NULL, FAST_TEMP_MONITORING_RATE,
 				FAST_TEMP_MONITORING_RATE);
-	if (IS_ERR(data->ti_thermal)) {
-		dev_err(bgp->dev, "thermal zone device is NULL\n");
-		return PTR_ERR(data->ti_thermal);
+		if (IS_ERR(data->ti_thermal)) {
+			dev_err(bgp->dev, "thermal zone device is NULL\n");
+			return PTR_ERR(data->ti_thermal);
+		}
+		data->ti_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
+		data->our_zone = true;
 	}
-	data->ti_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
 	ti_bandgap_set_sensor_data(bgp, id, data);
 	ti_bandgap_write_update_interval(bgp, data->sensor_id,
 					data->ti_thermal->polling_delay);
@@ -330,7 +360,13 @@ int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
 
-	thermal_zone_device_unregister(data->ti_thermal);
+	if (data && data->ti_thermal) {
+		if (data->our_zone)
+			thermal_zone_device_unregister(data->ti_thermal);
+		else
+			thermal_zone_of_sensor_unregister(bgp->dev,
+							  data->ti_thermal);
+	}
 
 	return 0;
 }
@@ -349,6 +385,15 @@ int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int id)
 int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 {
 	struct ti_thermal_data *data;
+	struct device_node *np = bgp->dev->of_node;
+
+	/*
+	 * We are assuming here that if one deploys the zone
+	 * using DT, then it must be aware that the cooling device
+	 * loading has to happen via cpufreq driver.
+	 */
+	if (of_find_property(np, "#thermal-sensor-cells", NULL))
+		return 0;
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
 	if (!data || IS_ERR(data))
@@ -379,7 +424,9 @@ int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id)
 	struct ti_thermal_data *data;
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
-	cpufreq_cooling_unregister(data->cool_dev);
+
+	if (data && data->cool_dev)
+		cpufreq_cooling_unregister(data->cool_dev);
 
 	return 0;
 }
-- 
1.8.2.1.342.gfa7285d

