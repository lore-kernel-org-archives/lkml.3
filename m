Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaHULeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:34:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:29700 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbaHULeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="591291325"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 5/6] base: platform: name the device already during allocation
Date: Thu, 21 Aug 2014 14:33:22 +0300
Message-Id: <1408620803-10464-6-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device name is needed when assigning resources like
clocks or GPIOs to devices using lookups. If
PLATFORM_DEVICE_AUTO is used, the device name is not know
before platform_device_add is called after which it's too
late to assign that kind of resources as the drivers most
likely have already requested them.

By naming the device already in platform_device_alloc, the
resources can be assigned before platform_device_add is
called.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/platform.c | 69 +++++++++++++++++++++++++++++--------------------
 1 file changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ab4f4ce..d3a7022 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -194,11 +194,41 @@ void platform_device_put(struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(platform_device_put);
 
+static int pdev_set_name(struct platform_device *pdev)
+{
+	int ret;
+
+	switch (pdev->id) {
+	default:
+		return dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
+	case PLATFORM_DEVID_NONE:
+		return dev_set_name(&pdev->dev, "%s", pdev->name);
+	case PLATFORM_DEVID_AUTO:
+		/*
+		 * Automatically allocated device ID. We mark it as such so
+		 * that we remember it must be freed, and we append a suffix
+		 * to avoid namespace collision with explicit IDs.
+		 */
+		ret = ida_simple_get(&platform_devid_ida, 0, 0, GFP_KERNEL);
+		if (ret < 0)
+			return ret;
+		pdev->id = ret;
+		pdev->id_auto = true;
+		return dev_set_name(&pdev->dev, "%s.%d.auto", pdev->name,
+				    pdev->id);
+	}
+
+	return 0;
+}
+
 static void platform_device_release(struct device *dev)
 {
 	struct platform_object *pa = container_of(dev, struct platform_object,
 						  pdev.dev);
 
+	if (pa->pdev.id_auto)
+		ida_simple_remove(&platform_devid_ida, pa->pdev.id);
+
 	of_device_node_put(&pa->pdev.dev);
 	kfree(pa->pdev.dev.platform_data);
 	kfree(pa->pdev.mfd_cell);
@@ -227,6 +257,10 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
 		arch_setup_pdev_archdata(&pa->pdev);
+		if (pdev_set_name(&pa->pdev)) {
+			kfree(pa);
+			return NULL;
+		}
 	}
 
 	return pa ? &pa->pdev : NULL;
@@ -307,28 +341,6 @@ int platform_device_add(struct platform_device *pdev)
 
 	pdev->dev.bus = &platform_bus_type;
 
-	switch (pdev->id) {
-	default:
-		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
-		break;
-	case PLATFORM_DEVID_NONE:
-		dev_set_name(&pdev->dev, "%s", pdev->name);
-		break;
-	case PLATFORM_DEVID_AUTO:
-		/*
-		 * Automatically allocated device ID. We mark it as such so
-		 * that we remember it must be freed, and we append a suffix
-		 * to avoid namespace collision with explicit IDs.
-		 */
-		ret = ida_simple_get(&platform_devid_ida, 0, 0, GFP_KERNEL);
-		if (ret < 0)
-			goto err_out;
-		pdev->id = ret;
-		pdev->id_auto = true;
-		dev_set_name(&pdev->dev, "%s.%d.auto", pdev->name, pdev->id);
-		break;
-	}
-
 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
 
@@ -371,7 +383,6 @@ int platform_device_add(struct platform_device *pdev)
 			release_resource(r);
 	}
 
- err_out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(platform_device_add);
@@ -391,11 +402,6 @@ void platform_device_del(struct platform_device *pdev)
 	if (pdev) {
 		device_del(&pdev->dev);
 
-		if (pdev->id_auto) {
-			ida_simple_remove(&platform_devid_ida, pdev->id);
-			pdev->id = PLATFORM_DEVID_AUTO;
-		}
-
 		for (i = 0; i < pdev->num_resources; i++) {
 			struct resource *r = &pdev->resource[i];
 			unsigned long type = resource_type(r);
@@ -413,8 +419,15 @@ EXPORT_SYMBOL_GPL(platform_device_del);
  */
 int platform_device_register(struct platform_device *pdev)
 {
+	int ret;
+
 	device_initialize(&pdev->dev);
 	arch_setup_pdev_archdata(pdev);
+
+	ret = pdev_set_name(pdev);
+	if (ret)
+		return ret;
+
 	return platform_device_add(pdev);
 }
 EXPORT_SYMBOL_GPL(platform_device_register);
-- 
2.1.0

