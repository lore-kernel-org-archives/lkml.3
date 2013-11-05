Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3KEDsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:48:55 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:65202 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3KEDsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:48:51 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: azael.avalos@gmail.com
Subject: [PATCH 3/8] toshiba_acpi: Add platform support
Date: Mon,  4 Nov 2013 20:48:40 -0700
Message-Id: <1383623325-4004-4-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
References: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add platform support and change the backlight
and led devices to register on it instead of the acpi_device.

The use of the platform is to have just one place where to
look for files instead of looking at the current three different
ACPI devices (TOS6200, TOS6208 and TOS1900) and thus making
userspace a bit easier.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index d7ecef3..226e0b5 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -54,6 +54,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/i8042.h>
+#include <linux/platform_device.h>
 
 #include <asm/uaccess.h>
 
@@ -129,6 +130,7 @@ MODULE_LICENSE("GPL");
 
 struct toshiba_acpi_dev {
 	struct acpi_device *acpi_dev;
+	struct platform_device *pf_dev;
 	const char *method_hci;
 	struct rfkill *bt_rfk;
 	struct input_dev *hotkey_dev;
@@ -1156,7 +1158,7 @@ static int toshiba_acpi_setup_backlight(struct toshiba_acpi_dev *dev)
 		props.max_brightness++;
 
 	dev->backlight_dev = backlight_device_register("toshiba",
-						       &dev->acpi_dev->dev,
+						       &dev->pf_dev->dev,
 						       dev,
 						       &toshiba_backlight_data,
 						       &props);
@@ -1198,6 +1200,9 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 	if (dev->illumination_supported)
 		led_classdev_unregister(&dev->led_dev);
 
+	if (dev->pf_dev)
+		platform_device_unregister(dev->pf_dev);
+
 	if (toshiba_acpi)
 		toshiba_acpi = NULL;
 
@@ -1249,6 +1254,15 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 	dev->method_hci = hci_method;
 	acpi_dev->driver_data = dev;
 
+	dev->pf_dev = platform_device_register_simple("toshiba", -1, NULL, 0);
+	if (IS_ERR(dev->pf_dev)) {
+		ret = PTR_ERR(dev->pf_dev);
+		pr_err("Unable to register platform device\n");
+		kfree(dev);
+		return ret;
+	}
+	platform_set_drvdata(dev->pf_dev, dev);
+
 	if (toshiba_acpi_setup_keyboard(dev))
 		pr_info("Unable to activate hotkeys\n");
 
@@ -1284,7 +1298,7 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 		dev->led_dev.max_brightness = 1;
 		dev->led_dev.brightness_set = toshiba_illumination_set;
 		dev->led_dev.brightness_get = toshiba_illumination_get;
-		if (!led_classdev_register(&acpi_dev->dev, &dev->led_dev))
+		if (!led_classdev_register(&dev->pf_dev->dev, &dev->led_dev))
 			dev->illumination_supported = 1;
 	}
 
@@ -1388,6 +1402,13 @@ static struct acpi_driver toshiba_acpi_driver = {
 	.drv.pm	= &toshiba_acpi_pm,
 };
 
+static struct platform_driver platform_driver = {
+	.driver = {
+		.name = "toshiba",
+		.owner = THIS_MODULE,
+	},
+};
+
 static int __init toshiba_acpi_init(void)
 {
 	int ret;
@@ -1406,6 +1427,12 @@ static int __init toshiba_acpi_init(void)
 		return -ENODEV;
 	}
 
+	ret = platform_driver_register(&platform_driver);
+	if (ret < 0) {
+		pr_err("Failed to register platform driver: %d\n", ret);
+		return ret;
+	}
+
 	ret = acpi_bus_register_driver(&toshiba_acpi_driver);
 	if (ret) {
 		pr_err("Failed to register ACPI driver: %d\n", ret);
@@ -1418,6 +1445,7 @@ static int __init toshiba_acpi_init(void)
 static void __exit toshiba_acpi_exit(void)
 {
 	acpi_bus_unregister_driver(&toshiba_acpi_driver);
+	platform_driver_unregister(&platform_driver);
 	if (toshiba_proc_dir)
 		remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);
 }
-- 
1.8.1.4

