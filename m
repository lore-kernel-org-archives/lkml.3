Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934421Ab3CMW6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:58:11 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:43298 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934400Ab3CMW6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:58:06 -0400
From: Julius Werner <jwerner@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sameer Nanda <snanda@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: Make USB persist default configurable
Date: Wed, 13 Mar 2013 15:57:31 -0700
Message-Id: <1363215451-26111-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9214d1d8 set the USB persist flag as a default for all devices.
This might be desirable for some distributions, but it certainly has its
trade-offs... most importantly, it can significantly increase system
resume time, because the kernel blocks on resuming (and sometimes
resetting) USB devices before it unfreezes userspace.

This patch introduces a new config option CONFIG_USB_DEFAULT_PERSIST,
which allows distributions to make this decision on their own without
the need to carry a custom patch or revert the kernel's setting in
userspace.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/core/Kconfig  | 14 ++++++++++++++
 drivers/usb/core/quirks.c | 16 +++++-----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index f70c1a1..dfc1360 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -27,6 +27,20 @@ config USB_ANNOUNCE_NEW_DEVICES
 comment "Miscellaneous USB options"
 	depends on USB
 
+config USB_DEFAULT_PERSIST
+	bool "Enable USB persist by default"
+	depends on USB
+	default y
+	help
+	  Say N here if you don't want USB power session persistance
+	  enabled by default. This will make suspended USB devices that
+	  lose power get reenumerated as if they had been unplugged,
+	  but may reduce your system's resume time and eliminates any
+	  chance of file system corruption by confusing two devices with
+	  the same vendor and product ID. The persist feature can still
+	  be enabled for individual devices through the power/persist
+	  sysfs node. See Documentation/usb/persist.txt for more info.
+
 config USB_DYNAMIC_MINORS
 	bool "Dynamic USB minor allocation"
 	depends on USB
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 3113c1d..ab5638d 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -201,20 +201,14 @@ void usb_detect_quirks(struct usb_device *udev)
 		dev_dbg(&udev->dev, "USB quirks for this device: %x\n",
 			udev->quirks);
 
-	/* For the present, all devices default to USB-PERSIST enabled */
-#if 0		/* was: #ifdef CONFIG_PM */
-	/* Hubs are automatically enabled for USB-PERSIST */
-	if (udev->descriptor.bDeviceClass == USB_CLASS_HUB)
+#ifdef CONFIG_USB_DEFAULT_PERSIST
+	if (!(udev->quirks & USB_QUIRK_RESET))
 		udev->persist_enabled = 1;
-
 #else
-	/* In the absence of PM, we can safely enable USB-PERSIST
-	 * for all devices.  It will affect things like hub resets
-	 * and EMF-related port disables.
-	 */
-	if (!(udev->quirks & USB_QUIRK_RESET))
+	/* Hubs are automatically enabled for USB-PERSIST */
+	if (udev->descriptor.bDeviceClass == USB_CLASS_HUB)
 		udev->persist_enabled = 1;
-#endif	/* CONFIG_PM */
+#endif	/* CONFIG_USB_DEFAULT_PERSIST */
 }
 
 void usb_detect_interface_quirks(struct usb_device *udev)
-- 
1.7.12.4

