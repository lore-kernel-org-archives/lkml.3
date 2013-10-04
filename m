Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3JDT6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:58:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:50672 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285Ab3JDT5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:57:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="388047497"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 3/3] gpio-intel-mid: update prefixes and names from langwell to intel-mid
Date: Fri,  4 Oct 2013 13:01:42 -0700
Message-Id: <1380916902-23791-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380916902-23791-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1380916902-23791-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After file was renamed from gpio-langwell to gpio-intel-mid, this patch
updates the variables, functions and structs to be based on intel-mid
instead of langwell.

There is no function change.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/gpio/gpio-intel-mid.c | 243 +++++++++++++++++++++---------------------
 1 file changed, 123 insertions(+), 120 deletions(-)

diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-mid.c
index bf3b959..612b54d 100644
--- a/drivers/gpio/gpio-intel-mid.c
+++ b/drivers/gpio/gpio-intel-mid.c
@@ -20,6 +20,8 @@
 /* Supports:
  * Moorestown platform Langwell chip.
  * Medfield platform Penwell chip.
+ * Clovertrail platform Cloverview chip.
+ * Merrifield platform Tangier chip.
  */
 
 #include <linux/module.h>
@@ -37,8 +39,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/irqdomain.h>
 
-#define LNW_IRQ_TYPE_EDGE	(1 << 0)
-#define LNW_IRQ_TYPE_LEVEL	(1 << 1)
+#define INTEL_MID_IRQ_TYPE_EDGE		(1 << 0)
+#define INTEL_MID_IRQ_TYPE_LEVEL	(1 << 1)
 
 /*
  * Langwell chip has 64 pins and thus there are 2 32bit registers to control
@@ -65,8 +67,8 @@ enum GPIO_REG {
 	GAFR,		/* alt function */
 };
 
-/* langwell gpio driver data */
-struct lnw_gpio_ddata {
+/* intel_mid gpio driver data */
+struct intel_mid_gpio_ddata {
 	u16 ngpio;		/* number of gpio pins */
 	u32 gplr_offset;	/* offset of first GPLR register from base */
 	u32 flis_base;		/* base address of FLIS registers */
@@ -75,7 +77,7 @@ struct lnw_gpio_ddata {
 	u32 chip_irq_type;	/* chip interrupt type */
 };
 
-struct lnw_gpio {
+struct intel_mid_gpio {
 	struct gpio_chip		chip;
 	void __iomem			*reg_base;
 	spinlock_t			lock;
@@ -83,29 +85,29 @@ struct lnw_gpio {
 	struct irq_domain		*domain;
 };
 
-#define to_lnw_priv(chip)	container_of(chip, struct lnw_gpio, chip)
+#define to_intel_gpio_priv(chip) container_of(chip, struct intel_mid_gpio, chip)
 
 static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
 			      enum GPIO_REG reg_type)
 {
-	struct lnw_gpio *lnw = to_lnw_priv(chip);
+	struct intel_mid_gpio *priv = to_intel_gpio_priv(chip);
 	unsigned nreg = chip->ngpio / 32;
 	u8 reg = offset / 32;
 
-	return lnw->reg_base + reg_type * nreg * 4 + reg * 4;
+	return priv->reg_base + reg_type * nreg * 4 + reg * 4;
 }
 
 static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
 				   enum GPIO_REG reg_type)
 {
-	struct lnw_gpio *lnw = to_lnw_priv(chip);
+	struct intel_mid_gpio *priv = to_intel_gpio_priv(chip);
 	unsigned nreg = chip->ngpio / 32;
 	u8 reg = offset / 16;
 
-	return lnw->reg_base + reg_type * nreg * 4 + reg * 4;
+	return priv->reg_base + reg_type * nreg * 4 + reg * 4;
 }
 
-static int lnw_gpio_request(struct gpio_chip *chip, unsigned offset)
+static int intel_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	void __iomem *gafr = gpio_reg_2bit(chip, offset, GAFR);
 	u32 value = readl(gafr);
@@ -118,14 +120,14 @@ static int lnw_gpio_request(struct gpio_chip *chip, unsigned offset)
 	return 0;
 }
 
-static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
+static int intel_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	void __iomem *gplr = gpio_reg(chip, offset, GPLR);
 
 	return readl(gplr) & BIT(offset % 32);
 }
 
-static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+static void intel_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	void __iomem *gpsr, *gpcr;
 
@@ -138,74 +140,74 @@ static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	}
 }
 
-static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+static int intel_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct lnw_gpio *lnw = to_lnw_priv(chip);
+	struct intel_mid_gpio *priv = to_intel_gpio_priv(chip);
 	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
 	u32 value;
 	unsigned long flags;
 
-	if (lnw->pdev)
-		pm_runtime_get(&lnw->pdev->dev);
+	if (priv->pdev)
+		pm_runtime_get(&priv->pdev->dev);
 
-	spin_lock_irqsave(&lnw->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	value = readl(gpdr);
 	value &= ~BIT(offset % 32);
 	writel(value, gpdr);
-	spin_unlock_irqrestore(&lnw->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (lnw->pdev)
-		pm_runtime_put(&lnw->pdev->dev);
+	if (priv->pdev)
+		pm_runtime_put(&priv->pdev->dev);
 
 	return 0;
 }
 
-static int lnw_gpio_direction_output(struct gpio_chip *chip,
+static int intel_gpio_direction_output(struct gpio_chip *chip,
 			unsigned offset, int value)
 {
-	struct lnw_gpio *lnw = to_lnw_priv(chip);
+	struct intel_mid_gpio *priv = to_intel_gpio_priv(chip);
 	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
 	unsigned long flags;
 
-	lnw_gpio_set(chip, offset, value);
+	intel_gpio_set(chip, offset, value);
 
-	if (lnw->pdev)
-		pm_runtime_get(&lnw->pdev->dev);
+	if (priv->pdev)
+		pm_runtime_get(&priv->pdev->dev);
 
-	spin_lock_irqsave(&lnw->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	value = readl(gpdr);
 	value |= BIT(offset % 32);
 	writel(value, gpdr);
-	spin_unlock_irqrestore(&lnw->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (lnw->pdev)
-		pm_runtime_put(&lnw->pdev->dev);
+	if (priv->pdev)
+		pm_runtime_put(&priv->pdev->dev);
 
 	return 0;
 }
 
-static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+static int intel_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	struct lnw_gpio *lnw = to_lnw_priv(chip);
-	return irq_create_mapping(lnw->domain, offset);
+	struct intel_mid_gpio *priv = to_intel_gpio_priv(chip);
+	return irq_create_mapping(priv->domain, offset);
 }
 
-static int lnw_irq_type(struct irq_data *d, unsigned type)
+static int intel_mid_irq_type(struct irq_data *d, unsigned type)
 {
-	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
+	struct intel_mid_gpio *priv = irq_data_get_irq_chip_data(d);
 	u32 gpio = irqd_to_hwirq(d);
 	unsigned long flags;
 	u32 value;
-	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
-	void __iomem *gfer = gpio_reg(&lnw->chip, gpio, GFER);
+	void __iomem *grer = gpio_reg(&priv->chip, gpio, GRER);
+	void __iomem *gfer = gpio_reg(&priv->chip, gpio, GFER);
 
-	if (gpio >= lnw->chip.ngpio)
+	if (gpio >= priv->chip.ngpio)
 		return -EINVAL;
 
-	if (lnw->pdev)
-		pm_runtime_get(&lnw->pdev->dev);
+	if (priv->pdev)
+		pm_runtime_get(&priv->pdev->dev);
 
-	spin_lock_irqsave(&lnw->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
 		value = readl(grer) | BIT(gpio % 32);
 	else
@@ -217,63 +219,63 @@ static int lnw_irq_type(struct irq_data *d, unsigned type)
 	else
 		value = readl(gfer) & (~BIT(gpio % 32));
 	writel(value, gfer);
-	spin_unlock_irqrestore(&lnw->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (lnw->pdev)
-		pm_runtime_put(&lnw->pdev->dev);
+	if (priv->pdev)
+		pm_runtime_put(&priv->pdev->dev);
 
 	return 0;
 }
 
-static void lnw_irq_unmask(struct irq_data *d)
+static void intel_mid_irq_unmask(struct irq_data *d)
 {
 }
 
-static void lnw_irq_mask(struct irq_data *d)
+static void intel_mid_irq_mask(struct irq_data *d)
 {
 }
 
-static struct irq_chip lnw_irqchip = {
-	.name		= "LNW-GPIO",
-	.irq_mask	= lnw_irq_mask,
-	.irq_unmask	= lnw_irq_unmask,
-	.irq_set_type	= lnw_irq_type,
+static struct irq_chip intel_mid_irqchip = {
+	.name		= "INTEL_MID-GPIO",
+	.irq_mask	= intel_mid_irq_mask,
+	.irq_unmask	= intel_mid_irq_unmask,
+	.irq_set_type	= intel_mid_irq_type,
 };
 
-static const struct lnw_gpio_ddata gpio_lincroft = {
+static const struct intel_mid_gpio_ddata gpio_lincroft = {
 	.ngpio = 64,
 };
 
-static const struct lnw_gpio_ddata gpio_penwell_aon = {
+static const struct intel_mid_gpio_ddata gpio_penwell_aon = {
 	.ngpio = 96,
-	.chip_irq_type = LNW_IRQ_TYPE_EDGE,
+	.chip_irq_type = INTEL_MID_IRQ_TYPE_EDGE,
 };
 
-static const struct lnw_gpio_ddata gpio_penwell_core = {
+static const struct intel_mid_gpio_ddata gpio_penwell_core = {
 	.ngpio = 96,
-	.chip_irq_type = LNW_IRQ_TYPE_EDGE,
+	.chip_irq_type = INTEL_MID_IRQ_TYPE_EDGE,
 };
 
-static const struct lnw_gpio_ddata gpio_cloverview_aon = {
+static const struct intel_mid_gpio_ddata gpio_cloverview_aon = {
 	.ngpio = 96,
-	.chip_irq_type = LNW_IRQ_TYPE_EDGE | LNW_IRQ_TYPE_LEVEL,
+	.chip_irq_type = INTEL_MID_IRQ_TYPE_EDGE | INTEL_MID_IRQ_TYPE_LEVEL,
 };
 
-static const struct lnw_gpio_ddata gpio_cloverview_core = {
+static const struct intel_mid_gpio_ddata gpio_cloverview_core = {
 	.ngpio = 96,
-	.chip_irq_type = LNW_IRQ_TYPE_EDGE,
+	.chip_irq_type = INTEL_MID_IRQ_TYPE_EDGE,
 };
 
-static const struct lnw_gpio_ddata gpio_tangier = {
+static const struct intel_mid_gpio_ddata gpio_tangier = {
 	.ngpio = 192,
 	.gplr_offset = 4,
 	.flis_base = 0xff0c0000,
 	.flis_len = 0x8000,
 	.get_flis_offset = NULL,
-	.chip_irq_type = LNW_IRQ_TYPE_EDGE,
+	.chip_irq_type = INTEL_MID_IRQ_TYPE_EDGE,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {
+static DEFINE_PCI_DEVICE_TABLE(intel_gpio_ids) = {
 	{
 		/* Lincroft */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f),
@@ -306,26 +308,26 @@ static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {
 	},
 	{ 0 }
 };
-MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
+MODULE_DEVICE_TABLE(pci, intel_gpio_ids);
 
-static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
+static void intel_mid_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	struct irq_data *data = irq_desc_get_irq_data(desc);
-	struct lnw_gpio *lnw = irq_data_get_irq_handler_data(data);
+	struct intel_mid_gpio *priv = irq_data_get_irq_handler_data(data);
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	u32 base, gpio, mask;
 	unsigned long pending;
 	void __iomem *gedr;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
-	for (base = 0; base < lnw->chip.ngpio; base += 32) {
-		gedr = gpio_reg(&lnw->chip, base, GEDR);
+	for (base = 0; base < priv->chip.ngpio; base += 32) {
+		gedr = gpio_reg(&priv->chip, base, GEDR);
 		while ((pending = readl(gedr))) {
 			gpio = __ffs(pending);
 			mask = BIT(gpio);
 			/* Clear before handling so we can't lose an edge */
 			writel(mask, gedr);
-			generic_handle_irq(irq_find_mapping(lnw->domain,
+			generic_handle_irq(irq_find_mapping(priv->domain,
 							    base + gpio));
 		}
 	}
@@ -333,61 +335,62 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 	chip->irq_eoi(data);
 }
 
-static void lnw_irq_init_hw(struct lnw_gpio *lnw)
+static void intel_mid_irq_init_hw(struct intel_mid_gpio *priv)
 {
 	void __iomem *reg;
 	unsigned base;
 
-	for (base = 0; base < lnw->chip.ngpio; base += 32) {
+	for (base = 0; base < priv->chip.ngpio; base += 32) {
 		/* Clear the rising-edge detect register */
-		reg = gpio_reg(&lnw->chip, base, GRER);
+		reg = gpio_reg(&priv->chip, base, GRER);
 		writel(0, reg);
 		/* Clear the falling-edge detect register */
-		reg = gpio_reg(&lnw->chip, base, GFER);
+		reg = gpio_reg(&priv->chip, base, GFER);
 		writel(0, reg);
 		/* Clear the edge detect status register */
-		reg = gpio_reg(&lnw->chip, base, GEDR);
+		reg = gpio_reg(&priv->chip, base, GEDR);
 		writel(~0, reg);
 	}
 }
 
-static int lnw_gpio_irq_map(struct irq_domain *d, unsigned int virq,
+static int intel_gpio_irq_map(struct irq_domain *d, unsigned int virq,
 			    irq_hw_number_t hw)
 {
-	struct lnw_gpio *lnw = d->host_data;
+	struct intel_mid_gpio *priv = d->host_data;
 
-	irq_set_chip_and_handler_name(virq, &lnw_irqchip, handle_simple_irq,
-				      "demux");
-	irq_set_chip_data(virq, lnw);
+	irq_set_chip_and_handler_name(virq, &intel_mid_irqchip,
+				      handle_simple_irq, "demux");
+	irq_set_chip_data(virq, priv);
 	irq_set_irq_type(virq, IRQ_TYPE_NONE);
 
 	return 0;
 }
 
-static const struct irq_domain_ops lnw_gpio_irq_ops = {
-	.map = lnw_gpio_irq_map,
+static const struct irq_domain_ops intel_gpio_irq_ops = {
+	.map = intel_gpio_irq_map,
 	.xlate = irq_domain_xlate_twocell,
 };
 
-static int lnw_gpio_runtime_idle(struct device *dev)
+static int intel_gpio_runtime_idle(struct device *dev)
 {
 	pm_schedule_suspend(dev, 500);
 	return -EBUSY;
 }
 
-static const struct dev_pm_ops lnw_gpio_pm_ops = {
-	SET_RUNTIME_PM_OPS(NULL, NULL, lnw_gpio_runtime_idle)
+static const struct dev_pm_ops intel_gpio_pm_ops = {
+	SET_RUNTIME_PM_OPS(NULL, NULL, intel_gpio_runtime_idle)
 };
 
-static int lnw_gpio_probe(struct pci_dev *pdev,
+static int intel_gpio_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *id)
 {
 	void __iomem *base;
-	struct lnw_gpio *lnw;
+	struct intel_mid_gpio *priv;
 	u32 gpio_base;
 	u32 irq_base;
 	int retval;
-	struct lnw_gpio_ddata *ddata = (struct lnw_gpio_ddata *)id->driver_data;
+	struct intel_mid_gpio_ddata *ddata =
+				(struct intel_mid_gpio_ddata *)id->driver_data;
 
 	retval = pcim_enable_device(pdev);
 	if (retval)
@@ -407,43 +410,43 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	/* release the IO mapping, since we already get the info from bar1 */
 	pcim_iounmap_regions(pdev, 1 << 1);
 
-	lnw = devm_kzalloc(&pdev->dev, sizeof(*lnw), GFP_KERNEL);
-	if (!lnw) {
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
 		dev_err(&pdev->dev, "can't allocate chip data\n");
 		return -ENOMEM;
 	}
 
-	lnw->reg_base = pcim_iomap_table(pdev)[0];
-	lnw->chip.label = dev_name(&pdev->dev);
-	lnw->chip.request = lnw_gpio_request;
-	lnw->chip.direction_input = lnw_gpio_direction_input;
-	lnw->chip.direction_output = lnw_gpio_direction_output;
-	lnw->chip.get = lnw_gpio_get;
-	lnw->chip.set = lnw_gpio_set;
-	lnw->chip.to_irq = lnw_gpio_to_irq;
-	lnw->chip.base = gpio_base;
-	lnw->chip.ngpio = ddata->ngpio;
-	lnw->chip.can_sleep = 0;
-	lnw->pdev = pdev;
-
-	spin_lock_init(&lnw->lock);
-
-	lnw->domain = irq_domain_add_simple(pdev->dev.of_node, ddata->ngpio,
-					    irq_base, &lnw_gpio_irq_ops, lnw);
-	if (!lnw->domain)
+	priv->reg_base = pcim_iomap_table(pdev)[0];
+	priv->chip.label = dev_name(&pdev->dev);
+	priv->chip.request = intel_gpio_request;
+	priv->chip.direction_input = intel_gpio_direction_input;
+	priv->chip.direction_output = intel_gpio_direction_output;
+	priv->chip.get = intel_gpio_get;
+	priv->chip.set = intel_gpio_set;
+	priv->chip.to_irq = intel_gpio_to_irq;
+	priv->chip.base = gpio_base;
+	priv->chip.ngpio = ddata->ngpio;
+	priv->chip.can_sleep = 0;
+	priv->pdev = pdev;
+
+	spin_lock_init(&priv->lock);
+
+	priv->domain = irq_domain_add_simple(pdev->dev.of_node, ddata->ngpio,
+					irq_base, &intel_gpio_irq_ops, priv);
+	if (!priv->domain)
 		return -ENOMEM;
 
-	pci_set_drvdata(pdev, lnw);
-	retval = gpiochip_add(&lnw->chip);
+	pci_set_drvdata(pdev, priv);
+	retval = gpiochip_add(&priv->chip);
 	if (retval) {
 		dev_err(&pdev->dev, "gpiochip_add error %d\n", retval);
 		return retval;
 	}
 
-	lnw_irq_init_hw(lnw);
+	intel_mid_irq_init_hw(priv);
 
-	irq_set_handler_data(pdev->irq, lnw);
-	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
+	irq_set_handler_data(pdev->irq, priv);
+	irq_set_chained_handler(pdev->irq, intel_mid_irq_handler);
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
@@ -451,18 +454,18 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	return 0;
 }
 
-static struct pci_driver lnw_gpio_driver = {
-	.name		= "langwell_gpio",
-	.id_table	= lnw_gpio_ids,
-	.probe		= lnw_gpio_probe,
+static struct pci_driver intel_gpio_driver = {
+	.name		= "intel_mid_gpio",
+	.id_table	= intel_gpio_ids,
+	.probe		= intel_gpio_probe,
 	.driver		= {
-		.pm	= &lnw_gpio_pm_ops,
+		.pm	= &intel_gpio_pm_ops,
 	},
 };
 
-static int __init lnw_gpio_init(void)
+static int __init intel_gpio_init(void)
 {
-	return pci_register_driver(&lnw_gpio_driver);
+	return pci_register_driver(&intel_gpio_driver);
 }
 
-device_initcall(lnw_gpio_init);
+device_initcall(intel_gpio_init);
-- 
1.8.4.rc3

