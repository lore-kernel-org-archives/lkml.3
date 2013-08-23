Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3HWSD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:03:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37870 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab3HWSDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:03:11 -0400
Message-ID: <5217A3C1.1010808@ti.com>
Date: Fri, 23 Aug 2013 23:32:41 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v3 2/7] gpio: davinci: move to platform device
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com> <1376803143-13738-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376803143-13738-3-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/2013 10:48 AM, Lad, Prabhakar wrote:
> From: KV Sujith <sujithkv@ti.com>
> 
> Modify GPIO Davinci driver to be compliant to standard platform drivers.
> The driver did not have platform driver structure or a probe. Instead,
> had a davinci_gpio_setup() function which is called in the pure_init
> sequence. The function also had dependency on davinci_soc_info structure
> of the corresponding platform. For Device Tree(DT) implementation, we
> need to get rid of the dependency on the davinci_soc_info structure.
> Hence as a first stage of DT conversion, we implement a probe. Future
> commits shall modify the probe to read platform related data from DT.
> 
> - Add platform_driver structure and driver register function for davinci
>   GPIO driver. The driver registration is made to happen in
>   postcore_initcall. This is required since machine init functions like
>   da850_lcd_hw_init() make use of GPIO.
> - Convert the davinci_gpio_setup() to davinci_gpio_probe().
> - Remove access of members in soc_info structure. Instead, relevant data
>   are taken from davinci_gpio_platform_data structure pointed by
>   pdev->dev.platform_data.
> - Change clk_get() to devm_clk_get() as devm_clk_get() is a device
>   managed function and makes error handling simpler.
> - Change pr_err to dev_err for gpio error reporting.
> - Add struct davinci_gpio_platform_data davinci for gpio module.
> 
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> [avinashphilip@ti.com: Move global definition for "struct
> davinci_gpio_controller" variable to local in probe and set it as driver
> data.]
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> [nsekhar@ti.com: dropped unused structure member, rebased on new clean-up
> patch and fixes error messages]
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Queuing this after editing the commit message for brevity and ...

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (unlikely(!res)) {

... removing such unneeded unlikely() calls. This is not performance 
critical path.

Updated patch attached for reference.

Thanks,
Sekhar

>From bb2857ab7a264463fb87c211ab6b077b40637e92 Mon Sep 17 00:00:00 2001
From: KV Sujith <sujithkv@ti.com>
Date: Sun, 18 Aug 2013 10:48:58 +0530
Subject: [PATCH 2/7] gpio: davinci: move to platform device

Modify DaVinci GPIO driver to become a platform device
driver.

The driver does not have platform driver structure or
a probe. Instead, it has pure_initcall function for
initialization. The platform specific information is
obtained using the DaVinci specific davinci_soc_info
structure. This is a problem for Device Tree (DT)
implementation.

As a first stage of DT conversion, we implement a probe.

Additional notes:

- The driver registration happens as  postcore_initcall.
  This is required since machine init functions like
  da850_lcd_hw_init() make use of GPIO.
- Start using devres APIs for simpler error handling.

Signed-off-by: KV Sujith <sujithkv@ti.com>
[avinashphilip@ti.com: Move global definition of
		       "davinci_gpio_controller" to local]
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
[nsekhar@ti.com: drop unused structure member, rebase to new
		 clean-up patch and fix error messages]
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/include/mach/gpio-davinci.h |    1 +
 drivers/gpio/gpio-davinci.c                       |  123 ++++++++++++++-------
 include/linux/platform_data/gpio-davinci.h        |   25 +++++
 3 files changed, 111 insertions(+), 38 deletions(-)
 create mode 100644 include/linux/platform_data/gpio-davinci.h

diff --git a/arch/arm/mach-davinci/include/mach/gpio-davinci.h b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
index 1fdd1fd..551ba43 100644
--- a/arch/arm/mach-davinci/include/mach/gpio-davinci.h
+++ b/arch/arm/mach-davinci/include/mach/gpio-davinci.h
@@ -60,6 +60,7 @@ struct davinci_gpio_controller {
 	void __iomem		*set_data;
 	void __iomem		*clr_data;
 	void __iomem		*in_data;
+	unsigned		gpio_irq;
 };
 
 /* The __gpio_to_controller() and __gpio_mask() functions inline to constants
diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index af7ea0b..b537e31 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -10,12 +10,17 @@
  * (at your option) any later version.
  */
 #include <linux/clk.h>
+#include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
-
-#include <asm/mach/irq.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/gpio-davinci.h>
 
 struct davinci_gpio_regs {
 	u32	dir;
@@ -35,10 +40,9 @@ struct davinci_gpio_regs {
 #define chip2controller(chip)	\
 	container_of(chip, struct davinci_gpio_controller, chip)
 
-static struct davinci_gpio_controller chips[DIV_ROUND_UP(DAVINCI_N_GPIO, 32)];
 static void __iomem *gpio_base;
 
-static struct davinci_gpio_regs __iomem __init *gpio2regs(unsigned gpio)
+static struct davinci_gpio_regs __iomem *gpio2regs(unsigned gpio)
 {
 	void __iomem *ptr;
 
@@ -66,7 +70,7 @@ static inline struct davinci_gpio_regs __iomem *irq2regs(int irq)
 	return g;
 }
 
-static int __init davinci_gpio_irq_setup(void);
+static int davinci_gpio_irq_setup(struct platform_device *pdev);
 
 /*--------------------------------------------------------------------------*/
 
@@ -132,33 +136,53 @@ davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	__raw_writel((1 << offset), value ? &g->set_data : &g->clr_data);
 }
 
-static int __init davinci_gpio_setup(void)
+static int davinci_gpio_probe(struct platform_device *pdev)
 {
 	int i, base;
 	unsigned ngpio;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	struct davinci_gpio_regs *regs;
-
-	if (soc_info->gpio_type != GPIO_TYPE_DAVINCI)
-		return 0;
+	struct davinci_gpio_controller *chips;
+	struct davinci_gpio_platform_data *pdata;
+	struct davinci_gpio_regs __iomem *regs;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+
+	pdata = dev->platform_data;
+	if (!pdata) {
+		dev_err(dev, "No platform data found\n");
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
+		dev_err(dev, "How many GPIOs?\n");
 		return -EINVAL;
 	}
 
 	if (WARN_ON(DAVINCI_N_GPIO < ngpio))
 		ngpio = DAVINCI_N_GPIO;
 
-	gpio_base = ioremap(soc_info->gpio_base, SZ_4K);
-	if (WARN_ON(!gpio_base))
+	chips = devm_kzalloc(dev,
+			     ngpio * sizeof(struct davinci_gpio_controller),
+			     GFP_KERNEL);
+	if (!chips) {
+		dev_err(dev, "Memory allocation failed\n");
 		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "Invalid memory resource\n");
+		return -EBUSY;
+	}
+
+	gpio_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(gpio_base))
+		return PTR_ERR(gpio_base);
 
 	for (i = 0, base = 0; base < ngpio; i++, base += 32) {
 		chips[i].chip.label = "DaVinci";
@@ -184,13 +208,10 @@ static int __init davinci_gpio_setup(void)
 		gpiochip_add(&chips[i].chip);
 	}
 
-	soc_info->gpio_ctlrs = chips;
-	soc_info->gpio_ctlrs_num = DIV_ROUND_UP(ngpio, 32);
-
-	davinci_gpio_irq_setup();
+	platform_set_drvdata(pdev, chips);
+	davinci_gpio_irq_setup(pdev);
 	return 0;
 }
-pure_initcall(davinci_gpio_setup);
 
 /*--------------------------------------------------------------------------*/
 /*
@@ -303,14 +324,14 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
 
 static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
 {
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
+	struct davinci_gpio_controller *d = chip2controller(chip);
 
 	/*
 	 * NOTE:  we assume for now that only irqs in the first gpio_chip
 	 * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
 	 */
-	if (offset < soc_info->gpio_unbanked)
-		return soc_info->gpio_irq + offset;
+	if (offset < d->irq_base)
+		return d->gpio_irq + offset;
 	else
 		return -ENODEV;
 }
@@ -319,12 +340,11 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
 {
 	struct davinci_gpio_controller *d;
 	struct davinci_gpio_regs __iomem *g;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
 	u32 mask;
 
 	d = (struct davinci_gpio_controller *)data->handler_data;
 	g = (struct davinci_gpio_regs __iomem *)d->regs;
-	mask = __gpio_mask(data->irq - soc_info->gpio_irq);
+	mask = __gpio_mask(data->irq - d->gpio_irq);
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
@@ -345,24 +365,33 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
  * (dm6446) can be set appropriately for GPIOV33 pins.
  */
 
-static int __init davinci_gpio_irq_setup(void)
+static int davinci_gpio_irq_setup(struct platform_device *pdev)
 {
 	unsigned	gpio, irq, bank;
 	struct clk	*clk;
 	u32		binten = 0;
 	unsigned	ngpio, bank_irq;
-	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	struct davinci_gpio_regs	__iomem *g;
+	struct device *dev = &pdev->dev;
+	struct resource	*res;
+	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
+	struct davinci_gpio_platform_data *pdata = dev->platform_data;
+	struct davinci_gpio_regs __iomem *g;
 
-	ngpio = soc_info->gpio_num;
+	ngpio = pdata->ngpio;
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "Invalid IRQ resource\n");
+		return -EBUSY;
+	}
 
-	bank_irq = soc_info->gpio_irq;
-	if (bank_irq == 0) {
-		printk(KERN_ERR "Don't know first GPIO bank IRQ.\n");
-		return -EINVAL;
+	bank_irq = res->start;
+
+	if (!bank_irq) {
+		dev_err(dev, "Invalid IRQ resource\n");
+		return -ENODEV;
 	}
 
-	clk = clk_get(NULL, "gpio");
+	clk = devm_clk_get(dev, "gpio");
 	if (IS_ERR(clk)) {
 		printk(KERN_ERR "Error %ld getting gpio clock?\n",
 		       PTR_ERR(clk));
@@ -378,9 +407,9 @@ static int __init davinci_gpio_irq_setup(void)
 	 */
 	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
 		chips[bank].chip.to_irq = gpio_to_irq_banked;
-		chips[bank].irq_base = soc_info->gpio_unbanked
+		chips[bank].irq_base = pdata->gpio_unbanked
 			? -EINVAL
-			: (soc_info->intc_irq_num + gpio);
+			: (pdata->intc_irq_num + gpio);
 	}
 
 	/*
@@ -388,7 +417,7 @@ static int __init davinci_gpio_irq_setup(void)
 	 * controller only handling trigger modes.  We currently assume no
 	 * IRQ mux conflicts; gpio_irq_type_unbanked() is only for GPIOs.
 	 */
-	if (soc_info->gpio_unbanked) {
+	if (pdata->gpio_unbanked) {
 		static struct irq_chip_type gpio_unbanked;
 
 		/* pass "bank 0" GPIO IRQs to AINTC */
@@ -408,7 +437,7 @@ static int __init davinci_gpio_irq_setup(void)
 		__raw_writel(~0, &g->set_rising);
 
 		/* set the direct IRQs up to use that irqchip */
-		for (gpio = 0; gpio < soc_info->gpio_unbanked; gpio++, irq++) {
+		for (gpio = 0; gpio < pdata->gpio_unbanked; gpio++, irq++) {
 			irq_set_chip(irq, &gpio_unbanked.chip);
 			irq_set_handler_data(irq, &chips[gpio / 32]);
 			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
@@ -463,3 +492,21 @@ done:
 
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
+ * GPIO driver registration needs to be done before machine_init functions
+ * access GPIO. Hence davinci_gpio_drv_reg() is a postcore_initcall.
+ */
+static int __init davinci_gpio_drv_reg(void)
+{
+	return platform_driver_register(&davinci_gpio_driver);
+}
+postcore_initcall(davinci_gpio_drv_reg);
diff --git a/include/linux/platform_data/gpio-davinci.h b/include/linux/platform_data/gpio-davinci.h
new file mode 100644
index 0000000..2fcc125
--- /dev/null
+++ b/include/linux/platform_data/gpio-davinci.h
@@ -0,0 +1,25 @@
+/*
+ * DaVinci GPIO Platform Related Defines
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __DAVINCI_GPIO_PLATFORM_H
+#define __DAVINCI_GPIO_PLATFORM_H
+
+struct davinci_gpio_platform_data {
+	u32	ngpio;
+	u32	gpio_unbanked;
+	u32	intc_irq_num;
+};
+
+#endif
-- 
1.7.10.1


