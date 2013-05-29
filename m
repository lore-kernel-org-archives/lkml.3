Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543Ab3E2L10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:27:26 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:39812 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965468Ab3E2L1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:27:24 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/2] GPIO: Add support for dual channel in gpio-xilinx.c
Date: Wed, 29 May 2013 13:27:07 +0200
Message-Id: <4b90b06fce0475b579cfba4d968b4778359154f6.1369826814.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-12799-1369826828-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-12799-1369826828-0001

Supporting the second channel in the driver.
Offset is 0x8 and both channnels share the same
IRQ.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/gpio/gpio-xilinx.c | 93 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 9ae7aa8..385dcb0 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -1,7 +1,7 @@
 /*
- * Xilinx gpio driver
+ * Xilinx gpio driver for xps/axi_gpio IP.
  *
- * Copyright 2008 Xilinx, Inc.
+ * Copyright 2008 - 2013 Xilinx, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2
@@ -26,10 +26,17 @@
 #define XGPIO_DATA_OFFSET   (0x0)	/* Data register  */
 #define XGPIO_TRI_OFFSET    (0x4)	/* I/O direction register  */

+#define XGPIO_CHANNEL_OFFSET	0x8
+
+/* Read/Write access to the GPIO registers */
+#define xgpio_readreg(offset)		__raw_readl(offset)
+#define xgpio_writereg(offset, val)	__raw_writel(val, offset)
+
 struct xgpio_instance {
 	struct of_mm_gpio_chip mmchip;
 	u32 gpio_state;		/* GPIO state shadow register */
 	u32 gpio_dir;		/* GPIO direction shadow register */
+	u32 offset;
 	spinlock_t gpio_lock;	/* Lock used for synchronization */
 };

@@ -44,8 +51,12 @@ struct xgpio_instance {
 static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	void __iomem *regs = mm_gc->regs + chip->offset;

-	return (in_be32(mm_gc->regs + XGPIO_DATA_OFFSET) >> gpio) & 1;
+	return (xgpio_readreg(regs + XGPIO_DATA_OFFSET) >> gpio) & 1;
 }

 /**
@@ -63,6 +74,7 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	void __iomem *regs = mm_gc->regs;

 	spin_lock_irqsave(&chip->gpio_lock, flags);

@@ -71,7 +83,9 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 		chip->gpio_state |= 1 << gpio;
 	else
 		chip->gpio_state &= ~(1 << gpio);
-	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+
+	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
+							 chip->gpio_state);

 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
 }
@@ -91,12 +105,13 @@ static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	void __iomem *regs = mm_gc->regs;

 	spin_lock_irqsave(&chip->gpio_lock, flags);

 	/* Set the GPIO bit in shadow register and set direction as input */
 	chip->gpio_dir |= (1 << gpio);
-	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	xgpio_writereg(regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);

 	spin_unlock_irqrestore(&chip->gpio_lock, flags);

@@ -119,6 +134,7 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	void __iomem *regs = mm_gc->regs;

 	spin_lock_irqsave(&chip->gpio_lock, flags);

@@ -127,11 +143,12 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 		chip->gpio_state |= 1 << gpio;
 	else
 		chip->gpio_state &= ~(1 << gpio);
-	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
+		       chip->gpio_state);

 	/* Clear the GPIO bit in shadow register and set direction as output */
 	chip->gpio_dir &= (~(1 << gpio));
-	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	xgpio_writereg(regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);

 	spin_unlock_irqrestore(&chip->gpio_lock, flags);

@@ -147,8 +164,10 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);

-	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
-	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	xgpio_writereg(mm_gc->regs + chip->offset + XGPIO_DATA_OFFSET,
+							chip->gpio_state);
+	xgpio_writereg(mm_gc->regs + chip->offset + XGPIO_TRI_OFFSET,
+							 chip->gpio_dir);
 }

 /**
@@ -183,9 +202,6 @@ static int xgpio_of_probe(struct device_node *np)
 	/* Check device node and parent device node for device width */
 	chip->mmchip.gc.ngpio = 32; /* By default assume full GPIO controller */
 	tree_info = of_get_property(np, "xlnx,gpio-width", NULL);
-	if (!tree_info)
-		tree_info = of_get_property(np->parent,
-					    "xlnx,gpio-width", NULL);
 	if (tree_info)
 		chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);

@@ -206,6 +222,59 @@ static int xgpio_of_probe(struct device_node *np)
 		       np->full_name, status);
 		return status;
 	}
+
+	pr_info("XGpio: %s: registered, base is %d\n", np->full_name,
+							chip->mmchip.gc.base);
+
+	tree_info = of_get_property(np, "xlnx,is-dual", NULL);
+	if (tree_info && be32_to_cpup(tree_info)) {
+		chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+		if (!chip)
+			return -ENOMEM;
+
+		/* Add dual channel offset */
+		chip->offset = XGPIO_CHANNEL_OFFSET;
+
+		/* Update GPIO state shadow register with default value */
+		tree_info = of_get_property(np, "xlnx,dout-default-2", NULL);
+		if (tree_info)
+			chip->gpio_state = be32_to_cpup(tree_info);
+
+		/* Update GPIO direction shadow register with default value */
+		/* By default, all pins are inputs */
+		chip->gpio_dir = 0xFFFFFFFF;
+		tree_info = of_get_property(np, "xlnx,tri-default-2", NULL);
+		if (tree_info)
+			chip->gpio_dir = be32_to_cpup(tree_info);
+
+		/* Check device node and parent device node for device width */
+		/* By default assume full GPIO controller */
+		chip->mmchip.gc.ngpio = 32;
+		tree_info = of_get_property(np, "xlnx,gpio2-width", NULL);
+		if (tree_info)
+			chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);
+
+		spin_lock_init(&chip->gpio_lock);
+
+		chip->mmchip.gc.direction_input = xgpio_dir_in;
+		chip->mmchip.gc.direction_output = xgpio_dir_out;
+		chip->mmchip.gc.get = xgpio_get;
+		chip->mmchip.gc.set = xgpio_set;
+
+		chip->mmchip.save_regs = xgpio_save_regs;
+
+		/* Call the OF gpio helper to setup and register the GPIO dev */
+		status = of_mm_gpiochip_add(np, &chip->mmchip);
+		if (status) {
+			kfree(chip);
+			pr_err("%s: error in probe function with status %d\n",
+			np->full_name, status);
+			return status;
+		}
+		pr_info("XGpio: %s: dual channel registered, base is %d\n",
+					np->full_name, chip->mmchip.gc.base);
+	}
+
 	return 0;
 }

--
1.8.2.3


--=_mimegpg-monstr-desktop-12799-1369826828-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGl5gwACgkQykllyylKDCGRvACeIqJtynVfJw+JwDRf2kFeZVff
UEoAoI8dLfXnRv92+Co/4HYrB5SeO6tu
=XIjI
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-12799-1369826828-0001--
