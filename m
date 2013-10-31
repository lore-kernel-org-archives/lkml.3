Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab3JaR6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:58:23 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:43645 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3JaR6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:58:18 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH v3 4/9] backlight: atmel-pwm-bl: clean up probe error handling
Date: Thu, 31 Oct 2013 18:57:39 +0100
Message-Id: <1383242264-7652-5-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383242264-7652-1-git-send-email-jhovold@gmail.com>
References: <1383064064-4983-1-git-send-email-jhovold@gmail.com>
 <1383242264-7652-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up probe error handling by checking parameters before any
allocations and removing an obsolete error label. Also remove
unnecessary reset of private gpio number.

Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/backlight/atmel-pwm-bl.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 4886028..01af5c2 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -126,40 +126,33 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 	struct atmel_pwm_bl *pwmbl;
 	int retval;
 
+	pdata = dev_get_platdata(&pdev->dev);
+	if (!pdata)
+		return -ENODEV;
+
+	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
+			pdata->pwm_duty_min > pdata->pwm_duty_max ||
+			pdata->pwm_frequency == 0)
+		return -EINVAL;
+
 	pwmbl = devm_kzalloc(&pdev->dev, sizeof(struct atmel_pwm_bl),
 				GFP_KERNEL);
 	if (!pwmbl)
 		return -ENOMEM;
 
 	pwmbl->pdev = pdev;
-
-	pdata = dev_get_platdata(&pdev->dev);
-	if (!pdata) {
-		retval = -ENODEV;
-		goto err_free_mem;
-	}
-
-	if (pdata->pwm_compare_max < pdata->pwm_duty_max ||
-			pdata->pwm_duty_min > pdata->pwm_duty_max ||
-			pdata->pwm_frequency == 0) {
-		retval = -EINVAL;
-		goto err_free_mem;
-	}
-
 	pwmbl->pdata = pdata;
 	pwmbl->gpio_on = pdata->gpio_on;
 
 	retval = pwm_channel_alloc(pdata->pwm_channel, &pwmbl->pwmc);
 	if (retval)
-		goto err_free_mem;
+		return retval;
 
 	if (pwmbl->gpio_on != -1) {
 		retval = devm_gpio_request(&pdev->dev, pwmbl->gpio_on,
 					"gpio_atmel_pwm_bl");
-		if (retval) {
-			pwmbl->gpio_on = -1;
+		if (retval)
 			goto err_free_pwm;
-		}
 
 		/* Turn display off by default. */
 		retval = gpio_direction_output(pwmbl->gpio_on,
@@ -197,7 +190,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
-err_free_mem:
+
 	return retval;
 }
 
-- 
1.8.4.2

