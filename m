Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab3KZTqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:46:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54656 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744Ab3KZToL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:44:11 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-gpio@vger.kernel.org>, <nsekhar@ti.com>
CC: <prabhakar.csengg@gmail.com>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC v1 5/9] gpio: davinci: reuse for Keystone SoC
Date: Tue, 26 Nov 2013 21:40:11 +0200
Message-ID: <1385494815-15740-6-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The similar GPIO HW block is used by keystone SoCs as
in Davinci SoCs.
Hence, reuse Davinci GPIO driver for Keystone.

Documentation:
 http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 .../devicetree/bindings/gpio/gpio-davinci.txt      |    4 +-
 drivers/gpio/gpio-davinci.c                        |   55 ++++++++++++++++++++
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
index a2e839d..4ce9862 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
@@ -1,7 +1,7 @@
-Davinci GPIO controller bindings
+Davinci/Keystone GPIO controller bindings
 
 Required Properties:
-- compatible: should be "ti,dm6441-gpio"
+- compatible: should be "ti,dm6441-gpio", "ti,keystone-gpio"
 
 - reg: Physical base address of the controller and the size of memory mapped
        registers.
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 6a48bf8..545f25c 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -542,11 +542,65 @@ static int davinci_gpio_banked_irq_init(struct platform_device *pdev)
 	return 0;
 }
 
+static int keystone_gpio_unbanked_irq_init(struct platform_device *pdev)
+{
+	int base_irq, irq;
+	unsigned gpio, ngpio;
+	struct davinci_gpio_regs __iomem *g;
+	struct device *dev = &pdev->dev;
+	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
+	struct davinci_gpio_platform_data *pdata = dev->platform_data;
+
+	static struct irq_chip gpio_unbanked;
+
+	if (pdata->gpio_unbanked > chips[0].chip.ngpio) {
+		dev_err(dev, "Invalid IRQ configuration\n");
+		return -EINVAL;
+	}
+
+	ngpio = pdata->ngpio;
+
+	base_irq = platform_get_irq(pdev, 0);
+	if (base_irq <= 0) {
+		dev_err(dev, "Invalid first banked IRQ number %d\n", base_irq);
+		return base_irq < 0 ? base_irq : -EINVAL;
+	}
+
+	/* pass "bank 0" GPIO IRQs to GIC */
+	chips[0].chip.to_irq = gpio_to_irq_unbanked;
+	chips[0].gpio_irq = base_irq;
+	chips[0].gpio_unbanked = pdata->gpio_unbanked;
+
+	/* GIC handles mask/unmask; GPIO handles triggering */
+	gpio_unbanked = *irq_get_chip(base_irq);
+	gpio_unbanked.name = "GPIO-GIC";
+	gpio_unbanked.irq_set_type = gpio_irq_type_unbanked;
+
+	/* default trigger: both edges */
+	g = gpio2regs(0);
+	writel(~0, &g->set_falling);
+	writel(~0, &g->set_rising);
+
+	irq = base_irq;
+	/* set the direct IRQs up to use that irqchip */
+	for (gpio = 0; gpio < pdata->gpio_unbanked; gpio++, irq++) {
+		irq_set_chip(irq, &gpio_unbanked);
+		irq_set_handler_data(irq, &chips[gpio / 32]);
+		irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
+	}
+
+	return 0;
+};
+
 static const struct davinci_gpio_init_data davinci_gpio_pdata = {
 	.unbanked_irq_init = davinci_gpio_unbanked_irq_init,
 	.banked_irq_init = davinci_gpio_banked_irq_init,
 };
 
+static const struct davinci_gpio_init_data keystone_gpio_pdata = {
+	.unbanked_irq_init = keystone_gpio_unbanked_irq_init,
+};
+
 /*
  * NOTE:  for suspend/resume, probably best to make a platform_device with
  * suspend_late/resume_resume calls hooking into results of the set_wake()
@@ -622,6 +676,7 @@ done:
 #if IS_ENABLED(CONFIG_OF)
 static const struct of_device_id davinci_gpio_ids[] = {
 	{ .compatible = "ti,dm6441-gpio", &davinci_gpio_pdata},
+	{ .compatible = "ti,keystone-gpio", &keystone_gpio_pdata},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, davinci_gpio_ids);
-- 
1.7.9.5

