Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaI3NYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:24:20 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:49242 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaI3NYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:24:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linus.walleij@linaro.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: fix callers of gpiochip_remove
Date: Tue, 30 Sep 2014 15:24:08 +0200
Message-ID: <2923496.zl6JUbOQrZ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Yzz6peKCGBQ7sGdBCmT+wJsYgKHYvUmUxUgwLqjMMkL
 10MBtYB6Gw4Td4ai5ZpevLhlrmKT5J34h+wf/+TsN9lPMpyJkA
 yLvTCTBqS9VJXGgOqLVrpbk6LlqoeQjbvyQncrk+hvOld7sEaX
 Df/UjZgnmaFCuBvpOlm/8wjxfjVg9w2S8wVh7frKX0gpboEBiK
 kgpwuIBh7YUrxegmZXiohPSVsK+z55OudmS5426rE0x2A34IYH
 LOkDqiug8QnQ+VwsYUHiABEJc8zBonqPumO2mfWJxYmlUwAxQV
 gxYBFi79He6ELHB1plJYNDuCogirhxD2rJeDiZ8fOA7wa9ZrUi
 h42zMj0EYuOER239SSJQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent API change made gpiochip_remove return void instead of an
error value, which broke drivers that use this return value:

gpio/gpio-sch311x.c: In function 'sch311x_gpio_probe':
gpio/gpio-sch311x.c:286:7: error: void value not ignored as it ought to be
   if (gpiochip_remove(&priv->blocks[i].chip))
       ^

This changes the callers that I have found during randconfig testing
so they no longer depend on the error code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: e1db1706c86e ("gpio: gpiolib: set gpiochip_remove retval to void")

diff --git a/drivers/gpio/gpio-sch311x.c b/drivers/gpio/gpio-sch311x.c
index 223830cb95ca..1c8e45b92471 100644
--- a/drivers/gpio/gpio-sch311x.c
+++ b/drivers/gpio/gpio-sch311x.c
@@ -283,9 +283,7 @@ exit_err:
 	release_region(pdata->runtime_reg + GP1, 6);
 	/* release already registered chips */
 	for (--i; i >= 0; i--)
-		if (gpiochip_remove(&priv->blocks[i].chip))
-			dev_err(&pdev->dev,
-				"Could not unregister gpiochip, %d\n", err);
+		gpiochip_remove(&priv->blocks[i].chip);
 
 	return err;
 }
diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index 9771bdb7ff38..a12c78206e36 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -1029,7 +1029,8 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 
 	pc->pctl_dev = pinctrl_register(&bcm2835_pinctrl_desc, dev, pc);
 	if (!pc->pctl_dev) {
-		return gpiochip_remove(&pc->gpio_chip) ? : -EINVAL;
+		gpiochip_remove(&pc->gpio_chip);
+		return -EINVAL;
 	}
 
 	pc->gpio_range = bcm2835_pinctrl_gpio_range;
@@ -1045,7 +1046,8 @@ static int bcm2835_pinctrl_remove(struct platform_device *pdev)
 	struct bcm2835_pinctrl *pc = platform_get_drvdata(pdev);
 
 	pinctrl_unregister(pc->pctl_dev);
-	return gpiochip_remove(&pc->gpio_chip);
+	gpiochip_remove(&pc->gpio_chip);
+	return 0;
 }
 
 static struct of_device_id bcm2835_pinctrl_match[] = {

