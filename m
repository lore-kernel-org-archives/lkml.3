Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaGKOL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:11:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29312 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbaGKOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:42 -0400
X-AuditID: cbfee61a-f79e46d00000134f-76-53bfeef8622b
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 03/21] leds: Improve and export led_update_brightness
Date: Fri, 11 Jul 2014 16:04:06 +0200
Message-id: <1405087464-13762-4-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd0f7/YHG6y4YmCxccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8aV+dvYCjrEKt7fv83ewLhJqIuRk0NCwERi+tNzLBC2
	mMSFe+vZuhi5OIQEpjNKzG8/yQzhtDNJbL2/lhmkik3AUOLni9dMILaIQLlEz/tnYB3MAqsZ
	Je5s/coKkhAW8JF4+m0m2FgWAVWJ2X+/g8V5BTwkti79AdTAAbROQWLOJBuQMKeAp8TB/pts
	ILYQUMnDtSfYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHGDPpHYwrmywOMQo
	wMGoxMOrsH5fsBBrYllxZe4hRgkOZiUR3qtv9gcL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Q
	ah0oJJCeWJKanZpakFoEk2Xi4JRqYGR52G72u1/1nEVgM6+Byqo8+7A3HZlOhR5FEh/6Pe/c
	LZ1opJdrvNxdYQtvymIRsx+8iey/z14XqlBbLyloPCc29zFr37118bql60LuWq5/M3d2nkDs
	t8iP2xUvhsVMvLL9QChPREXjBHa2ZWpv2nyavj05v3jpoTa3YzsT7m/883SZ5bL/ZkosxRmJ
	hlrMRcWJAGwAq/csAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

led_update_brightness helper function used to be exploited only locally
in the led-class.c module, where its result was being passed to the
brightness_show sysfs callback. With the introduction of v4l2-flash
subdevice the same functionality became required for reading current
brightness from a LED device. This patch adds checking of return value
of the brightness_get callback and moves the led_update_brightness()
function to the LED subsystem public API.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |    6 ------
 drivers/leds/led-core.c  |   15 +++++++++++++++
 include/linux/leds.h     |   10 ++++++++++
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index ea04891..da79bbb 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -23,12 +23,6 @@
 
 static struct class *leds_class;
 
-static void led_update_brightness(struct led_classdev *led_cdev)
-{
-	if (led_cdev->brightness_get)
-		led_cdev->brightness = led_cdev->brightness_get(led_cdev);
-}
-
 static ssize_t brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 4d7cb31..0ac06ed 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -127,6 +127,21 @@ void led_set_brightness(struct led_classdev *led_cdev,
 }
 EXPORT_SYMBOL(led_set_brightness);
 
+int led_update_brightness(struct led_classdev *led_cdev)
+{
+	int ret = 0;
+
+	if (led_cdev->brightness_get) {
+		ret = led_cdev->brightness_get(led_cdev);
+		if (ret >= 0) {
+			led_cdev->brightness = ret;
+			return 0;
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(led_update_brightness);
 /* Caller must ensure led_cdev->led_lock held */
 void led_sysfs_lock(struct led_classdev *led_cdev)
 {
diff --git a/include/linux/leds.h b/include/linux/leds.h
index da7c6b5..e9b025d 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -146,6 +146,16 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
 /**
+ * led_update_brightness - update LED brightness
+ * @led_cdev: the LED to query
+ *
+ * Get an LED's current brightness and update led_cdev->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_brightness(struct led_classdev *led_cdev);
+
  * led_sysfs_lock - lock LED sysfs interface
  * @led_cdev: the LED to set
  *
-- 
1.7.9.5

