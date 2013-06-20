Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034Ab3FTOHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:07:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55413 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030296Ab3FTOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:07:06 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH v2 3/4] pinctrl: abx500: factorize code
Date: Thu, 20 Jun 2013 16:05:44 +0200
Message-Id: <1371737145-27662-4-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

Factorize code by adding abx500_pullud_supported()
which improve code readability.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 5bf66ad..f1ff701 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -267,12 +267,21 @@ out:
 	return ret;
 }
 
+static bool abx500_pullud_supported(struct gpio_chip *chip, unsigned gpio)
+{
+	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
+	struct pullud *pullud = pct->soc->pullud;
+
+	return (pullud &&
+		gpio >= pullud->first_pin &&
+		gpio <= pullud->last_pin);
+}
+
 static int abx500_gpio_direction_output(struct gpio_chip *chip,
 					unsigned offset,
 					int val)
 {
 	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
-	struct pullud *pullud = pct->soc->pullud;
 	unsigned gpio;
 	int ret;
 
@@ -294,7 +303,7 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 
 	/* if supported, disable both pull down and pull up */
 	gpio = offset + 1;
-	if (pullud && gpio >= pullud->first_pin && gpio <= pullud->last_pin) {
+	if (abx500_pullud_supported(chip, gpio)) {
 		ret = abx500_set_pull_updown(pct,
 				gpio,
 				ABX500_GPIO_PULL_NONE);
@@ -523,7 +532,6 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 				     unsigned offset, unsigned gpio)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
-	struct pullud *pullud = pct->soc->pullud;
 	const char *label = gpiochip_is_requested(chip, offset - 1);
 	u8 gpio_offset = offset - 1;
 	int mode = -1;
@@ -552,9 +560,7 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 		   is_out ? "out" : "in ");
 
 	if (!is_out) {
-		if (pullud &&
-		   (offset >= pullud->first_pin) &&
-		   (offset <= pullud->last_pin)) {
+		if (abx500_pullud_supported(chip, offset)) {
 			abx500_get_pull_updown(pct, offset, &pud);
 			seq_printf(s, " %-9s", pull_up_down[pud]);
 		} else {
@@ -983,7 +989,6 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 			  unsigned long config)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
-	struct pullud *pullud = pct->soc->pullud;
 	struct gpio_chip *chip = &pct->chip;
 	unsigned offset;
 	int ret = -EINVAL;
@@ -1008,9 +1013,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		 * both features. If the pin is not within that range, we
 		 * fall back to the old bit set that only support pull down.
 		 */
-		if (pullud &&
-		    pin >= pullud->first_pin &&
-		    pin <= pullud->last_pin)
+		if (abx500_pullud_supported(chip, pin))
 			ret = abx500_set_pull_updown(pct,
 				pin,
 				ABX500_GPIO_PULL_NONE);
@@ -1031,9 +1034,7 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		 * both features. If the pin is not within that range, we
 		 * fall back to the old bit set that only support pull down.
 		 */
-		if (pullud &&
-		    pin >= pullud->first_pin &&
-		    pin <= pullud->last_pin)
+		if (abx500_pullud_supported(chip, pin))
 			ret = abx500_set_pull_updown(pct,
 				pin,
 				argument ? ABX500_GPIO_PULL_DOWN : ABX500_GPIO_PULL_NONE);
@@ -1058,13 +1059,10 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		 * both features. If the pin is not within that range, do
 		 * nothing
 		 */
-		if (pullud &&
-		    pin >= pullud->first_pin &&
-		    pin <= pullud->last_pin) {
+		if (abx500_pullud_supported(chip, pin))
 			ret = abx500_set_pull_updown(pct,
 				pin,
 				argument ? ABX500_GPIO_PULL_UP : ABX500_GPIO_PULL_NONE);
-		}
 		break;
 
 	case PIN_CONFIG_OUTPUT:
-- 
1.7.10

