Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3ANKx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:53:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51709 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3ANKx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:53:27 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: mvebu: Don't free chip label memory
Date: Mon, 14 Jan 2013 11:53:20 +0100
Message-Id: <1358160800-12185-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
X-Provags-ID: V02:K0:++Z4jBZttXS2a8Bw3kiTEkeUvQQ0nQcq17JU1e6rFAJ
 GIwC5hjWuHkbb3iHv4Xb24yNuv7/tKhyfs8K6f8L0k//Zbyd/U
 QPKaO/23V7jOrOPzAYgB98x83zHDUlgi2pAUSYRcJqnnBEIDjG
 cUjr0y2xtbHB+4G8Cztuw9ebqdkx/5Ui45JuzS2C6M15yypmZC
 rHWKleRy4ottOEDwTVPx/UcL7KbSnfylHycLi0etTVde8nem1s
 2zedO0nv+OWRwy8uQs1H2CGcfiz6SlPaeNnM+x1s4tUSELNzXb
 SxWuSaFyqPblnexRdYBa1/iCYPxbpUUH2G4ZMmi9kHJyRMw9Tl
 MsR0LpLF1BN8LoXfiO0YF87BrGOImrh78dIsQm//4SXV4syVmq
 /2Iq5D8D0f6Cj3O42vCkqWGosdJr8+54KN+WiB2RSAfT7+Jt6w
 e9zPA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gpio_chip.label field is a const char * and assigned the value of a
call to dev_name(). Memory obtained from dev_name() should not be freed
by drivers.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/gpio/gpio-mvebu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index 7d9bd94..6819d63 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -547,7 +547,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	mvchip->membase = devm_request_and_ioremap(&pdev->dev, res);
 	if (! mvchip->membase) {
 		dev_err(&pdev->dev, "Cannot ioremap\n");
-		kfree(mvchip->chip.label);
 		return -ENOMEM;
 	}
 
@@ -557,14 +556,12 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 		if (! res) {
 			dev_err(&pdev->dev, "Cannot get memory resource\n");
-			kfree(mvchip->chip.label);
 			return -ENODEV;
 		}
 
 		mvchip->percpu_membase = devm_request_and_ioremap(&pdev->dev, res);
 		if (! mvchip->percpu_membase) {
 			dev_err(&pdev->dev, "Cannot ioremap\n");
-			kfree(mvchip->chip.label);
 			return -ENOMEM;
 		}
 	}
@@ -625,7 +622,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	mvchip->irqbase = irq_alloc_descs(-1, 0, ngpios, -1);
 	if (mvchip->irqbase < 0) {
 		dev_err(&pdev->dev, "no irqs\n");
-		kfree(mvchip->chip.label);
 		return -ENOMEM;
 	}
 
@@ -633,7 +629,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 				    mvchip->membase, handle_level_irq);
 	if (! gc) {
 		dev_err(&pdev->dev, "Cannot allocate generic irq_chip\n");
-		kfree(mvchip->chip.label);
 		return -ENOMEM;
 	}
 
@@ -668,7 +663,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		irq_remove_generic_chip(gc, IRQ_MSK(ngpios), IRQ_NOREQUEST,
 					IRQ_LEVEL | IRQ_NOPROBE);
 		kfree(gc);
-		kfree(mvchip->chip.label);
 		return -ENODEV;
 	}
 
-- 
1.8.1

