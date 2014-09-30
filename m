Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaI3OMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:12:14 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:56136 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916AbaI3OMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:12:13 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
Subject: [PATCH 1/2] gpio: remove remaining users of gpiochip_remove() retval
Date: Tue, 30 Sep 2014 19:45:41 +0530
Message-Id: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some driver in gpio still check for return value from gpiochip_remove
Get rid of the check for return value.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/gpio/gpio-crystalcove.c |   12 ++++--------
 drivers/gpio/gpio-omap.c        |    2 +-
 drivers/gpio/gpio-zynq.c        |   10 ++--------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 934462f..0345b94 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -346,22 +346,18 @@ static int crystalcove_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 out_remove_gpio:
-	WARN_ON(gpiochip_remove(&cg->chip));
+	gpiochip_remove(&cg->chip);
 	return retval;
 }
 
 static int crystalcove_gpio_remove(struct platform_device *pdev)
 {
 	struct crystalcove_gpio *cg = platform_get_drvdata(pdev);
-	int irq = platform_get_irq(pdev, 0);
-	int err;
-
-	err = gpiochip_remove(&cg->chip);
+	platform_get_irq(pdev, 0);
 
-	if (irq >= 0)
-		free_irq(irq, cg);
+	gpiochip_remove(&cg->chip);
 
-	return err;
+	return 0;
 }
 
 static struct platform_driver crystalcove_gpio_driver = {
diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 1749321..5cd3367 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -1143,7 +1143,7 @@ static int omap_gpio_chip_init(struct gpio_bank *bank)
 
 	if (ret) {
 		dev_err(bank->dev, "Couldn't add irqchip to gpiochip %d\n", ret);
-		ret = gpiochip_remove(&bank->chip);
+		gpiochip_remove(&bank->chip);
 		return -ENODEV;
 	}
 
diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index 31ad5df..13c677a 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -648,8 +648,7 @@ static int zynq_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 err_rm_gpiochip:
-	if (gpiochip_remove(chip))
-		dev_err(&pdev->dev, "Failed to remove gpio chip\n");
+	gpiochip_remove(chip);
 err_disable_clk:
 	clk_disable_unprepare(gpio->clk);
 
@@ -664,16 +663,11 @@ err_disable_clk:
  */
 static int zynq_gpio_remove(struct platform_device *pdev)
 {
-	int ret;
 	struct zynq_gpio *gpio = platform_get_drvdata(pdev);
 
 	pm_runtime_get_sync(&pdev->dev);
 
-	ret = gpiochip_remove(&gpio->chip);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to remove gpio chip\n");
-		return ret;
-	}
+	gpiochip_remove(&gpio->chip);
 	clk_disable_unprepare(gpio->clk);
 	device_set_wakeup_capable(&pdev->dev, 0);
 	return 0;
-- 
1.7.9.5

