Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaANO6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:58:41 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:44936 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbaANO6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:58:32 -0500
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH v1 2/5] pinctrl: st: Add Interrupt support.
Date: Tue, 14 Jan 2014 14:52:14 +0000
Message-ID: <1389711134-21049-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
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
 .../devicetree/bindings/pinctrl/pinctrl-st.txt     |   60 +++++-
 drivers/pinctrl/pinctrl-st.c                       |  217 +++++++++++++++++++-
 2 files changed, 270 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
index 05bf82a..4077845 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
@@ -11,18 +11,66 @@ Pull Up (PU) are driven by the related PIO block.
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
+- ranges	: specifies the ranges for the pin controller memory.
+
+Optional properties:
+- interrupts	: Interrupt number of the irqmux. If the interrupt is shared
+  with other gpio banks via irqmux.
+  a irqline and gpio banks.
+- reg		: irqmux memory resource. If irqmux is present.
+- reg-names	: irqmux resource should be named as "irqmux".
+
+GPIO controller node.
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
+       external gpio interrupt space of the controller.
+     - Second Cell: flags to identify the type of the interrupt
+       - 1 = rising edge triggered
+       - 2 = falling edge triggered
+       - 3 = rising and falling edge triggered
+       - 4 = high level triggered
+       - 8 = low level triggered
+
 
 Example:
 	pin-controller-sbc {
diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 320c273..03c0cfd 100644
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
@@ -271,6 +276,8 @@ struct st_gpio_bank {
 	struct pinctrl_gpio_range	range;
 	void __iomem			*base;
 	struct st_pio_control		pc;
+	struct	irq_domain		*domain;
+	int				gpio_irq;
 };
 
 struct st_pinctrl {
@@ -284,6 +291,8 @@ struct st_pinctrl {
 	int				ngroups;
 	struct regmap			*regmap;
 	const struct st_pctl_data	*data;
+	void __iomem			*irqmux_base;
+	int				irqmux_irq;
 };
 
 /* SOC specific data */
@@ -1200,6 +1209,104 @@ static int st_pctl_parse_functions(struct device_node *np,
 	return 0;
 }
 
+static int st_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct st_gpio_bank *bank = gpio_chip_to_bank(chip);
+	int virq;
+
+	if (bank->domain && (offset < chip->ngpio))
+		virq = irq_create_mapping(bank->domain, offset);
+	else
+		virq = -ENXIO;
+
+	dev_info(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
+				chip->label, offset + chip->base, virq);
+	return virq;
+}
+
+static void st_gpio_irq_disable(struct irq_data *d)
+{
+	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+
+	writel(BIT(d->hwirq), bank->base + REG_PIO_CLR_PMASK);
+}
+
+static void st_gpio_irq_enable(struct irq_data *d)
+{
+	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+
+	writel(BIT(d->hwirq), bank->base + REG_PIO_SET_PMASK);
+}
+
+static int st_gpio_irq_set_type(struct irq_data *d, unsigned type)
+{
+	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
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
+	unsigned long port_in, port_mask, port_comp, port_active;
+	int n;
+
+	port_in = readl(bank->base + REG_PIO_PIN);
+	port_comp = readl(bank->base + REG_PIO_PCOMP);
+	port_mask = readl(bank->base + REG_PIO_PMASK);
+
+	port_active = (port_in ^ port_comp) & port_mask;
+
+	for_each_set_bit(n, &port_active, BITS_PER_LONG) {
+		generic_handle_irq(irq_find_mapping(bank->domain, n));
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
@@ -1210,6 +1317,58 @@ static struct gpio_chip st_gpio_template = {
 	.ngpio			= ST_GPIO_PINS_PER_BANK,
 	.of_gpio_n_cells	= 1,
 	.of_xlate		= st_gpio_xlate,
+	.to_irq			= st_gpio_to_irq,
+};
+
+static struct irq_chip st_gpio_irqchip = {
+	.name		= "GPIO",
+	.irq_disable	= st_gpio_irq_disable,
+	.irq_mask	= st_gpio_irq_disable,
+	.irq_unmask	= st_gpio_irq_enable,
+	.irq_set_type	= st_gpio_irq_set_type,
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
+static int st_gpio_irq_domain_xlate(struct irq_domain *d,
+	struct device_node *ctrlr, const u32 *intspec, unsigned int intsize,
+	irq_hw_number_t *out_hwirq, unsigned int *out_type)
+{
+	struct st_gpio_bank *bank = d->host_data;
+	int ret;
+	int pin = bank->gpio_chip.base + intspec[0];
+
+	if (WARN_ON(intsize < 2))
+		return -EINVAL;
+
+	*out_hwirq = intspec[0];
+	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
+
+	ret = gpio_request(pin, ctrlr->full_name);
+	if (ret)
+		return ret;
+
+	ret = gpio_direction_input(pin);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static struct irq_domain_ops st_gpio_irq_ops = {
+	.map	= st_gpio_irq_domain_map,
+	.xlate	= st_gpio_irq_domain_xlate,
 };
 
 static int st_gpiolib_register_bank(struct st_pinctrl *info,
@@ -1219,7 +1378,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 	struct pinctrl_gpio_range *range = &bank->range;
 	struct device *dev = info->dev;
 	int bank_num = of_alias_get_id(np, "gpio");
-	struct resource res;
+	struct resource res, irq_res;
 	int err;
 
 	if (of_address_to_resource(np, 0, &res))
@@ -1248,6 +1407,43 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
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
+		bank->gpio_irq = irq_res.start;
+		irq_set_chained_handler(bank->gpio_irq, st_gpio_irq_handler);
+		irq_set_handler_data(bank->gpio_irq, bank);
+	}
+
+	if (info->irqmux_irq > 0 || bank->gpio_irq > 0) {
+		/* Setup IRQ domain */
+		bank->domain  = irq_domain_add_linear(np,
+						ST_GPIO_PINS_PER_BANK,
+						&st_gpio_irq_ops, bank);
+		if (!bank->domain)
+			dev_err(dev, "Failed to add irq domain for [%s]\n",
+				np->full_name);
+	} else {
+		dev_info(dev, "No IRQ support for [%s] bank\n", np->full_name);
+	}
+
 	return 0;
 }
 
@@ -1276,6 +1472,8 @@ static int st_pctl_probe_dt(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *child;
 	int grp_index = 0;
+	int irq;
+	struct resource *res;
 
 	st_pctl_dt_child_count(info, np);
 	if (!info->nbanks) {
@@ -1306,6 +1504,23 @@ static int st_pctl_probe_dt(struct platform_device *pdev,
 	}
 	info->data = of_match_node(st_pctl_of_match, np)->data;
 
+	irq = platform_get_irq(pdev, 0);
+
+	if (irq > 0) {
+		info->irqmux_irq = irq;
+		res = platform_get_resource_byname(pdev,
+					IORESOURCE_MEM, "irqmux");
+		info->irqmux_base = devm_ioremap_resource(&pdev->dev, res);
+
+		if (IS_ERR(info->irqmux_base))
+			return PTR_ERR(info->irqmux_base);
+
+		irq_set_chained_handler(info->irqmux_irq,
+						st_gpio_irqmux_handler);
+		irq_set_handler_data(info->irqmux_irq, info);
+
+	}
+
 	pctl_desc->npins = info->nbanks * ST_GPIO_PINS_PER_BANK;
 	pdesc =	devm_kzalloc(&pdev->dev,
 			sizeof(*pdesc) * pctl_desc->npins, GFP_KERNEL);
-- 
1.7.6.5

