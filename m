Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3FAXHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 19:07:37 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:56540 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952Ab3FAXHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 19:07:33 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: rpurdie@rpsys.net, FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, rafael.j.wysocki@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH v3] backlight: Convert from Legacy pm ops to dev_pm_ops
Date: Sat,  1 Jun 2013 17:07:27 -0600
Message-Id: <1370128047-2444-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers/video/backlight/class to use dev_pm_ops for power
management and remove Legacy PM ops hooks. With this change, backlight
class registers suspend/resume callbacks via class->pm (dev_pm_ops)
instead of Legacy class->suspend/resume. When __device_suspend() runs
call-backs, it will find class->pm ops for the backlight class.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
---

v2: Updated changelog to correct device class.
v3: Updated changelog to correct device class.

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

