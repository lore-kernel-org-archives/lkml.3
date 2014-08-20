Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaHTNmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:42:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25412 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaHTNmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:20 -0400
X-AuditID: cbfee61b-f79f86d00000144c-c1-53f4a5ba325f
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 1/4] leds: Improve and export led_update_brightness
Date: Wed, 20 Aug 2014 15:41:55 +0200
Message-id: <1408542118-32723-2-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jAd1dS78EG3y7LGSxccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8alZxNYCmaIVrz79Yy1gfGWYBcjJ4eEgIlE47KD7BC2
	mMSFe+vZuhi5OIQEFjFKLDxwmBXCaWeS6F29kBGkik3AUOLni9dMILaIQLlEz/tnYB3MAqsZ
	Je5s/coKkhAW8JLYcWgPmM0ioCqxf893sGZeAQ+JOV8/sHQxcgCtU5CYM8kGJMwp4CmxdcMP
	sBIhoJLmpWdYJjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHGDPpHcwrmqwOMQo
	wMGoxMN7Y9GXYCHWxLLiytxDjBIczEoivO2dQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1ut
	A4UE0hNLUrNTUwtSi2CyTBycUg2MW6/8vvp687zsWK4tF++dON4VLVG2sJJDI9jDZJX/P6aW
	k22mr9cFcrpEv75813tfomqj9E4Ju7S5TxJkTjefnCF2/imP0p9an/DrhmoNrx48WryAp6rQ
	SXdx/C2mf5LR0sc9SvbsTYgNnndJjm/exAe7RTKV2QKCZe69un3kEPP/FRx3chgvKbEUZyQa
	ajEXFScCAJ14qvYsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

led_update_brightness helper function used to be exploited only locally
in the led-class.c module, where its result was being passed to the
brightness_show sysfs callback. With the introduction of v4l2-flash
subdevice the same functionality becomes required for reading current
brightness from a LED device. This patch adds checking of return value
of the brightness_get callback and moves the led_update_brightness()
function to the LED subsystem public API.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |    6 ------
 drivers/leds/led-core.c  |   16 ++++++++++++++++
 include/linux/leds.h     |   10 ++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f4e5bb4..6f82a76 100644
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
index 8380eb7..466ce5a 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -127,3 +127,19 @@ void led_set_brightness(struct led_classdev *led_cdev,
 	__led_set_brightness(led_cdev, brightness);
 }
 EXPORT_SYMBOL(led_set_brightness);
+
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
diff --git a/include/linux/leds.h b/include/linux/leds.h
index bc221d11..cc85b16 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -139,6 +139,16 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
  */
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
+/**
+ * led_update_brightness - update LED brightness
+ * @led_cdev: the LED to query
+ *
+ * Get an LED's current brightness and update led_cdev->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_brightness(struct led_classdev *led_cdev);
 
 /*
  * LED Triggers
-- 
1.7.9.5

