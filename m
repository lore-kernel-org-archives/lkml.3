Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbaGYGzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:55:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:46836 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGYGzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="567043474"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhu Lejun <lejun.zhu@linux.intel.com>, Yang Bin <bin.yang@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] pinctrl: baytrail: Convert to use gpiolib irqchip
Date: Fri, 25 Jul 2014 09:54:47 +0300
Message-Id: <1406271288-15995-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1406271288-15995-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding irqchip handling in the driver we can take advantage
of the new irqchip helpers provided by the gpiolib core.

While doing this we also make sure that we call gpiochip_irqchip_add()
after the gpiochip itself is registered as required.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pinctrl/Kconfig            |  2 +-
 drivers/pinctrl/pinctrl-baytrail.c | 87 +++++++++-----------------------------
 2 files changed, 20 insertions(+), 69 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 0042ccb46b9a..bd6f9926a569 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -93,7 +93,7 @@ config PINCTRL_AT91
 config PINCTRL_BAYTRAIL
 	bool "Intel Baytrail GPIO pin control"
 	depends on GPIOLIB && ACPI && X86
-	select IRQ_DOMAIN
+	select GPIOLIB_IRQCHIP
 	help
 	  driver for memory mapped GPIO functionality on Intel Baytrail
 	  platforms. Supports 3 banks with 102, 28 and 44 gpios.
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 975572e2f260..cb5419ca6577 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -25,9 +25,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
 #include <linux/gpio.h>
-#include <linux/irqdomain.h>
 #include <linux/acpi.h>
 #include <linux/platform_device.h>
 #include <linux/seq_file.h>
@@ -137,7 +135,6 @@ static struct pinctrl_gpio_range byt_ranges[] = {
 
 struct byt_gpio {
 	struct gpio_chip		chip;
-	struct irq_domain		*domain;
 	struct platform_device		*pdev;
 	spinlock_t			lock;
 	void __iomem			*reg_base;
@@ -217,7 +214,7 @@ static void byt_gpio_free(struct gpio_chip *chip, unsigned offset)
 
 static int byt_irq_type(struct irq_data *d, unsigned type)
 {
-	struct byt_gpio *vg = irq_data_get_irq_chip_data(d);
+	struct byt_gpio *vg = to_byt_gpio(irq_data_get_irq_chip_data(d));
 	u32 offset = irqd_to_hwirq(d);
 	u32 value;
 	unsigned long flags;
@@ -393,16 +390,10 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	spin_unlock_irqrestore(&vg->lock, flags);
 }
 
-static int byt_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct byt_gpio *vg = to_byt_gpio(chip);
-	return irq_create_mapping(vg->domain, offset);
-}
-
 static void byt_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	struct irq_data *data = irq_desc_get_irq_data(desc);
-	struct byt_gpio *vg = irq_data_get_irq_handler_data(data);
+	struct byt_gpio *vg = to_byt_gpio(irq_desc_get_handler_data(desc));
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
 	u32 base, pin, mask;
 	void __iomem *reg;
@@ -421,7 +412,7 @@ static void byt_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 			/* Clear before handling so we can't lose an edge */
 			writel(mask, reg);
 
-			virq = irq_find_mapping(vg->domain, base + pin);
+			virq = irq_find_mapping(vg->chip.irqdomain, base + pin);
 			generic_handle_irq(virq);
 
 			/* In case bios or user sets triggering incorretly a pin
@@ -454,33 +445,11 @@ static void byt_irq_mask(struct irq_data *d)
 {
 }
 
-static int byt_irq_reqres(struct irq_data *d)
-{
-	struct byt_gpio *vg = irq_data_get_irq_chip_data(d);
-
-	if (gpio_lock_as_irq(&vg->chip, irqd_to_hwirq(d))) {
-		dev_err(vg->chip.dev,
-			"unable to lock HW IRQ %lu for IRQ\n",
-			irqd_to_hwirq(d));
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void byt_irq_relres(struct irq_data *d)
-{
-	struct byt_gpio *vg = irq_data_get_irq_chip_data(d);
-
-	gpio_unlock_as_irq(&vg->chip, irqd_to_hwirq(d));
-}
-
 static struct irq_chip byt_irqchip = {
 	.name = "BYT-GPIO",
 	.irq_mask = byt_irq_mask,
 	.irq_unmask = byt_irq_unmask,
 	.irq_set_type = byt_irq_type,
-	.irq_request_resources = byt_irq_reqres,
-	.irq_release_resources = byt_irq_relres,
 };
 
 static void byt_gpio_irq_init_hw(struct byt_gpio *vg)
@@ -501,23 +470,6 @@ static void byt_gpio_irq_init_hw(struct byt_gpio *vg)
 	}
 }
 
-static int byt_gpio_irq_map(struct irq_domain *d, unsigned int virq,
-			    irq_hw_number_t hw)
-{
-	struct byt_gpio *vg = d->host_data;
-
-	irq_set_chip_and_handler_name(virq, &byt_irqchip, handle_simple_irq,
-				      "demux");
-	irq_set_chip_data(virq, vg);
-	irq_set_irq_type(virq, IRQ_TYPE_NONE);
-
-	return 0;
-}
-
-static const struct irq_domain_ops byt_gpio_irq_ops = {
-	.map = byt_gpio_irq_map,
-};
-
 static int byt_gpio_probe(struct platform_device *pdev)
 {
 	struct byt_gpio *vg;
@@ -527,7 +479,6 @@ static int byt_gpio_probe(struct platform_device *pdev)
 	struct acpi_device *acpi_dev;
 	struct pinctrl_gpio_range *range;
 	acpi_handle handle = ACPI_HANDLE(dev);
-	unsigned hwirq;
 	int ret;
 
 	if (acpi_bus_get_device(handle, &acpi_dev))
@@ -574,27 +525,27 @@ static int byt_gpio_probe(struct platform_device *pdev)
 	gc->can_sleep = false;
 	gc->dev = dev;
 
+	ret = gpiochip_add(gc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
+		return ret;
+	}
+
 	/* set up interrupts  */
 	irq_rc = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (irq_rc && irq_rc->start) {
-		hwirq = irq_rc->start;
-		gc->to_irq = byt_gpio_to_irq;
-
-		vg->domain = irq_domain_add_linear(NULL, gc->ngpio,
-						   &byt_gpio_irq_ops, vg);
-		if (!vg->domain)
-			return -ENXIO;
-
 		byt_gpio_irq_init_hw(vg);
+		ret = gpiochip_irqchip_add(gc, &byt_irqchip, 0,
+					   handle_simple_irq, IRQ_TYPE_NONE);
+		if (ret) {
+			dev_err(dev, "failed to add irqchip\n");
+			gpiochip_remove(gc);
+			return ret;
+		}
 
-		irq_set_handler_data(hwirq, vg);
-		irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
-	}
-
-	ret = gpiochip_add(gc);
-	if (ret) {
-		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
-		return ret;
+		gpiochip_set_chained_irqchip(gc, &byt_irqchip,
+					     (unsigned)irq_rc->start,
+					     byt_gpio_irq_handler);
 	}
 
 	pm_runtime_enable(dev);
-- 
2.0.1

