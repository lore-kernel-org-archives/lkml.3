Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbaCEO6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:58:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:64468 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbaCEO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:58:46 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-1f-53173ba382cb
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        cooloney@gmail.com, rpurdie@rpsys.net, dbaryshkov@gmail.com,
        dwmw2@infradead.org, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2] mfd: max8997: use regmap to access registers
Date: Wed, 05 Mar 2014 15:58:17 +0100
Message-id: <1394031497-16648-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd3F1uLBBqdvC1ksuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi9cvDC3ufz3KaPHtSgeTxc1P31gtLu+aw2ax
	9c06Rou1R+6yW9xuXMFmcW3vcWaLB4d3slvs3vWU1WJ/ZwejxeluVgcRj52z7rJ77Jl4ks1j
	8wotj02rOtk87lzbw+Yx72Sgx575P1g9+rasYvSYPu8nk8fnTXIe67dsZQrgjuKySUnNySxL
	LdK3S+DKmNO0nKWgZz9Txc9Jd9kbGDvbmLoYOTkkBEwkjm+ewgZhi0lcuLceyObiEBJYxCgx
	c/NEZginnUli8ooXrCBVbAI6Elu+T2AEsUUE9CU+7LgKVsQscJNZYs6ZfrCEsICDxNWrp8BW
	sAioSjxYNhGomYODV8BV4tRvbhBTQkBBYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al
	6yXn525iBIf3M6kdjCsbLA4xCnAwKvHwvuAQCxZiTSwrrsw9xCjBwawkwhutJR4sxJuSWFmV
	WpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgTHh8t5avS/CYbs9L0ue
	vvqY783J/+bix6rWS11fsf3gnob98lfzs1XuzirRtD3gOW+ZvNMXZhne3CWZd6IMF+Q+l5qx
	LeQR2/U1hs5HVs35neKfO0lIuVjB2DX6pW9npMKFKVPXeN+8pd2u/krq/v3M4skqYRVpOaIv
	Yt9ae61rN+V//do/SFCJpTgj0VCLuag4EQDLzLl0awIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies max8997 driver and each associated function driver,
to use regmap instead of operating directly on i2c bus. It will allow to
simplify IRQ handling using regmap-irq.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---

Changelog:

v2:
- check devm_regmap_init_i2c() return value
- use proper register maps for muic and haptic registers in functions
  max8997_freeze() and max8997_restore()
- fix style problems

v1: http://www.spinics.net/lists/kernel/msg1700375.html

 drivers/extcon/extcon-max8997.c     |   17 ++---
 drivers/input/misc/max8997_haptic.c |   33 ++++-----
 drivers/leds/leds-max8997.c         |   12 ++--
 drivers/mfd/max8997-irq.c           |   31 ++++----
 drivers/mfd/max8997.c               |  133 ++++++++++++++++++++++-------------
 drivers/power/max8997_charger.c     |   28 ++++----
 drivers/regulator/max8997.c         |   80 ++++++++++-----------
 drivers/rtc/rtc-max8997.c           |   51 ++++++++------
 include/linux/mfd/max8997-private.h |   19 +++--
 9 files changed, 227 insertions(+), 177 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 6a00464..9abc614 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -116,7 +116,7 @@ enum max8997_muic_charger_type {
 
 struct max8997_muic_info {
 	struct device *dev;
-	struct i2c_client *muic;
+	struct max8997_dev *max8997;
 	struct extcon_dev *edev;
 	int prev_cable_type;
 	int prev_chg_type;
@@ -190,7 +190,7 @@ static int max8997_muic_set_debounce_time(struct max8997_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = max8997_update_reg(info->muic,
+		ret = max8997_update_reg(info->max8997->regmap_muic,
 					  MAX8997_MUIC_REG_CONTROL3,
 					  time << CONTROL3_ADCDBSET_SHIFT,
 					  CONTROL3_ADCDBSET_MASK);
@@ -228,7 +228,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 	else
 		ctrl1 = CONTROL1_SW_OPEN;
 
-	ret = max8997_update_reg(info->muic,
+	ret = max8997_update_reg(info->max8997->regmap_muic,
 			MAX8997_MUIC_REG_CONTROL1, ctrl1, COMP_SW_MASK);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
@@ -240,7 +240,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 	else
 		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
 
-	ret = max8997_update_reg(info->muic,
+	ret = max8997_update_reg(info->max8997->regmap_muic,
 			MAX8997_MUIC_REG_CONTROL2, ctrl2,
 			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
 	if (ret < 0) {
@@ -543,7 +543,8 @@ static void max8997_muic_irq_work(struct work_struct *work)
 		if (info->irq == muic_irqs[i].virq)
 			irq_type = muic_irqs[i].irq;
 
-	ret = max8997_bulk_read(info->muic, MAX8997_MUIC_REG_STATUS1,
+	ret = max8997_bulk_read(info->max8997->regmap_muic,
+				MAX8997_MUIC_REG_STATUS1,
 				2, info->status);
 	if (ret) {
 		dev_err(info->dev, "failed to read muic register\n");
@@ -605,7 +606,7 @@ static int max8997_muic_detect_dev(struct max8997_muic_info *info)
 	mutex_lock(&info->mutex);
 
 	/* Read STATUSx register to detect accessory */
-	ret = max8997_bulk_read(info->muic,
+	ret = max8997_bulk_read(info->max8997->regmap_muic,
 			MAX8997_MUIC_REG_STATUS1, 2, info->status);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
@@ -667,7 +668,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 
 	info->dev = &pdev->dev;
-	info->muic = max8997->muic;
+	info->max8997 = max8997;
 
 	platform_set_drvdata(pdev, info);
 	mutex_init(&info->mutex);
@@ -721,7 +722,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 
 		/* Initialize registers according to platform data */
 		for (i = 0; i < muic_pdata->num_init_data; i++) {
-			max8997_write_reg(info->muic,
+			max8997_write_reg(info->max8997->regmap_muic,
 					muic_pdata->init_data[i].addr,
 					muic_pdata->init_data[i].data);
 		}
diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
index 1fea548..bce1f0f 100644
--- a/drivers/input/misc/max8997_haptic.c
+++ b/drivers/input/misc/max8997_haptic.c
@@ -45,7 +45,7 @@
 
 struct max8997_haptic {
 	struct device *dev;
-	struct i2c_client *client;
+	struct max8997_dev *max8997;
 	struct input_dev *input_dev;
 	struct regulator *regulator;
 
@@ -86,19 +86,19 @@ static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
 		}
 		switch (chip->internal_mode_pattern) {
 		case 0:
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGPWMDC1, duty_index);
 			break;
 		case 1:
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGPWMDC2, duty_index);
 			break;
 		case 2:
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGPWMDC3, duty_index);
 			break;
 		case 3:
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGPWMDC4, duty_index);
 			break;
 		default:
@@ -115,50 +115,51 @@ static void max8997_haptic_configure(struct max8997_haptic *chip)
 	value = chip->type << MAX8997_MOTOR_TYPE_SHIFT |
 		chip->enabled << MAX8997_ENABLE_SHIFT |
 		chip->mode << MAX8997_MODE_SHIFT | chip->pwm_divisor;
-	max8997_write_reg(chip->client, MAX8997_HAPTIC_REG_CONF2, value);
+	max8997_write_reg(chip->max8997->regmap_haptic,
+		MAX8997_HAPTIC_REG_CONF2, value);
 
 	if (chip->mode == MAX8997_INTERNAL_MODE && chip->enabled) {
 		value = chip->internal_mode_pattern << MAX8997_CYCLE_SHIFT |
 			chip->internal_mode_pattern << MAX8997_SIG_PERIOD_SHIFT |
 			chip->internal_mode_pattern << MAX8997_SIG_DUTY_SHIFT |
 			chip->internal_mode_pattern << MAX8997_PWM_DUTY_SHIFT;
-		max8997_write_reg(chip->client,
+		max8997_write_reg(chip->max8997->regmap_haptic,
 			MAX8997_HAPTIC_REG_DRVCONF, value);
 
 		switch (chip->internal_mode_pattern) {
 		case 0:
 			value = chip->pattern_cycle << 4;
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_CYCLECONF1, value);
 			value = chip->pattern_signal_period;
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGCONF1, value);
 			break;
 
 		case 1:
 			value = chip->pattern_cycle;
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_CYCLECONF1, value);
 			value = chip->pattern_signal_period;
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGCONF2, value);
 			break;
 
 		case 2:
 			value = chip->pattern_cycle << 4;
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_CYCLECONF2, value);
 			value = chip->pattern_signal_period;
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGCONF3, value);
 			break;
 
 		case 3:
 			value = chip->pattern_cycle;
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_CYCLECONF2, value);
 			value = chip->pattern_signal_period;
-			max8997_write_reg(chip->client,
+			max8997_write_reg(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGCONF4, value);
 			break;
 
@@ -267,7 +268,7 @@ static int max8997_haptic_probe(struct platform_device *pdev)
 	INIT_WORK(&chip->work, max8997_haptic_play_effect_work);
 	mutex_init(&chip->mutex);
 
-	chip->client = iodev->haptic;
+	chip->max8997 = iodev;
 	chip->dev = &pdev->dev;
 	chip->input_dev = input_dev;
 	chip->pwm_period = haptic_pdata->pwm_period;
diff --git a/drivers/leds/leds-max8997.c b/drivers/leds/leds-max8997.c
index f449a8b..a6b8696 100644
--- a/drivers/leds/leds-max8997.c
+++ b/drivers/leds/leds-max8997.c
@@ -53,7 +53,6 @@ static void max8997_led_set_mode(struct max8997_led *led,
 			enum max8997_led_mode mode)
 {
 	int ret;
-	struct i2c_client *client = led->iodev->i2c;
 	u8 mask = 0, val;
 
 	switch (mode) {
@@ -89,8 +88,8 @@ static void max8997_led_set_mode(struct max8997_led *led,
 	}
 
 	if (mask) {
-		ret = max8997_update_reg(client, MAX8997_REG_LEN_CNTL, val,
-					 mask);
+		ret = max8997_update_reg(led->iodev->regmap,
+					MAX8997_REG_LEN_CNTL, val, mask);
 		if (ret)
 			dev_err(led->iodev->dev,
 				"failed to update register(%d)\n", ret);
@@ -102,7 +101,6 @@ static void max8997_led_set_mode(struct max8997_led *led,
 static void max8997_led_enable(struct max8997_led *led, bool enable)
 {
 	int ret;
-	struct i2c_client *client = led->iodev->i2c;
 	u8 val = 0, mask = MAX8997_LED_BOOST_ENABLE_MASK;
 
 	if (led->enabled == enable)
@@ -110,7 +108,8 @@ static void max8997_led_enable(struct max8997_led *led, bool enable)
 
 	val = enable ? MAX8997_LED_BOOST_ENABLE_MASK : 0;
 
-	ret = max8997_update_reg(client, MAX8997_REG_BOOST_CNTL, val, mask);
+	ret = max8997_update_reg(led->iodev->regmap,
+				MAX8997_REG_BOOST_CNTL, val, mask);
 	if (ret)
 		dev_err(led->iodev->dev,
 			"failed to update register(%d)\n", ret);
@@ -122,7 +121,6 @@ static void max8997_led_set_current(struct max8997_led *led,
 				enum led_brightness value)
 {
 	int ret;
-	struct i2c_client *client = led->iodev->i2c;
 	u8 val = 0, mask = 0, reg = 0;
 
 	switch (led->led_mode) {
@@ -143,7 +141,7 @@ static void max8997_led_set_current(struct max8997_led *led,
 	}
 
 	if (mask) {
-		ret = max8997_update_reg(client, reg, val, mask);
+		ret = max8997_update_reg(led->iodev->regmap, reg, val, mask);
 		if (ret)
 			dev_err(led->iodev->dev,
 				"failed to update register(%d)\n", ret);
diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
index 43fa614..05d3b87 100644
--- a/drivers/mfd/max8997-irq.c
+++ b/drivers/mfd/max8997-irq.c
@@ -124,15 +124,20 @@ static void max8997_irq_sync_unlock(struct irq_data *data)
 	int i;
 
 	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
+		struct regmap *map;
 		u8 mask_reg = max8997_mask_reg[i];
-		struct i2c_client *i2c = get_i2c(max8997, i);
+
+		if (i >= MUIC_INT1 && i <= MUIC_INT3)
+			map = max8997->regmap_muic;
+		else
+			map = max8997->regmap;
 
 		if (mask_reg == MAX8997_REG_INVALID ||
-				IS_ERR_OR_NULL(i2c))
+				IS_ERR_OR_NULL(map))
 			continue;
 		max8997->irq_masks_cache[i] = max8997->irq_masks_cur[i];
 
-		max8997_write_reg(i2c, max8997_mask_reg[i],
+		max8997_write_reg(map, max8997_mask_reg[i],
 				max8997->irq_masks_cur[i]);
 	}
 
@@ -185,7 +190,7 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 	int ret;
 	int i, cur_irq;
 
-	ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
+	ret = max8997_read_reg(max8997->regmap, MAX8997_REG_INTSRC, &irq_src);
 	if (ret < 0) {
 		dev_err(max8997->dev, "Failed to read interrupt source: %d\n",
 				ret);
@@ -194,7 +199,7 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 
 	if (irq_src & MAX8997_IRQSRC_PMIC) {
 		/* PMIC INT1 ~ INT4 */
-		max8997_bulk_read(max8997->i2c, MAX8997_REG_INT1, 4,
+		max8997_bulk_read(max8997->regmap, MAX8997_REG_INT1, 4,
 				&irq_reg[PMIC_INT1]);
 	}
 	if (irq_src & MAX8997_IRQSRC_FUELGAUGE) {
@@ -215,8 +220,8 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 	}
 	if (irq_src & MAX8997_IRQSRC_MUIC) {
 		/* MUIC INT1 ~ INT3 */
-		max8997_bulk_read(max8997->muic, MAX8997_MUIC_REG_INT1, 3,
-				&irq_reg[MUIC_INT1]);
+		max8997_bulk_read(max8997->regmap_muic,
+				MAX8997_MUIC_REG_INT1, 3, &irq_reg[MUIC_INT1]);
 	}
 	if (irq_src & MAX8997_IRQSRC_GPIO) {
 		/* GPIO Interrupt */
@@ -225,7 +230,7 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 		irq_reg[GPIO_LOW] = 0;
 		irq_reg[GPIO_HI] = 0;
 
-		max8997_bulk_read(max8997->i2c, MAX8997_REG_GPIOCNTL1,
+		max8997_bulk_read(max8997->regmap, MAX8997_REG_GPIOCNTL1,
 				MAX8997_NUM_GPIO, gpio_info);
 		for (i = 0; i < MAX8997_NUM_GPIO; i++) {
 			bool interrupt = false;
@@ -260,7 +265,7 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 	}
 	if (irq_src & MAX8997_IRQSRC_FLASH) {
 		/* Flash Status Interrupt */
-		ret = max8997_read_reg(max8997->i2c, MAX8997_REG_FLASHSTATUS,
+		ret = max8997_read_reg(max8997->regmap, MAX8997_REG_FLASHSTATUS,
 				&irq_reg[FLASH_STATUS]);
 	}
 
@@ -323,22 +328,20 @@ int max8997_irq_init(struct max8997_dev *max8997)
 
 	/* Mask individual interrupt sources */
 	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
-		struct i2c_client *i2c;
-
 		max8997->irq_masks_cur[i] = 0xff;
 		max8997->irq_masks_cache[i] = 0xff;
 		i2c = get_i2c(max8997, i);
 
-		if (IS_ERR_OR_NULL(i2c))
+		if (IS_ERR_OR_NULL(max8997->regmap))
 			continue;
 		if (max8997_mask_reg[i] == MAX8997_REG_INVALID)
 			continue;
 
-		max8997_write_reg(i2c, max8997_mask_reg[i], 0xff);
+		max8997_write_reg(max8997->regmap, max8997_mask_reg[i], 0xff);
 	}
 
 	for (i = 0; i < MAX8997_NUM_GPIO; i++) {
-		max8997->gpio_status[i] = (max8997_read_reg(max8997->i2c,
+		max8997->gpio_status[i] = (max8997_read_reg(max8997->regmap,
 						MAX8997_REG_GPIOCNTL1 + i,
 						&val)
 					& MAX8997_GPIO_DATA_MASK) ?
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index be88a3b..590e368 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -33,6 +33,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
+#include <linux/regmap.h>
 
 #define I2C_ADDR_PMIC	(0xCC >> 1)
 #define I2C_ADDR_MUIC	(0x4A >> 1)
@@ -57,82 +58,82 @@ static struct of_device_id max8997_pmic_dt_match[] = {
 };
 #endif
 
-int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
+int max8997_read_reg(struct regmap *map, u8 reg, u8 *dest)
 {
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
+	unsigned int val;
 	int ret;
 
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_read_byte_data(i2c, reg);
-	mutex_unlock(&max8997->iolock);
-	if (ret < 0)
-		return ret;
+	ret = regmap_read(map, reg, &val);
+	*dest = val;
 
-	ret &= 0xff;
-	*dest = ret;
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(max8997_read_reg);
 
-int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
+int max8997_bulk_read(struct regmap *map, u8 reg, int count, u8 *buf)
 {
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
 	int ret;
 
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
-	mutex_unlock(&max8997->iolock);
-	if (ret < 0)
-		return ret;
+	ret = regmap_bulk_read(map, reg, buf, count);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(max8997_bulk_read);
 
-int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
+int max8997_write_reg(struct regmap *map, u8 reg, u8 value)
 {
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
 	int ret;
 
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_write_byte_data(i2c, reg, value);
-	mutex_unlock(&max8997->iolock);
+	ret = regmap_write(map, reg, value);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(max8997_write_reg);
 
-int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
+int max8997_bulk_write(struct regmap *map, u8 reg, int count, u8 *buf)
 {
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
 	int ret;
 
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_write_i2c_block_data(i2c, reg, count, buf);
-	mutex_unlock(&max8997->iolock);
-	if (ret < 0)
-		return ret;
+	ret = regmap_bulk_write(map, reg, buf, count);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(max8997_bulk_write);
 
-int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
+int max8997_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
 {
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
 	int ret;
 
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_read_byte_data(i2c, reg);
-	if (ret >= 0) {
-		u8 old_val = ret & 0xff;
-		u8 new_val = (val & mask) | (old_val & (~mask));
-		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
-	}
-	mutex_unlock(&max8997->iolock);
+	ret = regmap_update_bits(map, reg, mask, val);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(max8997_update_reg);
 
+static const struct regmap_config max8997_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_REG_PMIC_END,
+};
+
+static const struct regmap_config max8997_regmap_rtc_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_RTC_REG_END,
+};
+
+static const struct regmap_config max8997_regmap_haptic_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_HAPTIC_REG_END,
+};
+
+static const struct regmap_config max8997_regmap_muic_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_MUIC_REG_END,
+};
+
 /*
  * Only the common platform data elements for max8997 are parsed here from the
  * device tree. Other sub-modules of max8997 such as pmic, rtc and others have
@@ -202,6 +203,14 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	if (!pdata)
 		return ret;
 
+	max8997->regmap = devm_regmap_init_i2c(i2c, &max8997_regmap_config);
+	if (IS_ERR(max8997->regmap)) {
+		ret = PTR_ERR(max8997->regmap);
+		dev_err(max8997->dev, "failed to allocate register map: %d\n",
+				ret);
+		return ret;
+	}
+
 	max8997->pdata = pdata;
 	max8997->ono = pdata->ono;
 
@@ -209,11 +218,40 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 	max8997->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
 	i2c_set_clientdata(max8997->rtc, max8997);
+
 	max8997->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
 	i2c_set_clientdata(max8997->haptic, max8997);
+
 	max8997->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
 	i2c_set_clientdata(max8997->muic, max8997);
 
+	max8997->regmap_rtc = devm_regmap_init_i2c(max8997->rtc,
+					&max8997_regmap_rtc_config);
+	if (IS_ERR(max8997->regmap_rtc)) {
+		ret = PTR_ERR(max8997->regmap_rtc);
+		dev_err(max8997->dev,
+				"failed to allocate register map: %d\n", ret);
+		goto err_regmap;
+	}
+
+	max8997->regmap_haptic = devm_regmap_init_i2c(max8997->haptic,
+					&max8997_regmap_haptic_config);
+	if (IS_ERR(max8997->regmap_haptic)) {
+		ret = PTR_ERR(max8997->regmap_haptic);
+		dev_err(max8997->dev,
+				"failed to allocate register map: %d\n", ret);
+		goto err_regmap;
+	}
+
+	max8997->regmap_muic = devm_regmap_init_i2c(max8997->muic,
+					&max8997_regmap_muic_config);
+	if (IS_ERR(max8997->regmap_muic)) {
+		ret = PTR_ERR(max8997->regmap_muic);
+		dev_err(max8997->dev,
+				"failed to allocate register map: %d\n", ret);
+		goto err_regmap;
+	}
+
 	pm_runtime_set_active(max8997->dev);
 
 	max8997_irq_init(max8997);
@@ -238,6 +276,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 err_mfd:
 	mfd_remove_devices(max8997->dev);
+err_regmap:
 	i2c_unregister_device(max8997->muic);
 	i2c_unregister_device(max8997->haptic);
 	i2c_unregister_device(max8997->rtc);
@@ -423,15 +462,15 @@ static int max8997_freeze(struct device *dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
-		max8997_read_reg(i2c, max8997_dumpaddr_pmic[i],
+		max8997_read_reg(max8997->regmap, max8997_dumpaddr_pmic[i],
 				&max8997->reg_dump[i]);
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
-		max8997_read_reg(i2c, max8997_dumpaddr_muic[i],
+		max8997_read_reg(max8997->regmap_muic, max8997_dumpaddr_muic[i],
 				&max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
-		max8997_read_reg(i2c, max8997_dumpaddr_haptic[i],
+		max8997_read_reg(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
 				&max8997->reg_dump[i + MAX8997_REG_PMIC_END +
 				MAX8997_MUIC_REG_END]);
 
@@ -445,15 +484,15 @@ static int max8997_restore(struct device *dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
-		max8997_write_reg(i2c, max8997_dumpaddr_pmic[i],
+		max8997_write_reg(max8997->regmap, max8997_dumpaddr_pmic[i],
 				max8997->reg_dump[i]);
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
-		max8997_write_reg(i2c, max8997_dumpaddr_muic[i],
+		max8997_write_reg(max8997->regmap_muic, max8997_dumpaddr_muic[i],
 				max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
-		max8997_write_reg(i2c, max8997_dumpaddr_haptic[i],
+		max8997_write_reg(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
 				max8997->reg_dump[i + MAX8997_REG_PMIC_END +
 				MAX8997_MUIC_REG_END]);
 
diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index 4bdedfe..027e9bf 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -46,14 +46,14 @@ static int max8997_battery_get_property(struct power_supply *psy,
 {
 	struct charger_data *charger = container_of(psy,
 			struct charger_data, battery);
-	struct i2c_client *i2c = charger->iodev->i2c;
 	int ret;
 	u8 reg;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		val->intval = 0;
-		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		ret = max8997_read_reg(charger->iodev->regmap,
+				MAX8997_REG_STATUS4, &reg);
 		if (ret)
 			return ret;
 		if ((reg & (1 << 0)) == 0x1)
@@ -62,7 +62,8 @@ static int max8997_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = 0;
-		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		ret = max8997_read_reg(charger->iodev->regmap,
+				MAX8997_REG_STATUS4, &reg);
 		if (ret)
 			return ret;
 		if ((reg & (1 << 2)) == 0x0)
@@ -71,7 +72,8 @@ static int max8997_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = 0;
-		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		ret = max8997_read_reg(charger->iodev->regmap,
+				MAX8997_REG_STATUS4, &reg);
 		if (ret)
 			return ret;
 		/* DCINOK */
@@ -103,7 +105,7 @@ static int max8997_battery_probe(struct platform_device *pdev)
 		if (val > 0xf)
 			val = 0xf;
 
-		ret = max8997_update_reg(iodev->i2c,
+		ret = max8997_update_reg(iodev->regmap,
 				MAX8997_REG_MBCCTRL5, val, 0xf);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Cannot use i2c bus.\n");
@@ -113,20 +115,20 @@ static int max8997_battery_probe(struct platform_device *pdev)
 
 	switch (pdata->timeout) {
 	case 5:
-		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
-				0x2 << 4, 0x7 << 4);
+		ret = max8997_update_reg(iodev->regmap,
+				MAX8997_REG_MBCCTRL1, 0x2 << 4, 0x7 << 4);
 		break;
 	case 6:
-		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
-				0x3 << 4, 0x7 << 4);
+		ret = max8997_update_reg(iodev->regmap,
+				MAX8997_REG_MBCCTRL1, 0x3 << 4, 0x7 << 4);
 		break;
 	case 7:
-		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
-				0x4 << 4, 0x7 << 4);
+		ret = max8997_update_reg(iodev->regmap,
+				MAX8997_REG_MBCCTRL1, 0x4 << 4, 0x7 << 4);
 		break;
 	case 0:
-		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
-				0x7 << 4, 0x7 << 4);
+		ret = max8997_update_reg(iodev->regmap,
+				MAX8997_REG_MBCCTRL1, 0x7 << 4, 0x7 << 4);
 		break;
 	default:
 		dev_err(&pdev->dev, "incorrect timeout value (%d)\n",
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 2d618fc..470435e 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -258,7 +258,6 @@ static int max8997_get_enable_register(struct regulator_dev *rdev,
 static int max8997_reg_is_enabled(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int ret, reg, mask, pattern;
 	u8 val;
 
@@ -266,7 +265,7 @@ static int max8997_reg_is_enabled(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	ret = max8997_read_reg(i2c, reg, &val);
+	ret = max8997_read_reg(max8997->iodev->regmap, reg, &val);
 	if (ret)
 		return ret;
 
@@ -276,27 +275,25 @@ static int max8997_reg_is_enabled(struct regulator_dev *rdev)
 static int max8997_reg_enable(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int ret, reg, mask, pattern;
 
 	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
 	if (ret)
 		return ret;
 
-	return max8997_update_reg(i2c, reg, pattern, mask);
+	return max8997_update_reg(max8997->iodev->regmap, reg, pattern, mask);
 }
 
 static int max8997_reg_disable(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int ret, reg, mask, pattern;
 
 	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
 	if (ret)
 		return ret;
 
-	return max8997_update_reg(i2c, reg, ~pattern, mask);
+	return max8997_update_reg(max8997->iodev->regmap, reg, ~pattern, mask);
 }
 
 static int max8997_get_voltage_register(struct regulator_dev *rdev,
@@ -368,7 +365,6 @@ static int max8997_get_voltage_register(struct regulator_dev *rdev,
 static int max8997_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int reg, shift, mask, ret;
 	u8 val;
 
@@ -376,7 +372,7 @@ static int max8997_get_voltage_sel(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	ret = max8997_read_reg(i2c, reg, &val);
+	ret = max8997_read_reg(max8997->iodev->regmap, reg, &val);
 	if (ret)
 		return ret;
 
@@ -413,7 +409,6 @@ static int max8997_set_voltage_charger_cv(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int rid = rdev_get_id(rdev);
 	int lb, ub;
 	int reg, shift = 0, mask, ret = 0;
@@ -455,7 +450,8 @@ static int max8997_set_voltage_charger_cv(struct regulator_dev *rdev,
 
 	*selector = val;
 
-	ret = max8997_update_reg(i2c, reg, val << shift, mask);
+	ret = max8997_update_reg(max8997->iodev->regmap,
+				reg, val << shift, mask);
 
 	return ret;
 }
@@ -468,7 +464,6 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	const struct voltage_map_desc *desc;
 	int rid = rdev_get_id(rdev);
 	int i, reg, shift, mask, ret;
@@ -500,7 +495,8 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	ret = max8997_update_reg(i2c, reg, i << shift, mask << shift);
+	ret = max8997_update_reg(max8997->iodev->regmap,
+				reg, i << shift, mask << shift);
 	*selector = i;
 
 	return ret;
@@ -710,7 +706,6 @@ static int max8997_set_voltage_safeout_sel(struct regulator_dev *rdev,
 					   unsigned selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int rid = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
 
@@ -721,13 +716,13 @@ static int max8997_set_voltage_safeout_sel(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	return max8997_update_reg(i2c, reg, selector << shift, mask << shift);
+	return max8997_update_reg(max8997->iodev->regmap,
+				reg, selector << shift, mask << shift);
 }
 
 static int max8997_reg_disable_suspend(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int ret, reg, mask, pattern;
 	int rid = rdev_get_id(rdev);
 
@@ -735,20 +730,22 @@ static int max8997_reg_disable_suspend(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	max8997_read_reg(i2c, reg, &max8997->saved_states[rid]);
+	max8997_read_reg(max8997->iodev->regmap,
+			reg, &max8997->saved_states[rid]);
 
 	if (rid == MAX8997_LDO1 ||
 			rid == MAX8997_LDO10 ||
 			rid == MAX8997_LDO21) {
 		dev_dbg(&rdev->dev, "Conditional Power-Off for %s\n",
 				rdev->desc->name);
-		return max8997_update_reg(i2c, reg, 0x40, mask);
+		return max8997_update_reg(max8997->iodev->regmap,
+				reg, 0x40, mask);
 	}
 
 	dev_dbg(&rdev->dev, "Full Power-Off for %s (%xh -> %xh)\n",
 			rdev->desc->name, max8997->saved_states[rid] & mask,
 			(~pattern) & mask);
-	return max8997_update_reg(i2c, reg, ~pattern, mask);
+	return max8997_update_reg(max8997->iodev->regmap, reg, ~pattern, mask);
 }
 
 static struct regulator_ops max8997_ldo_ops = {
@@ -1032,7 +1029,6 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	struct regulator_dev **rdev;
 	struct max8997_data *max8997;
-	struct i2c_client *i2c;
 	int i, ret, size, nr_dvs;
 	u8 max_buck1 = 0, max_buck2 = 0, max_buck5 = 0;
 
@@ -1062,7 +1058,6 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	max8997->iodev = iodev;
 	max8997->num_regulators = pdata->num_regulators;
 	platform_set_drvdata(pdev, max8997);
-	i2c = max8997->iodev->i2c;
 
 	max8997->buck125_gpioindex = pdata->buck125_default_idx;
 	max8997->buck1_gpiodvs = pdata->buck1_gpiodvs;
@@ -1112,25 +1107,25 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 
 	/* For the safety, set max voltage before setting up */
 	for (i = 0; i < 8; i++) {
-		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
-				max_buck1, 0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
-				max_buck2, 0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
-				max_buck5, 0x3f);
+		max8997_update_reg(max8997->iodev->regmap,
+				MAX8997_REG_BUCK1DVS1 + i, max_buck1, 0x3f);
+		max8997_update_reg(max8997->iodev->regmap,
+				MAX8997_REG_BUCK2DVS1 + i, max_buck2, 0x3f);
+		max8997_update_reg(max8997->iodev->regmap,
+				MAX8997_REG_BUCK5DVS1 + i, max_buck5, 0x3f);
 	}
 
 	/* Initialize all the DVS related BUCK registers */
 	for (i = 0; i < nr_dvs; i++) {
-		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
-				max8997->buck1_vol[i],
-				0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
-				max8997->buck2_vol[i],
-				0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
-				max8997->buck5_vol[i],
-				0x3f);
+		max8997_update_reg(max8997->iodev->regmap,
+				MAX8997_REG_BUCK1DVS1 + i,
+				max8997->buck1_vol[i], 0x3f);
+		max8997_update_reg(max8997->iodev->regmap,
+				MAX8997_REG_BUCK2DVS1 + i,
+				max8997->buck2_vol[i], 0x3f);
+		max8997_update_reg(max8997->iodev->regmap,
+				MAX8997_REG_BUCK5DVS1 + i,
+				max8997->buck5_vol[i], 0x3f);
 	}
 
 	/*
@@ -1174,16 +1169,17 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	}
 
 	/* DVS-GPIO disabled */
-	max8997_update_reg(i2c, MAX8997_REG_BUCK1CTRL, (pdata->buck1_gpiodvs) ?
-			(1 << 1) : (0 << 1), 1 << 1);
-	max8997_update_reg(i2c, MAX8997_REG_BUCK2CTRL, (pdata->buck2_gpiodvs) ?
-			(1 << 1) : (0 << 1), 1 << 1);
-	max8997_update_reg(i2c, MAX8997_REG_BUCK5CTRL, (pdata->buck5_gpiodvs) ?
-			(1 << 1) : (0 << 1), 1 << 1);
+	max8997_update_reg(max8997->iodev->regmap, MAX8997_REG_BUCK1CTRL,
+			(pdata->buck1_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
+	max8997_update_reg(max8997->iodev->regmap, MAX8997_REG_BUCK2CTRL,
+			(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
+	max8997_update_reg(max8997->iodev->regmap, MAX8997_REG_BUCK5CTRL,
+			(pdata->buck5_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
 
 	/* Misc Settings */
 	max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
-	max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
+	max8997_write_reg(max8997->iodev->regmap,
+			MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
 
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct voltage_map_desc *desc;
diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index 0777c01..218535c 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -68,7 +68,6 @@ enum {
 struct max8997_rtc_info {
 	struct device		*dev;
 	struct max8997_dev	*max8997;
-	struct i2c_client	*rtc;
 	struct rtc_device	*rtc_dev;
 	struct mutex		lock;
 	int virq;
@@ -118,8 +117,8 @@ static inline int max8997_rtc_set_update_reg(struct max8997_rtc_info *info)
 {
 	int ret;
 
-	ret = max8997_write_reg(info->rtc, MAX8997_RTC_UPDATE1,
-						RTC_UDR_MASK);
+	ret = max8997_write_reg(info->max8997->regmap_rtc,
+				MAX8997_RTC_UPDATE1, RTC_UDR_MASK);
 	if (ret < 0)
 		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
 				__func__, ret);
@@ -140,7 +139,8 @@ static int max8997_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	int ret;
 
 	mutex_lock(&info->lock);
-	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_SEC, RTC_NR_TIME, data);
+	ret = max8997_bulk_read(info->max8997->regmap_rtc,
+				MAX8997_RTC_SEC, RTC_NR_TIME, data);
 	mutex_unlock(&info->lock);
 
 	if (ret < 0) {
@@ -166,7 +166,8 @@ static int max8997_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	mutex_lock(&info->lock);
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_SEC, RTC_NR_TIME, data);
+	ret = max8997_bulk_write(info->max8997->regmap_rtc,
+				MAX8997_RTC_SEC, RTC_NR_TIME, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write time reg(%d)\n", __func__,
 				ret);
@@ -188,8 +189,8 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	mutex_lock(&info->lock);
 
-	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-			data);
+	ret = max8997_bulk_read(info->max8997->regmap_rtc,
+				MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s:%d fail to read alarm reg(%d)\n",
 				__func__, __LINE__, ret);
@@ -207,7 +208,8 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	}
 
 	alrm->pending = 0;
-	ret = max8997_read_reg(info->max8997->i2c, MAX8997_REG_STATUS1, &val);
+	ret = max8997_read_reg(info->max8997->regmap_rtc,
+			       MAX8997_REG_STATUS1, &val);
 	if (ret < 0) {
 		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
 				__func__, __LINE__, ret);
@@ -230,8 +232,8 @@ static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
 	if (!mutex_is_locked(&info->lock))
 		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
 
-	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				data);
+	ret = max8997_bulk_read(info->max8997->regmap_rtc,
+				MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
 				__func__, ret);
@@ -241,8 +243,8 @@ static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
 	for (i = 0; i < RTC_NR_TIME; i++)
 		data[i] &= ~ALARM_ENABLE_MASK;
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				 data);
+	ret = max8997_bulk_write(info->max8997->regmap_rtc,
+				 MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
 				__func__, ret);
@@ -262,8 +264,8 @@ static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
 	if (!mutex_is_locked(&info->lock))
 		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
 
-	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				data);
+	ret = max8997_bulk_read(info->max8997->regmap_rtc,
+				MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
 				__func__, ret);
@@ -281,8 +283,8 @@ static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
 	if (data[RTC_DATE] & 0x1f)
 		data[RTC_DATE] |= (1 << ALARM_ENABLE_SHIFT);
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				 data);
+	ret = max8997_bulk_write(info->max8997->regmap_rtc,
+				 MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
 				__func__, ret);
@@ -313,8 +315,8 @@ static int max8997_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret < 0)
 		goto out;
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				data);
+	ret = max8997_bulk_write(info->max8997->regmap_rtc,
+				 MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
 				__func__, ret);
@@ -385,7 +387,8 @@ static void max8997_rtc_enable_wtsr(struct max8997_rtc_info *info, bool enable)
 	dev_info(info->dev, "%s: %s WTSR\n", __func__,
 			enable ? "enable" : "disable");
 
-	ret = max8997_update_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, val, mask);
+	ret = max8997_update_reg(info->max8997->regmap_rtc,
+				 MAX8997_RTC_WTSR_SMPL, val, mask);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
 				__func__, ret);
@@ -413,7 +416,8 @@ static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
 	dev_info(info->dev, "%s: %s SMPL\n", __func__,
 			enable ? "enable" : "disable");
 
-	ret = max8997_update_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, val, mask);
+	ret = max8997_update_reg(info->max8997->regmap_rtc,
+				 MAX8997_RTC_WTSR_SMPL, val, mask);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
 				__func__, ret);
@@ -423,7 +427,8 @@ static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
 	max8997_rtc_set_update_reg(info);
 
 	val = 0;
-	max8997_read_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, &val);
+	max8997_read_reg(info->max8997->regmap_rtc,
+			 MAX8997_RTC_WTSR_SMPL, &val);
 	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
 }
 
@@ -438,7 +443,8 @@ static int max8997_rtc_init_reg(struct max8997_rtc_info *info)
 
 	info->rtc_24hr_mode = 1;
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_CTRLMASK, 2, data);
+	ret = max8997_bulk_write(info->max8997->regmap_rtc,
+				 MAX8997_RTC_CTRLMASK, 2, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
 				__func__, ret);
@@ -463,7 +469,6 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 	mutex_init(&info->lock);
 	info->dev = &pdev->dev;
 	info->max8997 = max8997;
-	info->rtc = max8997->rtc;
 
 	platform_set_drvdata(pdev, info);
 
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index ad1ae7f..184e40a 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -309,6 +309,8 @@ enum max8997_rtc_reg {
 	MAX8997_RTC_ALARM2_MONTH	= 0x22,
 	MAX8997_RTC_ALARM2_YEAR		= 0x23,
 	MAX8997_RTC_ALARM2_DAY_OF_MONTH	= 0x24,
+
+	MAX8997_RTC_REG_END		= 0x25,
 };
 
 enum max8997_irq_source {
@@ -390,6 +392,11 @@ struct max8997_dev {
 	int type;
 	struct platform_device *battery; /* battery control (not fuel gauge) */
 
+	struct regmap *regmap;
+	struct regmap *regmap_rtc;
+	struct regmap *regmap_haptic;
+	struct regmap *regmap_muic;
+
 	int irq;
 	int ono;
 	struct irq_domain *irq_domain;
@@ -413,13 +420,11 @@ extern int max8997_irq_init(struct max8997_dev *max8997);
 extern void max8997_irq_exit(struct max8997_dev *max8997);
 extern int max8997_irq_resume(struct max8997_dev *max8997);
 
-extern int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
-extern int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count,
-				u8 *buf);
-extern int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
-extern int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count,
-				u8 *buf);
-extern int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
+extern int max8997_read_reg(struct regmap *map, u8 reg, u8 *dest);
+extern int max8997_bulk_read(struct regmap *map, u8 reg, int count, u8 *buf);
+extern int max8997_write_reg(struct regmap *map, u8 reg, u8 value);
+extern int max8997_bulk_write(struct regmap *map, u8 reg, int count, u8 *buf);
+extern int max8997_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask);
 
 #define MAX8997_GPIO_INT_BOTH	(0x3 << 4)
 #define MAX8997_GPIO_INT_RISE	(0x2 << 4)
-- 
1.7.9.5

