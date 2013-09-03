Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078Ab3ICOJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:09:41 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18890 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3ICOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:09:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Sep 2013 07:09:39 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <linus.walleij@linaro.org>
CC: <swarren@nvidia.com>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] gpio: palmas: add support for TPS80036
Date: Tue, 3 Sep 2013 19:58:03 +0530
Message-ID: <1378218483-19532-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI Palmas series device TPS80036 supports 16 GPIOs.
Register its all 16 gpios when this device is selected.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpio-palmas.c |  104 +++++++++++++++++++++++++++++---------------
 1 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
index 8588af0..11801e9 100644
--- a/drivers/gpio/gpio-palmas.c
+++ b/drivers/gpio/gpio-palmas.c
@@ -31,6 +31,10 @@ struct palmas_gpio {
 	struct palmas *palmas;
 };
 
+struct palmas_device_data {
+	int ngpio;
+};
+
 static inline struct palmas_gpio *to_palmas_gpio(struct gpio_chip *chip)
 {
 	return container_of(chip, struct palmas_gpio, gpio_chip);
@@ -42,23 +46,26 @@ static int palmas_gpio_get(struct gpio_chip *gc, unsigned offset)
 	struct palmas *palmas = pg->palmas;
 	unsigned int val;
 	int ret;
+	unsigned int reg;
+	int gpio16 = (offset/8);
+
+	offset %= 8;
+	reg = (gpio16) ? PALMAS_GPIO_DATA_DIR2 : PALMAS_GPIO_DATA_DIR;
 
-	ret = palmas_read(palmas, PALMAS_GPIO_BASE, PALMAS_GPIO_DATA_DIR, &val);
+	ret = palmas_read(palmas, PALMAS_GPIO_BASE, reg, &val);
 	if (ret < 0) {
-		dev_err(gc->dev, "GPIO_DATA_DIR read failed, err = %d\n", ret);
+		dev_err(gc->dev, "Reg 0x%02x read failed, %d\n", reg, ret);
 		return ret;
 	}
 
-	if (val & (1 << offset)) {
-		ret = palmas_read(palmas, PALMAS_GPIO_BASE,
-				  PALMAS_GPIO_DATA_OUT, &val);
-	} else {
-		ret = palmas_read(palmas, PALMAS_GPIO_BASE,
-				  PALMAS_GPIO_DATA_IN, &val);
-	}
+	if (val & BIT(offset))
+		reg = (gpio16) ? PALMAS_GPIO_DATA_OUT2 : PALMAS_GPIO_DATA_OUT;
+	else
+		reg = (gpio16) ? PALMAS_GPIO_DATA_IN2 : PALMAS_GPIO_DATA_IN;
+
+	ret = palmas_read(palmas, PALMAS_GPIO_BASE, reg, &val);
 	if (ret < 0) {
-		dev_err(gc->dev, "GPIO_DATA_IN/OUT read failed, err = %d\n",
-			ret);
+		dev_err(gc->dev, "Reg 0x%02x read failed, %d\n", reg, ret);
 		return ret;
 	}
 	return !!(val & BIT(offset));
@@ -70,17 +77,20 @@ static void palmas_gpio_set(struct gpio_chip *gc, unsigned offset,
 	struct palmas_gpio *pg = to_palmas_gpio(gc);
 	struct palmas *palmas = pg->palmas;
 	int ret;
+	unsigned int reg;
+	int gpio16 = (offset/8);
 
-	if (value)
-		ret = palmas_write(palmas, PALMAS_GPIO_BASE,
-				PALMAS_GPIO_SET_DATA_OUT, BIT(offset));
+	offset %= 8;
+	if (gpio16)
+		reg = (value) ?
+			PALMAS_GPIO_SET_DATA_OUT2 : PALMAS_GPIO_CLEAR_DATA_OUT2;
 	else
-		ret = palmas_write(palmas, PALMAS_GPIO_BASE,
-				PALMAS_GPIO_CLEAR_DATA_OUT, BIT(offset));
+		reg = (value) ?
+			PALMAS_GPIO_SET_DATA_OUT : PALMAS_GPIO_CLEAR_DATA_OUT;
+
+	ret = palmas_write(palmas, PALMAS_GPIO_BASE, reg, BIT(offset));
 	if (ret < 0)
-		dev_err(gc->dev, "%s write failed, err = %d\n",
-			(value) ? "GPIO_SET_DATA_OUT" : "GPIO_CLEAR_DATA_OUT",
-			ret);
+		dev_err(gc->dev, "Reg 0x%02x write failed, %d\n", reg, ret);
 }
 
 static int palmas_gpio_output(struct gpio_chip *gc, unsigned offset,
@@ -89,14 +99,19 @@ static int palmas_gpio_output(struct gpio_chip *gc, unsigned offset,
 	struct palmas_gpio *pg = to_palmas_gpio(gc);
 	struct palmas *palmas = pg->palmas;
 	int ret;
+	unsigned int reg;
+	int gpio16 = (offset/8);
+
+	offset %= 8;
+	reg = (gpio16) ? PALMAS_GPIO_DATA_DIR2 : PALMAS_GPIO_DATA_DIR;
 
 	/* Set the initial value */
 	palmas_gpio_set(gc, offset, value);
 
-	ret = palmas_update_bits(palmas, PALMAS_GPIO_BASE,
-		PALMAS_GPIO_DATA_DIR, BIT(offset), BIT(offset));
+	ret = palmas_update_bits(palmas, PALMAS_GPIO_BASE, reg,
+				BIT(offset), BIT(offset));
 	if (ret < 0)
-		dev_err(gc->dev, "GPIO_DATA_DIR write failed, err = %d\n", ret);
+		dev_err(gc->dev, "Reg 0x%02x update failed, %d\n", reg, ret);
 	return ret;
 }
 
@@ -105,11 +120,15 @@ static int palmas_gpio_input(struct gpio_chip *gc, unsigned offset)
 	struct palmas_gpio *pg = to_palmas_gpio(gc);
 	struct palmas *palmas = pg->palmas;
 	int ret;
+	unsigned int reg;
+	int gpio16 = (offset/8);
+
+	offset %= 8;
+	reg = (gpio16) ? PALMAS_GPIO_DATA_DIR2 : PALMAS_GPIO_DATA_DIR;
 
-	ret = palmas_update_bits(palmas, PALMAS_GPIO_BASE,
-		PALMAS_GPIO_DATA_DIR, BIT(offset), 0);
+	ret = palmas_update_bits(palmas, PALMAS_GPIO_BASE, reg, BIT(offset), 0);
 	if (ret < 0)
-		dev_err(gc->dev, "GPIO_DATA_DIR write failed, err = %d\n", ret);
+		dev_err(gc->dev, "Reg 0x%02x update failed, %d\n", reg, ret);
 	return ret;
 }
 
@@ -121,12 +140,36 @@ static int palmas_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 	return palmas_irq_get_virq(palmas, PALMAS_GPIO_0_IRQ + offset);
 }
 
+static const struct palmas_device_data palmas_dev_data = {
+	.ngpio = 8,
+};
+
+static const struct palmas_device_data tps80036_dev_data = {
+	.ngpio = 16,
+};
+
+static struct of_device_id of_palmas_gpio_match[] = {
+	{ .compatible = "ti,palmas-gpio", .data = &palmas_dev_data,},
+	{ .compatible = "ti,tps65913-gpio", .data = &palmas_dev_data,},
+	{ .compatible = "ti,tps65914-gpio", .data = &palmas_dev_data,},
+	{ .compatible = "ti,tps80036-gpio", .data = &tps80036_dev_data,},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
+
 static int palmas_gpio_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
 	struct palmas_platform_data *palmas_pdata;
 	struct palmas_gpio *palmas_gpio;
 	int ret;
+	const struct of_device_id *match;
+	const struct palmas_device_data *dev_data;
+
+	match = of_match_device(of_palmas_gpio_match, &pdev->dev);
+	dev_data = match->data;
+	if (!dev_data)
+		dev_data = &palmas_dev_data;
 
 	palmas_gpio = devm_kzalloc(&pdev->dev,
 				sizeof(*palmas_gpio), GFP_KERNEL);
@@ -138,7 +181,7 @@ static int palmas_gpio_probe(struct platform_device *pdev)
 	palmas_gpio->palmas = palmas;
 	palmas_gpio->gpio_chip.owner = THIS_MODULE;
 	palmas_gpio->gpio_chip.label = dev_name(&pdev->dev);
-	palmas_gpio->gpio_chip.ngpio = 8;
+	palmas_gpio->gpio_chip.ngpio = dev_data->ngpio;
 	palmas_gpio->gpio_chip.can_sleep = 1;
 	palmas_gpio->gpio_chip.direction_input = palmas_gpio_input;
 	palmas_gpio->gpio_chip.direction_output = palmas_gpio_output;
@@ -172,15 +215,6 @@ static int palmas_gpio_remove(struct platform_device *pdev)
 	return gpiochip_remove(&palmas_gpio->gpio_chip);
 }
 
-static struct of_device_id of_palmas_gpio_match[] = {
-	{ .compatible = "ti,palmas-gpio"},
-	{ .compatible = "ti,tps65913-gpio"},
-	{ .compatible = "ti,tps65914-gpio"},
-	{ .compatible = "ti,tps80036-gpio"},
-	{ },
-};
-MODULE_DEVICE_TABLE(of, of_palmas_gpio_match);
-
 static struct platform_driver palmas_gpio_driver = {
 	.driver.name	= "palmas-gpio",
 	.driver.owner	= THIS_MODULE,
-- 
1.7.1.1

