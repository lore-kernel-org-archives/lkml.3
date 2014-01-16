Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaAPSbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:31:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:23616 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaAPS2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:28:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="404034846"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv5 01/10] Thermal: Do kfree in _unregister functions
Date: Fri, 17 Jan 2014 05:26:18 +0530
Message-Id: <1389916587-2541-2-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
References: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the thermal_release function does
kfree for all devices when they call device_unregister.
This makes code scattering i.e whenever we add new
devices (to thermal class) we need to add its
corresponding kfree in thermal_release function.
And the if-else is also growing lengthy.

Instead, do all kfree() of devices in their own
_unregister functions. This makes the code look
clean and easy to maintain.

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 drivers/thermal/thermal_core.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 338a88b..165afc6 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1042,18 +1042,7 @@ EXPORT_SYMBOL_GPL(thermal_zone_unbind_cooling_device);
 
 static void thermal_release(struct device *dev)
 {
-	struct thermal_zone_device *tz;
-	struct thermal_cooling_device *cdev;
-
-	if (!strncmp(dev_name(dev), "thermal_zone",
-		     sizeof("thermal_zone") - 1)) {
-		tz = to_thermal_zone(dev);
-		kfree(tz);
-	} else if(!strncmp(dev_name(dev), "cooling_device",
-			sizeof("cooling_device") - 1)){
-		cdev = to_cooling_device(dev);
-		kfree(cdev);
-	}
+	/* No-op since kfree(dev) is done in _unregister functions */
 }
 
 static struct class thermal_class = {
@@ -1146,6 +1135,7 @@ __thermal_cooling_device_register(struct device_node *np,
 unregister:
 	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
 	device_unregister(&cdev->device);
+	kfree(cdev);
 	return ERR_PTR(result);
 }
 
@@ -1250,6 +1240,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 
 	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
 	device_unregister(&cdev->device);
+	kfree(cdev);
 	return;
 }
 EXPORT_SYMBOL_GPL(thermal_cooling_device_unregister);
@@ -1563,6 +1554,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	device_unregister(&tz->device);
+	kfree(tz);
 	return ERR_PTR(result);
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_register);
@@ -1630,6 +1622,7 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	idr_destroy(&tz->idr);
 	mutex_destroy(&tz->lock);
 	device_unregister(&tz->device);
+	kfree(tz);
 	return;
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
-- 
1.7.9.5

