Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbaEKTZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:25:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbaEKTYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:24:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.14 56/83] pinctrl: as3722: fix handling of GPIO invert bit
Date: Sun, 11 May 2014 21:19:57 +0200
Message-Id: <20140511191914.452028303@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Bresticker <abrestic@chromium.org>

commit a73d2e30b46787d478275db36c19222020e29dc5 upstream.

The AS3722_GPIO_INV bit will always be blindly overwritten by
as3722_pinctrl_gpio_set_direction() and will be ignored when
setting the value of the GPIO in as3722_gpio_set() since the
enable_gpio_invert flag is never set.  This will cause an
initially inverted GPIO to toggle when requested as an output,
which could be problematic if, for example, the GPIO controls
a critical regulator.

Instead of setting up the enable_gpio_invert flag, just leave
the invert bit alone and check it before setting the GPIO value.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-as3722.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/pinctrl/pinctrl-as3722.c
+++ b/drivers/pinctrl/pinctrl-as3722.c
@@ -64,7 +64,6 @@ struct as3722_pin_function {
 };
 
 struct as3722_gpio_pin_control {
-	bool enable_gpio_invert;
 	unsigned mode_prop;
 	int io_function;
 };
@@ -320,10 +319,8 @@ static int as3722_pinctrl_gpio_set_direc
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
@@ -496,10 +493,18 @@ static void as3722_gpio_set(struct gpio_
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


