Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965644Ab3FTOGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:06:36 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:56289 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965583Ab3FTOFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:05:41 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH v2 2/2] pinctrl: abx500: fix abx500_pin_config_set()
Date: Thu, 20 Jun 2013 16:05:00 +0200
Message-Id: <1371737100-27584-3-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1371737100-27584-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1371737100-27584-1-git-send-email-patrice.chotard.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

_ Update abx500_pin_config_set() in order to take in
account PIN_CONFIG_BIAS_DISABLE state to disable
pull up or pull down.

_ Rework error path.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |   31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index f13a57b..caa7ab6 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -33,6 +33,7 @@
 #include <linux/pinctrl/machine.h>
 
 #include "pinctrl-abx500.h"
+#include "core.h"
 #include "pinconf.h"
 
 /*
@@ -963,7 +964,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	struct pullud *pullud = pct->soc->pullud;
 	struct gpio_chip *chip = &pct->chip;
 	unsigned offset;
-	int ret = 0;
+	int ret = -EINVAL;
 	enum pin_config_param param = pinconf_to_config_param(config);
 	enum pin_config_param argument = pinconf_to_config_argument(config);
 
@@ -976,13 +977,32 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	offset = pin - 1;
 
 	switch (param) {
-	case PIN_CONFIG_BIAS_PULL_DOWN:
+	case PIN_CONFIG_BIAS_DISABLE:
+		ret = abx500_gpio_direction_input(chip, offset);
 		/*
-		 * if argument = 1 set the pull down
-		 * else clear the pull down
+		 * Some chips only support pull down, while some actually
+		 * support both pull up and pull down. Such chips have
+		 * a "pullud" range specified for the pins that support
+		 * both features. If the pin is not within that range, we
+		 * fall back to the old bit set that only support pull down.
 		 */
+		if (pullud &&
+		    pin >= pullud->first_pin &&
+		    pin <= pullud->last_pin)
+			ret = abx500_set_pull_updown(pct,
+				pin,
+				ABX500_GPIO_PULL_NONE);
+		else
+			/* Chip only supports pull down */
+			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
+				offset, ABX500_GPIO_PULL_NONE);
+		break;
+
+	case PIN_CONFIG_BIAS_PULL_DOWN:
 		ret = abx500_gpio_direction_input(chip, offset);
 		/*
+		 * if argument = 1 set the pull down
+		 * else clear the pull down
 		 * Some chips only support pull down, while some actually
 		 * support both pull up and pull down. Such chips have
 		 * a "pullud" range specified for the pins that support
@@ -1002,6 +1022,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		break;
 
 	case PIN_CONFIG_BIAS_PULL_UP:
+		ret = abx500_gpio_direction_input(chip, offset);
 		/*
 		 * if argument = 1 set the pull up
 		 * else clear the pull up
@@ -1030,8 +1051,6 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 
 	default:
 		dev_err(chip->dev, "illegal configuration requested\n");
-
-		return -EINVAL;
 	}
 
 	return ret;
-- 
1.7.10

