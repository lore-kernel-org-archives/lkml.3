Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaG3XGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:06:23 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9351 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaG3XGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:06:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 30 Jul 2014 15:58:00 -0700
Message-ID: <53D97B70.1050305@nvidia.com>
Date: Wed, 30 Jul 2014 16:10:40 -0700
From: Matt Longnecker <mlongnecker@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mlongnecker@nvidia.com>
Subject: [PATCH] thermal: tell cooling devices when a trip_point changes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware can react autonomously at a programmed temperature.
For example, an SoC might implement a last ditch throttle or a
hardware thermal shutdown. The driver for such a device can
register itself as a cooling_device with the thermal framework.

With this change, the thermal framework notifies such a driver
when userspace alters the relevant trip temperature so that
the driver can reprogram its hardware

Signed-off-by: Matt Longnecker <mlongnecker@nvidia.com>
---
 drivers/thermal/thermal_core.c |   30 ++++++++++++++++++++++++++++++
 include/linux/thermal.h        |    2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 71b0ec0..f25272e 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -597,6 +597,7 @@ trip_point_temp_store(struct device *dev, struct device_attribute *attr,
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
 	int trip, ret;
 	unsigned long temperature;
+	struct thermal_instance *pos = NULL;
 
 	if (!tz->ops->set_trip_temp)
 		return -EPERM;
@@ -609,6 +610,20 @@ trip_point_temp_store(struct device *dev, struct device_attribute *attr,
 
 	ret = tz->ops->set_trip_temp(tz, trip, temperature);
 
+	/*
+	 * Notify bound cooling devices that this trip point changed.
+	 * This is useful for cooling devices which represent a behavior
+	 * which trips in hardware (e.g. catastrophic shutdown)
+	 */
+	list_for_each_entry(pos, &tz->thermal_instances, tz_node) {
+		if (pos->tz == tz && pos->trip == trip && pos->cdev) {
+			if (pos->cdev->ops->trip_point_changed)
+				pos->cdev->ops->trip_point_changed(pos->cdev,
+								   pos->tz,
+								   trip);
+		}
+	}
+
 	return ret ? ret : count;
 }
 
@@ -641,6 +656,7 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
 	int trip, ret;
 	unsigned long temperature;
+	struct thermal_instance *pos = NULL;
 
 	if (!tz->ops->set_trip_hyst)
 		return -EPERM;
@@ -658,6 +674,20 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
 	 */
 	ret = tz->ops->set_trip_hyst(tz, trip, temperature);
 
+	/*
+	 * Notify bound cooling devices that this trip point changed.
+	 * This is useful for cooling devices which represent a behavior
+	 * which trips in hardware (e.g. catastrophic shutdown)
+	 */
+	list_for_each_entry(pos, &tz->thermal_instances, tz_node) {
+		if (pos->tz == tz && pos->trip == trip && pos->cdev) {
+			if (pos->cdev->ops->trip_point_changed)
+				pos->cdev->ops->trip_point_changed(pos->cdev,
+								   pos->tz,
+								   trip);
+		}
+	}
+
 	return ret ? ret : count;
 }
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f7e11c7..7da7fc5 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -138,6 +138,8 @@ struct thermal_cooling_device_ops {
 	int (*get_max_state) (struct thermal_cooling_device *, unsigned long *);
 	int (*get_cur_state) (struct thermal_cooling_device *, unsigned long *);
 	int (*set_cur_state) (struct thermal_cooling_device *, unsigned long);
+	void (*trip_point_changed) (struct thermal_cooling_device *,
+				    struct thermal_zone_device *, int);
 };
 
 struct thermal_cooling_device {
-- 
1.7.9.5

