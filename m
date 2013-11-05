Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3KEQ5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:57:22 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:49942
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352Ab3KEQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:56:39 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z551bizea8Nc8kzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6h1082kzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Alan Tull <delicious.quinoa@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
        delicious quinoa <delicious.quinoa@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH 1/3] gpio: add a driver for the Synopsys DesignWare APB GPIO block
Date: Tue, 5 Nov 2013 10:55:50 -0600
Message-ID: <1383670552-17566-2-git-send-email-delicious.quinoa@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383670552-17566-1-git-send-email-delicious.quinoa@gmail.com>
References: <1383670552-17566-1-git-send-email-delicious.quinoa@gmail.com>
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

v5:	- handle sparse bank population correctly
v3:	- depend on rather than select IRQ_DOMAIN
	- split IRQ support into a separate patch
v2:	- use Rob Herring's irqdomain in generic irq chip patches
	- use reg property to indicate bank index
	- support irqs on both edges based on LinusW's u300 driver

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   57 +++++++
 drivers/gpio/Kconfig                               |    9 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-dwapb.c                          |  172 ++++++++++++++++++++
 4 files changed, 239 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
 create mode 100644 drivers/gpio/gpio-dwapb.c

diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
new file mode 100644
index 0000000..73adf37
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
+- nr-gpio : The number of pins in the bank, a single cell.
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
index b6ed304..c5e7868 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -121,6 +121,15 @@ config GPIO_GENERIC_PLATFORM
 	help
 	  Say yes here to support basic platform_device memory-mapped GPIO controllers.
 
+config GPIO_DWAPB
+	bool "Synopsys DesignWare APB GPIO driver"
+	select GPIO_GENERIC
+	select GENERIC_IRQ_CHIP
+	depends on OF_GPIO
+	help
+	  Say Y or M here to build support for the Synopsys DesignWare APB
+	  GPIO block.  This requires device tree support.
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
index 0000000..3a28697
--- /dev/null
+++ b/drivers/gpio/gpio-dwapb.c
@@ -0,0 +1,172 @@
+/*
+ * Copyright (c) 2011 Jamie Iles
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * All enquiries to support@picochip.com
+ */
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/basic_mmio_gpio.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+
+struct dwapb_gpio;
+
+struct dwapb_gpio_bank {
+	struct bgpio_chip	bgc;
+	unsigned int		bank_idx;
+	bool			is_registered;
+	struct dwapb_gpio	*gpio;
+};
+
+struct dwapb_gpio {
+	struct device_node	*of_node;
+	struct	device		*dev;
+	void __iomem		*regs;
+	struct dwapb_gpio_bank	*banks;
+	unsigned int		nr_banks;
+};
+
+static unsigned int dwapb_gpio_nr_banks(struct device_node *of_node)
+{
+	unsigned int nr_banks = 0;
+	struct device_node *np;
+
+	for_each_child_of_node(of_node, np)
+		++nr_banks;
+
+	return nr_banks;
+}
+
+static int dwapb_gpio_add_bank(struct dwapb_gpio *gpio,
+			       struct device_node *bank_np,
+			       unsigned int offs)
+{
+	struct dwapb_gpio_bank *bank;
+	u32 bank_idx, ngpio;
+	int err;
+
+	if (of_property_read_u32(bank_np, "reg", &bank_idx)) {
+		dev_err(gpio->dev, "invalid bank index for %s\n",
+			bank_np->full_name);
+		return -EINVAL;
+	}
+	bank = &gpio->banks[offs];
+	bank->gpio = gpio;
+
+	if (of_property_read_u32(bank_np, "nr-gpio", &ngpio)) {
+		dev_err(gpio->dev, "failed to get number of gpios for %s\n",
+			bank_np->full_name);
+		return -EINVAL;
+	}
+
+	bank->bank_idx = bank_idx;
+	err = bgpio_init(&bank->bgc, gpio->dev, 4,
+			 gpio->regs + 0x50 + (bank_idx * 0x4),
+			 gpio->regs + 0x00 + (bank_idx * 0xc),
+			 NULL, gpio->regs + 0x04 + (bank_idx * 0xc), NULL,
+			 false);
+	if (err) {
+		dev_err(gpio->dev, "failed to init gpio chip for %s\n",
+			bank_np->full_name);
+		return err;
+	}
+
+	bank->bgc.gc.ngpio = ngpio;
+	bank->bgc.gc.of_node = bank_np;
+
+	err = gpiochip_add(&bank->bgc.gc);
+	if (err)
+		dev_err(gpio->dev, "failed to register gpiochip for %s\n",
+			bank_np->full_name);
+	else
+		bank->is_registered = true;
+
+	return err;
+}
+
+static void dwapb_gpio_unregister(struct dwapb_gpio *gpio)
+{
+	unsigned int m;
+
+	for (m = 0; m < gpio->nr_banks; ++m)
+		if (gpio->banks[m].is_registered)
+			WARN_ON(gpiochip_remove(&gpio->banks[m].bgc.gc));
+	of_node_put(gpio->of_node);
+}
+
+static int __devinit dwapb_gpio_probe(struct platform_device *pdev)
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
+	gpio->nr_banks = dwapb_gpio_nr_banks(pdev->dev.of_node);
+	if (!gpio->nr_banks)
+		return -EINVAL;
+	gpio->banks = devm_kzalloc(&pdev->dev, gpio->nr_banks *
+				   sizeof(*gpio->banks), GFP_KERNEL);
+	if (!gpio->banks)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "failed to get iomem\n");
+		return -ENXIO;
+	}
+	gpio->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!gpio->regs)
+		return -ENOMEM;
+
+	gpio->of_node = of_node_get(pdev->dev.of_node);
+	for_each_child_of_node(pdev->dev.of_node, np) {
+		err = dwapb_gpio_add_bank(gpio, np, offs++);
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
+	return err;
+}
+
+static const struct of_device_id dwapb_of_match_table[] = {
+	{ .compatible = "snps,dw-apb-gpio" },
+	{ /* Sentinel */ }
+};
+
+static struct platform_driver dwapb_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-dwapb",
+		.owner	= THIS_MODULE,
+		.of_match_table = dwapb_of_match_table,
+	},
+	.probe		= dwapb_gpio_probe,
+};
+
+static int __init dwapb_gpio_init(void)
+{
+	return platform_driver_register(&dwapb_gpio_driver);
+}
+postcore_initcall(dwapb_gpio_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jamie Iles");
+MODULE_DESCRIPTION("Synopsys DesignWare APB GPIO driver");
-- 
1.7.9.5


