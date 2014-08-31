Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaHaLWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:22:51 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:56603 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaHaLWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:22:39 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] pinctrl: at91: Switch to using managed clk_get
Date: Sun, 31 Aug 2014 16:51:52 +0530
Message-Id: <1409484115-1974-2-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch switches to using managed version of clk_get and hence
removes clk_put from failure path.

CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-at91.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index af1ba4f..480460d 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1575,14 +1575,14 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	at91_chip->pioc_virq = irq;
 	at91_chip->pioc_idx = alias_idx;
 
-	at91_chip->clock = clk_get(&pdev->dev, NULL);
+	at91_chip->clock = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(at91_chip->clock)) {
 		dev_err(&pdev->dev, "failed to get clock, ignoring.\n");
 		goto err;
 	}
 
 	if (clk_prepare(at91_chip->clock))
-		goto clk_prep_err;
+		goto err;
 
 	/* enable PIO controller's clock */
 	if (clk_enable(at91_chip->clock)) {
@@ -1645,8 +1645,6 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
 clk_err:
 	clk_unprepare(at91_chip->clock);
-clk_prep_err:
-	clk_put(at91_chip->clock);
 err:
 	dev_err(&pdev->dev, "Failure %i for GPIO %i\n", ret, alias_idx);
 
-- 
1.7.0.4

