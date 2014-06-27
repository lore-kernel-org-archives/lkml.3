Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaF0IMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:12:34 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10361 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaF0IMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:12:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 27 Jun 2014 01:02:32 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <pdeschrijver@nvidia.com>,
        <mlongnecker@nvidia.com>
CC: <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 1/6] thermal: of: Add support for hardware-tracked trip points
Date: Fri, 27 Jun 2014 11:11:34 +0300
Message-ID: <1403856699-2140-2-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com>
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for hardware-tracked trip points to the device tree
thermal sensor framework.

The framework supports an arbitrary number of trip points. Whenever
the current temperature is updated, the trip points immediately
below and above the current temperature are found. A sensor driver
callback `set_trips' is then called with the temperatures.
If there is no trip point above or below the current temperature,
the passed trip temperature will be LONG_MAX or LONG_MIN respectively.
In this callback, the driver should program the hardware such that
it is notified when either of these trip points are triggered.
When a trip point is triggered, the driver should call
`thermal_zone_device_update' for the respective thermal zone. This
will cause the trip points to be updated again.

If the `set_trips' callback is not implemented (is NULL), the framework
behaves as before.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/thermal/of-thermal.c | 97 ++++++++++++++++++++++++++++++++++++++++++--
 include/linux/thermal.h      |  3 +-
 2 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 04b1be7..bfccea5 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -89,6 +89,7 @@ struct __thermal_zone {
 	/* trip data */
 	int ntrips;
 	struct __thermal_trip *trips;
+	long prev_low_trip, prev_high_trip;
 
 	/* cooling binding data */
 	int num_tbps;
@@ -98,19 +99,66 @@ struct __thermal_zone {
 	void *sensor_data;
 	int (*get_temp)(void *, long *);
 	int (*get_trend)(void *, long *);
+	int (*set_trips)(void *, long, long);
 };
 
+/***   Automatic trip handling   ***/
+
+static int of_thermal_set_trips(struct thermal_zone_device *tz, long temp)
+{
+	struct __thermal_zone *data = tz->devdata;
+	long low = LONG_MIN, high = LONG_MAX;
+	int i;
+
+	/* Hardware trip points not supported */
+	if (!data->set_trips)
+		return 0;
+
+	/* No need to change trip points */
+	if (temp > data->prev_low_trip && temp < data->prev_high_trip)
+		return 0;
+
+	for (i = 0; i < data->ntrips; ++i) {
+		struct __thermal_trip *trip = data->trips + i;
+		long trip_low = trip->temperature - trip->hysteresis;
+
+		if (trip_low < temp && trip_low > low)
+			low = trip_low;
+
+		if (trip->temperature > temp && trip->temperature < high)
+			high = trip->temperature;
+	}
+
+	dev_dbg(&tz->device,
+		"temperature %ld, updating trip points to %ld, %ld\n",
+		temp, low, high);
+
+	data->prev_low_trip = low;
+	data->prev_high_trip = high;
+
+	return data->set_trips(data->sensor_data, low, high);
+}
+
 /***   DT thermal zone device callbacks   ***/
 
 static int of_thermal_get_temp(struct thermal_zone_device *tz,
 			       unsigned long *temp)
 {
 	struct __thermal_zone *data = tz->devdata;
+	int err;
 
 	if (!data->get_temp)
 		return -EINVAL;
 
-	return data->get_temp(data->sensor_data, temp);
+	err = data->get_temp(data->sensor_data, temp);
+	if (err)
+		return err;
+
+	err = of_thermal_set_trips(tz, *temp);
+	if (err)
+		return err;
+
+	return 0;
 }
 
 static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
@@ -222,6 +270,22 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
 	return 0;
 }
 
+static int of_thermal_update_trips(struct thermal_zone_device *tz)
+{
+	long temp;
+	int err;
+
+	err = of_thermal_get_temp(tz, &temp);
+	if (err)
+		return err;
+
+	err = of_thermal_set_trips(tz, temp);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int of_thermal_get_trip_type(struct thermal_zone_device *tz, int trip,
 				    enum thermal_trip_type *type)
 {
@@ -252,6 +316,7 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
 				    unsigned long temp)
 {
 	struct __thermal_zone *data = tz->devdata;
+	int err;
 
 	if (trip >= data->ntrips || trip < 0)
 		return -EDOM;
@@ -259,6 +324,10 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
 	/* thermal framework should take care of data->mask & (1 << trip) */
 	data->trips[trip].temperature = temp;
 
+	err = of_thermal_update_trips(tz);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -279,6 +348,7 @@ static int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int trip,
 				    unsigned long hyst)
 {
 	struct __thermal_zone *data = tz->devdata;
+	int err;
 
 	if (trip >= data->ntrips || trip < 0)
 		return -EDOM;
@@ -286,6 +356,10 @@ static int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int trip,
 	/* thermal framework should take care of data->mask & (1 << trip) */
 	data->trips[trip].hysteresis = hyst;
 
+	err = of_thermal_update_trips(tz);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -325,10 +399,12 @@ static struct thermal_zone_device *
 thermal_zone_of_add_sensor(struct device_node *zone,
 			   struct device_node *sensor, void *data,
 			   int (*get_temp)(void *, long *),
-			   int (*get_trend)(void *, long *))
+			   int (*get_trend)(void *, long *),
+			   int (*set_trips)(void *, long, long))
 {
 	struct thermal_zone_device *tzd;
 	struct __thermal_zone *tz;
+	int err;
 
 	tzd = thermal_zone_get_zone_by_name(zone->name);
 	if (IS_ERR(tzd))
@@ -339,8 +415,15 @@ thermal_zone_of_add_sensor(struct device_node *zone,
 	mutex_lock(&tzd->lock);
 	tz->get_temp = get_temp;
 	tz->get_trend = get_trend;
+	tz->set_trips = set_trips;
 	tz->sensor_data = data;
 
+	err = of_thermal_update_trips(tzd);
+	if (err) {
+		mutex_unlock(&tzd->lock);
+		return ERR_PTR(err);
+	}
+
 	tzd->ops->get_temp = of_thermal_get_temp;
 	tzd->ops->get_trend = of_thermal_get_trend;
 	mutex_unlock(&tzd->lock);
@@ -384,7 +467,8 @@ thermal_zone_of_add_sensor(struct device_node *zone,
 struct thermal_zone_device *
 thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
 				void *data, int (*get_temp)(void *, long *),
-				int (*get_trend)(void *, long *))
+				int (*get_trend)(void *, long *),
+				int (*set_trips)(void *, long, long))
 {
 	struct device_node *np, *child, *sensor_np;
 
@@ -422,7 +506,8 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
 			return thermal_zone_of_add_sensor(child, sensor_np,
 							  data,
 							  get_temp,
-							  get_trend);
+							  get_trend,
+							  set_trips);
 		}
 	}
 	of_node_put(np);
@@ -466,6 +551,7 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
 
 	tz->get_temp = NULL;
 	tz->get_trend = NULL;
+	tz->set_trips = NULL;
 	tz->sensor_data = NULL;
 	mutex_unlock(&tzd->lock);
 }
@@ -671,6 +757,9 @@ thermal_of_build_thermal_zone(struct device_node *np)
 	/* trips */
 	child = of_get_child_by_name(np, "trips");
 
+	tz->prev_high_trip = LONG_MIN;
+	tz->prev_low_trip = LONG_MAX;
+
 	/* No trips provided */
 	if (!child)
 		goto finish;
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f7e11c7..2f8951c 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -248,7 +248,8 @@ struct thermal_genl_event {
 struct thermal_zone_device *
 thermal_zone_of_sensor_register(struct device *dev, int id,
 				void *data, int (*get_temp)(void *, long *),
-				int (*get_trend)(void *, long *));
+				int (*get_trend)(void *, long *),
+				int (*set_trips)(void *, long, long));
 void thermal_zone_of_sensor_unregister(struct device *dev,
 				       struct thermal_zone_device *tz);
 #else
-- 
1.8.1.5

