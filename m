Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaDNVCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:02:12 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:64883 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaDNVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:02:04 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-input@vger.kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-leds@vger.kernel.org,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: [PATCH 1/4] HID: (thingm) remove the "play" sysfs attribute
Date: Mon, 14 Apr 2014 16:50:17 -0400
Message-Id: <1397508620-15244-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397508620-15244-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1397508620-15244-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the thingm driver registers an instance of LED class, it creates a
"play" sysfs attribute for this blink(1) specific feature.

Since this feature is not specific to the RGB chip but to the HID device
itself, let's remove this attribute from the LED instance and only
implement what is useful to switch on and off the LED.

This feature is still easily accessible through hidraw.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ABI/testing/sysfs-driver-hid-thingm |  7 -----
 drivers/hid/hid-thingm.c                          | 33 -----------------------
 2 files changed, 40 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-thingm b/Documentation/ABI/testing/sysfs-driver-hid-thingm
index abcffee..fda6185 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-thingm
+++ b/Documentation/ABI/testing/sysfs-driver-hid-thingm
@@ -14,10 +14,3 @@ Description:	This attribute allows to set a fade time in milliseconds for
 		the next color change. Read the attribute to know the current
 		fade time. The default value is set to 0 (no fade time). For
 		instance, set a fade time of 2 seconds with: echo 2000 > fade
-
-What:		/sys/class/leds/blink1::<serial>/play
-Date:		January 2013
-Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
-Description:	This attribute is used to play/pause the light patterns. Write 1
-		to start playing, 0 to stop. Reading this attribute returns the
-		current playing status.
diff --git a/drivers/hid/hid-thingm.c b/drivers/hid/hid-thingm.c
index a97c788..7e376b8 100644
--- a/drivers/hid/hid-thingm.c
+++ b/drivers/hid/hid-thingm.c
@@ -28,7 +28,6 @@
  * @rgb:		8-bit per channel RGB notation.
  * @fade:		fade time in hundredths of a second.
  * @brightness:		brightness coefficient.
- * @play:		play/pause in-memory patterns.
  */
 struct blink1_data {
 	struct hid_device *hdev;
@@ -36,7 +35,6 @@ struct blink1_data {
 	u32 rgb;
 	u16 fade;
 	u8 brightness;
-	bool play;
 };
 
 static int blink1_send_command(struct blink1_data *data,
@@ -155,41 +153,10 @@ static ssize_t blink1_store_fade(struct device *dev,
 static DEVICE_ATTR(fade, S_IRUGO | S_IWUSR,
 		blink1_show_fade, blink1_store_fade);
 
-static ssize_t blink1_show_play(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct blink1_data *data = dev_get_drvdata(dev->parent);
-
-	return sprintf(buf, "%d\n", data->play);
-}
-
-static ssize_t blink1_store_play(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct blink1_data *data = dev_get_drvdata(dev->parent);
-	u8 cmd[BLINK1_CMD_SIZE] = { 1, 'p', 0, 0, 0, 0, 0, 0, 0 };
-	long unsigned int play;
-	int ret;
-
-	ret = kstrtoul(buf, 10, &play);
-	if (ret)
-		return ret;
-
-	data->play = !!play;
-	cmd[2] = data->play;
-	ret = blink1_send_command(data, cmd);
-
-	return ret ? ret : count;
-}
-
-static DEVICE_ATTR(play, S_IRUGO | S_IWUSR,
-		blink1_show_play, blink1_store_play);
-
 static const struct attribute_group blink1_sysfs_group = {
 	.attrs = (struct attribute *[]) {
 		&dev_attr_rgb.attr,
 		&dev_attr_fade.attr,
-		&dev_attr_play.attr,
 		NULL
 	},
 };
-- 
1.9.1

