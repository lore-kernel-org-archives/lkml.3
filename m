Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaJTPdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:33:53 -0400
Received: from sauhun.de ([89.238.76.85]:56123 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaJTPdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:33:18 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 2/4] core: platform: let platform_driver_probe initialize module owner
Date: Mon, 20 Oct 2014 17:33:42 +0200
Message-Id: <1413819224-12677-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1413819224-12677-1-git-send-email-wsa@the-dreams.de>
References: <1413819224-12677-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 9447057eaff8 ("platform_device: use a macro instead of
platform_driver_register"), platform_driver_register() always overwrites
the .owner field of a platform_driver with THIS_MODULE. This breaks
platform_driver_probe() which uses it from within the platform core
instead of the module init. Fix it by using a similar #define construct
to obtain THIS_MODULE and pass it on later.

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/base/platform.c         | 11 ++++++-----
 include/linux/platform_device.h |  6 ++++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index b2afc29403f9..c87a63326871 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -580,9 +580,10 @@ void platform_driver_unregister(struct platform_driver *drv)
 EXPORT_SYMBOL_GPL(platform_driver_unregister);
 
 /**
- * platform_driver_probe - register driver for non-hotpluggable device
+ * __platform_driver_probe - register driver for non-hotpluggable device
  * @drv: platform driver structure
  * @probe: the driver probe routine, probably from an __init section
+ * @module: module which will be the owner of the driver
  *
  * Use this instead of platform_driver_register() when you know the device
  * is not hotpluggable and has already been registered, and you want to
@@ -598,8 +599,8 @@ EXPORT_SYMBOL_GPL(platform_driver_unregister);
  * Returns zero if the driver registered and bound to a device, else returns
  * a negative error code and with the driver not registered.
  */
-int __init_or_module platform_driver_probe(struct platform_driver *drv,
-		int (*probe)(struct platform_device *))
+int __init_or_module __platform_driver_probe(struct platform_driver *drv,
+		int (*probe)(struct platform_device *), struct module *module)
 {
 	int retval, code;
 
@@ -614,7 +615,7 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 
 	/* temporary section violation during probe() */
 	drv->probe = probe;
-	retval = code = platform_driver_register(drv);
+	retval = code = __platform_driver_register(drv, module);
 
 	/*
 	 * Fixup that section violation, being paranoid about code scanning
@@ -633,7 +634,7 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 		platform_driver_unregister(drv);
 	return retval;
 }
-EXPORT_SYMBOL_GPL(platform_driver_probe);
+EXPORT_SYMBOL_GPL(__platform_driver_probe);
 
 /**
  * platform_create_bundle - register driver and create corresponding device
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 153d303af7eb..c8d95c60da19 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -197,8 +197,10 @@ extern void platform_driver_unregister(struct platform_driver *);
 /* non-hotpluggable platform devices may use this so that probe() and
  * its support may live in __init sections, conserving runtime memory.
  */
-extern int platform_driver_probe(struct platform_driver *driver,
-		int (*probe)(struct platform_device *));
+#define platform_driver_probe(drv, probe) \
+	__platform_driver_probe(drv, probe, THIS_MODULE)
+extern int __platform_driver_probe(struct platform_driver *driver,
+		int (*probe)(struct platform_device *), struct module *module);
 
 static inline void *platform_get_drvdata(const struct platform_device *pdev)
 {
-- 
2.0.0

