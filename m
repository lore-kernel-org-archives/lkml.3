Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3BLHZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 02:25:09 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:28620 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752973Ab3BLHZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 02:25:07 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Subject: [PATCH v3] gpio: Add device driver for GRGPIO cores and support custom accessors with gpio-generic
Date: Tue, 12 Feb 2013 08:24:33 +0100
Message-Id: <1360653873-25368-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP
core library from Aeroflex Gaisler.

This also adds support to gpio-generic for using custom accessor
functions. The grgpio driver uses this to use ioread32be and iowrite32be
for big endian register accesses.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 .../devicetree/bindings/gpio/gpio-grgpio.txt       |   29 +++
 drivers/gpio/Kconfig                               |    8 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-generic.c                        |   26 ++-
 drivers/gpio/gpio-grgpio.c                         |  255 ++++++++++++++++++++
 5 files changed, 310 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
 create mode 100644 drivers/gpio/gpio-grgpio.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
new file mode 100644
index 0000000..36f456f
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-grgpio.txt
@@ -0,0 +1,29 @@
+Aeroflex Gaisler GRGPIO General Purpose I/O cores.
+
+The GRGPIO GPIO core is available in the GRLIB VHDL IP core library.
+
+Note: In the ordinary ordinary environment for the GRGPIO core, a Leon SPARC
+system, these properties are built from information in the AMBA plug&play.
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
+- irqmap : An array with an index for each gpio line. An index is either a valid
+	index into the interrupts property array, or 0xffffffff that indicates
+	no irq for that line. Driver provides no interrupt support if not
+	present.
+
+For further information look in the documentation for the GLIB IP core library:
+http://www.gaisler.com/products/grlib/grip.pdf
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index ab97eb8..5472778 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -309,6 +309,14 @@ config GPIO_LYNXPOINT
 	  driver for GPIO functionality on Intel Lynxpoint PCH chipset
 	  Requires ACPI device enumeration code to set up a platform device.
 
+config GPIO_GRGPIO
+	tristate "Aeroflex Gaisler GRGPIO support"
+	depends on OF
+	select GPIO_GENERIC
+	help
+	  Select this to support Aeroflex Gaisler GRGPIO cores from the GRLIB
+	  VHDL IP core library.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_ARIZONA
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 4398034..f3b49a2 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_GE_FPGA)	+= gpio-ge.o
+obj-$(CONFIG_GPIO_GRGPIO)	+= gpio-grgpio.o
 obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 05fcc0f..f854799 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -251,24 +251,25 @@ static int bgpio_setup_accessors(struct device *dev,
 				 struct bgpio_chip *bgc,
 				 bool be)
 {
+	struct bgpio_chip def;
 
 	switch (bgc->bits) {
 	case 8:
-		bgc->read_reg	= bgpio_read8;
-		bgc->write_reg	= bgpio_write8;
+		def.read_reg	= bgpio_read8;
+		def.write_reg	= bgpio_write8;
 		break;
 	case 16:
-		bgc->read_reg	= bgpio_read16;
-		bgc->write_reg	= bgpio_write16;
+		def.read_reg	= bgpio_read16;
+		def.write_reg	= bgpio_write16;
 		break;
 	case 32:
-		bgc->read_reg	= bgpio_read32;
-		bgc->write_reg	= bgpio_write32;
+		def.read_reg	= bgpio_read32;
+		def.write_reg	= bgpio_write32;
 		break;
 #if BITS_PER_LONG >= 64
 	case 64:
-		bgc->read_reg	= bgpio_read64;
-		bgc->write_reg	= bgpio_write64;
+		def.read_reg	= bgpio_read64;
+		def.write_reg	= bgpio_write64;
 		break;
 #endif /* BITS_PER_LONG >= 64 */
 	default:
@@ -276,7 +277,14 @@ static int bgpio_setup_accessors(struct device *dev,
 		return -EINVAL;
 	}
 
-	bgc->pin2mask = be ? bgpio_pin2mask_be : bgpio_pin2mask;
+	def.pin2mask = be ? bgpio_pin2mask_be : bgpio_pin2mask;
+
+	if (!bgc->read_reg)
+		bgc->read_reg = def.read_reg;
+	if (!bgc->write_reg)
+		bgc->write_reg = def.write_reg;
+	if (!bgc->pin2mask)
+		bgc->pin2mask = def.pin2mask;
 
 	return 0;
 }
diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
new file mode 100644
index 0000000..51db42e
--- /dev/null
+++ b/drivers/gpio/gpio-grgpio.c
@@ -0,0 +1,255 @@
+/*
+ * Driver for Aeroflex Gaisler GRGPIO General Purpose I/O cores.
+ *
+ * 2013 (c) Aeroflex Gaisler AB
+ *
+ * This driver supports the GRGPIO GPIO core available in the GRLIB VHDL IP core
+ * library.
+ *
+ * Full documentation of the GRGPIO core can be found here:
+ * http://www.gaisler.com/products/grlib/grip.pdf
+ *
+ * See "Documentation/devicetree/bindings/gpio/gpio-grgpio.txt" for information
+ * on open firmware properties.
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
+#include <linux/of_irq.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include <linux/basic_mmio_gpio.h>
+
+#define DRV_NAME	"grgpio"
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
+
+	u32 imask;	/* irq mask shadow register */
+	s32 *irqmap;	/* maps offset to irq or -1 if no irq */
+};
+
+static unsigned long  grgpio_read_reg(void __iomem *reg)
+{
+	return ioread32be(reg);
+}
+
+static void grgpio_write_reg(void __iomem *reg, unsigned long data)
+{
+	iowrite32be(data, reg);
+}
+
+static inline struct grgpio_priv *grgpio_gc_to_priv(struct gpio_chip *gc)
+{
+	struct bgpio_chip *bgc = to_bgpio_chip(gc);
+	return container_of(bgc, struct grgpio_priv, bgc);
+}
+
+static void grgpio_set_imask(struct grgpio_priv *priv, unsigned int offset,
+			     int val)
+{
+	struct bgpio_chip *bgc = &priv->bgc;
+	unsigned long mask = bgc->pin2mask(bgc, offset);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+
+	if (val)
+		priv->imask |= mask;
+	else
+		priv->imask &= ~mask;
+	bgc->write_reg(&priv->regs->imask, priv->imask);
+
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
+
+static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct grgpio_priv *priv = grgpio_gc_to_priv(gc);
+	int index, irq;
+
+	if (!priv->irqmap || offset > gc->ngpio)
+		return -ENXIO;
+
+	index = priv->irqmap[offset];
+	if (index < 0)
+		return -ENXIO;
+
+	irq = irq_of_parse_and_map(priv->bgc.gc.dev->of_node, index);
+	if (irq) {
+		/* Enable interrupt and return irq */
+		grgpio_set_imask(priv, offset, 1);
+		return irq;
+	} else {
+		return -ENXIO;
+	}
+}
+
+static void grgpio_free(struct gpio_chip *gc, unsigned offset)
+{
+	struct grgpio_priv *priv = grgpio_gc_to_priv(gc);
+	struct bgpio_chip *bgc = &priv->bgc;
+	unsigned long mask = bgc->pin2mask(bgc, offset);
+
+	if (unlikely(priv->imask & mask))
+		grgpio_set_imask(priv, offset, 0);
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
+	int err, i, size;
+	u32 prop;
+	s32 *irqmap;
+	char *label;
+
+	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
+	regs = devm_request_and_ioremap(&ofdev->dev, res);
+	if (!regs) {
+		dev_err(&ofdev->dev, "Couldn't map registers\n");
+		return -EADDRNOTAVAIL;
+	}
+
+	bgc = &priv->bgc;
+	bgc->read_reg = grgpio_read_reg;
+	bgc->write_reg = grgpio_write_reg;
+	err = bgpio_init(bgc, &ofdev->dev, 4, &regs->data, &regs->output, NULL,
+			 &regs->dir, NULL, 0);
+	if (err) {
+		dev_err(&ofdev->dev, "bgpio_init() failed\n");
+		return err;
+	}
+
+	priv->regs = regs;
+	priv->imask = bgc->read_reg(&regs->imask);
+
+	gc = &bgc->gc;
+	gc->of_node = np;
+	gc->owner = THIS_MODULE;
+	gc->to_irq = grgpio_to_irq;
+	gc->free = grgpio_free;
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
+	irqmap = (s32 *)of_get_property(np, "irqmap", &size);
+	if (irqmap) {
+		if (size < gc->ngpio) {
+			dev_err(&ofdev->dev,
+				"irqmap shorter than ngpio (%d < %d)\n",
+				size, gc->ngpio);
+			return -EINVAL;
+		}
+
+		priv->irqmap = devm_kzalloc(&ofdev->dev,
+					    gc->ngpio * sizeof(s32),
+					    GFP_KERNEL);
+		if (!priv->irqmap)
+			return -ENOMEM;
+
+		for (i = 0; i < gc->ngpio; i++)
+			priv->irqmap[i] = irqmap[i];
+	} else {
+		dev_dbg(&ofdev->dev, "No irqmap\n");
+	}
+
+	label = kstrdup(np->full_name, GFP_KERNEL);
+	if (label)
+		gc->label = label;
+
+	platform_set_drvdata(ofdev, priv);
+
+	err = gpiochip_add(gc);
+	if (err) {
+		dev_err(&ofdev->dev, "Couldn't add gpiochip\n");
+		return err;
+	}
+
+	dev_info(&ofdev->dev, "regs=0x%p, base=%d, npgio=%d\n",
+		 priv->regs, gc->base, gc->ngpio);
+
+	return 0;
+}
+
+static int grgpio_remove(struct platform_device *ofdev)
+{
+	dev_set_drvdata(&ofdev->dev, NULL);
+
+	return 0;
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
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = grgpio_match,
+	},
+	.probe = grgpio_probe,
+	.remove = grgpio_remove,
+};
+
+module_platform_driver(grgpio_driver);
+
+MODULE_AUTHOR("Aeroflex Gaisler AB.");
+MODULE_DESCRIPTION("Driver for Aeroflex Gaisler GRGPIO");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

