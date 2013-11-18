Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3KRSqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:46:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3KRSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:42:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 20/24] backlight: atmel-pwm-bl: fix deferred probe from __init
Date: Mon, 18 Nov 2013 10:42:30 -0800
Message-Id: <20131118184223.479438415@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184222.017393843@linuxfoundation.org>
References: <20131118184222.017393843@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 9d3fde86b15303decea632c929fbf1f3ae4501f2 upstream.

Move probe out of __init section and don't use platform_driver_probe
which cannot be used with deferred probing.

Since commit e9354576 ("gpiolib: Defer failed gpio requests by default")
this driver might return -EPROBE_DEFER if a gpio_request fails.

Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/backlight/atmel-pwm-bl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -118,7 +118,7 @@ static const struct backlight_ops atmel_
 	.update_status  = atmel_pwm_bl_set_intensity,
 };
 
-static int __init atmel_pwm_bl_probe(struct platform_device *pdev)
+static int atmel_pwm_bl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	const struct atmel_pwm_bl_platform_data *pdata;
@@ -203,7 +203,7 @@ err_free_mem:
 	return retval;
 }
 
-static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
+static int atmel_pwm_bl_remove(struct platform_device *pdev)
 {
 	struct atmel_pwm_bl *pwmbl = platform_get_drvdata(pdev);
 
@@ -222,10 +222,11 @@ static struct platform_driver atmel_pwm_
 		.name = "atmel-pwm-bl",
 	},
 	/* REVISIT add suspend() and resume() */
-	.remove = __exit_p(atmel_pwm_bl_remove),
+	.probe = atmel_pwm_bl_probe,
+	.remove = atmel_pwm_bl_remove,
 };
 
-module_platform_driver_probe(atmel_pwm_bl_driver, atmel_pwm_bl_probe);
+module_platform_driver(atmel_pwm_bl_driver);
 
 MODULE_AUTHOR("Hans-Christian egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Atmel PWM backlight driver");


