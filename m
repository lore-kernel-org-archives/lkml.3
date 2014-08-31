Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaHaLXD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:23:03 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:36574 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751046AbaHaLW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:22:58 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] pinctrl: at91: Fix error handling while doing gpiochio_irqchip_add
Date: Sun, 31 Aug 2014 16:51:54 +0530
Message-Id: <1409484115-1974-4-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409484115-1974-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a call to panic function when gpiochio_irqchip_add
fails and just returns the error to the calling function.
Same return value is used to handle the error case and adds to lable
to release resources on error.

This also changes first argument to function at91_gpio_of_irq_setup from
struct device_node to struct platform_device. Because The device_node
argument was anyway not being used. Passed pdev so that on failure dev_err
can use &pdev->dev and log can be associated with proper device.

CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/pinctrl-at91.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 7abe683..8b8772c 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1445,7 +1445,7 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 	/* now it may re-trigger */
 }
 
-static int at91_gpio_of_irq_setup(struct device_node *node,
+static int at91_gpio_of_irq_setup(struct platform_device *pdev,
 				  struct at91_gpio_chip *at91_gpio)
 {
 	struct at91_gpio_chip   *prev = NULL;
@@ -1470,9 +1470,11 @@ static int at91_gpio_of_irq_setup(struct device_node *node,
 				   0,
 				   handle_edge_irq,
 				   IRQ_TYPE_EDGE_BOTH);
-	if (ret)
-		panic("at91_gpio.%d: couldn't allocate irq domain (DT).\n",
+	if (ret) {
+		dev_err(&pdev->dev, "at91_gpio.%d: couldn't allocate irq domain (DT).\n",
 			at91_gpio->pioc_idx);
+		return ret;
+	}
 
 	/* Setup chained handler */
 	if (at91_gpio->pioc_idx)
@@ -1640,12 +1642,16 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
 	at91_gpio_probe_fixup();
 
-	at91_gpio_of_irq_setup(np, at91_chip);
+	ret = at91_gpio_of_irq_setup(pdev, at91_chip);
+	if (ret)
+		goto irq_setup_err;
 
 	dev_info(&pdev->dev, "at address %p\n", at91_chip->regbase);
 
 	return 0;
 
+irq_setup_err:
+	gpiochip_remove(chip);
 gpiochip_add_err:
 	clk_disable(at91_chip->clock);
 clk_enable_err:
-- 
1.7.0.4

