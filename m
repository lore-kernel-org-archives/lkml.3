Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaH2R7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:59:12 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51222 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaH2R7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:59:08 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Ezra Savard <ezras@xilinx.com>, Ezra Savard <ezra.savard@xilinx.com>
Subject: [PATCH 2/3] gpio: zynq: Fixed broken wakeup implementation
Date: Fri, 29 Aug 2014 10:58:46 -0700
Message-Id: <1409335127-26712-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.1.0.1.g27b9230
In-Reply-To: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1409335127-26712-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezra Savard <ezra.savard@xilinx.com>

Use of unmask/mask in set_wake was an incorrect implementation. The new
implementation correctly sets wakeup for the gpio chip's IRQ so the gpio chip
will not sleep while wakeup-enabled gpio are in use.

Signed-off-by: Ezra Savard <ezra.savard@xilinx.com>
Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/gpio/gpio-zynq.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-zynq.c b/drivers/gpio/gpio-zynq.c
index d80d722529ad..1e6f19a07454 100644
--- a/drivers/gpio/gpio-zynq.c
+++ b/drivers/gpio/gpio-zynq.c
@@ -88,16 +88,17 @@
  * @chip:	instance of the gpio_chip
  * @base_addr:	base address of the GPIO device
  * @clk:	clock resource for this controller
+ * @irq:	interrupt for the GPIO device
  */
 struct zynq_gpio {
 	struct gpio_chip chip;
 	void __iomem *base_addr;
 	struct clk *clk;
+	int irq;
 };
 
 static struct irq_chip zynq_gpio_level_irqchip;
 static struct irq_chip zynq_gpio_edge_irqchip;
-
 /**
  * zynq_gpio_get_bank_pin - Get the bank number and pin number within that bank
  * for a given pin in the GPIO device
@@ -434,10 +435,9 @@ static int zynq_gpio_set_irq_type(struct irq_data *irq_data, unsigned int type)
 
 static int zynq_gpio_set_wake(struct irq_data *data, unsigned int on)
 {
-	if (on)
-		zynq_gpio_irq_unmask(data);
-	else
-		zynq_gpio_irq_mask(data);
+	struct zynq_gpio *gpio = irq_data_get_irq_chip_data(data);
+
+	irq_set_irq_wake(gpio->irq, on);
 
 	return 0;
 }
@@ -518,7 +518,11 @@ static void zynq_gpio_irqhandler(unsigned int irq, struct irq_desc *desc)
 
 static int __maybe_unused zynq_gpio_suspend(struct device *dev)
 {
-	if (!device_may_wakeup(dev))
+	struct platform_device *pdev = to_platform_device(dev);
+	int irq = platform_get_irq(pdev, 0);
+	struct irq_data *data = irq_get_irq_data(irq);
+
+	if (!irqd_is_wakeup_set(data))
 		return pm_runtime_force_suspend(dev);
 
 	return 0;
@@ -526,7 +530,11 @@ static int __maybe_unused zynq_gpio_suspend(struct device *dev)
 
 static int __maybe_unused zynq_gpio_resume(struct device *dev)
 {
-	if (!device_may_wakeup(dev))
+	struct platform_device *pdev = to_platform_device(dev);
+	int irq = platform_get_irq(pdev, 0);
+	struct irq_data *data = irq_get_irq_data(irq);
+
+	if (!irqd_is_wakeup_set(data))
 		return pm_runtime_force_resume(dev);
 
 	return 0;
@@ -587,7 +595,7 @@ static const struct dev_pm_ops zynq_gpio_dev_pm_ops = {
  */
 static int zynq_gpio_probe(struct platform_device *pdev)
 {
-	int ret, bank_num, irq;
+	int ret, bank_num;
 	struct zynq_gpio *gpio;
 	struct gpio_chip *chip;
 	struct resource *res;
@@ -603,10 +611,10 @@ static int zynq_gpio_probe(struct platform_device *pdev)
 	if (IS_ERR(gpio->base_addr))
 		return PTR_ERR(gpio->base_addr);
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
+	gpio->irq = platform_get_irq(pdev, 0);
+	if (gpio->irq < 0) {
 		dev_err(&pdev->dev, "invalid IRQ\n");
-		return irq;
+		return gpio->irq;
 	}
 
 	/* configure the gpio chip */
@@ -654,14 +662,12 @@ static int zynq_gpio_probe(struct platform_device *pdev)
 		goto err_rm_gpiochip;
 	}
 
-	gpiochip_set_chained_irqchip(chip, &zynq_gpio_edge_irqchip, irq,
+	gpiochip_set_chained_irqchip(chip, &zynq_gpio_edge_irqchip, gpio->irq,
 				     zynq_gpio_irqhandler);
 
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	device_set_wakeup_capable(&pdev->dev, 1);
-
 	return 0;
 
 err_rm_gpiochip:
-- 
2.1.0.1.g27b9230

