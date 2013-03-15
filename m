Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3CONqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:46:11 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:29861 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754890Ab3CONqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:46:07 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Subject: [PATCH v5 2/3] gpio: grgpio: Add device driver for GRGPIO cores
Date: Fri, 15 Mar 2013 14:45:39 +0100
Message-Id: <1363355140-28216-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP
core library from Aeroflex Gaisler.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 .../devicetree/bindings/gpio/gpio-grgpio.txt       |   24 +++
 drivers/gpio/Kconfig                               |    9 ++
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-grgpio.c                         |  164 ++++++++++++++++++++
 4 files changed, 198 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
 create mode 100644 drivers/gpio/gpio-grgpio.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
new file mode 100644
index 0000000..1050dc8
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
@@ -0,0 +1,24 @@
+Aeroflex Gaisler GRGPIO General Purpose I/O cores.
+
+The GRGPIO GPIO core is available in the GRLIB VHDL IP core library.
+
+Note: In the ordinary environment for the GRGPIO core, a Leon SPARC system,
+these properties are built from information in the AMBA plug&play.
+
+Required properties:
+
+- name : Should be "GAISLER_GPIO" or "01_01a"
+
+- reg : Address and length of the register set for the device
+
+- interrupts : Interrupt numbers for this device
+
+Optional properties:
+
+- base : The base gpio number for the core. A dynamic base is used if not
+	present
+
+- nbits : The number of gpio lines. If not present driver assumes 32 lines.
+
+For further information look in the documentation for the GLIB IP core library:
+http://www.gaisler.com/products/grlib/grip.pdf
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..32f068d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -309,6 +309,15 @@ config GPIO_LYNXPOINT
 	  driver for GPIO functionality on Intel Lynxpoint PCH chipset
 	  Requires ACPI device enumeration code to set up a platform device.
 
+config GPIO_GRGPIO
+	tristate "Aeroflex Gaisler GRGPIO support"
+	depends on OF
+	select GPIO_GENERIC
+	select IRQ_DOMAIN
+	help
+	  Select this to support Aeroflex Gaisler GRGPIO cores from the GRLIB
+	  VHDL IP core library.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_ARIZONA
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 22e07bc..3e6be51 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_GE_FPGA)	+= gpio-ge.o
+obj-$(CONFIG_GPIO_GRGPIO)	+= gpio-grgpio.o
 obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
new file mode 100644
index 0000000..f8902da
--- /dev/null
+++ b/drivers/gpio/gpio-grgpio.c
@@ -0,0 +1,164 @@
+/*
+ * Driver for Aeroflex Gaisler GRGPIO General Purpose I/O cores.
+ *
+ * 2013 (c) Aeroflex Gaisler AB
+ *
+ * This driver supports the GRGPIO GPIO core available in the GRLIB VHDL
+ * IP core library.
+ *
+ * Full documentation of the GRGPIO core can be found here:
+ * http://www.gaisler.com/products/grlib/grip.pdf
+ *
+ * See "Documentation/devicetree/bindings/gpio/gpio-grgpio.txt" for
+ * information on open firmware properties.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * Contributors: Andreas Larsson <andreas@gaisler.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/of_platform.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/basic_mmio_gpio.h>
+
+#define GRGPIO_MAX_NGPIO 32
+
+struct grgpio_regs {
+	u32 data;	/* 0x00 */
+	u32 output;	/* 0x04 */
+	u32 dir;	/* 0x08 */
+	u32 imask;	/* 0x0c */
+	u32 ipol;	/* 0x10  */
+	u32 iedge;	/* 0x14 */
+	u32 bypass;	/* 0x18 */
+	u32 __reserved;	/* 0x1c */
+	u32 imap[8];	/* 0x20-0x3c */
+};
+
+struct grgpio_priv {
+	struct bgpio_chip bgc;
+	struct grgpio_regs __iomem *regs;
+	struct device *dev;
+};
+
+static inline struct grgpio_priv *grgpio_gc_to_priv(struct gpio_chip *gc)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+
+	return container_of(bgc, struct grgpio_priv, bgc);
+}
+
+static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	return -ENXIO;
+}
+
+static int grgpio_probe(struct platform_device *ofdev)
+{
+	struct device_node *np = ofdev->dev.of_node;
+	struct grgpio_regs __iomem *regs;
+	struct gpio_chip *gc;
+	struct bgpio_chip *bgc;
+	struct grgpio_priv *priv;
+	struct resource *res;
+	int err;
+	u32 prop;
+
+	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
+	regs = devm_ioremap_resource(&ofdev->dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	bgc = &priv->bgc;
+	err = bgpio_init(bgc, &ofdev->dev, 4, &regs->data, &regs->output, NULL,
+			 &regs->dir, NULL, BGPIOF_BIG_ENDIAN_BYTE_ORDER);
+	if (err) {
+		dev_err(&ofdev->dev, "bgpio_init() failed\n");
+		return err;
+	}
+
+	priv->regs = regs;
+	priv->dev = &ofdev->dev;
+
+	gc = &bgc->gc;
+	gc->of_node = np;
+	gc->owner = THIS_MODULE;
+	gc->to_irq = grgpio_to_irq;
+	gc->label = np->full_name;
+
+	err = of_property_read_u32(np, "base", &prop);
+	if (err) {
+		dev_dbg(&ofdev->dev, "No base property: use dynamic base\n");
+		gc->base = -1;
+	} else {
+		gc->base = prop;
+	}
+
+	err = of_property_read_u32(np, "nbits", &prop);
+	if (err || prop <= 0 || prop > GRGPIO_MAX_NGPIO) {
+		gc->ngpio = GRGPIO_MAX_NGPIO;
+		dev_dbg(&ofdev->dev,
+			"No or invalid nbits property: assume %d\n", gc->ngpio);
+	} else {
+		gc->ngpio = prop;
+	}
+
+	platform_set_drvdata(ofdev, priv);
+
+	err = gpiochip_add(gc);
+	if (err) {
+		dev_err(&ofdev->dev, "Could not add gpiochip\n");
+		return err;
+	}
+
+	dev_info(&ofdev->dev, "regs=0x%p, base=%d, ngpio=%d\n",
+		 priv->regs, gc->base, gc->ngpio);
+
+	return 0;
+}
+
+static int grgpio_remove(struct platform_device *ofdev)
+{
+	struct grgpio_priv *priv = platform_get_drvdata(ofdev);
+
+	return gpiochip_remove(&priv->bgc.gc);
+}
+
+static struct of_device_id grgpio_match[] = {
+	{.name = "GAISLER_GPIO"},
+	{.name = "01_01a"},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, grgpio_match);
+
+static struct platform_driver grgpio_driver = {
+	.driver = {
+		.name = "grgpio",
+		.owner = THIS_MODULE,
+		.of_match_table = grgpio_match,
+	},
+	.probe = grgpio_probe,
+	.remove = grgpio_remove,
+};
+module_platform_driver(grgpio_driver);
+
+MODULE_AUTHOR("Aeroflex Gaisler AB.");
+MODULE_DESCRIPTION("Driver for Aeroflex Gaisler GRGPIO");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

