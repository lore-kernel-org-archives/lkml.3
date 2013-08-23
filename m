Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3HWWDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 18:03:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32907 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab3HWWDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 18:03:52 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <linux-pm@vger.kernel.org>, <rui.zhang@intel.com>
CC: <linux-kernel@vger.kernel.org>, Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 4/5] thermal: thermal_core: allow binding with limits on bind_params
Date: Fri, 23 Aug 2013 18:03:15 -0400
Message-ID: <1377295396-17289-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1377295396-17289-1-git-send-email-eduardo.valentin@ti.com>
References: <1377295396-17289-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When registering a thermal zone device using platform information
via bind_params, the thermal framework will always perform the
cdev binding using the lowest and highest limits (THERMAL_NO_LIMIT).

This patch changes the data structures so that it is possible
to inform what are the desired limits for each trip point
inside a bind_param. The way the binding is performed is also
changed so that it uses the new data structure.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/thermal/sysfs-api.txt |  7 +++++++
 drivers/thermal/thermal_core.c      | 19 +++++++++++++++----
 include/linux/thermal.h             | 10 ++++++++++
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 4b4a052..86e75a6 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -136,6 +136,13 @@ temperature) and throttle appropriate devices.
                this thermal zone and cdev, for a particular trip point.
                If nth bit is set, then the cdev and thermal zone are bound
                for trip point n.
+    .limits: This is an array of cooling state limits. Must have exactly
+         2 * thermal_zone.number_of_trip_points. It is an array consisting
+         of tuples <lower-state upper-state> of state limits. Each trip
+         will be associated with one state limit tuple when binding.
+         A NULL pointer means <THERMAL_NO_LIMITS THERMAL_NO_LIMITS>
+         on all trips. These limits are used when binding a cdev to a
+         trip point.
     .match: This call back returns success(0) if the 'tz and cdev' need to
 	    be bound, as per platform data.
 1.4.2 struct thermal_zone_params
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index d949ab0..e9545a7 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -202,14 +202,23 @@ static void print_bind_err_msg(struct thermal_zone_device *tz,
 }
 
 static void __bind(struct thermal_zone_device *tz, int mask,
-			struct thermal_cooling_device *cdev)
+			struct thermal_cooling_device *cdev,
+			unsigned long *limits)
 {
 	int i, ret;
 
 	for (i = 0; i < tz->trips; i++) {
 		if (mask & (1 << i)) {
+			unsigned long upper, lower;
+
+			upper = THERMAL_NO_LIMIT;
+			lower = THERMAL_NO_LIMIT;
+			if (limits) {
+				lower = limits[i * 2];
+				upper = limits[i * 2 + 1];
+			}
 			ret = thermal_zone_bind_cooling_device(tz, i, cdev,
-					THERMAL_NO_LIMIT, THERMAL_NO_LIMIT);
+							       upper, lower);
 			if (ret)
 				print_bind_err_msg(tz, cdev, ret);
 		}
@@ -254,7 +263,8 @@ static void bind_cdev(struct thermal_cooling_device *cdev)
 			if (tzp->tbp[i].match(pos, cdev))
 				continue;
 			tzp->tbp[i].cdev = cdev;
-			__bind(pos, tzp->tbp[i].trip_mask, cdev);
+			__bind(pos, tzp->tbp[i].trip_mask, cdev,
+			       tzp->tbp[i].binding_limits);
 		}
 	}
 
@@ -292,7 +302,8 @@ static void bind_tz(struct thermal_zone_device *tz)
 			if (tzp->tbp[i].match(tz, pos))
 				continue;
 			tzp->tbp[i].cdev = pos;
-			__bind(tz, tzp->tbp[i].trip_mask, pos);
+			__bind(tz, tzp->tbp[i].trip_mask, pos,
+			       tzp->tbp[i].binding_limits);
 		}
 	}
 exit:
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 88148b9..7c2769c 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -207,6 +207,16 @@ struct thermal_bind_params {
 	 * See Documentation/thermal/sysfs-api.txt for more information.
 	 */
 	int trip_mask;
+
+	/*
+	 * This is an array of cooling state limits. Must have exactly
+	 * 2 * thermal_zone.number_of_trip_points. It is an array consisting
+	 * of tuples <lower-state upper-state> of state limits. Each trip
+	 * will be associated with one state limit tuple when binding.
+	 * A NULL pointer means <THERMAL_NO_LIMITS THERMAL_NO_LIMITS>
+	 * on all trips.
+	 */
+	unsigned long *binding_limits;
 	int (*match) (struct thermal_zone_device *tz,
 			struct thermal_cooling_device *cdev);
 };
-- 
1.8.2.1.342.gfa7285d

