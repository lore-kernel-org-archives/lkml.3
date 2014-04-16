Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaDPMHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:07:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:26552 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbaDPMHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:07:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,872,1389772800"; 
   d="scan'208";a="514133826"
From: Jin Yao <yao.jin@linux.intel.com>
To: linus.walleij@linaro.org, alan@linux.intel.com, mathias.nyman@intel.com,
        linux-kernel@vger.kernel.org
Cc: Jin Yao <yao.jin@linux.intel.com>
Subject: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on ASUS T100TA
Date: Wed, 16 Apr 2014 20:05:59 +0800
Message-Id: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A crash is triggered on the ASUS T100TA Baytrail-T because of a irq 
descriptor conflict. There are two gpio triggered acpi events in this
device, GPIO 6 and 18. These gpios are translated to irqs by calling
gpio_to_irq which in turn will call irq_create_mapping(vg->domain, offset).
irq_create_mapping will take care of allocating the irq descriptor, taking
the first available number starting from the given value (6 in our case).
The 0-15 are already reserved by legacy ISA code, so it gets the first
free irq descriptor which is number 16. The i915 driver also uses irq 16,
it loads later than gpio and crashes in probe.

The bug is reported here:
https://bugzilla.kernel.org/show_bug.cgi?id=68291

The rootcause we know now is a low level irq issue. It needs a long term
solution to fix the issue in irq system.

This patch changes the Baytrail GPIO driver to avoid the irq descriptor
conflict. It still uses the irq domain to allocate irq descriptor but start
from a predefined irq base number (256) to avoid the conflict.

Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 6e8301f..45b2d81 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -124,6 +124,18 @@ static struct pinctrl_gpio_range byt_ranges[] = {
 	},
 };
 
+/*
+ * Start from an irq base number above x86 ioapic range to work around some
+ * nasty, which is still in 3.14 unresolved irq descriptor conflicts.
+ */
+#define BYT_GPIO_PIN_IRQBASE	256
+
+static int byt_pin_irqbase[] = {
+	BYT_GPIO_PIN_IRQBASE,
+	BYT_GPIO_PIN_IRQBASE + BYT_NGPIO_SCORE,
+	BYT_GPIO_PIN_IRQBASE + BYT_NGPIO_SCORE + BYT_NGPIO_NCORE,
+};
+
 struct byt_gpio {
 	struct gpio_chip		chip;
 	struct irq_domain		*domain;
@@ -131,6 +143,7 @@ struct byt_gpio {
 	spinlock_t			lock;
 	void __iomem			*reg_base;
 	struct pinctrl_gpio_range	*range;
+	int				pin_irqbase;
 };
 
 #define to_byt_gpio(c)	container_of(c, struct byt_gpio, chip)
@@ -481,7 +494,7 @@ static int byt_gpio_probe(struct platform_device *pdev)
 	struct pinctrl_gpio_range *range;
 	acpi_handle handle = ACPI_HANDLE(dev);
 	unsigned hwirq;
-	int ret;
+	int ret, i;
 
 	if (acpi_bus_get_device(handle, &acpi_dev))
 		return -ENODEV;
@@ -496,6 +509,12 @@ static int byt_gpio_probe(struct platform_device *pdev)
 		if (!strcmp(acpi_dev->pnp.unique_id, range->name)) {
 			vg->chip.ngpio = range->npins;
 			vg->range = range;
+			ret = kstrtol(range->name, 10, &i);
+			if (ret != 0)
+				return ret;
+
+			i--;
+			vg->pin_irqbase = byt_pin_irqbase[i];
 			break;
 		}
 	}
@@ -527,19 +546,14 @@ static int byt_gpio_probe(struct platform_device *pdev)
 	gc->can_sleep = false;
 	gc->dev = dev;
 
-	ret = gpiochip_add(gc);
-	if (ret) {
-		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
-		return ret;
-	}
-
 	/* set up interrupts  */
 	irq_rc = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (irq_rc && irq_rc->start) {
 		hwirq = irq_rc->start;
 		gc->to_irq = byt_gpio_to_irq;
 
-		vg->domain = irq_domain_add_linear(NULL, gc->ngpio,
+		vg->domain = irq_domain_add_simple(NULL, gc->ngpio,
+						   vg->pin_irqbase,
 						   &byt_gpio_irq_ops, vg);
 		if (!vg->domain)
 			return -ENXIO;
@@ -550,6 +564,12 @@ static int byt_gpio_probe(struct platform_device *pdev)
 		irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
 	}
 
+	ret = gpiochip_add(gc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
+		return ret;
+	}
+
 	pm_runtime_enable(dev);
 
 	return 0;
@@ -572,6 +592,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
 
 static const struct acpi_device_id byt_gpio_acpi_match[] = {
 	{ "INT33B2", 0 },
+	{ "INT33FC", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
-- 
1.8.3.2

