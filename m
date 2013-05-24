Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3EXMHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:07:41 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49049 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3EXMHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:07:39 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH 2/3] pinctrl: abx500: allow to set pull up
Date: Fri, 24 May 2013 14:06:30 +0200
Message-Id: <1369397191-16643-3-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1369397191-16643-1-git-send-email-patrice.chotard.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

On ABx500 chip family, all pins support only pull down except for
AB8540 which supports pull up/down on some pins.
Rework abx500_pin_config_set to be able to set pull up on
pins which support this feature.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 7d2e8d7..7f2202a 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -725,7 +725,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	struct pullud *pullud = pct->soc->pullud;
 	struct gpio_chip *chip = &pct->chip;
 	unsigned offset;
-	int ret;
+	int ret = 0;
 	enum pin_config_param param = pinconf_to_config_param(config);
 	enum pin_config_param argument = pinconf_to_config_argument(config);
 
@@ -763,6 +763,28 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 				offset, argument ? 0 : 1);
 		break;
 
+	case PIN_CONFIG_BIAS_PULL_UP:
+		/*
+		 * if argument = 1 set the pull up
+		 * else clear the pull up
+		 */
+		ret = abx500_gpio_direction_input(chip, offset);
+		/*
+		 * Some chips only support pull down, while some actually
+		 * support both pull up and pull down. Such chips have
+		 * a "pullud" range specified for the pins that support
+		 * both features. If the pin is not within that range, do
+		 * nothing
+		 */
+		if (pullud &&
+		    pin >= pullud->first_pin &&
+		    pin <= pullud->last_pin) {
+			ret = abx500_config_pull_updown(pct,
+				pin,
+				argument ? ABX500_GPIO_PULL_UP : ABX500_GPIO_PULL_NONE);
+		}
+		break;
+
 	case PIN_CONFIG_OUTPUT:
 		ret = abx500_gpio_direction_output(chip, offset, argument);
 
-- 
1.7.10

