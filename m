Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3IVRA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:00:29 -0400
Received: from smtp.newsguy.com ([74.209.136.69]:58966 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab3IVRA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:00:26 -0400
From: Mike Dunn <mikedunn@newsguy.com>
To: thierry.reding@gmail.com
Cc: Mike Dunn <mikedunn@newsguy.com>, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: [PATCH v2] pwm-backlight: allow for non-increasing brightness levels
Date: Sun, 22 Sep 2013 09:59:56 -0700
Message-Id: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver assumes that the values specified in the
brightness-levels device tree property increase as they are parsed from
left to right.  But boards that invert the signal between the PWM output
and the backlight will need to specify decreasing brightness-levels.
This patch removes the assumption that the last element of the array is
the maximum value, and instead searches the array for the maximum value
and uses that in the duty cycle calculation.

Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
---
Changelog:
v2: 
- commit message reworded; correct line wrap used
- 'max_level' variable renamed to 'scale'
- loop counter variable type changed to unsigned int
- value held in scale changed from array index to actual maximum level
- blank lines added around loop for readability

 drivers/video/backlight/pwm_bl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 1fea627..5e99b88 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -27,6 +27,7 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	unsigned int		scale;
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -57,7 +58,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 
 		if (pb->levels) {
 			duty_cycle = pb->levels[brightness];
-			max = pb->levels[max];
+			max = pb->scale;
 		} else {
 			duty_cycle = brightness;
 		}
@@ -195,7 +196,14 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	}
 
 	if (data->levels) {
-		max = data->levels[data->max_brightness];
+		unsigned int i;
+
+		for (i = 0; i <= data->max_brightness; i++) {
+			if (data->levels[i] > pb->scale)
+				pb->scale = data->levels[i];
+		}
+
+		max = pb->scale;
 		pb->levels = data->levels;
 	} else
 		max = data->max_brightness;
-- 
1.8.1.5

