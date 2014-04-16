Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161700AbaDPOpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:45:14 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51821 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161676AbaDPOpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:45:01 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Silvio F <silvio.fricke@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/6] gpio: stmpe: switch to use gpiolib irqchip helpers
Date: Wed, 16 Apr 2014 16:44:15 +0200
Message-Id: <1397659455-13638-7-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the STMPE driver to use the gpiolib irqchip
helpers.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/Kconfig      |   1 +
 drivers/gpio/gpio-stmpe.c | 111 +++++++++++-----------------------------------
 2 files changed, 28 insertions(+), 84 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index a86c49a605c6..cb91e2d9651f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -562,6 +562,7 @@ config GPIO_SX150X
 config GPIO_STMPE
 	bool "STMPE GPIOs"
 	depends on MFD_STMPE
+	select GPIOLIB_IRQCHIP
 	help
 	  This enables support for the GPIOs found on the STMPE I/O
 	  Expanders.
diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 628b58494294..ed90adbdb128 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -10,8 +10,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/gpio.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
 #include <linux/mfd/stmpe.h>
@@ -31,9 +29,7 @@ struct stmpe_gpio {
 	struct stmpe *stmpe;
 	struct device *dev;
 	struct mutex irq_lock;
-	struct irq_domain *domain;
 	unsigned norequest_mask;
-
 	/* Caches of interrupt control registers for bus_lock */
 	u8 regs[CACHE_NR_REGS][CACHE_NR_BANKS];
 	u8 oldregs[CACHE_NR_REGS][CACHE_NR_BANKS];
@@ -101,13 +97,6 @@ static int stmpe_gpio_direction_input(struct gpio_chip *chip,
 	return stmpe_set_bits(stmpe, reg, mask, 0);
 }
 
-static int stmpe_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
-
-	return irq_create_mapping(stmpe_gpio->domain, offset);
-}
-
 static int stmpe_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(chip);
@@ -126,14 +115,14 @@ static struct gpio_chip template_chip = {
 	.get			= stmpe_gpio_get,
 	.direction_output	= stmpe_gpio_direction_output,
 	.set			= stmpe_gpio_set,
-	.to_irq			= stmpe_gpio_to_irq,
 	.request		= stmpe_gpio_request,
 	.can_sleep		= true,
 };
 
 static int stmpe_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(gc);
 	int offset = d->hwirq;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
@@ -160,14 +149,16 @@ static int stmpe_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 
 static void stmpe_gpio_irq_lock(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(gc);
 
 	mutex_lock(&stmpe_gpio->irq_lock);
 }
 
 static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(gc);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
 	int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
 	static const u8 regmap[] = {
@@ -200,7 +191,8 @@ static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 
 static void stmpe_gpio_irq_mask(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(gc);
 	int offset = d->hwirq;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
@@ -210,7 +202,8 @@ static void stmpe_gpio_irq_mask(struct irq_data *d)
 
 static void stmpe_gpio_irq_unmask(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct stmpe_gpio *stmpe_gpio = to_stmpe_gpio(gc);
 	int offset = d->hwirq;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
@@ -253,7 +246,7 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 		while (stat) {
 			int bit = __ffs(stat);
 			int line = bank * 8 + bit;
-			int child_irq = irq_find_mapping(stmpe_gpio->domain,
+			int child_irq = irq_find_mapping(stmpe_gpio->chip.irqdomain,
 							 line);
 
 			handle_nested_irq(child_irq);
@@ -271,56 +264,6 @@ static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int stmpe_gpio_irq_map(struct irq_domain *d, unsigned int irq,
-			      irq_hw_number_t hwirq)
-{
-	struct stmpe_gpio *stmpe_gpio = d->host_data;
-
-	if (!stmpe_gpio)
-		return -EINVAL;
-
-	irq_set_chip_data(irq, stmpe_gpio);
-	irq_set_chip_and_handler(irq, &stmpe_gpio_irq_chip,
-				 handle_simple_irq);
-	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
-	irq_set_noprobe(irq);
-#endif
-
-	return 0;
-}
-
-static void stmpe_gpio_irq_unmap(struct irq_domain *d, unsigned int irq)
-{
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, 0);
-#endif
-	irq_set_chip_and_handler(irq, NULL, NULL);
-	irq_set_chip_data(irq, NULL);
-}
-
-static const struct irq_domain_ops stmpe_gpio_irq_simple_ops = {
-	.unmap = stmpe_gpio_irq_unmap,
-	.map = stmpe_gpio_irq_map,
-	.xlate = irq_domain_xlate_twocell,
-};
-
-static int stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio,
-		struct device_node *np)
-{
-	stmpe_gpio->domain = irq_domain_add_simple(np,
-				stmpe_gpio->chip.ngpio, 0,
-				&stmpe_gpio_irq_simple_ops, stmpe_gpio);
-	if (!stmpe_gpio->domain) {
-		dev_err(stmpe_gpio->dev, "failed to create irqdomain\n");
-		return -ENOSYS;
-	}
-
-	return 0;
-}
-
 static int stmpe_gpio_probe(struct platform_device *pdev)
 {
 	struct stmpe *stmpe = dev_get_drvdata(pdev->dev.parent);
@@ -358,30 +301,37 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
 
 	if (irq < 0)
 		dev_info(&pdev->dev,
-			"device configured in no-irq mode; "
+			"device configured in no-irq mode: "
 			"irqs are not available\n");
 
 	ret = stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
 	if (ret)
 		goto out_free;
 
-	if (irq >= 0) {
-		ret = stmpe_gpio_irq_init(stmpe_gpio, np);
-		if (ret)
-			goto out_disable;
-
-		ret = request_threaded_irq(irq, NULL, stmpe_gpio_irq,
-				IRQF_ONESHOT, "stmpe-gpio", stmpe_gpio);
+	if (irq > 0) {
+		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+				stmpe_gpio_irq, IRQF_ONESHOT,
+				"stmpe-gpio", stmpe_gpio);
 		if (ret) {
 			dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
 			goto out_disable;
 		}
+		ret =  gpiochip_irqchip_add(&stmpe_gpio->chip,
+					    &stmpe_gpio_irq_chip,
+					    0,
+					    handle_simple_irq,
+					    IRQ_TYPE_NONE);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"could not connect irqchip to gpiochip\n");
+			return ret;
+		}
 	}
 
 	ret = gpiochip_add(&stmpe_gpio->chip);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
-		goto out_freeirq;
+		goto out_disable;
 	}
 
 	if (pdata && pdata->setup)
@@ -391,9 +341,6 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
 
 	return 0;
 
-out_freeirq:
-	if (irq >= 0)
-		free_irq(irq, stmpe_gpio);
 out_disable:
 	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
 out_free:
@@ -406,7 +353,6 @@ static int stmpe_gpio_remove(struct platform_device *pdev)
 	struct stmpe_gpio *stmpe_gpio = platform_get_drvdata(pdev);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
 	struct stmpe_gpio_platform_data *pdata = stmpe->pdata->gpio;
-	int irq = platform_get_irq(pdev, 0);
 	int ret;
 
 	if (pdata && pdata->remove)
@@ -421,9 +367,6 @@ static int stmpe_gpio_remove(struct platform_device *pdev)
 
 	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
 
-	if (irq >= 0)
-		free_irq(irq, stmpe_gpio);
-
 	kfree(stmpe_gpio);
 
 	return 0;
-- 
1.9.0

