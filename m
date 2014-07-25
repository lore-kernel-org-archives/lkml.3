Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbaGYKDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:03:31 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4305 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaGYKD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:03:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 25 Jul 2014 02:51:29 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>, <eduardo.valentin@gmail.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <javi.merino@arm.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] thermal: add support to disable thermal zone from DTS
Date: Fri, 25 Jul 2014 15:31:58 +0530
Message-ID: <1406282518-31266-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to check status of the thermal zone before registering the
zone. This will help on disabling some non-existing thermal zone from
the top level DTS file out of common dtsi thermalzone file.

For example,
we have 3 platforms almost same but thermal zones on this platform are
little bit different. Platform 1 and 2 have three thermal zones and
platform 3 has two thermal zones. To avoid duplication of the thermal
zones entries on each DTS file of platforms,we created one common
dtsi file for thermal zone and included this dtsi file from these
3 platform's top level dts file.

On common thermal zone com dtsi file, all thermal zone are enabled and
need to disable one of thermal zone on platform 3 dts file. For this, we
just added entry status = "disabled" for that thermal zone on platform 3
dts file and along with this change to make it work.

This way, we reuse the common file and control the enable/disable of the
thermal zone from top level dts file.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/thermal/of-thermal.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 4b2b999..f8eb625 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -401,6 +401,10 @@ thermal_zone_of_sensor_register(struct device *dev, int sensor_id,
 		struct of_phandle_args sensor_specs;
 		int ret, id;
 
+		/* Check whether child is enabled or not */
+		if (!of_device_is_available(child))
+			continue;
+
 		/* For now, thermal framework supports only 1 sensor per zone */
 		ret = of_parse_phandle_with_args(child, "thermal-sensors",
 						 "#thermal-sensor-cells",
@@ -771,6 +775,10 @@ int __init of_parse_thermal_zones(void)
 		struct thermal_zone_device *zone;
 		struct thermal_zone_params *tzp;
 
+		/* Check whether child is enabled or not */
+		if (!of_device_is_available(child))
+			continue;
+
 		tz = thermal_of_build_thermal_zone(child);
 		if (IS_ERR(tz)) {
 			pr_err("failed to build thermal zone %s: %ld\n",
@@ -838,6 +846,10 @@ void of_thermal_destroy_zones(void)
 	for_each_child_of_node(np, child) {
 		struct thermal_zone_device *zone;
 
+		/* Check whether child is enabled or not */
+		if (!of_device_is_available(child))
+			continue;
+
 		zone = thermal_zone_get_zone_by_name(child->name);
 		if (IS_ERR(zone))
 			continue;
-- 
1.8.1.5

