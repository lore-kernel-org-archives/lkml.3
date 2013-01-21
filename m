Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3AUSSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:18:42 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:56379 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3AUSSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:18:41 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-input@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] HID: add ThingM blink(1) USB RGB LED support
Date: Mon, 21 Jan 2013 13:18:34 -0500
Message-Id: <1358792314-24596-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ThingM blink(1) is an open source hardware USB RGB LED. It contains
an internal EEPROM, allowing to configure up to 12 light patterns. A
light pattern is a RGB color plus a fading time. This driver registers a
LED class instance with additional sysfs attributes to support basic
functions such as setting RGB colors, fading and playing. Other
functions are still accessible through the hidraw interface.

At this time, the only documentation for the device is the firmware
source code from ThingM, plus a few schematics. They are available at:

https://github.com/todbot/blink1

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ABI/testing/sysfs-driver-hid-blink1 |  23 ++
 MAINTAINERS                                       |   5 +
 drivers/hid/Kconfig                               |  10 +
 drivers/hid/Makefile                              |   1 +
 drivers/hid/hid-core.c                            |   1 +
 drivers/hid/hid-ids.h                             |   3 +
 drivers/hid/hid-thingm-blink1.c                   | 272 ++++++++++++++++++++++
 7 files changed, 315 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-blink1
 create mode 100644 drivers/hid/hid-thingm-blink1.c

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-blink1 b/Documentation/ABI/testing/sysfs-driver-hid-blink1
new file mode 100644
index 0000000..1998c3c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-blink1
@@ -0,0 +1,23 @@
+What:		/sys/class/leds/blink(1)::<serial>/rgb
+Date:		January 2013
+Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+Description:	The ThingM blink(1) is an USB RGB LED. The color notation is
+		3-byte hexadecimal. Read this attribute to get the last set
+		color. Write the 24-bit hexadecimal color to change the current
+		LED color. The default color is full white (0xFFFFFF).
+		For instance, set the color to green with: echo 00FF00 > rgb
+
+What:		/sys/class/leds/blink(1)::<serial>/fade
+Date:		January 2013
+Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+Description:	This attribute allows to set a fade time in milliseconds for
+		the next color change. Read the attribute to know the current
+		fade time. The default value is set to 0 (no fade time). For
+		instance, set a fade time of 2 seconds with: echo 2000 > fade
+
+What:		/sys/class/leds/blink(1)::<serial>/play
+Date:		January 2013
+Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+Description:	This attribute is used to play/pause the light patterns. Write 1
+		to start playing, 0 to stop. Reading this attribute returns the
+		current playing status.
diff --git a/MAINTAINERS b/MAINTAINERS
index b0b880d..b166f45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7306,6 +7306,11 @@ S:      Supported
 F:      drivers/thermal/
 F:      include/linux/thermal.h
 
+THINGM BLINK(1) USB RGB LED DRIVER
+M:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+S:	Maintained
+F:	drivers/hid/hid-thingm-blink1.c
+
 THINKPAD ACPI EXTRAS DRIVER
 M:	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
 L:	ibm-acpi-devel@lists.sourceforge.net
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e7d6a13..b3a7b0f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -655,6 +655,16 @@ config HID_TOPSEED
 	Say Y if you have a TopSeed Cyberlink or BTC Emprex or Conceptronic
 	CLLRCMCE remote control.
 
+config HID_THINGM_BLINK1
+	tristate "ThingM blink(1) USB RGB LED"
+	depends on USB_HID
+	depends on LEDS_CLASS
+	---help---
+	Support for the ThingM blink(1) USB RGB LED. This driver registers a
+	Linux LED class instance, plus additional sysfs attributes to control
+	RGB colors, fading and playing. The device is exposed through hidraw to
+	access other functions.
+
 config HID_THRUSTMASTER
 	tristate "ThrustMaster devices support"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index b622157..63e337a 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_HID_SONY)		+= hid-sony.o
 obj-$(CONFIG_HID_SPEEDLINK)	+= hid-speedlink.o
 obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
 obj-$(CONFIG_HID_GREENASIA)	+= hid-gaff.o
+obj-$(CONFIG_HID_THINGM_BLINK1)	+= hid-thingm-blink1.o
 obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o
 obj-$(CONFIG_HID_TIVO)		+= hid-tivo.o
 obj-$(CONFIG_HID_TOPSEED)	+= hid-topseed.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5ae2cb1..b14cbf4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1700,6 +1700,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGP_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THINGM, USB_DEVICE_ID_BLINK1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index dad56aa..3503003 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -748,6 +748,9 @@
 #define USB_DEVICE_ID_SYNAPTICS_WTP	0x0010
 #define USB_DEVICE_ID_SYNAPTICS_DPAD	0x0013
 
+#define USB_VENDOR_ID_THINGM		0x27b8
+#define USB_DEVICE_ID_BLINK1		0x01ed
+
 #define USB_VENDOR_ID_THRUSTMASTER	0x044f
 
 #define USB_VENDOR_ID_TIVO		0x150a
diff --git a/drivers/hid/hid-thingm-blink1.c b/drivers/hid/hid-thingm-blink1.c
new file mode 100644
index 0000000..1555e27
--- /dev/null
+++ b/drivers/hid/hid-thingm-blink1.c
@@ -0,0 +1,272 @@
+/*
+ * ThingM blink(1) USB RGB LED driver
+ *
+ * Copyright 2013 Vivien Didelot <vivien.didelot@savoirfairelinux.com>
+ * Copyright 2013 Savoir-faire Linux Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ */
+
+#include <linux/hid.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+
+#include "hid-ids.h"
+
+#define BLINK1_CMD_SIZE		9
+
+#define blink1_rgb_to_r(rgb)	((rgb & 0xFF0000) >> 16)
+#define blink1_rgb_to_g(rgb)	((rgb & 0x00FF00) >> 8)
+#define blink1_rgb_to_b(rgb)	((rgb & 0x0000FF) >> 0)
+
+/**
+ * struct blink1_data - blink(1) device specific data
+ * @hdev:		HID device.
+ * @led_cdev:		LED class instance.
+ * @rgb:		8-bit per channel RGB notation.
+ * @fade:		fade time in hundredths of a second.
+ * @brightness:		brightness coefficient.
+ * @play:		play/pause in-memory patterns.
+ */
+struct blink1_data {
+	struct hid_device *hdev;
+	struct led_classdev led_cdev;
+	u32 rgb;
+	u16 fade;
+	u8 brightness;
+	bool play;
+};
+
+static int blink1_send_command(struct blink1_data *data,
+		u8 buf[BLINK1_CMD_SIZE])
+{
+	int ret;
+
+	hid_dbg(data->hdev, "command: %d%c%.2x%.2x%.2x%.2x%.2x%.2x%.2x\n",
+			buf[0], buf[1], buf[2], buf[3], buf[4],
+			buf[5], buf[6], buf[7], buf[8]);
+
+	ret = data->hdev->hid_output_raw_report(data->hdev, buf,
+			BLINK1_CMD_SIZE, HID_FEATURE_REPORT);
+
+	return ret < 0 ? ret : 0;
+}
+
+static int blink1_update_color(struct blink1_data *data)
+{
+	u8 buf[BLINK1_CMD_SIZE] = { 1, 'n', 0, 0, 0, 0, 0, 0, 0 };
+
+	if (data->brightness) {
+		unsigned int coef = DIV_ROUND_CLOSEST(255, data->brightness);
+
+		buf[2] = DIV_ROUND_CLOSEST(blink1_rgb_to_r(data->rgb), coef);
+		buf[3] = DIV_ROUND_CLOSEST(blink1_rgb_to_g(data->rgb), coef);
+		buf[4] = DIV_ROUND_CLOSEST(blink1_rgb_to_b(data->rgb), coef);
+	}
+
+	if (data->fade) {
+		buf[1] = 'c';
+		buf[5] = (data->fade & 0xFF00) >> 8;
+		buf[6] = (data->fade & 0x00FF);
+	}
+
+	return blink1_send_command(data, buf);
+}
+
+static void blink1_led_set(struct led_classdev *led_cdev,
+		enum led_brightness brightness)
+{
+	struct blink1_data *data = dev_get_drvdata(led_cdev->dev->parent);
+
+	data->brightness = brightness;
+	if (blink1_update_color(data))
+		hid_err(data->hdev, "failed to update color\n");
+}
+
+static enum led_brightness blink1_led_get(struct led_classdev *led_cdev)
+{
+	struct blink1_data *data = dev_get_drvdata(led_cdev->dev->parent);
+
+	return data->brightness;
+}
+
+static ssize_t blink1_show_rgb(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+
+	return sprintf(buf, "%.6X\n", data->rgb);
+}
+
+static ssize_t blink1_store_rgb(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+	long unsigned int rgb;
+	int ret;
+
+	ret = kstrtoul(buf, 16, &rgb);
+	if (ret)
+		return ret;
+
+	/* RGB triplet notation is 24-bit hexadecimal */
+	if (rgb > 0xFFFFFF)
+		return -EINVAL;
+
+	data->rgb = rgb;
+	ret = blink1_update_color(data);
+
+	return ret ? ret : count;
+}
+
+static DEVICE_ATTR(rgb, S_IRUGO | S_IWUSR, blink1_show_rgb, blink1_store_rgb);
+
+static ssize_t blink1_show_fade(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+
+	return sprintf(buf, "%d\n", data->fade * 10);
+}
+
+static ssize_t blink1_store_fade(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+	long unsigned int fade;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &fade);
+	if (ret)
+		return ret;
+
+	/* blink(1) accepts 16-bit fade time, number of 10ms ticks */
+	fade = DIV_ROUND_CLOSEST(fade, 10);
+	if (fade > 65535)
+		return -EINVAL;
+
+	data->fade = fade;
+
+	return count;
+}
+
+static DEVICE_ATTR(fade, S_IRUGO | S_IWUSR,
+		blink1_show_fade, blink1_store_fade);
+
+static ssize_t blink1_show_play(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+
+	return sprintf(buf, "%d\n", data->play);
+}
+
+static ssize_t blink1_store_play(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct blink1_data *data = dev_get_drvdata(dev->parent);
+	u8 cmd[BLINK1_CMD_SIZE] = { 1, 'p', 0, 0, 0, 0, 0, 0, 0 };
+	long unsigned int play;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &play);
+	if (ret)
+		return ret;
+
+	data->play = !!play;
+	cmd[2] = data->play;
+	ret = blink1_send_command(data, cmd);
+
+	return ret ? ret : count;
+}
+
+static DEVICE_ATTR(play, S_IRUGO | S_IWUSR,
+		blink1_show_play, blink1_store_play);
+
+static const struct attribute_group blink1_sysfs_group = {
+	.attrs = (struct attribute *[]) {
+		&dev_attr_rgb.attr,
+		&dev_attr_fade.attr,
+		&dev_attr_play.attr,
+		NULL
+	},
+};
+
+static int blink1_probe(struct hid_device *hdev, const struct hid_device_id *id)
+{
+	struct blink1_data *data;
+	struct led_classdev *led;
+	char led_name[15];
+	int ret;
+
+	data = devm_kzalloc(&hdev->dev, sizeof(struct blink1_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	hid_set_drvdata(hdev, data);
+	data->hdev = hdev;
+	data->rgb = 0xFFFFFF; /* set a default white color */
+
+	ret = hid_parse(hdev);
+	if (ret)
+		goto error;
+
+	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	if (ret)
+		goto error;
+
+	/* blink(1) serial numbers range is 0x1A001000 to 0x1A002FFF */
+	led = &data->led_cdev;
+	snprintf(led_name, sizeof(led_name), "blink(1)::%s", hdev->uniq + 4);
+	led->name = led_name;
+	led->brightness_set = blink1_led_set;
+	led->brightness_get = blink1_led_get;
+	ret = led_classdev_register(&hdev->dev, led);
+	if (ret)
+		goto stop;
+
+	ret = sysfs_create_group(&led->dev->kobj, &blink1_sysfs_group);
+	if (ret)
+		goto remove_led;
+
+	return 0;
+
+remove_led:
+	led_classdev_unregister(led);
+stop:
+	hid_hw_stop(hdev);
+error:
+	return ret;
+}
+
+static void blink1_remove(struct hid_device *hdev)
+{
+	struct blink1_data *data = hid_get_drvdata(hdev);
+	struct led_classdev *led = &data->led_cdev;
+
+	sysfs_remove_group(&led->dev->kobj, &blink1_sysfs_group);
+	led_classdev_unregister(led);
+	hid_hw_stop(hdev);
+}
+
+static const struct hid_device_id blink1_table[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THINGM, USB_DEVICE_ID_BLINK1) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, blink1_table);
+
+static struct hid_driver blink1_driver = {
+	.name = "blink(1)",
+	.probe = blink1_probe,
+	.remove = blink1_remove,
+	.id_table = blink1_table,
+};
+
+module_hid_driver(blink1_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vivien Didelot <vivien.didelot@savoirfairelinux.com>");
+MODULE_DESCRIPTION("ThingM blink(1) USB RGB LED driver");
-- 
1.8.1.1

