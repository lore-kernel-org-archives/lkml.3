Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaLQPvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:51:43 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:37777 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaLQPvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:51:23 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 5/7] gpio/xilinx: Create a single gpio chip on dual cores
Date: Wed, 17 Dec 2014 16:51:12 +0100
Message-Id: <1418831474-24428-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we had two gpio chips on cores configured as dual.

This lead to mapping the same memory region twice and duplicating the
init and remove code.

This patch creates a single gpiochip for single and dual cores.

Suggested-by: Alexandre Courbot <gnurou@gmail.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpio-xilinx.c | 217 +++++++++++++++++++++++----------------------
 1 file changed, 109 insertions(+), 108 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index 9cf4457..e89fb42 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -48,15 +48,35 @@
  */
 struct xgpio_instance {
 	struct of_mm_gpio_chip mmchip;
-	u32 gpio_state;
-	u32 gpio_dir;
-	spinlock_t gpio_lock;
-	bool inited;
+	unsigned int gpio_width[2];
+	u32 gpio_state[2];
+	u32 gpio_dir[2];
+	spinlock_t gpio_lock[2];
 };
 
-struct xgpio {
-	struct xgpio_instance port[2];
-};
+static inline int xgpio_index(struct xgpio_instance *chip, int gpio)
+{
+	if (gpio >= chip->gpio_width[0])
+		return 1;
+
+	return 0;
+}
+
+static inline int xgpio_regoffset(struct xgpio_instance *chip, int gpio)
+{
+	if (xgpio_index(chip, gpio))
+		return XGPIO_CHANNEL_OFFSET;
+
+	return 0;
+}
+
+static inline int xgpio_offset(struct xgpio_instance *chip, int gpio)
+{
+	if (xgpio_index(chip, gpio))
+		return gpio - chip->gpio_width[0];
+
+	return gpio;
+}
 
 /**
  * xgpio_get - Read the specified signal of the GPIO device.
@@ -72,8 +92,14 @@ struct xgpio {
 static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	u32 val;
 
-	return !!(xgpio_readreg(mm_gc->regs + XGPIO_DATA_OFFSET) & BIT(gpio));
+	val = xgpio_readreg(mm_gc->regs + XGPIO_DATA_OFFSET +
+			    xgpio_regoffset(chip, gpio));
+
+	return !!(val & BIT(xgpio_offset(chip, gpio)));
 }
 
 /**
@@ -91,18 +117,21 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	int index =  xgpio_index(chip, gpio);
+	int offset =  xgpio_offset(chip, gpio);
 
-	spin_lock_irqsave(&chip->gpio_lock, flags);
+	spin_lock_irqsave(&chip->gpio_lock[index], flags);
 
 	/* Write to GPIO signal and set its direction to output */
 	if (val)
-		chip->gpio_state |= BIT(gpio);
+		chip->gpio_state[index] |= BIT(offset);
 	else
-		chip->gpio_state &= ~BIT(gpio);
+		chip->gpio_state[index] &= ~BIT(offset);
 
-	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET +
+		       xgpio_regoffset(chip, gpio), chip->gpio_state[index]);
 
-	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+	spin_unlock_irqrestore(&chip->gpio_lock[index], flags);
 }
 
 /**
@@ -120,14 +149,17 @@ static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	int index =  xgpio_index(chip, gpio);
+	int offset =  xgpio_offset(chip, gpio);
 
-	spin_lock_irqsave(&chip->gpio_lock, flags);
+	spin_lock_irqsave(&chip->gpio_lock[index], flags);
 
 	/* Set the GPIO bit in shadow register and set direction as input */
-	chip->gpio_dir |= BIT(gpio);
-	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	chip->gpio_dir[index] |= BIT(offset);
+	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET +
+		       xgpio_regoffset(chip, gpio), chip->gpio_dir[index]);
 
-	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+	spin_unlock_irqrestore(&chip->gpio_lock[index], flags);
 
 	return 0;
 }
@@ -150,21 +182,25 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
+	int index =  xgpio_index(chip, gpio);
+	int offset =  xgpio_offset(chip, gpio);
 
-	spin_lock_irqsave(&chip->gpio_lock, flags);
+	spin_lock_irqsave(&chip->gpio_lock[index], flags);
 
 	/* Write state of GPIO signal */
 	if (val)
-		chip->gpio_state |= BIT(gpio);
+		chip->gpio_state[index] |= BIT(offset);
 	else
-		chip->gpio_state &= ~BIT(gpio);
-	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+		chip->gpio_state[index] &= ~BIT(offset);
+	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET +
+			xgpio_regoffset(chip, gpio), chip->gpio_state[index]);
 
 	/* Clear the GPIO bit in shadow register and set direction as output */
-	chip->gpio_dir &= ~BIT(gpio);
-	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	chip->gpio_dir[index] &= ~BIT(offset);
+	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET +
+			xgpio_regoffset(chip, gpio), chip->gpio_dir[index]);
 
-	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+	spin_unlock_irqrestore(&chip->gpio_lock[index], flags);
 
 	return 0;
 }
@@ -178,8 +214,16 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
 
-	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET,	chip->gpio_state);
-	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET,	chip->gpio_state[0]);
+	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir[0]);
+
+	if (!chip->gpio_width[1])
+		return;
+
+	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET + XGPIO_TRI_OFFSET,
+		       chip->gpio_state[1]);
+	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET + XGPIO_TRI_OFFSET,
+		       chip->gpio_dir[1]);
 }
 
 /**
@@ -190,20 +234,12 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
  */
 static int xgpio_remove(struct platform_device *pdev)
 {
-	struct xgpio *xgpio = platform_get_drvdata(pdev);
-	int i;
+	struct xgpio_instance *chip = platform_get_drvdata(pdev);
 
-	for (i = 0; i < 2; i++) {
-		if (!xgpio->port[i].inited)
-			continue;
-		gpiochip_remove(&xgpio->port[i].mmchip.gc);
+	gpiochip_remove(&chip->mmchip.gc);
 
-		if (i == 1)
-			xgpio->port[i].mmchip.regs -= XGPIO_CHANNEL_OFFSET;
-
-		iounmap(xgpio->port[i].mmchip.regs);
-		kfree(xgpio->port[i].mmchip.gc.label);
-	}
+	iounmap(chip->mmchip.regs);
+	kfree(chip->mmchip.gc.label);
 
 	return 0;
 }
@@ -218,40 +254,58 @@ static int xgpio_remove(struct platform_device *pdev)
  */
 static int xgpio_probe(struct platform_device *pdev)
 {
-	struct xgpio *xgpio;
 	struct xgpio_instance *chip;
 	int status = 0;
 	struct device_node *np = pdev->dev.of_node;
-	const u32 *tree_info;
-	u32 ngpio;
+	u32 is_dual;
 
-	xgpio = devm_kzalloc(&pdev->dev, sizeof(*xgpio), GFP_KERNEL);
-	if (!xgpio)
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
+	if (!chip)
 		return -ENOMEM;
 
-	platform_set_drvdata(pdev, xgpio);
-
-	chip = &xgpio->port[0];
+	platform_set_drvdata(pdev, chip);
 
 	/* Update GPIO state shadow register with default value */
-	of_property_read_u32(np, "xlnx,dout-default", &chip->gpio_state);
-
-	/* By default, all pins are inputs */
-	chip->gpio_dir = 0xFFFFFFFF;
+	of_property_read_u32(np, "xlnx,dout-default", &chip->gpio_state[0]);
 
 	/* Update GPIO direction shadow register with default value */
-	of_property_read_u32(np, "xlnx,tri-default", &chip->gpio_dir);
+	if (of_property_read_u32(np, "xlnx,tri-default", &chip->gpio_dir[0]))
+		chip->gpio_dir[0] = 0xFFFFFFFF;
 
 	/*
 	 * Check device node and parent device node for device width
 	 * and assume default width of 32
 	 */
-	if (of_property_read_u32(np, "xlnx,gpio-width", &ngpio))
-		ngpio = 32;
-	chip->mmchip.gc.ngpio = (u16)ngpio;
+	if (of_property_read_u32(np, "xlnx,gpio-width", &chip->gpio_width[0]))
+		chip->gpio_width[0] = 32;
+
+	spin_lock_init(&chip->gpio_lock[0]);
+
+	if (of_property_read_u32(np, "xlnx,is-dual", &is_dual))
+		is_dual = 0;
 
-	spin_lock_init(&chip->gpio_lock);
+	if (is_dual) {
+		/* Update GPIO state shadow register with default value */
+		of_property_read_u32(np, "xlnx,dout-default-2",
+				     &chip->gpio_state[1]);
+
+		/* Update GPIO direction shadow register with default value */
+		if (of_property_read_u32(np, "xlnx,tri-default-2",
+					 &chip->gpio_dir[1]))
+			chip->gpio_dir[1] = 0xFFFFFFFF;
 
+		/*
+		 * Check device node and parent device node for device width
+		 * and assume default width of 32
+		 */
+		if (of_property_read_u32(np, "xlnx,gpio2-width",
+					 &chip->gpio_width[1]))
+			chip->gpio_width[1] = 32;
+
+		spin_lock_init(&chip->gpio_lock[1]);
+	}
+
+	chip->mmchip.gc.ngpio = chip->gpio_width[0] + chip->gpio_width[1];
 	chip->mmchip.gc.dev = &pdev->dev;
 	chip->mmchip.gc.direction_input = xgpio_dir_in;
 	chip->mmchip.gc.direction_output = xgpio_dir_out;
@@ -267,59 +321,6 @@ static int xgpio_probe(struct platform_device *pdev)
 		       np->full_name, status);
 		return status;
 	}
-	chip->inited = true;
-
-	pr_info("XGpio: %s: registered, base is %d\n", np->full_name,
-							chip->mmchip.gc.base);
-
-	tree_info = of_get_property(np, "xlnx,is-dual", NULL);
-	if (tree_info && be32_to_cpup(tree_info)) {
-		chip = &xgpio->port[1];
-
-		/* Update GPIO state shadow register with default value */
-		of_property_read_u32(np, "xlnx,dout-default-2",
-				     &chip->gpio_state);
-
-		/* By default, all pins are inputs */
-		chip->gpio_dir = 0xFFFFFFFF;
-
-		/* Update GPIO direction shadow register with default value */
-		of_property_read_u32(np, "xlnx,tri-default-2", &chip->gpio_dir);
-
-		/*
-		 * Check device node and parent device node for device width
-		 * and assume default width of 32
-		 */
-		if (of_property_read_u32(np, "xlnx,gpio2-width", &ngpio))
-			ngpio = 32;
-		chip->mmchip.gc.ngpio = (u16)ngpio;
-
-		spin_lock_init(&chip->gpio_lock);
-
-		chip->mmchip.gc.dev = &pdev->dev;
-		chip->mmchip.gc.direction_input = xgpio_dir_in;
-		chip->mmchip.gc.direction_output = xgpio_dir_out;
-		chip->mmchip.gc.get = xgpio_get;
-		chip->mmchip.gc.set = xgpio_set;
-
-		chip->mmchip.save_regs = xgpio_save_regs;
-
-		/* Call the OF gpio helper to setup and register the GPIO dev */
-		status = of_mm_gpiochip_add(np, &chip->mmchip);
-		if (status) {
-			xgpio_remove(pdev);
-			pr_err("%s: error in probe function with status %d\n",
-			np->full_name, status);
-			return status;
-		}
-
-		/* Add dual channel offset */
-		chip->mmchip.regs += XGPIO_CHANNEL_OFFSET;
-		chip->inited = true;
-
-		pr_info("XGpio: %s: dual channel registered, base is %d\n",
-					np->full_name, chip->mmchip.gc.base);
-	}
 
 	return 0;
 }
-- 
2.1.3

