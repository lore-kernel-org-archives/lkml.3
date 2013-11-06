Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3KFWuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:50:15 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:54589
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab3KFWuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:50:10 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z551bizea8Nc8kzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6h1082kzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Alan Tull <delicious.quinoa@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-gpio@vger.kernel.org>, Linus Walleij <linus.walleij@stericsson.com>,
        <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
        delicious quinoa <delicious.quinoa@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH 1/1] gpio: add a driver for the Synopsys DesignWare APB GPIO block
Date: Wed, 6 Nov 2013 16:49:42 -0600
Message-ID: <1383778182-16941-2-git-send-email-delicious.quinoa@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383778182-16941-1-git-send-email-delicious.quinoa@gmail.com>
References: <1383778182-16941-1-git-send-email-delicious.quinoa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jamie Iles <jamie@jamieiles.com>

The Synopsys DesignWare block is used in some ARM devices (picoxcell)
and can be configured to provide multiple banks of GPIO pins.

Signed-off-by: Alan Tull <atull@altera.com>

v6:	- (atull) squash the set of patches
	- use linear irq domain
	- build fixes. Original driver was reviewed on v3.2.
	- Fix setting irq edge type for 'rising' and 'both'.
	- Support as a loadable module.
	- Use bgpio_chip's spinlock during register access.
	- Clean up register names to match spec
	- s/bank/port/ because register names use the word 'port'
	- s/nr-gpio/nr-gpios/
	- don't get/put the of_node
	- remove signoffs/acked-by's because of changes
	- other cleanup
v5:	- handle sparse bank population correctly
v3:	- depend on rather than select IRQ_DOMAIN
	- split IRQ support into a separate patch
v2:	- use Rob Herring's irqdomain in generic irq chip patches
	- use reg property to indicate bank index
	- support irqs on both edges based on LinusW's u300 driver
---
 .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   57 +++
 drivers/gpio/Kconfig                               |    9 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-dwapb.c                          |  458 ++++++++++++++++++++
 4 files changed, 525 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
 create mode 100644 drivers/gpio/gpio-dwapb.c

diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
new file mode 100644
index 0000000..f7e2076
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
@@ -0,0 +1,57 @@
+* Synopsys DesignWare APB GPIO controller
+
+Required properties:
+- compatible : Should be "snps,dw-apb-gpio"
+- reg : Address and length of the register set for the device
+
+The GPIO controller has a configurable number of banks, each of which are
+represented as child nodes with the following properties:
+
+Required properties:
+- compatible : "snps,dw-apb-gpio-bank"
+- gpio-controller : Marks the device node as a gpio controller.
+- #gpio-cells : Should be two.  The first cell is the pin number and
+  the second cell is used to specify optional parameters (currently
+  unused).
+- reg : The integer bank index of the bank, a single cell.
+- nr-gpios : The number of pins in the bank, a single cell.
+
+Optional properties:
+- interrupt-controller : The first bank may be configured to be an interrupt
+controller.
+- #interrupt-cells : Specifies the number of cells needed to encode an
+interrupt.  Shall be set to 2.  The first cell defines the interrupt number,
+the second encodes the triger flags encoded as described in
+Documentation/devicetree/bindings/interrupts.txt
+- interrupt-parent : The parent interrupt controller.
+- interrupts : The interrupts to the parent controller raised when GPIOs
+generate the interrupts.
+
+Example:
+
+gpio: gpio@20000 {
+	compatible = "snps,dw-apb-gpio";
+	reg = <0x20000 0x1000>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	banka: gpio-controller@0 {
+		compatible = "snps,dw-apb-gpio-bank";
+		gpio-controller;
+		#gpio-cells = <2>;
+		nr-gpio = <8>;
+		reg = <0>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		interrupt-parent = <&vic1>;
+		interrupts = <0 1 2 3 4 5 6 7>;
+	};
+
+	bankb: gpio-controller@1 {
+		compatible = "snps,dw-apb-gpio-bank";
+		gpio-controller;
+		#gpio-cells = <2>;
+		nr-gpio = <8>;
+		reg = <1>;
+	};
+};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index b6ed304..14ec4e4 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -121,6 +121,15 @@ config GPIO_GENERIC_PLATFORM
 	help
 	  Say yes here to support basic platform_device memory-mapped GPIO controllers.
 
+config GPIO_DWAPB
+	tristate "Synopsys DesignWare APB GPIO driver"
+	select GPIO_GENERIC
+	select GENERIC_IRQ_CHIP
+	depends on OF_GPIO && IRQ_DOMAIN
+	help
+	  Say Y or M here to build support for the Synopsys DesignWare APB
+	  GPIO block.
+
 config GPIO_IT8761E
 	tristate "IT8761E GPIO support"
 	depends on X86  # unconditional access to IO space.
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 98e23eb..8de041a 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
 obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
+obj-$(CONFIG_GPIO_DWAPB)	+= gpio-dwapb.o
 obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_F7188X)	+= gpio-f7188x.o
diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
new file mode 100644
index 0000000..7957dfd
--- /dev/null
+++ b/drivers/gpio/gpio-dwapb.c
@@ -0,0 +1,458 @@
+/*
+ * Copyright (c) 2011 Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * All enquiries to support@picochip.com
+ */
+#include <linux/basic_mmio_gpio.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+
+#define GPIO_SWPORTA_DR		0x00
+#define GPIO_SWPORTA_DDR	0x04
+#define GPIO_SWPORTB_DR		0x0c
+#define GPIO_SWPORTB_DDR	0x10
+#define GPIO_SWPORTC_DR		0x18
+#define GPIO_SWPORTC_DDR	0x1c
+#define GPIO_SWPORTD_DR		0x24
+#define GPIO_SWPORTD_DDR	0x28
+#define GPIO_INTEN		0x30
+#define GPIO_INTMASK		0x34
+#define GPIO_INTTYPE_LEVEL	0x38
+#define GPIO_INT_POLARITY	0x3c
+#define GPIO_INTSTATUS		0x40
+#define GPIO_PORTA_EOI		0x4c
+#define GPIO_EXT_PORTA		0x50
+#define GPIO_EXT_PORTB		0x54
+#define GPIO_EXT_PORTC		0x58
+#define GPIO_EXT_PORTD		0x5c
+
+struct dwapb_gpio;
+
+struct dwapb_gpio_port {
+	struct bgpio_chip	bgc;
+	bool			is_registered;
+	struct dwapb_gpio	*gpio;
+};
+
+struct dwapb_gpio {
+	struct	device		*dev;
+	void __iomem		*regs;
+	struct dwapb_gpio_port	*ports;
+	unsigned int		nr_ports;
+	struct irq_domain	*domain;
+	int			hwirq;
+};
+
+static unsigned int dwapb_gpio_nr_ports(struct device_node *of_node)
+{
+	unsigned int nr_ports = 0;
+	struct device_node *np;
+
+	for_each_child_of_node(of_node, np)
+		++nr_ports;
+
+	return nr_ports;
+}
+
+static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	struct dwapb_gpio_port *port = container_of(bgc, struct
+						    dwapb_gpio_port, bgc);
+	struct dwapb_gpio *gpio = port->gpio;
+
+	return irq_create_mapping(gpio->domain, offset);
+}
+
+static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
+{
+	u32 v = readl(gpio->regs + GPIO_INT_POLARITY);
+
+	if (gpio_get_value(gpio->ports[0].bgc.gc.base + offs))
+		v &= ~BIT(offs);
+	else
+		v |= BIT(offs);
+
+	writel(v, gpio->regs + GPIO_INT_POLARITY);
+}
+
+static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
+{
+	struct dwapb_gpio *gpio = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	u32 irq_status = readl(gpio->regs + GPIO_INTSTATUS);
+
+	while (irq_status) {
+		int irqoffset = fls(irq_status) - 1;
+		int gpio_irq = irq_linear_revmap(gpio->domain, irqoffset);
+		u32 irq_type = irq_get_trigger_type(gpio_irq);
+
+		generic_handle_irq(gpio_irq);
+		irq_status &= ~(1 << irqoffset);
+
+		if ((irq_type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH)
+			dwapb_toggle_trigger(gpio, irqoffset);
+	}
+
+	if (chip->irq_eoi)
+		chip->irq_eoi(irq_desc_get_irq_data(desc));
+}
+
+static void dwapb_irq_enable(struct irq_data *d)
+{
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	val = readl(gpio->regs + GPIO_INTEN);
+	val |= 1 << d->hwirq;
+	writel(val, gpio->regs + GPIO_INTEN);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static void dwapb_irq_disable(struct irq_data *d)
+{
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	val = readl(gpio->regs + GPIO_INTEN);
+	val &= ~(1 << d->hwirq);
+	writel(val, gpio->regs + GPIO_INTEN);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static int dwapb_irq_set_type(struct irq_data *d, u32 type)
+{
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
+	int bit = d->hwirq;
+	unsigned long level, polarity, flags;
+
+	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
+		     IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
+		return -EINVAL;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	level = readl(gpio->regs + GPIO_INTTYPE_LEVEL);
+	polarity = readl(gpio->regs + GPIO_INT_POLARITY);
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_BOTH:
+		level |= (1 << bit);
+		dwapb_toggle_trigger(gpio, bit);
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		level |= (1 << bit);
+		polarity |= (1 << bit);
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		level |= (1 << bit);
+		polarity &= ~(1 << bit);
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		level &= ~(1 << bit);
+		polarity |= (1 << bit);
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		level &= ~(1 << bit);
+		polarity &= ~(1 << bit);
+		break;
+	}
+
+	writel(level, gpio->regs + GPIO_INTTYPE_LEVEL);
+	writel(polarity, gpio->regs + GPIO_INT_POLARITY);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+
+	return 0;
+}
+
+static void dwapb_irq_ack(struct irq_data *d)
+{
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	writel(1 << d->hwirq, gpio->regs + GPIO_PORTA_EOI);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static void dwapb_irq_mask(struct irq_data *d)
+{
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
+	unsigned long value, flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	value = readl(gpio->regs + GPIO_INTMASK);
+	value |= 1 << d->hwirq;
+	writel(value, gpio->regs + GPIO_INTMASK);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static void dwapb_irq_unmask(struct irq_data *d)
+{
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
+	unsigned long value, flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	value = readl(gpio->regs + GPIO_INTMASK);
+	value &= ~(1 << d->hwirq);
+	writel(value, gpio->regs + GPIO_INTMASK);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static struct irq_chip dwapb_irq_chip = {
+	.name = "gpio-dwapb",
+	.irq_ack = dwapb_irq_ack,
+	.irq_mask = dwapb_irq_mask,
+	.irq_unmask = dwapb_irq_unmask,
+	.irq_set_type = dwapb_irq_set_type,
+	.irq_enable = dwapb_irq_enable,
+	.irq_disable = dwapb_irq_disable,
+};
+
+static int dwapb_gpio_irq_map(struct irq_domain *domain,
+			      unsigned int irq,
+			      irq_hw_number_t hwirq)
+{
+	struct dwapb_gpio *gpio = domain->host_data;
+
+	irq_set_chip_data(irq, gpio);
+	irq_set_chip_and_handler(irq, &dwapb_irq_chip, handle_level_irq);
+	irq_set_irq_type(irq, IRQ_TYPE_NONE);
+	irq_set_handler_data(irq, gpio);
+
+	return 0;
+}
+
+static struct irq_domain_ops dwapb_gpio_irq_ops = {
+	.map = dwapb_gpio_irq_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
+static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
+				 struct dwapb_gpio_port *port)
+{
+	struct gpio_chip *gc = &port->bgc.gc;
+	struct device_node *node =  gc->of_node;
+	unsigned int ngpio = gc->ngpio;
+	int reg;
+
+	if (of_get_property(node, "interrupts", &reg) == NULL)
+		return;
+
+	gpio->hwirq = irq_of_parse_and_map(node, 0);
+	if (gpio->hwirq == NO_IRQ)
+		return;
+
+	gpio->domain = irq_domain_add_linear(node, ngpio, &dwapb_gpio_irq_ops,
+					     gpio);
+	if (!gpio->domain) {
+		irq_dispose_mapping(gpio->hwirq);
+		return;
+	}
+
+	irq_set_handler_data(gpio->hwirq, gpio);
+	irq_set_chained_handler(gpio->hwirq, dwapb_irq_handler);
+	port->bgc.gc.to_irq = dwapb_gpio_to_irq;
+}
+
+static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
+			       struct device_node *port_np,
+			       unsigned int offs)
+{
+	struct dwapb_gpio_port *port;
+	u32 port_idx, ngpio;
+	void __iomem *dat, *set, *dirout;
+	int err;
+
+	if (of_property_read_u32(port_np, "reg", &port_idx)) {
+		dev_err(gpio->dev, "missing port index for %s\n",
+			port_np->full_name);
+		return -EINVAL;
+	}
+
+	if (port_idx > 3) {
+		dev_err(gpio->dev, "invalid port index for %s\n",
+			port_np->full_name);
+		return -EINVAL;
+	}
+
+	port = &gpio->ports[offs];
+	port->gpio = gpio;
+
+	if (of_property_read_u32(port_np, "nr-gpios", &ngpio)) {
+		dev_err(gpio->dev, "failed to get number of gpios for %s\n",
+			port_np->full_name);
+		return -EINVAL;
+	}
+
+	dat = gpio->regs + GPIO_EXT_PORTA +
+		(port_idx * (GPIO_EXT_PORTB - GPIO_EXT_PORTA));
+
+	set = gpio->regs + GPIO_SWPORTA_DR +
+		(port_idx * (GPIO_SWPORTB_DR - GPIO_SWPORTA_DR));
+
+	dirout = gpio->regs + GPIO_SWPORTA_DDR +
+		(port_idx * (GPIO_SWPORTB_DDR - GPIO_SWPORTA_DDR));
+
+	err = bgpio_init(&port->bgc, gpio->dev, 4, dat, set, NULL, dirout,
+			 NULL, false);
+	if (err) {
+		dev_err(gpio->dev, "failed to init gpio chip for %s\n",
+			port_np->full_name);
+		return err;
+	}
+
+	port->bgc.gc.ngpio = ngpio;
+	port->bgc.gc.of_node = port_np;
+
+	/*
+	 * Only port A can provide interrupts in all configurations of the IP.
+	 */
+	if (port_idx == 0 &&
+	    of_get_property(port_np, "interrupt-controller", NULL))
+		dwapb_configure_irqs(gpio, port);
+
+	err = gpiochip_add(&port->bgc.gc);
+	if (err)
+		dev_err(gpio->dev, "failed to register gpiochip for %s\n",
+			port_np->full_name);
+	else
+		port->is_registered = true;
+
+	return err;
+}
+
+static void dwapb_gpio_unregister(struct dwapb_gpio *gpio)
+{
+	unsigned int m;
+
+	for (m = 0; m < gpio->nr_ports; ++m)
+		if (gpio->ports[m].is_registered)
+			WARN_ON(gpiochip_remove(&gpio->ports[m].bgc.gc));
+}
+
+static int dwapb_gpio_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct dwapb_gpio *gpio;
+	struct device_node *np;
+	int err;
+	unsigned int offs = 0;
+
+	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
+	if (!gpio)
+		return -ENOMEM;
+	gpio->dev = &pdev->dev;
+
+	gpio->nr_ports = dwapb_gpio_nr_ports(pdev->dev.of_node);
+	if (!gpio->nr_ports) {
+		err = -EINVAL;
+		goto out_err;
+	}
+	gpio->ports = devm_kzalloc(&pdev->dev, gpio->nr_ports *
+				   sizeof(*gpio->ports), GFP_KERNEL);
+	if (!gpio->ports) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	gpio->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (!gpio->regs) {
+		err = -ENOMEM;
+		goto out_free_ports;
+	}
+
+	for_each_child_of_node(pdev->dev.of_node, np) {
+		err = dwapb_gpio_add_port(gpio, np, offs++);
+		if (err)
+			goto out_unregister;
+	}
+	platform_set_drvdata(pdev, gpio);
+
+	return 0;
+
+out_unregister:
+	dwapb_gpio_unregister(gpio);
+
+	if (gpio->domain) {
+		irq_dispose_mapping(gpio->hwirq);
+		irq_domain_remove(gpio->domain);
+	}
+
+out_free_ports:
+	devm_kfree(&pdev->dev, gpio->ports);
+
+out_err:
+	devm_kfree(&pdev->dev, gpio);
+	return err;
+}
+
+static int dwapb_gpio_remove(struct platform_device *pdev)
+{
+	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
+
+	dwapb_gpio_unregister(gpio);
+	if (gpio->domain) {
+		irq_dispose_mapping(gpio->hwirq);
+		irq_domain_remove(gpio->domain);
+	}
+	devm_kfree(&pdev->dev, gpio->ports);
+	devm_kfree(&pdev->dev, gpio);
+
+	return 0;
+}
+
+static const struct of_device_id dwapb_of_match[] = {
+	{ .compatible = "snps,dw-apb-gpio" },
+	{ /* Sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, dwapb_of_match);
+
+static struct platform_driver dwapb_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-dwapb",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(dwapb_of_match),
+	},
+	.probe		= dwapb_gpio_probe,
+	.remove		= dwapb_gpio_remove,
+};
+
+static int __init dwapb_gpio_init(void)
+{
+	return platform_driver_register(&dwapb_gpio_driver);
+}
+postcore_initcall(dwapb_gpio_init);
+
+static void __exit dwapb_gpio_exit(void)
+{
+	platform_driver_unregister(&dwapb_gpio_driver);
+}
+module_exit(dwapb_gpio_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("Synopsys DesignWare APB GPIO driver");
-- 
1.7.9.5


