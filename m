Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaAMRCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:02:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaAMQBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 039/208] gpio: twl4030: Fix regression for twl gpio LED output
Date: Mon, 13 Jan 2014 15:58:00 +0000
Message-Id: <1389628849-1614-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpio/gpio-twl4030.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index ed1d10a..28d9876 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -300,7 +300,7 @@ static int twl_direction_in(struct gpio_chip *chip, unsigned offset)
 	if (offset < TWL4030_GPIO_MAX)
 		ret = twl4030_set_gpio_direction(offset, 1);
 	else
-		ret = -EINVAL;
+		ret = -EINVAL;	/* LED outputs can't be set as input */
 
 	if (!ret)
 		priv->direction &= ~BIT(offset);
@@ -354,11 +354,20 @@ static void twl_set(struct gpio_chip *chip, unsigned offset, int value)
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
-- 
1.8.3.2

