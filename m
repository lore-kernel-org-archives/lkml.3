Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaIIKRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:17:20 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:43851 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320AbaIIKRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:17:06 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2 2/2] pinctrl: at91: Fix error handling while doing gpiochio_irqchip_add
Date: Tue,  9 Sep 2014 15:50:37 +0530
Message-Id: <1410258037-32024-2-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410258037-32024-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1410258037-32024-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a call to panic function when gpiochio_irqchip_add
fails and just returns the error to the calling function.
Same return value is used to handle the error case and adds a lable
to release resources on error.
The error message has been improved to indicate failure to add irqchip
to gpiochip.

This also changes first argument to function at91_gpio_of_irq_setup from
struct device_node to struct platform_device. Because The device_node
argument was anyway not being used. Passed pdev so that on failure dev_err
can use &pdev->dev and log can be associated with proper device.

CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---

Changes since v1:
 FIxed the error massage on gpiochio_irqchip_add failure to indicate 
 failure to add irqchip to gpiochip.

 drivers/pinctrl/pinctrl-at91.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 4d4bea4..4fdd851 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1605,7 +1605,7 @@ static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 	/* now it may re-trigger */
 }
 
-static int at91_gpio_of_irq_setup(struct device_node *node,
+static int at91_gpio_of_irq_setup(struct platform_device *pdev,
 				  struct at91_gpio_chip *at91_gpio)
 {
 	struct at91_gpio_chip   *prev = NULL;
@@ -1630,9 +1630,11 @@ static int at91_gpio_of_irq_setup(struct device_node *node,
 				   0,
 				   handle_edge_irq,
 				   IRQ_TYPE_EDGE_BOTH);
-	if (ret)
-		panic("at91_gpio.%d: couldn't allocate irq domain (DT).\n",
+	if (ret) {
+		dev_err(&pdev->dev, "at91_gpio.%d: Couldn't add irqchip to gpiochip.\n",
 			at91_gpio->pioc_idx);
+		return ret;
+	}
 
 	/* Setup chained handler */
 	if (at91_gpio->pioc_idx)
@@ -1800,12 +1802,16 @@ static int at91_gpio_probe(struct platform_device *pdev)
 
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
1.7.9.5

