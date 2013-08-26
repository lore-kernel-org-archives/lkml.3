Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3HZOHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:07:32 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:60517 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab3HZOHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:07:30 -0400
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: mark.rutland@arm.com, ian.campbell@citrix.com, galak@codeaurora.org,
        pawel.moll@arm.com, tomasz.figa@gmail.com, swarren@wwwdotorg.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
Date: Mon, 26 Aug 2013 16:07:10 +0200
Message-Id: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Currently the kernel is ambigously treating GPIOs and interrupts
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
perform gpio_request() and gpio_direction_input() on these,
making them unreachable from the GPIO side.

The patch has been devised by Linus Walleij and Lars Poeschel.

Changelog V3:
- define of_gpiochip_reserve_irq_lines as empty if
  CONFIG_OF_IRQ is not defined. Walking the devicetree simply
  makes no sense in this case and caused a compile time error
  on SPARC.
- exit of_gpiochip_reserve_irq_lines if no irq_domain can be
  found.
- convert the irqspec to cpu byte order before invoking the
  irq_domains xlate function.

Changelog V2:
- To be able to parse custom interrupts properties from the
  device tree, get a reference to the drivers irq_domain
  and use the xlate function to parse the proptery and
  get the irq number. This is tested with
  #interrupt-cells = 1, 2, and 3 and multiple interrupts
  per property.

Cc: devicetree@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Balaji T K <balajitk@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Jon Hunter <jgchunter@gmail.com>
Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpiolib-of.c |  201 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 200 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 665f953..d328c5d 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -10,7 +10,6 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -19,6 +18,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_gpio.h>
+#include <linux/of_irq.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/slab.h>
 
@@ -126,6 +126,201 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
 }
 EXPORT_SYMBOL(of_gpio_simple_xlate);
 
+#if defined(CONFIG_OF_IRQ)
+/**
+ * of_gpio_scan_irq_lines() - internal function to recursively scan the device
+ * tree and request or free the GPIOs that are to be used as IRQ lines
+ * @node:	node to start the scanning at
+ * @gcn:	device node of the GPIO chip
+ * @irq_domain:	the irq_domain for the GPIO chip
+ * @intsize:	size of one single interrupt in the device tree for the GPIO
+ *		chip. It is the same as #interrupt-cells.
+ * @gc:		GPIO chip instantiated from same node
+ * @request:	wheter the function should request(true) or free(false) the
+ *		irq lines
+ *
+ * This is a internal function that calls itself to recursively scan the device
+ * tree. It scans for uses of the device_node gcn as an interrupt-controller.
+ * If it finds some, it requests the corresponding gpio lines that are to be
+ * used as irq lines and sets them as input.
+ *
+ * If the request parameter is 0 it frees the gpio lines.
+ * For more information see documentation of of_gpiochip_reserve_irq_lines
+ * function.
+ */
+static void of_gpio_scan_irq_lines(const struct device_node *const node,
+				   struct device_node *const gcn,
+				   struct irq_domain *const irq_domain,
+				   const u32 intsize,
+				   const struct gpio_chip * const gc,
+				   bool request)
+{
+	struct device_node *child;
+	struct device_node *irq_parent;
+	const __be32 *intspec;
+	u32 intlen;
+	u32 specifier[OF_MAX_IRQ_SPEC];
+	int ret;
+	int i, j;
+	irq_hw_number_t hwirq;
+	unsigned int type;
+
+	if (node == NULL)
+		return;
+
+	for_each_child_of_node(node, child) {
+		of_gpio_scan_irq_lines(child, gcn, irq_domain, intsize, gc,
+				       request);
+		/* Check if we have an IRQ parent, else continue */
+		irq_parent = of_irq_find_parent(child);
+		if (!irq_parent)
+			continue;
+
+		/* Is it so that this very GPIO chip is the parent? */
+		if (irq_parent != gcn) {
+			of_node_put(irq_parent);
+			continue;
+		}
+		of_node_put(irq_parent);
+
+		pr_debug("gpiochip OF: node %s references GPIO interrupt lines\n",
+				child->name);
+
+		/* Get the interrupts property */
+		intspec = of_get_property(child, "interrupts", &intlen);
+		if (intspec == NULL)
+			continue;
+		intlen /= sizeof(*intspec);
+
+		for (i = 0; i < intlen; i += intsize) {
+			/*
+			 * Find out the local IRQ number. This corresponds to
+			 * the GPIO line offset for a GPIO chip.
+			 */
+			if (irq_domain->ops->xlate) {
+				for (j = 0; j < intsize; j++)
+					specifier[j] = of_read_number(intspec +
+								i + j, 1);
+				irq_domain->ops->xlate(irq_domain, gcn,
+						       specifier, intsize,
+						       &hwirq, &type);
+			} else
+				hwirq = be32_to_cpu(intspec[0]);
+
+			pr_debug("gpiochip OF: node %s references GPIO %lu (%lu)\n",
+				child->name, gc->base + hwirq, hwirq);
+
+			if (request) {
+				/*
+				 * This child is making a reference to this
+				 * chip through the interrupts property, so
+				 * reserve these GPIO lines and set them as
+				 * input.
+				 */
+				ret = gpio_request(gc->base + hwirq,
+						   child->name);
+				if (ret)
+					pr_err("gpiolib OF: could not request IRQ GPIO %lu (%lu) for node %s (%d)\n",
+						gc->base + hwirq, hwirq,
+						child->name, ret);
+				ret = gpio_direction_input(gc->base + hwirq);
+				if (ret)
+					pr_err("gpiolib OF: could not set IRQ GPIO %lu (%lu) as input for node %s (%d)\n",
+						gc->base + hwirq, hwirq,
+						child->name, ret);
+			} else {
+				gpio_free(gc->base + hwirq);
+			}
+		}
+	}
+}
+
+/**
+ * of_gpiochip_reserve_irq_lines() - request or free GPIO IRQ lines
+ * @np:		device node of the GPIO chip
+ * @gc:		GPIO chip instantiated from same node
+ * @request:	wheter the function should request(1) or free(0) the irq lines
+ *
+ * This function should not be used directly, use the macros
+ * of_gpiochip_request_irq_lines or of_gpiochip_free_gpio_lines instead.
+ *
+ * For the case of requesting the irq lines (request == 1) this function is
+ * called after instantiating a GPIO chip from a device tree node to assert
+ * that all interrupts derived from the chip are consistently requested as
+ * GPIO lines, if the GPIO chip is BOTH a gpio-controller AND an
+ * interrupt-controller.
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
+ *
+ * For the case of freeing the irq lines (request == 0) this function simply
+ * uses the same device tree information used to request the irq lines to call
+ * gpiochip_free on that GPIOs.
+ */
+static void of_gpiochip_reserve_irq_lines(struct device_node *np,
+					  struct gpio_chip *gc, bool request)
+{
+	struct device_node *root;
+	const __be32 *tmp;
+	struct irq_domain *irq_domain;
+	u32 intsize;
+
+	/*
+	 * If this chip is not tagged as interrupt-controller, there is
+	 * no problem so we just exit.
+	 */
+	if (!of_property_read_bool(np, "interrupt-controller"))
+		return;
+
+	/*
+	 * Proceed to check the consistency of all references to this
+	 * GPIO chip.
+	 */
+	root = of_find_node_by_path("/");
+	if (!root)
+		return;
+
+	tmp = of_get_property(np, "#interrupt-cells", NULL);
+	if (tmp == NULL)
+		intsize = 1;
+	else
+		intsize = be32_to_cpu(*tmp);
+
+	irq_domain = irq_find_host(np);
+	if (irq_domain == NULL) {
+		dev_err(gc->dev, "Unable to find a irq_domain, aborting to request gpios for interrupts used from combined gpio-/interrupt-controllers\n");
+		goto err;
+	}
+
+	of_gpio_scan_irq_lines(root, np, irq_domain, intsize, gc, request);
+err:
+	of_node_put(root);
+}
+#else
+static void of_gpiochip_reserve_irq_lines(struct device_node *np,
+					  struct gpio_chip *gc, bool request)
+{
+	return;
+}
+#endif /* defined(CONFIG_OF_IRQ) */
+
+#define of_gpiochip_request_irq_lines(np, gc) \
+	of_gpiochip_reserve_irq_lines(np, gc, true)
+
+#define of_gpiochip_free_irq_lines(np, gc) \
+	of_gpiochip_reserve_irq_lines(np, gc, false)
+
 /**
  * of_mm_gpiochip_add - Add memory mapped GPIO chip (bank)
  * @np:		device node of the GPIO chip
@@ -170,6 +365,8 @@ int of_mm_gpiochip_add(struct device_node *np,
 	if (ret)
 		goto err2;
 
+	of_gpiochip_request_irq_lines(np, gc);
+
 	return 0;
 err2:
 	iounmap(mm_gc->regs);
@@ -231,12 +428,14 @@ void of_gpiochip_add(struct gpio_chip *chip)
 		chip->of_xlate = of_gpio_simple_xlate;
 	}
 
+	of_gpiochip_request_irq_lines(chip->of_node, chip);
 	of_gpiochip_add_pin_range(chip);
 	of_node_get(chip->of_node);
 }
 
 void of_gpiochip_remove(struct gpio_chip *chip)
 {
+	of_gpiochip_free_irq_lines(chip->of_node, chip);
 	gpiochip_remove_pin_ranges(chip);
 
 	if (chip->of_node)
-- 
1.7.10.4

