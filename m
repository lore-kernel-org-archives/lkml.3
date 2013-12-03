Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3LCI3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:29:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:50305 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab3LCI3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:29:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445878203"
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ACPI / fan: convert to platform driver
Date: Tue,  3 Dec 2013 16:28:32 +0800
Message-Id: <1386059312-2990-5-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
References: <1386059312-2990-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ACPI fan driver to a platform driver for the purpose of phasing
out ACPI bus.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/acpi_platform.c |  3 +++
 drivers/acpi/fan.c           | 63 ++++++++++++++++++++------------------------
 2 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index dbfe49e5fd63..69e5317c7753 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -37,6 +37,9 @@ static const struct acpi_device_id acpi_platform_device_ids[] = {
 	{ "INT33C8" },
 	{ "80860F28" },
 
+	/* ACPI fan device */
+	{ "PNP0C0B" },
+
 	{ }
 };
 
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 8683bed14dac..78b054ee245c 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -30,18 +30,14 @@
 #include <asm/uaccess.h>
 #include <linux/thermal.h>
 #include <linux/acpi.h>
-
-#define PREFIX "ACPI: "
-
-#define ACPI_FAN_CLASS			"fan"
-#define ACPI_FAN_FILE_STATE		"state"
+#include <linux/platform_device.h>
 
 MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI Fan Driver");
 MODULE_LICENSE("GPL");
 
-static int acpi_fan_add(struct acpi_device *device);
-static int acpi_fan_remove(struct acpi_device *device);
+static int acpi_fan_probe(struct platform_device *pdev);
+static int acpi_fan_remove(struct platform_device *pdev);
 
 static const struct acpi_device_id fan_device_ids[] = {
 	{"PNP0C0B", 0},
@@ -55,15 +51,14 @@ static int acpi_fan_resume(struct device *dev);
 #endif
 static SIMPLE_DEV_PM_OPS(acpi_fan_pm, acpi_fan_suspend, acpi_fan_resume);
 
-static struct acpi_driver acpi_fan_driver = {
-	.name = "fan",
-	.class = ACPI_FAN_CLASS,
-	.ids = fan_device_ids,
-	.ops = {
-		.add = acpi_fan_add,
-		.remove = acpi_fan_remove,
-		},
-	.drv.pm = &acpi_fan_pm,
+static struct platform_driver acpi_fan_driver = {
+	.probe = acpi_fan_probe,
+	.remove = acpi_fan_remove,
+	.driver = {
+		.name = "acpi-fan",
+		.acpi_match_table = fan_device_ids,
+		.pm = &acpi_fan_pm,
+	},
 };
 
 /* thermal cooling device callbacks */
@@ -119,17 +114,15 @@ static const struct thermal_cooling_device_ops fan_cooling_ops = {
                                  Driver Interface
    -------------------------------------------------------------------------- */
 
-static int acpi_fan_add(struct acpi_device *device)
+static int acpi_fan_probe(struct platform_device *pdev)
 {
 	int result = 0;
 	struct thermal_cooling_device *cdev;
-
-	strcpy(acpi_device_name(device), "Fan");
-	strcpy(acpi_device_class(device), ACPI_FAN_CLASS);
+	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
 
 	result = acpi_device_update_power(device, NULL);
 	if (result) {
-		printk(KERN_ERR PREFIX "Setting initial power state\n");
+		dev_err(&pdev->dev, "Setting initial power state\n");
 		goto end;
 	}
 
@@ -140,24 +133,24 @@ static int acpi_fan_add(struct acpi_device *device)
 		goto end;
 	}
 
-	dev_dbg(&device->dev, "registered as cooling_device%d\n", cdev->id);
+	dev_dbg(&pdev->dev, "registered as cooling_device%d\n", cdev->id);
 
-	device->driver_data = cdev;
-	result = sysfs_create_link(&device->dev.kobj,
+	platform_set_drvdata(pdev, cdev);
+	result = sysfs_create_link(&pdev->dev.kobj,
 				   &cdev->device.kobj,
 				   "thermal_cooling");
 	if (result)
-		dev_err(&device->dev, "Failed to create sysfs link "
+		dev_err(&pdev->dev, "Failed to create sysfs link "
 			"'thermal_cooling'\n");
 
 	result = sysfs_create_link(&cdev->device.kobj,
-				   &device->dev.kobj,
+				   &pdev->dev.kobj,
 				   "device");
 	if (result)
-		dev_err(&device->dev, "Failed to create sysfs link "
+		dev_err(&pdev->dev, "Failed to create sysfs link "
 			"'device'\n");
 
-	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
+	dev_info(&pdev->dev, "%s [%s] (%s)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
 	       !device->power.state ? "on" : "off");
 
@@ -165,11 +158,11 @@ end:
 	return result;
 }
 
-static int acpi_fan_remove(struct acpi_device *device)
+static int acpi_fan_remove(struct platform_device *pdev)
 {
-	struct thermal_cooling_device *cdev = acpi_driver_data(device);
+	struct thermal_cooling_device *cdev = platform_get_drvdata(pdev);
 
-	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+	sysfs_remove_link(&pdev->dev.kobj, "thermal_cooling");
 	sysfs_remove_link(&cdev->device.kobj, "device");
 	thermal_cooling_device_unregister(cdev);
 
@@ -179,7 +172,7 @@ static int acpi_fan_remove(struct acpi_device *device)
 #ifdef CONFIG_PM_SLEEP
 static int acpi_fan_suspend(struct device *dev)
 {
-	acpi_device_set_power(to_acpi_device(dev), ACPI_STATE_D0);
+	acpi_device_set_power(ACPI_COMPANION(dev), ACPI_STATE_D0);
 
 	return AE_OK;
 }
@@ -188,12 +181,12 @@ static int acpi_fan_resume(struct device *dev)
 {
 	int result;
 
-	result = acpi_device_update_power(to_acpi_device(dev), NULL);
+	result = acpi_device_update_power(ACPI_COMPANION(dev), NULL);
 	if (result)
-		printk(KERN_ERR PREFIX "Error updating fan power state\n");
+		dev_err(dev, "Error updating fan power state\n");
 
 	return result;
 }
 #endif
 
-module_acpi_driver(acpi_fan_driver);
+module_platform_driver(acpi_fan_driver);
-- 
1.8.3.1

