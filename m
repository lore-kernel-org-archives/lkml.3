Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3BCLLI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:11:08 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:33641 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3BCLLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:11:06 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] pinctrl: sunxi: Add of_xlate function
Date: Sun,  3 Feb 2013 12:10:11 +0100
Message-Id: <1359889813-10029-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359889813-10029-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359889813-10029-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the pin controller of sunxi chips is represented as a single bank
in the driver.
Since this is neither convenient nor represented that way in the
datasheets, define a custom of_xlate function with the layout <bank pin
flag>

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index e4d32c6..80b11e3 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -1261,6 +1261,24 @@ static void sunxi_pinctrl_gpio_set(struct gpio_chip *chip,
 	writel((value & DATA_PINS_MASK) << index, pctl->membase + reg);
 }
 
+static int sunxi_pinctrl_gpio_of_xlate(struct gpio_chip *gc,
+				const struct of_phandle_args *gpiospec,
+				u32 *flags)
+{
+	int pin, base;
+
+	base = PINS_PER_BANK * gpiospec->args[0];
+	pin = base + gpiospec->args[1];
+
+	if (pin > (gc->base + gc->ngpio))
+		return -EINVAL;
+
+	if (flags)
+		*flags = gpiospec->args[2];
+
+	return pin;
+}
+
 static struct gpio_chip sunxi_pinctrl_gpio_chip = {
 	.owner			= THIS_MODULE,
 	.request		= sunxi_pinctrl_gpio_request,
@@ -1269,6 +1287,8 @@ static struct gpio_chip sunxi_pinctrl_gpio_chip = {
 	.direction_output	= sunxi_pinctrl_gpio_direction_output,
 	.get			= sunxi_pinctrl_gpio_get,
 	.set			= sunxi_pinctrl_gpio_set,
+	.of_xlate		= sunxi_pinctrl_gpio_of_xlate,
+	.of_gpio_n_cells	= 3,
 	.can_sleep		= 0,
 };
 
-- 
1.7.10.4

