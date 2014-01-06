Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbaAFXPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:15:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961AbaAFWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.10 086/129] gpio: twl4030: Fix regression for twl gpio LED output
Date: Mon,  6 Jan 2014 14:38:35 -0800
Message-Id: <20140106223902.069967119@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit f5837ec11f8cfa6d53ebc5806582771b2c9988c6 upstream.

Commit 0b2aa8be introduced a regression that causes failure
in setting LED GPO direction to OUT.

This causes USB host probe failures for Beagleboard C4.

platform usb_phy_gen_xceiv.2: Driver usb_phy_gen_xceiv requests probe deferral
hsusb2_vcc: Failed to request enable GPIO510: -22
reg-fixed-voltage reg-fixed-voltage.0.auto: Failed to register regulator: -22
reg-fixed-voltage: probe of reg-fixed-voltage.0.auto failed with error -22

direction_out/direction_in must return 0 if the operation succeeded.

Also, don't update direction flag and output data if twl4030_set_gpio_direction()
failed inside twl_direction_out();

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-twl4030.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -300,7 +300,7 @@ static int twl_direction_in(struct gpio_
 	if (offset < TWL4030_GPIO_MAX)
 		ret = twl4030_set_gpio_direction(offset, 1);
 	else
-		ret = -EINVAL;
+		ret = -EINVAL;	/* LED outputs can't be set as input */
 
 	if (!ret)
 		priv->direction &= ~BIT(offset);
@@ -354,11 +354,20 @@ static void twl_set(struct gpio_chip *ch
 static int twl_direction_out(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct gpio_twl4030_priv *priv = to_gpio_twl4030(chip);
-	int ret = -EINVAL;
+	int ret = 0;
 
 	mutex_lock(&priv->mutex);
-	if (offset < TWL4030_GPIO_MAX)
+	if (offset < TWL4030_GPIO_MAX) {
 		ret = twl4030_set_gpio_direction(offset, 0);
+		if (ret) {
+			mutex_unlock(&priv->mutex);
+			return ret;
+		}
+	}
+
+	/*
+	 *  LED gpios i.e. offset >= TWL4030_GPIO_MAX are always output
+	 */
 
 	priv->direction |= BIT(offset);
 	mutex_unlock(&priv->mutex);


