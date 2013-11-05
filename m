Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3KEDtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:49:03 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:49744 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3KEDsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:48:54 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: azael.avalos@gmail.com
Subject: [PATCH 5/8] toshiba_acpi: Add ECO led support
Date: Mon,  4 Nov 2013 20:48:42 -0700
Message-Id: <1383623325-4004-6-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
References: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Toshiba laptops now come with a feature called
ECO Mode, where the system is put in low power consupmtion
state and a green (world shaped with leaves) icon illuminates
indicating that the system is in such power state.

This patch adds support to turn on/off the ECO led by
creating and registering the toshiba::eco_mode led.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 66 +++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index f97f942..022c6e6 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -113,6 +113,7 @@ MODULE_LICENSE("GPL");
 #define HCI_LCD_BRIGHTNESS		0x002a
 #define HCI_WIRELESS			0x0056
 #define HCI_KBD_ILLUMINATION		0x0095
+#define HCI_ECO_MODE			0x0097
 #define SCI_ILLUMINATION		0x014e
 #define SCI_KBD_ILLUM_STATUS		0x015c
 
@@ -143,6 +144,7 @@ struct toshiba_acpi_dev {
 	struct backlight_device *backlight_dev;
 	struct led_classdev led_dev;
 	struct led_classdev kbd_led;
+	struct led_classdev eco_led;
 
 	int force_fan;
 	int last_key_event;
@@ -159,6 +161,7 @@ struct toshiba_acpi_dev {
 	unsigned int tr_backlight_supported:1;
 	unsigned int kbd_illum_supported:1;
 	unsigned int kbd_led_registered:1;
+	unsigned int eco_supported:1;
 	unsigned int sysfs_created:1;
 
 	struct mutex mutex;
@@ -538,6 +541,57 @@ static void toshiba_kbd_backlight_set(struct led_classdev *cdev,
 	}
 }
 
+/* Eco Mode support */
+static int toshiba_eco_mode_available(struct toshiba_acpi_dev *dev)
+{
+	acpi_status status;
+	u32 in[HCI_WORDS] = { HCI_GET, HCI_ECO_MODE, 0, 1, 0, 0 };
+	u32 out[HCI_WORDS];
+
+	status = hci_raw(dev, in, out);
+	if (ACPI_FAILURE(status) || out[0] == INPUT_DATA_ERROR) {
+		pr_info("ACPI call to get ECO led failed\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static enum led_brightness toshiba_eco_mode_get_status(struct led_classdev *cdev)
+{
+	struct toshiba_acpi_dev *dev = container_of(cdev,
+			struct toshiba_acpi_dev, eco_led);
+	u32 in[HCI_WORDS] = { HCI_GET, HCI_ECO_MODE, 0, 1, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status;
+
+	status = hci_raw(dev, in, out);
+	if (ACPI_FAILURE(status) || out[0] == INPUT_DATA_ERROR) {
+		pr_err("ACPI call to get ECO led failed\n");
+		return LED_OFF;
+	}
+
+	return out[2] ? LED_FULL : LED_OFF;
+}
+
+static void toshiba_eco_mode_set_status(struct led_classdev *cdev,
+				     enum led_brightness brightness)
+{
+	struct toshiba_acpi_dev *dev = container_of(cdev,
+			struct toshiba_acpi_dev, eco_led);
+	u32 in[HCI_WORDS] = { HCI_SET, HCI_ECO_MODE, 0, 1, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status;
+
+	/* Switch the Eco Mode led on/off */
+	in[2] = (brightness) ? 1 : 0;
+	status = hci_raw(dev, in, out);
+	if (ACPI_FAILURE(status) || out[0] == INPUT_DATA_ERROR) {
+		pr_err("ACPI call to set ECO led failed\n");
+		return;
+	}
+}
+
 /* Bluetooth rfkill handlers */
 
 static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
@@ -1413,6 +1467,9 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 	if (dev->kbd_led_registered)
 		led_classdev_unregister(&dev->kbd_led);
 
+	if (dev->eco_supported)
+		led_classdev_unregister(&dev->eco_led);
+
 	if (dev->pf_dev)
 		platform_device_unregister(dev->pf_dev);
 
@@ -1515,6 +1572,15 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 			dev->illumination_supported = 1;
 	}
 
+	if (toshiba_eco_mode_available(dev)) {
+		dev->eco_led.name = "toshiba::eco_mode";
+		dev->eco_led.max_brightness = 1;
+		dev->eco_led.brightness_set = toshiba_eco_mode_set_status;
+		dev->eco_led.brightness_get = toshiba_eco_mode_get_status;
+		if (!led_classdev_register(&dev->pf_dev->dev, &dev->eco_led))
+			dev->eco_supported = 1;
+	}
+
 	ret = toshiba_kbd_illum_status_get(dev, &dummy);
 	if (!ret) {
 		dev->kbd_time = dummy >> HCI_MISC_SHIFT;
-- 
1.8.1.4

