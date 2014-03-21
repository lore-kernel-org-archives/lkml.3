Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbaCUJmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:42:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52831 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760576AbaCUJm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:42:28 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] pinctrl: nomadik: rename secondary to latent
Date: Fri, 21 Mar 2014 10:42:17 +0100
Message-Id: <1395394937-31503-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "secondary irq" in the nomadik pin control driver is actually
not secondary (as in: can occur any time alongside the ordinary
irq), it is a latent IRQ. It is an IRQ that has occurred when
the system was in sleep state and has been cached in a special
register flagged from the low power management unit (PRCM).

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index cec7762cf335..ee6a8ca264fc 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -254,7 +254,7 @@ struct nmk_gpio_platform_data {
 	int first_gpio;
 	int first_irq;
 	int num_gpio;
-	u32 (*get_secondary_status)(unsigned int bank);
+	u32 (*get_latent_status)(unsigned int bank);
 	void (*set_ioforce)(bool enable);
 	bool supports_sleepmode;
 };
@@ -266,8 +266,8 @@ struct nmk_gpio_chip {
 	struct clk *clk;
 	unsigned int bank;
 	unsigned int parent_irq;
-	int secondary_parent_irq;
-	u32 (*get_secondary_status)(unsigned int bank);
+	int latent_parent_irq;
+	u32 (*get_latent_status)(unsigned int bank);
 	void (*set_ioforce)(bool enable);
 	spinlock_t lock;
 	bool sleepmode;
@@ -909,11 +909,11 @@ static void nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	__nmk_gpio_irq_handler(irq, desc, status);
 }
 
-static void nmk_gpio_secondary_irq_handler(unsigned int irq,
+static void nmk_gpio_latent_irq_handler(unsigned int irq,
 					   struct irq_desc *desc)
 {
 	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
-	u32 status = nmk_chip->get_secondary_status(nmk_chip->bank);
+	u32 status = nmk_chip->get_latent_status(nmk_chip->bank);
 
 	__nmk_gpio_irq_handler(irq, desc, status);
 }
@@ -923,10 +923,10 @@ static int nmk_gpio_init_irq(struct nmk_gpio_chip *nmk_chip)
 	irq_set_chained_handler(nmk_chip->parent_irq, nmk_gpio_irq_handler);
 	irq_set_handler_data(nmk_chip->parent_irq, nmk_chip);
 
-	if (nmk_chip->secondary_parent_irq >= 0) {
-		irq_set_chained_handler(nmk_chip->secondary_parent_irq,
-					nmk_gpio_secondary_irq_handler);
-		irq_set_handler_data(nmk_chip->secondary_parent_irq, nmk_chip);
+	if (nmk_chip->latent_parent_irq >= 0) {
+		irq_set_chained_handler(nmk_chip->latent_parent_irq,
+					nmk_gpio_latent_irq_handler);
+		irq_set_handler_data(nmk_chip->latent_parent_irq, nmk_chip);
 	}
 
 	return 0;
@@ -1246,7 +1246,7 @@ static int nmk_gpio_probe(struct platform_device *dev)
 	struct gpio_chip *chip;
 	struct resource *res;
 	struct clk *clk;
-	int secondary_irq;
+	int latent_irq;
 	void __iomem *base;
 	int irq;
 	int ret;
@@ -1270,8 +1270,8 @@ static int nmk_gpio_probe(struct platform_device *dev)
 	if (irq < 0)
 		return irq;
 
-	secondary_irq = platform_get_irq(dev, 1);
-	if (secondary_irq >= 0 && !pdata->get_secondary_status)
+	latent_irq = platform_get_irq(dev, 1);
+	if (latent_irq >= 0 && !pdata->get_latent_status)
 		return -EINVAL;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
@@ -1297,8 +1297,8 @@ static int nmk_gpio_probe(struct platform_device *dev)
 	nmk_chip->addr = base;
 	nmk_chip->chip = nmk_gpio_template;
 	nmk_chip->parent_irq = irq;
-	nmk_chip->secondary_parent_irq = secondary_irq;
-	nmk_chip->get_secondary_status = pdata->get_secondary_status;
+	nmk_chip->latent_parent_irq = latent_irq;
+	nmk_chip->get_latent_status = pdata->get_latent_status;
 	nmk_chip->set_ioforce = pdata->set_ioforce;
 	nmk_chip->sleepmode = pdata->supports_sleepmode;
 	spin_lock_init(&nmk_chip->lock);
-- 
1.8.5.3

