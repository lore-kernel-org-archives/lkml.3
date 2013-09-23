Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3IWIvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:51:12 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:42689 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3IWIvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:51:11 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, Mark Brown <broonie@linaro.org>,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] driver core: prevent deferred probe with platform_driver_probe
Date: Mon, 23 Sep 2013 10:48:47 +0200
Message-Id: <1379926127-8935-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent drivers relying on platform_driver_probe from requesting
deferred probing in order to avoid further futile probe attempts (either
the driver has been unregistered or its probe function has been set to
platform_drv_probe_fail when probing is retried).

Note that several platform drivers currently return subsystem errors
from probe and that these can include -EPROBE_DEFER (e.g. if a gpio
request fails).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/base/platform.c         | 17 +++++++++++++----
 include/linux/platform_device.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4f8bef3..47051cd 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -488,6 +488,11 @@ static int platform_drv_probe(struct device *_dev)
 	if (ret && ACPI_HANDLE(_dev))
 		acpi_dev_pm_detach(_dev, true);
 
+	if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
+		dev_warn(_dev, "probe deferral not supported\n");
+		ret = -ENXIO;
+	}
+
 	return ret;
 }
 
@@ -553,8 +558,7 @@ EXPORT_SYMBOL_GPL(platform_driver_unregister);
 /**
  * platform_driver_probe - register driver for non-hotpluggable device
  * @drv: platform driver structure
- * @probe: the driver probe routine, probably from an __init section,
- *         must not return -EPROBE_DEFER.
+ * @probe: the driver probe routine, probably from an __init section
  *
  * Use this instead of platform_driver_register() when you know the device
  * is not hotpluggable and has already been registered, and you want to
@@ -565,8 +569,7 @@ EXPORT_SYMBOL_GPL(platform_driver_unregister);
  * into system-on-chip processors, where the controller devices have been
  * configured as part of board setup.
  *
- * This is incompatible with deferred probing so probe() must not
- * return -EPROBE_DEFER.
+ * Note that this is incompatible with deferred probing.
  *
  * Returns zero if the driver registered and bound to a device, else returns
  * a negative error code and with the driver not registered.
@@ -576,6 +579,12 @@ int __init_or_module platform_driver_probe(struct platform_driver *drv,
 {
 	int retval, code;
 
+	/*
+	 * Prevent driver from requesting probe deferral to avoid further
+	 * futile probe attempts.
+	 */
+	drv->prevent_deferred_probe = true;
+
 	/* make sure driver won't have bind/unbind attributes */
 	drv->driver.suppress_bind_attrs = true;
 
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index ce8e4ff..16f6654 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -178,6 +178,7 @@ struct platform_driver {
 	int (*resume)(struct platform_device *);
 	struct device_driver driver;
 	const struct platform_device_id *id_table;
+	bool prevent_deferred_probe;
 };
 
 #define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
-- 
1.8.3.2

