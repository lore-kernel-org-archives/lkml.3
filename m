Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaCYKxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:53:33 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38234 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaCYKuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:50:16 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mark.hambleton@broadcom.com, mark.brown@linaro.org,
        eduardo.valentin@ti.com, mporter@linaro.org, lsk-interest@linaro.org,
        linaro-kernel@linaro.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Shi <alex.shi@linaro.org>
Subject: [PATCH 05/19] thermal: core: introduce thermal_of_cooling_device_register
Date: Tue, 25 Mar 2014 18:49:18 +0800
Message-Id: <1395744572-20014-6-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395744572-20014-1-git-send-email-alex.shi@linaro.org>
References: <1395744572-20014-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@ti.com>

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
(cherry picked from commit a116b5d44f144586ef03a93f14ddc63f4a85e906)

Signed-off-by: Alex Shi <alex.shi@linaro.org>

Conflicts:
	drivers/thermal/thermal_core.c
---
 drivers/thermal/thermal_core.c | 59 +++++++++++++++++++++++++++++++++++++++---
 include/linux/thermal.h        |  4 +++
 2 files changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index ed5f765..916bde1 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -33,6 +33,8 @@
 #include <linux/idr.h>
 #include <linux/thermal.h>
 #include <linux/reboot.h>
+#include <linux/string.h>
+#include <linux/of.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
@@ -1037,7 +1039,8 @@ static struct class thermal_class = {
 };
 
 /**
- * thermal_cooling_device_register() - register a new thermal cooling device
+ * __thermal_cooling_device_register() - register a new thermal cooling device
+ * @np:		a pointer to a device tree node.
  * @type:	the thermal cooling device type.
  * @devdata:	device private data.
  * @ops:		standard thermal cooling devices callbacks.
@@ -1045,13 +1048,16 @@ static struct class thermal_class = {
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
@@ -1076,6 +1082,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
 	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
+	cdev->np = np;
 	cdev->ops = ops;
 	cdev->updated = true;
 	cdev->device.class = &thermal_class;
@@ -1118,9 +1125,53 @@ unregister:
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
index bd2533b..55fce47 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -25,6 +25,7 @@
 #ifndef __THERMAL_H__
 #define __THERMAL_H__
 
+#include <linux/of.h>
 #include <linux/idr.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
@@ -270,6 +271,9 @@ void thermal_zone_device_update(struct thermal_zone_device *);
 
 struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 		const struct thermal_cooling_device_ops *);
+struct thermal_cooling_device *
+thermal_of_cooling_device_register(struct device_node *np, char *, void *,
+				   const struct thermal_cooling_device_ops *);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
 struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *name);
 int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long *temp);
-- 
1.8.1.2

