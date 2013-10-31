Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3JaR7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:59:46 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:52163 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JaR6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:58:20 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 8/9] backlight: atmel-pwm-bl: refactor gpio_on handling
Date: Thu, 31 Oct 2013 18:57:43 +0100
Message-Id: <1383242264-7652-9-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383242264-7652-1-git-send-email-jhovold@gmail.com>
References: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
 <1383242264-7652-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helper function to control the gpio_on signal.

Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index c254209..bd1ed34 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -26,6 +26,14 @@ struct atmel_pwm_bl {
 	int					gpio_on;
 };
 
+static void atmel_pwm_bl_set_gpio_on(struct atmel_pwm_bl *pwmbl, int on)
+{
+	if (!gpio_is_valid(pwmbl->gpio_on))
+		return;
+
+	gpio_set_value(pwmbl->gpio_on, on ^ pwmbl->pdata->on_active_low);
+}
+
 static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 {
 	struct atmel_pwm_bl *pwmbl = bl_get_data(bd);
@@ -48,19 +56,13 @@ static int atmel_pwm_bl_set_intensity(struct backlight_device *bd)
 		pwm_duty = pwmbl->pdata->pwm_duty_min;
 
 	if (!intensity) {
-		if (gpio_is_valid(pwmbl->gpio_on)) {
-			gpio_set_value(pwmbl->gpio_on,
-					0 ^ pwmbl->pdata->on_active_low);
-		}
+		atmel_pwm_bl_set_gpio_on(pwmbl, 0);
 		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
 		pwm_channel_disable(&pwmbl->pwmc);
 	} else {
 		pwm_channel_enable(&pwmbl->pwmc);
 		pwm_channel_writel(&pwmbl->pwmc, PWM_CUPD, pwm_duty);
-		if (gpio_is_valid(pwmbl->gpio_on)) {
-			gpio_set_value(pwmbl->gpio_on,
-					1 ^ pwmbl->pdata->on_active_low);
-		}
+		atmel_pwm_bl_set_gpio_on(pwmbl, 1);
 	}
 
 	return 0;
@@ -196,10 +198,7 @@ static int atmel_pwm_bl_remove(struct platform_device *pdev)
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
-	if (gpio_is_valid(pwmbl->gpio_on)) {
-		gpio_set_value(pwmbl->gpio_on,
-					0 ^ pwmbl->pdata->on_active_low);
-	}
+	atmel_pwm_bl_set_gpio_on(pwmbl, 0);
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
 
-- 
1.8.4.2

