Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaFXTj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:39:59 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:48672 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaFXTj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:39:56 -0400
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: johan@kernel.org
Cc: greg@kroah.com, bjorn@mork.no, jkosina@suse.cz, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>
Subject: [PATCH 2/2] HID: leds: move led_mode attribute to led-class devices in MSI GT683R driver
Date: Tue, 24 Jun 2014 22:38:38 +0300
Message-Id: <1403638718-11448-2-git-send-email-janne.kanniainen@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1403638718-11448-1-git-send-email-janne.kanniainen@gmail.com>
References: <20140624145003.GA6607@localhost>
 <1403638718-11448-1-git-send-email-janne.kanniainen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move led_mode attribute from HID device to led-class devices and rename it
msi_mode.

Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
---
 .../ABI/testing/sysfs-class-hid-driver-gt683r      |  6 ++-
 drivers/hid/hid-gt683r.c                           | 50 +++++++++++++++++-----
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
index 317e9d5..c97970a 100644
--- a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
+++ b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
@@ -1,9 +1,11 @@
-What:		/sys/class/hidraw/<hidraw>/device/leds_mode
+What:		/sys/class/leds/<led>/msi_mode
 Date:		Jun 2014
 KernelVersion:	3.17
 Contact:	Janne Kanniainen <janne.kanniainen@gmail.com>
 Description:
-		Set the mode of LEDs
+		Set the mode of LEDs. You should notice that changing the mode
+		of one LED will update the mode of its two sibling devices as
+		well
 
 		0 - normal
 		1 - audio
diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
index 073bd80..1c942eb 100644
--- a/drivers/hid/hid-gt683r.c
+++ b/drivers/hid/hid-gt683r.c
@@ -58,6 +58,7 @@ struct gt683r_led {
 	struct work_struct work;
 	enum led_brightness brightnesses[GT683R_LED_COUNT];
 	enum gt683r_led_mode mode;
+	const struct attribute_group *dev_attr_group[GT683R_LED_COUNT];
 };
 
 static const struct hid_device_id gt683r_led_id[] = {
@@ -84,12 +85,13 @@ static void gt683r_brightness_set(struct led_classdev *led_cdev,
 	}
 }
 
-static ssize_t leds_mode_show(struct device *dev,
+static ssize_t msi_mode_show(struct device *led_dev,
 				struct device_attribute *attr,
 				char *buf)
 {
 	u8 sysfs_mode;
-	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct hid_device *hdev = container_of(led_dev->parent,
+					struct hid_device, dev);
 	struct gt683r_led *led = hid_get_drvdata(hdev);
 
 	if (led->mode == GT683R_LED_NORMAL)
@@ -102,15 +104,15 @@ static ssize_t leds_mode_show(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%u\n", sysfs_mode);
 }
 
-static ssize_t leds_mode_store(struct device *dev,
+static ssize_t msi_mode_store(struct device *led_dev,
 				struct device_attribute *attr,
 				const char *buf, size_t count)
 {
 	u8 sysfs_mode;
-	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct hid_device *hdev = container_of(led_dev->parent,
+					struct hid_device, dev);
 	struct gt683r_led *led = hid_get_drvdata(hdev);
 
-
 	if (kstrtou8(buf, 10, &sysfs_mode) || sysfs_mode > 2)
 		return -EINVAL;
 
@@ -212,7 +214,16 @@ fail:
 	mutex_unlock(&led->lock);
 }
 
-static DEVICE_ATTR_RW(leds_mode);
+static DEVICE_ATTR_RW(msi_mode);
+
+static struct attribute *gt683r_attributes[] = {
+	&dev_attr_msi_mode.attr,
+	NULL
+};
+
+static const struct attribute_group gt683r_group = {
+	.attrs = gt683r_attributes
+};
 
 static int gt683r_led_probe(struct hid_device *hdev,
 			const struct hid_device_id *id)
@@ -261,6 +272,7 @@ static int gt683r_led_probe(struct hid_device *hdev,
 		led->led_devs[i].name = name;
 		led->led_devs[i].max_brightness = 1;
 		led->led_devs[i].brightness_set = gt683r_brightness_set;
+
 		ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
 		if (ret) {
 			hid_err(hdev, "could not register led device\n");
@@ -268,17 +280,29 @@ static int gt683r_led_probe(struct hid_device *hdev,
 		}
 	}
 
-	ret = device_create_file(&led->hdev->dev, &dev_attr_leds_mode);
-	if (ret) {
-		hid_err(hdev, "could not make mode attribute file\n");
-		goto fail;
+	for (i = 0; i < GT683R_LED_COUNT; i++) {
+		led->dev_attr_group[i] = &gt683r_group;
+
+		ret = sysfs_create_group(&led->led_devs[i].dev->kobj,
+					led->dev_attr_group[i]);
+		if (ret) {
+			hid_err(hdev, "could not create attribute file\n");
+			goto sysfs_create_fail;
+		}
 	}
 
 	return 0;
 
+sysfs_create_fail:
+	for (i = i - 1; i >= 0; i--)
+		sysfs_remove_group(&led->led_devs[i].dev->kobj,
+				led->dev_attr_group[i]);
+
+	i = GT683R_LED_COUNT;
 fail:
 	for (i = i - 1; i >= 0; i--)
 		led_classdev_unregister(&led->led_devs[i]);
+
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -288,9 +312,13 @@ static void gt683r_led_remove(struct hid_device *hdev)
 	int i;
 	struct gt683r_led *led = hid_get_drvdata(hdev);
 
-	device_remove_file(&hdev->dev, &dev_attr_leds_mode);
+	for (i = 0; i < GT683R_LED_COUNT; i++)
+		sysfs_remove_group(&led->led_devs[i].dev->kobj,
+				led->dev_attr_group[i]);
+
 	for (i = 0; i < GT683R_LED_COUNT; i++)
 		led_classdev_unregister(&led->led_devs[i]);
+
 	flush_work(&led->work);
 	hid_hw_stop(hdev);
 }
-- 
1.9.2

