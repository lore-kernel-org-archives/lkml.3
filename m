Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029AbaCTOzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:55:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29151 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815AbaCTOvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:38 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-3f-532b007909d0
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC 2/8] leds: Improve and export led_update_brightness function
Date: Thu, 20 Mar 2014 15:51:04 +0100
Message-id: <1395327070-20215-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jQd1KBu1gg39zBS1urTvHanF050Qm
	i/lHgKzeq88ZLc42vWG3uLxrDpvF1jfrGC16Nmxltdi96ymrxeE37awOXB47Z91l99gz/wer
	R9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVsmr+JveC+aMWtHXNYGhgnCnUxcnJICJhI7JzU
	zQRhi0lcuLeerYuRi0NIYDqjxISGHkaQhJBAJ5PE2RXKIDabgKHEzxevwRpEBMolpk19xATS
	wCywj1Fi07TjzCAJYYEAiY+7L4HZLAKqEjOOrASzeQU8JPa1LgayOYC2KUjMmWQDEuYU8JRY
	urQLLCwEVHJ2YsQERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLD7JnUDsaVDRaH
	GAU4GJV4eFfs0QwWYk0sK67MPcQowcGsJMJr91wrWIg3JbGyKrUoP76oNCe1+BCjNAeLkjjv
	gVbrQCGB9MSS1OzU1ILUIpgsEwenVAPjzolNp1Q8U09f0ZzdvX/mvrtOzDym8fvT/d28+tk/
	xDpJJpw6eGTVXemwrrrPQmfyJn+qT6/dsaM1UK40I8dZaQ7/vckzky+/CP66oXBSEvO0CdtZ
	uVwlPi0U+aRR08FtHd114GfttB8CjW7nuJsSZqf1b2FsLGE2Z1N6K3ac6/vuzV5CPolKLMUZ
	iYZazEXFiQA8C6CoLwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

led_update_brightness helper function used to be exploited
only locally in the led-class.c module, where its result was
being passed to the brightness_show sysfs callback. With the
introduction of v4l2-flash subdevice the same functionality
became required for checking the current flash strobe status.
This patch adds checking brightness_get callback error code
and adds the function to the LED subsystem public API.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/led-class.c |    6 ------
 drivers/leds/led-core.c  |   17 +++++++++++++++++
 include/linux/leds.h     |   10 ++++++++++
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 0510532..04de352 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -27,12 +27,6 @@
 
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
index 093703c..21ceda1 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -166,6 +166,23 @@ void led_set_brightness(struct led_classdev *led_cdev,
 }
 EXPORT_SYMBOL(led_set_brightness);
 
+int led_update_brightness(struct led_classdev *led_cdev)
+{
+	int ret;
+
+	if (led_cdev->brightness_get == NULL)
+		return -EINVAL;
+
+	ret = led_cdev->brightness_get(led_cdev);
+	if (ret >= 0)
+		led_cdev->brightness = ret;
+	else
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(led_update_brightness);
+
 int led_set_flash_mode(struct led_classdev *led_cdev,
 			bool flash_mode)
 {
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 1bf0ab3..5bf05cc 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -190,6 +190,16 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
 /**
+ * led_update_brightness - update LED brightness
+ * @led_cdev: the LED to query about
+ *
+ * Get an LED's current brightness and update led_cdev->brightness
+ * member with the obtained value.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+extern int led_update_brightness(struct led_classdev *led_cdev);
+
 /**
  * led_set_flash_mode - set LED flash mode
  * @led_cdev: the LED to set
-- 
1.7.9.5

