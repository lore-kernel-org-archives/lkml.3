Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3KGMdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:33:36 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34297 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3KGMdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:33:31 -0500
Message-ID: <527B8895.3050305@gmail.com>
Date: Thu, 07 Nov 2013 13:33:25 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Alan Tull <delicious.quinoa@gmail.com>, linux-kernel@vger.kernel.org
CC: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>, Heiko Stuebner <heiko@sntech.de>,
        Alan Tull <atull@altera.com>, Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH 1/1] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
References: <1383778182-16941-1-git-send-email-delicious.quinoa@gmail.com> <1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com>
In-Reply-To: <1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/13 23:49, Alan Tull wrote:
> From: Jamie Iles <jamie@jamieiles.com>
>
> The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> and can be configured to provide multiple banks of GPIO pins.
>
> Signed-off-by: Alan Tull <atull@altera.com>
>
> v6:	- (atull) squash the set of patches

Much better to review, thanks.

[...]
> diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
> new file mode 100644
> index 0000000..f7e2076
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
> @@ -0,0 +1,57 @@
> +* Synopsys DesignWare APB GPIO controller
> +
> +Required properties:
> +- compatible : Should be "snps,dw-apb-gpio"
> +- reg : Address and length of the register set for the device
> +
> +The GPIO controller has a configurable number of banks, each of which are
> +represented as child nodes with the following properties:

still, s/bank/port/g

> +Required properties:
> +- compatible : "snps,dw-apb-gpio-bank"

should be "snps,dw-apb-gpio-port" then. If someone badly needs
"snps,dw-apb-gpio-bank", I suggest to mark it as DEPRECATED.

> +- gpio-controller : Marks the device node as a gpio controller.
> +- #gpio-cells : Should be two.  The first cell is the pin number and
> +  the second cell is used to specify optional parameters (currently
> +  unused).
> +- reg : The integer bank index of the bank, a single cell.
> +- nr-gpios : The number of pins in the bank, a single cell.

Missed that one, must have vendor-specific prefix, i.e. snps,nr-gpios.
Also, if you leave this property as required, there is no way for those
IP with CONFIG registers to not use it. Please, make it optional.

> +Optional properties:
> +- interrupt-controller : The first bank may be configured to be an interrupt
> +controller.

s/bank/port/

> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +interrupt.  Shall be set to 2.  The first cell defines the interrupt number,
> +the second encodes the triger flags encoded as described in
> +Documentation/devicetree/bindings/interrupts.txt
> +- interrupt-parent : The parent interrupt controller.
> +- interrupts : The interrupts to the parent controller raised when GPIOs
> +generate the interrupts.

Right, here you correctly say that there may be more than just one
upstream irq.

> +Example:
> +
> +gpio: gpio@20000 {
> +	compatible = "snps,dw-apb-gpio";
> +	reg = <0x20000 0x1000>;
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	banka: gpio-controller@0 {
> +		compatible = "snps,dw-apb-gpio-bank";
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		nr-gpio = <8>;
> +		reg = <0>;
> +		interrupt-controller;
> +		#interrupt-cells = <2>;
> +		interrupt-parent = <&vic1>;
> +		interrupts = <0 1 2 3 4 5 6 7>;
> +	};
> +
> +	bankb: gpio-controller@1 {
> +		compatible = "snps,dw-apb-gpio-bank";
> +		gpio-controller;
> +		#gpio-cells = <2>;
> +		nr-gpio = <8>;
> +		reg = <1>;
> +	};

s/bank/port/


BTW, what if we get rid of port child nodes completely and rather
use:

gpio: gpio-controller@20000 {
	compatible = "snps,dw-apb-gpio";
	reg = <0x20000 0x1000>;
	gpio-controller;
	#gpio-cells = <2>;
	interrupt-controller;
	interrupt-parent = <&vic1>;
	interrupts = <0 1 2 3 4 5 6 7>;
	snps,port-widths = <8 8 0 0>;
};

The only draw-back compared to child-nodes is, that you'll reference
gpios with <&gpio 13> instead of <&banka 5>. I have no strong opinion
about it, so I leave the correct answer to either LinusW or DT
maintainers.

[...]
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> new file mode 100644
> index 0000000..7957dfd
> --- /dev/null
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -0,0 +1,458 @@
> +/*
> + * Copyright (c) 2011 Jamie Iles
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * All enquiries to support@picochip.com
> + */
> +#include <linux/basic_mmio_gpio.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +
> +#define GPIO_SWPORTA_DR		0x00
> +#define GPIO_SWPORTA_DDR	0x04
> +#define GPIO_SWPORTB_DR		0x0c
> +#define GPIO_SWPORTB_DDR	0x10
> +#define GPIO_SWPORTC_DR		0x18
> +#define GPIO_SWPORTC_DDR	0x1c
> +#define GPIO_SWPORTD_DR		0x24
> +#define GPIO_SWPORTD_DDR	0x28
> +#define GPIO_INTEN		0x30
> +#define GPIO_INTMASK		0x34
> +#define GPIO_INTTYPE_LEVEL	0x38
> +#define GPIO_INT_POLARITY	0x3c
> +#define GPIO_INTSTATUS		0x40
> +#define GPIO_PORTA_EOI		0x4c
> +#define GPIO_EXT_PORTA		0x50
> +#define GPIO_EXT_PORTB		0x54
> +#define GPIO_EXT_PORTC		0x58
> +#define GPIO_EXT_PORTD		0x5c
> +
> +struct dwapb_gpio;
> +
> +struct dwapb_gpio_port {
> +	struct bgpio_chip	bgc;
> +	bool			is_registered;

if you make *ports an array of 4 below, you can get rid
of that awkward is_registered. On top of that, with only
struct bgpio_chip and the pointer back to dwapb_gpio you
can get rid of struct dwapb_gpio_port completely.

> +	struct dwapb_gpio	*gpio;
> +};
> +
> +struct dwapb_gpio {
> +	struct	device		*dev;
> +	void __iomem		*regs;
> +	struct dwapb_gpio_port	*ports;

#define DWAPB_MAX_PORTS	4

	struct bgpio_chip port_bgc[DWAPB_MAXPORTS];

> +	unsigned int		nr_ports;
> +	struct irq_domain	*domain;
> +	int			hwirq;

As said earlier, hwirq is actually virq. As you'll possibly have
to request more than one upstream irq and irqdomain API requires you
to dispose the mapping before removing, I suggest to remove any
upstream reference from the above struct and use irq_find_mapping()
get the virq to dispose (example below).

> +};
> +
> +static unsigned int dwapb_gpio_nr_ports(struct device_node *of_node)
> +{
> +	unsigned int nr_ports = 0;
> +	struct device_node *np;
> +
> +	for_each_child_of_node(of_node, np)
> +		++nr_ports;
> +
> +	return nr_ports;
> +}
> +
> +static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +	struct dwapb_gpio_port *port = container_of(bgc, struct
> +						    dwapb_gpio_port, bgc);
> +	struct dwapb_gpio *gpio = port->gpio;
> +
> +	return irq_create_mapping(gpio->domain, offset);
> +}
> +
> +static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
> +{
> +	u32 v = readl(gpio->regs + GPIO_INT_POLARITY);
> +
> +	if (gpio_get_value(gpio->ports[0].bgc.gc.base + offs))
> +		v &= ~BIT(offs);
> +	else
> +		v |= BIT(offs);
> +
> +	writel(v, gpio->regs + GPIO_INT_POLARITY);
> +}
> +
> +static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
> +{
> +	struct dwapb_gpio *gpio = irq_get_handler_data(irq);
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	u32 irq_status = readl(gpio->regs + GPIO_INTSTATUS);
> +
> +	while (irq_status) {
> +		int irqoffset = fls(irq_status) - 1;
> +		int gpio_irq = irq_linear_revmap(gpio->domain, irqoffset);
> +		u32 irq_type = irq_get_trigger_type(gpio_irq);
> +
> +		generic_handle_irq(gpio_irq);
> +		irq_status &= ~(1 << irqoffset);

BIT(irqoffset) as above?

> +
> +		if ((irq_type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
> +			dwapb_toggle_trigger(gpio, irqoffset);
> +	}

If you use irq_chip_generic, the whole handler can be written as:

static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
{
	struct irq_domain *d = irq_get_handler_data(irq);
	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
	u32 irqstatus = readl_relaxed(gc->reg_base + GPIO_INTSTATUS) &
		gc->mask_cache;

	while (irqstatus) {
		u32 hwirq = fls(irqstatus) - 1;
		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
		irqstatus &= ~BIT(hwirq);

		if ((irq_get_trigger_type(irq) & IRQ_TYPE_SENSE_MASK)
				== IRQ_TYPE_EDGE_BOTH)
			dwapb_toggle_trigger(gpio, hwirq);
	}
}

> +
> +	if (chip->irq_eoi)
> +		chip->irq_eoi(irq_desc_get_irq_data(desc));
> +}
> +
> +static void dwapb_irq_enable(struct irq_data *d)
> +{
> +	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
> +	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	val = readl(gpio->regs + GPIO_INTEN);
> +	val |= 1 << d->hwirq;

BIT(d->hwirq) ?

> +	writel(val, gpio->regs + GPIO_INTEN);
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +}
> +
> +static void dwapb_irq_disable(struct irq_data *d)
> +{
> +	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
> +	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	val = readl(gpio->regs + GPIO_INTEN);
> +	val &= ~(1 << d->hwirq);

ditto.

> +	writel(val, gpio->regs + GPIO_INTEN);
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +}
> +
> +static int dwapb_irq_set_type(struct irq_data *d, u32 type)
> +{
> +	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
> +	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
> +	int bit = d->hwirq;
> +	unsigned long level, polarity, flags;
> +
> +	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
> +		     IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	level = readl(gpio->regs + GPIO_INTTYPE_LEVEL);
> +	polarity = readl(gpio->regs + GPIO_INT_POLARITY);
> +
> +	switch (type) {
> +	case IRQ_TYPE_EDGE_BOTH:
> +		level |= (1 << bit);
> +		dwapb_toggle_trigger(gpio, bit);
> +		break;
> +	case IRQ_TYPE_EDGE_RISING:
> +		level |= (1 << bit);
> +		polarity |= (1 << bit);
> +		break;
> +	case IRQ_TYPE_EDGE_FALLING:
> +		level |= (1 << bit);
> +		polarity &= ~(1 << bit);
> +		break;
> +	case IRQ_TYPE_LEVEL_HIGH:
> +		level &= ~(1 << bit);
> +		polarity |= (1 << bit);
> +		break;
> +	case IRQ_TYPE_LEVEL_LOW:
> +		level &= ~(1 << bit);
> +		polarity &= ~(1 << bit);

ditto for all above and below.

> +		break;
> +	}
> +
> +	writel(level, gpio->regs + GPIO_INTTYPE_LEVEL);
> +	writel(polarity, gpio->regs + GPIO_INT_POLARITY);
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +
> +	return 0;
> +}
> +
> +static void dwapb_irq_ack(struct irq_data *d)
> +{
> +	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
> +	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	writel(1 << d->hwirq, gpio->regs + GPIO_PORTA_EOI);
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +}
> +
> +static void dwapb_irq_mask(struct irq_data *d)
> +{
> +	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
> +	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
> +	unsigned long value, flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	value = readl(gpio->regs + GPIO_INTMASK);
> +	value |= 1 << d->hwirq;
> +	writel(value, gpio->regs + GPIO_INTMASK);
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +}
> +
> +static void dwapb_irq_unmask(struct irq_data *d)
> +{
> +	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
> +	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
> +	unsigned long value, flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	value = readl(gpio->regs + GPIO_INTMASK);
> +	value &= ~(1 << d->hwirq);
> +	writel(value, gpio->regs + GPIO_INTMASK);
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +}
> +
> +static struct irq_chip dwapb_irq_chip = {
> +	.name = "gpio-dwapb",
> +	.irq_ack = dwapb_irq_ack,
> +	.irq_mask = dwapb_irq_mask,
> +	.irq_unmask = dwapb_irq_unmask,
> +	.irq_set_type = dwapb_irq_set_type,
> +	.irq_enable = dwapb_irq_enable,
> +	.irq_disable = dwapb_irq_disable,
> +};

If you use irq_chip_generic, that should allow you to get rid of
ack/mask/unmask callbacks above. If you need an example, look at
drivers/irqchip/irq-orion.c.

> +static int dwapb_gpio_irq_map(struct irq_domain *domain,
> +			      unsigned int irq,
> +			      irq_hw_number_t hwirq)
> +{
> +	struct dwapb_gpio *gpio = domain->host_data;
> +
> +	irq_set_chip_data(irq, gpio);
> +	irq_set_chip_and_handler(irq, &dwapb_irq_chip, handle_level_irq);
> +	irq_set_irq_type(irq, IRQ_TYPE_NONE);
> +	irq_set_handler_data(irq, gpio);
> +
> +	return 0;
> +}
> +
> +static struct irq_domain_ops dwapb_gpio_irq_ops = {
> +	.map = dwapb_gpio_irq_map,
> +	.xlate = irq_domain_xlate_twocell,
> +};
> +
> +static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
> +				 struct dwapb_gpio_port *port)
> +{
> +	struct gpio_chip *gc = &port->bgc.gc;
> +	struct device_node *node =  gc->of_node;
> +	unsigned int ngpio = gc->ngpio;
> +	int reg;
> +
> +	if (of_get_property(node, "interrupts", &reg) == NULL)
> +		return;
> +
> +	gpio->hwirq = irq_of_parse_and_map(node, 0);

Loop over all "interrupts" passed and register them to
dwapb_irq_handler, as said before, there can be more than
one upstream irq. And better use devm_request_irq, all interrupts
have been converted to resources by platform bus already.

> +	if (gpio->hwirq == NO_IRQ)
> +		return;
> +
> +	gpio->domain = irq_domain_add_linear(node, ngpio, &dwapb_gpio_irq_ops,
> +					     gpio);
> +	if (!gpio->domain) {
> +		irq_dispose_mapping(gpio->hwirq);
> +		return;
> +	}
> +
> +	irq_set_handler_data(gpio->hwirq, gpio);
> +	irq_set_chained_handler(gpio->hwirq, dwapb_irq_handler);
> +	port->bgc.gc.to_irq = dwapb_gpio_to_irq;
> +}
> +
> +static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
> +			       struct device_node *port_np,
> +			       unsigned int offs)
> +{
> +	struct dwapb_gpio_port *port;
> +	u32 port_idx, ngpio;
> +	void __iomem *dat, *set, *dirout;
> +	int err;
> +
> +	if (of_property_read_u32(port_np, "reg", &port_idx)) {
> +		dev_err(gpio->dev, "missing port index for %s\n",
> +			port_np->full_name);
> +		return -EINVAL;
> +	}
> +
> +	if (port_idx > 3) {
> +		dev_err(gpio->dev, "invalid port index for %s\n",
> +			port_np->full_name);
> +		return -EINVAL;
> +	}

join the two above to

if (of_property_read_u32(port_np, "reg", &port_idx) ||
	port_idx >= DWAPB_MAX_PORTS) {
	dev_err(.., "missing/invalid port index ...", ...)
	return -EINVAL;
}

> +	port = &gpio->ports[offs];

if you devm_kzalloc each gpio_chip locally here and assign it
after successful gpiochip_add, you have your is_registered
back implicitly.

> +	port->gpio = gpio;
> +
> +	if (of_property_read_u32(port_np, "nr-gpios", &ngpio)) {
> +		dev_err(gpio->dev, "failed to get number of gpios for %s\n",
> +			port_np->full_name);
> +		return -EINVAL;
> +	}
> +
> +	dat = gpio->regs + GPIO_EXT_PORTA +
> +		(port_idx * (GPIO_EXT_PORTB - GPIO_EXT_PORTA));

#define GPIO_EXT_PORT_SIZE	0xc

dat = gpio->reg + GPIO_EXT_PORTA + (port_idx * GPIO_EXT_PORT_SIZE);

> +	set = gpio->regs + GPIO_SWPORTA_DR +
> +		(port_idx * (GPIO_SWPORTB_DR - GPIO_SWPORTA_DR));

ditto.

> +	dirout = gpio->regs + GPIO_SWPORTA_DDR +
> +		(port_idx * (GPIO_SWPORTB_DDR - GPIO_SWPORTA_DDR));

ditto.

> +	err = bgpio_init(&port->bgc, gpio->dev, 4, dat, set, NULL, dirout,
> +			 NULL, false);
> +	if (err) {
> +		dev_err(gpio->dev, "failed to init gpio chip for %s\n",
> +			port_np->full_name);
> +		return err;
> +	}
> +
> +	port->bgc.gc.ngpio = ngpio;
> +	port->bgc.gc.of_node = port_np;
> +
> +	/*
> +	 * Only port A can provide interrupts in all configurations of the IP.
> +	 */
> +	if (port_idx == 0 &&
> +	    of_get_property(port_np, "interrupt-controller", NULL))

of_property_read_bool(port_np, "interrupt-controller")

> +		dwapb_configure_irqs(gpio, port);
> +
> +	err = gpiochip_add(&port->bgc.gc);
> +	if (err)
> +		dev_err(gpio->dev, "failed to register gpiochip for %s\n",
> +			port_np->full_name);
> +	else
> +		port->is_registered = true;
> +
> +	return err;
> +}
> +
> +static void dwapb_gpio_unregister(struct dwapb_gpio *gpio)
> +{
> +	unsigned int m;
> +
> +	for (m = 0; m < gpio->nr_ports; ++m)
> +		if (gpio->ports[m].is_registered)
> +			WARN_ON(gpiochip_remove(&gpio->ports[m].bgc.gc));

if (gpio->port_bgc[m])
	...

> +}
> +
> +static int dwapb_gpio_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct dwapb_gpio *gpio;
> +	struct device_node *np;
> +	int err;
> +	unsigned int offs = 0;
> +
> +	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
> +	if (!gpio)
> +		return -ENOMEM;
> +	gpio->dev = &pdev->dev;
> +
> +	gpio->nr_ports = dwapb_gpio_nr_ports(pdev->dev.of_node);
> +	if (!gpio->nr_ports) {
> +		err = -EINVAL;
> +		goto out_err;
> +	}
> +	gpio->ports = devm_kzalloc(&pdev->dev, gpio->nr_ports *
> +				   sizeof(*gpio->ports), GFP_KERNEL);
> +	if (!gpio->ports) {
> +		err = -ENOMEM;
> +		goto out_err;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	gpio->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (!gpio->regs) {
> +		err = -ENOMEM;

if (!gpio->regs)
	return PTR_ERR(gpio->regs);

Jamie already mentioned it.

> +		goto out_free_ports;
> +	}
> +
> +	for_each_child_of_node(pdev->dev.of_node, np) {
> +		err = dwapb_gpio_add_port(gpio, np, offs++);
> +		if (err)
> +			goto out_unregister;
> +	}
> +	platform_set_drvdata(pdev, gpio);
> +
> +	return 0;
> +
> +out_unregister:
> +	dwapb_gpio_unregister(gpio);
> +
> +	if (gpio->domain) {
> +		irq_dispose_mapping(gpio->hwirq);
> +		irq_domain_remove(gpio->domain);

pseudo-code:

for hwirq in #gpios-porta loop
	irq_dispose_mapping(
	   irq_find_mapping(domain,gc->irq_base + hwirq))
end loop
irq_domain_remove(domain)

> +	}
> +
> +out_free_ports:
> +	devm_kfree(&pdev->dev, gpio->ports);
> +
> +out_err:
> +	devm_kfree(&pdev->dev, gpio);

Still, remove devm_kfree above.

> +	return err;
> +}
> +
> +static int dwapb_gpio_remove(struct platform_device *pdev)
> +{
> +	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
> +
> +	dwapb_gpio_unregister(gpio);
> +	if (gpio->domain) {
> +		irq_dispose_mapping(gpio->hwirq);
> +		irq_domain_remove(gpio->domain);
> +	}
> +	devm_kfree(&pdev->dev, gpio->ports);
> +	devm_kfree(&pdev->dev, gpio);

ditto.

> +	return 0;
> +}
> +
> +static const struct of_device_id dwapb_of_match[] = {
> +	{ .compatible = "snps,dw-apb-gpio" },
> +	{ /* Sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, dwapb_of_match);
> +
> +static struct platform_driver dwapb_gpio_driver = {
> +	.driver		= {
> +		.name	= "gpio-dwapb",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(dwapb_of_match),
> +	},
> +	.probe		= dwapb_gpio_probe,
> +	.remove		= dwapb_gpio_remove,
> +};
> +
> +static int __init dwapb_gpio_init(void)
> +{
> +	return platform_driver_register(&dwapb_gpio_driver);
> +}
> +postcore_initcall(dwapb_gpio_init);
> +
> +static void __exit dwapb_gpio_exit(void)
> +{
> +	platform_driver_unregister(&dwapb_gpio_driver);
> +}
> +module_exit(dwapb_gpio_exit);

Jamie already mentioned to use module_platform_driver(), of course
this will remove the postcore_initcall and move gpio init to some
later point. I know GPIO is important, but nevertheless I suggest
to remove it. Deferred probing will sort out initialization order.

Sebastian

> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jamie Iles");
> +MODULE_DESCRIPTION("Synopsys DesignWare APB GPIO driver");
>

