Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaJTPdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:33:24 -0400
Received: from sauhun.de ([89.238.76.85]:56126 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbaJTPdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:33:20 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3/4] core: platform: let platform_create_bundle initialize module owner
Date: Mon, 20 Oct 2014 17:33:43 +0200
Message-Id: <1413819224-12677-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1413819224-12677-1-git-send-email-wsa@the-dreams.de>
References: <1413819224-12677-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 9447057eaff8 ("platform_device: use a macro instead of
platform_driver_register"), platform_driver_register() always overwrites
the .owner field of a platform_driver with THIS_MODULE. This breaks
platform_create_bundle() which uses it via platform_driver_probe() from
within the platform core instead of the module init. Fix it by using a
similar #define construct to obtain THIS_MODULE and pass it on later.

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/base/platform.c         | 11 ++++++-----
 include/linux/platform_device.h |  6 ++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c87a63326871..cdb6c076c3f7 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -637,24 +637,25 @@ int __init_or_module __platform_driver_probe(struct platform_driver *drv,
 EXPORT_SYMBOL_GPL(__platform_driver_probe);
 
 /**
- * platform_create_bundle - register driver and create corresponding device
+ * __platform_create_bundle - register driver and create corresponding device
  * @driver: platform driver structure
  * @probe: the driver probe routine, probably from an __init section
  * @res: set of resources that needs to be allocated for the device
  * @n_res: number of resources
  * @data: platform specific data for this platform device
  * @size: size of platform specific data
+ * @module: module which will be the owner of the driver
  *
  * Use this in legacy-style modules that probe hardware directly and
  * register a single platform device and corresponding platform driver.
  *
  * Returns &struct platform_device pointer on success, or ERR_PTR() on error.
  */
-struct platform_device * __init_or_module platform_create_bundle(
+struct platform_device * __init_or_module __platform_create_bundle(
 			struct platform_driver *driver,
 			int (*probe)(struct platform_device *),
 			struct resource *res, unsigned int n_res,
-			const void *data, size_t size)
+			const void *data, size_t size, struct module *module)
 {
 	struct platform_device *pdev;
 	int error;
@@ -677,7 +678,7 @@ struct platform_device * __init_or_module platform_create_bundle(
 	if (error)
 		goto err_pdev_put;
 
-	error = platform_driver_probe(driver, probe);
+	error = __platform_driver_probe(driver, probe, module);
 	if (error)
 		goto err_pdev_del;
 
@@ -690,7 +691,7 @@ err_pdev_put:
 err_out:
 	return ERR_PTR(error);
 }
-EXPORT_SYMBOL_GPL(platform_create_bundle);
+EXPORT_SYMBOL_GPL(__platform_create_bundle);
 
 /* modalias support enables more hands-off userspace setup:
  * (a) environment variable lets new-style hotplug events work once system is
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index c8d95c60da19..ae4882ca4a64 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -240,10 +240,12 @@ static void __exit __platform_driver##_exit(void) \
 } \
 module_exit(__platform_driver##_exit);
 
-extern struct platform_device *platform_create_bundle(
+#define platform_create_bundle(driver, probe, res, n_res, data, size) \
+	__platform_create_bundle(driver, probe, res, n_res, data, size, THIS_MODULE)
+extern struct platform_device *__platform_create_bundle(
 	struct platform_driver *driver, int (*probe)(struct platform_device *),
 	struct resource *res, unsigned int n_res,
-	const void *data, size_t size);
+	const void *data, size_t size, struct module *module);
 
 /* early platform driver interface */
 struct early_platform_driver {
-- 
2.0.0

