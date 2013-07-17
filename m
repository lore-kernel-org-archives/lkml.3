Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3GQPF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:05:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33683 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab3GQPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:05:55 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>
CC: <wni@nvidia.com>, <l.stach@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 6/9] thermal: ti-soc-thermal: use thermal DT infrastructure
Date: Wed, 17 Jul 2013 11:02:49 -0400
Message-ID: <1374073374-30946-14-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1374073374-30946-1-git-send-email-eduardo.valentin@ti.com>
References: <1374073374-30946-1-git-send-email-eduardo.valentin@ti.com>
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
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 46 +++++++++++++++++-----
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 4c5f55c37..de4e138 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -31,6 +31,7 @@
 #include <linux/cpufreq.h>
 #include <linux/cpumask.h>
 #include <linux/cpu_cooling.h>
+#include <linux/of.h>
 
 #include "ti-thermal.h"
 #include "ti-bandgap.h"
@@ -75,11 +76,10 @@ static inline int ti_thermal_hotspot_temperature(int t, int s, int c)
 
 /* thermal zone ops */
 /* Get temperature callback function for thermal zone*/
-static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
-				      unsigned long *temp)
+static inline int __ti_thermal_get_temp(void *devdata, unsigned long *temp)
 {
 	struct thermal_zone_device *pcb_tz = NULL;
-	struct ti_thermal_data *data = thermal->devdata;
+	struct ti_thermal_data *data = devdata;
 	struct ti_bandgap *bgp;
 	const struct ti_temp_sensor *s;
 	int ret, tmp, slope, constant;
@@ -117,6 +117,14 @@ static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
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
@@ -302,17 +310,27 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
 	if (!data)
 		return -EINVAL;
 
-	/* Create thermal zone */
-	data->ti_thermal = thermal_zone_device_register(domain,
+	/* in case this is specified by DT */
+	if (of_find_node_by_name(bgp->dev->of_node, "thermal_zone")) {
+		data->ti_thermal = thermal_zone_of_device_register(bgp->dev,
+						data, __ti_thermal_get_temp);
+		if (IS_ERR(data->ti_thermal)) {
+			dev_err(bgp->dev, "failed to build of thermal zone\n");
+			return PTR_ERR(data->ti_thermal);
+		}
+	} else {
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
+		ti_bandgap_set_sensor_data(bgp, id, data);
 	}
-	data->ti_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
-	ti_bandgap_set_sensor_data(bgp, id, data);
 
 	return 0;
 }
@@ -343,6 +361,14 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 {
 	struct ti_thermal_data *data;
 
+	/*
+	 * We are assuming here that if one deploys the zone
+	 * using DT, then it must be aware that the cooling device
+	 * loading has to happen via cpufreq driver.
+	 */
+	if (of_find_node_by_name(bgp->dev->of_node, "thermal_zone"))
+		return 0;
+
 	data = ti_bandgap_get_sensor_data(bgp, id);
 	if (!data || IS_ERR(data))
 		data = ti_thermal_build_data(bgp, id);
-- 
1.8.2.1.342.gfa7285d

