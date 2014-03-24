Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaCXO5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:57:20 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49979 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaCXO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:57:18 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] RFC: gpio: factor IRQ chip helpers into gpiolib
Date: Mon, 24 Mar 2014 15:57:10 +0100
Message-Id: <1395673030-21743-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides a function gpiochip_irqchip_add() to set
up an irqchip for a GPIO controller, and a function
gpiochip_set_chained_irqchip() to chain it to a parent
irqchip.

Most GPIOs are of the type where a number of lines form
a cascaded interrupt controller chained onto
the primary system interrupt controller (or further down the
chain) so let's add this helper and factor the code to
request the lines to be used as IRQs, the .to_irq() function
and the irqdomain into the core as well.

Exemplify by patching the Nomadik pin control driver and
PL061 (that I can test) to see if this is a good idea.
Patches will be split up if we proceed like this.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi Thomas, Alexander,

Is this the way to go?
---
 drivers/gpio/Kconfig              |   4 +
 drivers/gpio/gpio-pl061.c         |  80 +++++---------------
 drivers/gpio/gpiolib.c            | 150 ++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/Kconfig           |   3 +
 drivers/pinctrl/pinctrl-nomadik.c | 124 +++++++++----------------------
 include/linux/gpio.h              |   1 +
 include/linux/gpio/driver.h       |  30 ++++++++
 7 files changed, 240 insertions(+), 152 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 2e461e459d88..92d8e9a064b4 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -55,6 +55,9 @@ config GPIO_ACPI
 	def_bool y
 	depends on ACPI
 
+config GPIOLIB_IRQCHIP
+	bool
+
 config DEBUG_GPIO
 	bool "Debug GPIO calls"
 	depends on DEBUG_KERNEL
@@ -244,6 +247,7 @@ config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
 	depends on ARM_AMBA
 	select IRQ_DOMAIN
+	select GPIOLIB_IRQCHIP
 	help
 	  Say yes here to support the PrimeCell PL061 GPIO device
 
diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index d2a0ad5fc752..d56e6a1c37cd 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -15,7 +15,6 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/irqchip/chained_irq.h>
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
@@ -53,7 +52,6 @@ struct pl061_gpio {
 	spinlock_t		lock;
 
 	void __iomem		*base;
-	struct irq_domain	*domain;
 	struct gpio_chip	gc;
 
 #ifdef CONFIG_PM
@@ -137,16 +135,10 @@ static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
 	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
 }
 
-static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
-{
-	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
-
-	return irq_create_mapping(chip->domain, offset);
-}
-
 static int pl061_irq_type(struct irq_data *d, unsigned trigger)
 {
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 	int offset = irqd_to_hwirq(d);
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
@@ -194,7 +186,8 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	unsigned long pending;
 	int offset;
-	struct pl061_gpio *chip = irq_desc_get_handler_data(desc);
+	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 	struct irq_chip *irqchip = irq_desc_get_chip(desc);
 
 	chained_irq_enter(irqchip, desc);
@@ -203,7 +196,8 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 	writeb(pending, chip->base + GPIOIC);
 	if (pending) {
 		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
-			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
+			generic_handle_irq(irq_find_mapping(gc->irqdomain,
+							    offset));
 	}
 
 	chained_irq_exit(irqchip, desc);
@@ -211,7 +205,8 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 
 static void pl061_irq_mask(struct irq_data *d)
 {
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 	u8 mask = 1 << (irqd_to_hwirq(d) % PL061_GPIO_NR);
 	u8 gpioie;
 
@@ -223,7 +218,8 @@ static void pl061_irq_mask(struct irq_data *d)
 
 static void pl061_irq_unmask(struct irq_data *d)
 {
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
 	u8 mask = 1 << (irqd_to_hwirq(d) % PL061_GPIO_NR);
 	u8 gpioie;
 
@@ -233,50 +229,11 @@ static void pl061_irq_unmask(struct irq_data *d)
 	spin_unlock(&chip->lock);
 }
 
-static int pl061_irq_reqres(struct irq_data *d)
-{
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
-
-	if (gpio_lock_as_irq(&chip->gc, irqd_to_hwirq(d))) {
-		dev_err(chip->gc.dev,
-			"unable to lock HW IRQ %lu for IRQ\n",
-			irqd_to_hwirq(d));
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void pl061_irq_relres(struct irq_data *d)
-{
-	struct pl061_gpio *chip = irq_data_get_irq_chip_data(d);
-
-	gpio_unlock_as_irq(&chip->gc, irqd_to_hwirq(d));
-}
-
 static struct irq_chip pl061_irqchip = {
 	.name		= "pl061",
 	.irq_mask	= pl061_irq_mask,
 	.irq_unmask	= pl061_irq_unmask,
 	.irq_set_type	= pl061_irq_type,
-	.irq_request_resources = pl061_irq_reqres,
-	.irq_release_resources = pl061_irq_relres,
-};
-
-static int pl061_irq_map(struct irq_domain *d, unsigned int irq,
-			 irq_hw_number_t hwirq)
-{
-	struct pl061_gpio *chip = d->host_data;
-
-	irq_set_chip_and_handler(irq, &pl061_irqchip, handle_simple_irq);
-	irq_set_chip_data(irq, chip);
-	irq_set_irq_type(irq, IRQ_TYPE_NONE);
-
-	return 0;
-}
-
-static const struct irq_domain_ops pl061_domain_ops = {
-	.map	= pl061_irq_map,
-	.xlate	= irq_domain_xlate_twocell,
 };
 
 static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
@@ -314,7 +271,6 @@ static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 	chip->gc.direction_output = pl061_direction_output;
 	chip->gc.get = pl061_get_value;
 	chip->gc.set = pl061_set_value;
-	chip->gc.to_irq = pl061_to_irq;
 	chip->gc.ngpio = PL061_GPIO_NR;
 	chip->gc.label = dev_name(dev);
 	chip->gc.dev = dev;
@@ -334,15 +290,15 @@ static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 		return -ENODEV;
 	}
 
-	irq_set_chained_handler(irq, pl061_irq_handler);
-	irq_set_handler_data(irq, chip);
-
-	chip->domain = irq_domain_add_simple(adev->dev.of_node, PL061_GPIO_NR,
-					     irq_base, &pl061_domain_ops, chip);
-	if (!chip->domain) {
-		dev_err(&adev->dev, "no irq domain\n");
-		return -ENODEV;
+	ret = gpiochip_irqchip_add(adev->dev.of_node, irq_base,
+				   &chip->gc, &pl061_irqchip,
+				   handle_simple_irq, IRQ_TYPE_NONE);
+	if (ret) {
+		dev_info(&adev->dev, "could not add irqchip\n");
+		return ret;
 	}
+	gpiochip_set_chained_irqchip(&chip->gc, &pl061_irqchip,
+				     irq, pl061_irq_handler);
 
 	for (i = 0; i < PL061_GPIO_NR; i++) {
 		if (pdata) {
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 584d2b465f84..4c0007658dc4 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1339,6 +1339,156 @@ static struct gpio_chip *find_chip_by_name(const char *name)
 	return gpiochip_find((void *)name, gpiochip_match_name);
 }
 
+#ifdef CONFIG_GPIOLIB_IRQCHIP
+
+/*
+ * The following is irqchip helper code for gpiochips.
+ */
+
+/**
+ * gpiochip_add_chained_irqchip() - adds a chained irqchip to a gpiochip
+ * @gpiochip: the gpiochip to add the irqchip to
+ * @irqchip: the irqchip to add to the gpiochip
+ * @parent_irq: the irq number corresponding to the parent IRQ for this
+ * chained irqchip
+ * @parent_handler: the parent interrupt handler for the accumulated IRQ
+ * coming out of the gpiochip
+ */
+void gpiochip_set_chained_irqchip(struct gpio_chip *gpiochip,
+				  struct irq_chip *irqchip,
+				  int parent_irq,
+				  irq_flow_handler_t parent_handler)
+{
+	irq_set_chained_handler(parent_irq, parent_handler);
+	/*
+	 * The parent irqchip is already using the chip_data for this
+	 * irqchip, so our callbacks simply use the handler_data.
+	 */
+	irq_set_handler_data(parent_irq, gpiochip);
+}
+EXPORT_SYMBOL_GPL(gpiochip_set_chained_irqchip);
+
+/**
+ * gpiochip_irq_map() - maps an IRQ into a GPIO irqchip
+ * @d: the irqdomain used by this irqchip
+ * @irq: the global irq number used by this GPIO irqchip irq
+ * @hwirq: the local IRQ/GPIO line offset on this gpiochip
+ *
+ * This function will set up the mapping for a certain IRQ line on a
+ * gpiochip by assigning the gpiochip as chip data, and using the irqchip
+ * stored inside the gpiochip.
+ */
+static int gpiochip_irq_map(struct irq_domain *d, unsigned int irq,
+			    irq_hw_number_t hwirq)
+{
+	struct gpio_chip *chip = d->host_data;
+
+	irq_set_chip_and_handler(irq, chip->irqchip, chip->irq_handler);
+	irq_set_chip_data(irq, chip);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
+	irq_set_irq_type(irq, chip->irq_default_type);
+
+	return 0;
+}
+
+static const struct irq_domain_ops gpiochip_domain_ops = {
+	.map	= gpiochip_irq_map,
+	/* Virtually all GPIO irqchips are twocell:ed */
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static int gpiochip_irq_reqres(struct irq_data *d)
+{
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+
+	if (gpio_lock_as_irq(chip, d->hwirq)) {
+		chip_err(chip,
+			"unable to lock HW IRQ %lu for IRQ\n",
+			d->hwirq);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void gpiochip_irq_relres(struct irq_data *d)
+{
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+
+	gpio_unlock_as_irq(chip, d->hwirq);
+}
+
+static int gpiochip_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	return irq_find_mapping(chip->irqdomain, offset);
+}
+
+/**
+ * gpiochip_irqchip_add() - adds an irqchip to a gpiochip
+ * @of_node: the OF node of this gpiochip
+ * @first_irq: if not dynamically assigned, the base (first) IRQ to
+ * allocate gpiochip irqs from
+ * @gpiochip: the gpiochip to add the irqchip to
+ * @irqchip: the irqchip to add to the gpiochip
+ * @handler: the irq handler to use (often a predefined irq core function)
+ * @type: the default type for IRQs on this irqchip
+ *
+ * This function closely associates a certain irqchip with a certain
+ * gpiochip, providing an irq domain to translate the local IRQs to
+ * global irqs in the gpiolib core, and making sure that the gpiochip
+ * is passed as chip data to all related functions. Driver callbacks
+ * need to use container_of() to get their local state containers back
+ * from the gpiochip passed as chip data. An irqdomain will be stored
+ * in the gpiochip that shall be used by the driver to handle IRQ number
+ * translation. The gpiochip will need to be initialized and registered
+ * before calling this function.
+ *
+ * This function will handle two cell:ed simple IRQs. Everything else
+ * need to be open coded.
+ */
+int gpiochip_irqchip_add(struct device_node *of_node,
+			 unsigned int first_irq,
+			 struct gpio_chip *gpiochip,
+			 struct irq_chip *irqchip,
+			 irq_flow_handler_t handler,
+			 unsigned int type)
+{
+	unsigned int offset;
+
+	if (!gpiochip || !irqchip)
+		return -EINVAL;
+
+	gpiochip->irqchip = irqchip;
+	gpiochip->irq_handler = handler;
+	gpiochip->irq_default_type = type;
+	gpiochip->to_irq = gpiochip_to_irq;
+	gpiochip->irqdomain = irq_domain_add_simple(of_node,
+					gpiochip->ngpio, first_irq,
+					&gpiochip_domain_ops, gpiochip);
+	if (!gpiochip->irqdomain) {
+		gpiochip->irqchip = NULL;
+		return -EINVAL;
+	}
+	irqchip->irq_request_resources = gpiochip_irq_reqres;
+	irqchip->irq_release_resources = gpiochip_irq_relres;
+
+	/*
+	 * Prepare the mapping since the irqchip shall be orthogonal to
+	 * to any gpiochip calls. If the first_irq was zero, this is
+	 * necessary to allocate descriptors for all IRQs.
+	 */
+	for (offset = 0; offset < gpiochip->ngpio; offset++)
+		irq_create_mapping(gpiochip->irqdomain, offset);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gpiochip_irqchip_add);
+
+#endif /* CONFIG_GPIOLIB_IRQCHIP */
+
 #ifdef CONFIG_PINCTRL
 
 /**
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 1e4e69384baa..a05087bd1955 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -235,6 +235,9 @@ config PINCTRL_NOMADIK
 	depends on ARCH_U8500 || ARCH_NOMADIK
 	select PINMUX
 	select PINCONF
+	select GPIOLIB
+	select OF_GPIO
+	select GPIOLIB_IRQCHIP
 
 config PINCTRL_STN8815
 	bool "STN8815 pin controller driver"
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 2ea3f3738eab..10d8dd8afaa3 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -21,9 +21,6 @@
 #include <linux/gpio.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
-#include <linux/irqchip/chained_irq.h>
 #include <linux/slab.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
@@ -261,7 +258,6 @@ struct nmk_gpio_platform_data {
 
 struct nmk_gpio_chip {
 	struct gpio_chip chip;
-	struct irq_domain *domain;
 	void __iomem *addr;
 	struct clk *clk;
 	unsigned int bank;
@@ -432,7 +428,7 @@ nmk_gpio_disable_lazy_irq(struct nmk_gpio_chip *nmk_chip, unsigned offset)
 	u32 falling = nmk_chip->fimsc & BIT(offset);
 	u32 rising = nmk_chip->rimsc & BIT(offset);
 	int gpio = nmk_chip->chip.base + offset;
-	int irq = irq_find_mapping(nmk_chip->domain, offset);
+	int irq = irq_find_mapping(nmk_chip->chip.irqdomain, offset);
 	struct irq_data *d = irq_get_irq_data(irq);
 
 	if (!rising && !falling)
@@ -660,11 +656,8 @@ static inline int nmk_gpio_get_bitmask(int gpio)
 
 static void nmk_gpio_irq_ack(struct irq_data *d)
 {
-	struct nmk_gpio_chip *nmk_chip;
-
-	nmk_chip = irq_data_get_irq_chip_data(d);
-	if (!nmk_chip)
-		return;
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct nmk_gpio_chip *nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
 
 	clk_enable(nmk_chip->clk);
 	writel(nmk_gpio_get_bitmask(d->hwirq), nmk_chip->addr + NMK_GPIO_IC);
@@ -861,26 +854,6 @@ static void nmk_gpio_irq_shutdown(struct irq_data *d)
 	clk_disable(nmk_chip->clk);
 }
 
-static int nmk_gpio_irq_reqres(struct irq_data *d)
-{
-	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
-
-	if (gpio_lock_as_irq(&nmk_chip->chip, d->hwirq)) {
-		dev_err(nmk_chip->chip.dev,
-			"unable to lock HW IRQ %lu for IRQ\n",
-			d->hwirq);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void nmk_gpio_irq_relres(struct irq_data *d)
-{
-	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
-
-	gpio_unlock_as_irq(&nmk_chip->chip, d->hwirq);
-}
-
 static struct irq_chip nmk_gpio_irq_chip = {
 	.name		= "Nomadik-GPIO",
 	.irq_ack	= nmk_gpio_irq_ack,
@@ -890,24 +863,21 @@ static struct irq_chip nmk_gpio_irq_chip = {
 	.irq_set_wake	= nmk_gpio_irq_set_wake,
 	.irq_startup	= nmk_gpio_irq_startup,
 	.irq_shutdown	= nmk_gpio_irq_shutdown,
-	.irq_request_resources = nmk_gpio_irq_reqres,
-	.irq_release_resources = nmk_gpio_irq_relres,
 	.flags		= IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
 				   u32 status)
 {
-	struct nmk_gpio_chip *nmk_chip;
 	struct irq_chip *host_chip = irq_get_chip(irq);
+	struct gpio_chip *chip = irq_desc_get_handler_data(desc);
 
 	chained_irq_enter(host_chip, desc);
 
-	nmk_chip = irq_get_handler_data(irq);
 	while (status) {
 		int bit = __ffs(status);
 
-		generic_handle_irq(irq_find_mapping(nmk_chip->domain, bit));
+		generic_handle_irq(irq_find_mapping(chip->irqdomain, bit));
 		status &= ~BIT(bit);
 	}
 
@@ -916,9 +886,11 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
 
 static void nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
-	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
+	struct gpio_chip *chip = irq_desc_get_handler_data(desc);
+	struct nmk_gpio_chip *nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
 	u32 status;
 
+	pr_err("PLONK IRQ %d\n", irq);
 	clk_enable(nmk_chip->clk);
 	status = readl(nmk_chip->addr + NMK_GPIO_IS);
 	clk_disable(nmk_chip->clk);
@@ -929,26 +901,13 @@ static void nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 static void nmk_gpio_secondary_irq_handler(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
+	struct gpio_chip *chip = irq_desc_get_handler_data(desc);
+	struct nmk_gpio_chip *nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
 	u32 status = nmk_chip->get_secondary_status(nmk_chip->bank);
 
 	__nmk_gpio_irq_handler(irq, desc, status);
 }
 
-static int nmk_gpio_init_irq(struct nmk_gpio_chip *nmk_chip)
-{
-	irq_set_chained_handler(nmk_chip->parent_irq, nmk_gpio_irq_handler);
-	irq_set_handler_data(nmk_chip->parent_irq, nmk_chip);
-
-	if (nmk_chip->secondary_parent_irq >= 0) {
-		irq_set_chained_handler(nmk_chip->secondary_parent_irq,
-					nmk_gpio_secondary_irq_handler);
-		irq_set_handler_data(nmk_chip->secondary_parent_irq, nmk_chip);
-	}
-
-	return 0;
-}
-
 /* I/O Functions */
 
 static int nmk_gpio_request(struct gpio_chip *chip, unsigned offset)
@@ -1027,14 +986,6 @@ static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
 	return 0;
 }
 
-static int nmk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct nmk_gpio_chip *nmk_chip =
-		container_of(chip, struct nmk_gpio_chip, chip);
-
-	return irq_create_mapping(nmk_chip->domain, offset);
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 #include <linux/seq_file.h>
@@ -1133,7 +1084,6 @@ static struct gpio_chip nmk_gpio_template = {
 	.get			= nmk_gpio_get_input,
 	.direction_output	= nmk_gpio_make_output,
 	.set			= nmk_gpio_set_output,
-	.to_irq			= nmk_gpio_to_irq,
 	.dbg_show		= nmk_gpio_dbg_show,
 	.can_sleep		= false,
 };
@@ -1234,27 +1184,6 @@ void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up)
 	}
 }
 
-static int nmk_gpio_irq_map(struct irq_domain *d, unsigned int irq,
-			    irq_hw_number_t hwirq)
-{
-	struct nmk_gpio_chip *nmk_chip = d->host_data;
-
-	if (!nmk_chip)
-		return -EINVAL;
-
-	irq_set_chip_and_handler(irq, &nmk_gpio_irq_chip, handle_edge_irq);
-	set_irq_flags(irq, IRQF_VALID);
-	irq_set_chip_data(irq, nmk_chip);
-	irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
-
-	return 0;
-}
-
-static const struct irq_domain_ops nmk_gpio_irq_simple_ops = {
-	.map = nmk_gpio_irq_map,
-	.xlate = irq_domain_xlate_twocell,
-};
-
 static int nmk_gpio_probe(struct platform_device *dev)
 {
 	struct nmk_gpio_platform_data *pdata;
@@ -1342,17 +1271,32 @@ static int nmk_gpio_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, nmk_chip);
 
-	nmk_chip->domain = irq_domain_add_simple(np,
-				NMK_GPIO_PER_CHIP, 0,
-				&nmk_gpio_irq_simple_ops, nmk_chip);
-	if (!nmk_chip->domain) {
-		dev_err(&dev->dev, "failed to create irqdomain\n");
-		/* Just do this, no matter if it fails */
+	/*
+	 * Let the generic code handle this edge IRQ, the the chained
+	 * handler will perform the actual work of handling the parent
+	 * interrupt.
+	 */
+	ret = gpiochip_irqchip_add(np,
+				   0,
+				   &nmk_chip->chip,
+				   &nmk_gpio_irq_chip,
+				   handle_edge_irq,
+				   IRQ_TYPE_EDGE_FALLING);
+	if (ret) {
+		dev_err(&dev->dev, "could not add irqchip\n");
 		ret = gpiochip_remove(&nmk_chip->chip);
-		return -ENOSYS;
+		return -ENODEV;
 	}
-
-	nmk_gpio_init_irq(nmk_chip);
+	/* Then register the chain on the parent IRQ */
+	gpiochip_set_chained_irqchip(&nmk_chip->chip,
+				     &nmk_gpio_irq_chip,
+				     nmk_chip->parent_irq,
+				     nmk_gpio_irq_handler);
+	if (nmk_chip->secondary_parent_irq > 0)
+		gpiochip_set_chained_irqchip(&nmk_chip->chip,
+					     &nmk_gpio_irq_chip,
+					     nmk_chip->secondary_parent_irq,
+					     nmk_gpio_secondary_irq_handler);
 
 	dev_info(&dev->dev, "at address %p\n", nmk_chip->addr);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index b581b13d29d9..2d112b890cbc 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -2,6 +2,7 @@
 #define __LINUX_GPIO_H
 
 #include <linux/errno.h>
+#include <linux/irq.h>
 
 /* see Documentation/gpio.txt */
 
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 9fe283642253..8e7d0051e6db 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -3,6 +3,9 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/irqdomain.h>
 
 struct device;
 struct gpio_desc;
@@ -97,6 +100,17 @@ struct gpio_chip {
 	bool			can_sleep;
 	bool			exported;
 
+#ifdef CONFIG_GPIOLIB_IRQCHIP
+	/*
+	 * With CONFIG_GPIO_IRQCHIP we get an irqchip inside the gpiolib
+	 * to handle IRQs for most practical cases.
+	 */
+	struct irq_chip		*irqchip;
+	struct irq_domain	*irqdomain;
+	irq_flow_handler_t	irq_handler;
+	unsigned int		irq_default_type;
+#endif
+
 #if defined(CONFIG_OF_GPIO)
 	/*
 	 * If CONFIG_OF is enabled, then all GPIO controllers described in the
@@ -190,6 +204,22 @@ struct gpiod_lookup_table {
 
 void gpiod_add_lookup_table(struct gpiod_lookup_table *table);
 
+#ifdef CONFIG_GPIOLIB_IRQCHIP
+
+void gpiochip_set_chained_irqchip(struct gpio_chip *gpiochip,
+		struct irq_chip *irqchip,
+		int parent_irq,
+		irq_flow_handler_t parent_handler);
+
+int gpiochip_irqchip_add(struct device_node *of_node,
+		unsigned int first_irq,
+		struct gpio_chip *gpiochip,
+		struct irq_chip *irqchip,
+		irq_flow_handler_t handler,
+		unsigned int type);
+
+#endif /* CONFIG_GPIO_IRQCHIP */
+
 #else /* CONFIG_GPIOLIB */
 
 static inline struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
-- 
1.8.5.3

