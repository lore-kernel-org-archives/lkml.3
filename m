Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbaLJNWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:22:00 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33075 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaLJNV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:21:56 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 1/3] gpio/xilinx: Remove offset property
Date: Wed, 10 Dec 2014 14:21:48 +0100
Message-Id: <1418217710-11987-2-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418217710-11987-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418217710-11987-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calculating the register offset per call, pre-calculate it on
probe time.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v2: Add Acked-by 

 drivers/gpio/gpio-xilinx.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index ba18b06..9483950 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -50,7 +50,6 @@ struct xgpio_instance {
 	struct of_mm_gpio_chip mmchip;
 	u32 gpio_state;
 	u32 gpio_dir;
-	u32 offset;
 	spinlock_t gpio_lock;
 };
 
@@ -65,12 +64,8 @@ struct xgpio_instance {
 static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
 {
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
-	struct xgpio_instance *chip =
-	    container_of(mm_gc, struct xgpio_instance, mmchip);
 
-	void __iomem *regs = mm_gc->regs + chip->offset;
-
-	return !!(xgpio_readreg(regs + XGPIO_DATA_OFFSET) & BIT(gpio));
+	return !!(xgpio_readreg(mm_gc->regs + XGPIO_DATA_OFFSET) & BIT(gpio));
 }
 
 /**
@@ -88,7 +83,6 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
-	void __iomem *regs = mm_gc->regs;
 
 	spin_lock_irqsave(&chip->gpio_lock, flags);
 
@@ -98,8 +92,7 @@ static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
 	else
 		chip->gpio_state &= ~BIT(gpio);
 
-	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
-							 chip->gpio_state);
+	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
 
 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
 }
@@ -119,13 +112,12 @@ static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
-	void __iomem *regs = mm_gc->regs;
 
 	spin_lock_irqsave(&chip->gpio_lock, flags);
 
 	/* Set the GPIO bit in shadow register and set direction as input */
 	chip->gpio_dir |= BIT(gpio);
-	xgpio_writereg(regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
 
 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
 
@@ -148,7 +140,6 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
-	void __iomem *regs = mm_gc->regs;
 
 	spin_lock_irqsave(&chip->gpio_lock, flags);
 
@@ -157,12 +148,11 @@ static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 		chip->gpio_state |= BIT(gpio);
 	else
 		chip->gpio_state &= ~BIT(gpio);
-	xgpio_writereg(regs + chip->offset + XGPIO_DATA_OFFSET,
-		       chip->gpio_state);
+	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
 
 	/* Clear the GPIO bit in shadow register and set direction as output */
 	chip->gpio_dir &= ~BIT(gpio);
-	xgpio_writereg(regs + chip->offset + XGPIO_TRI_OFFSET, chip->gpio_dir);
+	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
 
 	spin_unlock_irqrestore(&chip->gpio_lock, flags);
 
@@ -178,10 +168,8 @@ static void xgpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 	struct xgpio_instance *chip =
 	    container_of(mm_gc, struct xgpio_instance, mmchip);
 
-	xgpio_writereg(mm_gc->regs + chip->offset + XGPIO_DATA_OFFSET,
-							chip->gpio_state);
-	xgpio_writereg(mm_gc->regs + chip->offset + XGPIO_TRI_OFFSET,
-							 chip->gpio_dir);
+	xgpio_writereg(mm_gc->regs + XGPIO_DATA_OFFSET,	chip->gpio_state);
+	xgpio_writereg(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
 }
 
 /**
@@ -247,9 +235,6 @@ static int xgpio_of_probe(struct device_node *np)
 		if (!chip)
 			return -ENOMEM;
 
-		/* Add dual channel offset */
-		chip->offset = XGPIO_CHANNEL_OFFSET;
-
 		/* Update GPIO state shadow register with default value */
 		of_property_read_u32(np, "xlnx,dout-default-2",
 				     &chip->gpio_state);
@@ -285,6 +270,10 @@ static int xgpio_of_probe(struct device_node *np)
 			np->full_name, status);
 			return status;
 		}
+
+		/* Add dual channel offset */
+		chip->mmchip.regs += XGPIO_CHANNEL_OFFSET;
+
 		pr_info("XGpio: %s: dual channel registered, base is %d\n",
 					np->full_name, chip->mmchip.gc.base);
 	}
-- 
2.1.3

