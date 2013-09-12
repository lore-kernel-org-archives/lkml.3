Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3ILShI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:37:08 -0400
Received: from smtp.newsguy.com ([74.209.136.69]:60147 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab3ILShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:37:04 -0400
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
Subject: [PATCH] pwm-backlight: allow for non-increasing brightness levels
Date: Thu, 12 Sep 2013 11:35:52 -0700
Message-Id: <1379010952-8928-1-git-send-email-mikedunn@newsguy.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver assumes that the values specified in the brightness-levels
device tree property increase as they are parsed from left to right.  But boards
that invert the signal between the PWM output and the backlight will need to
specify decreasing brightness-levels.  This patch removes the assumption that
the last element of the array is the max value, and instead searches the array
for the max value and uses that as the normalizing value when determining the
duty cycle.

Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
---
 drivers/video/backlight/pwm_bl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 1fea627..d66aaa0 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -27,6 +27,7 @@ struct pwm_bl_data {
 	unsigned int		period;
 	unsigned int		lth_brightness;
 	unsigned int		*levels;
+	unsigned int		max_level;
 	int			(*notify)(struct device *,
 					  int brightness);
 	void			(*notify_after)(struct device *,
@@ -57,7 +58,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 
 		if (pb->levels) {
 			duty_cycle = pb->levels[brightness];
-			max = pb->levels[max];
+			max = pb->levels[pb->max_level];
 		} else {
 			duty_cycle = brightness;
 		}
@@ -195,7 +196,15 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	}
 
 	if (data->levels) {
-		max = data->levels[data->max_brightness];
+		int i, max_value = 0, max_idx = 0;
+		for (i = 0; i <= data->max_brightness; i++) {
+			if (data->levels[i] > max_value) {
+				max_value = data->levels[i];
+				max_idx = i;
+			}
+		}
+		pb->max_level = max_idx;
+		max = data->levels[max_idx];
 		pb->levels = data->levels;
 	} else
 		max = data->max_brightness;
-- 
1.8.1.5

