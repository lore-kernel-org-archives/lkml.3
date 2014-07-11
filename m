Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaGKOEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:04:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59388 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaGKOEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:53 -0400
X-AuditID: cbfee61b-f79f86d00000144c-02-53bfef03fc56
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 06/21] leds: add API for setting torch brightness
Date: Fri, 11 Jul 2014 16:04:09 +0200
Message-id: <1405087464-13762-7-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV3m9/uDDW5uErbYOGM9q8XRnROZ
	LOYfOcdq0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWu3c9ZXXg9Ng56y67x575P1g9+ras
	YvT4vEkugCWKyyYlNSezLLVI3y6BK2Pi0sOsBeeUK7Y1XmJtYJwl28XIySEhYCLx6cwBVghb
	TOLCvfVsILaQwHRGiZYv0V2MXEB2O5PE+qWXmEESbAKGEj9fvGYCsUUEyiV63j9jAyliFljN
	KHFn61ewScICHhKfWleBFbEIqEr83ncDbCovULzl41n2LkYOoG0KEnMm2YCEOQU8JQ7234Ra
	7CHxcO0J9gmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfXM+kdjKsaLA4xCnAw
	KvHwnlizL1iINbGsuDL3EKMEB7OSCO/VN/uDhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUO
	FBJITyxJzU5NLUgtgskycXBKNTDOWJkz3WfV44OXerll1lq6P31k8jGM+cOUzevfbU5kMzqh
	dee8wg5e2x6+BNfr3cHTHD4rPj4+Pf3MjLzaZm6X2f/vSn+YIvq07LyC+imvnbvuPNLeUslT
	tL9nq+FBDusPJkoL16+ZPFNjjWWo4WPTV4Wf9qc/1hCLDotl2tG73VbZ2756mfE0JZbijERD
	Leai4kQAZniXcisCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares ground for addition of LED Flash Class extension to
the LED subsystem. Since turning the torch on must have guaranteed
immediate effect the brightness_set op can't be used for it. Drivers must
schedule a work queue task in this op to be compatible with led-triggers,
which call brightess_set from timer irqs. In order to address this
limitiation a torch_brightness_set op and led_set_torch_brightness API
is introduced. Setting brightness sysfs attribute will result in calling
brightness_set op for LED Class decices and torch_brightness_set op for
LED Flash Class devices, whereas triggers will still call brightness
op in both cases.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |   18 ++++++++++++++++--
 drivers/leds/led-core.c  |   15 +++++++++++++++
 include/linux/leds.h     |   22 ++++++++++++++++++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index a96a1a7..c17dda0 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -44,15 +44,29 @@ static ssize_t brightness_store(struct device *dev,
 
 	mutex_lock(&led_cdev->led_lock);
 
+	/*
+	 * Having LED_DEV_CAP_TORCH implies this is LED Flash Class
+	 * device and we need to check sysfs accessibility.
+	 */
+	if (led_cdev->flags & LED_DEV_CAP_TORCH) {
+		if (led_sysfs_is_locked(led_cdev)) {
+			ret = -EBUSY;
+			goto unlock;
+		}
+	}
+
 	ret = kstrtoul(buf, 10, &state);
 	if (ret)
 		goto unlock;
 
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
-	__led_set_brightness(led_cdev, state);
 
-	return size;
+	if (led_cdev->flags & LED_DEV_CAP_TORCH)
+		ret = led_set_torch_brightness(led_cdev, state);
+	else
+		__led_set_brightness(led_cdev, state);
+
 	ret = size;
 unlock:
 	mutex_unlock(&led_cdev->led_lock);
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index d156fb6..0ce087a 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -143,6 +143,21 @@ int led_update_brightness(struct led_classdev *led_cdev)
 	return ret;
 }
 EXPORT_SYMBOL(led_update_brightness);
+
+int led_set_torch_brightness(struct led_classdev *led_cdev,
+				enum led_brightness brightness)
+{
+	int ret = 0;
+
+	led_cdev->brightness = min(brightness, led_cdev->max_brightness);
+
+	if (!(led_cdev->flags & LED_SUSPENDED))
+		ret = led_cdev->torch_brightness_set(led_cdev,
+						     led_cdev->brightness);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_set_torch_brightness);
+
 /* Caller must ensure led_cdev->led_lock held */
 void led_sysfs_lock(struct led_classdev *led_cdev)
 {
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 1a130cc..9bea9e6 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -44,11 +44,21 @@ struct led_classdev {
 #define LED_BLINK_ONESHOT_STOP	(1 << 18)
 #define LED_BLINK_INVERT	(1 << 19)
 #define LED_SYSFS_LOCK		(1 << 20)
+#define LED_DEV_CAP_TORCH	(1 << 21)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
 	void		(*brightness_set)(struct led_classdev *led_cdev,
 					  enum led_brightness brightness);
+	/*
+	 * Set LED brightness immediately - it is required for flash led
+	 * devices as they require setting torch brightness to have immediate
+	 * effect. brightness_set op cannot be used for this purpose because
+	 * the led drivers schedule a work queue task in it to allow for
+	 * being called from led-triggers, i.e. from the timer irq context.
+	 */
+	int		(*torch_brightness_set)(struct led_classdev *led_cdev,
+					enum led_brightness brightness);
 	/* Get LED brightness level */
 	enum led_brightness (*brightness_get)(struct led_classdev *led_cdev);
 
@@ -156,6 +166,18 @@ extern void led_set_brightness(struct led_classdev *led_cdev,
  */
 extern int led_update_brightness(struct led_classdev *led_cdev);
 
+/**
+ * led_set_torch_brightness - set torch LED brightness
+ * @led_cdev: the LED to set
+ * @brightness: the brightness to set it to
+ *
+ * Returns: 0 on success or negative error value on failure
+ *
+ * Set a torch LED's brightness.
+ */
+extern int led_set_torch_brightness(struct led_classdev *led_cdev,
+					enum led_brightness brightness);
+/**
  * led_sysfs_lock - lock LED sysfs interface
  * @led_cdev: the LED to set
  *
-- 
1.7.9.5

