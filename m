Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbaJURta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:49:30 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52969 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbaJURrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:47:45 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Chris Zhong <zyw@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] pinctrl: rockchip: Don't call pinctrl_gpio_direction_output() in pin_config_set()
Date: Tue, 21 Oct 2014 10:47:33 -0700
Message-Id: <1413913655-22351-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413913655-22351-1-git-send-email-dianders@chromium.org>
References: <1413913655-22351-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Rockchip pinctrl driver was calling
rockchip_gpio_direction_output() in the pin_config_set() callback.
This was just a shortcut for:
* rockchip_gpio_set()
* pinctrl_gpio_direction_output()

Unfortunately it's not so good to call pinctrl_gpio_direction_output()
from pin_config_set().  Specifically when initting hogs you'll get an
error.

Let's refactor a little so we can call
_rockchip_pmx_gpio_set_direction() directly.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Tested-by: Chris Zhong <zyw@rock-chips.com>
---
Changes in v2:
- The 'flags' variable is now in the locking patch.
- Fix confusion between 'pin' and 'offset'.

 drivers/pinctrl/pinctrl-rockchip.c | 41 +++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 230d8f3..8a3c582 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -856,22 +856,14 @@ static int rockchip_pmx_set(struct pinctrl_dev *pctldev, unsigned selector,
  * leads to this function call (via the pinctrl_gpio_direction_{input|output}()
  * function called from the gpiolib interface).
  */
-static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
-					      struct pinctrl_gpio_range *range,
-					      unsigned offset, bool input)
+static int _rockchip_pmx_gpio_set_direction(struct gpio_chip *chip,
+					    int pin, bool input)
 {
-	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	struct rockchip_pin_bank *bank;
-	struct gpio_chip *chip;
-	int pin, ret;
+	int ret;
 	u32 data;
 
-	chip = range->gc;
 	bank = gc_to_pin_bank(chip);
-	pin = offset - chip->base;
-
-	dev_dbg(info->dev, "gpio_direction for pin %u as %s-%d to %s\n",
-		 offset, range->name, pin, input ? "input" : "output");
 
 	ret = rockchip_set_mux(bank, pin, RK_FUNC_GPIO);
 	if (ret < 0)
@@ -888,6 +880,23 @@ static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+static int rockchip_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
+					      struct pinctrl_gpio_range *range,
+					      unsigned offset, bool input)
+{
+	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	struct gpio_chip *chip;
+	int pin;
+
+	chip = range->gc;
+	pin = offset - chip->base;
+	dev_dbg(info->dev, "gpio_direction for pin %u as %s-%d to %s\n",
+		 offset, range->name, pin, input ? "input" : "output");
+
+	return _rockchip_pmx_gpio_set_direction(chip, offset - chip->base,
+						input);
+}
+
 static const struct pinmux_ops rockchip_pmx_ops = {
 	.get_functions_count	= rockchip_pmx_get_funcs_count,
 	.get_function_name	= rockchip_pmx_get_func_name,
@@ -917,8 +926,7 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 	return false;
 }
 
-static int rockchip_gpio_direction_output(struct gpio_chip *gc,
-					  unsigned offset, int value);
+static void rockchip_gpio_set(struct gpio_chip *gc, unsigned offset, int value);
 static int rockchip_gpio_get(struct gpio_chip *gc, unsigned offset);
 
 /* set the pin config settings for a specified pin */
@@ -959,9 +967,10 @@ static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 				return rc;
 			break;
 		case PIN_CONFIG_OUTPUT:
-			rc = rockchip_gpio_direction_output(&bank->gpio_chip,
-							    pin - bank->pin_base,
-							    arg);
+			rockchip_gpio_set(&bank->gpio_chip,
+					  pin - bank->pin_base, arg);
+			rc = _rockchip_pmx_gpio_set_direction(&bank->gpio_chip,
+					  pin - bank->pin_base, false);
 			if (rc)
 				return rc;
 			break;
-- 
2.1.0.rc2.206.gedb03e5

