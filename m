Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3KLTsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:48:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52390 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab3KLTsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:48:05 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>
CC: <wni@nvidia.com>, <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv5 03/20] thermal: core: introduce thermal_of_cooling_device_register
Date: Tue, 12 Nov 2013 15:46:05 -0400
Message-ID: <1384285582-16933-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new API to allow registering cooling devices
in the thermal framework derived from device tree nodes.

This API links the cooling device with the device tree node
so that binding with thermal zones is possible, given
that thermal zones are pointing to cooling device
device tree nodes.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_core.c | 58 +++++++++++++++++++++++++++++++++++++++---
 include/linux/thermal.h        |  4 +++
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index aba68dc..3092bfb 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -34,6 +34,7 @@
 #include <linux/thermal.h>
 #include <linux/reboot.h>
 #include <linux/string.h>
+#include <linux/of.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
@@ -1055,7 +1056,8 @@ static struct class thermal_class = {
 };
 
 /**
- * thermal_cooling_device_register() - register a new thermal cooling device
+ * __thermal_cooling_device_register() - register a new thermal cooling device
+ * @np:		a pointer to a device tree node.
  * @type:	the thermal cooling device type.
  * @devdata:	device private data.
  * @ops:		standard thermal cooling devices callbacks.
@@ -1063,13 +1065,16 @@ static struct class thermal_class = {
  * This interface function adds a new thermal cooling device (fan/processor/...)
  * to /sys/class/thermal/ folder as cooling_device[0-*]. It tries to bind itself
  * to all the thermal zone devices registered at the same time.
+ * It also gives the opportunity to link the cooling device to a device tree
+ * node, so that it can be bound to a thermal zone created out of device tree.
  *
  * Return: a pointer to the created struct thermal_cooling_device or an
  * ERR_PTR. Caller must check return value with IS_ERR*() helpers.
  */
-struct thermal_cooling_device *
-thermal_cooling_device_register(char *type, void *devdata,
-				const struct thermal_cooling_device_ops *ops)
+static struct thermal_cooling_device *
+__thermal_cooling_device_register(struct device_node *np,
+				  char *type, void *devdata,
+				  const struct thermal_cooling_device_ops *ops)
 {
 	struct thermal_cooling_device *cdev;
 	int result;
@@ -1094,6 +1099,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
 	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
+	cdev->np = np;
 	cdev->ops = ops;
 	cdev->updated = true;
 	cdev->device.class = &thermal_class;
@@ -1136,9 +1142,53 @@ unregister:
 	device_unregister(&cdev->device);
 	return ERR_PTR(result);
 }
+
+/**
+ * thermal_cooling_device_register() - register a new thermal cooling device
+ * @type:	the thermal cooling device type.
+ * @devdata:	device private data.
+ * @ops:		standard thermal cooling devices callbacks.
+ *
+ * This interface function adds a new thermal cooling device (fan/processor/...)
+ * to /sys/class/thermal/ folder as cooling_device[0-*]. It tries to bind itself
+ * to all the thermal zone devices registered at the same time.
+ *
+ * Return: a pointer to the created struct thermal_cooling_device or an
+ * ERR_PTR. Caller must check return value with IS_ERR*() helpers.
+ */
+struct thermal_cooling_device *
+thermal_cooling_device_register(char *type, void *devdata,
+				const struct thermal_cooling_device_ops *ops)
+{
+	return __thermal_cooling_device_register(NULL, type, devdata, ops);
+}
 EXPORT_SYMBOL_GPL(thermal_cooling_device_register);
 
 /**
+ * thermal_of_cooling_device_register() - register an OF thermal cooling device
+ * @np:		a pointer to a device tree node.
+ * @type:	the thermal cooling device type.
+ * @devdata:	device private data.
+ * @ops:		standard thermal cooling devices callbacks.
+ *
+ * This function will register a cooling device with device tree node reference.
+ * This interface function adds a new thermal cooling device (fan/processor/...)
+ * to /sys/class/thermal/ folder as cooling_device[0-*]. It tries to bind itself
+ * to all the thermal zone devices registered at the same time.
+ *
+ * Return: a pointer to the created struct thermal_cooling_device or an
+ * ERR_PTR. Caller must check return value with IS_ERR*() helpers.
+ */
+struct thermal_cooling_device *
+thermal_of_cooling_device_register(struct device_node *np,
+				   char *type, void *devdata,
+				   const struct thermal_cooling_device_ops *ops)
+{
+	return __thermal_cooling_device_register(np, type, devdata, ops);
+}
+EXPORT_SYMBOL_GPL(thermal_of_cooling_device_register);
+
+/**
  * thermal_cooling_device_unregister - removes the registered thermal cooling device
  * @cdev:	the thermal cooling device to remove.
  *
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index b780c5b..f7e11c7 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -25,6 +25,7 @@
 #ifndef __THERMAL_H__
 #define __THERMAL_H__
 
+#include <linux/of.h>
 #include <linux/idr.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
@@ -280,6 +281,9 @@ void thermal_zone_device_update(struct thermal_zone_device *);
 
 struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 		const struct thermal_cooling_device_ops *);
+struct thermal_cooling_device *
+thermal_of_cooling_device_register(struct device_node *np, char *, void *,
+				   const struct thermal_cooling_device_ops *);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
 struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *name);
 int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long *temp);
-- 
1.8.2.1.342.gfa7285d

