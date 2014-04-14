Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaDNU5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:57:08 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:54090 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaDNU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:57:04 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-input@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-leds@vger.kernel.org,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH 3/4] HID: (thingm) refactor blink(1) support
Date: Mon, 14 Apr 2014 16:50:19 -0400
Message-Id: <1397508620-15244-4-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397508620-15244-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1397508620-15244-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors the way the thingm driver registers a blink(1) LED.
In order to make the driver simpler and more standard, drop the "rgb"
sysfs attribute and create one instance of LED class per RGB channel.

Actually, the name of the LED class instance registered for a blink(1)
device is "blink1::ABCD", where ABCD is the last 4 chars of the serial
number. The driver now registers 3 instances per RGB chip, named
"thingmX:{red,green,blue}:ledY" where X is the hidraw minor number and Y
is the RGB chip number (as seen by the firmware).

This patch also uses work queues to defer calls with the device, which
now allows triggers to work as expected with this LED device.

Also remove the brightness structure field and the brightness_get
backend, as it is already handled by the LED class, and changes the
prefix of functions and structures to thingm_ to match the driver name.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ABI/testing/sysfs-driver-hid-thingm |   8 -
 drivers/hid/hid-thingm.c                          | 304 +++++++++++++++-------
 drivers/leds/Kconfig                              |   2 +
 3 files changed, 209 insertions(+), 105 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-hid-thingm

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-thingm b/Documentation/ABI/testing/sysfs-driver-hid-thingm
deleted file mode 100644
index 735c5cb..0000000
--- a/Documentation/ABI/testing/sysfs-driver-hid-thingm
+++ /dev/null
@@ -1,8 +0,0 @@
-What:		/sys/class/leds/blink1::<serial>/rgb
-Date:		January 2013
-Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
-Description:	The ThingM blink1 is an USB RGB LED. The color notation is
-		3-byte hexadecimal. Read this attribute to get the last set
-		color. Write the 24-bit hexadecimal color to change the current
-		LED color. The default color is full white (0xFFFFFF).
-		For instance, set the color to green with: echo 00FF00 > rgb
diff --git a/drivers/hid/hid-thingm.c b/drivers/hid/hid-thingm.c
index e3b6647..0af0eb4 100644
--- a/drivers/hid/hid-thingm.c
+++ b/drivers/hid/hid-thingm.c
@@ -1,7 +1,7 @@
 /*
  * ThingM blink(1) USB RGB LED driver
  *
- * Copyright 2013 Savoir-faire Linux Inc.
+ * Copyright 2013-2014 Savoir-faire Linux Inc.
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -10,170 +10,280 @@
  */
 
 #include <linux/hid.h>
+#include <linux/hidraw.h>
 #include <linux/leds.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
 
 #include "hid-ids.h"
 
-#define BLINK1_CMD_SIZE		9
+#define REPORT_ID	1
+#define REPORT_SIZE	9
 
-#define blink1_rgb_to_r(rgb)	((rgb & 0xFF0000) >> 16)
-#define blink1_rgb_to_g(rgb)	((rgb & 0x00FF00) >> 8)
-#define blink1_rgb_to_b(rgb)	((rgb & 0x0000FF) >> 0)
+/* Firmware major number of supported devices */
+#define THINGM_MAJOR_MK1	'1'
 
-/**
- * struct blink1_data - blink(1) device specific data
- * @hdev:		HID device.
- * @led_cdev:		LED class instance.
- * @rgb:		8-bit per channel RGB notation.
- * @brightness:		brightness coefficient.
- */
-struct blink1_data {
+struct thingm_fwinfo {
+	char major;
+	unsigned numrgb;
+	unsigned first;
+};
+
+const struct thingm_fwinfo thingm_fwinfo[] = {
+	{
+		.major = THINGM_MAJOR_MK1,
+		.numrgb = 1,
+		.first = 0,
+	}
+};
+
+/* A red, green or blue channel, part of an RGB chip */
+struct thingm_led {
+	struct thingm_rgb *rgb;
+	struct led_classdev ldev;
+	char name[32];
+};
+
+/* Basically a WS2812 5050 RGB LED chip */
+struct thingm_rgb {
+	struct thingm_device *tdev;
+	struct thingm_led red;
+	struct thingm_led green;
+	struct thingm_led blue;
+	struct work_struct work;
+	u8 num;
+};
+
+struct thingm_device {
 	struct hid_device *hdev;
-	struct led_classdev led_cdev;
-	u32 rgb;
-	u8 brightness;
+	struct {
+		char major;
+		char minor;
+	} version;
+	const struct thingm_fwinfo *fwinfo;
+	struct mutex lock;
+	struct thingm_rgb *rgb;
 };
 
-static int blink1_send_command(struct blink1_data *data,
-		u8 buf[BLINK1_CMD_SIZE])
+static int thingm_send(struct thingm_device *tdev, u8 buf[REPORT_SIZE])
 {
 	int ret;
 
-	hid_dbg(data->hdev, "command: %d%c%.2x%.2x%.2x%.2x%.2x%.2x%.2x\n",
+	hid_dbg(tdev->hdev, "-> %d %c %02hhx %02hhx %02hhx %02hhx %02hhx %02hhx %02hhx\n",
 			buf[0], buf[1], buf[2], buf[3], buf[4],
 			buf[5], buf[6], buf[7], buf[8]);
 
-	ret = hid_hw_raw_request(data->hdev, buf[0], buf, BLINK1_CMD_SIZE,
-				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
+	ret = hid_hw_raw_request(tdev->hdev, buf[0], buf, REPORT_SIZE,
+			HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
 
 	return ret < 0 ? ret : 0;
 }
 
-static int blink1_update_color(struct blink1_data *data)
+static int thingm_recv(struct thingm_device *tdev, u8 buf[REPORT_SIZE])
 {
-	u8 buf[BLINK1_CMD_SIZE] = { 1, 'n', 0, 0, 0, 0, 0, 0, 0 };
+	int ret;
 
-	if (data->brightness) {
-		unsigned int coef = DIV_ROUND_CLOSEST(255, data->brightness);
+	ret = hid_hw_raw_request(tdev->hdev, buf[0], buf, REPORT_SIZE,
+			HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
+	if (ret < 0)
+		return ret;
 
-		buf[2] = DIV_ROUND_CLOSEST(blink1_rgb_to_r(data->rgb), coef);
-		buf[3] = DIV_ROUND_CLOSEST(blink1_rgb_to_g(data->rgb), coef);
-		buf[4] = DIV_ROUND_CLOSEST(blink1_rgb_to_b(data->rgb), coef);
-	}
+	hid_dbg(tdev->hdev, "<- %d %c %02hhx %02hhx %02hhx %02hhx %02hhx %02hhx %02hhx\n",
+			buf[0], buf[1], buf[2], buf[3], buf[4],
+			buf[5], buf[6], buf[7], buf[8]);
 
-	return blink1_send_command(data, buf);
+	return 0;
 }
 
-static void blink1_led_set(struct led_classdev *led_cdev,
-		enum led_brightness brightness)
+static int thingm_version(struct thingm_device *tdev)
 {
-	struct blink1_data *data = dev_get_drvdata(led_cdev->dev->parent);
+	u8 buf[REPORT_SIZE] = { REPORT_ID, 'v', 0, 0, 0, 0, 0, 0, 0 };
+	int err;
+
+	err = thingm_send(tdev, buf);
+	if (err)
+		return err;
+
+	err = thingm_recv(tdev, buf);
+	if (err)
+		return err;
 
-	data->brightness = brightness;
-	if (blink1_update_color(data))
-		hid_err(data->hdev, "failed to update color\n");
+	tdev->version.major = buf[3];
+	tdev->version.minor = buf[4];
+
+	return 0;
 }
 
-static enum led_brightness blink1_led_get(struct led_classdev *led_cdev)
+static int thingm_write_color(struct thingm_rgb *rgb)
 {
-	struct blink1_data *data = dev_get_drvdata(led_cdev->dev->parent);
+	u8 buf[REPORT_SIZE] = { REPORT_ID, 'n', 0, 0, 0, 0, 0, 0, 0 };
+
+	buf[2] = rgb->red.ldev.brightness;
+	buf[3] = rgb->green.ldev.brightness;
+	buf[4] = rgb->blue.ldev.brightness;
 
-	return data->brightness;
+	return thingm_send(rgb->tdev, buf);
 }
 
-static ssize_t blink1_show_rgb(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static void thingm_work(struct work_struct *work)
 {
-	struct blink1_data *data = dev_get_drvdata(dev->parent);
+	struct thingm_rgb *rgb = container_of(work, struct thingm_rgb, work);
 
-	return sprintf(buf, "%.6X\n", data->rgb);
+	mutex_lock(&rgb->tdev->lock);
+
+	if (thingm_write_color(rgb))
+		hid_err(rgb->tdev->hdev, "failed to write color\n");
+
+	mutex_unlock(&rgb->tdev->lock);
 }
 
-static ssize_t blink1_store_rgb(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+static void thingm_led_set(struct led_classdev *ldev,
+		enum led_brightness brightness)
 {
-	struct blink1_data *data = dev_get_drvdata(dev->parent);
-	long unsigned int rgb;
-	int ret;
+	struct thingm_led *led = container_of(ldev, struct thingm_led, ldev);
 
-	ret = kstrtoul(buf, 16, &rgb);
-	if (ret)
-		return ret;
+	/* the ledclass has already stored the brightness value */
+	schedule_work(&led->rgb->work);
+}
 
-	/* RGB triplet notation is 24-bit hexadecimal */
-	if (rgb > 0xFFFFFF)
-		return -EINVAL;
+static int thingm_init_rgb(struct thingm_rgb *rgb)
+{
+	const int minor = ((struct hidraw *) rgb->tdev->hdev->hidraw)->minor;
+	int err;
+
+	/* Register the red diode */
+	snprintf(rgb->red.name, sizeof(rgb->red.name),
+			"thingm%d:red:led%d", minor, rgb->num);
+	rgb->red.ldev.name = rgb->red.name;
+	rgb->red.ldev.max_brightness = 255;
+	rgb->red.ldev.brightness_set = thingm_led_set;
+	rgb->red.rgb = rgb;
+
+	err = led_classdev_register(&rgb->tdev->hdev->dev, &rgb->red.ldev);
+	if (err)
+		return err;
+
+	/* Register the green diode */
+	snprintf(rgb->green.name, sizeof(rgb->green.name),
+			"thingm%d:green:led%d", minor, rgb->num);
+	rgb->green.ldev.name = rgb->green.name;
+	rgb->green.ldev.max_brightness = 255;
+	rgb->green.ldev.brightness_set = thingm_led_set;
+	rgb->green.rgb = rgb;
+
+	err = led_classdev_register(&rgb->tdev->hdev->dev, &rgb->green.ldev);
+	if (err)
+		goto unregister_red;
+
+	/* Register the blue diode */
+	snprintf(rgb->blue.name, sizeof(rgb->blue.name),
+			"thingm%d:blue:led%d", minor, rgb->num);
+	rgb->blue.ldev.name = rgb->blue.name;
+	rgb->blue.ldev.max_brightness = 255;
+	rgb->blue.ldev.brightness_set = thingm_led_set;
+	rgb->blue.rgb = rgb;
+
+	err = led_classdev_register(&rgb->tdev->hdev->dev, &rgb->blue.ldev);
+	if (err)
+		goto unregister_green;
+
+	INIT_WORK(&rgb->work, thingm_work);
 
-	data->rgb = rgb;
-	ret = blink1_update_color(data);
+	return 0;
 
-	return ret ? ret : count;
-}
+unregister_green:
+	led_classdev_unregister(&rgb->green.ldev);
 
-static DEVICE_ATTR(rgb, S_IRUGO | S_IWUSR, blink1_show_rgb, blink1_store_rgb);
+unregister_red:
+	led_classdev_unregister(&rgb->red.ldev);
 
-static const struct attribute_group blink1_sysfs_group = {
-	.attrs = (struct attribute *[]) {
-		&dev_attr_rgb.attr,
-		NULL
-	},
-};
+	return err;
+}
+
+static void thingm_remove_rgb(struct thingm_rgb *rgb)
+{
+	flush_work(&rgb->work);
+	led_classdev_unregister(&rgb->red.ldev);
+	led_classdev_unregister(&rgb->green.ldev);
+	led_classdev_unregister(&rgb->blue.ldev);
+}
 
 static int thingm_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
-	struct blink1_data *data;
-	struct led_classdev *led;
-	char led_name[13];
-	int ret;
+	struct thingm_device *tdev;
+	int i, err;
 
-	data = devm_kzalloc(&hdev->dev, sizeof(struct blink1_data), GFP_KERNEL);
-	if (!data)
+	tdev = devm_kzalloc(&hdev->dev, sizeof(struct thingm_device),
+			GFP_KERNEL);
+	if (!tdev)
 		return -ENOMEM;
 
-	hid_set_drvdata(hdev, data);
-	data->hdev = hdev;
-	data->rgb = 0xFFFFFF; /* set a default white color */
+	tdev->hdev = hdev;
+	hid_set_drvdata(hdev, tdev);
 
-	ret = hid_parse(hdev);
-	if (ret)
+	err = hid_parse(hdev);
+	if (err)
 		goto error;
 
-	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
-	if (ret)
+	err = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	if (err)
 		goto error;
 
-	/* blink(1) serial numbers range is 0x1A001000 to 0x1A002FFF */
-	led = &data->led_cdev;
-	snprintf(led_name, sizeof(led_name), "blink1::%s", hdev->uniq + 4);
-	led->name = led_name;
-	led->brightness_set = blink1_led_set;
-	led->brightness_get = blink1_led_get;
-	ret = led_classdev_register(&hdev->dev, led);
-	if (ret)
+	mutex_init(&tdev->lock);
+
+	err = thingm_version(tdev);
+	if (err)
 		goto stop;
 
-	ret = sysfs_create_group(&led->dev->kobj, &blink1_sysfs_group);
-	if (ret)
-		goto remove_led;
+	hid_dbg(hdev, "firmware version: %c.%c\n",
+			tdev->version.major, tdev->version.minor);
 
-	return 0;
+	for (i = 0; i < ARRAY_SIZE(thingm_fwinfo) && !tdev->fwinfo; ++i)
+		if (thingm_fwinfo[i].major == tdev->version.major)
+			tdev->fwinfo = &thingm_fwinfo[i];
+
+	if (!tdev->fwinfo) {
+		hid_err(hdev, "unsupported firmware %c\n", tdev->version.major);
+		goto stop;
+	}
+
+	tdev->rgb = devm_kzalloc(&hdev->dev,
+			sizeof(struct thingm_rgb) * tdev->fwinfo->numrgb,
+			GFP_KERNEL);
+	if (!tdev->rgb) {
+		err = -ENOMEM;
+		goto stop;
+	}
+
+	for (i = 0; i < tdev->fwinfo->numrgb; ++i) {
+		struct thingm_rgb *rgb = tdev->rgb + i;
+
+		rgb->tdev = tdev;
+		rgb->num = tdev->fwinfo->first + i;
+		err = thingm_init_rgb(rgb);
+		if (err) {
+			while (--i >= 0)
+				thingm_remove_rgb(tdev->rgb + i);
+			goto stop;
+		}
+	}
 
-remove_led:
-	led_classdev_unregister(led);
+	return 0;
 stop:
 	hid_hw_stop(hdev);
 error:
-	return ret;
+	return err;
 }
 
 static void thingm_remove(struct hid_device *hdev)
 {
-	struct blink1_data *data = hid_get_drvdata(hdev);
-	struct led_classdev *led = &data->led_cdev;
+	struct thingm_device *tdev = hid_get_drvdata(hdev);
+	int i;
+
+	for (i = 0; i < tdev->fwinfo->numrgb; ++i)
+		thingm_remove_rgb(tdev->rgb + i);
 
-	sysfs_remove_group(&led->dev->kobj, &blink1_sysfs_group);
-	led_classdev_unregister(led);
 	hid_hw_stop(hdev);
 }
 
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 72156c1..46c7d79 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -479,6 +479,8 @@ config LEDS_OT200
 	  This option enables support for the LEDs on the Bachmann OT200.
 	  Say Y to enable LEDs on the Bachmann OT200.
 
+comment "LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)"
+
 config LEDS_BLINKM
 	tristate "LED support for the BlinkM I2C RGB LED"
 	depends on LEDS_CLASS
-- 
1.9.1

