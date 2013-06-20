Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323Ab3FTOHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:07:12 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59555 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030294Ab3FTOHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:07:09 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH v2 4/4] pinctrl: abx500: rework error path
Date: Thu, 20 Jun 2013 16:05:45 +0200
Message-Id: <1371737145-27662-5-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

At several places, return value was not tested
and error output was missing.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |  114 +++++++++++++++++++++++++++++---------
 1 file changed, 87 insertions(+), 27 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index f1ff701..2b1da8f 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -131,8 +131,8 @@ static int abx500_gpio_get_bit(struct gpio_chip *chip, u8 reg,
 
 	if (ret < 0)
 		dev_err(pct->dev,
-			"%s read reg =%x, offset=%x failed\n",
-			__func__, reg, offset);
+			"%s read reg =%x, offset=%x failed (%d)\n",
+			__func__, reg, offset, ret);
 
 	return ret;
 }
@@ -148,7 +148,8 @@ static int abx500_gpio_set_bits(struct gpio_chip *chip, u8 reg,
 	ret = abx500_mask_and_set_register_interruptible(pct->dev,
 				AB8500_MISC, reg, BIT(pos), val << pos);
 	if (ret < 0)
-		dev_err(pct->dev, "%s write failed\n", __func__);
+		dev_err(pct->dev, "%s write reg, %x offset %x failed (%d)\n",
+				__func__, reg, offset, ret);
 
 	return ret;
 }
@@ -168,10 +169,8 @@ static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
 
 	ret = abx500_gpio_get_bit(chip, AB8500_GPIO_DIR1_REG,
 			gpio_offset, &is_out);
-	if (ret < 0) {
-		dev_err(pct->dev, "%s failed\n", __func__);
-		return ret;
-	}
+	if (ret < 0)
+		goto out;
 
 	if (is_out)
 		ret = abx500_gpio_get_bit(chip, AB8500_GPIO_OUT1_REG,
@@ -179,8 +178,9 @@ static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
 	else
 		ret = abx500_gpio_get_bit(chip, AB8500_GPIO_IN1_REG,
 				gpio_offset, &bit);
+out:
 	if (ret < 0) {
-		dev_err(pct->dev, "%s failed\n", __func__);
+		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
 		return ret;
 	}
 
@@ -194,7 +194,7 @@ static void abx500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 
 	ret = abx500_gpio_set_bits(chip, AB8500_GPIO_OUT1_REG, offset, val);
 	if (ret < 0)
-		dev_err(pct->dev, "%s write failed\n", __func__);
+		dev_err(pct->dev, "%s write failed (%d)\n", __func__, ret);
 }
 
 static int abx500_get_pull_updown(struct abx500_pinctrl *pct, int offset,
@@ -291,7 +291,7 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 				offset,
 				ABX500_GPIO_OUTPUT);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	/* disable pull down */
 	ret = abx500_gpio_set_bits(chip,
@@ -299,7 +299,7 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 				offset,
 				ABX500_GPIO_PULL_NONE);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	/* if supported, disable both pull down and pull up */
 	gpio = offset + 1;
@@ -307,8 +307,11 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 		ret = abx500_set_pull_updown(pct,
 				gpio,
 				ABX500_GPIO_PULL_NONE);
-		if (ret < 0)
-			return ret;
+	}
+out:
+	if (ret < 0) {
+		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
+		return ret;
 	}
 
 	/* set the output as 1 or 0 */
@@ -406,10 +409,16 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 		if (af.alt_bit1 != UNUSED) {
 			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_SEL1_REG,
 					offset, 0);
+			if (ret < 0)
+				goto out;
+
 			ret = abx500_gpio_set_bits(chip,
 					AB8500_GPIO_ALTFUN_REG,
 					af.alt_bit1,
 					!!(af.alta_val && BIT(0)));
+			if (ret < 0)
+				goto out;
+
 			if (af.alt_bit2 != UNUSED)
 				ret = abx500_gpio_set_bits(chip,
 					AB8500_GPIO_ALTFUN_REG,
@@ -423,8 +432,14 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 	case ABX500_ALT_B:
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_SEL1_REG,
 				offset, 0);
+		if (ret < 0)
+			goto out;
+
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_ALTFUN_REG,
 				af.alt_bit1, !!(af.altb_val && BIT(0)));
+		if (ret < 0)
+			goto out;
+
 		if (af.alt_bit2 != UNUSED)
 			ret = abx500_gpio_set_bits(chip,
 					AB8500_GPIO_ALTFUN_REG,
@@ -435,8 +450,14 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 	case ABX500_ALT_C:
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_SEL1_REG,
 				offset, 0);
+		if (ret < 0)
+			goto out;
+
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_ALTFUN_REG,
 				af.alt_bit2, !!(af.altc_val && BIT(0)));
+		if (ret < 0)
+			goto out;
+
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_ALTFUN_REG,
 				af.alt_bit2, !!(af.altc_val && BIT(1)));
 		break;
@@ -446,11 +467,14 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 
 		return -EINVAL;
 	}
+out:
+	if (ret < 0)
+		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
 
 	return ret;
 }
 
-static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
+static int abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 			  unsigned gpio)
 {
 	u8 mode;
@@ -461,6 +485,7 @@ static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 	struct alternate_functions af = pct->soc->alternate_functions[gpio];
 	/* on ABx5xx, there is no GPIO0, so adjust the offset */
 	unsigned offset = gpio - 1;
+	int ret;
 
 	/*
 	 * if gpiosel_bit is set to unused,
@@ -470,8 +495,11 @@ static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 		return ABX500_DEFAULT;
 
 	/* read GpioSelx register */
-	abx500_gpio_get_bit(chip, AB8500_GPIO_SEL1_REG + (offset / 8),
+	ret = abx500_gpio_get_bit(chip, AB8500_GPIO_SEL1_REG + (offset / 8),
 			af.gpiosel_bit, &bit_mode);
+	if (ret < 0)
+		goto out;
+
 	mode = bit_mode;
 
 	/* sanity check */
@@ -503,14 +531,19 @@ static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 	 * pin use the AlternatFunction register
 	 * read alt_bit1 value
 	 */
-	abx500_gpio_get_bit(chip, AB8500_GPIO_ALTFUN_REG,
+	ret = abx500_gpio_get_bit(chip, AB8500_GPIO_ALTFUN_REG,
 			    af.alt_bit1, &alt_bit1);
+	if (ret < 0)
+		goto out;
 
-	if (af.alt_bit2 != UNUSED)
+	if (af.alt_bit2 != UNUSED) {
 		/* read alt_bit2 value */
-		abx500_gpio_get_bit(chip, AB8500_GPIO_ALTFUN_REG, af.alt_bit2,
+		ret = abx500_gpio_get_bit(chip, AB8500_GPIO_ALTFUN_REG,
+				af.alt_bit2,
 				&alt_bit2);
-	else
+		if (ret < 0)
+			goto out;
+	} else
 		alt_bit2 = 0;
 
 	mode = (alt_bit2 << 1) + alt_bit1;
@@ -520,6 +553,10 @@ static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 		return ABX500_ALT_B;
 	else
 		return ABX500_ALT_C;
+
+out:
+	dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
+	return ret;
 }
 
 #ifdef CONFIG_DEBUG_FS
@@ -538,6 +575,7 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 	bool is_out;
 	bool pd;
 	enum abx500_gpio_pull_updown pud = 0;
+	int ret;
 
 	const char *modes[] = {
 		[ABX500_DEFAULT]	= "default",
@@ -553,7 +591,10 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 		[ABX500_GPIO_PULL_UP]		= "pull up",
 	};
 
-	abx500_gpio_get_bit(chip, AB8500_GPIO_DIR1_REG, gpio_offset, &is_out);
+	ret = abx500_gpio_get_bit(chip, AB8500_GPIO_DIR1_REG,
+			gpio_offset, &is_out);
+	if (ret < 0)
+		goto out;
 
 	seq_printf(s, " gpio-%-3d (%-20.20s) %-3s",
 		   gpio, label ?: "(none)",
@@ -561,11 +602,17 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 
 	if (!is_out) {
 		if (abx500_pullud_supported(chip, offset)) {
-			abx500_get_pull_updown(pct, offset, &pud);
+			ret = abx500_get_pull_updown(pct, offset, &pud);
+			if (ret < 0)
+				goto out;
+
 			seq_printf(s, " %-9s", pull_up_down[pud]);
 		} else {
-			abx500_gpio_get_bit(chip, AB8500_GPIO_PUD1_REG,
-					    gpio_offset, &pd);
+			ret = abx500_gpio_get_bit(chip, AB8500_GPIO_PUD1_REG,
+					gpio_offset, &pd);
+			if (ret < 0)
+				goto out;
+
 			seq_printf(s, " %-9s", pull_up_down[pd]);
 		}
 	} else
@@ -575,6 +622,10 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 		mode = abx500_get_mode(pctldev, chip, offset);
 
 	seq_printf(s, " %s", (mode < 0) ? "unknown" : modes[mode]);
+
+out:
+	if (ret < 0)
+		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
 }
 
 static void abx500_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
@@ -678,6 +729,9 @@ static int abx500_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 		ret = abx500_set_mode(pctldev, chip, g->pins[i], g->altsetting);
 	}
 
+	if (ret < 0)
+		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
+
 	return ret;
 }
 
@@ -726,10 +780,8 @@ static int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
 
 	ret = abx500_set_mode(pct->pctldev, &pct->chip,
 			      offset, p->altfunc);
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(pct->dev, "%s setting altfunc failed\n", __func__);
-		return ret;
-	}
 
 	return ret;
 }
@@ -1006,6 +1058,8 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 	switch (param) {
 	case PIN_CONFIG_BIAS_DISABLE:
 		ret = abx500_gpio_direction_input(chip, offset);
+		if (ret < 0)
+			goto out;
 		/*
 		 * Some chips only support pull down, while some actually
 		 * support both pull up and pull down. Such chips have
@@ -1025,6 +1079,8 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 
 	case PIN_CONFIG_BIAS_PULL_DOWN:
 		ret = abx500_gpio_direction_input(chip, offset);
+		if (ret < 0)
+			goto out;
 		/*
 		 * if argument = 1 set the pull down
 		 * else clear the pull down
@@ -1047,6 +1103,8 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 
 	case PIN_CONFIG_BIAS_PULL_UP:
 		ret = abx500_gpio_direction_input(chip, offset);
+		if (ret < 0)
+			goto out;
 		/*
 		 * if argument = 1 set the pull up
 		 * else clear the pull up
@@ -1067,12 +1125,14 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 
 	case PIN_CONFIG_OUTPUT:
 		ret = abx500_gpio_direction_output(chip, offset, argument);
-
 		break;
 
 	default:
 		dev_err(chip->dev, "illegal configuration requested\n");
 	}
+out:
+	if (ret < 0)
+		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
 
 	return ret;
 }
-- 
1.7.10

