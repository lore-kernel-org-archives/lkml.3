Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3H2PP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:15:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34984 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3H2PPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:15:25 -0400
From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "Enric Balletbo i Serra" <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: RE: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
Thread-Topic: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
Thread-Index: AQHOomWc4rH2D5GBkUe2TDCS4blGVJmsOg7g
Date: Thu, 29 Aug 2013 15:14:58 +0000
Message-ID: <902E09E6452B0E43903E4F2D568737AB35B65D@DNCE04.ent.ti.com>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
In-Reply-To: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.42]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars, Linus,

I've few comments regarding this patch and problem in general.

On 08/26/2013 05:07 PM, Lars Poeschel wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> Currently the kernel is ambigously treating GPIOs and interrupts
> from a GPIO controller: GPIOs and interrupts are treated as
> orthogonal. This unfortunately makes it unclear how to actually
> retrieve and request a GPIO line or interrupt from a GPIO
> controller in the device tree probe path.
>
> In the non-DT probe path it is clear that the GPIO number has to
> be passed to the consuming device, and if it is to be used as
> an interrupt, the consumer shall performa a gpio_to_irq() mapping
> and request the resulting IRQ number.
>
> In the DT boot path consumers may have been given one or more
> interrupts from the interrupt-controller side of the GPIO chip
> in an abstract way, such that the driver is not aware of the
> fact that a GPIO chip is backing this interrupt, and the GPIO
> side of the same line is never requested with gpio_request().
> A typical case for this is ethernet chips which just take some
> interrupt line which may be a "hard" interrupt line (such as an
> external interrupt line from an SoC) or a cascaded interrupt
> connected to a GPIO line.
>
> This has the following undesired effects:
>
> - The GPIOlib subsystem is not aware that the line is in use
>    and willingly lets some other consumer perform gpio_request()
>    on it, leading to a complex resource conflict if it occurs.
>
> - The GPIO debugfs file claims this GPIO line is "free".
>
> - The line direction of the interrupt GPIO line is not
>    explicitly set as input, even though it is obvious that such
>    a line need to be set up in this way, often making the system
>    depend on boot-on defaults for this kind of settings.
>
> To solve this dilemma, perform an interrupt consistency check
> when adding a GPIO chip: if the chip is both gpio-controller and
> interrupt-controller, walk all children of the device tree,
> check if these in turn reference the interrupt-controller, and
> if they do, loop over the interrupts used by that child and
> perform gpio_request() and gpio_direction_input() on these,
> making them unreachable from the GPIO side.
>
> The patch has been devised by Linus Walleij and Lars Poeschel.
>
> Changelog V3:
> - define of_gpiochip_reserve_irq_lines as empty if
>    CONFIG_OF_IRQ is not defined. Walking the devicetree simply
>    makes no sense in this case and caused a compile time error
>    on SPARC.
> - exit of_gpiochip_reserve_irq_lines if no irq_domain can be
>    found.
> - convert the irqspec to cpu byte order before invoking the
>    irq_domains xlate function.
>
> Changelog V2:
> - To be able to parse custom interrupts properties from the
>    device tree, get a reference to the drivers irq_domain
>    and use the xlate function to parse the proptery and
>    get the irq number. This is tested with
>    #interrupt-cells = 1, 2, and 3 and multiple interrupts
>    per property.
>
> Cc: devicetree@vger.kernel.org
> Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: Enric Balletbo i Serra <eballetbo@gmail.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Jon Hunter <jgchunter@gmail.com>
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>   drivers/gpio/gpiolib-of.c |  201 ++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 200 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index 665f953..d328c5d 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -10,7 +10,6 @@
>    * the Free Software Foundation; either version 2 of the License, or
>    * (at your option) any later version.
>    */
> -
>   #include <linux/device.h>
>   #include <linux/errno.h>
>   #include <linux/module.h>
> @@ -19,6 +18,7 @@
>   #include <linux/of.h>
>   #include <linux/of_address.h>
>   #include <linux/of_gpio.h>
> +#include <linux/of_irq.h>
>   #include <linux/pinctrl/pinctrl.h>
>   #include <linux/slab.h>
>
> @@ -126,6 +126,201 @@ int of_gpio_simple_xlate(struct gpio_chip *gc,
>   }
>   EXPORT_SYMBOL(of_gpio_simple_xlate);
>
> +#if defined(CONFIG_OF_IRQ)
> +/**
> + * of_gpio_scan_irq_lines() - internal function to recursively scan the device
> + * tree and request or free the GPIOs that are to be used as IRQ lines
> + * @node:	node to start the scanning at
> + * @gcn:	device node of the GPIO chip
> + * @irq_domain:	the irq_domain for the GPIO chip
> + * @intsize:	size of one single interrupt in the device tree for the GPIO
> + *		chip. It is the same as #interrupt-cells.
> + * @gc:		GPIO chip instantiated from same node
> + * @request:	wheter the function should request(true) or free(false) the
> + *		irq lines
> + *
> + * This is a internal function that calls itself to recursively scan the device
> + * tree. It scans for uses of the device_node gcn as an interrupt-controller.
> + * If it finds some, it requests the corresponding gpio lines that are to be
> + * used as irq lines and sets them as input.
> + *
> + * If the request parameter is 0 it frees the gpio lines.
> + * For more information see documentation of of_gpiochip_reserve_irq_lines
> + * function.
> + */
> +static void of_gpio_scan_irq_lines(const struct device_node *const node,
> +				   struct device_node *const gcn,
> +				   struct irq_domain *const irq_domain,
> +				   const u32 intsize,
> +				   const struct gpio_chip * const gc,
> +				   bool request)
> +{
> +	struct device_node *child;
> +	struct device_node *irq_parent;
> +	const __be32 *intspec;
> +	u32 intlen;
> +	u32 specifier[OF_MAX_IRQ_SPEC];
> +	int ret;
> +	int i, j;
> +	irq_hw_number_t hwirq;
> +	unsigned int type;
> +
> +	if (node == NULL)
> +		return;
> +
> +	for_each_child_of_node(node, child) {


p1) for_each_child_of_node will traverse all the child nodes
independently of whether the node is available or not. As result, GPIO
line may be requested for disabled nodes (status="disabled")

p2) If any child of complex devices, such MFD, will use GPIO line as IRQ, then corresponding GPIO line will always be requested.
BUT - the MFD driver may not be loaded at all, so there will be "GPIO leak" which will affect on power consumption (GPIO bank will not be switched to idle state).

p3) Would it be allowed to use shared GPIO IRQs after this patch?

p4) Who/When will free GPIO line? This question is not about GPIO chip removing/unloading -
It's about unloading GPIO chip consumers: loadable
drivers (especially MFD devices) and such feature as DT-overlays.
( Looks like "Release resources assigned by DT-core/DT-helpers" is
common problem.
For example, similar problem with IRQ descriptors:
irq_dispose_mapping() is not called for IRQs, which were allocated/mapped by
 DT-core from irq_of_parse_and_map().
 So, there is no simple way to free IRQ-descriptors in case if MFD is unloaded
 and, at the same time, It is IRQ controller and uses linear irq_domain.)

> +		of_gpio_scan_irq_lines(child, gcn, irq_domain, intsize, gc,
> +				       request);
> +		/* Check if we have an IRQ parent, else continue */
> +		irq_parent = of_irq_find_parent(child);
> +		if (!irq_parent)
> +			continue;
> +
> +		/* Is it so that this very GPIO chip is the parent? */
> +		if (irq_parent != gcn) {
> +			of_node_put(irq_parent);
> +			continue;
> +		}
> +		of_node_put(irq_parent);
> +
> +		pr_debug("gpiochip OF: node %s references GPIO interrupt lines\n",
> +				child->name);
> +
> +		/* Get the interrupts property */
> +		intspec = of_get_property(child, "interrupts", &intlen);
> +		if (intspec == NULL)
> +			continue;
> +		intlen /= sizeof(*intspec);
> +
> +		for (i = 0; i < intlen; i += intsize) {
> +			/*
> +			 * Find out the local IRQ number. This corresponds to
> +			 * the GPIO line offset for a GPIO chip.
> +			 */
> +			if (irq_domain->ops->xlate) {
> +				for (j = 0; j < intsize; j++)
> +					specifier[j] = of_read_number(intspec +
> +								i + j, 1);
> +				irq_domain->ops->xlate(irq_domain, gcn,
> +						       specifier, intsize,
> +						       &hwirq, &type);
> +			} else
> +				hwirq = be32_to_cpu(intspec[0]);
> +
> +			pr_debug("gpiochip OF: node %s references GPIO %lu (%lu)\n",
> +				child->name, gc->base + hwirq, hwirq);
> +
> +			if (request) {
> +				/*
> +				 * This child is making a reference to this
> +				 * chip through the interrupts property, so
> +				 * reserve these GPIO lines and set them as
> +				 * input.
> +				 */
> +				ret = gpio_request(gc->base + hwirq,
> +						   child->name);
> +				if (ret)
> +					pr_err("gpiolib OF: could not request IRQ GPIO %lu (%lu) for node %s (%d)\n",
> +						gc->base + hwirq, hwirq,
> +						child->name, ret);
> +				ret = gpio_direction_input(gc->base + hwirq);
> +				if (ret)
> +					pr_err("gpiolib OF: could not set IRQ GPIO %lu (%lu) as input for node %s (%d)\n",
> +						gc->base + hwirq, hwirq,
> +						child->name, ret);

gpio_request_one

> +			} else {
> +				gpio_free(gc->base + hwirq);
> +			}
> +		}
> +	}

[...]

> +}
>   /**
>    * of_mm_gpiochip_add - Add memory mapped GPIO chip (bank)
>    * @np:		device node of the GPIO chip
> @@ -170,6 +365,8 @@ int of_mm_gpiochip_add(struct device_node *np,
>   	if (ret)
>   		goto err2;
>

p5) Most of GPIO chip implementations use simple call to gpiochip_add
and not of_mm_gpiochip_add - at least gpio-omap.c (which is important
for me:)

> +	of_gpiochip_request_irq_lines(np, gc);
> +
>   	return 0;
>   err2:
>   	iounmap(mm_gc->regs);
> @@ -231,12 +428,14 @@ void of_gpiochip_add(struct gpio_chip *chip)
>   		chip->of_xlate = of_gpio_simple_xlate;
>   	}
>
> +	of_gpiochip_request_irq_lines(chip->of_node, chip);
>   	of_gpiochip_add_pin_range(chip);
>   	of_node_get(chip->of_node);
>   }
>
>   void of_gpiochip_remove(struct gpio_chip *chip)
>   {
> +	of_gpiochip_free_irq_lines(chip->of_node, chip);
>   	gpiochip_remove_pin_ranges(chip);
>
>   	if (chip->of_node)
>

I think there are two major problems (at least about IRQs, but seems
the same is valid for DMA too):
1) Data duplication
- from one side DT has all needed information about HW resources
- from other side, the same data maintained using "struct resource" per
device
  Such duplication should definitely be removed and all data should be
taken from DT (if DT is the future of course:))).

2) DT-core/helpers - performs actions on HW resources which they
shouldn't do, i think (like IRQ mapping&descriptors allocation, GPIO
request and etc.). Instead all these stuff should be done/initiated by
drivers when (and only when) they are going to request&use HW resource.

[v1]
According, to explained above, I thought, that it would be reasonable
to move IRQ parsing&mapping code inside platform_get_xxx() helpers and
and corresponding code for GPIO requesting inside irq_of_parse_and_map() -
so, any manipulation with IRQ resources will by performed only by request
form drivers (this solves [p1] & [p2] & [p5]).
[to prove this concept I've created patch -
 dirty version attached below, boot tested on OMAP4 SDP, based on v3.11-rc6]

In addition, I tried to use "devres" API for GPIO requesting (this was my goal to solve [p4]) -
but I stuck with the problem of getting pointer on device which requests IRQ
and got problem with frameworks like SPI & I2C which use
irq_of_parse_and_map() directly before calling the device_add().

[v2]
A result, I think, that the best way to handle IRQ resources
configuration will be from request_threaded_irq():
- create "of" equivalents for request_irq()/request_threaded_irq()/
/devm_request_threaded_irq()/devm_request_irq()
- switch drivers to use them and finally get rid of IORESOURCE_IRQ type at all.

To solve [p3], IRQF_SHARED need to be populated through DT per IRQ
somehow, and GPIO should be requested only once.
Or "gpio-reset"/"fixed-regulator" could be used in DT for such GPIOs and
GPIO shouldn't never be requested by "of_irq" code if IRQF_SHARED
is specified for some IRQ.

Of course, I could miss smth, because my investigation is based on ARM OMAP2 code only.

Regards,
-grygorii

---
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3c3197a..68dcb15 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -22,7 +22,8 @@
 #include <linux/pm_runtime.h>
 #include <linux/idr.h>
 #include <linux/acpi.h>
-
+#include <linux/of_irq.h>
+#include <linux/gpio.h>
 #include "base.h"
 #include "power/power.h"

@@ -64,6 +65,19 @@ struct resource *platform_get_resource(struct platform_device *dev,
 {
 	int i;

+#ifdef CONFIG_OF
+	if (IORESOURCE_IRQ == (type & IORESOURCE_TYPE_BITS)) {
+		struct resource	 *r_irq;
+
+		r_irq = devm_kzalloc(&dev->dev, sizeof(*r_irq), GFP_KERNEL);
+		if (r_irq) {
+			if (!of_irq_to_resource(dev->dev.of_node, num, r_irq))
+				return NULL;
+		}
+		return r_irq;
+	}
+#endif
+
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];

@@ -87,9 +101,13 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
 		return -ENXIO;
 	return dev->archdata.irqs[num];
 #else
+#ifndef CONFIG_OF
 	struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);

 	return r ? r->start : -ENXIO;
+#else
+	return irq_of_parse_and_map(dev->dev.of_node, num);
+#endif
 #endif
 }
 EXPORT_SYMBOL_GPL(platform_get_irq);
@@ -105,7 +123,18 @@ struct resource *platform_get_resource_byname(struct platform_device *dev,
 					      const char *name)
 {
 	int i;
-
+#ifdef CONFIG_OF
+	const char *name_irq = NULL;
+	int index = 0;
+
+	if (IORESOURCE_IRQ == (type & IORESOURCE_TYPE_BITS))
+		while (!of_property_read_string_index(dev->dev.of_node,
+			"interrupt-names", index, &name_irq)) {
+			if (!strcmp(name, name_irq)) {
+				return platform_get_resource(dev, type, index);
+			}
+		}
+#endif
 	for (i = 0; i < dev->num_resources; i++) {
 		struct resource *r = &dev->resource[i];

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 1264923..91f3330 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -25,7 +25,19 @@
 #include <linux/of_irq.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/of_platform.h>

+
+static int irq_of_gpiochip_find(struct gpio_chip *gc, void *data)
+{
+	struct device_node *np = data;
+
+	if (gc->of_node != np)
+		return false;
+
+	return true;
+}
 /**
  * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
  * @device: Device node of the device whose interrupt is to be mapped
@@ -37,12 +49,57 @@
 unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 {
 	struct of_irq oirq;
+	unsigned int virq;
+	irq_hw_number_t hwirq;
+	unsigned int type = IRQ_TYPE_NONE;

 	if (of_irq_map_one(dev, index, &oirq))
 		return 0;

-	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
+				     oirq.size, &hwirq, &type);
+	if (!virq)
+		return virq;
+
+	if (of_property_read_bool(oirq.controller, "gpio-controller")) {
+		struct gpio_chip *gc;
+		struct irq_domain *domain;
+		int ret;
+		struct platform_device *pdev;
+		pr_err("========= GPIO-IRQ %s %ul->%u\n", oirq.controller->name, (unsigned int)hwirq, virq);
+
+		domain = irq_find_host(oirq.controller);
+		if (!domain) {
+			pr_err("======= could not find IRQ domain for GPIO chip\n");
+			return 0;
+		}
+
+		gc = gpiochip_find(oirq.controller, irq_of_gpiochip_find);
+		if (!gc) {
+			pr_err("======= could not find GPIO chip\n");
+			return 0;
+		}
+
+/*		pdev = of_find_device_by_node(dev);
+		if (!pdev) {
+			pr_err("======= could not find pdev %s\n", dev->name);
+			return 0;
+		} else {
+			ret = devm_gpio_request_one(&pdev->dev,
+				    gc->base + hwirq, GPIOF_DIR_IN, dev->name);
+		}*/
+		ret = gpio_request_one(gc->base + hwirq, GPIOF_DIR_IN, dev->name);
+		if (ret)
+			pr_err("======= could not request IRQ GPIO %lu (%u) for node %s (%d)\n",
+			       gc->base + hwirq, (unsigned int)hwirq, dev->name, ret);
+	}
+
+	/* Set type if specified and different than the current one */
+	if (type != IRQ_TYPE_NONE &&
+	    type != irq_get_trigger_type(virq))
+		irq_set_irq_type(virq, type);
+
+	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index e0a6514..c685fce 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -168,7 +168,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 			rc = of_address_to_resource(np, i, res);
 			WARN_ON(rc);
 		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+		//WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
 	}

 	dev->dev.of_node = of_node_get(np);
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 535cecf..8e50653 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -65,7 +65,9 @@ extern int of_irq_map_one(struct device_node *device, int index,
 			  struct of_irq *out_irq);
 extern unsigned int irq_create_of_mapping(struct device_node *controller,
 					  const u32 *intspec,
-					  unsigned int intsize);
+					  unsigned int intsize,
+					  irq_hw_number_t *hwirq,
+					  unsigned int *type);
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
 extern int of_irq_count(struct device_node *dev);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 706724e..ff0d26d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -466,11 +466,10 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
 EXPORT_SYMBOL_GPL(irq_create_strict_mappings);

 unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
+				   const u32 *intspec, unsigned int intsize,
+				   irq_hw_number_t *hwirq, unsigned int *type)
 {
 	struct irq_domain *domain;
-	irq_hw_number_t hwirq;
-	unsigned int type = IRQ_TYPE_NONE;
 	unsigned int virq;

 	domain = controller ? irq_find_host(controller) : irq_default_domain;
@@ -482,22 +481,16 @@ unsigned int irq_create_of_mapping(struct device_node *controller,

 	/* If domain has no translation, then we assume interrupt line */
 	if (domain->ops->xlate == NULL)
-		hwirq = intspec[0];
+		*hwirq = intspec[0];
 	else {
 		if (domain->ops->xlate(domain, controller, intspec, intsize,
-				     &hwirq, &type))
+				       hwirq, type))
 			return 0;
 	}

 	/* Create mapping */
-	virq = irq_create_mapping(domain, hwirq);
-	if (!virq)
-		return virq;
+	virq = irq_create_mapping(domain, *hwirq);

-	/* Set type if specified and different than the current one */
-	if (type != IRQ_TYPE_NONE &&
-	    type != irq_get_trigger_type(virq))
-		irq_set_irq_type(virq, type);
 	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);








