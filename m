Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422747Ab3FTTIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:08:52 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:34619 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422731Ab3FTTIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:08:49 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: cooloney@gmail.com, rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com
Subject: [PATCH] leds: Convert led class driver from legacy pm ops to dev_pm_ops
Date: Thu, 20 Jun 2013 13:08:44 -0600
Message-Id: <1371755324-18248-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers/leds/led-class to use dev_pm_ops for power management and
remove Legacy PM ops hooks. With this change, led class registers
suspend/resume callbacks via class->pm (dev_pm_ops) instead of Legacy
class->suspend/resume. When __device_suspend() runs call-backs, it will
find class->pm ops for the led class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/leds/led-class.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index a20752f..4336e37 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -156,7 +156,7 @@ void led_classdev_resume(struct led_classdev *led_cdev)
 }
 EXPORT_SYMBOL_GPL(led_classdev_resume);
 
-static int led_suspend(struct device *dev, pm_message_t state)
+static int led_suspend(struct device *dev)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 
@@ -176,6 +176,11 @@ static int led_resume(struct device *dev)
 	return 0;
 }
 
+static const struct dev_pm_ops leds_class_dev_pm_ops = {
+	.suspend        = led_suspend,
+	.resume         = led_resume,
+};
+
 /**
  * led_classdev_register - register a new object of led_classdev class.
  * @parent: The device to register.
@@ -252,8 +257,7 @@ static int __init leds_init(void)
 	leds_class = class_create(THIS_MODULE, "leds");
 	if (IS_ERR(leds_class))
 		return PTR_ERR(leds_class);
-	leds_class->suspend = led_suspend;
-	leds_class->resume = led_resume;
+	leds_class->pm = &leds_class_dev_pm_ops;
 	leds_class->dev_attrs = led_class_attrs;
 	return 0;
 }
-- 
1.7.10.4

