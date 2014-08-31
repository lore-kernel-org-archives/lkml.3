Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaHaLXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:23:05 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:49778 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbaHaLWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:22:48 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] pinctrl: at91: Fix failure path in at91_gpio_probe path
Date: Sun, 31 Aug 2014 16:51:53 +0530
Message-Id: <1409484115-1974-3-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the whole error handling in probe function by capturing and
returning error values on kernel function like clk_prepare,
clk_enable, gpiochip_add etc.

CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-at91.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 480460d..7abe683 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1578,16 +1578,19 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	at91_chip->clock = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(at91_chip->clock)) {
 		dev_err(&pdev->dev, "failed to get clock, ignoring.\n");
+		ret = IS_ERR(at91_chip->clock);
 		goto err;
 	}
 
-	if (clk_prepare(at91_chip->clock))
-		goto err;
+	ret = clk_prepare(at91_chip->clock);
+	if (ret)
+		goto clk_prepare_err;
 
 	/* enable PIO controller's clock */
-	if (clk_enable(at91_chip->clock)) {
+	ret = clk_enable(at91_chip->clock);
+	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock, ignoring.\n");
-		goto clk_err;
+		goto clk_enable_err;
 	}
 
 	at91_chip->chip = at91_gpio_template;
@@ -1612,7 +1615,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
 	if (!names) {
 		ret = -ENOMEM;
-		goto clk_err;
+		goto clk_enable_err;
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
@@ -1630,7 +1633,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
 	ret = gpiochip_add(chip);
 	if (ret)
-		goto clk_err;
+		goto gpiochip_add_err;
 
 	gpio_chips[alias_idx] = at91_chip;
 	gpio_banks = max(gpio_banks, alias_idx + 1);
@@ -1643,8 +1646,11 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
 	return 0;
 
-clk_err:
+gpiochip_add_err:
+	clk_disable(at91_chip->clock);
+clk_enable_err:
 	clk_unprepare(at91_chip->clock);
+clk_prepare_err:
 err:
 	dev_err(&pdev->dev, "Failure %i for GPIO %i\n", ret, alias_idx);
 
-- 
1.7.0.4

