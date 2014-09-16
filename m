Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaIPB3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:29:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:50501 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaIPB30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:29:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,532,1406617200"; 
   d="scan'208";a="477747344"
From: Weike Chen <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Alvin Chen <alvin.chen@intel.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/4 v4] GPIO: gpio-dwapb: Enable platform driver binding to MFD driver
Date: Tue, 16 Sep 2014 02:22:12 -0700
Message-Id: <1410859335-11080-2-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Synopsys DesignWare APB GPIO driver only supports open firmware devices.
But, like Intel Quark X1000 SOC, which has a single PCI function exporting
a GPIO and an I2C controller, it is a Multifunction device. This patch is
to enable the current Synopsys DesignWare APB GPIO driver to support the
Multifunction device which exports the designware GPIO controller.

Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
Signed-off-by: Weike Chen <alvin.chen@intel.com>
---
 drivers/gpio/Kconfig                     |    1 -
 drivers/gpio/gpio-dwapb.c                |  226 ++++++++++++++++++++++--------
 include/linux/platform_data/gpio-dwapb.h |   32 +++++
 3 files changed, 201 insertions(+), 58 deletions(-)
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
index d6618a6..a62467a 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -21,6 +21,8 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
+#include <linux/platform_data/gpio-dwapb.h>
+#include <linux/slab.h>
 
 #define GPIO_SWPORTA_DR		0x00
 #define GPIO_SWPORTA_DDR	0x04
@@ -84,11 +86,10 @@ static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
 	writel(v, gpio->regs + GPIO_INT_POLARITY);
 }
 
-static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
+static u32 dwapb_do_irq(struct dwapb_gpio *gpio)
 {
-	struct dwapb_gpio *gpio = irq_get_handler_data(irq);
-	struct irq_chip *chip = irq_desc_get_chip(desc);
 	u32 irq_status = readl_relaxed(gpio->regs + GPIO_INTSTATUS);
+	u32 ret = irq_status;
 
 	while (irq_status) {
 		int hwirq = fls(irq_status) - 1;
@@ -102,6 +103,16 @@ static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
 			dwapb_toggle_trigger(gpio, hwirq);
 	}
 
+	return ret;
+}
+
+static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
+{
+	struct dwapb_gpio *gpio = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+
+	dwapb_do_irq(gpio);
+
 	if (chip->irq_eoi)
 		chip->irq_eoi(irq_desc_get_irq_data(desc));
 }
@@ -207,22 +218,26 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 	return 0;
 }
 
+static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id)
+{
+	u32 worked;
+	struct dwapb_gpio *gpio = dev_id;
+
+	worked = dwapb_do_irq(gpio);
+
+	return worked ? IRQ_HANDLED : IRQ_NONE;
+}
+
 static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
-				 struct dwapb_gpio_port *port)
+				 struct dwapb_gpio_port *port,
+				 struct dwapb_port_property *pp)
 {
 	struct gpio_chip *gc = &port->bgc.gc;
-	struct device_node *node =  gc->of_node;
-	struct irq_chip_generic	*irq_gc;
+	struct device_node *node = pp->node;
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
@@ -269,8 +284,24 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	irq_gc->chip_types[1].type = IRQ_TYPE_EDGE_BOTH;
 	irq_gc->chip_types[1].handler = handle_edge_irq;
 
-	irq_set_chained_handler(irq, dwapb_irq_handler);
-	irq_set_handler_data(irq, gpio);
+	if (!pp->irq_shared) {
+		irq_set_chained_handler(pp->irq, dwapb_irq_handler);
+		irq_set_handler_data(pp->irq, gpio);
+	} else {
+		/*
+		 * Request a shared IRQ since where MFD would have devices
+		 * using the same irq pin
+		 */
+		err = devm_request_irq(gpio->dev, pp->irq,
+				       dwapb_irq_handler_mfd,
+				       IRQF_SHARED, "gpio-dwapb-mfd", gpio);
+		if (err) {
+			dev_err(gpio->dev, "error requesting IRQ\n");
+			irq_domain_remove(gpio->domain);
+			gpio->domain = NULL;
+			return;
+		}
+	}
 
 	for (hwirq = 0 ; hwirq < ngpio ; hwirq++)
 		irq_create_mapping(gpio->domain, hwirq);
@@ -296,57 +327,42 @@ static void dwapb_irq_teardown(struct dwapb_gpio *gpio)
 }
 
 static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
-			       struct device_node *port_np,
+			       struct dwapb_port_property *pp,
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
+#ifdef CONFIG_OF_GPIO
+	port->bgc.gc.of_node = pp->node;
+#endif
+	port->bgc.gc.ngpio = pp->ngpio;
+	port->bgc.gc.base = pp->gpio_base;
 
-	/*
-	 * Only port A can provide interrupts in all configurations of the IP.
-	 */
-	if (port_idx == 0 &&
-	    of_property_read_bool(port_np, "interrupt-controller"))
-		dwapb_configure_irqs(gpio, port);
+	if (pp->irq)
+		dwapb_configure_irqs(gpio, port, pp);
 
 	err = gpiochip_add(&port->bgc.gc);
 	if (err)
 		dev_err(gpio->dev, "failed to register gpiochip for %s\n",
-			port_np->full_name);
+			pp->name);
 	else
 		port->is_registered = true;
 
@@ -362,25 +378,118 @@ static void dwapb_gpio_unregister(struct dwapb_gpio *gpio)
 			gpiochip_remove(&gpio->ports[m].bgc.gc);
 }
 
+static struct dwapb_platform_data *
+dwapb_gpio_get_pdata_of(struct device *dev)
+{
+	struct device_node *node, *port_np;
+	struct dwapb_platform_data *pdata;
+	struct dwapb_port_property *pp;
+	int nports;
+	int i;
+
+	node = dev->of_node;
+	if (!IS_ENABLED(CONFIG_OF_GPIO) || !node)
+		return ERR_PTR(-ENODEV);
+
+	nports = of_get_child_count(node);
+	if (nports == 0)
+		return ERR_PTR(-ENODEV);
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	pdata->properties = kcalloc(nports, sizeof(*pp), GFP_KERNEL);
+	if (!pdata->properties) {
+		kfree(pdata);
+		return ERR_PTR(-ENOMEM);
+	}
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
+			kfree(pdata->properties);
+			kfree(pdata);
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
+		/*
+		 * Only port A can provide interrupts in all configurations of
+		 * the IP.
+		 */
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
+		pp->gpio_base	= -1;
+		pp->name	= port_np->full_name;
+	}
+
+	return pdata;
+}
+
+static inline void dwapb_free_pdata_of(struct dwapb_platform_data *pdata)
+{
+	if (!IS_ENABLED(CONFIG_OF_GPIO) || !pdata)
+		return;
+
+	kfree(pdata->properties);
+	kfree(pdata);
+}
+
 static int dwapb_gpio_probe(struct platform_device *pdev)
 {
+	unsigned int i;
 	struct resource *res;
 	struct dwapb_gpio *gpio;
-	struct device_node *np;
 	int err;
-	unsigned int offs = 0;
+	struct device *dev = &pdev->dev;
+	struct dwapb_platform_data *pdata = dev_get_platdata(dev);
+	bool is_pdata_alloc = !pdata;
+
+	if (is_pdata_alloc) {
+		pdata = dwapb_gpio_get_pdata_of(dev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+	}
 
-	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
-	if (!gpio)
-		return -ENOMEM;
-	gpio->dev = &pdev->dev;
+	if (!pdata->nports) {
+		err = -ENODEV;
+		goto out_err;
+	}
 
-	gpio->nr_ports = of_get_child_count(pdev->dev.of_node);
-	if (!gpio->nr_ports) {
-		err = -EINVAL;
+	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
+	if (!gpio) {
+		err = -ENOMEM;
 		goto out_err;
 	}
-	gpio->ports = devm_kzalloc(&pdev->dev, gpio->nr_ports *
+	gpio->dev = &pdev->dev;
+	gpio->nr_ports = pdata->nports;
+
+	gpio->ports = devm_kcalloc(&pdev->dev, gpio->nr_ports,
 				   sizeof(*gpio->ports), GFP_KERNEL);
 	if (!gpio->ports) {
 		err = -ENOMEM;
@@ -394,20 +503,23 @@ static int dwapb_gpio_probe(struct platform_device *pdev)
 		goto out_err;
 	}
 
-	for_each_child_of_node(pdev->dev.of_node, np) {
-		err = dwapb_gpio_add_port(gpio, np, offs++);
+	for (i = 0; i < gpio->nr_ports; i++) {
+		err = dwapb_gpio_add_port(gpio, &pdata->properties[i], i);
 		if (err)
 			goto out_unregister;
 	}
 	platform_set_drvdata(pdev, gpio);
 
-	return 0;
+	goto out_err;
 
 out_unregister:
 	dwapb_gpio_unregister(gpio);
 	dwapb_irq_teardown(gpio);
 
 out_err:
+	if (is_pdata_alloc)
+		dwapb_free_pdata_of(pdata);
+
 	return err;
 }
 
diff --git a/include/linux/platform_data/gpio-dwapb.h b/include/linux/platform_data/gpio-dwapb.h
new file mode 100644
index 0000000..28702c8
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
+struct dwapb_port_property {
+	struct device_node *node;
+	const char	*name;
+	unsigned int	idx;
+	unsigned int	ngpio;
+	unsigned int	gpio_base;
+	unsigned int	irq;
+	bool		irq_shared;
+};
+
+struct dwapb_platform_data {
+	struct dwapb_port_property *properties;
+	unsigned int nports;
+};
+
+#endif
-- 
1.7.9.5

