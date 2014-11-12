Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaKLHXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:23:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54105 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaKLHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:23:47 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-5a-54630aff5ce2
From: Robert Baldyga <r.baldyga@samsung.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, sachin.kamat@linaro.org,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-pm@vger.kernel.org, rtc-linux@googlegroups.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v5 1/3] mfd: max8997: use regmap to access registers
Date: Wed, 12 Nov 2014 08:23:14 +0100
Message-id: <1415776996-11569-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415776996-11569-1-git-send-email-r.baldyga@samsung.com>
References: <1415776996-11569-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jQV0G7uQQg/vtXBZLLl5lt5j68Amb
	xdGdE5ksrn95zmox6cl7ZovDi14wWkxcOZnZ4vULQ4v7X48yWny70sFkcfPTN1aLy7vmsFls
	fbOO0eJz7xFGi9uNK9gsru09zmzx4PBOdovdu56yWuzv7GC0OPmnl9HidDerxendJQ5iHjtn
	3WX32DPxJJvH5hVaHptWdbJ53Lm2h81j3slAjz3zf7B69G1Zxegxfd5PJo/Pm+Q81m/ZyhTA
	HcVlk5Kak1mWWqRvl8CVcXPSd/aC7utMFb3XnjE1MG6ZydTFyMkhIWAi8XjhXkYIW0ziwr31
	bF2MXBxCAtMZJZZMfcUI4bQzSey+eRWsik1AR2LL9wlgtoiAhMTGH30sIEXMArNZJF68fgTU
	zsEhLOAiMfd4BUgNi4CqxM/Z/1hAwrwCrhLnDydBLJOTOHlsMiuIzSngJtF36yALiC0EVDLv
	2Tu2CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER8gz6R2MqxosDjEKcDAq8fBm
	bE4KEWJNLCuuzD3EKMHBrCTC++krUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS
	1OzU1ILUIpgsEwenVANjTXKNb6jenq3OZnsrdthO3P3PbpeR88xWvdBw/yiFGRc0NjSdUV9x
	652KhIvbatk9y2aUbj4259COtfv3/FTynLDN/FNcXtfeFJWdn85uS1h66Uua15Xw53GNlou2
	2xwPPS/ZdLf6tuLfXYHNXA9ybJ+bNUTzzbsQfLFzWvSpe7OsvWWD/u3+osRSnJFoqMVcVJwI
	AKEk1PuMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies max8997 driver and each associated function driver,
to use regmap instead of operating directly on i2c bus. It will allow to
simplify IRQ handling using regmap-irq.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

[For extcon part]
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

[For leds part]
Acked-by: Bryan Wu <cooloney@gmail.com>

[For the mfd part]
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/extcon/extcon-max8997.c     |  31 ++++----
 drivers/input/misc/max8997_haptic.c |  34 +++++----
 drivers/leds/leds-max8997.c         |  13 ++--
 drivers/mfd/Kconfig                 |   1 +
 drivers/mfd/max8997-irq.c           |  64 +++++++---------
 drivers/mfd/max8997.c               | 141 ++++++++++++++++--------------------
 drivers/power/max8997_charger.c     |  33 +++++----
 drivers/regulator/max8997.c         |  87 +++++++++++-----------
 drivers/rtc/rtc-max8997.c           |  56 +++++++-------
 include/linux/mfd/max8997-private.h |  17 ++---
 10 files changed, 228 insertions(+), 249 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 75e501c..2aafd5b 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -27,6 +27,7 @@
 #include <linux/mfd/max8997-private.h>
 #include <linux/extcon.h>
 #include <linux/irqdomain.h>
+#include <linux/regmap.h>
 
 #define	DEV_NAME			"max8997-muic"
 #define	DELAY_MS_DEFAULT		20000		/* unit: millisecond */
@@ -116,7 +117,7 @@ enum max8997_muic_charger_type {
 
 struct max8997_muic_info {
 	struct device *dev;
-	struct i2c_client *muic;
+	struct max8997_dev *max8997;
 	struct extcon_dev *edev;
 	int prev_cable_type;
 	int prev_chg_type;
@@ -190,10 +191,10 @@ static int max8997_muic_set_debounce_time(struct max8997_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = max8997_update_reg(info->muic,
+		ret = regmap_update_bits(info->max8997->regmap_muic,
 					  MAX8997_MUIC_REG_CONTROL3,
-					  time << CONTROL3_ADCDBSET_SHIFT,
-					  CONTROL3_ADCDBSET_MASK);
+					  CONTROL3_ADCDBSET_MASK,
+					  time << CONTROL3_ADCDBSET_SHIFT);
 		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
 			return ret;
@@ -228,8 +229,8 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 	else
 		ctrl1 = CONTROL1_SW_OPEN;
 
-	ret = max8997_update_reg(info->muic,
-			MAX8997_MUIC_REG_CONTROL1, ctrl1, COMP_SW_MASK);
+	ret = regmap_update_bits(info->max8997->regmap_muic,
+			MAX8997_MUIC_REG_CONTROL1, COMP_SW_MASK, ctrl1);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
@@ -240,9 +241,9 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 	else
 		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
 
-	ret = max8997_update_reg(info->muic,
-			MAX8997_MUIC_REG_CONTROL2, ctrl2,
-			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
+	ret = regmap_update_bits(info->max8997->regmap_muic,
+			MAX8997_MUIC_REG_CONTROL2,
+			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK, ctrl2);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
@@ -543,8 +544,8 @@ static void max8997_muic_irq_work(struct work_struct *work)
 		if (info->irq == muic_irqs[i].virq)
 			irq_type = muic_irqs[i].irq;
 
-	ret = max8997_bulk_read(info->muic, MAX8997_MUIC_REG_STATUS1,
-				2, info->status);
+	ret = regmap_bulk_read(info->max8997->regmap_muic,
+				MAX8997_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read muic register\n");
 		mutex_unlock(&info->mutex);
@@ -605,8 +606,8 @@ static int max8997_muic_detect_dev(struct max8997_muic_info *info)
 	mutex_lock(&info->mutex);
 
 	/* Read STATUSx register to detect accessory */
-	ret = max8997_bulk_read(info->muic,
-			MAX8997_MUIC_REG_STATUS1, 2, info->status);
+	ret = regmap_bulk_read(info->max8997->regmap_muic,
+			MAX8997_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
@@ -665,7 +666,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	info->dev = &pdev->dev;
-	info->muic = max8997->muic;
+	info->max8997 = max8997;
 
 	platform_set_drvdata(pdev, info);
 	mutex_init(&info->mutex);
@@ -717,7 +718,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 
 		/* Initialize registers according to platform data */
 		for (i = 0; i < muic_pdata->num_init_data; i++) {
-			max8997_write_reg(info->muic,
+			regmap_write(info->max8997->regmap_muic,
 					muic_pdata->init_data[i].addr,
 					muic_pdata->init_data[i].data);
 		}
diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
index a363ebb..53b32b5 100644
--- a/drivers/input/misc/max8997_haptic.c
+++ b/drivers/input/misc/max8997_haptic.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/max8997-private.h>
 #include <linux/mfd/max8997.h>
 #include <linux/regulator/consumer.h>
+#include <linux/regmap.h>
 
 /* Haptic configuration 2 register */
 #define MAX8997_MOTOR_TYPE_SHIFT	7
@@ -45,7 +46,7 @@
 
 struct max8997_haptic {
 	struct device *dev;
-	struct i2c_client *client;
+	struct max8997_dev *max8997;
 	struct input_dev *input_dev;
 	struct regulator *regulator;
 
@@ -86,19 +87,19 @@ static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
 		}
 		switch (chip->internal_mode_pattern) {
 		case 0:
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGPWMDC1, duty_index);
 			break;
 		case 1:
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGPWMDC2, duty_index);
 			break;
 		case 2:
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGPWMDC3, duty_index);
 			break;
 		case 3:
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGPWMDC4, duty_index);
 			break;
 		default:
@@ -115,50 +116,51 @@ static void max8997_haptic_configure(struct max8997_haptic *chip)
 	value = chip->type << MAX8997_MOTOR_TYPE_SHIFT |
 		chip->enabled << MAX8997_ENABLE_SHIFT |
 		chip->mode << MAX8997_MODE_SHIFT | chip->pwm_divisor;
-	max8997_write_reg(chip->client, MAX8997_HAPTIC_REG_CONF2, value);
+	regmap_write(chip->max8997->regmap_haptic,
+		MAX8997_HAPTIC_REG_CONF2, value);
 
 	if (chip->mode == MAX8997_INTERNAL_MODE && chip->enabled) {
 		value = chip->internal_mode_pattern << MAX8997_CYCLE_SHIFT |
 			chip->internal_mode_pattern << MAX8997_SIG_PERIOD_SHIFT |
 			chip->internal_mode_pattern << MAX8997_SIG_DUTY_SHIFT |
 			chip->internal_mode_pattern << MAX8997_PWM_DUTY_SHIFT;
-		max8997_write_reg(chip->client,
+		regmap_write(chip->max8997->regmap_haptic,
 			MAX8997_HAPTIC_REG_DRVCONF, value);
 
 		switch (chip->internal_mode_pattern) {
 		case 0:
 			value = chip->pattern_cycle << 4;
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_CYCLECONF1, value);
 			value = chip->pattern_signal_period;
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGCONF1, value);
 			break;
 
 		case 1:
 			value = chip->pattern_cycle;
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_CYCLECONF1, value);
 			value = chip->pattern_signal_period;
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGCONF2, value);
 			break;
 
 		case 2:
 			value = chip->pattern_cycle << 4;
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_CYCLECONF2, value);
 			value = chip->pattern_signal_period;
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGCONF3, value);
 			break;
 
 		case 3:
 			value = chip->pattern_cycle;
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_CYCLECONF2, value);
 			value = chip->pattern_signal_period;
-			max8997_write_reg(chip->client,
+			regmap_write(chip->max8997->regmap_haptic,
 				MAX8997_HAPTIC_REG_SIGCONF4, value);
 			break;
 
@@ -277,7 +279,7 @@ static int max8997_haptic_probe(struct platform_device *pdev)
 	INIT_WORK(&chip->work, max8997_haptic_play_effect_work);
 	mutex_init(&chip->mutex);
 
-	chip->client = iodev->haptic;
+	chip->max8997 = iodev;
 	chip->dev = &pdev->dev;
 	chip->input_dev = input_dev;
 	chip->pwm_period = haptic_pdata->pwm_period;
diff --git a/drivers/leds/leds-max8997.c b/drivers/leds/leds-max8997.c
index 607bc27..49bb128 100644
--- a/drivers/leds/leds-max8997.c
+++ b/drivers/leds/leds-max8997.c
@@ -18,6 +18,7 @@
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 
 #define MAX8997_LED_FLASH_SHIFT			3
 #define MAX8997_LED_FLASH_CUR_MASK		0xf8
@@ -53,7 +54,6 @@ static void max8997_led_set_mode(struct max8997_led *led,
 			enum max8997_led_mode mode)
 {
 	int ret;
-	struct i2c_client *client = led->iodev->i2c;
 	u8 mask = 0, val;
 
 	switch (mode) {
@@ -89,8 +89,8 @@ static void max8997_led_set_mode(struct max8997_led *led,
 	}
 
 	if (mask) {
-		ret = max8997_update_reg(client, MAX8997_REG_LEN_CNTL, val,
-					 mask);
+		ret = regmap_update_bits(led->iodev->regmap,
+					MAX8997_REG_LEN_CNTL, mask, val);
 		if (ret)
 			dev_err(led->iodev->dev,
 				"failed to update register(%d)\n", ret);
@@ -102,7 +102,6 @@ static void max8997_led_set_mode(struct max8997_led *led,
 static void max8997_led_enable(struct max8997_led *led, bool enable)
 {
 	int ret;
-	struct i2c_client *client = led->iodev->i2c;
 	u8 val = 0, mask = MAX8997_LED_BOOST_ENABLE_MASK;
 
 	if (led->enabled == enable)
@@ -110,7 +109,8 @@ static void max8997_led_enable(struct max8997_led *led, bool enable)
 
 	val = enable ? MAX8997_LED_BOOST_ENABLE_MASK : 0;
 
-	ret = max8997_update_reg(client, MAX8997_REG_BOOST_CNTL, val, mask);
+	ret = regmap_update_bits(led->iodev->regmap,
+				MAX8997_REG_BOOST_CNTL, mask, val);
 	if (ret)
 		dev_err(led->iodev->dev,
 			"failed to update register(%d)\n", ret);
@@ -122,7 +122,6 @@ static void max8997_led_set_current(struct max8997_led *led,
 				enum led_brightness value)
 {
 	int ret;
-	struct i2c_client *client = led->iodev->i2c;
 	u8 val = 0, mask = 0, reg = 0;
 
 	switch (led->led_mode) {
@@ -143,7 +142,7 @@ static void max8997_led_set_current(struct max8997_led *led,
 	}
 
 	if (mask) {
-		ret = max8997_update_reg(client, reg, val, mask);
+		ret = regmap_update_bits(led->iodev->regmap, reg, mask, val);
 		if (ret)
 			dev_err(led->iodev->dev,
 				"failed to update register(%d)\n", ret);
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 72d3808..ca57035 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -463,6 +463,7 @@ config MFD_MAX8997
 	bool "Maxim Semiconductor MAX8997/8966 PMIC Support"
 	depends on I2C=y
 	select MFD_CORE
+	select REGMAP_I2C
 	select IRQ_DOMAIN
 	help
 	  Say yes here to add support for Maxim Semiconductor MAX8997/8966.
diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
index 43fa614..0e7ff39 100644
--- a/drivers/mfd/max8997-irq.c
+++ b/drivers/mfd/max8997-irq.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
+#include <linux/regmap.h>
 
 static const u8 max8997_mask_reg[] = {
 	[PMIC_INT1] = MAX8997_REG_INT1MSK,
@@ -41,25 +42,6 @@ static const u8 max8997_mask_reg[] = {
 	[FLASH_STATUS] = MAX8997_REG_INVALID,
 };
 
-static struct i2c_client *get_i2c(struct max8997_dev *max8997,
-				enum max8997_irq_source src)
-{
-	switch (src) {
-	case PMIC_INT1 ... PMIC_INT4:
-		return max8997->i2c;
-	case FUEL_GAUGE:
-		return NULL;
-	case MUIC_INT1 ... MUIC_INT3:
-		return max8997->muic;
-	case GPIO_LOW ... GPIO_HI:
-		return max8997->i2c;
-	case FLASH_STATUS:
-		return max8997->i2c;
-	default:
-		return ERR_PTR(-EINVAL);
-	}
-}
-
 struct max8997_irq_data {
 	int mask;
 	enum max8997_irq_source group;
@@ -124,15 +106,20 @@ static void max8997_irq_sync_unlock(struct irq_data *data)
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
+		regmap_write(map, max8997_mask_reg[i],
 				max8997->irq_masks_cur[i]);
 	}
 
@@ -181,11 +168,11 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 {
 	struct max8997_dev *max8997 = data;
 	u8 irq_reg[MAX8997_IRQ_GROUP_NR] = {};
-	u8 irq_src;
+	unsigned int irq_src;
 	int ret;
 	int i, cur_irq;
 
-	ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
+	ret = regmap_read(max8997->regmap, MAX8997_REG_INTSRC, &irq_src);
 	if (ret < 0) {
 		dev_err(max8997->dev, "Failed to read interrupt source: %d\n",
 				ret);
@@ -194,8 +181,8 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 
 	if (irq_src & MAX8997_IRQSRC_PMIC) {
 		/* PMIC INT1 ~ INT4 */
-		max8997_bulk_read(max8997->i2c, MAX8997_REG_INT1, 4,
-				&irq_reg[PMIC_INT1]);
+		regmap_bulk_read(max8997->regmap, MAX8997_REG_INT1,
+				&irq_reg[PMIC_INT1], 4);
 	}
 	if (irq_src & MAX8997_IRQSRC_FUELGAUGE) {
 		/*
@@ -215,8 +202,8 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 	}
 	if (irq_src & MAX8997_IRQSRC_MUIC) {
 		/* MUIC INT1 ~ INT3 */
-		max8997_bulk_read(max8997->muic, MAX8997_MUIC_REG_INT1, 3,
-				&irq_reg[MUIC_INT1]);
+		regmap_bulk_read(max8997->regmap_muic, MAX8997_MUIC_REG_INT1,
+				&irq_reg[MUIC_INT1], 3);
 	}
 	if (irq_src & MAX8997_IRQSRC_GPIO) {
 		/* GPIO Interrupt */
@@ -225,8 +212,8 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 		irq_reg[GPIO_LOW] = 0;
 		irq_reg[GPIO_HI] = 0;
 
-		max8997_bulk_read(max8997->i2c, MAX8997_REG_GPIOCNTL1,
-				MAX8997_NUM_GPIO, gpio_info);
+		regmap_bulk_read(max8997->regmap, MAX8997_REG_GPIOCNTL1,
+				gpio_info, MAX8997_NUM_GPIO);
 		for (i = 0; i < MAX8997_NUM_GPIO; i++) {
 			bool interrupt = false;
 
@@ -260,8 +247,10 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 	}
 	if (irq_src & MAX8997_IRQSRC_FLASH) {
 		/* Flash Status Interrupt */
-		ret = max8997_read_reg(max8997->i2c, MAX8997_REG_FLASHSTATUS,
-				&irq_reg[FLASH_STATUS]);
+		unsigned int data;
+		ret = regmap_read(max8997->regmap,
+				MAX8997_REG_FLASHSTATUS, &data);
+		irq_reg[FLASH_STATUS] = data;
 	}
 
 	/* Apply masking */
@@ -312,7 +301,7 @@ int max8997_irq_init(struct max8997_dev *max8997)
 	struct irq_domain *domain;
 	int i;
 	int ret;
-	u8 val;
+	unsigned int val;
 
 	if (!max8997->irq) {
 		dev_warn(max8997->dev, "No interrupt specified.\n");
@@ -323,22 +312,19 @@ int max8997_irq_init(struct max8997_dev *max8997)
 
 	/* Mask individual interrupt sources */
 	for (i = 0; i < MAX8997_IRQ_GROUP_NR; i++) {
-		struct i2c_client *i2c;
-
 		max8997->irq_masks_cur[i] = 0xff;
 		max8997->irq_masks_cache[i] = 0xff;
-		i2c = get_i2c(max8997, i);
 
-		if (IS_ERR_OR_NULL(i2c))
+		if (IS_ERR_OR_NULL(max8997->regmap))
 			continue;
 		if (max8997_mask_reg[i] == MAX8997_REG_INVALID)
 			continue;
 
-		max8997_write_reg(i2c, max8997_mask_reg[i], 0xff);
+		regmap_write(max8997->regmap, max8997_mask_reg[i], 0xff);
 	}
 
 	for (i = 0; i < MAX8997_NUM_GPIO; i++) {
-		max8997->gpio_status[i] = (max8997_read_reg(max8997->i2c,
+		max8997->gpio_status[i] = (regmap_read(max8997->regmap,
 						MAX8997_REG_GPIOCNTL1 + i,
 						&val)
 					& MAX8997_GPIO_DATA_MASK) ?
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 595364e..c4a1072 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -33,6 +33,7 @@
 #include <linux/mfd/core.h>
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
+#include <linux/regmap.h>
 
 #define I2C_ADDR_PMIC	(0xCC >> 1)
 #define I2C_ADDR_MUIC	(0x4A >> 1)
@@ -57,81 +58,29 @@ static const struct of_device_id max8997_pmic_dt_match[] = {
 };
 #endif
 
-int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
-{
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
-	int ret;
-
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_read_byte_data(i2c, reg);
-	mutex_unlock(&max8997->iolock);
-	if (ret < 0)
-		return ret;
-
-	ret &= 0xff;
-	*dest = ret;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(max8997_read_reg);
-
-int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
-{
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
-	int ret;
-
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_read_i2c_block_data(i2c, reg, count, buf);
-	mutex_unlock(&max8997->iolock);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(max8997_bulk_read);
-
-int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
-{
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
-	int ret;
-
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_write_byte_data(i2c, reg, value);
-	mutex_unlock(&max8997->iolock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(max8997_write_reg);
-
-int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count, u8 *buf)
-{
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
-	int ret;
+static const struct regmap_config max8997_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_REG_PMIC_END,
+};
 
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_write_i2c_block_data(i2c, reg, count, buf);
-	mutex_unlock(&max8997->iolock);
-	if (ret < 0)
-		return ret;
+static const struct regmap_config max8997_regmap_rtc_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_RTC_REG_END,
+};
 
-	return 0;
-}
-EXPORT_SYMBOL_GPL(max8997_bulk_write);
+static const struct regmap_config max8997_regmap_haptic_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_HAPTIC_REG_END,
+};
 
-int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
-{
-	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
-	int ret;
-
-	mutex_lock(&max8997->iolock);
-	ret = i2c_smbus_read_byte_data(i2c, reg);
-	if (ret >= 0) {
-		u8 old_val = ret & 0xff;
-		u8 new_val = (val & mask) | (old_val & (~mask));
-		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
-	}
-	mutex_unlock(&max8997->iolock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(max8997_update_reg);
+static const struct regmap_config max8997_regmap_muic_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_MUIC_REG_END,
+};
 
 /*
  * Only the common platform data elements for max8997 are parsed here from the
@@ -230,6 +179,41 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	}
 	i2c_set_clientdata(max8997->muic, max8997);
 
+	max8997->regmap = devm_regmap_init_i2c(i2c, &max8997_regmap_config);
+	if (IS_ERR(max8997->regmap)) {
+		ret = PTR_ERR(max8997->regmap);
+		dev_err(max8997->dev,
+				"failed to allocate register map: %d\n", ret);
+		return ret;
+	}
+
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
@@ -254,6 +238,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 err_mfd:
 	mfd_remove_devices(max8997->dev);
+err_regmap:
 	i2c_unregister_device(max8997->muic);
 err_i2c_muic:
 	i2c_unregister_device(max8997->haptic);
@@ -441,15 +426,15 @@ static int max8997_freeze(struct device *dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
-		max8997_read_reg(i2c, max8997_dumpaddr_pmic[i],
+		regmap_read(max8997->regmap, max8997_dumpaddr_pmic[i],
 				&max8997->reg_dump[i]);
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
-		max8997_read_reg(i2c, max8997_dumpaddr_muic[i],
+		regmap_read(max8997->regmap_muic, max8997_dumpaddr_muic[i],
 				&max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
-		max8997_read_reg(i2c, max8997_dumpaddr_haptic[i],
+		regmap_read(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
 				&max8997->reg_dump[i + MAX8997_REG_PMIC_END +
 				MAX8997_MUIC_REG_END]);
 
@@ -463,15 +448,15 @@ static int max8997_restore(struct device *dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_pmic); i++)
-		max8997_write_reg(i2c, max8997_dumpaddr_pmic[i],
+		regmap_write(max8997->regmap, max8997_dumpaddr_pmic[i],
 				max8997->reg_dump[i]);
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
-		max8997_write_reg(i2c, max8997_dumpaddr_muic[i],
+		regmap_write(max8997->regmap_muic, max8997_dumpaddr_muic[i],
 				max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
 
 	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
-		max8997_write_reg(i2c, max8997_dumpaddr_haptic[i],
+		regmap_write(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
 				max8997->reg_dump[i + MAX8997_REG_PMIC_END +
 				MAX8997_MUIC_REG_END]);
 
diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index 4bdedfe..43d8481 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -26,6 +26,7 @@
 #include <linux/power_supply.h>
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
+#include <linux/regmap.h>
 
 struct charger_data {
 	struct device *dev;
@@ -46,14 +47,14 @@ static int max8997_battery_get_property(struct power_supply *psy,
 {
 	struct charger_data *charger = container_of(psy,
 			struct charger_data, battery);
-	struct i2c_client *i2c = charger->iodev->i2c;
 	int ret;
-	u8 reg;
+	unsigned int reg;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		val->intval = 0;
-		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		ret = regmap_read(charger->iodev->regmap,
+				MAX8997_REG_STATUS4, &reg);
 		if (ret)
 			return ret;
 		if ((reg & (1 << 0)) == 0x1)
@@ -62,7 +63,8 @@ static int max8997_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = 0;
-		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		ret = regmap_read(charger->iodev->regmap,
+				MAX8997_REG_STATUS4, &reg);
 		if (ret)
 			return ret;
 		if ((reg & (1 << 2)) == 0x0)
@@ -71,7 +73,8 @@ static int max8997_battery_get_property(struct power_supply *psy,
 		break;
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = 0;
-		ret = max8997_read_reg(i2c, MAX8997_REG_STATUS4, &reg);
+		ret = regmap_read(charger->iodev->regmap,
+				MAX8997_REG_STATUS4, &reg);
 		if (ret)
 			return ret;
 		/* DCINOK */
@@ -103,8 +106,8 @@ static int max8997_battery_probe(struct platform_device *pdev)
 		if (val > 0xf)
 			val = 0xf;
 
-		ret = max8997_update_reg(iodev->i2c,
-				MAX8997_REG_MBCCTRL5, val, 0xf);
+		ret = regmap_update_bits(iodev->regmap,
+				MAX8997_REG_MBCCTRL5, 0xf, val);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Cannot use i2c bus.\n");
 			return ret;
@@ -113,20 +116,20 @@ static int max8997_battery_probe(struct platform_device *pdev)
 
 	switch (pdata->timeout) {
 	case 5:
-		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
-				0x2 << 4, 0x7 << 4);
+		ret = regmap_update_bits(iodev->regmap,
+				MAX8997_REG_MBCCTRL1, 0x7 << 4, 0x2 << 4);
 		break;
 	case 6:
-		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
-				0x3 << 4, 0x7 << 4);
+		ret = regmap_update_bits(iodev->regmap,
+				MAX8997_REG_MBCCTRL1, 0x7 << 4, 0x3 << 4);
 		break;
 	case 7:
-		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
-				0x4 << 4, 0x7 << 4);
+		ret = regmap_update_bits(iodev->regmap,
+				MAX8997_REG_MBCCTRL1, 0x7 << 4, 0x4 << 4);
 		break;
 	case 0:
-		ret = max8997_update_reg(iodev->i2c, MAX8997_REG_MBCCTRL1,
-				0x7 << 4, 0x7 << 4);
+		ret = regmap_update_bits(iodev->regmap,
+				MAX8997_REG_MBCCTRL1, 0x7 << 4, 0x7 << 4);
 		break;
 	default:
 		dev_err(&pdev->dev, "incorrect timeout value (%d)\n",
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 9c31e21..faefd1c 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -33,6 +33,7 @@
 #include <linux/mfd/max8997.h>
 #include <linux/mfd/max8997-private.h>
 #include <linux/regulator/of_regulator.h>
+#include <linux/regmap.h>
 
 struct max8997_data {
 	struct device *dev;
@@ -50,7 +51,7 @@ struct max8997_data {
 	int buck125_gpioindex;
 	bool ignore_gpiodvs_side_effect;
 
-	u8 saved_states[MAX8997_REG_MAX];
+	unsigned int saved_states[MAX8997_REG_MAX];
 };
 
 static const unsigned int safeoutvolt[] = {
@@ -257,15 +258,14 @@ static int max8997_get_enable_register(struct regulator_dev *rdev,
 static int max8997_reg_is_enabled(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int ret, reg, mask, pattern;
-	u8 val;
+	unsigned int val;
 
 	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
 	if (ret)
 		return ret;
 
-	ret = max8997_read_reg(i2c, reg, &val);
+	ret = regmap_read(max8997->iodev->regmap, reg, &val);
 	if (ret)
 		return ret;
 
@@ -275,27 +275,25 @@ static int max8997_reg_is_enabled(struct regulator_dev *rdev)
 static int max8997_reg_enable(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int ret, reg, mask, pattern;
 
 	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
 	if (ret)
 		return ret;
 
-	return max8997_update_reg(i2c, reg, pattern, mask);
+	return regmap_update_bits(max8997->iodev->regmap, reg, mask, pattern);
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
+	return regmap_update_bits(max8997->iodev->regmap, reg, mask, ~pattern);
 }
 
 static int max8997_get_voltage_register(struct regulator_dev *rdev,
@@ -367,15 +365,14 @@ static int max8997_get_voltage_register(struct regulator_dev *rdev,
 static int max8997_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int reg, shift, mask, ret;
-	u8 val;
+	unsigned int val;
 
 	ret = max8997_get_voltage_register(rdev, &reg, &shift, &mask);
 	if (ret)
 		return ret;
 
-	ret = max8997_read_reg(i2c, reg, &val);
+	ret = regmap_read(max8997->iodev->regmap, reg, &val);
 	if (ret)
 		return ret;
 
@@ -412,7 +409,6 @@ static int max8997_set_voltage_charger_cv(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int rid = rdev_get_id(rdev);
 	int lb, ub;
 	int reg, shift = 0, mask, ret = 0;
@@ -454,7 +450,8 @@ static int max8997_set_voltage_charger_cv(struct regulator_dev *rdev,
 
 	*selector = val;
 
-	ret = max8997_update_reg(i2c, reg, val << shift, mask);
+	ret = regmap_update_bits(max8997->iodev->regmap,
+				reg, mask, val << shift);
 
 	return ret;
 }
@@ -467,7 +464,6 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	const struct voltage_map_desc *desc;
 	int rid = rdev_get_id(rdev);
 	int i, reg, shift, mask, ret;
@@ -499,7 +495,8 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	ret = max8997_update_reg(i2c, reg, i << shift, mask << shift);
+	ret = regmap_update_bits(max8997->iodev->regmap,
+				reg, mask << shift, i << shift);
 	*selector = i;
 
 	return ret;
@@ -709,7 +706,6 @@ static int max8997_set_voltage_safeout_sel(struct regulator_dev *rdev,
 					   unsigned selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int rid = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
 
@@ -720,13 +716,13 @@ static int max8997_set_voltage_safeout_sel(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	return max8997_update_reg(i2c, reg, selector << shift, mask << shift);
+	return regmap_update_bits(max8997->iodev->regmap,
+				reg, mask << shift, selector << shift);
 }
 
 static int max8997_reg_disable_suspend(struct regulator_dev *rdev)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	struct i2c_client *i2c = max8997->iodev->i2c;
 	int ret, reg, mask, pattern;
 	int rid = rdev_get_id(rdev);
 
@@ -734,20 +730,22 @@ static int max8997_reg_disable_suspend(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	max8997_read_reg(i2c, reg, &max8997->saved_states[rid]);
+	regmap_read(max8997->iodev->regmap,
+			reg, &max8997->saved_states[rid]);
 
 	if (rid == MAX8997_LDO1 ||
 			rid == MAX8997_LDO10 ||
 			rid == MAX8997_LDO21) {
 		dev_dbg(&rdev->dev, "Conditional Power-Off for %s\n",
 				rdev->desc->name);
-		return max8997_update_reg(i2c, reg, 0x40, mask);
+		return regmap_update_bits(max8997->iodev->regmap,
+				reg, mask, 0x40);
 	}
 
 	dev_dbg(&rdev->dev, "Full Power-Off for %s (%xh -> %xh)\n",
 			rdev->desc->name, max8997->saved_states[rid] & mask,
 			(~pattern) & mask);
-	return max8997_update_reg(i2c, reg, ~pattern, mask);
+	return regmap_update_bits(max8997->iodev->regmap, reg, mask, ~pattern);
 }
 
 static struct regulator_ops max8997_ldo_ops = {
@@ -1030,7 +1028,6 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
 	struct max8997_data *max8997;
-	struct i2c_client *i2c;
 	int i, ret, nr_dvs;
 	u8 max_buck1 = 0, max_buck2 = 0, max_buck5 = 0;
 
@@ -1054,7 +1051,6 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	max8997->iodev = iodev;
 	max8997->num_regulators = pdata->num_regulators;
 	platform_set_drvdata(pdev, max8997);
-	i2c = max8997->iodev->i2c;
 
 	max8997->buck125_gpioindex = pdata->buck125_default_idx;
 	max8997->buck1_gpiodvs = pdata->buck1_gpiodvs;
@@ -1104,25 +1100,25 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 
 	/* For the safety, set max voltage before setting up */
 	for (i = 0; i < 8; i++) {
-		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS1 + i,
-				max_buck1, 0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS1 + i,
-				max_buck2, 0x3f);
-		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS1 + i,
-				max_buck5, 0x3f);
+		regmap_update_bits(max8997->iodev->regmap,
+				MAX8997_REG_BUCK1DVS1 + i, 0x3f, max_buck1);
+		regmap_update_bits(max8997->iodev->regmap,
+				MAX8997_REG_BUCK2DVS1 + i, 0x3f, max_buck2);
+		regmap_update_bits(max8997->iodev->regmap,
+				MAX8997_REG_BUCK5DVS1 + i, 0x3f, max_buck5);
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
+		regmap_update_bits(max8997->iodev->regmap,
+				MAX8997_REG_BUCK1DVS1 + i,
+				0x3f, max8997->buck1_vol[i]);
+		regmap_update_bits(max8997->iodev->regmap,
+				MAX8997_REG_BUCK2DVS1 + i,
+				0x3f, max8997->buck2_vol[i]);
+		regmap_update_bits(max8997->iodev->regmap,
+				MAX8997_REG_BUCK5DVS1 + i,
+				0x3f, max8997->buck5_vol[i]);
 	}
 
 	/*
@@ -1166,16 +1162,17 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	}
 
 	/* DVS-GPIO disabled */
-	max8997_update_reg(i2c, MAX8997_REG_BUCK1CTRL, (pdata->buck1_gpiodvs) ?
-			(1 << 1) : (0 << 1), 1 << 1);
-	max8997_update_reg(i2c, MAX8997_REG_BUCK2CTRL, (pdata->buck2_gpiodvs) ?
-			(1 << 1) : (0 << 1), 1 << 1);
-	max8997_update_reg(i2c, MAX8997_REG_BUCK5CTRL, (pdata->buck5_gpiodvs) ?
-			(1 << 1) : (0 << 1), 1 << 1);
+	regmap_update_bits(max8997->iodev->regmap, MAX8997_REG_BUCK1CTRL,
+			1 << 1, (pdata->buck1_gpiodvs) ? (1 << 1) : (0 << 1));
+	regmap_update_bits(max8997->iodev->regmap, MAX8997_REG_BUCK2CTRL,
+			1 << 1, (pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1));
+	regmap_update_bits(max8997->iodev->regmap, MAX8997_REG_BUCK5CTRL,
+			1 << 1, (pdata->buck5_gpiodvs) ? (1 << 1) : (0 << 1));
 
 	/* Misc Settings */
 	max8997->ramp_delay = 10; /* set 10mV/us, which is the default */
-	max8997_write_reg(i2c, MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
+	regmap_write(max8997->iodev->regmap,
+			MAX8997_REG_BUCKRAMP, (0xf << 4) | 0x9);
 
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct voltage_map_desc *desc;
diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index 0777c01..b866f7d5 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/max8997-private.h>
 #include <linux/irqdomain.h>
+#include <linux/regmap.h>
 
 /* Module parameter for WTSR function control */
 static int wtsr_en = 1;
@@ -68,7 +69,6 @@ enum {
 struct max8997_rtc_info {
 	struct device		*dev;
 	struct max8997_dev	*max8997;
-	struct i2c_client	*rtc;
 	struct rtc_device	*rtc_dev;
 	struct mutex		lock;
 	int virq;
@@ -118,8 +118,8 @@ static inline int max8997_rtc_set_update_reg(struct max8997_rtc_info *info)
 {
 	int ret;
 
-	ret = max8997_write_reg(info->rtc, MAX8997_RTC_UPDATE1,
-						RTC_UDR_MASK);
+	ret = regmap_write(info->max8997->regmap_rtc,
+				MAX8997_RTC_UPDATE1, RTC_UDR_MASK);
 	if (ret < 0)
 		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
 				__func__, ret);
@@ -140,7 +140,8 @@ static int max8997_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	int ret;
 
 	mutex_lock(&info->lock);
-	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_SEC, RTC_NR_TIME, data);
+	ret = regmap_bulk_read(info->max8997->regmap_rtc,
+				MAX8997_RTC_SEC, data, RTC_NR_TIME);
 	mutex_unlock(&info->lock);
 
 	if (ret < 0) {
@@ -166,7 +167,8 @@ static int max8997_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	mutex_lock(&info->lock);
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_SEC, RTC_NR_TIME, data);
+	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+				MAX8997_RTC_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write time reg(%d)\n", __func__,
 				ret);
@@ -183,13 +185,13 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct max8997_rtc_info *info = dev_get_drvdata(dev);
 	u8 data[RTC_NR_TIME];
-	u8 val;
+	unsigned int val;
 	int i, ret;
 
 	mutex_lock(&info->lock);
 
-	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-			data);
+	ret = regmap_bulk_read(info->max8997->regmap_rtc,
+				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s:%d fail to read alarm reg(%d)\n",
 				__func__, __LINE__, ret);
@@ -207,7 +209,8 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	}
 
 	alrm->pending = 0;
-	ret = max8997_read_reg(info->max8997->i2c, MAX8997_REG_STATUS1, &val);
+	ret = regmap_read(info->max8997->regmap_rtc,
+			       MAX8997_REG_STATUS1, &val);
 	if (ret < 0) {
 		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
 				__func__, __LINE__, ret);
@@ -230,8 +233,8 @@ static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
 	if (!mutex_is_locked(&info->lock))
 		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
 
-	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				data);
+	ret = regmap_bulk_read(info->max8997->regmap_rtc,
+				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
 				__func__, ret);
@@ -241,8 +244,8 @@ static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
 	for (i = 0; i < RTC_NR_TIME; i++)
 		data[i] &= ~ALARM_ENABLE_MASK;
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				 data);
+	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
 				__func__, ret);
@@ -262,8 +265,8 @@ static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
 	if (!mutex_is_locked(&info->lock))
 		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
 
-	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				data);
+	ret = regmap_bulk_read(info->max8997->regmap_rtc,
+				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
 				__func__, ret);
@@ -281,8 +284,8 @@ static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
 	if (data[RTC_DATE] & 0x1f)
 		data[RTC_DATE] |= (1 << ALARM_ENABLE_SHIFT);
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				 data);
+	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
 				__func__, ret);
@@ -313,8 +316,8 @@ static int max8997_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret < 0)
 		goto out;
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
-				data);
+	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
 				__func__, ret);
@@ -385,7 +388,8 @@ static void max8997_rtc_enable_wtsr(struct max8997_rtc_info *info, bool enable)
 	dev_info(info->dev, "%s: %s WTSR\n", __func__,
 			enable ? "enable" : "disable");
 
-	ret = max8997_update_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, val, mask);
+	ret = regmap_update_bits(info->max8997->regmap_rtc,
+				 MAX8997_RTC_WTSR_SMPL, mask, val);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
 				__func__, ret);
@@ -398,7 +402,7 @@ static void max8997_rtc_enable_wtsr(struct max8997_rtc_info *info, bool enable)
 static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
 {
 	int ret;
-	u8 val, mask;
+	unsigned int val, mask;
 
 	if (!smpl_en)
 		return;
@@ -413,7 +417,8 @@ static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
 	dev_info(info->dev, "%s: %s SMPL\n", __func__,
 			enable ? "enable" : "disable");
 
-	ret = max8997_update_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, val, mask);
+	ret = regmap_update_bits(info->max8997->regmap_rtc,
+				 MAX8997_RTC_WTSR_SMPL, mask, val);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
 				__func__, ret);
@@ -423,7 +428,8 @@ static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
 	max8997_rtc_set_update_reg(info);
 
 	val = 0;
-	max8997_read_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, &val);
+	regmap_read(info->max8997->regmap_rtc,
+			 MAX8997_RTC_WTSR_SMPL, &val);
 	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
 }
 
@@ -438,7 +444,8 @@ static int max8997_rtc_init_reg(struct max8997_rtc_info *info)
 
 	info->rtc_24hr_mode = 1;
 
-	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_CTRLMASK, 2, data);
+	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+				 MAX8997_RTC_CTRLMASK, data, 2);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
 				__func__, ret);
@@ -463,7 +470,6 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 	mutex_init(&info->lock);
 	info->dev = &pdev->dev;
 	info->max8997 = max8997;
-	info->rtc = max8997->rtc;
 
 	platform_set_drvdata(pdev, info);
 
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index 78c76cd..ea80ef8 100644
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
 	unsigned long type;
 	struct platform_device *battery; /* battery control (not fuel gauge) */
 
+	struct regmap *regmap;
+	struct regmap *regmap_rtc;
+	struct regmap *regmap_haptic;
+	struct regmap *regmap_muic;
+
 	int irq;
 	int ono;
 	struct irq_domain *irq_domain;
@@ -398,7 +405,7 @@ struct max8997_dev {
 	int irq_masks_cache[MAX8997_IRQ_GROUP_NR];
 
 	/* For hibernation */
-	u8 reg_dump[MAX8997_REG_PMIC_END + MAX8997_MUIC_REG_END +
+	unsigned int reg_dump[MAX8997_REG_PMIC_END + MAX8997_MUIC_REG_END +
 		MAX8997_HAPTIC_REG_END];
 
 	bool gpio_status[MAX8997_NUM_GPIO];
@@ -413,14 +420,6 @@ extern int max8997_irq_init(struct max8997_dev *max8997);
 extern void max8997_irq_exit(struct max8997_dev *max8997);
 extern int max8997_irq_resume(struct max8997_dev *max8997);
 
-extern int max8997_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
-extern int max8997_bulk_read(struct i2c_client *i2c, u8 reg, int count,
-				u8 *buf);
-extern int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
-extern int max8997_bulk_write(struct i2c_client *i2c, u8 reg, int count,
-				u8 *buf);
-extern int max8997_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
-
 #define MAX8997_GPIO_INT_BOTH	(0x3 << 4)
 #define MAX8997_GPIO_INT_RISE	(0x2 << 4)
 #define MAX8997_GPIO_INT_FALL	(0x1 << 4)
-- 
1.9.1

