Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaHTNmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:42:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25428 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaHTNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:42:30 -0400
X-AuditID: cbfee61a-f79e46d00000134f-19-53f4a5c381cf
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 3/4] leds: add API for setting torch brightness
Date: Wed, 20 Aug 2014 15:41:57 +0200
Message-id: <1408542118-32723-4-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAd3DS78EG6x/aWOxccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8ay/u2sBc8UKja8ncjSwNgn3cXIwSEhYCLROy+hi5ET
	yBSTuHBvPVsXIxeHkMAiRomDD16zQzjtTBK7FjYzgVSxCRhK/HzxGswWESiX6Hn/DKyDWWA1
	o8SdrV9ZQRLCAm4SG3seMIPYLAKqEhcm3GIBsXkFPCQadk1kh9isIDFnkg1ImFPAU2Lrhh+M
	ILYQUEnz0jMsExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDq9nUjsYVzZYHGIU
	4GBU4uFtWPAlWIg1say4MvcQowQHs5IIb3snUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbr
	QCGB9MSS1OzU1ILUIpgsEwenVAOjepeuSdD3S4GLosJ3eoVPCzUPnV+s/enGtx5bzVql43Vp
	t7f8Zj9u1Pxig2PlmignVlPOpMinPaeXv1u4/oLtn44JfLu6uRLZPN5cUOa452HZP4XnkfL7
	DeIH/5ydtZAjze7HzFT/Us0jposPxrwwOfWTRf25bOPeFxe5l9zLWTT9eOK1D6FXlFiKMxIN
	tZiLihMB0hE5IysCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares ground for addition of LED Flash Class extension to
the LED subsystem. Since turning the torch on must have guaranteed
immediate effect the brightness_set op can't be used for it. Drivers must
schedule a work queue task in this op to be compatible with led-triggers,
which call brightess_set from timer irqs. In order to address this
limitation a torch_brightness_set op and led_set_torch_brightness API
is introduced. Setting brightness sysfs attribute will result in calling
brightness_set op for LED Class devices and torch_brightness_set op for
LED Flash Class devices, whereas triggers will still call brightness
op in both cases.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |    9 +++++++--
 drivers/leds/led-core.c  |   14 ++++++++++++++
 include/linux/leds.h     |   21 +++++++++++++++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 0bc0ba9..f640da9 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -56,9 +56,14 @@ static ssize_t brightness_store(struct device *dev,
 
 	if (state == LED_OFF)
 		led_trigger_remove(led_cdev);
-	__led_set_brightness(led_cdev, state);
 
-	ret = size;
+	if (led_cdev->flags & LED_DEV_CAP_TORCH)
+		ret = led_set_torch_brightness(led_cdev, state);
+	else
+		__led_set_brightness(led_cdev, state);
+
+	if (!ret)
+		ret = size;
 unlock:
 #ifdef CONFIG_V4L2_FLASH_LED_CLASS
 	mutex_unlock(&led_cdev->led_lock);
diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 4649ea5..093265f 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -144,6 +144,20 @@ int led_update_brightness(struct led_classdev *led_cdev)
 }
 EXPORT_SYMBOL(led_update_brightness);
 
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
index ef343f1..df0715c 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -43,11 +43,21 @@ struct led_classdev {
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
 
@@ -156,6 +166,17 @@ extern void led_set_brightness(struct led_classdev *led_cdev,
 extern int led_update_brightness(struct led_classdev *led_cdev);
 
 /**
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

