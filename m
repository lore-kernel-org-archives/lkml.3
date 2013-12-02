Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3LBK2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:28:53 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:50326 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3LBK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:28:51 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-gpio@vger.kernel.org
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com,
        devicetree@vger.kernel.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] gpio: MOXA ART: rename moxart_gpio_base to base
Date: Mon,  2 Dec 2013 11:27:59 +0100
Message-Id: <1385980079-20175-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1385723494-8033-1-git-send-email-jonas.jensen@gmail.com>
References: <1385723494-8033-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renaming "moxart_gpio_base" to "base" allows better fit,
remove line breaks in moxart_gpio_get().

While doing trivial cleanup, also remove fields initialized
with zero in moxart_template_chip.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks for applying!
    
    This is a follow-up with trivial changes per your comments.
    
    Regarding Documentation/devicetree/bindings/vendor-prefixes.txt,
    there's already a patch submitted (Mark Rutland requested this):
    
    https://lkml.org/lkml/2013/10/8/451
    
    Applies to next-20131202

 drivers/gpio/gpio-moxart.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-moxart.c b/drivers/gpio/gpio-moxart.c
index d662cde..4ecd195 100644
--- a/drivers/gpio/gpio-moxart.c
+++ b/drivers/gpio/gpio-moxart.c
@@ -30,7 +30,7 @@
 
 struct moxart_gpio_chip {
 	struct gpio_chip gpio;
-	void __iomem *moxart_gpio_base;
+	void __iomem *base;
 };
 
 static inline struct moxart_gpio_chip *to_moxart_gpio(struct gpio_chip *chip)
@@ -51,7 +51,7 @@ static void moxart_gpio_free(struct gpio_chip *chip, unsigned offset)
 static int moxart_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
-	void __iomem *ioaddr = gc->moxart_gpio_base + GPIO_PIN_DIRECTION;
+	void __iomem *ioaddr = gc->base + GPIO_PIN_DIRECTION;
 
 	writel(readl(ioaddr) & ~BIT(offset), ioaddr);
 	return 0;
@@ -61,7 +61,7 @@ static int moxart_gpio_direction_output(struct gpio_chip *chip,
 					unsigned offset, int value)
 {
 	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
-	void __iomem *ioaddr = gc->moxart_gpio_base + GPIO_PIN_DIRECTION;
+	void __iomem *ioaddr = gc->base + GPIO_PIN_DIRECTION;
 
 	writel(readl(ioaddr) | BIT(offset), ioaddr);
 	return 0;
@@ -70,7 +70,7 @@ static int moxart_gpio_direction_output(struct gpio_chip *chip,
 static void moxart_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
-	void __iomem *ioaddr = gc->moxart_gpio_base + GPIO_DATA_OUT;
+	void __iomem *ioaddr = gc->base + GPIO_DATA_OUT;
 	u32 reg = readl(ioaddr);
 
 	if (value)
@@ -85,14 +85,12 @@ static void moxart_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 static int moxart_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct moxart_gpio_chip *gc = to_moxart_gpio(chip);
-	u32 ret = readl(gc->moxart_gpio_base + GPIO_PIN_DIRECTION);
+	u32 ret = readl(gc->base + GPIO_PIN_DIRECTION);
 
 	if (ret & BIT(offset))
-		return !!(readl(gc->moxart_gpio_base + GPIO_DATA_OUT) &
-			  BIT(offset));
+		return !!(readl(gc->base + GPIO_DATA_OUT) & BIT(offset));
 	else
-		return !!(readl(gc->moxart_gpio_base + GPIO_DATA_IN) &
-			  BIT(offset));
+		return !!(readl(gc->base + GPIO_DATA_IN) & BIT(offset));
 }
 
 static struct gpio_chip moxart_template_chip = {
@@ -103,9 +101,7 @@ static struct gpio_chip moxart_template_chip = {
 	.direction_output	= moxart_gpio_direction_output,
 	.set			= moxart_gpio_set,
 	.get			= moxart_gpio_get,
-	.base			= 0,
 	.ngpio			= 32,
-	.can_sleep		= 0,
 };
 
 static int moxart_gpio_probe(struct platform_device *pdev)
@@ -123,11 +119,11 @@ static int moxart_gpio_probe(struct platform_device *pdev)
 	mgc->gpio = moxart_template_chip;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	mgc->moxart_gpio_base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(mgc->moxart_gpio_base)) {
+	mgc->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(mgc->base)) {
 		dev_err(dev, "%s: devm_ioremap_resource res_gpio failed\n",
 			dev->of_node->full_name);
-		return PTR_ERR(mgc->moxart_gpio_base);
+		return PTR_ERR(mgc->base);
 	}
 
 	mgc->gpio.dev = dev;
-- 
1.8.2.1

