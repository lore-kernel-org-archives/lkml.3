Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbbAURW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:22:28 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:45536 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbbAURWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:22:18 -0500
From: Mans Rullgard <mans@mansr.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: max732x: add set_multiple function
Date: Wed, 21 Jan 2015 17:17:49 +0000
Message-Id: <1421860669-9217-1-git-send-email-mans@mansr.com>
X-Mailer: git-send-email 2.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a set_multiple function to the MAX732x GPIO driver,
allowing for performance gains when using gpiod_set_array().

Signed-off-by: Mans Rullgard <mans@mansr.com>
---
 drivers/gpio/gpio-max732x.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-max732x.c b/drivers/gpio/gpio-max732x.c
index f860837..ef7eef8 100644
--- a/drivers/gpio/gpio-max732x.c
+++ b/drivers/gpio/gpio-max732x.c
@@ -210,10 +210,11 @@ static int max732x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 	return reg_val & (1u << (off & 0x7));
 }
 
-static void max732x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
+static void max732x_gpio_set_mask(struct gpio_chip *gc, unsigned off, int mask,
+				  int val)
 {
 	struct max732x_chip *chip;
-	uint8_t reg_out, mask = 1u << (off & 0x7);
+	uint8_t reg_out;
 	int ret;
 
 	chip = container_of(gc, struct max732x_chip, gpio_chip);
@@ -221,7 +222,7 @@ static void max732x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 	mutex_lock(&chip->lock);
 
 	reg_out = (off > 7) ? chip->reg_out[1] : chip->reg_out[0];
-	reg_out = (val) ? reg_out | mask : reg_out & ~mask;
+	reg_out = (reg_out & ~mask) | (val & mask);
 
 	ret = max732x_writeb(chip, is_group_a(chip, off), reg_out);
 	if (ret < 0)
@@ -236,6 +237,26 @@ out:
 	mutex_unlock(&chip->lock);
 }
 
+static void max732x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
+{
+	unsigned base = off & ~0x7;
+	uint8_t mask = 1u << (off & 0x7);
+
+	max732x_gpio_set_mask(gc, base, mask, val << (off & 0x7));
+}
+
+static void max732x_gpio_set_multiple(struct gpio_chip *gc,
+				      unsigned long *mask, unsigned long *bits)
+{
+	unsigned mask_lo = mask[0] & 0xff;
+	unsigned mask_hi = (mask[0] >> 8) & 0xff;
+
+	if (mask_lo)
+		max732x_gpio_set_mask(gc, 0, mask_lo, bits[0] & 0xff);
+	if (mask_hi)
+		max732x_gpio_set_mask(gc, 8, mask_hi, (bits[0] >> 8) & 0xff);
+}
+
 static int max732x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 {
 	struct max732x_chip *chip;
@@ -579,6 +600,7 @@ static int max732x_setup_gpio(struct max732x_chip *chip,
 	if (chip->dir_output) {
 		gc->direction_output = max732x_gpio_direction_output;
 		gc->set = max732x_gpio_set_value;
+		gc->set_multiple = max732x_gpio_set_multiple;
 	}
 	gc->get = max732x_gpio_get_value;
 	gc->can_sleep = true;
-- 
2.0.5

