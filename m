Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbaH0Jyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:54:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:3195 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905AbaH0JyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:54:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="473110623"
From: Weike Chen <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boon Leong Ong <boon.leong.ong@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Alvin Chen <alvin.chen@intel.com>
Subject: [PATCH 1/3] GPIO: gpio-dwapb: Enable platform driver binding to MFD driver
Date: Wed, 27 Aug 2014 10:46:26 -0700
Message-Id: <1409161588-19417-2-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Synopsys DesignWare APB GPIO driver only supports open firmware devices.
But, like Intel Quark X1000 SOC, which has a single PCI function exporting
a GPIO and an I2C controller, it is a Multifunction device. This patch is
to enable the current Synopsys DesignWare APB GPIO driver to support the
Multifunction device which exports the designware GPIO controller.

Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/gpio/Kconfig                     |    1 -
 drivers/gpio/gpio-dwapb.c                |  187 ++++++++++++++++++++++--------
 include/linux/platform_data/gpio-dwapb.h |   32 +++++
 3 files changed, 171 insertions(+), 49 deletions(-)
 create mode 100644 include/linux/platform_data/gpio-dwapb.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9de1515..8250a44 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -136,7 +136,6 @@ config GPIO_DWAPB
 	tristate "Synopsys DesignWare APB GPIO driver"
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
-	depends on OF_GPIO
 	help
 	  Say Y or M here to build support for the Synopsys DesignWare APB
 	  GPIO block.
diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index d6618a6..155a64b 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -21,6 +21,7 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
+#include <linux/platform_data/gpio-dwapb.h>
 
 #define GPIO_SWPORTA_DR		0x00
 #define GPIO_SWPORTA_DDR	0x04
@@ -52,14 +53,15 @@ struct dwapb_gpio_port {
 	struct bgpio_chip	bgc;
 	bool			is_registered;
 	struct dwapb_gpio	*gpio;
+	struct dwapb_gpio_port_property *pp;
 };
 
 struct dwapb_gpio {
 	struct	device		*dev;
 	void __iomem		*regs;
 	struct dwapb_gpio_port	*ports;
-	unsigned int		nr_ports;
 	struct irq_domain	*domain;
+	const struct dwapb_gpio_platform_data	*pdata;
 };
 
 static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
@@ -207,22 +209,24 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 	return 0;
 }
 
+static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	dwapb_irq_handler(irq, desc);
+
+	return IRQ_HANDLED;
+}
+
 static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 				 struct dwapb_gpio_port *port)
 {
 	struct gpio_chip *gc = &port->bgc.gc;
-	struct device_node *node =  gc->of_node;
-	struct irq_chip_generic	*irq_gc;
+	struct device_node *node = port->pp->node;
+	struct irq_chip_generic	*irq_gc = NULL;
 	unsigned int hwirq, ngpio = gc->ngpio;
 	struct irq_chip_type *ct;
-	int err, irq, i;
-
-	irq = irq_of_parse_and_map(node, 0);
-	if (!irq) {
-		dev_warn(gpio->dev, "no irq for bank %s\n",
-			port->bgc.gc.of_node->full_name);
-		return;
-	}
+	int err, i;
 
 	gpio->domain = irq_domain_add_linear(node, ngpio,
 					     &irq_generic_chip_ops, gpio);
@@ -269,8 +273,24 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	irq_gc->chip_types[1].type = IRQ_TYPE_EDGE_BOTH;
 	irq_gc->chip_types[1].handler = handle_edge_irq;
 
-	irq_set_chained_handler(irq, dwapb_irq_handler);
-	irq_set_handler_data(irq, gpio);
+	if (!port->pp->irq_shared) {
+		irq_set_chained_handler(port->pp->irq, dwapb_irq_handler);
+	} else {
+		/*
+		 * Request a shared IRQ since where MFD would have devices
+		 * using the same irq pin
+		 */
+		err = devm_request_irq(gpio->dev, port->pp->irq,
+				       dwapb_irq_handler_mfd,
+				       IRQF_SHARED, "gpio-dwapb-mfd", gpio);
+		if (err) {
+			dev_err(gpio->dev, "error requesting IRQ\n");
+			irq_domain_remove(gpio->domain);
+			gpio->domain = NULL;
+			return;
+		}
+	}
+	irq_set_handler_data(port->pp->irq, gpio);
 
 	for (hwirq = 0 ; hwirq < ngpio ; hwirq++)
 		irq_create_mapping(gpio->domain, hwirq);
@@ -296,57 +316,43 @@ static void dwapb_irq_teardown(struct dwapb_gpio *gpio)
 }
 
 static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
-			       struct device_node *port_np,
+			       struct dwapb_gpio_port_property *pp,
 			       unsigned int offs)
 {
 	struct dwapb_gpio_port *port;
-	u32 port_idx, ngpio;
 	void __iomem *dat, *set, *dirout;
 	int err;
 
-	if (of_property_read_u32(port_np, "reg", &port_idx) ||
-		port_idx >= DWAPB_MAX_PORTS) {
-		dev_err(gpio->dev, "missing/invalid port index for %s\n",
-			port_np->full_name);
-		return -EINVAL;
-	}
-
 	port = &gpio->ports[offs];
 	port->gpio = gpio;
+	port->pp   = pp;
 
-	if (of_property_read_u32(port_np, "snps,nr-gpios", &ngpio)) {
-		dev_info(gpio->dev, "failed to get number of gpios for %s\n",
-			 port_np->full_name);
-		ngpio = 32;
-	}
-
-	dat = gpio->regs + GPIO_EXT_PORTA + (port_idx * GPIO_EXT_PORT_SIZE);
-	set = gpio->regs + GPIO_SWPORTA_DR + (port_idx * GPIO_SWPORT_DR_SIZE);
+	dat = gpio->regs + GPIO_EXT_PORTA + (pp->idx * GPIO_EXT_PORT_SIZE);
+	set = gpio->regs + GPIO_SWPORTA_DR + (pp->idx * GPIO_SWPORT_DR_SIZE);
 	dirout = gpio->regs + GPIO_SWPORTA_DDR +
-		(port_idx * GPIO_SWPORT_DDR_SIZE);
+		(pp->idx * GPIO_SWPORT_DDR_SIZE);
 
 	err = bgpio_init(&port->bgc, gpio->dev, 4, dat, set, NULL, dirout,
 			 NULL, false);
 	if (err) {
 		dev_err(gpio->dev, "failed to init gpio chip for %s\n",
-			port_np->full_name);
+			pp->name);
 		return err;
 	}
 
-	port->bgc.gc.ngpio = ngpio;
-	port->bgc.gc.of_node = port_np;
+	port->bgc.gc.ngpio = pp->ngpio;
+	port->bgc.gc.base = pp->gpio_base;
 
 	/*
 	 * Only port A can provide interrupts in all configurations of the IP.
 	 */
-	if (port_idx == 0 &&
-	    of_property_read_bool(port_np, "interrupt-controller"))
+	if (pp->irq)
 		dwapb_configure_irqs(gpio, port);
 
 	err = gpiochip_add(&port->bgc.gc);
 	if (err)
 		dev_err(gpio->dev, "failed to register gpiochip for %s\n",
-			port_np->full_name);
+			pp->name);
 	else
 		port->is_registered = true;
 
@@ -357,30 +363,115 @@ static void dwapb_gpio_unregister(struct dwapb_gpio *gpio)
 {
 	unsigned int m;
 
-	for (m = 0; m < gpio->nr_ports; ++m)
+	for (m = 0; m < gpio->pdata->nports; ++m)
 		if (gpio->ports[m].is_registered)
 			gpiochip_remove(&gpio->ports[m].bgc.gc);
 }
 
+/*
+ * Handlers for alternative sources of platform_data
+ */
+
+#ifdef CONFIG_OF_GPIO
+/*
+ * Translate OpenFirmware node properties into platform_data
+ */
+static struct dwapb_gpio_platform_data *
+dwapb_gpio_get_pdata_of(struct device *dev)
+{
+	struct device_node *node, *port_np;
+	struct dwapb_gpio_platform_data *pdata;
+	struct dwapb_gpio_port_property *pp;
+	int nports;
+	int i;
+
+	node = dev->of_node;
+	if (!node)
+		return ERR_PTR(-ENODEV);
+
+	nports = of_get_child_count(node);
+	if (nports == 0)
+		return ERR_PTR(-ENODEV);
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	pdata->properties = devm_kcalloc(dev, nports, sizeof(*pp), GFP_KERNEL);
+	if (!pdata->properties)
+		return ERR_PTR(-ENOMEM);
+
+	pdata->nports = nports;
+
+	i = 0;
+	for_each_child_of_node(node, port_np) {
+		pp = &pdata->properties[i++];
+		pp->node = port_np;
+
+		if (of_property_read_u32(port_np, "reg", &pp->idx) ||
+		    pp->idx >= DWAPB_MAX_PORTS) {
+			dev_err(dev, "missing/invalid port index for %s\n",
+				port_np->full_name);
+			return ERR_PTR(-EINVAL);
+		}
+
+		if (of_property_read_u32(port_np, "snps,nr-gpios",
+					 &pp->ngpio)) {
+			dev_info(dev, "failed to get number of gpios for %s\n",
+				 port_np->full_name);
+			pp->ngpio = 32;
+		}
+
+		if (pp->idx == 0 &&
+		    of_property_read_bool(port_np, "interrupt-controller")) {
+			pp->irq = irq_of_parse_and_map(port_np, 0);
+			if (!pp->irq) {
+				dev_warn(dev, "no irq for bank %s\n",
+					 port_np->full_name);
+			}
+		} else {
+			pp->irq	= 0;
+		}
+
+		pp->irq_shared	= false;
+		pp->gpio_base	= 0;
+		pp->name	= port_np->full_name;
+	}
+
+	return pdata;
+}
+#else
+static inline struct dwapb_gpio_platform_data *
+dwapb_gpio_get_pdata_of(struct device *dev)
+{
+	return ERR_PTR(-ENODEV);
+}
+#endif
+
 static int dwapb_gpio_probe(struct platform_device *pdev)
 {
+	int i;
 	struct resource *res;
 	struct dwapb_gpio *gpio;
-	struct device_node *np;
 	int err;
-	unsigned int offs = 0;
+	struct device *dev = &pdev->dev;
+	const struct dwapb_gpio_platform_data *pdata = dev_get_platdata(dev);
+
+	if (!pdata) {
+		pdata = dwapb_gpio_get_pdata_of(dev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+	}
+	if (!pdata->nports)
+		return -ENODEV;
 
 	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
 	if (!gpio)
 		return -ENOMEM;
 	gpio->dev = &pdev->dev;
+	gpio->pdata = pdata;
 
-	gpio->nr_ports = of_get_child_count(pdev->dev.of_node);
-	if (!gpio->nr_ports) {
-		err = -EINVAL;
-		goto out_err;
-	}
-	gpio->ports = devm_kzalloc(&pdev->dev, gpio->nr_ports *
+	gpio->ports = devm_kcalloc(&pdev->dev, pdata->nports,
 				   sizeof(*gpio->ports), GFP_KERNEL);
 	if (!gpio->ports) {
 		err = -ENOMEM;
@@ -394,8 +485,8 @@ static int dwapb_gpio_probe(struct platform_device *pdev)
 		goto out_err;
 	}
 
-	for_each_child_of_node(pdev->dev.of_node, np) {
-		err = dwapb_gpio_add_port(gpio, np, offs++);
+	for (i = 0; i < pdata->nports; i++) {
+		err = dwapb_gpio_add_port(gpio, &pdata->properties[i], i);
 		if (err)
 			goto out_unregister;
 	}
diff --git a/include/linux/platform_data/gpio-dwapb.h b/include/linux/platform_data/gpio-dwapb.h
new file mode 100644
index 0000000..1f1ce3a
--- /dev/null
+++ b/include/linux/platform_data/gpio-dwapb.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef GPIO_DW_APB_H
+#define GPIO_DW_APB_H
+
+struct dwapb_gpio_port_property {
+	struct device_node *node;
+	const char	*name;
+	unsigned int	idx;
+	unsigned int	ngpio;
+	unsigned int	gpio_base;
+	unsigned int	irq;
+	bool		irq_shared;
+};
+
+struct dwapb_gpio_platform_data {
+	struct dwapb_gpio_port_property *properties;
+	unsigned int nports;
+};
+
+#endif
-- 
1.7.9.5

