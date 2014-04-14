Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaDNWAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:00:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35578 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755953AbaDNWAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:00:31 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 11/11] backlight: pwm_bl: retrieve configured pwm period
Date: Mon, 14 Apr 2014 23:59:53 +0200
Message-Id: <1397512793-10325-12-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PWM core is now able to initialize the PWM period from platform_data. Use it
and if it is not configured, use the supplied pwm_period_ns.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/video/backlight/pwm_bl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index b75201ff46f6..1bb8a69062c5 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -304,12 +304,14 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	/*
 	 * The DT case will set the pwm_period_ns field to 0 and store the
 	 * period, parsed from the DT, in the PWM device. For the non-DT case,
-	 * set the period from platform data.
+	 * set the period from platform data if it is not already set.
 	 */
-	if (data->pwm_period_ns > 0)
+	pb->period = pwm_get_period(pb->pwm);
+	if (!pb->period && (data->pwm_period_ns > 0)) {
+		pb->period = data->pwm_period_ns;
 		pwm_set_period(pb->pwm, data->pwm_period_ns);
+	}
 
-	pb->period = pwm_get_period(pb->pwm);
 	pb->lth_brightness = data->lth_brightness * (pb->period / pb->scale);
 
 	memset(&props, 0, sizeof(struct backlight_properties));
-- 
1.8.3.2

