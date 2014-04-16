Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaDPBZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:25:15 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:36051 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaDPBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:25:08 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] pinctrl: as3722: fix handling of GPIO invert bit
Date: Tue, 15 Apr 2014 18:25:05 -0700
Message-Id: <1397611505-17917-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AS3722_GPIO_INV bit will always be blindly overwritten by
as3722_pinctrl_gpio_set_direction() and will be ignored when
setting the value of the GPIO in as3722_gpio_set() since the
enable_gpio_invert flag is never set.  This will cause an
initially inverted GPIO to toggle when requested as an output,
which could be problematic if, for example, the GPIO controls
a critical regulator.

Instead of setting up the enable_gpio_invert flag, uust leave
the invert bit alone and check it before setting the GPIO value.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/pinctrl/pinctrl-as3722.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-as3722.c b/drivers/pinctrl/pinctrl-as3722.c
index 92ed4b2..c862f9c0 100644
--- a/drivers/pinctrl/pinctrl-as3722.c
+++ b/drivers/pinctrl/pinctrl-as3722.c
@@ -64,7 +64,6 @@ struct as3722_pin_function {
 };
 
 struct as3722_gpio_pin_control {
-	bool enable_gpio_invert;
 	unsigned mode_prop;
 	int io_function;
 };
@@ -320,10 +319,8 @@ static int as3722_pinctrl_gpio_set_direction(struct pinctrl_dev *pctldev,
 		return mode;
 	}
 
-	if (as_pci->gpio_control[offset].enable_gpio_invert)
-		mode |= AS3722_GPIO_INV;
-
-	return as3722_write(as3722, AS3722_GPIOn_CONTROL_REG(offset), mode);
+	return as3722_update_bits(as3722, AS3722_GPIOn_CONTROL_REG(offset),
+				AS3722_GPIO_MODE_MASK, mode);
 }
 
 static const struct pinmux_ops as3722_pinmux_ops = {
@@ -496,10 +493,18 @@ static void as3722_gpio_set(struct gpio_chip *chip, unsigned offset,
 {
 	struct as3722_pctrl_info *as_pci = to_as_pci(chip);
 	struct as3722 *as3722 = as_pci->as3722;
-	int en_invert = as_pci->gpio_control[offset].enable_gpio_invert;
+	int en_invert;
 	u32 val;
 	int ret;
 
+	ret = as3722_read(as3722, AS3722_GPIOn_CONTROL_REG(offset), &val);
+	if (ret < 0) {
+		dev_err(as_pci->dev,
+			"GPIO_CONTROL%d_REG read failed: %d\n", offset, ret);
+		return;
+	}
+	en_invert = !!(val & AS3722_GPIO_INV);
+
 	if (value)
 		val = (en_invert) ? 0 : AS3722_GPIOn_SIGNAL(offset);
 	else
-- 
1.9.1.423.g4596e3a

