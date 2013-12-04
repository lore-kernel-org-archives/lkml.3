Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3LDLfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:35:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50481 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab3LDLfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:35:03 -0500
From: Roger Quadros <rogerq@ti.com>
To: <linus.walleij@linaro.org>
CC: <tony@atomide.com>, <peter.ujfalusi@ti.com>, <nm@ti.com>,
        <tomi.valkeinen@ti.com>, <balbi@ti.com>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/1] gpio: twl4030: Fix regression for twl gpio LED output
Date: Wed, 4 Dec 2013 13:34:31 +0200
Message-ID: <1386156871-7639-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386156871-7639-1-git-send-email-rogerq@ti.com>
References: <1386156871-7639-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0b2aa8be introduced a regression that causes failure
in setting LED GPO direction to OUT.

This causes USB host probe failures for Beagleboard C4.

[    2.075469] platform usb_phy_gen_xceiv.2: Driver usb_phy_gen_xceiv requests probe deferral
[    2.090454] hsusb2_vcc: Failed to request enable GPIO510: -22
[    2.100982] reg-fixed-voltage reg-fixed-voltage.0.auto: Failed to register regulator: -22
[    2.109954] reg-fixed-voltage: probe of reg-fixed-voltage.0.auto failed with error -22

direction_out/direction_in must return 0 if the operation succeeded.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/gpio/gpio-twl4030.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index b97d6a6..0999ed1 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -294,13 +294,13 @@ out:
 static int twl_direction_in(struct gpio_chip *chip, unsigned offset)
 {
 	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&priv->mutex);
 	if (offset < TWL4030_GPIO_MAX)
-		ret = twl4030_set_gpio_direction(offset, 1);
+		twl4030_set_gpio_direction(offset, 1);
 	else
-		ret = -EINVAL;
+		ret = -EINVAL;	/* LED outputs can't be set as input */
 
 	if (!ret)
 		priv->direction &= ~BIT(offset);
@@ -354,18 +354,21 @@ static void twl_set(struct gpio_chip *chip, unsigned offset, int value)
 static int twl_direction_out(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
-	int ret = -EINVAL;
 
 	mutex_lock(&priv->mutex);
 	if (offset < TWL4030_GPIO_MAX)
-		ret = twl4030_set_gpio_direction(offset, 0);
+		twl4030_set_gpio_direction(offset, 0);
+
+	/*
+	 *  LED gpio's i.e. offset >= TWL4030_GPIO_MAX are always output
+	 */
 
 	priv->direction |= BIT(offset);
 	mutex_unlock(&priv->mutex);
 
 	twl_set(chip, offset, value);
 
-	return ret;
+	return 0;
 }
 
 static int twl_to_irq(struct gpio_chip *chip, unsigned offset)
-- 
1.8.3.2

