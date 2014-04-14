Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaDNVCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:02:15 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:50600 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaDNVCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:02:05 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-input@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-leds@vger.kernel.org,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH 2/4] HID: (thingm) remove the "fade" sysfs attribute
Date: Mon, 14 Apr 2014 16:50:18 -0400
Message-Id: <1397508620-15244-3-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397508620-15244-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1397508620-15244-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As for the "play" sysfs attribute, remove this other non-standard
attribute, so the driver only implements what is required to switch the
LED on and off. Thus, a fade time won't be ideal for some fast-changing
triggers.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ABI/testing/sysfs-driver-hid-thingm |  8 -----
 drivers/hid/hid-thingm.c                          | 41 -----------------------
 2 files changed, 49 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-thingm b/Documentation/ABI/testing/sysfs-driver-hid-thingm
index fda6185..735c5cb 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-thingm
+++ b/Documentation/ABI/testing/sysfs-driver-hid-thingm
@@ -6,11 +6,3 @@ Description:	The ThingM blink1 is an USB RGB LED. The color notation is
 		color. Write the 24-bit hexadecimal color to change the current
 		LED color. The default color is full white (0xFFFFFF).
 		For instance, set the color to green with: echo 00FF00 > rgb
-
-What:		/sys/class/leds/blink1::<serial>/fade
-Date:		January 2013
-Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
-Description:	This attribute allows to set a fade time in milliseconds for
-		the next color change. Read the attribute to know the current
-		fade time. The default value is set to 0 (no fade time). For
-		instance, set a fade time of 2 seconds with: echo 2000 > fade
diff --git a/drivers/hid/hid-thingm.c b/drivers/hid/hid-thingm.c
index 7e376b8..e3b6647 100644
--- a/drivers/hid/hid-thingm.c
+++ b/drivers/hid/hid-thingm.c
@@ -26,14 +26,12 @@
  * @hdev:		HID device.
  * @led_cdev:		LED class instance.
  * @rgb:		8-bit per channel RGB notation.
- * @fade:		fade time in hundredths of a second.
  * @brightness:		brightness coefficient.
  */
 struct blink1_data {
 	struct hid_device *hdev;
 	struct led_classdev led_cdev;
 	u32 rgb;
-	u16 fade;
 	u8 brightness;
 };
 
@@ -64,12 +62,6 @@ static int blink1_update_color(struct blink1_data *data)
 		buf[4] = DIV_ROUND_CLOSEST(blink1_rgb_to_b(data->rgb), coef);
 	}
 
-	if (data->fade) {
-		buf[1] = 'c';
-		buf[5] = (data->fade & 0xFF00) >> 8;
-		buf[6] = (data->fade & 0x00FF);
-	}
-
 	return blink1_send_command(data, buf);
 }
 
@@ -121,42 +113,9 @@ static ssize_t blink1_store_rgb(struct device *dev,
 
 static DEVICE_ATTR(rgb, S_IRUGO | S_IWUSR, blink1_show_rgb, blink1_store_rgb);
 
-static ssize_t blink1_show_fade(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct blink1_data *data = dev_get_drvdata(dev->parent);
-
-	return sprintf(buf, "%d\n", data->fade * 10);
-}
-
-static ssize_t blink1_store_fade(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct blink1_data *data = dev_get_drvdata(dev->parent);
-	long unsigned int fade;
-	int ret;
-
-	ret = kstrtoul(buf, 10, &fade);
-	if (ret)
-		return ret;
-
-	/* blink(1) accepts 16-bit fade time, number of 10ms ticks */
-	fade = DIV_ROUND_CLOSEST(fade, 10);
-	if (fade > 65535)
-		return -EINVAL;
-
-	data->fade = fade;
-
-	return count;
-}
-
-static DEVICE_ATTR(fade, S_IRUGO | S_IWUSR,
-		blink1_show_fade, blink1_store_fade);
-
 static const struct attribute_group blink1_sysfs_group = {
 	.attrs = (struct attribute *[]) {
 		&dev_attr_rgb.attr,
-		&dev_attr_fade.attr,
 		NULL
 	},
 };
-- 
1.9.1

