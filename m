Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3JVR2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:28:39 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:33221 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3JVR1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:27:16 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 9/9] backlight: atmel-pwm-bl: use gpio_request_one
Date: Tue, 22 Oct 2013 19:26:59 +0200
Message-Id: <1382462819-28576-10-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
References: <1382462819-28576-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one rather than requesting and setting direction
in two calls.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 1277e0c..5ea2517 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -124,6 +124,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 	const struct atmel_pwm_bl_platform_data *pdata;
 	struct backlight_device *bldev;
 	struct atmel_pwm_bl *pwmbl;
+	int flags;
 	int retval;
 
 	pdata = dev_get_platdata(&pdev->dev);
@@ -149,14 +150,14 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 		return retval;
 
 	if (gpio_is_valid(pwmbl->gpio_on)) {
-		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
-					"gpio_atmel_pwm_bl");
-		if (retval)
-			goto err_free_pwm;
-
 		/* Turn display off by default. */
-		retval = gpio_direction_output(pwmbl->gpio_on,
-				0 ^ pdata->on_active_low);
+		if (pdata->on_active_low)
+			flags = GPIOF_OUT_INIT_HIGH;
+		else
+			flags = GPIOF_OUT_INIT_LOW;
+
+		retval = devm_gpio_request_one(&pdev->dev, pwmbl->gpio_on,
+						flags, "gpio_atmel_pwm_bl");
 		if (retval)
 			goto err_free_pwm;
 	}
-- 
1.8.4

