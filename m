Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaDNWDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:03:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35569 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755943AbaDNWA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:00:29 -0400
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
Subject: [PATCHv2 10/11] leds: leds-pwm: retrieve configured pwm period
Date: Mon, 14 Apr 2014 23:59:52 +0200
Message-Id: <1397512793-10325-11-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PWM core is now able to initialize the PWM period. Use it and if it is not
configured, use the supplied pwm_period_ns.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/leds/leds-pwm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 7d0aaed1e23a..aa770ec1e892 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -181,7 +181,6 @@ static int led_pwm_probe(struct platform_device *pdev)
 			led_dat->cdev.name = cur_led->name;
 			led_dat->cdev.default_trigger = cur_led->default_trigger;
 			led_dat->active_low = cur_led->active_low;
-			led_dat->period = cur_led->pwm_period_ns;
 			led_dat->cdev.brightness_set = led_pwm_set;
 			led_dat->cdev.brightness = LED_OFF;
 			led_dat->cdev.max_brightness = cur_led->max_brightness;
@@ -191,6 +190,10 @@ static int led_pwm_probe(struct platform_device *pdev)
 			if (led_dat->can_sleep)
 				INIT_WORK(&led_dat->work, led_pwm_work);
 
+			led_dat->period = pwm_get_period(led_dat->pwm);
+			if (!led_dat->period && (cur_led->pwm_period_ns > 0))
+				led_dat->period = cur_led->pwm_period_ns;
+
 			ret = led_classdev_register(&pdev->dev, &led_dat->cdev);
 			if (ret < 0)
 				goto err;
-- 
1.8.3.2

