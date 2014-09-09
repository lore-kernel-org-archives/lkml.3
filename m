Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbaIIKRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:17:07 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:46711 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756289AbaIIKRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:17:03 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 1/2] pinctrl: at91: Fix failure path in at91_gpio_probe path
Date: Tue,  9 Sep 2014 15:50:36 +0530
Message-Id: <1410258037-32024-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
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

Changes since v1:
  Used PTR_ERR instead of IS_ERR as per Linus's review.

 drivers/pinctrl/pinctrl-at91.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index a3d8902..4d4bea4 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1738,16 +1738,19 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	at91_chip->clock = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(at91_chip->clock)) {
 		dev_err(&pdev->dev, "failed to get clock, ignoring.\n");
+		ret = PTR_ERR(at91_chip->clock);
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
@@ -1772,7 +1775,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
 	if (!names) {
 		ret = -ENOMEM;
-		goto clk_err;
+		goto clk_enable_err;
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
@@ -1790,7 +1793,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
 	ret = gpiochip_add(chip);
 	if (ret)
-		goto clk_err;
+		goto gpiochip_add_err;
 
 	gpio_chips[alias_idx] = at91_chip;
 	gpio_banks = max(gpio_banks, alias_idx + 1);
@@ -1803,8 +1806,11 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
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
1.7.9.5

