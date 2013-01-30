Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3A3M3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:29:00 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:54373 "HELO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752478Ab3A3M26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:28:58 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: [PATCH] gpio: Add device driver for GRGPIO cores
Date: Wed, 30 Jan 2013 13:28:41 +0100
Message-Id: <1359548921-14925-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports GRGPIO gpio cores available in the GRLIB VHDL IP core
library.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/gpio/Kconfig       |    7 +
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/gpio-grgpio.c |  313 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 321 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-grgpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 682de75..4ce4626 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -298,6 +298,13 @@ config GPIO_GE_FPGA
 	  and write pin state) for GPIO implemented in a number of GE single
 	  board computers.
 
+config GPIO_GRGPIO
+	tristate "Aeroflex Gaisler GRGPIO support"
+	depends on OF
+	help
+	  Select this to support Aeroflex Gaisler GRGPIO cores from the GRLIB
+	  VHDL IP core library.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_ARIZONA
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index c5aebd0..ca5d7a3 100644
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
index 0000000..1e367c0
--- /dev/null
+++ b/drivers/gpio/gpio-grgpio.c
@@ -0,0 +1,313 @@
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
+#define GRGPIO_IN	0
+#define GRGPIO_OUT	1
+
+struct grgpio_priv {
+	struct gpio_chip gc;
+	struct device *dev;
+	struct grgpio_regs __iomem *regs;
+
+	u32 output;	/* output shadow register */
+	u32 dir;	/* direction shadow register */
+	u32 imask;	/* irq mask shadow register */
+
+	s32 *irqmap;
+
+	spinlock_t lock; /* Protecting concurrent shadow & register changes */
+};
+
+static inline struct grgpio_priv *grgpio_chip_to_priv(struct gpio_chip *gc)
+{
+	return container_of(gc, struct grgpio_priv, gc);
+}
+
+#if defined(__BIG_ENDIAN)
+static inline u32 grgpio_read_reg(u32 __iomem *reg)
+{
+	return ioread32be(reg);
+}
+
+static inline void grgpio_write_reg(u32 __iomem *reg, u32 val)
+{
+	iowrite32be(val, reg);
+}
+#else
+static inline u32 grgpio_read_reg(u32 __iomem *reg)
+{
+	return ioread32(reg);
+}
+
+static inline void grgpio_write_reg(u32 __iomem *reg, u32 val)
+{
+	iowrite32(val, reg);
+}
+#endif
+
+static void grgpio_set_sbit(struct grgpio_priv *priv, u32 __iomem *reg,
+			   unsigned offset, int val, u32 *shadow)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	if (val)
+		*shadow |= (1 << offset);
+	else
+		*shadow &= ~(1 << offset);
+	grgpio_write_reg(reg, *shadow);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+/* ------------------------------------------------------------ */
+
+static int grgpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct grgpio_priv *priv = grgpio_chip_to_priv(gc);
+
+	return (grgpio_read_reg(&priv->regs->data) >> offset) & 1;
+}
+
+static void grgpio_set(struct gpio_chip *gc, unsigned offset, int val)
+{
+	struct grgpio_priv *priv = grgpio_chip_to_priv(gc);
+
+	grgpio_set_sbit(priv, &priv->regs->output, offset, val, &priv->output);
+}
+
+
+static int grgpio_get_dir(struct gpio_chip *gc, unsigned offset)
+{
+	struct grgpio_priv *priv = grgpio_chip_to_priv(gc);
+
+	return (priv->dir >> offset) & 1;
+}
+
+static int grgpio_dir_in(struct gpio_chip *gc, unsigned offset)
+{
+	struct grgpio_priv *priv = grgpio_chip_to_priv(gc);
+
+	grgpio_set_sbit(priv, &priv->regs->dir, offset, GRGPIO_IN, &priv->dir);
+	return 0;
+}
+
+static int grgpio_dir_out(struct gpio_chip *gc, unsigned offset, int val)
+{
+	struct grgpio_priv *priv = grgpio_chip_to_priv(gc);
+
+	grgpio_set(gc, offset, val);
+	grgpio_set_sbit(priv, &priv->regs->dir, offset, GRGPIO_OUT, &priv->dir);
+	return 0;
+}
+
+static int grgpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct grgpio_priv *priv = grgpio_chip_to_priv(gc);
+	struct grgpio_regs *regs = priv->regs;
+	int index, irq;
+
+	if (!priv->irqmap || offset > gc->ngpio)
+		return -ENXIO;
+
+	index = priv->irqmap[offset];
+	if (index < 0)
+		return -ENXIO;
+
+	irq = irq_of_parse_and_map(priv->dev->of_node, index);
+	if (irq) {
+		/* Enable interrupt and return irq */
+		grgpio_set_sbit(priv, &regs->imask, offset, 1, &priv->imask);
+		return irq;
+	} else {
+		return -ENXIO;
+	}
+}
+
+static void grgpio_free(struct gpio_chip *gc, unsigned offset)
+{
+	struct grgpio_priv *priv = grgpio_chip_to_priv(gc);
+	struct grgpio_regs *regs = priv->regs;
+
+	if (unlikely(priv->imask & (1 << offset)))
+		grgpio_set_sbit(priv, &regs->imask, offset, 0, &priv->imask);
+}
+
+static int grgpio_probe(struct platform_device *ofdev)
+{
+	struct device_node *np = ofdev->dev.of_node;
+	struct grgpio_regs __iomem *regs;
+	struct gpio_chip *gc;
+	struct grgpio_priv *priv;
+	struct resource *res;
+	int err, i, size;
+	u32 prop;
+	s32 *irqmap;
+
+	priv = devm_kzalloc(&ofdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&ofdev->dev, "Could not allocate priv\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
+	regs = devm_request_and_ioremap(&ofdev->dev, res);
+	if (!regs) {
+		dev_err(&ofdev->dev, "Couldn't map registers\n");
+		return -EADDRNOTAVAIL;
+	}
+
+	spin_lock_init(&priv->lock);
+
+	priv->dev = &ofdev->dev;
+	priv->regs = regs;
+	priv->output = grgpio_read_reg(&regs->output);
+	priv->dir = grgpio_read_reg(&regs->dir);
+	priv->imask = grgpio_read_reg(&regs->imask);
+
+	gc = &priv->gc;
+	gc->dev = &ofdev->dev;
+	gc->of_node = np;
+	gc->owner = THIS_MODULE;
+	gc->get = grgpio_get;
+	gc->set = grgpio_set;
+	gc->get_direction = grgpio_get_dir;
+	gc->direction_input = grgpio_dir_in;
+	gc->direction_output = grgpio_dir_out;
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
+		if (!priv->irqmap) {
+			dev_err(&ofdev->dev,
+				"Could not allocate memory for irqmap\n");
+			return -ENOMEM;
+		}
+		for (i = 0; i < gc->ngpio; i++)
+			priv->irqmap[i] = irqmap[i];
+	} else {
+		dev_dbg(&ofdev->dev, "No irqmap\n");
+	}
+
+
+	/* OK if this fails */
+	gc->label = kstrdup(np->full_name, GFP_KERNEL);
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

