Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaK0BRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:17:19 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7981 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaK0BRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:17:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 26 Nov 2014 17:15:41 -0800
From: Navneet Kumar <navneetk@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        navneet kumar <navneetk@nvidia.com>
Subject: [PATCH 3/3] thermal: of: notify sensor driver on trip updates
Date: Wed, 26 Nov 2014 17:16:29 -0800
Message-ID: <1417050989-25405-3-git-send-email-navneetk@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
References: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navneet kumar <navneetk@nvidia.com>

some thermal sensor hardwares include logic which
can raise interrupts at certain programmed temperature
thresholds.

Drivers for such sensors should be able to learn the
appropriate threshold temperatures for interrupts by querying
the thermal framework.

This change provides a mechanism to allow a sensor driver to
update it's thresholds when userspace changes a trip point
temperature.

While this behavior may not make sense in thermal zones
with more than one sensor, no such examples exist in
the kernel.

Signed-off-by: navneet kumar <navneetk@nvidia.com>
---
 drivers/thermal/of-thermal.c | 7 +++++++
 include/linux/thermal.h      | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 3d47a0cf3825..3568e4a586dc 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -258,6 +258,9 @@ static int of_thermal_set_trip_temp(struct thermal_zone_device *tz, int trip,
 	/* thermal framework should take care of data->mask & (1 << trip) */
 	data->trips[trip].temperature = temp;
 
+	if (data->sops.trip_update)
+		data->sops.trip_update(data->sensor_data, trip);
+
 	return 0;
 }
 
@@ -285,6 +288,9 @@ static int of_thermal_set_trip_hyst(struct thermal_zone_device *tz, int trip,
 	/* thermal framework should take care of data->mask & (1 << trip) */
 	data->trips[trip].hysteresis = hyst;
 
+	if (data->sops.trip_update)
+		data->sops.trip_update(data->sensor_data, trip);
+
 	return 0;
 }
 
@@ -500,6 +506,7 @@ void thermal_zone_of_sensor_unregister(struct device *dev,
 
 	tz->sops.get_temp = NULL;
 	tz->sops.get_trend = NULL;
+	tz->sops.trip_update = NULL;
 	tz->sensor_data = NULL;
 	mutex_unlock(&tzd->lock);
 }
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 58341c56a01f..b93e65815175 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -292,6 +292,7 @@ struct thermal_genl_event {
 struct thermal_of_sensor_ops {
 	int (*get_temp)(void *, long *);
 	int (*get_trend)(void *, long *);
+	int (*trip_update)(void *, int);
 };
 
 /* Function declarations */
-- 
1.8.1.5

