Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaAPPn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:43:58 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:45790 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbaAPPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:43:50 -0500
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH v2 1/4] pinctrl: st: Add Interrupt support.
Date: Thu, 16 Jan 2014 15:36:53 +0000
Message-ID: <1389886613-31945-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch add interrupt support to the pincontroller driver.

ST Pincontroller GPIO bank can have one of the two possible types of
interrupt-wirings.

First type is via irqmux, single interrupt is used by multiple gpio
banks. This reduces number of overall interrupts numbers required. All
these banks belong to a single pincontroller.
		  _________
		 |	   |----> [gpio-bank (n)    ]
		 |	   |----> [gpio-bank (n + 1)]
	[irqN]-- | irq-mux |----> [gpio-bank (n + 2)]
		 |	   |----> [gpio-bank (...  )]
		 |_________|----> [gpio-bank (n + 7)]

Second type has a dedicated interrupt per gpio bank.

	[irqN]----> [gpio-bank (n)]

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 .../devicetree/bindings/pinctrl/pinctrl-st.txt     |   73 ++++++-
 drivers/pinctrl/pinctrl-st.c                       |  225 +++++++++++++++++++-
 2 files changed, 290 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
index 05bf82a..4bd5be0 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
@@ -11,18 +11,68 @@ Pull Up (PU) are driven by the related PIO block.
 ST pinctrl driver controls PIO multiplexing block and also interacts with
 gpio driver to configure a pin.
 
-Required properties: (PIO multiplexing block)
+GPIO bank can have one of the two possible types of interrupt-wirings.
+
+First type is via irqmux, single interrupt is used by multiple gpio banks. This
+reduces number of overall interrupts numbers required. All these banks belong to
+a single pincontroller.
+		  _________
+		 |	   |----> [gpio-bank (n)    ]
+		 |	   |----> [gpio-bank (n + 1)]
+	[irqN]-- | irq-mux |----> [gpio-bank (n + 2)]
+		 |	   |----> [gpio-bank (...  )]
+		 |_________|----> [gpio-bank (n + 7)]
+
+Second type has a dedicated interrupt per gpio bank.
+
+	[irqN]----> [gpio-bank (n)]
+
+
+Pin controller node:
+Required properties:
 - compatible	: should be "st,<SOC>-<pio-block>-pinctrl"
 	like st,stih415-sbc-pinctrl, st,stih415-front-pinctrl and so on.
-- gpio-controller : Indicates this device is a GPIO controller
-- #gpio-cells	  : Should be one. The first cell is the pin number.
+- st,syscfg		: Should be a phandle of the syscfg node.
 - st,retime-pin-mask	: Should be mask to specify which pins can be retimed.
 	If the property is not present, it is assumed that all the pins in the
 	bank are capable of retiming. Retiming is mainly used to improve the
 	IO timing margins of external synchronous interfaces.
-- st,bank-name		: Should be a name string for this bank as
-			specified in datasheet.
-- st,syscfg		: Should be a phandle of the syscfg node.
+- ranges : defines mapping between pin controller node (parent) to gpio-bank
+  node (children).
+
+Optional properties:
+- interrupts	: Interrupt number of the irqmux. If the interrupt is shared
+  with other gpio banks via irqmux.
+  a irqline and gpio banks.
+- reg		: irqmux memory resource. If irqmux is present.
+- reg-names	: irqmux resource should be named as "irqmux".
+
+GPIO controller/bank node.
+Required properties:
+- gpio-controller : Indicates this device is a GPIO controller
+- #gpio-cells	  : Should be one. The first cell is the pin number.
+- st,bank-name	  : Should be a name string for this bank as specified in
+  datasheet.
+
+Optional properties:
+- interrupts	: Interrupt number for this gpio bank. If there is a dedicated
+  interrupt wired up for this gpio bank.
+
+- interrupt-controller : Indicates this device is a interrupt controller. GPIO
+  bank can be an interrupt controller iff one of the interrupt type either via
+irqmux or a dedicated interrupt per bank is specified.
+
+- #interrupt-cells: the value of this property should be 2.
+     - First Cell: represents the external gpio interrupt number local to the
+       gpio interrupt space of the controller.
+     - Second Cell: flags to identify the type of the interrupt
+       - 1 = rising edge triggered
+       - 2 = falling edge triggered
+       - 3 = rising and falling edge triggered
+       - 4 = high level triggered
+       - 8 = low level triggered
+for related macros look in:
+include/dt-bindings/interrupt-controller/irq.h
 
 Example:
 	pin-controller-sbc {
@@ -30,10 +80,17 @@ Example:
 		#size-cells	= <1>;
 		compatible	= "st,stih415-sbc-pinctrl";
 		st,syscfg	= <&syscfg_sbc>;
+		reg 		= <0xfe61f080 0x4>;
+		reg-names	= "irqmux";
+		interrupts 	= <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts-names = "irqmux";
 		ranges 		= <0 0xfe610000 0x5000>;
+
 		PIO0: gpio@fe610000 {
 			gpio-controller;
 			#gpio-cells	= <1>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 			reg		= <0 0x100>;
 			st,bank-name	= "PIO0";
 		};
@@ -105,6 +162,10 @@ pin-controller {
 
 sdhci0:sdhci@fe810000{
 	...
+	interrupt-parent = <&PIO3>;
+	#interrupt-cells = <2>;
+	interrupts = <3 IRQ_TYPE_LEVEL_HIGH>; /* Interrupt line via PIO3-3 */
+	interrupts-names = "card-detect";
 	pinctrl-names = "default";
 	pinctrl-0	= <&pinctrl_mmc>;
 };
diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 320c273..51e4f3a 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -13,7 +13,12 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
+#include <linux/irqdomain.h>
+#include <linux/irqchip/chained_irq.h>
 #include <linux/of.h>
+#include <linux/of_irq.h>
 #include <linux/of_gpio.h>
 #include <linux/of_address.h>
 #include <linux/regmap.h>
@@ -271,6 +276,7 @@ struct st_gpio_bank {
 	struct pinctrl_gpio_range	range;
 	void __iomem			*base;
 	struct st_pio_control		pc;
+	struct	irq_domain		*domain;
 };
 
 struct st_pinctrl {
@@ -284,6 +290,7 @@ struct st_pinctrl {
 	int				ngroups;
 	struct regmap			*regmap;
 	const struct st_pctl_data	*data;
+	void __iomem			*irqmux_base;
 };
 
 /* SOC specific data */
@@ -1200,6 +1207,130 @@ static int st_pctl_parse_functions(struct device_node *np,
 	return 0;
 }
 
+static int st_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct st_gpio_bank *bank = gpio_chip_to_bank(chip);
+	int irq = -ENXIO;
+
+	if (offset < chip->ngpio)
+		irq = irq_find_mapping(bank->domain, offset);
+
+	dev_info(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
+				chip->label, offset + chip->base, irq);
+	return irq;
+}
+
+static void st_gpio_irq_mask(struct irq_data *d)
+{
+	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+
+	writel(BIT(d->hwirq), bank->base + REG_PIO_CLR_PMASK);
+}
+
+static void st_gpio_irq_unmask(struct irq_data *d)
+{
+	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+
+	writel(BIT(d->hwirq), bank->base + REG_PIO_SET_PMASK);
+}
+
+static unsigned int st_gpio_irq_startup(struct irq_data *d)
+{
+	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+
+	if (gpio_lock_as_irq(&bank->gpio_chip, d->hwirq))
+		dev_err(bank->gpio_chip.dev,
+			"unable to lock HW IRQ %lu for IRQ\n",
+			d->hwirq);
+
+	st_gpio_irq_unmask(d);
+
+	return 0;
+}
+
+static void st_gpio_irq_shutdown(struct irq_data *d)
+{
+	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+
+	st_gpio_irq_mask(d);
+	gpio_unlock_as_irq(&bank->gpio_chip, d->hwirq);
+}
+
+static int st_gpio_irq_set_type(struct irq_data *d, unsigned type)
+{
+	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+	unsigned long flags;
+	int comp, pin = d->hwirq;
+	u32 val;
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		comp = 0;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		comp = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	val = readl(bank->base + REG_PIO_PCOMP);
+	val &= ~BIT(pin);
+	val |= (comp << pin);
+	writel(val, bank->base + REG_PIO_PCOMP);
+
+	return 0;
+}
+
+static void __gpio_irq_handler(struct st_gpio_bank *bank)
+{
+	unsigned long port_in, port_mask, port_comp, active_irqs;
+	int n;
+
+	for (;;) {
+		port_in = readl(bank->base + REG_PIO_PIN);
+		port_comp = readl(bank->base + REG_PIO_PCOMP);
+		port_mask = readl(bank->base + REG_PIO_PMASK);
+
+		active_irqs = (port_in ^ port_comp) & port_mask;
+
+		if (active_irqs == 0)
+			break;
+
+		for_each_set_bit(n, &active_irqs, BITS_PER_LONG) {
+			generic_handle_irq(irq_find_mapping(bank->domain, n));
+		}
+	}
+}
+
+static void st_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	/* interrupt dedicated per bank */
+	struct irq_chip *chip = irq_get_chip(irq);
+	struct st_gpio_bank *bank = irq_get_handler_data(irq);
+
+	chained_irq_enter(chip, desc);
+	__gpio_irq_handler(bank);
+	chained_irq_exit(chip, desc);
+}
+
+static void st_gpio_irqmux_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct irq_chip *chip = irq_get_chip(irq);
+	struct st_pinctrl *info = irq_get_handler_data(irq);
+	unsigned long status;
+	int n;
+
+	chained_irq_enter(chip, desc);
+
+	status = readl(info->irqmux_base);
+
+	for_each_set_bit(n, &status, ST_GPIO_PINS_PER_BANK)
+		__gpio_irq_handler(&info->banks[n]);
+
+	chained_irq_exit(chip, desc);
+}
+
 static struct gpio_chip st_gpio_template = {
 	.request		= st_gpio_request,
 	.free			= st_gpio_free,
@@ -1210,6 +1341,34 @@ static struct gpio_chip st_gpio_template = {
 	.ngpio			= ST_GPIO_PINS_PER_BANK,
 	.of_gpio_n_cells	= 1,
 	.of_xlate		= st_gpio_xlate,
+	.to_irq			= st_gpio_to_irq,
+};
+
+static struct irq_chip st_gpio_irqchip = {
+	.name		= "GPIO",
+	.irq_mask	= st_gpio_irq_mask,
+	.irq_unmask	= st_gpio_irq_unmask,
+	.irq_set_type	= st_gpio_irq_set_type,
+	.irq_startup	= st_gpio_irq_startup,
+	.irq_shutdown	= st_gpio_irq_shutdown,
+};
+
+static int st_gpio_irq_domain_map(struct irq_domain *h,
+			unsigned int virq, irq_hw_number_t hw)
+{
+	struct st_gpio_bank *bank = h->host_data;
+
+	irq_set_chip(virq, &st_gpio_irqchip);
+	irq_set_handler(virq, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID);
+	irq_set_chip_data(virq, bank);
+
+	return 0;
+}
+
+static struct irq_domain_ops st_gpio_irq_ops = {
+	.map	= st_gpio_irq_domain_map,
+	.xlate	= irq_domain_xlate_twocell,
 };
 
 static int st_gpiolib_register_bank(struct st_pinctrl *info,
@@ -1219,8 +1378,8 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 	struct pinctrl_gpio_range *range = &bank->range;
 	struct device *dev = info->dev;
 	int bank_num = of_alias_get_id(np, "gpio");
-	struct resource res;
-	int err;
+	struct resource res, irq_res;
+	int gpio_irq = 0, err, i;
 
 	if (of_address_to_resource(np, 0, &res))
 		return -ENODEV;
@@ -1248,6 +1407,51 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 	}
 	dev_info(dev, "%s bank added.\n", range->name);
 
+	/**
+	 * GPIO bank can have one of the two possible types of
+	 * interrupt-wirings.
+	 *
+	 * First type is via irqmux, single interrupt is used by multiple
+	 * gpio banks. This reduces number of overall interrupts numbers
+	 * required. All these banks belong to a single pincontroller.
+	 *		  _________
+	 *		 |	   |----> [gpio-bank (n)    ]
+	 *		 |	   |----> [gpio-bank (n + 1)]
+	 *	[irqN]-- | irq-mux |----> [gpio-bank (n + 2)]
+	 *		 |	   |----> [gpio-bank (...  )]
+	 *		 |_________|----> [gpio-bank (n + 7)]
+	 *
+	 * Second type has a dedicated interrupt per each gpio bank.
+	 *
+	 *	[irqN]----> [gpio-bank (n)]
+	 */
+
+	if (!of_irq_to_resource(np, 0, &irq_res)) {
+		gpio_irq = irq_res.start;
+		irq_set_chained_handler(gpio_irq, st_gpio_irq_handler);
+		irq_set_handler_data(gpio_irq, bank);
+	}
+
+	if (info->irqmux_base > 0 || gpio_irq > 0) {
+		/* Setup IRQ domain */
+		bank->domain  = irq_domain_add_linear(np,
+						ST_GPIO_PINS_PER_BANK,
+						&st_gpio_irq_ops, bank);
+		if (!bank->domain) {
+			dev_err(dev, "Failed to add irq domain for %s\n",
+				np->full_name);
+		} else  {
+			for (i = 0; i < ST_GPIO_PINS_PER_BANK; i++) {
+				if (irq_create_mapping(bank->domain, i) < 0)
+					dev_err(dev,
+						"Failed to map IRQ %i\n", i);
+			}
+		}
+
+	} else {
+		dev_info(dev, "No IRQ support for %s bank\n", np->full_name);
+	}
+
 	return 0;
 }
 
@@ -1276,6 +1480,8 @@ static int st_pctl_probe_dt(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *child;
 	int grp_index = 0;
+	int irq = 0;
+	struct resource *res;
 
 	st_pctl_dt_child_count(info, np);
 	if (!info->nbanks) {
@@ -1306,6 +1512,21 @@ static int st_pctl_probe_dt(struct platform_device *pdev,
 	}
 	info->data = of_match_node(st_pctl_of_match, np)->data;
 
+	irq = platform_get_irq(pdev, 0);
+
+	if (irq > 0) {
+		res = platform_get_resource_byname(pdev,
+					IORESOURCE_MEM, "irqmux");
+		info->irqmux_base = devm_ioremap_resource(&pdev->dev, res);
+
+		if (IS_ERR(info->irqmux_base))
+			return PTR_ERR(info->irqmux_base);
+
+		irq_set_chained_handler(irq, st_gpio_irqmux_handler);
+		irq_set_handler_data(irq, info);
+
+	}
+
 	pctl_desc->npins = info->nbanks * ST_GPIO_PINS_PER_BANK;
 	pdesc =	devm_kzalloc(&pdev->dev,
 			sizeof(*pdesc) * pctl_desc->npins, GFP_KERNEL);
-- 
1.7.6.5

