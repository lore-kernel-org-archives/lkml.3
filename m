Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbaD1MJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:09:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:8470 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbaD1MJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,943,1389772800"; 
   d="scan'208";a="529792167"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, Jean Delvare <khali@linux-fr.org>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] base: platform: name the device already during allocation
Date: Mon, 28 Apr 2014 15:09:27 +0300
Message-Id: <1398686967-6086-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows resources such as GPIOs and clocks, which can be
matched based on the device name when requested, to be
assigned even when PLATFORM_DEVID_AUTO is used.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/base/platform.c | 77 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 30 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 5b47210..697896d 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -174,11 +174,45 @@ struct platform_object {
  */
 void platform_device_put(struct platform_device *pdev)
 {
-	if (pdev)
-		put_device(&pdev->dev);
+	if (!pdev)
+		return;
+
+	if (pdev->id_auto) {
+		ida_simple_remove(&platform_devid_ida, pdev->id);
+		pdev->id = PLATFORM_DEVID_AUTO;
+	}
+
+	put_device(&pdev->dev);
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
@@ -211,6 +245,10 @@ struct platform_device *platform_device_alloc(const char *name, int id)
 		device_initialize(&pa->pdev.dev);
 		pa->pdev.dev.release = platform_device_release;
 		arch_setup_pdev_archdata(&pa->pdev);
+		if (pdev_set_name(&pa->pdev)) {
+			kfree(pa);
+			return NULL;
+		}
 	}
 
 	return pa ? &pa->pdev : NULL;
@@ -291,28 +329,6 @@ int platform_device_add(struct platform_device *pdev)
 
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
 
@@ -355,7 +371,6 @@ int platform_device_add(struct platform_device *pdev)
 			release_resource(r);
 	}
 
- err_out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(platform_device_add);
@@ -375,11 +390,6 @@ void platform_device_del(struct platform_device *pdev)
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
@@ -397,8 +407,15 @@ EXPORT_SYMBOL_GPL(platform_device_del);
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
2.0.0.rc0

