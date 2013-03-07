Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab3CGNUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:20:13 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:60858 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab3CGNS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:18:26 -0500
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: [PATCH v8 07/12] gpio: palmas: add in GPIO support for palmas charger
Date: Thu,  7 Mar 2013 13:17:51 +0000
Message-Id: <1362662276-20792-7-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
References: <1362662276-20792-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas charger has 16 GPIOs
add palmas_gpio_[read|write|update] api to take account
second bank of GPIOs

Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/gpio/gpio-palmas.c |   77 ++++++++++++++++++++++++++++++++++++--------
 include/linux/mfd/palmas.h |   12 ++++++-
 2 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
index e3a4e56..636648c 100644
--- a/drivers/gpio/gpio-palmas.c
+++ b/drivers/gpio/gpio-palmas.c
@@ -1,7 +1,7 @@
 /*
- * TI Palma series PMIC's GPIO driver.
+ * TI Palmas series PMIC's GPIO driver.
  *
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2012-2012, NVIDIA CORPORATION.  All rights reserved.
  *
  * Author: Laxman Dewangan <ldewangan@nvidia.com>
  *
@@ -31,6 +31,36 @@ struct palmas_gpio {
 	struct palmas *palmas;
 };
 
+static int palmas_gpio_read(struct palmas *palmas, unsigned int reg,
+		int gpio, unsigned int *dest)
+{
+	/* registers for second bank are identical and offset by 0x9 */
+	if (gpio > 7)
+		reg += PALMAS_GPIO_DATA_IN2;
+
+	return palmas_read(palmas, PALMAS_GPIO_BASE, reg, dest);
+}
+
+static int palmas_gpio_write(struct palmas *palmas, unsigned int reg,
+		int gpio, unsigned int data)
+{
+	/* registers for second bank are identical and offset by 0x9 */
+	if (gpio > 7)
+		reg += PALMAS_GPIO_DATA_IN2;
+
+	return palmas_write(palmas, PALMAS_GPIO_BASE, reg, data);
+}
+
+static int palmas_gpio_update_bits(struct palmas *palmas, unsigned int reg,
+		int gpio, unsigned int mask, unsigned int data)
+{
+	/* registers for second bank are identical and offset by 0x9 */
+	if (gpio > 7)
+		reg += PALMAS_GPIO_DATA_IN2;
+
+	return palmas_update_bits(palmas, PALMAS_GPIO_BASE, reg, mask, data);
+}
+
 static inline struct palmas_gpio *to_palmas_gpio(struct gpio_chip *chip)
 {
 	return container_of(chip, struct palmas_gpio, gpio_chip);
@@ -43,12 +73,12 @@ static int palmas_gpio_get(struct gpio_chip *gc, unsigned offset)
 	unsigned int val;
 	int ret;
 
-	ret = palmas_read(palmas, PALMAS_GPIO_BASE, PALMAS_GPIO_DATA_IN, &val);
+	ret = palmas_gpio_read(palmas, PALMAS_GPIO_DATA_IN, offset, &val);
 	if (ret < 0) {
 		dev_err(gc->dev, "GPIO_DATA_IN read failed, err = %d\n", ret);
 		return ret;
 	}
-	return !!(val & BIT(offset));
+	return !!(val & BIT(offset % 8));
 }
 
 static void palmas_gpio_set(struct gpio_chip *gc, unsigned offset,
@@ -59,11 +89,11 @@ static void palmas_gpio_set(struct gpio_chip *gc, unsigned offset,
 	int ret;
 
 	if (value)
-		ret = palmas_write(palmas, PALMAS_GPIO_BASE,
-				PALMAS_GPIO_SET_DATA_OUT, BIT(offset));
+		ret = palmas_gpio_write(palmas, PALMAS_GPIO_SET_DATA_OUT,
+				offset, BIT(offset % 8));
 	else
-		ret = palmas_write(palmas, PALMAS_GPIO_BASE,
-				PALMAS_GPIO_CLEAR_DATA_OUT, BIT(offset));
+		ret = palmas_gpio_write(palmas, PALMAS_GPIO_CLEAR_DATA_OUT,
+				offset, BIT(offset % 8));
 	if (ret < 0)
 		dev_err(gc->dev, "%s write failed, err = %d\n",
 			(value) ? "GPIO_SET_DATA_OUT" : "GPIO_CLEAR_DATA_OUT",
@@ -80,8 +110,8 @@ static int palmas_gpio_output(struct gpio_chip *gc, unsigned offset,
 	/* Set the initial value */
 	palmas_gpio_set(gc, offset, value);
 
-	ret = palmas_update_bits(palmas, PALMAS_GPIO_BASE,
-		PALMAS_GPIO_DATA_DIR, BIT(offset), BIT(offset));
+	ret = palmas_gpio_update_bits(palmas, PALMAS_GPIO_DATA_DIR,
+			offset, 1 << (offset % 8), 1 << (offset % 8));
 	if (ret < 0)
 		dev_err(gc->dev, "GPIO_DATA_DIR write failed, err = %d\n", ret);
 	return ret;
@@ -93,8 +123,8 @@ static int palmas_gpio_input(struct gpio_chip *gc, unsigned offset)
 	struct palmas *palmas = pg->palmas;
 	int ret;
 
-	ret = palmas_update_bits(palmas, PALMAS_GPIO_BASE,
-		PALMAS_GPIO_DATA_DIR, BIT(offset), 0);
+	ret =  palmas_gpio_update_bits(palmas, PALMAS_GPIO_DATA_DIR,
+				offset, 1 << (offset % 8), 0);
 	if (ret < 0)
 		dev_err(gc->dev, "GPIO_DATA_DIR write failed, err = %d\n", ret);
 	return ret;
@@ -108,7 +138,21 @@ static int palmas_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 	return palmas_irq_get_virq(palmas, PALMAS_GPIO_0_IRQ + offset);
 }
 
-static int palmas_gpio_probe(struct platform_device *pdev)
+static int palmas_gpio_set_debounce(struct gpio_chip *gc, unsigned offset,
+				    unsigned debounce)
+{
+	struct palmas_gpio *palmas_gpio = to_palmas_gpio(gc);
+	struct palmas *palmas = palmas_gpio->palmas;
+	unsigned int data = 0;
+
+	if (debounce)
+		data = 0xff;
+
+	return palmas_gpio_update_bits(palmas, PALMAS_GPIO_DEBOUNCE_EN,
+			offset, 1 << (offset % 8), data);
+}
+
+static int  palmas_gpio_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
 	struct palmas_platform_data *palmas_pdata;
@@ -125,10 +169,15 @@ static int palmas_gpio_probe(struct platform_device *pdev)
 	palmas_gpio->palmas = palmas;
 	palmas_gpio->gpio_chip.owner = THIS_MODULE;
 	palmas_gpio->gpio_chip.label = dev_name(&pdev->dev);
-	palmas_gpio->gpio_chip.ngpio = 8;
+	/* palmas charger has 16 gpios */
+	if (is_palmas_charger(palmas->product_id))
+		palmas_gpio->gpio_chip.ngpio = 16;
+	else
+		palmas_gpio->gpio_chip.ngpio = 8;
 	palmas_gpio->gpio_chip.can_sleep = 1;
 	palmas_gpio->gpio_chip.direction_input = palmas_gpio_input;
 	palmas_gpio->gpio_chip.direction_output = palmas_gpio_output;
+	palmas_gpio->gpio_chip.set_debounce = palmas_gpio_set_debounce,
 	palmas_gpio->gpio_chip.to_irq = palmas_gpio_to_irq;
 	palmas_gpio->gpio_chip.set	= palmas_gpio_set;
 	palmas_gpio->gpio_chip.get	= palmas_gpio_get;
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 0427165..5661f2d 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -243,7 +243,7 @@ struct palmas_platform_data {
 	 * then the two value to load into the registers if true
 	 */
 	int mux_from_pdata;
-	u8 pad1, pad2;
+	u8 pad1, pad2, pad3, pad4;
 
 	struct palmas_pmic_platform_data *pmic_pdata;
 	struct palmas_gpadc_platform_data *gpadc_pdata;
@@ -2512,6 +2512,16 @@ enum usb_irq_events {
 #define PALMAS_PU_PD_GPIO_CTRL1					0x6
 #define PALMAS_PU_PD_GPIO_CTRL2					0x7
 #define PALMAS_OD_OUTPUT_GPIO_CTRL				0x8
+#define PALMAS_GPIO_DATA_IN2					0x9
+#define PALMAS_GPIO_DATA_DIR2					0xA
+#define PALMAS_GPIO_DATA_OUT2					0xB
+#define PALMAS_GPIO_DEBOUNCE_EN2				0xC
+#define PALMAS_GPIO_CLEAR_DATA_OUT2				0xD
+#define PALMAS_GPIO_SET_DATA_OUT2				0xE
+#define PALMAS_PU_PD_GPIO_CTRL3					0xF
+#define PALMAS_PU_PD_GPIO_CTRL4					0x10
+#define PALMAS_OD_OUTPUT_GPIO_CTRL2				0x11
+#define PALMAS_GPO_CTRL						0x12
 
 /* Bit definitions for GPIO_DATA_IN */
 #define PALMAS_GPIO_DATA_IN_GPIO_7_IN				0x80
-- 
1.7.0.4

