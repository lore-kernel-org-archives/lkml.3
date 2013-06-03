Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab3FCMcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:32:02 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50585 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab3FCMb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:31:58 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 2/6] GPIO: xilinx: Add support for dual channel
Date: Mon,  3 Jun 2013 14:31:17 +0200
Message-Id: <d678410ae1b6ff11a221a996f5aa4b4ee4ed01a5.1370262666.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
In-Reply-To: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-25567-1370262713-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-25567-1370262713-0001

Supporting the second channel in the driver.
Offset is 0x8 and both channnels share the same
IRQ.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>

---
Changes in v2:
- Use kernel doc format - suggested by Linus Walleij
- Do not use __raw_readl/__raw_writel IO in this patch
- Use of_property_read_u32 helper function
- Use BIT()
- Change patch subject

 drivers/gpio/gpio-xilinx.c | 103 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 91 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 2aad534..626eaa8 100644
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
@@ -12,6 +12,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */

+#include <linux/bitops.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -26,11 +27,26 @@
 #define XGPIO_DATA_OFFSET   (0x0)	/* Data register  */
 #define XGPIO_TRI_OFFSET    (0x4)	/* I/O direction register  */

+#define XGPIO_CHANNEL_OFFSET	0x8
+
+/* Read/Write access to the GPIO registers */
+#define xgpio_readreg(offset)		in_be32(offset)
+#define xgpio_writereg(offset, val)	out_be32(offset, val)
+
+/**
+ * struct xgpio_instance - Stores information about GPIO device
+ * struct of_mm_gpio_chip mmchip: OF GPIO chip for memory mapped banks
+ * gpio_state: GPIO state shadow register
+ * gpio_dir: GPIO direction shadow register
+ * offset: GPIO channel offset
+ * gpio_lock: Lock used for synchronization
+ */
 struct xgpio_instance {
 	struct of_mm_gpio_chip mmchip;
-	u32 gpio_state;		/* GPIO state shadow register */
-	u32 gpio_dir;		/* GPIO direction shadow register */
-	spinlock_t gpio_lock;	/* Lock used for synchronization */
+	u32 gpio_state;
+	u32 gpio_dir;
+	u32 offset;
+	spinlock_t gpio_lock;
 };

 /**
@@ -44,8 +60,12 @@ struct xgpio_instance {
 static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);

-	return (in_be32(mm_gc->regs + XGPIO_DATA_OFFSET) >> gpio) & 1;
+	void __iomem *regs = mm_gc->regs + chip->offset;
+
+	return !!(xgpio_readreg(regs + XGPIO_DATA_OFFSET) & BIT(gpio));
 }

 /**
@@ -63,6 +83,7 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	void __iomem *regs = mm_gc->regs;

 	spin_lock_irqsave(&chip->gpio_lock, flags);

@@ -71,7 +92,9 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 		chip->gpio_state |= 1 << gpio;
 	else
 		chip->gpio_state &= ~(1 << gpio);
-	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+
+	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
+							 chip->gpio_state);

 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
 }
@@ -91,12 +114,13 @@ static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
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

@@ -119,6 +143,7 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	void __iomem *regs = mm_gc->regs;

 	spin_lock_irqsave(&chip->gpio_lock, flags);

@@ -127,11 +152,12 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
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

@@ -147,8 +173,10 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
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
@@ -202,6 +230,57 @@ static int xgpio_of_probe(struct device_node *np)
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
+		of_property_read_u32(np, "xlnx,dout-default-2",
+				     &chip->gpio_state);
+
+		/* By default, all pins are inputs */
+		chip->gpio_dir = 0xFFFFFFFF;
+
+		/* Update GPIO direction shadow register with default value */
+		of_property_read_u32(np, "xlnx,tri-default-2", &chip->gpio_dir);
+
+		/* By default assume full GPIO controller */
+		chip->mmchip.gc.ngpio = 32;
+
+		/* Check device node and parent device node for device width */
+		of_property_read_u32(np, "xlnx,gpio2-width",
+				     (u32 *)&chip->mmchip.gc.ngpio);
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


--=_mimegpg-monstr-desktop-25567-1370262713-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsjLkACgkQykllyylKDCFLAwCgiqSJkMbWYsxLCyI8IRr2frhz
lzoAoIMsBfu1SlN6M9esSxWu58GfObHM
=02k+
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-25567-1370262713-0001--
