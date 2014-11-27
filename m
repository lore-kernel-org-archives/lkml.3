Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaK0BQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:16:52 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6623 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaK0BQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:16:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 26 Nov 2014 17:15:04 -0800
From: Navneet Kumar <navneetk@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        navneet kumar <navneetk@nvidia.com>,
        Diwakar Tundlam <dtundlam@nvidia.com>
Subject: [PATCH 1/3] thermal: of: support writable trips via dt
Date: Wed, 26 Nov 2014 17:16:27 -0800
Message-ID: <1417050989-25405-1-git-send-email-navneetk@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: navneet kumar <navneetk@nvidia.com>

Support writable trip points configuration from the
device tree. 'OF' reads this configuration and adjusts
the 'trips' mask accordingly to allow the 'set_trip_xxx'
calls to be effective.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
---
 drivers/thermal/of-thermal.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 62143ba31001..cf9ee3e82fee 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -604,7 +604,8 @@ static int thermal_of_get_trip_type(struct device_node *np,
  * Return: 0 on success, proper error code otherwise
  */
 static int thermal_of_populate_trip(struct device_node *np,
-				    struct __thermal_trip *trip)
+				    struct __thermal_trip *trip,
+				    bool *trip_writable)
 {
 	int prop;
 	int ret;
@@ -629,6 +630,8 @@ static int thermal_of_populate_trip(struct device_node *np,
 		return ret;
 	}
 
+	*trip_writable = of_property_read_bool(np, "writable");
+
 	/* Required for cooling map matching */
 	trip->np = np;
 	of_node_get(np);
@@ -657,6 +660,8 @@ thermal_of_build_thermal_zone(struct device_node *np)
 	struct __thermal_zone *tz;
 	int ret, i;
 	u32 prop;
+	bool trip_writable;
+	u64 m = 0;
 
 	if (!np) {
 		pr_err("no thermal zone np\n");
@@ -700,9 +705,14 @@ thermal_of_build_thermal_zone(struct device_node *np)
 
 	i = 0;
 	for_each_child_of_node(child, gchild) {
-		ret = thermal_of_populate_trip(gchild, &tz->trips[i++]);
+		trip_writable = false;
+		ret = thermal_of_populate_trip(gchild, &tz->trips[i],
+					       &trip_writable);
 		if (ret)
 			goto free_trips;
+		if (trip_writable)
+			m |= 1ULL << i;
+		i++;
 	}
 
 	of_node_put(child);
-- 
1.8.1.5

