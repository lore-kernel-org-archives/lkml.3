Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaDKO7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:59:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43408 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaDKO5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:57:32 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-86-534802db9012
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v3 2/5] leds: Improve and export led_update_brightness
 function
Date: Fri, 11 Apr 2014 16:56:53 +0200
Message-id: <1397228216-6657-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAd3bTB7BBl9bVCxurTvHanF050Qm
	i/lHgKzeq88ZLc42vWG3uLxrDpvF1jfrGC16Nmxltdi96ymrxeE37awOXB47Z91l99gz/wer
	R9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGUcnb+ZteCXSMXzW0/YGhgPCHYxcnJICJhILFq3
	kxXCFpO4cG89WxcjF4eQwCJGiYOrmhghnHYmidcPdzGDVLEJGEr8fPGaCcQWESiXmDb1ERNI
	EbPAPkaJTdOOgxUJC4RKXHn/hg3EZhFQlZg9/QM7iM0r4C6xZuJsli5GDqB1ChJzJtmAhDkF
	PCTuPFzDAmILAZUcez6VaQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwaH2TGoH
	48oGi0OMAhyMSjy8GRfcgoVYE8uKK3MPMUpwMCuJ8G666h4sxJuSWFmVWpQfX1Sak1p8iFGa
	g0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgXHr7fQ5N5j+LwhZJOro+nWlT57r690H5Uwk
	3gflLFe8fnMzR5ZRK6NdxNns1N+50oenFmxQDvg3+8ra7uPxPTLPLXyV9v0TyDpwnP/r6elO
	L16FMOzZpLvVJNZe4qaF0x/Wl+4ON37/rPM4uOsL251sAcHpHprFN5qW2z1Oc3q/aUdncrrN
	jkVKLMUZiYZazEXFiQCaIiG4MQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

led_update_brightness helper function used to be exploited
only locally in the led-class.c module, where its result was
being passed to the brightness_show sysfs callback. With the
introduction of v4l2-flash subdevice the same functionality
became required for reading current brightness from a LED
device. This patch adds checking brightness_get callback
error code and adds the function to the LED subsystem
public API.

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
index 58f16c3..7f285d7 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -24,12 +24,6 @@
 
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
index 71b40d3..376166c 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -126,3 +126,19 @@ void led_set_brightness(struct led_classdev *led_cdev,
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
index a794817..d085c21 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -174,6 +174,16 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
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
 
 /**
  * led_sysfs_is_locked
-- 
1.7.9.5

