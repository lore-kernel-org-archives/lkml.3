Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab3JaR63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:58:29 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:45379 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3JaR6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:58:21 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 9/9] backlight: atmel-pwm-bl: use gpio_request_one
Date: Thu, 31 Oct 2013 18:57:44 +0100
Message-Id: <1383242264-7652-10-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383242264-7652-1-git-send-email-jhovold@gmail.com>
References: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
 <1383242264-7652-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one rather than requesting and setting direction
in two calls.

Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index bd1ed34..261b1a4 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -124,6 +124,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 	const struct atmel_pwm_bl_platform_data *pdata;
 	struct backlight_device *bldev;
 	struct atmel_pwm_bl *pwmbl;
+	unsigned long flags;
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
1.8.4.2

