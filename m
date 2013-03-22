Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab3CVO5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:57:25 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47326 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933720Ab3CVOzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:55:21 -0400
From: Ian Lartey <ian@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        linus.walleij@linaro.org, cooloney@gmail.com, sfr@canb.auug.org.au,
        rpurdie@rpsys.net, akpm@linux-foundation.org, sameo@linux.intel.com,
        wim@iguana.be, lgirdwood@gmail.com, gg@slimlogic.co.uk,
        j-keerthy@ti.com, ldewangan@nvidia.com, t-kristo@ti.com
Subject: [PATCH v10 08/12] gpio: Palmas palmas_gpio_(read|write|update) factoring
Date: Fri, 22 Mar 2013 14:55:18 +0000
Message-Id: <1363964122-19201-9-git-send-email-ian@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

palmas_gpio_(read|write|update)  gpio parameter renamed to offset
palmas_gpio_write   renamed to palmas_gpio_clear_and_set
as it no longer takes a data value instead it always sets the
offset bit and clears all other bits -

Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
---
 drivers/gpio/gpio-palmas.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/gpio/gpio-palmas.c b/drivers/gpio/gpio-palmas.c
index 04da57a..689c633 100644
--- a/drivers/gpio/gpio-palmas.c
+++ b/drivers/gpio/gpio-palmas.c
@@ -32,30 +32,31 @@ struct palmas_gpio {
 };
 
 static int palmas_gpio_read(struct palmas *palmas, unsigned int reg,
-		int gpio, unsigned int *dest)
+		int offset, unsigned int *dest)
 {
 	/* registers for second bank are identical and offset by 0x9 */
-	if (gpio > 7)
+	if (offset > 7)
 		reg += PALMAS_GPIO_DATA_IN2;
 
 	return palmas_read(palmas, PALMAS_GPIO_BASE, reg, dest);
 }
 
-static int palmas_gpio_write(struct palmas *palmas, unsigned int reg,
-		int gpio, unsigned int data)
+/* Note: This procedure sets 1 bit and clears _all_ others */
+static int palmas_gpio_clear_and_set(struct palmas *palmas, unsigned int reg,
+		int offset)
 {
 	/* registers for second bank are identical and offset by 0x9 */
-	if (gpio > 7)
+	if (offset > 7)
 		reg += PALMAS_GPIO_DATA_IN2;
 
-	return palmas_write(palmas, PALMAS_GPIO_BASE, reg, data);
+	return palmas_write(palmas, PALMAS_GPIO_BASE, reg, BIT(offset % 8));
 }
 
 static int palmas_gpio_update_bits(struct palmas *palmas, unsigned int reg,
-		int gpio, unsigned int mask, unsigned int data)
+		int offset, unsigned int mask, unsigned int data)
 {
 	/* registers for second bank are identical and offset by 0x9 */
-	if (gpio > 7)
+	if (offset > 7)
 		reg += PALMAS_GPIO_DATA_IN2;
 
 	return palmas_update_bits(palmas, PALMAS_GPIO_BASE, reg, mask, data);
@@ -89,11 +90,11 @@ static void palmas_gpio_set(struct gpio_chip *gc, unsigned offset,
 	int ret;
 
 	if (value)
-		ret = palmas_gpio_write(palmas, PALMAS_GPIO_SET_DATA_OUT,
-				offset, BIT(offset % 8));
+		ret = palmas_gpio_clear_and_set(palmas,
+				PALMAS_GPIO_SET_DATA_OUT, offset);
 	else
-		ret = palmas_gpio_write(palmas, PALMAS_GPIO_CLEAR_DATA_OUT,
-				offset, BIT(offset % 8));
+		ret = palmas_gpio_clear_and_set(palmas,
+				PALMAS_GPIO_CLEAR_DATA_OUT, offset);
 	if (ret < 0)
 		dev_err(gc->dev, "%s write failed, err = %d\n",
 			(value) ? "GPIO_SET_DATA_OUT" : "GPIO_CLEAR_DATA_OUT",
@@ -111,7 +112,7 @@ static int palmas_gpio_output(struct gpio_chip *gc, unsigned offset,
 	palmas_gpio_set(gc, offset, value);
 
 	ret = palmas_gpio_update_bits(palmas, PALMAS_GPIO_DATA_DIR,
-			offset, 1 << (offset % 8), 1 << (offset % 8));
+			offset, BIT(offset % 8), BIT(offset % 8));
 	if (ret < 0)
 		dev_err(gc->dev, "GPIO_DATA_DIR write failed, err = %d\n", ret);
 	return ret;
@@ -124,7 +125,7 @@ static int palmas_gpio_input(struct gpio_chip *gc, unsigned offset)
 	int ret;
 
 	ret =  palmas_gpio_update_bits(palmas, PALMAS_GPIO_DATA_DIR,
-				offset, 1 << (offset % 8), 0);
+				offset, BIT(offset % 8), 0);
 	if (ret < 0)
 		dev_err(gc->dev, "GPIO_DATA_DIR write failed, err = %d\n", ret);
 	return ret;
@@ -149,7 +150,7 @@ static int palmas_gpio_set_debounce(struct gpio_chip *gc, unsigned offset,
 		data = 0xff;
 
 	return palmas_gpio_update_bits(palmas, PALMAS_GPIO_DEBOUNCE_EN,
-			offset, 1 << (offset % 8), data);
+			offset, BIT(offset % 8), data);
 }
 
 static int  palmas_gpio_probe(struct platform_device *pdev)
@@ -210,7 +211,6 @@ static int palmas_gpio_remove(struct platform_device *pdev)
 
 static struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,palmas-gpio", },
-	{ .compatible = "ti,palmas-charger-gpio", },
 	{ .compatible = "ti,twl6035-gpio", },
 	{ .compatible = "ti,twl6036-gpio", },
 	{ .compatible = "ti,twl6037-gpio", },
-- 
1.7.0.4

