Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3JGLjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 07:39:54 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:44004 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3JGLju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 07:39:50 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/12] pwm-backlight: Refactor backlight power on/off
Date: Mon,  7 Oct 2013 13:37:36 +0200
Message-Id: <1381145866-445-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381145866-445-1-git-send-email-treding@nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for adding an optional regulator and enable GPIO to the
driver, split the power on and power off sequences into separate
functions to reduce code duplication at the multiple call sites.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- add back pwm_config(..., 0, ...) call on power off
- move whitespace cleanups to separate patch

 drivers/video/backlight/pwm_bl.c | 53 +++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 774bce3..ab9d5e6 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -35,6 +35,31 @@ struct pwm_bl_data {
 	void			(*exit)(struct device *);
 };
 
+static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness,
+				   int max)
+{
+	int duty_cycle, err;
+
+	if (pb->levels) {
+		duty_cycle = pb->levels[brightness];
+		max = pb->levels[max];
+	} else {
+		duty_cycle = brightness;
+	}
+
+	duty_cycle = (duty_cycle * (pb->period - pb->lth_brightness) / max) +
+		     pb->lth_brightness;
+
+	pwm_config(pb->pwm, duty_cycle, pb->period);
+	pwm_enable(pb->pwm);
+}
+
+static void pwm_backlight_power_off(struct pwm_bl_data *pb)
+{
+	pwm_config(pb->pwm, 0, pb->period);
+	pwm_disable(pb->pwm);
+}
+
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = bl_get_data(bl);
@@ -49,24 +74,10 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 	if (pb->notify)
 		brightness = pb->notify(pb->dev, brightness);
 
-	if (brightness == 0) {
-		pwm_config(pb->pwm, 0, pb->period);
-		pwm_disable(pb->pwm);
-	} else {
-		int duty_cycle;
-
-		if (pb->levels) {
-			duty_cycle = pb->levels[brightness];
-			max = pb->levels[max];
-		} else {
-			duty_cycle = brightness;
-		}
-
-		duty_cycle = pb->lth_brightness +
-		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
-		pwm_config(pb->pwm, duty_cycle, pb->period);
-		pwm_enable(pb->pwm);
-	}
+	if (brightness > 0)
+		pwm_backlight_power_on(pb, brightness, max);
+	else
+		pwm_backlight_power_off(pb);
 
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, brightness);
@@ -267,8 +278,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_power_off(pb);
 
 	if (pb->exit)
 		pb->exit(&pdev->dev);
@@ -285,8 +295,7 @@ static int pwm_backlight_suspend(struct device *dev)
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
 
-	pwm_config(pb->pwm, 0, pb->period);
-	pwm_disable(pb->pwm);
+	pwm_backlight_power_off(pb);
 
 	if (pb->notify_after)
 		pb->notify_after(pb->dev, 0);
-- 
1.8.4

