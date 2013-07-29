Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3G2Msa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:48:30 -0400
Received: from mail.df.lth.se ([194.47.250.12]:40080 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3G2Ms2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:48:28 -0400
X-Greylist: delayed 724 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2013 08:48:27 EDT
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>
Cc: Linux-OMAP <linux-omap@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
Date: Mon, 29 Jul 2013 14:36:08 +0200
Message-Id: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: THIS PATCH IS UNFINISHED AND UNTESTED AND THE ONLY
INTENTION IS TO SHOWCASE MY DESIRED APPROACH, IT WILL NOT
TRAVERSE THE DT INTERRUPTS PROPERLY AS OF NOW. PLEASE LET US
JUST DISCUSS THIS APPROACH.

Currently the kernel are ambigously treating GPIOs and interrupts
from a GPIO controller: GPIOs and interrupts are treated as
orthogonal. This unfortunately makes it unclear how to actually
retrieve and request a GPIO line or interrupt from a GPIO
controller in the device tree probe path.

In the non-DT probe path it is clear that the GPIO number has to
be passed to the consuming device, and if it is to be used as
an interrupt, the consumer shall performa a gpio_to_irq() mapping
and request the resulting IRQ number.

In the DT boot path consumers may have been given one or more
interrupts from the interrupt-controller side of the GPIO chip
in an abstract way, such that the driver is not aware of the
fact that a GPIO chip is backing this interrupt, and the GPIO
side of the same line is never requested with gpio_request().
A typical case for this is ethernet chips which just take some
interrupt line which may be a "hard" interrupt line (such as an
external interrupt line from an SoC) or a cascaded interrupt
connected to a GPIO line.

This has the following undesired effects:

- The GPIOlib subsystem is not aware that the line is in use
  and willingly lets some other consumer perform gpio_request()
  on it, leading to a complex resource conflict if it occurs.

- The GPIO debugfs file claims this GPIO line is "free".

- The line direction of the interrupt GPIO line is not
  explicitly set as input, even though it is obvious that such
  a line need to be set up in this way, often making the system
  depend on boot-on defaults for this kind of settings.

To solve this dilemma, perform an interrupt consistency check
when adding a GPIO chip: if the chip is both gpio-controller and
interrupt-controller, walk all children of the device tree,
check if these in turn reference the interrupt-controller, and
if they do, loop over the interrupts used by that child and
perform gpio_reques() and gpio_direction_input() on these,
making them unreachable from the GPIO side.

Cc: devicetree@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Balaji T K <balajitk@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Jon Hunter <jgchunter@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib-of.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 665f953..129f0e7 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -19,6 +19,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_gpio.h>
+#include <linux/of_irq.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/slab.h>
 
@@ -127,6 +128,112 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
 EXPORT_SYMBOL(of_gpio_simple_xlate);
 
 /**
+ * of_gpiochip_interrupt_consistency_check - check IRQ consistency
+ * @np:		device node of the GPIO chip
+ * @gc:		GPIO chip instantiated from same node
+ *
+ * This function is called after instantiating a GPIO chip from a device
+ * tree node to assert that all interrupts derived from the chip are
+ * consistently requested as GPIO lines, if the GPIO chip is BOTH a
+ * gpio-controller AND an interrupt-controller.
+ *
+ * If another node in the device tree is referencing the interrupt-controller
+ * portions of the GPIO chip, such that it is using a GPIO line as some
+ * arbitrary interrupt source, the following holds:
+ *
+ * - That line must NOT be used anywhere else in the device tree as a
+ *   <&gpio N> reference, or GPIO and interrupt usage may conflict.
+ *
+ * Conversely, if a node is using a line as a direct reference to a GPIO line,
+ * no node in the tree may use that line as an interrupt.
+ *
+ * If another node is referencing a GPIO line, and also want to use that line
+ * as an interrupt source, it is necessary for this driver to use the
+ * gpio_to_irq() kernel interface.
+ */
+static void of_gpiochip_interrupt_consistency_check(struct device_node *np,
+						    struct gpio_chip *gc)
+{
+	struct device_node *root, *child;
+	struct device_node *irq_parent;
+
+	/*
+	 * If this chip is not tagged as interrupt-controller, there is
+	 * no problem so we just exit.
+	 */
+	if (!of_property_read_bool(np, "interrupt-controller"))
+	    return;
+
+	/*
+	 * Proceed to check the consistency of all references to this
+	 * GPIO chip.
+	 */
+	root = of_find_node_by_path("/");
+	if (!root)
+		return;
+
+	for_each_child_of_node(root, child) {
+		const __be32 *intspec;
+		u32 intlen;
+		u32 offset;
+		int ret;
+		int num_irq;
+		int i;
+
+		/* Check if we have an IRQ parent, else continue */
+		irq_parent = of_irq_find_parent(child);
+		if (!irq_parent)
+			continue;
+
+		/* Is it so that this very GPIO chip is the parent? */
+		if (irq_parent != np) {
+			of_node_put(irq_parent);
+			continue;
+		}
+		of_node_put(irq_parent);
+
+		pr_debug("gpiochip OF: node reference GPIO interrupt lines\n");
+
+		/* Get the interrupts property */
+		intspec = of_get_property(child, "interrupts", &intlen);
+		if (intspec == NULL)
+			continue;
+		intlen /= sizeof(*intspec);
+
+		num_irq = of_irq_count(np);
+		for (i = 0; i < num_irq; i++) {
+			/*
+			 * The first cell is always the local IRQ number, and
+			 * this corresponds to the GPIO line offset for a GPIO
+			 * chip.
+			 *
+			 * FIXME: take interrupt-cells into account here.
+			 */
+			offset = of_read_number(intspec + i, 1);
+			pr_debug("gpiochip: OF node references offset=%d\n",
+				 offset);
+
+			/*
+			 * This child is making a reference to this chip
+			 * through the interrupts property, so reserve these
+			 * GPIO lines and set them as input.
+			 */
+			ret = gpio_request(gc->base + offset, "OF IRQ");
+			if (ret)
+				pr_err("gpiolib OF: could not request IRQ GPIO %d (%d)\n",
+				       gc->base + offset, offset);
+			ret = gpio_direction_input(gc->base + offset);
+			if (ret)
+				pr_err("gpiolib OF: could not set IRQ GPIO %d (%d) as input\n",
+				       gc->base + offset, offset);
+		}
+
+	}
+
+	of_node_put(root);
+}
+
+/**
  * of_mm_gpiochip_add - Add memory mapped GPIO chip (bank)
  * @np:		device node of the GPIO chip
  * @mm_gc:	pointer to the of_mm_gpio_chip allocated structure
@@ -170,6 +277,8 @@ int of_mm_gpiochip_add(struct device_node *np,
 	if (ret)
 		goto err2;
 
+	of_gpiochip_interrupt_consistency_check(np, gc);
+
 	return 0;
 err2:
 	iounmap(mm_gc->regs);
@@ -231,6 +340,7 @@ void of_gpiochip_add(struct gpio_chip *chip)
 		chip->of_xlate = of_gpio_simple_xlate;
 	}
 
+	of_gpiochip_interrupt_consistency_check(chip->of_node, chip);
 	of_gpiochip_add_pin_range(chip);
 	of_node_get(chip->of_node);
 }
-- 
1.8.1.4

