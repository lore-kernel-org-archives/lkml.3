Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbaBFQMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:12:49 -0500
Received: from mail-bn1on0114.outbound.protection.outlook.com ([157.56.110.114]:34643
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752686AbaBFQMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:12:46 -0500
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Feb 2014 11:12:45 EST
From: Alan Tull <delicious.quinoa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.com>
CC: <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "Steffen Trumtrar" <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        delicious quinoa <delicious.quinoa@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH v10] gpio: add a driver for the Synopsys DesignWare APB GPIO block
Date: Thu, 6 Feb 2014 09:55:47 -0600
Message-ID: <1391702147-6617-1-git-send-email-delicious.quinoa@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130361758731650255;(6c7e1f6d-ea3d-4e34-ed1d-08d0e4b1def8);()
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(1001?=
 =?us-ascii?Q?9001)(6009001)(37524003)(189002)(199002)(49866001)(69226001)?=
 =?us-ascii?Q?(47976001)(50986001)(50226001)(83072002)(73392001)(4396001)(?=
 =?us-ascii?Q?74366001)(33646001)(81342001)(92726001)(56816005)(89996001)(?=
 =?us-ascii?Q?74706001)(85306002)(88136002)(87936001)(50466002)(55446002)(?=
 =?us-ascii?Q?85852003)(47736001)(51856001)(31966008)(90146001)(80022001)(?=
 =?us-ascii?Q?53806001)(81686001)(73972005)(48376002)(81542001)(87266001)(?=
 =?us-ascii?Q?65816001)(86362001)(81442001)(76176001)(80976001)(79102001)(?=
 =?us-ascii?Q?94946001)(74876001)(77096001)(76786001)(63696002)(74502001)(?=
 =?us-ascii?Q?87286001)(77982001)(6806004)(59766001)(53416003)(93136001)(6?=
 =?us-ascii?Q?1266001)(56776001)(54316002)(93916002)(47446002)(92566001)(7?=
 =?us-ascii?Q?6796001)(575784001)(94316002)(47776003)(74662001)(81816001)(?=
 =?us-ascii?Q?46102001)(82202001)(77156001)(19580405001)(44976005)(9351600?=
 =?us-ascii?Q?2)(36756003)(62966002)(20776003)(95416001)(19580395003)(2004?=
 =?us-ascii?Q?002)(42262001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO?=
 =?us-ascii?Q?11HUB044;H:SJ-ITEXEDGE02.altera.priv.altera.com;CLIP:66.35.2?=
 =?us-ascii?Q?36.232;FPR:;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;?=
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0114FF88F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jamie Iles <jamie@jamieiles.com>

The Synopsys DesignWare block is used in some ARM devices (picoxcell)
and can be configured to provide multiple banks of GPIO pins.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Signed-off-by: Alan Tull <atull@altera.com>
Reviewed-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

v10:	- in documentation nr-gpio -> nr-gpios
v9:	- cleanup in dt bindings doc
	- use of_get_child_count()
v8:	- remove socfpga.dtsi changes
	- minor cleanup in devicetree documentation
v7:	- use irq_generic_chip
	- support one irq per gpio line or one irq for many
	- s/bank/port/ and other cleanup
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
 .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   59 +++
 drivers/gpio/Kconfig                               |    9 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-dwapb.c                          |  415 ++++++++++++++++++++
 4 files changed, 484 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
 create mode 100644 drivers/gpio/gpio-dwapb.c

diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
new file mode 100644
index 0000000..cb01f9f
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
@@ -0,0 +1,59 @@
+* Synopsys DesignWare APB GPIO controller
+
+Required properties:
+- compatible : Should contain "snps,dw-apb-gpio"
+- reg : Address and length of the register set for the device
+
+The GPIO controller has a configurable number of ports, each of which are
+represented as child nodes with the following properties:
+
+Required properties:
+- compatible : "snps,dw-apb-gpio-port"
+- gpio-controller : Marks the device node as a gpio controller.
+- #gpio-cells : Should be two.  The first cell is the pin number and
+  the second cell is used to specify optional parameters (currently
+  unused).
+- reg : The integer port index of the port, a single cell.
+- #address-cells : should be 1.
+- #size-cells : should be 0.
+
+Optional properties:
+- interrupt-controller : The first port may be configured to be an interrupt
+controller.
+- #interrupt-cells : Specifies the number of cells needed to encode an
+interrupt.  Shall be set to 2.  The first cell defines the interrupt number,
+the second encodes the triger flags encoded as described in
+Documentation/devicetree/bindings/interrupts.txt
+- interrupt-parent : The parent interrupt controller.
+- interrupts : The interrupts to the parent controller raised when GPIOs
+generate the interrupts.
+- snps,nr-gpios : The number of pins in the port, a single cell.
+
+Example:
+
+gpio: gpio@20000 {
+	compatible = "snps,dw-apb-gpio";
+	reg = <0x20000 0x1000>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	porta: gpio-controller@0 {
+		compatible = "snps,dw-apb-gpio-port";
+		gpio-controller;
+		#gpio-cells = <2>;
+		snps,nr-gpios = <8>;
+		reg = <0>;
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		interrupt-parent = <&vic1>;
+		interrupts = <0>, <1>, <2>, <3>, <4>, <5>, <6>, <7>;
+	};
+
+	portb: gpio-controller@1 {
+		compatible = "snps,dw-apb-gpio-port";
+		gpio-controller;
+		#gpio-cells = <2>;
+		snps,nr-gpios = <8>;
+		reg = <1>;
+	};
+};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0f04444..17760dd 100644
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
index 7971e36..b4f852e 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
 obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
+obj-$(CONFIG_GPIO_DWAPB)	+= gpio-dwapb.o
 obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_F7188X)	+= gpio-f7188x.o
diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
new file mode 100644
index 0000000..7dff515
--- /dev/null
+++ b/drivers/gpio/gpio-dwapb.c
@@ -0,0 +1,415 @@
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
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
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
+#define DWAPB_MAX_PORTS		4
+#define GPIO_EXT_PORT_SIZE	(GPIO_EXT_PORTB - GPIO_EXT_PORTA)
+#define GPIO_SWPORT_DR_SIZE	(GPIO_SWPORTB_DR - GPIO_SWPORTA_DR)
+#define GPIO_SWPORT_DDR_SIZE	(GPIO_SWPORTB_DDR - GPIO_SWPORTA_DDR)
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
+};
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
+	u32 irq_status = readl_relaxed(gpio->regs + GPIO_INTSTATUS);
+
+	while (irq_status) {
+		int hwirq = fls(irq_status) - 1;
+		int gpio_irq = irq_find_mapping(gpio->domain, hwirq);
+
+		generic_handle_irq(gpio_irq);
+		irq_status &= ~BIT(hwirq);
+
+		if ((irq_get_trigger_type(gpio_irq) & IRQ_TYPE_SENSE_MASK)
+			== IRQ_TYPE_EDGE_BOTH)
+			dwapb_toggle_trigger(gpio, hwirq);
+	}
+
+	if (chip->irq_eoi)
+		chip->irq_eoi(irq_desc_get_irq_data(desc));
+}
+
+static void dwapb_irq_enable(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct dwapb_gpio *gpio = gc->private;
+	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	val = readl(gpio->regs + GPIO_INTEN);
+	val |= BIT(d->hwirq);
+	writel(val, gpio->regs + GPIO_INTEN);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static void dwapb_irq_disable(struct irq_data *d)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct dwapb_gpio *gpio = gc->private;
+	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	val = readl(gpio->regs + GPIO_INTEN);
+	val &= ~BIT(d->hwirq);
+	writel(val, gpio->regs + GPIO_INTEN);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static int dwapb_irq_set_type(struct irq_data *d, u32 type)
+{
+	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
+	struct dwapb_gpio *gpio = gc->private;
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
+		level |= BIT(bit);
+		dwapb_toggle_trigger(gpio, bit);
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		level |= BIT(bit);
+		polarity |= BIT(bit);
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		level |= BIT(bit);
+		polarity &= ~BIT(bit);
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		level &= ~BIT(bit);
+		polarity |= BIT(bit);
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		level &= ~BIT(bit);
+		polarity &= ~BIT(bit);
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
+static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
+				 struct dwapb_gpio_port *port)
+{
+	struct gpio_chip *gc = &port->bgc.gc;
+	struct device_node *node =  gc->of_node;
+	struct irq_chip_generic	*irq_gc;
+	unsigned int hwirq, ngpio = gc->ngpio;
+	struct irq_chip_type *ct;
+	int reg, err, irq;
+
+	if (of_get_property(node, "interrupts", &reg) == NULL)
+		return;
+
+	gpio->domain = irq_domain_add_linear(node, ngpio, &irq_generic_chip_ops,
+					     gpio);
+	if (!gpio->domain)
+		return;
+
+	err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 1,
+					     "gpio-dwapb", handle_level_irq,
+					     IRQ_NOREQUEST, 0,
+					     IRQ_GC_INIT_NESTED_LOCK);
+	if (err) {
+		dev_info(gpio->dev, "irq_alloc_domain_generic_chips failed\n");
+		irq_domain_remove(gpio->domain);
+		gpio->domain = NULL;
+		return;
+	}
+
+	for (hwirq = 0 ; hwirq < ngpio ; hwirq++) {
+		irq_gc = irq_get_domain_generic_chip(gpio->domain, hwirq);
+		if (!irq_gc) {
+			irq_domain_remove(gpio->domain);
+			gpio->domain = NULL;
+			return;
+		}
+
+		irq_gc->reg_base = gpio->regs;
+		irq_gc->private = gpio;
+
+		ct = irq_gc->chip_types;
+		ct->chip.irq_ack = irq_gc_ack_set_bit;
+		ct->chip.irq_mask = irq_gc_mask_set_bit;
+		ct->chip.irq_unmask = irq_gc_mask_clr_bit;
+		ct->chip.irq_set_type = dwapb_irq_set_type;
+		ct->chip.irq_enable = dwapb_irq_enable;
+		ct->chip.irq_disable = dwapb_irq_disable;
+		ct->regs.ack = GPIO_PORTA_EOI;
+		ct->regs.mask = GPIO_INTMASK;
+
+		irq_setup_generic_chip(irq_gc, IRQ_MSK(port->bgc.gc.ngpio),
+				IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
+
+		irq = irq_of_parse_and_map(node, hwirq);
+		if (!irq && (hwirq == 0)) {
+			dev_warn(gpio->dev, "no irq for bank %s\n",
+				port->bgc.gc.of_node->full_name);
+			return;
+		} else if (!irq)
+			break;
+
+		irq_set_chained_handler(irq, dwapb_irq_handler);
+		irq_set_handler_data(irq, gpio);
+	}
+	port->bgc.gc.to_irq = dwapb_gpio_to_irq;
+}
+
+static void dwapb_irq_teardown(struct dwapb_gpio *gpio)
+{
+	struct dwapb_gpio_port *port = &gpio->ports[0];
+	struct gpio_chip *gc = &port->bgc.gc;
+	unsigned int ngpio = gc->ngpio;
+	irq_hw_number_t hwirq;
+
+	if (!gpio->domain)
+		return;
+
+	for (hwirq = 0 ; hwirq < ngpio ; hwirq++)
+		irq_dispose_mapping(irq_find_mapping(gpio->domain, hwirq));
+
+	irq_domain_remove(gpio->domain);
+	gpio->domain = NULL;
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
+	if (of_property_read_u32(port_np, "reg", &port_idx) ||
+		port_idx >= DWAPB_MAX_PORTS) {
+		dev_err(gpio->dev, "missing/invalid port index for %s\n",
+			port_np->full_name);
+		return -EINVAL;
+	}
+
+	port = &gpio->ports[offs];
+	port->gpio = gpio;
+
+	if (of_property_read_u32(port_np, "snps,nr-gpios", &ngpio)) {
+		dev_info(gpio->dev, "failed to get number of gpios for %s\n",
+			 port_np->full_name);
+		ngpio = 32;
+	}
+
+	dat = gpio->regs + GPIO_EXT_PORTA + (port_idx * GPIO_EXT_PORT_SIZE);
+	set = gpio->regs + GPIO_SWPORTA_DR + (port_idx * GPIO_SWPORT_DR_SIZE);
+	dirout = gpio->regs + GPIO_SWPORTA_DDR +
+		(port_idx * GPIO_SWPORT_DDR_SIZE);
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
+	    of_property_read_bool(port_np, "interrupt-controller"))
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
+	gpio->nr_ports = of_get_child_count(pdev->dev.of_node);
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
+	if (IS_ERR(gpio->regs)) {
+		err = PTR_ERR(gpio->regs);
+		goto out_err;
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
+	dwapb_irq_teardown(gpio);
+
+out_err:
+	return err;
+}
+
+static int dwapb_gpio_remove(struct platform_device *pdev)
+{
+	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
+
+	dwapb_gpio_unregister(gpio);
+	dwapb_irq_teardown(gpio);
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
+module_platform_driver(dwapb_gpio_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("Synopsys DesignWare APB GPIO driver");
-- 
1.7.9.5

