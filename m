Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3FAD6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 23:58:39 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:57104 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755270Ab3FAD6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 23:58:32 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2013 23:58:32 EDT
From: Shuah Khan <shuah.kh@samsung.com>
To: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, rafael.j.wysocki@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Wed, 14 Nov 2040 04:27:17 -0700
Message-Id: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers/video/backlight/class to use dev_pm_ops for power
management and remove Legacy PM ops hooks. With this change, rtc class
registers suspend/resume callbacks via class->pm (dev_pm_ops) instead of
Legacy class->suspend/resume. When __device_suspend() runs call-backs,
it will find class->pm ops for the backlight class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
---

v2: Updated changelog to correct device class.

 drivers/video/backlight/backlight.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index c74e7aa..0ffb251 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -208,7 +208,7 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
 
 static struct class *backlight_class;
 
-static int backlight_suspend(struct device *dev, pm_message_t state)
+static int backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
 
@@ -236,6 +236,9 @@ static int backlight_resume(struct device *dev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(backlight_class_dev_pm_ops, backlight_suspend,
+			 backlight_resume);
+
 static void bl_device_release(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
@@ -414,8 +417,7 @@ static int __init backlight_class_init(void)
 	}
 
 	backlight_class->dev_attrs = bl_device_attributes;
-	backlight_class->suspend = backlight_suspend;
-	backlight_class->resume = backlight_resume;
+	backlight_class->pm = &backlight_class_dev_pm_ops;
 	return 0;
 }
 
-- 
1.7.10.4

