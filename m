Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbASBbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:31:13 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61522 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbbASBbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:31:10 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 3/4] toshiba_acpi: Add support for USB Rapid Charge
Date: Sun, 18 Jan 2015 18:30:24 -0700
Message-Id: <1421631025-27895-4-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421631025-27895-1-git-send-email-coproscefalo@gmail.com>
References: <1421631025-27895-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Toshiba laptops equipped with USB 3.0 ports now have the
functionality of rapid charging devices connected to their USB hubs.

This patch adds support to use such feature by creating a sysfs entry
named "usb_rapid_charge", accepting only two values, 0 to disable and
1 to enable, however, the machine needs a restart everytime the
function is toggled.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 107 ++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 3b6e952..ab08d00 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -155,6 +155,7 @@ MODULE_LICENSE("GPL");
 #define SCI_USB_CHARGE_BAT_LVL_OFF	0x1
 #define SCI_USB_CHARGE_BAT_LVL_ON	0x4
 #define SCI_USB_CHARGE_BAT_LVL		0x0200
+#define SCI_USB_CHARGE_RAPID_DSP	0x0300
 
 struct toshiba_acpi_dev {
 	struct acpi_device *acpi_dev;
@@ -188,6 +189,7 @@ struct toshiba_acpi_dev {
 	unsigned int eco_supported:1;
 	unsigned int accelerometer_supported:1;
 	unsigned int usb_sleep_charge_supported:1;
+	unsigned int usb_rapid_charge_supported:1;
 	unsigned int sysfs_created:1;
 
 	struct mutex mutex;
@@ -874,6 +876,60 @@ static int toshiba_sleep_functions_status_set(struct toshiba_acpi_dev *dev,
 	return 0;
 }
 
+static int toshiba_usb_rapid_charge_get(struct toshiba_acpi_dev *dev,
+					u32 *state)
+{
+	u32 in[TCI_WORDS] = { SCI_GET, SCI_USB_SLEEP_CHARGE, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	in[5] = SCI_USB_CHARGE_RAPID_DSP;
+	status = tci_raw(dev, in, out);
+	sci_close(dev);
+	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
+		pr_err("ACPI call to get USB S&C battery level failed\n");
+		return -EIO;
+	} else if (out[0] == TOS_NOT_SUPPORTED ||
+		   out[0] == TOS_INPUT_DATA_ERROR) {
+		pr_info("USB Sleep and Charge not supported\n");
+		return -ENODEV;
+	}
+
+	*state = out[2];
+
+	return 0;
+}
+
+static int toshiba_usb_rapid_charge_set(struct toshiba_acpi_dev *dev,
+					u32 state)
+{
+	u32 in[TCI_WORDS] = { SCI_SET, SCI_USB_SLEEP_CHARGE, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	in[2] = state;
+	in[5] = SCI_USB_CHARGE_RAPID_DSP;
+	status = tci_raw(dev, in, out);
+	sci_close(dev);
+	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
+		pr_err("ACPI call to set USB S&C battery level failed\n");
+		return -EIO;
+	} else if (out[0] == TOS_NOT_SUPPORTED) {
+		pr_info("USB Sleep and Charge not supported\n");
+		return -ENODEV;
+	} else if (out[0] == TOS_INPUT_DATA_ERROR) {
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /* Bluetooth rfkill handlers */
 
 static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
@@ -1439,6 +1495,12 @@ static ssize_t sleep_functions_on_battery_show(struct device *dev,
 static ssize_t sleep_functions_on_battery_store(struct device *dev,
 						struct device_attribute *attr,
 						const char *buf, size_t count);
+static ssize_t toshiba_usb_rapid_charge_show(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf);
+static ssize_t toshiba_usb_rapid_charge_store(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf, size_t count);
 
 static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
@@ -1456,6 +1518,9 @@ static DEVICE_ATTR(usb_sleep_charge, S_IRUGO | S_IWUSR,
 static DEVICE_ATTR(sleep_functions_on_battery, S_IRUGO | S_IWUSR,
 		   sleep_functions_on_battery_show,
 		   sleep_functions_on_battery_store);
+static DEVICE_ATTR(usb_rapid_charge, S_IRUGO | S_IWUSR,
+		   toshiba_usb_rapid_charge_show,
+		   toshiba_usb_rapid_charge_store);
 
 static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_mode.attr,
@@ -1466,6 +1531,7 @@ static struct attribute *toshiba_attributes[] = {
 	&dev_attr_position.attr,
 	&dev_attr_usb_sleep_charge.attr,
 	&dev_attr_sleep_functions_on_battery.attr,
+	&dev_attr_usb_rapid_charge.attr,
 	NULL,
 };
 
@@ -1794,6 +1860,42 @@ static ssize_t sleep_functions_on_battery_store(struct device *dev,
 	return count;
 }
 
+static ssize_t toshiba_usb_rapid_charge_show(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 state;
+	int ret;
+
+	ret = toshiba_usb_rapid_charge_get(toshiba, &state);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", state);
+}
+
+static ssize_t toshiba_usb_rapid_charge_store(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf, size_t count)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	int state;
+	int ret;
+
+	ret = kstrtoint(buf, 0, &state);
+	if (ret)
+		return ret;
+	if (state != 0 && state != 1)
+		return -EINVAL;
+
+	ret = toshiba_usb_rapid_charge_set(toshiba, state);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
 static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 					struct attribute *attr, int idx)
 {
@@ -1813,6 +1915,8 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 		exists = (drv->usb_sleep_charge_supported) ? true : false;
 	else if (attr == &dev_attr_sleep_functions_on_battery.attr)
 		exists = (drv->usb_sleep_charge_supported) ? true : false;
+	else if (attr == &dev_attr_usb_rapid_charge.attr)
+		exists = (drv->usb_rapid_charge_supported) ? true : false;
 
 	return exists ? attr->mode : 0;
 }
@@ -2225,6 +2329,9 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 	ret = toshiba_usb_sleep_charge_get(dev, &dummy);
 	dev->usb_sleep_charge_supported = !ret;
 
+	ret = toshiba_usb_rapid_charge_get(dev, &dummy);
+	dev->usb_rapid_charge_supported = !ret;
+
 	/* Determine whether or not BIOS supports fan and video interfaces */
 
 	ret = get_video_status(dev, &dummy);
-- 
2.2.1

