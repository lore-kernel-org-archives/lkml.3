Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab3ESGAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 02:00:54 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36536 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3ESGAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 02:00:53 -0400
Message-ID: <1368943247.3455.6.camel@phoenix>
Subject: [PATCH 2/2] gpio: Don't override the error code in probe error
 handling
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Denis Turischev <denis@compulab.co.il>,
        Lars Poeschel <poeschel@lemonage.de>, linux-kernel@vger.kernel.org
Date: Sun, 19 May 2013 14:00:47 +0800
In-Reply-To: <1368943117.3455.4.camel@phoenix>
References: <1368943117.3455.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, we return 0 in probe error paths when gpiochip_remove() returns 0.
Also show error message if gpiochip_remove() fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Denis Turischev <denis@compulab.co.il>
Cc: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/gpio/gpio-ml-ioh.c     | 3 +--
 drivers/gpio/gpio-pch.c        | 3 +--
 drivers/gpio/gpio-sch.c        | 6 ++----
 drivers/gpio/gpio-viperboard.c | 3 ++-
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index b733665..0966f26 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -496,8 +496,7 @@ err_irq_alloc_descs:
 err_gpiochip_add:
 	while (--i >= 0) {
 		chip--;
-		ret = gpiochip_remove(&chip->gpio);
-		if (ret)
+		if (gpiochip_remove(&chip->gpio))
 			dev_err(&pdev->dev, "Failed gpiochip_remove(%d)\n", i);
 	}
 	kfree(chip_save);
diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index cdf5996..0fec097 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -424,8 +424,7 @@ end:
 err_request_irq:
 	irq_free_descs(irq_base, gpio_pins[chip->ioh]);
 
-	ret = gpiochip_remove(&chip->gpio);
-	if (ret)
+	if (gpiochip_remove(&chip->gpio))
 		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);
 
 err_gpiochip_add:
diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 1e4de16..5af6571 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -272,10 +272,8 @@ static int sch_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 err_sch_gpio_resume:
-	err = gpiochip_remove(&sch_gpio_core);
-	if (err)
-		dev_err(&pdev->dev, "%s failed, %d\n",
-				"gpiochip_remove()", err);
+	if (gpiochip_remove(&sch_gpio_core))
+		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);
 
 err_sch_gpio_core:
 	release_region(res->start, resource_size(res));
diff --git a/drivers/gpio/gpio-viperboard.c b/drivers/gpio/gpio-viperboard.c
index 095ab14..5ac2919 100644
--- a/drivers/gpio/gpio-viperboard.c
+++ b/drivers/gpio/gpio-viperboard.c
@@ -446,7 +446,8 @@ static int vprbrd_gpio_probe(struct platform_device *pdev)
 	return ret;
 
 err_gpiob:
-	ret = gpiochip_remove(&vb_gpio->gpioa);
+	if (gpiochip_remove(&vb_gpio->gpioa))
+		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);
 
 err_gpioa:
 	return ret;
-- 
1.8.1.2



