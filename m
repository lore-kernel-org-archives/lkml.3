Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3HVBUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 21:20:43 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4057 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab3HVBUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 21:20:41 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Sherman Yin" <syin@broadcom.com>
To: linus.walleij@linaro.org
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mips@linux-mips.org, matt.porter@linaro.org,
        "Sherman Yin" <syin@broadcom.com>
Subject: [PATCH v2] pinctrl: Pass all configs to driver on
 pin_config_set()
Date: Wed, 21 Aug 2013 18:18:20 -0700
Message-ID: <1377134300-25480-1-git-send-email-syin@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376606573-15093-1-git-send-email-syin@broadcom.com>
References: <1376606573-15093-1-git-send-email-syin@broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7E0BB9F931W86689201-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting pin configuration in the pinctrl framework, pin_config_set() or
pin_config_group_set() is called in a loop to set one configuration at a time
for the specified pin or group.

This patch 1) removes the loop and 2) changes the API to pass the whole pin
config array to the driver.  It is now up to the driver to loop through the
configs.  This allows the driver to potentially combine configs and reduce the
number of writes to pin config registers.

All c files changed have been build-tested to verify the change compiles and
that the corresponding .o is successfully generated.

Signed-off-by: Sherman Yin <syin@broadcom.com>
Reviewed-by: Christian Daudt <csd@broadcom.com>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
Please refer to the discussion with Linus W. "[PATCH] ARM: Adds pin config API
to set all configs in one function" here:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166567.html

All c files changed have been build-tested to verify the change compiles and
that the corresponding .o are successfully generated.

[v2]	rebased on LinusW's linux-pinctrl.git "devel" branch.  Fixed and build-
	tested pinctrl-sunxi.c
---
 drivers/pinctrl/mvebu/pinctrl-mvebu.c |   26 +++--
 drivers/pinctrl/pinconf.c             |   42 ++++----
 drivers/pinctrl/pinctrl-abx500.c      |  187 ++++++++++++++++++---------------
 drivers/pinctrl/pinctrl-at91.c        |   48 +++++----
 drivers/pinctrl/pinctrl-bcm2835.c     |   43 ++++----
 drivers/pinctrl/pinctrl-exynos5440.c  |  113 +++++++++++---------
 drivers/pinctrl/pinctrl-falcon.c      |   63 ++++++-----
 drivers/pinctrl/pinctrl-imx.c         |   28 ++---
 drivers/pinctrl/pinctrl-mxs.c         |   91 ++++++++--------
 drivers/pinctrl/pinctrl-nomadik.c     |  125 ++++++++++++----------
 drivers/pinctrl/pinctrl-rockchip.c    |   57 ++++++----
 drivers/pinctrl/pinctrl-samsung.c     |   17 ++-
 drivers/pinctrl/pinctrl-single.c      |   33 ++++--
 drivers/pinctrl/pinctrl-st.c          |   11 +-
 drivers/pinctrl/pinctrl-sunxi.c       |   95 +++++++++--------
 drivers/pinctrl/pinctrl-tegra.c       |   69 ++++++------
 drivers/pinctrl/pinctrl-tz1090-pdc.c  |  135 ++++++++++++++----------
 drivers/pinctrl/pinctrl-tz1090.c      |  140 +++++++++++++-----------
 drivers/pinctrl/pinctrl-u300.c        |   18 ++--
 drivers/pinctrl/pinctrl-xway.c        |  119 +++++++++++++--------
 drivers/pinctrl/sh-pfc/pinctrl.c      |   42 ++++----
 drivers/pinctrl/vt8500/pinctrl-wmt.c  |   54 +++++-----
 include/linux/pinctrl/pinconf.h       |    6 +-
 23 files changed, 889 insertions(+), 673 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-mvebu.c b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
index bb7ddb1..e78c041 100644
--- a/drivers/pinctrl/mvebu/pinctrl-mvebu.c
+++ b/drivers/pinctrl/mvebu/pinctrl-mvebu.c
@@ -191,18 +191,27 @@ static int mvebu_pinconf_group_get(struct pinctrl_dev *pctldev,
 }
 
 static int mvebu_pinconf_group_set(struct pinctrl_dev *pctldev,
-				unsigned gid, unsigned long config)
+				unsigned gid, unsigned long *configs,
+				unsigned num_configs)
 {
 	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
 	struct mvebu_pinctrl_group *grp = &pctl->groups[gid];
+	int i, ret;
 
 	if (!grp->ctrl)
 		return -EINVAL;
 
-	if (grp->ctrl->mpp_set)
-		return grp->ctrl->mpp_set(grp->ctrl, config);
+	for (i = 0; i < num_configs; i++) {
+		if (grp->ctrl->mpp_set)
+			ret = grp->ctrl->mpp_set(grp->ctrl, configs[i]);
+		else
+			ret = mvebu_common_mpp_set(pctl, grp, configs[i]);
 
-	return mvebu_common_mpp_set(pctl, grp, config);
+		if (ret)
+			return ret;
+	} /* for each config */
+
+	return 0;
 }
 
 static void mvebu_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
@@ -303,6 +312,7 @@ static int mvebu_pinmux_enable(struct pinctrl_dev *pctldev, unsigned fid,
 	struct mvebu_pinctrl_group *grp = &pctl->groups[gid];
 	struct mvebu_mpp_ctrl_setting *setting;
 	int ret;
+	unsigned long config;
 
 	setting = mvebu_pinctrl_find_setting_by_name(pctl, grp,
 						     func->name);
@@ -313,7 +323,8 @@ static int mvebu_pinmux_enable(struct pinctrl_dev *pctldev, unsigned fid,
 		return -EINVAL;
 	}
 
-	ret = mvebu_pinconf_group_set(pctldev, grp->gid, setting->val);
+	config = setting->val;
+	ret = mvebu_pinconf_group_set(pctldev, grp->gid, &config, 1);
 	if (ret) {
 		dev_err(pctl->dev, "cannot set group %s to %s\n",
 			func->groups[gid], func->name);
@@ -329,6 +340,7 @@ static int mvebu_pinmux_gpio_request_enable(struct pinctrl_dev *pctldev,
 	struct mvebu_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
 	struct mvebu_pinctrl_group *grp;
 	struct mvebu_mpp_ctrl_setting *setting;
+	unsigned long config;
 
 	grp = mvebu_pinctrl_find_group_by_pid(pctl, offset);
 	if (!grp)
@@ -341,7 +353,9 @@ static int mvebu_pinmux_gpio_request_enable(struct pinctrl_dev *pctldev,
 	if (!setting)
 		return -ENOTSUPP;
 
-	return mvebu_pinconf_group_set(pctldev, grp->gid, setting->val);
+	config = setting->val;
+
+	return mvebu_pinconf_group_set(pctldev, grp->gid, &config, 1);
 }
 
 static int mvebu_pinmux_gpio_set_direction(struct pinctrl_dev *pctldev,
diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 8da2d6d..a138965 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -158,7 +158,7 @@ int pinconf_apply_setting(struct pinctrl_setting const *setting)
 {
 	struct pinctrl_dev *pctldev = setting->pctldev;
 	const struct pinconf_ops *ops = pctldev->desc->confops;
-	int i, ret;
+	int ret;
 
 	if (!ops) {
 		dev_err(pctldev->dev, "missing confops\n");
@@ -171,17 +171,15 @@ int pinconf_apply_setting(struct pinctrl_setting const *setting)
 			dev_err(pctldev->dev, "missing pin_config_set op\n");
 			return -EINVAL;
 		}
-		for (i = 0; i < setting->data.configs.num_configs; i++) {
-			ret = ops->pin_config_set(pctldev,
-					setting->data.configs.group_or_pin,
-					setting->data.configs.configs[i]);
-			if (ret < 0) {
-				dev_err(pctldev->dev,
-					"pin_config_set op failed for pin %d config %08lx\n",
-					setting->data.configs.group_or_pin,
-					setting->data.configs.configs[i]);
-				return ret;
-			}
+		ret = ops->pin_config_set(pctldev,
+				setting->data.configs.group_or_pin,
+				setting->data.configs.configs,
+				setting->data.configs.num_configs);
+		if (ret < 0) {
+			dev_err(pctldev->dev,
+				"pin_config_set op failed for pin %d\n",
+				setting->data.configs.group_or_pin);
+			return ret;
 		}
 		break;
 	case PIN_MAP_TYPE_CONFIGS_GROUP:
@@ -190,17 +188,15 @@ int pinconf_apply_setting(struct pinctrl_setting const *setting)
 				"missing pin_config_group_set op\n");
 			return -EINVAL;
 		}
-		for (i = 0; i < setting->data.configs.num_configs; i++) {
-			ret = ops->pin_config_group_set(pctldev,
-					setting->data.configs.group_or_pin,
-					setting->data.configs.configs[i]);
-			if (ret < 0) {
-				dev_err(pctldev->dev,
-					"pin_config_group_set op failed for group %d config %08lx\n",
-					setting->data.configs.group_or_pin,
-					setting->data.configs.configs[i]);
-				return ret;
-			}
+		ret = ops->pin_config_group_set(pctldev,
+				setting->data.configs.group_or_pin,
+				setting->data.configs.configs,
+				setting->data.configs.num_configs);
+		if (ret < 0) {
+			dev_err(pctldev->dev,
+				"pin_config_group_set op failed for group %d\n",
+				setting->data.configs.group_or_pin);
+			return ret;
 		}
 		break;
 	default:
diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 1d3f988..8f25df0 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -1041,98 +1041,115 @@ static int abx500_pin_config_get(struct pinctrl_dev *pctldev,
 
 static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 			  unsigned pin,
-			  unsigned long config)
+			  unsigned long *configs,
+			  unsigned num_configs)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 	struct gpio_chip *chip = &pct->chip;
 	unsigned offset;
 	int ret = -EINVAL;
-	enum pin_config_param param = pinconf_to_config_param(config);
-	enum pin_config_param argument = pinconf_to_config_argument(config);
-
-	dev_dbg(chip->dev, "pin %d [%#lx]: %s %s\n",
-		pin, config, (param == PIN_CONFIG_OUTPUT) ? "output " : "input",
-		(param == PIN_CONFIG_OUTPUT) ? (argument ? "high" : "low") :
-		(argument ? "pull up" : "pull down"));
-
-	/* on ABx500, there is no GPIO0, so adjust the offset */
-	offset = pin - 1;
-
-	switch (param) {
-	case PIN_CONFIG_BIAS_DISABLE:
-		ret = abx500_gpio_direction_input(chip, offset);
-		if (ret < 0)
-			goto out;
-		/*
-		 * Some chips only support pull down, while some actually
-		 * support both pull up and pull down. Such chips have
-		 * a "pullud" range specified for the pins that support
-		 * both features. If the pin is not within that range, we
-		 * fall back to the old bit set that only support pull down.
-		 */
-		if (abx500_pullud_supported(chip, pin))
-			ret = abx500_set_pull_updown(pct,
-				pin,
-				ABX500_GPIO_PULL_NONE);
-		else
-			/* Chip only supports pull down */
-			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
-				offset, ABX500_GPIO_PULL_NONE);
-		break;
-
-	case PIN_CONFIG_BIAS_PULL_DOWN:
-		ret = abx500_gpio_direction_input(chip, offset);
-		if (ret < 0)
-			goto out;
-		/*
-		 * if argument = 1 set the pull down
-		 * else clear the pull down
-		 * Some chips only support pull down, while some actually
-		 * support both pull up and pull down. Such chips have
-		 * a "pullud" range specified for the pins that support
-		 * both features. If the pin is not within that range, we
-		 * fall back to the old bit set that only support pull down.
-		 */
-		if (abx500_pullud_supported(chip, pin))
-			ret = abx500_set_pull_updown(pct,
-				pin,
-				argument ? ABX500_GPIO_PULL_DOWN : ABX500_GPIO_PULL_NONE);
-		else
-			/* Chip only supports pull down */
-			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
-				offset,
-				argument ? ABX500_GPIO_PULL_DOWN : ABX500_GPIO_PULL_NONE);
-		break;
-
-	case PIN_CONFIG_BIAS_PULL_UP:
-		ret = abx500_gpio_direction_input(chip, offset);
-		if (ret < 0)
-			goto out;
-		/*
-		 * if argument = 1 set the pull up
-		 * else clear the pull up
-		 */
-		ret = abx500_gpio_direction_input(chip, offset);
-		/*
-		 * Some chips only support pull down, while some actually
-		 * support both pull up and pull down. Such chips have
-		 * a "pullud" range specified for the pins that support
-		 * both features. If the pin is not within that range, do
-		 * nothing
-		 */
-		if (abx500_pullud_supported(chip, pin))
-			ret = abx500_set_pull_updown(pct,
-				pin,
-				argument ? ABX500_GPIO_PULL_UP : ABX500_GPIO_PULL_NONE);
-		break;
+	int i;
+	enum pin_config_param param;
+	enum pin_config_param argument;
+
+	for (i = 0; i < num_configs; i++) {
+		param = pinconf_to_config_param(configs[i]);
+		argument = pinconf_to_config_argument(configs[i]);
+
+		dev_dbg(chip->dev, "pin %d [%#lx]: %s %s\n",
+			pin, configs[i],
+			(param == PIN_CONFIG_OUTPUT) ? "output " : "input",
+			(param == PIN_CONFIG_OUTPUT) ?
+			(argument ? "high" : "low") :
+			(argument ? "pull up" : "pull down"));
+
+		/* on ABx500, there is no GPIO0, so adjust the offset */
+		offset = pin - 1;
+
+		switch (param) {
+		case PIN_CONFIG_BIAS_DISABLE:
+			ret = abx500_gpio_direction_input(chip, offset);
+			if (ret < 0)
+				goto out;
+			/*
+			 * Some chips only support pull down, while some
+			 * actually support both pull up and pull down. Such
+			 * chips have a "pullud" range specified for the pins
+			 * that support both features. If the pin is not
+			 * within that range, we fall back to the old bit set
+			 * that only support pull down.
+			 */
+			if (abx500_pullud_supported(chip, pin))
+				ret = abx500_set_pull_updown(pct,
+					pin,
+					ABX500_GPIO_PULL_NONE);
+			else
+				/* Chip only supports pull down */
+				ret = abx500_gpio_set_bits(chip,
+					AB8500_GPIO_PUD1_REG, offset,
+					ABX500_GPIO_PULL_NONE);
+			break;
 
-	case PIN_CONFIG_OUTPUT:
-		ret = abx500_gpio_direction_output(chip, offset, argument);
-		break;
+		case PIN_CONFIG_BIAS_PULL_DOWN:
+			ret = abx500_gpio_direction_input(chip, offset);
+			if (ret < 0)
+				goto out;
+			/*
+			 * if argument = 1 set the pull down
+			 * else clear the pull down
+			 * Some chips only support pull down, while some
+			 * actually support both pull up and pull down. Such
+			 * chips have a "pullud" range specified for the pins
+			 * that support both features. If the pin is not
+			 * within that range, we fall back to the old bit set
+			 * that only support pull down.
+			 */
+			if (abx500_pullud_supported(chip, pin))
+				ret = abx500_set_pull_updown(pct,
+					pin,
+					argument ? ABX500_GPIO_PULL_DOWN :
+					ABX500_GPIO_PULL_NONE);
+			else
+				/* Chip only supports pull down */
+				ret = abx500_gpio_set_bits(chip,
+				AB8500_GPIO_PUD1_REG,
+					offset,
+					argument ? ABX500_GPIO_PULL_DOWN :
+					ABX500_GPIO_PULL_NONE);
+			break;
 
-	default:
-		dev_err(chip->dev, "illegal configuration requested\n");
-	}
+		case PIN_CONFIG_BIAS_PULL_UP:
+			ret = abx500_gpio_direction_input(chip, offset);
+			if (ret < 0)
+				goto out;
+			/*
+			 * if argument = 1 set the pull up
+			 * else clear the pull up
+			 */
+			ret = abx500_gpio_direction_input(chip, offset);
+			/*
+			 * Some chips only support pull down, while some
+			 * actually support both pull up and pull down. Such
+			 * chips have a "pullud" range specified for the pins
+			 * that support both features. If the pin is not
+			 * within that range, do nothing
+			 */
+			if (abx500_pullud_supported(chip, pin))
+				ret = abx500_set_pull_updown(pct,
+					pin,
+					argument ? ABX500_GPIO_PULL_UP :
+					ABX500_GPIO_PULL_NONE);
+			break;
+
+		case PIN_CONFIG_OUTPUT:
+			ret = abx500_gpio_direction_output(chip, offset,
+				argument);
+			break;
+
+		default:
+			dev_err(chip->dev, "illegal configuration requested\n");
+		}
+	} /* for each config */
 out:
 	if (ret < 0)
 		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 7cce066..9685ff6 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -736,30 +736,40 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int at91_pinconf_set(struct pinctrl_dev *pctldev,
-			     unsigned pin_id, unsigned long config)
+			     unsigned pin_id, unsigned long *configs,
+			     unsigned num_configs)
 {
 	struct at91_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	unsigned mask;
 	void __iomem *pio;
-
-	dev_dbg(info->dev, "%s:%d, pin_id=%d, config=0x%lx", __func__, __LINE__, pin_id, config);
-	pio = pin_to_controller(info, pin_to_bank(pin_id));
-	mask = pin_to_mask(pin_id % MAX_NB_GPIO_PER_BANK);
-
-	if (config & PULL_UP && config & PULL_DOWN)
-		return -EINVAL;
-
-	at91_mux_set_pullup(pio, mask, config & PULL_UP);
-	at91_mux_set_multidrive(pio, mask, config & MULTI_DRIVE);
-	if (info->ops->set_deglitch)
-		info->ops->set_deglitch(pio, mask, config & DEGLITCH);
-	if (info->ops->set_debounce)
-		info->ops->set_debounce(pio, mask, config & DEBOUNCE,
+	int i;
+	unsigned long config;
+
+	for (i = 0; i < num_configs; i++) {
+		config = configs[i];
+
+		dev_dbg(info->dev,
+			"%s:%d, pin_id=%d, config=0x%lx",
+			__func__, __LINE__, pin_id, config);
+		pio = pin_to_controller(info, pin_to_bank(pin_id));
+		mask = pin_to_mask(pin_id % MAX_NB_GPIO_PER_BANK);
+
+		if (config & PULL_UP && config & PULL_DOWN)
+			return -EINVAL;
+
+		at91_mux_set_pullup(pio, mask, config & PULL_UP);
+		at91_mux_set_multidrive(pio, mask, config & MULTI_DRIVE);
+		if (info->ops->set_deglitch)
+			info->ops->set_deglitch(pio, mask, config & DEGLITCH);
+		if (info->ops->set_debounce)
+			info->ops->set_debounce(pio, mask, config & DEBOUNCE,
 				(config & DEBOUNCE_VAL) >> DEBOUNCE_VAL_SHIFT);
-	if (info->ops->set_pulldown)
-		info->ops->set_pulldown(pio, mask, config & PULL_DOWN);
-	if (info->ops->disable_schmitt_trig && config & DIS_SCHMIT)
-		info->ops->disable_schmitt_trig(pio, mask);
+		if (info->ops->set_pulldown)
+			info->ops->set_pulldown(pio, mask, config & PULL_DOWN);
+		if (info->ops->disable_schmitt_trig && config & DIS_SCHMIT)
+			info->ops->disable_schmitt_trig(pio, mask);
+
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index a1c88b3..c05c1ef 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -893,28 +893,35 @@ static int bcm2835_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int bcm2835_pinconf_set(struct pinctrl_dev *pctldev,
-			unsigned pin, unsigned long config)
+			unsigned pin, unsigned long *configs,
+			unsigned num_configs)
 {
 	struct bcm2835_pinctrl *pc = pinctrl_dev_get_drvdata(pctldev);
-	enum bcm2835_pinconf_param param = BCM2835_PINCONF_UNPACK_PARAM(config);
-	u16 arg = BCM2835_PINCONF_UNPACK_ARG(config);
+	enum bcm2835_pinconf_param param;
+	u16 arg;
 	u32 off, bit;
+	int i;
 
-	if (param != BCM2835_PINCONF_PARAM_PULL)
-		return -EINVAL;
-
-	off = GPIO_REG_OFFSET(pin);
-	bit = GPIO_REG_SHIFT(pin);
-
-	bcm2835_gpio_wr(pc, GPPUD, arg & 3);
-	/*
-	 * Docs say to wait 150 cycles, but not of what. We assume a
-	 * 1 MHz clock here, which is pretty slow...
-	 */
-	udelay(150);
-	bcm2835_gpio_wr(pc, GPPUDCLK0 + (off * 4), BIT(bit));
-	udelay(150);
-	bcm2835_gpio_wr(pc, GPPUDCLK0 + (off * 4), 0);
+	for (i = 0; i < num_configs; i++) {
+		param = BCM2835_PINCONF_UNPACK_PARAM(configs[i]);
+		arg = BCM2835_PINCONF_UNPACK_ARG(configs[i]);
+
+		if (param != BCM2835_PINCONF_PARAM_PULL)
+			return -EINVAL;
+
+		off = GPIO_REG_OFFSET(pin);
+		bit = GPIO_REG_SHIFT(pin);
+
+		bcm2835_gpio_wr(pc, GPPUD, arg & 3);
+		/*
+		 * Docs say to wait 150 cycles, but not of what. We assume a
+		 * 1 MHz clock here, which is pretty slow...
+		 */
+		udelay(150);
+		bcm2835_gpio_wr(pc, GPPUDCLK0 + (off * 4), BIT(bit));
+		udelay(150);
+		bcm2835_gpio_wr(pc, GPPUDCLK0 + (off * 4), 0);
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index 3b283fd..544d469 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -401,64 +401,71 @@ static const struct pinmux_ops exynos5440_pinmux_ops = {
 
 /* set the pin config settings for a specified pin */
 static int exynos5440_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
-				unsigned long config)
+				unsigned long *configs,
+				unsigned num_configs)
 {
 	struct exynos5440_pinctrl_priv_data *priv;
 	void __iomem *base;
-	enum pincfg_type cfg_type = PINCFG_UNPACK_TYPE(config);
-	u32 cfg_value = PINCFG_UNPACK_VALUE(config);
+	enum pincfg_type cfg_type;
+	u32 cfg_value;
 	u32 data;
+	int i;
 
 	priv = pinctrl_dev_get_drvdata(pctldev);
 	base = priv->reg_base;
 
-	switch (cfg_type) {
-	case PINCFG_TYPE_PUD:
-		/* first set pull enable/disable bit */
-		data = readl(base + GPIO_PE);
-		data &= ~(1 << pin);
-		if (cfg_value)
-			data |= (1 << pin);
-		writel(data, base + GPIO_PE);
-
-		/* then set pull up/down bit */
-		data = readl(base + GPIO_PS);
-		data &= ~(1 << pin);
-		if (cfg_value == 2)
-			data |= (1 << pin);
-		writel(data, base + GPIO_PS);
-		break;
-
-	case PINCFG_TYPE_DRV:
-		/* set the first bit of the drive strength */
-		data = readl(base + GPIO_DS0);
-		data &= ~(1 << pin);
-		data |= ((cfg_value & 1) << pin);
-		writel(data, base + GPIO_DS0);
-		cfg_value >>= 1;
-
-		/* set the second bit of the driver strength */
-		data = readl(base + GPIO_DS1);
-		data &= ~(1 << pin);
-		data |= ((cfg_value & 1) << pin);
-		writel(data, base + GPIO_DS1);
-		break;
-	case PINCFG_TYPE_SKEW_RATE:
-		data = readl(base + GPIO_SR);
-		data &= ~(1 << pin);
-		data |= ((cfg_value & 1) << pin);
-		writel(data, base + GPIO_SR);
-		break;
-	case PINCFG_TYPE_INPUT_TYPE:
-		data = readl(base + GPIO_TYPE);
-		data &= ~(1 << pin);
-		data |= ((cfg_value & 1) << pin);
-		writel(data, base + GPIO_TYPE);
-		break;
-	default:
-		WARN_ON(1);
-		return -EINVAL;
-	}
+	for (i = 0; i < num_configs; i++) {
+		cfg_type = PINCFG_UNPACK_TYPE(configs[i]);
+		cfg_value = PINCFG_UNPACK_VALUE(configs[i]);
+
+		switch (cfg_type) {
+		case PINCFG_TYPE_PUD:
+			/* first set pull enable/disable bit */
+			data = readl(base + GPIO_PE);
+			data &= ~(1 << pin);
+			if (cfg_value)
+				data |= (1 << pin);
+			writel(data, base + GPIO_PE);
+
+			/* then set pull up/down bit */
+			data = readl(base + GPIO_PS);
+			data &= ~(1 << pin);
+			if (cfg_value == 2)
+				data |= (1 << pin);
+			writel(data, base + GPIO_PS);
+			break;
+
+		case PINCFG_TYPE_DRV:
+			/* set the first bit of the drive strength */
+			data = readl(base + GPIO_DS0);
+			data &= ~(1 << pin);
+			data |= ((cfg_value & 1) << pin);
+			writel(data, base + GPIO_DS0);
+			cfg_value >>= 1;
+
+			/* set the second bit of the driver strength */
+			data = readl(base + GPIO_DS1);
+			data &= ~(1 << pin);
+			data |= ((cfg_value & 1) << pin);
+			writel(data, base + GPIO_DS1);
+			break;
+		case PINCFG_TYPE_SKEW_RATE:
+			data = readl(base + GPIO_SR);
+			data &= ~(1 << pin);
+			data |= ((cfg_value & 1) << pin);
+			writel(data, base + GPIO_SR);
+			break;
+		case PINCFG_TYPE_INPUT_TYPE:
+			data = readl(base + GPIO_TYPE);
+			data &= ~(1 << pin);
+			data |= ((cfg_value & 1) << pin);
+			writel(data, base + GPIO_TYPE);
+			break;
+		default:
+			WARN_ON(1);
+			return -EINVAL;
+		}
+	} /* for each config */
 
 	return 0;
 }
@@ -510,7 +517,8 @@ static int exynos5440_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
 
 /* set the pin config settings for a specified pin group */
 static int exynos5440_pinconf_group_set(struct pinctrl_dev *pctldev,
-			unsigned group, unsigned long config)
+			unsigned group, unsigned long *configs,
+			unsigned num_configs)
 {
 	struct exynos5440_pinctrl_priv_data *priv;
 	const unsigned int *pins;
@@ -520,7 +528,8 @@ static int exynos5440_pinconf_group_set(struct pinctrl_dev *pctldev,
 	pins = priv->pin_groups[group].pins;
 
 	for (cnt = 0; cnt < priv->pin_groups[group].num_pins; cnt++)
-		exynos5440_pinconf_set(pctldev, pins[cnt], config);
+		exynos5440_pinconf_set(pctldev, pins[cnt], configs,
+				       num_configs);
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index 4e731f2..2e62689 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -238,7 +238,8 @@ static int falcon_pinconf_group_get(struct pinctrl_dev *pctrldev,
 }
 
 static int falcon_pinconf_group_set(struct pinctrl_dev *pctrldev,
-				unsigned group, unsigned long config)
+				unsigned group, unsigned long *configs,
+				unsigned num_configs)
 {
 	return -ENOTSUPP;
 }
@@ -279,39 +280,47 @@ static int falcon_pinconf_get(struct pinctrl_dev *pctrldev,
 }
 
 static int falcon_pinconf_set(struct pinctrl_dev *pctrldev,
-			unsigned pin, unsigned long config)
+			unsigned pin, unsigned long *configs,
+			unsigned num_configs)
 {
-	enum ltq_pinconf_param param = LTQ_PINCONF_UNPACK_PARAM(config);
-	int arg = LTQ_PINCONF_UNPACK_ARG(config);
+	enum ltq_pinconf_param param;
+	int arg;
 	struct ltq_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
 	void __iomem *mem = info->membase[PORT(pin)];
 	u32 reg;
+	int i;
 
-	switch (param) {
-	case LTQ_PINCONF_PARAM_DRIVE_CURRENT:
-		reg = LTQ_PADC_DCC;
-		break;
-
-	case LTQ_PINCONF_PARAM_SLEW_RATE:
-		reg = LTQ_PADC_SRC;
-		break;
-
-	case LTQ_PINCONF_PARAM_PULL:
-		if (arg == 1)
-			reg = LTQ_PADC_PDEN;
-		else
-			reg = LTQ_PADC_PUEN;
-		break;
+	for (i = 0; i < num_configs; i++) {
+		param = LTQ_PINCONF_UNPACK_PARAM(configs[i]);
+		arg = LTQ_PINCONF_UNPACK_ARG(configs[i]);
+
+		switch (param) {
+		case LTQ_PINCONF_PARAM_DRIVE_CURRENT:
+			reg = LTQ_PADC_DCC;
+			break;
+
+		case LTQ_PINCONF_PARAM_SLEW_RATE:
+			reg = LTQ_PADC_SRC;
+			break;
+
+		case LTQ_PINCONF_PARAM_PULL:
+			if (arg == 1)
+				reg = LTQ_PADC_PDEN;
+			else
+				reg = LTQ_PADC_PUEN;
+			break;
+
+		default:
+			pr_err("%s: Invalid config param %04x\n",
+			pinctrl_dev_get_name(pctrldev), param);
+			return -ENOTSUPP;
+		}
 
-	default:
-		pr_err("%s: Invalid config param %04x\n",
-		pinctrl_dev_get_name(pctrldev), param);
-		return -ENOTSUPP;
-	}
+		pad_w32(mem, BIT(PORT_PIN(pin)), reg);
+		if (!(pad_r32(mem, reg) & BIT(PORT_PIN(pin))))
+			return -ENOTSUPP;
+	} /* for each config */
 
-	pad_w32(mem, BIT(PORT_PIN(pin)), reg);
-	if (!(pad_r32(mem, reg) & BIT(PORT_PIN(pin))))
-		return -ENOTSUPP;
 	return 0;
 }
 
diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 3a14245..51f3a49 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -335,11 +335,13 @@ static int imx_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int imx_pinconf_set(struct pinctrl_dev *pctldev,
-			     unsigned pin_id, unsigned long config)
+			     unsigned pin_id, unsigned long *configs,
+			     unsigned num_configs)
 {
 	struct imx_pinctrl *ipctl = pinctrl_dev_get_drvdata(pctldev);
 	const struct imx_pinctrl_soc_info *info = ipctl->info;
 	const struct imx_pin_reg *pin_reg = &info->pin_regs[pin_id];
+	int i;
 
 	if (!(info->flags & ZERO_OFFSET_VALID) && !pin_reg->conf_reg) {
 		dev_err(info->dev, "Pin(%s) does not support config function\n",
@@ -350,17 +352,19 @@ static int imx_pinconf_set(struct pinctrl_dev *pctldev,
 	dev_dbg(ipctl->dev, "pinconf set pin %s\n",
 		info->pins[pin_id].name);
 
-	if (info->flags & SHARE_MUX_CONF_REG) {
-		u32 reg;
-		reg = readl(ipctl->base + pin_reg->conf_reg);
-		reg &= ~0xffff;
-		reg |= config;
-		writel(reg, ipctl->base + pin_reg->conf_reg);
-	} else {
-		writel(config, ipctl->base + pin_reg->conf_reg);
-	}
-	dev_dbg(ipctl->dev, "write: offset 0x%x val 0x%lx\n",
-		pin_reg->conf_reg, config);
+	for (i = 0; i < num_configs; i++) {
+		if (info->flags & SHARE_MUX_CONF_REG) {
+			u32 reg;
+			reg = readl(ipctl->base + pin_reg->conf_reg);
+			reg &= ~0xffff;
+			reg |= configs[i];
+			writel(reg, ipctl->base + pin_reg->conf_reg);
+		} else {
+			writel(configs[i], ipctl->base + pin_reg->conf_reg);
+		}
+		dev_dbg(ipctl->dev, "write: offset 0x%x val 0x%lx\n",
+			pin_reg->conf_reg, configs[i]);
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/pinctrl-mxs.c
index f5d5643..40c76f2 100644
--- a/drivers/pinctrl/pinctrl-mxs.c
+++ b/drivers/pinctrl/pinctrl-mxs.c
@@ -233,7 +233,8 @@ static int mxs_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int mxs_pinconf_set(struct pinctrl_dev *pctldev,
-			   unsigned pin, unsigned long config)
+			   unsigned pin, unsigned long *configs,
+			   unsigned num_configs)
 {
 	return -ENOTSUPP;
 }
@@ -249,7 +250,8 @@ static int mxs_pinconf_group_get(struct pinctrl_dev *pctldev,
 }
 
 static int mxs_pinconf_group_set(struct pinctrl_dev *pctldev,
-				 unsigned group, unsigned long config)
+				 unsigned group, unsigned long *configs,
+				 unsigned num_configs)
 {
 	struct mxs_pinctrl_data *d = pinctrl_dev_get_drvdata(pctldev);
 	struct mxs_group *g = &d->soc->groups[group];
@@ -257,49 +259,56 @@ static int mxs_pinconf_group_set(struct pinctrl_dev *pctldev,
 	u8 ma, vol, pull, bank, shift;
 	u16 pin;
 	u32 i;
+	int n;
+	unsigned long config;
 
-	ma = CONFIG_TO_MA(config);
-	vol = CONFIG_TO_VOL(config);
-	pull = CONFIG_TO_PULL(config);
-
-	for (i = 0; i < g->npins; i++) {
-		bank = PINID_TO_BANK(g->pins[i]);
-		pin = PINID_TO_PIN(g->pins[i]);
-
-		/* drive */
-		reg = d->base + d->soc->regs->drive;
-		reg += bank * 0x40 + pin / 8 * 0x10;
-
-		/* mA */
-		if (config & MA_PRESENT) {
-			shift = pin % 8 * 4;
-			writel(0x3 << shift, reg + CLR);
-			writel(ma << shift, reg + SET);
-		}
-
-		/* vol */
-		if (config & VOL_PRESENT) {
-			shift = pin % 8 * 4 + 2;
-			if (vol)
-				writel(1 << shift, reg + SET);
-			else
-				writel(1 << shift, reg + CLR);
+	for (n = 0; n < num_configs; n++) {
+		config = configs[n];
+
+		ma = CONFIG_TO_MA(config);
+		vol = CONFIG_TO_VOL(config);
+		pull = CONFIG_TO_PULL(config);
+
+		for (i = 0; i < g->npins; i++) {
+			bank = PINID_TO_BANK(g->pins[i]);
+			pin = PINID_TO_PIN(g->pins[i]);
+
+			/* drive */
+			reg = d->base + d->soc->regs->drive;
+			reg += bank * 0x40 + pin / 8 * 0x10;
+
+			/* mA */
+			if (config & MA_PRESENT) {
+				shift = pin % 8 * 4;
+				writel(0x3 << shift, reg + CLR);
+				writel(ma << shift, reg + SET);
+			}
+
+			/* vol */
+			if (config & VOL_PRESENT) {
+				shift = pin % 8 * 4 + 2;
+				if (vol)
+					writel(1 << shift, reg + SET);
+				else
+					writel(1 << shift, reg + CLR);
+			}
+
+			/* pull */
+			if (config & PULL_PRESENT) {
+				reg = d->base + d->soc->regs->pull;
+				reg += bank * 0x10;
+				shift = pin;
+				if (pull)
+					writel(1 << shift, reg + SET);
+				else
+					writel(1 << shift, reg + CLR);
+			}
 		}
 
-		/* pull */
-		if (config & PULL_PRESENT) {
-			reg = d->base + d->soc->regs->pull;
-			reg += bank * 0x10;
-			shift = pin;
-			if (pull)
-				writel(1 << shift, reg + SET);
-			else
-				writel(1 << shift, reg + CLR);
-		}
-	}
+		/* cache the config value for mxs_pinconf_group_get() */
+		g->config = config;
 
-	/* cache the config value for mxs_pinconf_group_get() */
-	g->config = config;
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index f7c7279..d7c3ae3 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1695,7 +1695,7 @@ static int nmk_pin_config_get(struct pinctrl_dev *pctldev, unsigned pin,
 }
 
 static int nmk_pin_config_set(struct pinctrl_dev *pctldev, unsigned pin,
-			      unsigned long config)
+			      unsigned long *configs, unsigned num_configs)
 {
 	static const char *pullnames[] = {
 		[NMK_GPIO_PULL_NONE]	= "none",
@@ -1712,20 +1712,9 @@ static int nmk_pin_config_set(struct pinctrl_dev *pctldev, unsigned pin,
 	struct pinctrl_gpio_range *range;
 	struct gpio_chip *chip;
 	unsigned bit;
-
-	/*
-	 * The pin config contains pin number and altfunction fields, here
-	 * we just ignore that part. It's being handled by the framework and
-	 * pinmux callback respectively.
-	 */
-	pin_cfg_t cfg = (pin_cfg_t) config;
-	int pull = PIN_PULL(cfg);
-	int slpm = PIN_SLPM(cfg);
-	int output = PIN_DIR(cfg);
-	int val = PIN_VAL(cfg);
-	bool lowemi = PIN_LOWEMI(cfg);
-	bool gpiomode = PIN_GPIOMODE(cfg);
-	bool sleep = PIN_SLEEPMODE(cfg);
+	pin_cfg_t cfg;
+	int pull, slpm, output, val, i;
+	bool lowemi, gpiomode, sleep;
 
 	range = nmk_match_gpio_range(pctldev, pin);
 	if (!range) {
@@ -1740,54 +1729,74 @@ static int nmk_pin_config_set(struct pinctrl_dev *pctldev, unsigned pin,
 	chip = range->gc;
 	nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
 
-	if (sleep) {
-		int slpm_pull = PIN_SLPM_PULL(cfg);
-		int slpm_output = PIN_SLPM_DIR(cfg);
-		int slpm_val = PIN_SLPM_VAL(cfg);
-
-		/* All pins go into GPIO mode at sleep */
-		gpiomode = true;
-
+	for (i = 0; i < num_configs; i++) {
 		/*
-		 * The SLPM_* values are normal values + 1 to allow zero to
-		 * mean "same as normal".
+		 * The pin config contains pin number and altfunction fields,
+		 * here we just ignore that part. It's being handled by the
+		 * framework and pinmux callback respectively.
 		 */
-		if (slpm_pull)
-			pull = slpm_pull - 1;
-		if (slpm_output)
-			output = slpm_output - 1;
-		if (slpm_val)
-			val = slpm_val - 1;
-
-		dev_dbg(nmk_chip->chip.dev, "pin %d: sleep pull %s, dir %s, val %s\n",
-			pin,
-			slpm_pull ? pullnames[pull] : "same",
-			slpm_output ? (output ? "output" : "input") : "same",
-			slpm_val ? (val ? "high" : "low") : "same");
-	}
+		cfg = (pin_cfg_t) configs[i];
+		pull = PIN_PULL(cfg);
+		slpm = PIN_SLPM(cfg);
+		output = PIN_DIR(cfg);
+		val = PIN_VAL(cfg);
+		lowemi = PIN_LOWEMI(cfg);
+		gpiomode = PIN_GPIOMODE(cfg);
+		sleep = PIN_SLEEPMODE(cfg);
+
+		if (sleep) {
+			int slpm_pull = PIN_SLPM_PULL(cfg);
+			int slpm_output = PIN_SLPM_DIR(cfg);
+			int slpm_val = PIN_SLPM_VAL(cfg);
+
+			/* All pins go into GPIO mode at sleep */
+			gpiomode = true;
+
+			/*
+			 * The SLPM_* values are normal values + 1 to allow zero
+			 * to mean "same as normal".
+			 */
+			if (slpm_pull)
+				pull = slpm_pull - 1;
+			if (slpm_output)
+				output = slpm_output - 1;
+			if (slpm_val)
+				val = slpm_val - 1;
+
+			dev_dbg(nmk_chip->chip.dev,
+				"pin %d: sleep pull %s, dir %s, val %s\n",
+				pin,
+				slpm_pull ? pullnames[pull] : "same",
+				slpm_output ? (output ? "output" : "input")
+				: "same",
+				slpm_val ? (val ? "high" : "low") : "same");
+		}
 
-	dev_dbg(nmk_chip->chip.dev, "pin %d [%#lx]: pull %s, slpm %s (%s%s), lowemi %s\n",
-		pin, cfg, pullnames[pull], slpmnames[slpm],
-		output ? "output " : "input",
-		output ? (val ? "high" : "low") : "",
-		lowemi ? "on" : "off");
+		dev_dbg(nmk_chip->chip.dev,
+			"pin %d [%#lx]: pull %s, slpm %s (%s%s), lowemi %s\n",
+			pin, cfg, pullnames[pull], slpmnames[slpm],
+			output ? "output " : "input",
+			output ? (val ? "high" : "low") : "",
+			lowemi ? "on" : "off");
 
-	clk_enable(nmk_chip->clk);
-	bit = pin % NMK_GPIO_PER_CHIP;
-	if (gpiomode)
-		/* No glitch when going to GPIO mode */
-		__nmk_gpio_set_mode(nmk_chip, bit, NMK_GPIO_ALT_GPIO);
-	if (output)
-		__nmk_gpio_make_output(nmk_chip, bit, val);
-	else {
-		__nmk_gpio_make_input(nmk_chip, bit);
-		__nmk_gpio_set_pull(nmk_chip, bit, pull);
-	}
-	/* TODO: isn't this only applicable on output pins? */
-	__nmk_gpio_set_lowemi(nmk_chip, bit, lowemi);
+		clk_enable(nmk_chip->clk);
+		bit = pin % NMK_GPIO_PER_CHIP;
+		if (gpiomode)
+			/* No glitch when going to GPIO mode */
+			__nmk_gpio_set_mode(nmk_chip, bit, NMK_GPIO_ALT_GPIO);
+		if (output)
+			__nmk_gpio_make_output(nmk_chip, bit, val);
+		else {
+			__nmk_gpio_make_input(nmk_chip, bit);
+			__nmk_gpio_set_pull(nmk_chip, bit, pull);
+		}
+		/* TODO: isn't this only applicable on output pins? */
+		__nmk_gpio_set_lowemi(nmk_chip, bit, lowemi);
+
+		__nmk_gpio_set_slpm(nmk_chip, bit, slpm);
+		clk_disable(nmk_chip->clk);
+	} /* for each config */
 
-	__nmk_gpio_set_slpm(nmk_chip, bit, slpm);
-	clk_disable(nmk_chip->clk);
 	return 0;
 }
 
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 64ad0c0..6461aef 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -575,32 +575,45 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 
 /* set the pin config settings for a specified pin */
 static int rockchip_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
-							unsigned long config)
+				unsigned long *configs, unsigned num_configs)
 {
 	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	struct rockchip_pin_bank *bank = pin_to_bank(info, pin);
-	enum pin_config_param param = pinconf_to_config_param(config);
-	u16 arg = pinconf_to_config_argument(config);
-
-	switch (param) {
-	case PIN_CONFIG_BIAS_DISABLE:
-		return rockchip_set_pull(bank, pin - bank->pin_base, param);
-		break;
-	case PIN_CONFIG_BIAS_PULL_UP:
-	case PIN_CONFIG_BIAS_PULL_DOWN:
-	case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
-		if (!rockchip_pinconf_pull_valid(info->ctrl, param))
+	enum pin_config_param param;
+	u16 arg;
+	int i;
+	int rc;
+
+	for (i = 0; i < num_configs; i++) {
+		param = pinconf_to_config_param(configs[i]);
+		arg = pinconf_to_config_argument(configs[i]);
+
+		switch (param) {
+		case PIN_CONFIG_BIAS_DISABLE:
+			rc =  rockchip_set_pull(bank, pin - bank->pin_base,
+				param);
+			if (rc)
+				return rc;
+			break;
+		case PIN_CONFIG_BIAS_PULL_UP:
+		case PIN_CONFIG_BIAS_PULL_DOWN:
+		case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
+			if (!rockchip_pinconf_pull_valid(info->ctrl, param))
+				return -ENOTSUPP;
+
+			if (!arg)
+				return -EINVAL;
+
+			rc = rockchip_set_pull(bank, pin - bank->pin_base,
+				param);
+			if (rc)
+				return rc;
+			break;
+		default:
 			return -ENOTSUPP;
-
-		if (!arg)
-			return -EINVAL;
-
-		return rockchip_set_pull(bank, pin - bank->pin_base, param);
-		break;
-	default:
-		return -ENOTSUPP;
-		break;
-	}
+			break;
+		}
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 439f2ef..222648d 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -442,9 +442,17 @@ static int samsung_pinconf_rw(struct pinctrl_dev *pctldev, unsigned int pin,
 
 /* set the pin config settings for a specified pin */
 static int samsung_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
-				unsigned long config)
+				unsigned long *configs, unsigned num_configs)
 {
-	return samsung_pinconf_rw(pctldev, pin, &config, true);
+	int i, ret;
+
+	for (i = 0; i < num_configs; i++) {
+		ret = samsung_pinconf_rw(pctldev, pin, &configs[i], true);
+		if (ret < 0)
+			return ret;
+	} /* for each config */
+
+	return 0;
 }
 
 /* get the pin config settings for a specified pin */
@@ -456,7 +464,8 @@ static int samsung_pinconf_get(struct pinctrl_dev *pctldev, unsigned int pin,
 
 /* set the pin config settings for a specified pin group */
 static int samsung_pinconf_group_set(struct pinctrl_dev *pctldev,
-			unsigned group, unsigned long config)
+			unsigned group, unsigned long *configs,
+			unsigned num_configs)
 {
 	struct samsung_pinctrl_drv_data *drvdata;
 	const unsigned int *pins;
@@ -466,7 +475,7 @@ static int samsung_pinconf_group_set(struct pinctrl_dev *pctldev,
 	pins = drvdata->pin_groups[group].pins;
 
 	for (cnt = 0; cnt < drvdata->pin_groups[group].num_pins; cnt++)
-		samsung_pinconf_set(pctldev, pins[cnt], config);
+		samsung_pinconf_set(pctldev, pins[cnt], configs, num_configs);
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 6866548..8f31768 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -209,7 +209,7 @@ struct pcs_device {
 static int pcs_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
 			   unsigned long *config);
 static int pcs_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin,
-			   unsigned long config);
+			   unsigned long *configs, unsigned num_configs);
 
 static enum pin_config_param pcs_bias[] = {
 	PIN_CONFIG_BIAS_PULL_DOWN,
@@ -536,7 +536,7 @@ static void pcs_pinconf_clear_bias(struct pinctrl_dev *pctldev, unsigned pin)
 	int i;
 	for (i = 0; i < ARRAY_SIZE(pcs_bias); i++) {
 		config = pinconf_to_config_packed(pcs_bias[i], 0);
-		pcs_pinconf_set(pctldev, pin, config);
+		pcs_pinconf_set(pctldev, pin, &config, 1);
 	}
 }
 
@@ -622,22 +622,28 @@ static int pcs_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
-				unsigned pin, unsigned long config)
+				unsigned pin, unsigned long *configs,
+				unsigned num_configs)
 {
 	struct pcs_device *pcs = pinctrl_dev_get_drvdata(pctldev);
 	struct pcs_function *func;
 	unsigned offset = 0, shift = 0, i, data, ret;
 	u16 arg;
+	int j;
 
 	ret = pcs_get_function(pctldev, pin, &func);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < func->nconfs; i++) {
-		if (pinconf_to_config_param(config) == func->conf[i].param) {
+	for (j = 0; j < num_configs; j++) {
+		for (i = 0; i < func->nconfs; i++) {
+			if (pinconf_to_config_param(configs[j])
+				!= func->conf[i].param)
+				continue;
+
 			offset = pin * (pcs->width / BITS_PER_BYTE);
 			data = pcs->read(pcs->base + offset);
-			arg = pinconf_to_config_argument(config);
+			arg = pinconf_to_config_argument(configs[j]);
 			switch (func->conf[i].param) {
 			/* 2 parameters */
 			case PIN_CONFIG_INPUT_SCHMITT:
@@ -667,10 +673,14 @@ static int pcs_pinconf_set(struct pinctrl_dev *pctldev,
 				return -ENOTSUPP;
 			}
 			pcs->write(data, pcs->base + offset);
-			return 0;
+
+			break;
 		}
-	}
-	return -ENOTSUPP;
+		if (i >= func->nconfs)
+			return -ENOTSUPP;
+	} /* for each config */
+
+	return 0;
 }
 
 static int pcs_pinconf_group_get(struct pinctrl_dev *pctldev,
@@ -695,7 +705,8 @@ static int pcs_pinconf_group_get(struct pinctrl_dev *pctldev,
 }
 
 static int pcs_pinconf_group_set(struct pinctrl_dev *pctldev,
-				unsigned group, unsigned long config)
+				unsigned group, unsigned long *configs,
+				unsigned num_configs)
 {
 	const unsigned *pins;
 	unsigned npins;
@@ -705,7 +716,7 @@ static int pcs_pinconf_group_set(struct pinctrl_dev *pctldev,
 	if (ret)
 		return ret;
 	for (i = 0; i < npins; i++) {
-		if (pcs_pinconf_set(pctldev, pins[i], config))
+		if (pcs_pinconf_set(pctldev, pins[i], configs, num_configs))
 			return -ENOTSUPP;
 	}
 	return 0;
diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 2a10a31..9cadc68 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -909,15 +909,18 @@ static void st_pinconf_set_retime(struct st_pinctrl *info,
 							config, pin);
 }
 
-static int st_pinconf_set(struct pinctrl_dev *pctldev,
-			     unsigned pin_id, unsigned long config)
+static int st_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin_id,
+			unsigned long *configs, unsigned num_configs)
 {
 	int pin = st_gpio_pin(pin_id);
 	struct st_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	struct st_pio_control *pc = st_get_pio_control(pctldev, pin_id);
+	int i;
 
-	st_pinconf_set_config(pc, pin, config);
-	st_pinconf_set_retime(info, pc, pin, config);
+	for (i = 0; i < num_configs; i++) {
+		st_pinconf_set_config(pc, pin, configs[i]);
+		st_pinconf_set_retime(info, pc, pin, configs[i]);
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 19ab749..b20df31 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -274,7 +274,8 @@ static int sunxi_pconf_group_get(struct pinctrl_dev *pctldev,
 
 static int sunxi_pconf_group_set(struct pinctrl_dev *pctldev,
 				 unsigned group,
-				 unsigned long config)
+				 unsigned long *configs,
+				 unsigned num_configs)
 {
 	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
 	struct sunxi_pinctrl_group *g = &pctl->groups[group];
@@ -282,56 +283,60 @@ static int sunxi_pconf_group_set(struct pinctrl_dev *pctldev,
 	u32 val, mask;
 	u16 strength;
 	u8 dlevel;
+	int i;
 
-	switch (pinconf_to_config_param(config)) {
-	case PIN_CONFIG_DRIVE_STRENGTH:
-		strength = pinconf_to_config_argument(config);
-		if (strength > 40)
-			return -EINVAL;
-		/*
-		 * We convert from mA to what the register expects:
-		 *   0: 10mA
-		 *   1: 20mA
-		 *   2: 30mA
-		 *   3: 40mA
-		 */
-		dlevel = strength / 10 - 1;
-
-		spin_lock_irqsave(&pctl->lock, flags);
-
-		val = readl(pctl->membase + sunxi_dlevel_reg(g->pin));
-	        mask = DLEVEL_PINS_MASK << sunxi_dlevel_offset(g->pin);
-		writel((val & ~mask) | dlevel << sunxi_dlevel_offset(g->pin),
-			pctl->membase + sunxi_dlevel_reg(g->pin));
-
-		spin_unlock_irqrestore(&pctl->lock, flags);
-		break;
-	case PIN_CONFIG_BIAS_PULL_UP:
-		spin_lock_irqsave(&pctl->lock, flags);
+	for (i = 0; i < num_configs; i++) {
+		switch (pinconf_to_config_param(configs[i])) {
+		case PIN_CONFIG_DRIVE_STRENGTH:
+			strength = pinconf_to_config_argument(configs[i]);
+			if (strength > 40)
+				return -EINVAL;
+			/*
+			 * We convert from mA to what the register expects:
+			 *   0: 10mA
+			 *   1: 20mA
+			 *   2: 30mA
+			 *   3: 40mA
+			 */
+			dlevel = strength / 10 - 1;
+
+			spin_lock_irqsave(&pctl->lock, flags);
+
+			val = readl(pctl->membase + sunxi_dlevel_reg(g->pin));
+			mask = DLEVEL_PINS_MASK << sunxi_dlevel_offset(g->pin);
+			writel((val & ~mask)
+				| dlevel << sunxi_dlevel_offset(g->pin),
+				pctl->membase + sunxi_dlevel_reg(g->pin));
+
+			spin_unlock_irqrestore(&pctl->lock, flags);
+			break;
+		case PIN_CONFIG_BIAS_PULL_UP:
+			spin_lock_irqsave(&pctl->lock, flags);
 
-		val = readl(pctl->membase + sunxi_pull_reg(g->pin));
-		mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
-		writel((val & ~mask) | 1 << sunxi_pull_offset(g->pin),
-			pctl->membase + sunxi_pull_reg(g->pin));
+			val = readl(pctl->membase + sunxi_pull_reg(g->pin));
+			mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
+			writel((val & ~mask) | 1 << sunxi_pull_offset(g->pin),
+				pctl->membase + sunxi_pull_reg(g->pin));
 
-		spin_unlock_irqrestore(&pctl->lock, flags);
-		break;
-	case PIN_CONFIG_BIAS_PULL_DOWN:
-		spin_lock_irqsave(&pctl->lock, flags);
+			spin_unlock_irqrestore(&pctl->lock, flags);
+			break;
+		case PIN_CONFIG_BIAS_PULL_DOWN:
+			spin_lock_irqsave(&pctl->lock, flags);
 
-		val = readl(pctl->membase + sunxi_pull_reg(g->pin));
-		mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
-		writel((val & ~mask) | 2 << sunxi_pull_offset(g->pin),
-			pctl->membase + sunxi_pull_reg(g->pin));
+			val = readl(pctl->membase + sunxi_pull_reg(g->pin));
+			mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
+			writel((val & ~mask) | 2 << sunxi_pull_offset(g->pin),
+				pctl->membase + sunxi_pull_reg(g->pin));
 
-		spin_unlock_irqrestore(&pctl->lock, flags);
-		break;
-	default:
-		break;
-	}
+			spin_unlock_irqrestore(&pctl->lock, flags);
+			break;
+		default:
+			break;
+		}
 
-	/* cache the config value */
-	g->config = config;
+		/* cache the config value */
+		g->config = configs[i];
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index 637bcd3..bc5af07 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -436,7 +436,8 @@ static int tegra_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int tegra_pinconf_set(struct pinctrl_dev *pctldev,
-			     unsigned pin, unsigned long config)
+			     unsigned pin, unsigned long *configs,
+			     unsigned num_configs)
 {
 	dev_err(pctldev->dev, "pin_config_set op not supported\n");
 	return -ENOTSUPP;
@@ -471,51 +472,57 @@ static int tegra_pinconf_group_get(struct pinctrl_dev *pctldev,
 }
 
 static int tegra_pinconf_group_set(struct pinctrl_dev *pctldev,
-				   unsigned group, unsigned long config)
+				   unsigned group, unsigned long *configs,
+				   unsigned num_configs)
 {
 	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
-	enum tegra_pinconf_param param = TEGRA_PINCONF_UNPACK_PARAM(config);
-	u16 arg = TEGRA_PINCONF_UNPACK_ARG(config);
+	enum tegra_pinconf_param param;
+	u16 arg;
 	const struct tegra_pingroup *g;
-	int ret;
+	int ret, i;
 	s8 bank, bit, width;
 	s16 reg;
 	u32 val, mask;
 
 	g = &pmx->soc->groups[group];
 
-	ret = tegra_pinconf_reg(pmx, g, param, true, &bank, &reg, &bit,
-				&width);
-	if (ret < 0)
-		return ret;
+	for (i = 0; i < num_configs; i++) {
+		param = TEGRA_PINCONF_UNPACK_PARAM(configs[i]);
+		arg = TEGRA_PINCONF_UNPACK_ARG(configs[i]);
 
-	val = pmx_readl(pmx, bank, reg);
+		ret = tegra_pinconf_reg(pmx, g, param, true, &bank, &reg, &bit,
+					&width);
+		if (ret < 0)
+			return ret;
 
-	/* LOCK can't be cleared */
-	if (param == TEGRA_PINCONF_PARAM_LOCK) {
-		if ((val & BIT(bit)) && !arg) {
-			dev_err(pctldev->dev, "LOCK bit cannot be cleared\n");
-			return -EINVAL;
+		val = pmx_readl(pmx, bank, reg);
+
+		/* LOCK can't be cleared */
+		if (param == TEGRA_PINCONF_PARAM_LOCK) {
+			if ((val & BIT(bit)) && !arg) {
+				dev_err(pctldev->dev, "LOCK bit cannot be cleared\n");
+				return -EINVAL;
+			}
 		}
-	}
 
-	/* Special-case Boolean values; allow any non-zero as true */
-	if (width == 1)
-		arg = !!arg;
+		/* Special-case Boolean values; allow any non-zero as true */
+		if (width == 1)
+			arg = !!arg;
 
-	/* Range-check user-supplied value */
-	mask = (1 << width) - 1;
-	if (arg & ~mask) {
-		dev_err(pctldev->dev,
-			"config %lx: %x too big for %d bit register\n",
-			config, arg, width);
-		return -EINVAL;
-	}
+		/* Range-check user-supplied value */
+		mask = (1 << width) - 1;
+		if (arg & ~mask) {
+			dev_err(pctldev->dev,
+				"config %lx: %x too big for %d bit register\n",
+				configs[i], arg, width);
+			return -EINVAL;
+		}
 
-	/* Update register */
-	val &= ~(mask << bit);
-	val |= arg << bit;
-	pmx_writel(pmx, val, bank, reg);
+		/* Update register */
+		val &= ~(mask << bit);
+		val |= arg << bit;
+		pmx_writel(pmx, val, bank, reg);
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c b/drivers/pinctrl/pinctrl-tz1090-pdc.c
index d4f12cc..b1fea745 100644
--- a/drivers/pinctrl/pinctrl-tz1090-pdc.c
+++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
@@ -737,39 +737,46 @@ static int tz1090_pdc_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int tz1090_pdc_pinconf_set(struct pinctrl_dev *pctldev,
-				  unsigned int pin, unsigned long config)
+				  unsigned int pin, unsigned long *configs,
+				  unsigned num_configs)
 {
 	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
-	enum pin_config_param param = pinconf_to_config_param(config);
-	unsigned int arg = pinconf_to_config_argument(config);
+	enum pin_config_param param;
+	unsigned int arg;
 	int ret;
 	u32 reg, width, mask, shift, val, tmp;
 	unsigned long flags;
+	int i;
 
-	dev_dbg(pctldev->dev, "%s(pin=%s, config=%#lx)\n",
-		__func__, tz1090_pdc_pins[pin].name, config);
+	for (i = 0; i < num_configs; i++) {
+		param = pinconf_to_config_param(configs[i]);
+		arg = pinconf_to_config_argument(configs[i]);
 
-	/* Get register information */
-	ret = tz1090_pdc_pinconf_reg(pctldev, pin, param, true,
-				     &reg, &width, &mask, &shift, &val);
-	if (ret < 0)
-		return ret;
+		dev_dbg(pctldev->dev, "%s(pin=%s, config=%#lx)\n",
+			__func__, tz1090_pdc_pins[pin].name, configs[i]);
 
-	/* Unpack argument and range check it */
-	if (arg > 1) {
-		dev_dbg(pctldev->dev, "%s: arg %u out of range\n",
-			__func__, arg);
-		return -EINVAL;
-	}
+		/* Get register information */
+		ret = tz1090_pdc_pinconf_reg(pctldev, pin, param, true,
+					     &reg, &width, &mask, &shift, &val);
+		if (ret < 0)
+			return ret;
 
-	/* Write register field */
-	__global_lock2(flags);
-	tmp = pmx_read(pmx, reg);
-	tmp &= ~mask;
-	if (arg)
-		tmp |= val << shift;
-	pmx_write(pmx, tmp, reg);
-	__global_unlock2(flags);
+		/* Unpack argument and range check it */
+		if (arg > 1) {
+			dev_dbg(pctldev->dev, "%s: arg %u out of range\n",
+				__func__, arg);
+			return -EINVAL;
+		}
+
+		/* Write register field */
+		__global_lock2(flags);
+		tmp = pmx_read(pmx, reg);
+		tmp &= ~mask;
+		if (arg)
+			tmp |= val << shift;
+		pmx_write(pmx, tmp, reg);
+		__global_unlock2(flags);
+	} /* for each config */
 
 	return 0;
 }
@@ -860,54 +867,68 @@ static int tz1090_pdc_pinconf_group_get(struct pinctrl_dev *pctldev,
 
 static int tz1090_pdc_pinconf_group_set(struct pinctrl_dev *pctldev,
 					unsigned int group,
-					unsigned long config)
+					unsigned long *configs,
+					unsigned num_configs)
 {
 	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 	const struct tz1090_pdc_pingroup *g = &tz1090_pdc_groups[group];
-	enum pin_config_param param = pinconf_to_config_param(config);
+	enum pin_config_param param;
 	const unsigned int *pit;
 	unsigned int i;
 	int ret, arg;
 	u32 reg, width, mask, shift, val;
 	unsigned long flags;
 	const int *map;
+	int j;
 
-	dev_dbg(pctldev->dev, "%s(group=%s, config=%#lx)\n",
-		__func__, g->name, config);
+	for (j = 0; j < num_configs; j++) {
+		param = pinconf_to_config_param(configs[j]);
 
-	/* Get register information */
-	ret = tz1090_pdc_pinconf_group_reg(pctldev, g, param, true,
-					   &reg, &width, &mask, &shift, &map);
-	if (ret < 0) {
-		/*
-		 * Maybe we're trying to set a per-pin configuration of a group,
-		 * so do the pins one by one. This is mainly as a convenience.
-		 */
-		for (i = 0, pit = g->pins; i < g->npins; ++i, ++pit) {
-			ret = tz1090_pdc_pinconf_set(pctldev, *pit, config);
-			if (ret)
-				return ret;
-		}
-		return 0;
-	}
+		dev_dbg(pctldev->dev, "%s(group=%s, config=%#lx)\n",
+			__func__, g->name, configs[j]);
 
-	/* Unpack argument and map it to register value */
-	arg = pinconf_to_config_argument(config);
-	for (i = 0; i < BIT(width); ++i) {
-		if (map[i] == arg || (map[i] == -EINVAL && !arg)) {
-			/* Write register field */
-			__global_lock2(flags);
-			val = pmx_read(pmx, reg);
-			val &= ~mask;
-			val |= i << shift;
-			pmx_write(pmx, val, reg);
-			__global_unlock2(flags);
+		/* Get register information */
+		ret = tz1090_pdc_pinconf_group_reg(pctldev, g, param, true,
+						   &reg, &width, &mask, &shift,
+						   &map);
+		if (ret < 0) {
+			/*
+			 * Maybe we're trying to set a per-pin configuration
+			 * of a group, so do the pins one by one. This is
+			 * mainly as a convenience.
+			 */
+			for (i = 0, pit = g->pins; i < g->npins; ++i, ++pit) {
+				ret = tz1090_pdc_pinconf_set(pctldev, *pit,
+					configs, num_configs);
+				if (ret)
+					return ret;
+			}
 			return 0;
 		}
-	}
 
-	dev_dbg(pctldev->dev, "%s: arg %u not supported\n",
-		__func__, arg);
+		/* Unpack argument and map it to register value */
+		arg = pinconf_to_config_argument(configs[j]);
+		for (i = 0; i < BIT(width); ++i) {
+			if (map[i] == arg || (map[i] == -EINVAL && !arg)) {
+				/* Write register field */
+				__global_lock2(flags);
+				val = pmx_read(pmx, reg);
+				val &= ~mask;
+				val |= i << shift;
+				pmx_write(pmx, val, reg);
+				__global_unlock2(flags);
+				goto next_config;
+			}
+		}
+
+		dev_dbg(pctldev->dev, "%s: arg %u not supported\n",
+			__func__, arg);
+		return 0;
+
+next_config:
+		;
+	} /* for each config */
+
 	return 0;
 }
 
diff --git a/drivers/pinctrl/pinctrl-tz1090.c b/drivers/pinctrl/pinctrl-tz1090.c
index 4edae08..c758867 100644
--- a/drivers/pinctrl/pinctrl-tz1090.c
+++ b/drivers/pinctrl/pinctrl-tz1090.c
@@ -1762,39 +1762,46 @@ static int tz1090_pinconf_get(struct pinctrl_dev *pctldev,
 }
 
 static int tz1090_pinconf_set(struct pinctrl_dev *pctldev,
-			      unsigned int pin, unsigned long config)
+			      unsigned int pin, unsigned long *configs,
+			      unsigned num_configs)
 {
 	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
-	enum pin_config_param param = pinconf_to_config_param(config);
-	unsigned int arg = pinconf_to_config_argument(config);
+	enum pin_config_param param;
+	unsigned int arg;
 	int ret;
 	u32 reg, width, mask, shift, val, tmp;
 	unsigned long flags;
+	int i;
 
-	dev_dbg(pctldev->dev, "%s(pin=%s, config=%#lx)\n",
-		__func__, tz1090_pins[pin].name, config);
+	for (i = 0; i < num_configs; i++) {
+		param = pinconf_to_config_param(configs[i]);
+		arg = pinconf_to_config_argument(configs[i]);
 
-	/* Get register information */
-	ret = tz1090_pinconf_reg(pctldev, pin, param, true,
-				 &reg, &width, &mask, &shift, &val);
-	if (ret < 0)
-		return ret;
+		dev_dbg(pctldev->dev, "%s(pin=%s, config=%#lx)\n",
+			__func__, tz1090_pins[pin].name, configs[i]);
 
-	/* Unpack argument and range check it */
-	if (arg > 1) {
-		dev_dbg(pctldev->dev, "%s: arg %u out of range\n",
-			__func__, arg);
-		return -EINVAL;
-	}
+		/* Get register information */
+		ret = tz1090_pinconf_reg(pctldev, pin, param, true,
+					 &reg, &width, &mask, &shift, &val);
+		if (ret < 0)
+			return ret;
 
-	/* Write register field */
-	__global_lock2(flags);
-	tmp = pmx_read(pmx, reg);
-	tmp &= ~mask;
-	if (arg)
-		tmp |= val << shift;
-	pmx_write(pmx, tmp, reg);
-	__global_unlock2(flags);
+		/* Unpack argument and range check it */
+		if (arg > 1) {
+			dev_dbg(pctldev->dev, "%s: arg %u out of range\n",
+				__func__, arg);
+			return -EINVAL;
+		}
+
+		/* Write register field */
+		__global_lock2(flags);
+		tmp = pmx_read(pmx, reg);
+		tmp &= ~mask;
+		if (arg)
+			tmp |= val << shift;
+		pmx_write(pmx, tmp, reg);
+		__global_unlock2(flags);
+	} /* for each config */
 
 	return 0;
 }
@@ -1894,68 +1901,81 @@ static int tz1090_pinconf_group_get(struct pinctrl_dev *pctldev,
 }
 
 static int tz1090_pinconf_group_set(struct pinctrl_dev *pctldev,
-				    unsigned int group, unsigned long config)
+				    unsigned int group, unsigned long *configs,
+				    unsigned num_configs)
 {
 	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
 	const struct tz1090_pingroup *g;
-	enum pin_config_param param = pinconf_to_config_param(config);
+	enum pin_config_param param;
 	unsigned int arg, pin, i;
 	const unsigned int *pit;
 	int ret;
 	u32 reg, width, mask, shift, val;
 	unsigned long flags;
 	const int *map;
+	int j;
 
 	if (group >= ARRAY_SIZE(tz1090_groups)) {
 		pin = group - ARRAY_SIZE(tz1090_groups);
-		return tz1090_pinconf_set(pctldev, pin, config);
+		return tz1090_pinconf_set(pctldev, pin, configs, num_configs);
 	}
 
 	g = &tz1090_groups[group];
 	if (g->npins == 1) {
 		pin = g->pins[0];
-		ret = tz1090_pinconf_set(pctldev, pin, config);
+		ret = tz1090_pinconf_set(pctldev, pin, configs, num_configs);
 		if (ret != -ENOTSUPP)
 			return ret;
 	}
 
-	dev_dbg(pctldev->dev, "%s(group=%s, config=%#lx)\n",
-		__func__, g->name, config);
+	for (j = 0; j < num_configs; j++) {
+		param = pinconf_to_config_param(configs[j]);
 
-	/* Get register information */
-	ret = tz1090_pinconf_group_reg(pctldev, g, param, true,
-				       &reg, &width, &mask, &shift, &map);
-	if (ret < 0) {
-		/*
-		 * Maybe we're trying to set a per-pin configuration of a group,
-		 * so do the pins one by one. This is mainly as a convenience.
-		 */
-		for (i = 0, pit = g->pins; i < g->npins; ++i, ++pit) {
-			ret = tz1090_pinconf_set(pctldev, *pit, config);
-			if (ret)
-				return ret;
-		}
-		return 0;
-	}
+		dev_dbg(pctldev->dev, "%s(group=%s, config=%#lx)\n",
+			__func__, g->name, configs[j]);
 
-	/* Unpack argument and map it to register value */
-	arg = pinconf_to_config_argument(config);
-	for (i = 0; i < BIT(width); ++i) {
-		if (map[i] == arg || (map[i] == -EINVAL && !arg)) {
-			/* Write register field */
-			__global_lock2(flags);
-			val = pmx_read(pmx, reg);
-			val &= ~mask;
-			val |= i << shift;
-			pmx_write(pmx, val, reg);
-			__global_unlock2(flags);
+		/* Get register information */
+		ret = tz1090_pinconf_group_reg(pctldev, g, param, true, &reg,
+						&width, &mask, &shift, &map);
+		if (ret < 0) {
+			/*
+			 * Maybe we're trying to set a per-pin configuration
+			 * of a group, so do the pins one by one. This is
+			 * mainly as a convenience.
+			 */
+			for (i = 0, pit = g->pins; i < g->npins; ++i, ++pit) {
+				ret = tz1090_pinconf_set(pctldev, *pit, configs,
+					num_configs);
+				if (ret)
+					return ret;
+			}
 			return 0;
 		}
-	}
 
-	dev_dbg(pctldev->dev, "%s: arg %u not supported\n",
-		__func__, arg);
-	return -EINVAL;
+		/* Unpack argument and map it to register value */
+		arg = pinconf_to_config_argument(configs[j]);
+		for (i = 0; i < BIT(width); ++i) {
+			if (map[i] == arg || (map[i] == -EINVAL && !arg)) {
+				/* Write register field */
+				__global_lock2(flags);
+				val = pmx_read(pmx, reg);
+				val &= ~mask;
+				val |= i << shift;
+				pmx_write(pmx, val, reg);
+				__global_unlock2(flags);
+				goto next_config;
+			}
+		}
+
+		dev_dbg(pctldev->dev, "%s: arg %u not supported\n",
+			__func__, arg);
+		return -EINVAL;
+
+next_config:
+		;
+	} /* for each config */
+
+	return 0;
 }
 
 static struct pinconf_ops tz1090_pinconf_ops = {
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 6fbdc06..209a01b 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1027,21 +1027,23 @@ static int u300_pin_config_get(struct pinctrl_dev *pctldev, unsigned pin,
 }
 
 static int u300_pin_config_set(struct pinctrl_dev *pctldev, unsigned pin,
-			       unsigned long config)
+			       unsigned long *configs, unsigned num_configs)
 {
 	struct pinctrl_gpio_range *range =
 		pinctrl_find_gpio_range_from_pin(pctldev, pin);
-	int ret;
+	int ret, i;
 
 	if (!range)
 		return -EINVAL;
 
-	/* Note: none of these configurations take any argument */
-	ret = u300_gpio_config_set(range->gc,
-				   (pin - range->pin_base + range->base),
-				   pinconf_to_config_param(config));
-	if (ret)
-		return ret;
+	for (i = 0; i < num_configs; i++) {
+		/* Note: none of these configurations take any argument */
+		ret = u300_gpio_config_set(range->gc,
+			(pin - range->pin_base + range->base),
+			pinconf_to_config_param(configs[i]));
+		if (ret)
+			return ret;
+	} /* for each config */
 
 	return 0;
 }
diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index 86c8cf8..ed2d1ba 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -499,74 +499,101 @@ static int xway_pinconf_get(struct pinctrl_dev *pctldev,
 
 static int xway_pinconf_set(struct pinctrl_dev *pctldev,
 				unsigned pin,
-				unsigned long config)
+				unsigned long *configs,
+				unsigned num_configs)
 {
 	struct ltq_pinmux_info *info = pinctrl_dev_get_drvdata(pctldev);
-	enum ltq_pinconf_param param = LTQ_PINCONF_UNPACK_PARAM(config);
-	int arg = LTQ_PINCONF_UNPACK_ARG(config);
+	enum ltq_pinconf_param param;
+	int arg;
 	int port = PORT(pin);
 	u32 reg;
+	int i;
+
+	for (i = 0; i < num_configs; i++) {
+		param = LTQ_PINCONF_UNPACK_PARAM(configs[i]);
+		arg = LTQ_PINCONF_UNPACK_ARG(configs[i]);
+
+		switch (param) {
+		case LTQ_PINCONF_PARAM_OPEN_DRAIN:
+			if (port == PORT3)
+				reg = GPIO3_OD;
+			else
+				reg = GPIO_OD(pin);
+			if (arg == 0)
+				gpio_setbit(info->membase[0],
+					reg,
+					PORT_PIN(pin));
+			else
+				gpio_clearbit(info->membase[0],
+					reg,
+					PORT_PIN(pin));
+			break;
 
-	switch (param) {
-	case LTQ_PINCONF_PARAM_OPEN_DRAIN:
-		if (port == PORT3)
-			reg = GPIO3_OD;
-		else
-			reg = GPIO_OD(pin);
-		if (arg == 0)
+		case LTQ_PINCONF_PARAM_PULL:
+			if (port == PORT3)
+				reg = GPIO3_PUDEN;
+			else
+				reg = GPIO_PUDEN(pin);
+			if (arg == 0) {
+				gpio_clearbit(info->membase[0],
+					reg,
+					PORT_PIN(pin));
+				break;
+			}
 			gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
-		else
-			gpio_clearbit(info->membase[0], reg, PORT_PIN(pin));
-		break;
 
-	case LTQ_PINCONF_PARAM_PULL:
-		if (port == PORT3)
-			reg = GPIO3_PUDEN;
-		else
-			reg = GPIO_PUDEN(pin);
-		if (arg == 0) {
-			gpio_clearbit(info->membase[0], reg, PORT_PIN(pin));
+			if (port == PORT3)
+				reg = GPIO3_PUDSEL;
+			else
+				reg = GPIO_PUDSEL(pin);
+			if (arg == 1)
+				gpio_clearbit(info->membase[0],
+					reg,
+					PORT_PIN(pin));
+			else if (arg == 2)
+				gpio_setbit(info->membase[0],
+					reg,
+					PORT_PIN(pin));
+			else
+				dev_err(pctldev->dev,
+					"Invalid pull value %d\n", arg);
 			break;
-		}
-		gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
 
-		if (port == PORT3)
-			reg = GPIO3_PUDSEL;
-		else
-			reg = GPIO_PUDSEL(pin);
-		if (arg == 1)
-			gpio_clearbit(info->membase[0], reg, PORT_PIN(pin));
-		else if (arg == 2)
-			gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
-		else
-			dev_err(pctldev->dev, "Invalid pull value %d\n", arg);
-		break;
+		case LTQ_PINCONF_PARAM_OUTPUT:
+			reg = GPIO_DIR(pin);
+			if (arg == 0)
+				gpio_clearbit(info->membase[0],
+					reg,
+					PORT_PIN(pin));
+			else
+				gpio_setbit(info->membase[0],
+					reg,
+					PORT_PIN(pin));
+			break;
 
-	case LTQ_PINCONF_PARAM_OUTPUT:
-		reg = GPIO_DIR(pin);
-		if (arg == 0)
-			gpio_clearbit(info->membase[0], reg, PORT_PIN(pin));
-		else
-			gpio_setbit(info->membase[0], reg, PORT_PIN(pin));
-		break;
+		default:
+			dev_err(pctldev->dev,
+				"Invalid config param %04x\n", param);
+			return -ENOTSUPP;
+		}
+	} /* for each config */
 
-	default:
-		dev_err(pctldev->dev, "Invalid config param %04x\n", param);
-		return -ENOTSUPP;
-	}
 	return 0;
 }
 
 int xway_pinconf_group_set(struct pinctrl_dev *pctldev,
 			unsigned selector,
-			unsigned long config)
+			unsigned long *configs,
+			unsigned num_configs)
 {
 	struct ltq_pinmux_info *info = pinctrl_dev_get_drvdata(pctldev);
 	int i, ret = 0;
 
 	for (i = 0; i < info->grps[selector].npins && !ret; i++)
 		ret = xway_pinconf_set(pctldev,
-				info->grps[selector].pins[i], config);
+				info->grps[selector].pins[i],
+				configs,
+				num_configs);
 
 	return ret;
 }
diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
index 8649ec3..ced199e 100644
--- a/drivers/pinctrl/sh-pfc/pinctrl.c
+++ b/drivers/pinctrl/sh-pfc/pinctrl.c
@@ -529,38 +529,44 @@ static int sh_pfc_pinconf_get(struct pinctrl_dev *pctldev, unsigned _pin,
 }
 
 static int sh_pfc_pinconf_set(struct pinctrl_dev *pctldev, unsigned _pin,
-			      unsigned long config)
+			      unsigned long *configs, unsigned num_configs)
 {
 	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
 	struct sh_pfc *pfc = pmx->pfc;
-	enum pin_config_param param = pinconf_to_config_param(config);
+	enum pin_config_param param;
 	unsigned long flags;
+	int i;
 
-	if (!sh_pfc_pinconf_validate(pfc, _pin, param))
-		return -ENOTSUPP;
+	for (i = 0; i < num_configs; i++) {
+		param = pinconf_to_config_param(configs[i]);
 
-	switch (param) {
-	case PIN_CONFIG_BIAS_PULL_UP:
-	case PIN_CONFIG_BIAS_PULL_DOWN:
-	case PIN_CONFIG_BIAS_DISABLE:
-		if (!pfc->info->ops || !pfc->info->ops->set_bias)
+		if (!sh_pfc_pinconf_validate(pfc, _pin, param))
 			return -ENOTSUPP;
 
-		spin_lock_irqsave(&pfc->lock, flags);
-		pfc->info->ops->set_bias(pfc, _pin, param);
-		spin_unlock_irqrestore(&pfc->lock, flags);
+		switch (param) {
+		case PIN_CONFIG_BIAS_PULL_UP:
+		case PIN_CONFIG_BIAS_PULL_DOWN:
+		case PIN_CONFIG_BIAS_DISABLE:
+			if (!pfc->info->ops || !pfc->info->ops->set_bias)
+				return -ENOTSUPP;
 
-		break;
+			spin_lock_irqsave(&pfc->lock, flags);
+			pfc->info->ops->set_bias(pfc, _pin, param);
+			spin_unlock_irqrestore(&pfc->lock, flags);
 
-	default:
-		return -ENOTSUPP;
-	}
+			break;
+
+		default:
+			return -ENOTSUPP;
+		}
+	} /* for each config */
 
 	return 0;
 }
 
 static int sh_pfc_pinconf_group_set(struct pinctrl_dev *pctldev, unsigned group,
-				    unsigned long config)
+				    unsigned long *configs,
+				    unsigned num_configs)
 {
 	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
 	const unsigned int *pins;
@@ -571,7 +577,7 @@ static int sh_pfc_pinconf_group_set(struct pinctrl_dev *pctldev, unsigned group,
 	num_pins = pmx->pfc->info->groups[group].nr_pins;
 
 	for (i = 0; i < num_pins; ++i)
-		sh_pfc_pinconf_set(pctldev, pins[i], config);
+		sh_pfc_pinconf_set(pctldev, pins[i], configs, num_configs);
 
 	return 0;
 }
diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index 0cc4335..39aec08 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -424,15 +424,16 @@ static int wmt_pinconf_get(struct pinctrl_dev *pctldev, unsigned pin,
 }
 
 static int wmt_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin,
-			   unsigned long config)
+			   unsigned long *configs, unsigned num_configs)
 {
 	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
-	enum pin_config_param param = pinconf_to_config_param(config);
-	u16 arg = pinconf_to_config_argument(config);
+	enum pin_config_param param;
+	u16 arg;
 	u32 bank = WMT_BANK_FROM_PIN(pin);
 	u32 bit = WMT_BIT_FROM_PIN(pin);
 	u32 reg_pull_en = data->banks[bank].reg_pull_en;
 	u32 reg_pull_cfg = data->banks[bank].reg_pull_cfg;
+	int i;
 
 	if ((reg_pull_en == NO_REG) || (reg_pull_cfg == NO_REG)) {
 		dev_err(data->dev, "bias functions not supported on pin %d\n",
@@ -440,28 +441,33 @@ static int wmt_pinconf_set(struct pinctrl_dev *pctldev, unsigned pin,
 		return -EINVAL;
 	}
 
-	if ((param == PIN_CONFIG_BIAS_PULL_DOWN) ||
-	    (param == PIN_CONFIG_BIAS_PULL_UP)) {
-		if (arg == 0)
-			param = PIN_CONFIG_BIAS_DISABLE;
-	}
+	for (i = 0; i < num_configs; i++) {
+		param = pinconf_to_config_param(configs[i]);
+		arg = pinconf_to_config_argument(configs[i]);
 
-	switch (param) {
-	case PIN_CONFIG_BIAS_DISABLE:
-		wmt_clearbits(data, reg_pull_en, BIT(bit));
-		break;
-	case PIN_CONFIG_BIAS_PULL_DOWN:
-		wmt_clearbits(data, reg_pull_cfg, BIT(bit));
-		wmt_setbits(data, reg_pull_en, BIT(bit));
-		break;
-	case PIN_CONFIG_BIAS_PULL_UP:
-		wmt_setbits(data, reg_pull_cfg, BIT(bit));
-		wmt_setbits(data, reg_pull_en, BIT(bit));
-		break;
-	default:
-		dev_err(data->dev, "unknown pinconf param\n");
-		return -EINVAL;
-	}
+		if ((param == PIN_CONFIG_BIAS_PULL_DOWN) ||
+		    (param == PIN_CONFIG_BIAS_PULL_UP)) {
+			if (arg == 0)
+				param = PIN_CONFIG_BIAS_DISABLE;
+		}
+
+		switch (param) {
+		case PIN_CONFIG_BIAS_DISABLE:
+			wmt_clearbits(data, reg_pull_en, BIT(bit));
+			break;
+		case PIN_CONFIG_BIAS_PULL_DOWN:
+			wmt_clearbits(data, reg_pull_cfg, BIT(bit));
+			wmt_setbits(data, reg_pull_en, BIT(bit));
+			break;
+		case PIN_CONFIG_BIAS_PULL_UP:
+			wmt_setbits(data, reg_pull_cfg, BIT(bit));
+			wmt_setbits(data, reg_pull_en, BIT(bit));
+			break;
+		default:
+			dev_err(data->dev, "unknown pinconf param\n");
+			return -EINVAL;
+		}
+	} /* for each config */
 
 	return 0;
 }
diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index f699869..09eb80f 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -47,13 +47,15 @@ struct pinconf_ops {
 			       unsigned long *config);
 	int (*pin_config_set) (struct pinctrl_dev *pctldev,
 			       unsigned pin,
-			       unsigned long config);
+			       unsigned long *configs,
+			       unsigned num_configs);
 	int (*pin_config_group_get) (struct pinctrl_dev *pctldev,
 				     unsigned selector,
 				     unsigned long *config);
 	int (*pin_config_group_set) (struct pinctrl_dev *pctldev,
 				     unsigned selector,
-				     unsigned long config);
+				     unsigned long *configs,
+				     unsigned num_configs);
 	int (*pin_config_dbg_parse_modify) (struct pinctrl_dev *pctldev,
 					   const char *arg,
 					   unsigned long *config);
-- 
1.7.9.5


