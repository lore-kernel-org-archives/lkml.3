Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbbANVlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:41:12 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54373 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbbANVka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:40:30 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 2/4] toshiba_acpi: Add support for USB Sleep functions under battery
Date: Wed, 14 Jan 2015 14:40:19 -0700
Message-Id: <1421271621-8330-3-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421271621-8330-1-git-send-email-coproscefalo@gmail.com>
References: <1421271621-8330-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiba laptops supporting USB Sleep and Charge also come with a
feature called "USB functions under battery", which what it does when
enabled, is allows the USB Sleep functions when the computer is under
battery power.

This patch adds support to that function, creating a sysfs entry
named "sleep_functions_on_battery", accepting values from 0-100,
where zero disables the function and 1-100 sets the battery level at
which point the USB Sleep functions will be disabled, and printing
the current state of the functon and also the battery level currently
set.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 133 ++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index b03129d..9e054c5 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -151,6 +151,10 @@ MODULE_LICENSE("GPL");
 #define SCI_USB_CHARGE_DISABLED		0x30000
 #define SCI_USB_CHARGE_ALTERNATE	0x30009
 #define SCI_USB_CHARGE_AUTO		0x30021
+#define SCI_USB_CHARGE_BAT_MASK		0x7
+#define SCI_USB_CHARGE_BAT_LVL_OFF	0x1
+#define SCI_USB_CHARGE_BAT_LVL_ON	0x4
+#define SCI_USB_CHARGE_BAT_LVL		0x0200
 
 struct toshiba_acpi_dev {
 	struct acpi_device *acpi_dev;
@@ -169,6 +173,7 @@ struct toshiba_acpi_dev {
 	int kbd_type;
 	int kbd_mode;
 	int kbd_time;
+	int usbsc_bat_level;
 
 	unsigned int illumination_supported:1;
 	unsigned int video_supported:1;
@@ -814,6 +819,61 @@ static int toshiba_usb_sleep_charge_set(struct toshiba_acpi_dev *dev,
 	return 0;
 }
 
+static int toshiba_sleep_functions_status_get(struct toshiba_acpi_dev *dev,
+					      u32 *mode)
+{
+	u32 in[TCI_WORDS] = { SCI_GET, SCI_USB_SLEEP_CHARGE, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	in[5] = SCI_USB_CHARGE_BAT_LVL;
+	status = tci_raw(dev, in, out);
+	sci_close(dev);
+	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
+		pr_err("ACPI call to get USB S&C battery level failed\n");
+		return -EIO;
+	} else if (out[0] == TOS_NOT_SUPPORTED) {
+		pr_info("USB Sleep and Charge not supported\n");
+		return -ENODEV;
+	} else if (out[0] == TOS_INPUT_DATA_ERROR) {
+		return -EIO;
+	}
+
+	*mode = out[2];
+
+	return 0;
+}
+
+static int toshiba_sleep_functions_status_set(struct toshiba_acpi_dev *dev,
+					      u32 mode)
+{
+	u32 in[TCI_WORDS] = { SCI_SET, SCI_USB_SLEEP_CHARGE, 0, 0, 0, 0 };
+	u32 out[TCI_WORDS];
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	in[2] = mode;
+	in[5] = SCI_USB_CHARGE_BAT_LVL;
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
@@ -1373,6 +1433,12 @@ static ssize_t toshiba_usb_sleep_charge_show(struct device *dev,
 static ssize_t toshiba_usb_sleep_charge_store(struct device *dev,
 					      struct device_attribute *attr,
 					      const char *buf, size_t count);
+static ssize_t sleep_functions_on_battery_show(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf);
+static ssize_t sleep_functions_on_battery_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count);
 
 static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
@@ -1387,6 +1453,9 @@ static DEVICE_ATTR(position, S_IRUGO, toshiba_position_show, NULL);
 static DEVICE_ATTR(usb_sleep_charge, S_IRUGO | S_IWUSR,
 		   toshiba_usb_sleep_charge_show,
 		   toshiba_usb_sleep_charge_store);
+static DEVICE_ATTR(sleep_functions_on_battery, S_IRUGO | S_IWUSR,
+		   sleep_functions_on_battery_show,
+		   sleep_functions_on_battery_store);
 
 static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_mode.attr,
@@ -1396,6 +1465,7 @@ static struct attribute *toshiba_attributes[] = {
 	&dev_attr_touchpad.attr,
 	&dev_attr_position.attr,
 	&dev_attr_usb_sleep_charge.attr,
+	&dev_attr_sleep_functions_on_battery.attr,
 	NULL,
 };
 
@@ -1657,6 +1727,67 @@ static ssize_t toshiba_usb_sleep_charge_store(struct device *dev,
 	return count;
 }
 
+static ssize_t sleep_functions_on_battery_show(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 state;
+	int ret;
+	int tmp;
+	int status;
+	int bat_lvl;
+
+	ret = toshiba_sleep_functions_status_get(toshiba, &state);
+	if (ret < 0)
+		return ret;
+
+	/* Determine the status: 0x4 - Enabled | 0x1 - Disabled */
+	tmp = state & SCI_USB_CHARGE_BAT_MASK;
+	status = (tmp == 0x4) ? 1 : 0;
+	/* Determine the battery level set */
+	bat_lvl = state >> HCI_MISC_SHIFT;
+
+	return sprintf(buf, "%d %d\n", status, bat_lvl);
+}
+
+static ssize_t sleep_functions_on_battery_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 status;
+	int value;
+	int ret;
+	int tmp;
+
+	ret = kstrtoint(buf, 0, &value);
+	if (ret)
+		return ret;
+
+	/* Set the status of the function:
+	 * 0 - Disabled
+	 * 1-100 - Enabled
+	 */
+	if (value < 0 || value > 100)
+		return -EINVAL;
+
+	if (value == 0) {
+		tmp = toshiba->usbsc_bat_level << HCI_MISC_SHIFT;
+		status = tmp | SCI_USB_CHARGE_BAT_LVL_OFF;
+	} else {
+		tmp = value << HCI_MISC_SHIFT;
+		status = tmp | SCI_USB_CHARGE_BAT_LVL_ON;
+	}
+	ret = toshiba_sleep_functions_status_set(toshiba, status);
+	if (ret < 0)
+		return ret;
+
+	toshiba->usbsc_bat_level = status >> HCI_MISC_SHIFT;
+
+	return count;
+}
+
 static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 					struct attribute *attr, int idx)
 {
@@ -1674,6 +1805,8 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 		exists = (drv->accelerometer_supported) ? true : false;
 	else if (attr == &dev_attr_usb_sleep_charge.attr)
 		exists = (drv->usb_sleep_charge_supported) ? true : false;
+	else if (attr == &dev_attr_sleep_functions_on_battery.attr)
+		exists = (drv->usb_sleep_charge_supported) ? true : false;
 
 	return exists ? attr->mode : 0;
 }
-- 
2.2.1

