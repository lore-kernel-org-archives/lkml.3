Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3A1RB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:01:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:20192 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab3A1RBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:01:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,553,1355126400"; 
   d="scan'208";a="279324842"
From: Lan Tianyu <tianyu.lan@intel.com>
To: gregkh@linuxfoundation.org, sfr@canb.auug.org.au
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "usb: Register usb port's acpi power resources"
Date: Tue, 29 Jan 2013 00:59:06 +0800
Message-Id: <1359392346-30321-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 88bb965ed711e8a5984e70208ebc901a6ff4141f.

The linux-next branch of linux-pm tree has replaced
acpi_power_resource_(un)register_device() with new routines.
Commit 88bb965 will cause conflict in the linux-next tree.
So revert it and this will not affect other functions. Will
send a new patch with new routines after 3.9 merge window.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/usb/core/port.c     |    6 ------
 drivers/usb/core/usb-acpi.c |   18 ------------------
 drivers/usb/core/usb.h      |    6 ------
 3 files changed, 30 deletions(-)

diff --git a/drivers/usb/core/port.c b/drivers/usb/core/port.c
index 5df143d..797f9d5 100644
--- a/drivers/usb/core/port.c
+++ b/drivers/usb/core/port.c
@@ -68,7 +68,6 @@ static void usb_port_device_release(struct device *dev)
 	struct usb_port *port_dev = to_usb_port(dev);
 
 	dev_pm_qos_hide_flags(dev);
-	usb_acpi_unregister_power_resources(dev);
 	kfree(port_dev);
 }
 
@@ -187,11 +186,6 @@ int usb_hub_create_port_device(struct usb_hub *hub, int port1)
 		pm_runtime_enable(&port_dev->dev);
 
 	device_enable_async_suspend(&port_dev->dev);
-
-	retval = usb_acpi_register_power_resources(&port_dev->dev);
-	if (retval && retval != -ENODEV)
-		dev_warn(&port_dev->dev, "the port can't register its ACPI power resource.\n");
-
 	return 0;
 
 error_register:
diff --git a/drivers/usb/core/usb-acpi.c b/drivers/usb/core/usb-acpi.c
index 8d304b0..cef4252 100644
--- a/drivers/usb/core/usb-acpi.c
+++ b/drivers/usb/core/usb-acpi.c
@@ -216,24 +216,6 @@ static struct acpi_bus_type usb_acpi_bus = {
 	.find_device = usb_acpi_find_device,
 };
 
-int usb_acpi_register_power_resources(struct device *dev)
-{
-	acpi_handle port_handle = DEVICE_ACPI_HANDLE(dev);
-
-	if (!port_handle)
-		return -ENODEV;
-
-	return acpi_power_resource_register_device(dev, port_handle);
-}
-
-void usb_acpi_unregister_power_resources(struct device *dev)
-{
-	acpi_handle port_handle = DEVICE_ACPI_HANDLE(dev);
-
-	if (port_handle)
-		acpi_power_resource_unregister_device(dev, port_handle);
-}
-
 int usb_acpi_register(void)
 {
 	return register_acpi_bus_type(&usb_acpi_bus);
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index 601b044..a7f20bd 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -191,13 +191,7 @@ extern int usb_acpi_register(void);
 extern void usb_acpi_unregister(void);
 extern acpi_handle usb_get_hub_port_acpi_handle(struct usb_device *hdev,
 	int port1);
-extern int usb_acpi_register_power_resources(struct device *dev);
-extern void usb_acpi_unregister_power_resources(struct device *dev);
 #else
 static inline int usb_acpi_register(void) { return 0; };
 static inline void usb_acpi_unregister(void) { };
-static inline int usb_acpi_register_power_resources(struct device *dev)
-	{ return 0; };
-static inline void usb_acpi_unregister_power_resources(struct device *dev)
-	{ };
 #endif
-- 
1.7.9.5

