Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaLQPvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:51:42 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:64933 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaLQPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:51:24 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 6/7] gpio/gpiolib-of: Create of_mm_gpiochip_remove
Date: Wed, 17 Dec 2014 16:51:13 +0100
Message-Id: <1418831474-24428-7-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create counterpart of of_mm_gpiochip_add(). This way the modules that
can be removable do not duplicate the cleanup code.

Suggested-by: Alexandre Courbot <gnurou@gmail.com>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/gpio/gpiolib-of.c | 17 +++++++++++++++++
 include/linux/of_gpio.h   |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 604dbe6..3e2c6af 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -204,6 +204,23 @@ err0:
 }
 EXPORT_SYMBOL(of_mm_gpiochip_add);
 
+/**
+ * of_mm_gpiochip_remove - Remove memory mapped GPIO chip (bank)
+ * @mm_gc:	pointer to the of_mm_gpio_chip allocated structure
+ */
+void of_mm_gpiochip_remove(struct of_mm_gpio_chip *mm_gc)
+{
+	struct gpio_chip *gc = &mm_gc->gc;
+
+	if (!mm_gc)
+		return;
+
+	gpiochip_remove(gc);
+	iounmap(mm_gc->regs);
+	kfree(gc->label);
+}
+EXPORT_SYMBOL(of_mm_gpiochip_remove);
+
 #ifdef CONFIG_PINCTRL
 static void of_gpiochip_add_pin_range(struct gpio_chip *chip)
 {
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index 38fc050..69dbe31 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -52,6 +52,7 @@ extern int of_get_named_gpio_flags(struct device_node *np,
 
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
+extern void of_mm_gpiochip_remove(struct of_mm_gpio_chip *mm_gc);
 
 extern void of_gpiochip_add(struct gpio_chip *gc);
 extern void of_gpiochip_remove(struct gpio_chip *gc);
-- 
2.1.3

