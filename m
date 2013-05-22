Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3EVHKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:10:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45493 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab3EVHKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:10:32 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, KV Sujith <sujithkv@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 03/11] gpio: davinci: Modify to platform driver
Date: Wed, 22 May 2013 12:40:26 +0530
Message-ID: <1369206634-6778-4-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

Modify GPIO Davinci driver to be compliant to standard platform drivers.
The driver did not have platform driver structure or a probe. Instead,
had a davinci_gpio_setup() function which is called in the pure_init
sequence. The function also had dependency on davinci_soc_info structure
of the corresponding platform. For Device Tree(DT) implementation, we
need to get rid of the dependency on the davinci_soc_info structure.
Hence as a first stage of DT conversion, we implement a probe. Future
commits shall modify the probe to read platform related data from DT.

- Add platform_driver structure and driver register function for davinci
  GPIO driver. The driver registration is made to happen in
  postcore_initcall. This is required since machine init functions like
  da850_lcd_hw_init() make use of GPIO.
- Convert the davinci_gpio_setup() to davinci_gpio_probe().
- Remove access of members in soc_info structure. Instead, relevant data
  are taken from davinci_gpio_platform_data structure pointed by
  pdev->dev.platform_data.
- Change clk_get() to devm_clk_get() as devm_clk_get() is a device
  managed function and makes error handling simpler.
- Change pr_err to dev_err for ngpio error reporting.
- Arrange include files and variables in alphabetical order

Signed-off-by: KV Sujith <sujithkv@ti.com>
[avinashphilip@ti.com: Move global definition for "struct
davinci_gpio_controller" variable to local in probe and set it as driver
data.]
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |    2 +
 drivers/gpio/gpio-davinci.c                       |  121 +++++++++++++++------
 2 files changed, 87 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/gpio-davinci.h b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
index 1fdd1fd..b325a1d 100644
--- a/arch/arm/mach-davinci/include/mach/gpio-davinci.h
+++ b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
@@ -60,6 +60,8 @@ struct davinci_gpio_controller {
 	void __iomem		*set_data;
 	void __iomem		*clr_data;
 	void __iomem		*in_data;
+	int			gpio_unbanked;
+	unsigned		gpio_irq;
 };
 
 /* The __gpio_to_controller() and __gpio_mask() functions inline to constants
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index d308955..08830aa 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -11,10 +11,17 @@
  */
 
 #include <linux/clk.h>
+#include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <mach/gpio-davinci.h>
 
 #include <asm/mach/irq.h>
 
@@ -35,10 +42,9 @@ struct davinci_gpio_regs {
 #define chip2controller(chip)	\
 	container_of(chip, struct davinci_gpio_controller, chip)
 
-static struct davinci_gpio_controller ctlrs[DIV_ROUND_UP(DAVINCI_N_GPIO, 32)];
 static void __iomem *gpio_base;
 
-static struct davinci_gpio_regs __iomem __init *gpio2regs(unsigned gpio)
+static struct davinci_gpio_regs __iomem *gpio2regs(unsigned gpio)
 {
 	void __iomem *ptr;
 
@@ -64,7 +70,7 @@ static inline struct davinci_gpio_regs __iomem *irq2regs(int irq)
 		irq_get_chip_data(irq);
 }
 
-static int __init davinci_gpio_irq_setup(void);
+static int davinci_gpio_irq_setup(struct platform_device *pdev);
 
 static inline int __davinci_direction(struct gpio_chip *chip,
 			unsigned offset, bool out, int value)
@@ -127,33 +133,52 @@ static void davinci_gpio_set(struct gpio_chip *chip, unsigned offset,
 	__raw_writel((1 << offset), value ? &regs->set_data : &regs->clr_data);
 }
 
-static int __init davinci_gpio_setup(void)
+static int davinci_gpio_probe(struct platform_device *pdev)
 {
 	int i, base;
 	unsigned ngpio;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
+	struct davinci_gpio_controller *ctlrs;
+	struct davinci_gpio_platform_data *pdata;
 	struct davinci_gpio_regs *regs;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
 
-	if (soc_info->gpio_type != GPIO_TYPE_DAVINCI)
-		return 0;
+	pdata = dev->platform_data;
+	if (!pdata) {
+		dev_err(dev, "GPIO: No Platform Data Supplied\n");
+		return -EINVAL;
+	}
 
 	/*
 	 * The gpio banks conceptually expose a segmented bitmap,
 	 * and "ngpio" is one more than the largest zero-based
 	 * bit index that's valid.
 	 */
-	ngpio = soc_info->gpio_num;
+	ngpio = pdata->ngpio;
 	if (ngpio == 0) {
-		pr_err("GPIO setup:  how many GPIOs?\n");
+		dev_err(dev, "GPIO Probe: how many GPIOs?\n");
 		return -EINVAL;
 	}
 
 	if (WARN_ON(DAVINCI_N_GPIO < ngpio))
 		ngpio = DAVINCI_N_GPIO;
 
-	gpio_base = ioremap(soc_info->gpio_base, SZ_4K);
-	if (WARN_ON(!gpio_base))
+	ctlrs = devm_kzalloc(dev,
+		ngpio * sizeof(struct davinci_gpio_controller), GFP_KERNEL);
+	if (!ctlrs) {
+		dev_err(dev, "Memory alloc failed\n");
 		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (unlikely(!res)) {
+		dev_err(dev, "Invalid mem resource\n");
+		return -ENODEV;
+	}
+
+	gpio_base = devm_ioremap_resource(dev, res);
+	if (!gpio_base)
+		return -EADDRNOTAVAIL;
 
 	for (i = 0, base = 0; base < ngpio; i++, base += 32) {
 		ctlrs[i].chip.label = "DaVinci";
@@ -179,13 +204,10 @@ static int __init davinci_gpio_setup(void)
 		gpiochip_add(&ctlrs[i].chip);
 	}
 
-	soc_info->gpio_ctlrs = ctlrs;
-	soc_info->gpio_ctlrs_num = DIV_ROUND_UP(ngpio, 32);
-
-	davinci_gpio_irq_setup();
+	platform_set_drvdata(pdev, ctlrs);
+	davinci_gpio_irq_setup(pdev);
 	return 0;
 }
-pure_initcall(davinci_gpio_setup);
 
 /*
  * We expect irqs will normally be set up as input pins, but they can also be
@@ -297,14 +319,14 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
 
 static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
 {
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
+	struct davinci_gpio_controller *ctlr = chip2controller(chip);
 
 	/*
 	 * NOTE:  we assume for now that only irqs in the first gpio_chip
 	 * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
 	 */
-	if (offset < soc_info->gpio_unbanked)
-		return soc_info->gpio_irq + offset;
+	if (offset < ctlr->irq_base)
+		return ctlr->gpio_irq + offset;
 	else
 		return -ENODEV;
 }
@@ -313,12 +335,11 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
 {
 	struct davinci_gpio_controller *ctlr;
 	struct davinci_gpio_regs __iomem *regs;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
 	u32 mask;
 
 	ctlr = (struct davinci_gpio_controller *)data->handler_data;
 	regs = (struct davinci_gpio_regs __iomem *)ctlr->regs;
-	mask = __gpio_mask(data->irq - soc_info->gpio_irq);
+	mask = __gpio_mask(data->irq - ctlr->gpio_irq);
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
@@ -339,23 +360,33 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
  * (dm6446) can be set appropriately for GPIOV33 pins.
  */
 
-static int __init davinci_gpio_irq_setup(void)
+static int davinci_gpio_irq_setup(struct platform_device *pdev)
 {
-	u32		binten = 0;
-	unsigned	gpio, irq, bank, ngpio, bank_irq;
-	struct clk	*clk;
+	u32 binten = 0;
+	unsigned gpio, irq, bank, ngpio, bank_irq;
+	struct clk *clk;
+	struct davinci_gpio_controller *ctlrs = platform_get_drvdata(pdev);
+	struct davinci_gpio_platform_data *pdata;
 	struct davinci_gpio_regs __iomem *regs;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+
+	pdata = dev->platform_data;
+	ngpio = pdata->ngpio;
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (unlikely(!res)) {
+		dev_err(dev, "Invalid IRQ resource\n");
+		return -ENODEV;
+	}
 
-	ngpio = soc_info->gpio_num;
+	bank_irq = res->start;
 
-	bank_irq = soc_info->gpio_irq;
-	if (bank_irq == 0) {
-		printk(KERN_ERR "Don't know first GPIO bank IRQ.\n");
-		return -EINVAL;
+	if (unlikely(!bank_irq)) {
+		dev_err(dev, "Invalid IRQ resource\n");
+		return -ENODEV;
 	}
 
-	clk = clk_get(NULL, "gpio");
+	clk = devm_clk_get(dev, "gpio");
 	if (IS_ERR(clk)) {
 		printk(KERN_ERR "Error %ld getting gpio clock?\n",
 		       PTR_ERR(clk));
@@ -371,8 +402,8 @@ static int __init davinci_gpio_irq_setup(void)
 	 */
 	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
 		ctlrs[bank].chip.to_irq = gpio_to_irq_banked;
-		ctlrs[bank].irq_base = soc_info->gpio_unbanked ?
-			-EINVAL : (soc_info->intc_irq_num + gpio);
+		ctlrs[bank].irq_base = pdata->gpio_unbanked ?
+			-EINVAL : (pdata->intc_irq_num + gpio);
 	}
 
 	/*
@@ -380,7 +411,7 @@ static int __init davinci_gpio_irq_setup(void)
 	 * controller only handling trigger modes.  We currently assume no
 	 * IRQ mux conflicts; gpio_irq_type_unbanked() is only for GPIOs.
 	 */
-	if (soc_info->gpio_unbanked) {
+	if (pdata->gpio_unbanked) {
 		static struct irq_chip_type gpio_unbanked;
 
 		/* pass "bank 0" GPIO IRQs to AINTC */
@@ -400,7 +431,7 @@ static int __init davinci_gpio_irq_setup(void)
 		__raw_writel(~0, &regs->set_rising);
 
 		/* set the direct IRQs up to use that irqchip */
-		for (gpio = 0; gpio < soc_info->gpio_unbanked; gpio++, irq++) {
+		for (gpio = 0; gpio < pdata->gpio_unbanked; gpio++, irq++) {
 			irq_set_chip(irq, &gpio_unbanked.chip);
 			irq_set_handler_data(irq, &ctlrs[gpio / 32]);
 			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
@@ -455,3 +486,21 @@ done:
 
 	return 0;
 }
+
+static struct platform_driver davinci_gpio_driver = {
+	.probe		= davinci_gpio_probe,
+	.driver		= {
+		.name	= "davinci_gpio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+/**
+ * gpio driver register needs to be done before machine_init functions
+ * access gpio APIs. Hence davinci_gpio_drv_reg() is a postcore_initcall.
+ */
+static int __init davinci_gpio_drv_reg(void)
+{
+	return platform_driver_register(&davinci_gpio_driver);
+}
+postcore_initcall(davinci_gpio_drv_reg);
-- 
1.7.9.5

