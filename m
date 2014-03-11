Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbaCKN7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:59:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47081 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbaCKN7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:59:09 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-ab-531f16abfc63
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
Subject: [PATCH 3/3] mfd: max8997: move regmap handling to function drivers
Date: Tue, 11 Mar 2014 14:58:24 +0100
Message-id: <1394546304-15191-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394546304-15191-1-git-send-email-r.baldyga@samsung.com>
References: <1394546304-15191-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9jQd3VYvLBBmsnaVosuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi9cvDC3ufz3KaPHtSgeTxc1P31gtLu+aw2ax
	9c06Rou1R+6yW9xuXMFmcW3vcWaLB4d3slvs3vWU1WJ/ZwejxeluVgcRj52z7rJ77Jl4ks1j
	8wotj02rOtk87lzbw+Yx72Sgx575P1g9+rasYvSYPu8nk8fnTXIe67dsZQrgjuKySUnNySxL
	LdK3S+DKWLP2BmPBkW+MFRvXbmVrYJx+mrGLkZNDQsBEYs/k30wQtpjEhXvr2boYuTiEBKYz
	Spz98p8Vwmlnkrh35QUrSBWbgI7Elu8TwLpFBPQlPuy4ygxSxCxwk1lizpl+sISwgLfE/H2P
	wBpYBFQlPkzdAxbnFXCVeHTrE1CcA2idgsScSTYgYU4BN4nrcyezgNhCQCVzj71in8DIu4CR
	YRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEQ8k97BuKrB4hCjAAejEg/vCn+5YCHWxLLi
	ytxDjBIczEoivH9F5YOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2C
	yTJxcEo1MAZccrRQFtgsX3BxeSHXwyXSwWyW/mb177/VTmEJnp7EV8RdueHAFE/DaW3MX9U4
	flxYoF3d+K3mx9RDat//BjyJFN4/IaraM0DYVXO93enonc99+D/naDgWx92rZF0ooPi//vGT
	OXebHzb8zPiueqdv9zofm6+uL16JLAlv5b4p/6Yxq/NTqxJLcUaioRZzUXEiAEBkCPCEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves code creating new i2c clients and regmaps to function
drivers which uses them. It allow to avoid creating this instances when
intividual function drivers are not enabled.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max8997.c     |  118 +++++++++++++++++++++++++++--
 drivers/input/misc/max8997_haptic.c |  113 ++++++++++++++++++++++-----
 drivers/mfd/max8997.c               |  143 -----------------------------------
 drivers/rtc/rtc-max8997.c           |   74 ++++++++++++------
 include/linux/mfd/max8997-private.h |   14 ++--
 5 files changed, 262 insertions(+), 200 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 5948061..a71581a 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -118,6 +118,9 @@ enum max8997_muic_charger_type {
 struct max8997_muic_info {
 	struct device *dev;
 	struct max8997_dev *max8997;
+	struct i2c_client *i2c;
+	struct regmap *regmap;
+	struct regmap_irq_chip_data *irq_data;
 	struct extcon_dev *edev;
 	int prev_cable_type;
 	int prev_chg_type;
@@ -144,6 +147,39 @@ struct max8997_muic_info {
 	 */
 	int path_usb;
 	int path_uart;
+
+	unsigned int reg_dump[MAX8997_MUIC_REG_END];
+};
+
+static const struct regmap_config max8997_muic_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_MUIC_REG_END,
+};
+
+static const struct regmap_irq max8997_irqs_muic[] = {
+	/* MUIC_INT1 interrupts */
+	{ .reg_offset = 0, .mask = MUIC_INT1_ADC_MASK, },
+	{ .reg_offset = 0, .mask = MUIC_INT1_ADCLow_MASK, },
+	{ .reg_offset = 0, .mask = MUIC_INT1_ADCError_MASK, },
+	/* MUIC_INT2 interrupts */
+	{ .reg_offset = 1, .mask = MUIC_INT2_ChgTyp_MASK, },
+	{ .reg_offset = 1, .mask = MUIC_INT2_ChgDetRun_MASK, },
+	{ .reg_offset = 1, .mask = MUIC_INT2_DCDTmr_MASK, },
+	{ .reg_offset = 1, .mask = MUIC_INT2_DBChg_MASK, },
+	{ .reg_offset = 1, .mask = MUIC_INT2_VBVolt_MASK, },
+	/* MUIC_INT3 interrupts */
+	{ .reg_offset = 2, .mask = MUIC_INT3_OVP_MASK, },
+};
+
+static const struct regmap_irq_chip max8997_muic_irq_chip = {
+	.name                   = "max8997-muic",
+	.status_base            = MAX8997_MUIC_REG_INT1,
+	.mask_base              = MAX8997_MUIC_REG_INTMASK1,
+	.mask_invert            = true,
+	.num_regs               = 3,
+	.irqs                   = max8997_irqs_muic,
+	.num_irqs               = ARRAY_SIZE(max8997_irqs_muic),
 };
 
 enum {
@@ -191,7 +227,7 @@ static int max8997_muic_set_debounce_time(struct max8997_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = regmap_update_bits(info->max8997->regmap_muic,
+		ret = regmap_update_bits(info->regmap,
 					  MAX8997_MUIC_REG_CONTROL3,
 					  CONTROL3_ADCDBSET_MASK,
 					  time << CONTROL3_ADCDBSET_SHIFT);
@@ -229,7 +265,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 	else
 		ctrl1 = CONTROL1_SW_OPEN;
 
-	ret = regmap_update_bits(info->max8997->regmap_muic,
+	ret = regmap_update_bits(info->regmap,
 			MAX8997_MUIC_REG_CONTROL1, COMP_SW_MASK, ctrl1);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
@@ -241,7 +277,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
 	else
 		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
 
-	ret = regmap_update_bits(info->max8997->regmap_muic,
+	ret = regmap_update_bits(info->regmap,
 			MAX8997_MUIC_REG_CONTROL2,
 			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK, ctrl2);
 	if (ret < 0) {
@@ -544,7 +580,7 @@ static void max8997_muic_irq_work(struct work_struct *work)
 		if (info->irq == muic_irqs[i].virq)
 			irq_type = muic_irqs[i].irq;
 
-	ret = regmap_bulk_read(info->max8997->regmap_muic,
+	ret = regmap_bulk_read(info->regmap,
 				MAX8997_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read muic register\n");
@@ -606,7 +642,7 @@ static int max8997_muic_detect_dev(struct max8997_muic_info *info)
 	mutex_lock(&info->mutex);
 
 	/* Read STATUSx register to detect accessory */
-	ret = regmap_bulk_read(info->max8997->regmap_muic,
+	ret = regmap_bulk_read(info->regmap,
 			MAX8997_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
@@ -670,6 +706,27 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 	info->max8997 = max8997;
 
+	info->i2c = i2c_new_dummy(max8997->i2c->adapter, MAX8997_I2C_ADDR_MUIC);
+
+	info->regmap = devm_regmap_init_i2c(info->i2c,
+			&max8997_muic_regmap_config);
+	if (IS_ERR(info->regmap)) {
+		ret = PTR_ERR(info->regmap);
+		dev_err(info->dev,
+			"failed to allocate register map: %d\n", ret);
+		goto err_regmap;
+	}
+
+	ret = regmap_add_irq_chip(info->regmap, max8997->irq,
+				IRQF_ONESHOT | IRQF_SHARED |
+				IRQF_TRIGGER_FALLING, 0,
+				&max8997_muic_irq_chip,
+				&info->irq_data);
+	if (ret) {
+		dev_err(info->dev, "failed to add irq chip: %d\n", ret);
+		goto err_regmap;
+	}
+
 	platform_set_drvdata(pdev, info);
 	mutex_init(&info->mutex);
 
@@ -679,8 +736,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		struct max8997_muic_irq *muic_irq = &muic_irqs[i];
 		unsigned int virq = 0;
 
-		virq = regmap_irq_get_virq(max8997->irq_data_muic,
-					muic_irq->irq);
+		virq = regmap_irq_get_virq(info->irq_data, muic_irq->irq);
 		if (!virq) {
 			ret = -EINVAL;
 			goto err_irq;
@@ -723,7 +779,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 
 		/* Initialize registers according to platform data */
 		for (i = 0; i < muic_pdata->num_init_data; i++) {
-			regmap_write(info->max8997->regmap_muic,
+			regmap_write(info->regmap,
 					muic_pdata->init_data[i].addr,
 					muic_pdata->init_data[i].data);
 		}
@@ -779,6 +835,8 @@ static int max8997_muic_probe(struct platform_device *pdev)
 err_irq:
 	while (--i >= 0)
 		free_irq(muic_irqs[i].virq, info);
+err_regmap:
+	i2c_unregister_device(info->i2c);
 	return ret;
 }
 
@@ -796,10 +854,54 @@ static int max8997_muic_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static u8 max8997_muic_dumpaddr[] = {
+	MAX8997_MUIC_REG_INTMASK1,
+	MAX8997_MUIC_REG_INTMASK2,
+	MAX8997_MUIC_REG_INTMASK3,
+	MAX8997_MUIC_REG_CDETCTRL,
+	MAX8997_MUIC_REG_CONTROL1,
+	MAX8997_MUIC_REG_CONTROL2,
+	MAX8997_MUIC_REG_CONTROL3,
+};
+
+static int max8997_muic_freeze(struct device *dev)
+{
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+	struct max8997_muic_info *info = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8997_muic_dumpaddr); i++)
+		regmap_read(info->regmap, max8997_muic_dumpaddr[i],
+				&info->reg_dump[i]);
+
+	return 0;
+}
+
+static int max8997_muic_restore(struct device *dev)
+{
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+	struct max8997_muic_info *info = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8997_muic_dumpaddr); i++)
+		regmap_write(info->regmap, max8997_muic_dumpaddr[i],
+				info->reg_dump[i]);
+
+	return 0;
+}
+
+static const struct dev_pm_ops max8997_muic_pm = {
+	.freeze = max8997_muic_freeze,
+	.restore = max8997_muic_restore,
+};
+
 static struct platform_driver max8997_muic_driver = {
 	.driver		= {
 		.name	= DEV_NAME,
 		.owner	= THIS_MODULE,
+		.pm	= &max8997_muic_pm,
 	},
 	.probe		= max8997_muic_probe,
 	.remove		= max8997_muic_remove,
diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
index d3f7079..abb44f3 100644
--- a/drivers/input/misc/max8997_haptic.c
+++ b/drivers/input/misc/max8997_haptic.c
@@ -47,6 +47,8 @@
 struct max8997_haptic {
 	struct device *dev;
 	struct max8997_dev *max8997;
+	struct i2c_client *i2c;
+	struct regmap *regmap;
 	struct input_dev *input_dev;
 	struct regulator *regulator;
 
@@ -66,6 +68,14 @@ struct max8997_haptic {
 	unsigned int internal_mode_pattern;
 	unsigned int pattern_cycle;
 	unsigned int pattern_signal_period;
+
+	unsigned int reg_dump[MAX8997_HAPTIC_REG_END];
+};
+
+static const struct regmap_config max8997_haptic_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_HAPTIC_REG_END,
 };
 
 static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
@@ -87,19 +97,19 @@ static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
 		}
 		switch (chip->internal_mode_pattern) {
 		case 0:
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_SIGPWMDC1, duty_index);
 			break;
 		case 1:
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_SIGPWMDC2, duty_index);
 			break;
 		case 2:
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_SIGPWMDC3, duty_index);
 			break;
 		case 3:
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_SIGPWMDC4, duty_index);
 			break;
 		default:
@@ -116,51 +126,49 @@ static void max8997_haptic_configure(struct max8997_haptic *chip)
 	value = chip->type << MAX8997_MOTOR_TYPE_SHIFT |
 		chip->enabled << MAX8997_ENABLE_SHIFT |
 		chip->mode << MAX8997_MODE_SHIFT | chip->pwm_divisor;
-	regmap_write(chip->max8997->regmap_haptic,
-		MAX8997_HAPTIC_REG_CONF2, value);
+	regmap_write(chip->regmap, MAX8997_HAPTIC_REG_CONF2, value);
 
 	if (chip->mode == MAX8997_INTERNAL_MODE && chip->enabled) {
 		value = chip->internal_mode_pattern << MAX8997_CYCLE_SHIFT |
 			chip->internal_mode_pattern << MAX8997_SIG_PERIOD_SHIFT |
 			chip->internal_mode_pattern << MAX8997_SIG_DUTY_SHIFT |
 			chip->internal_mode_pattern << MAX8997_PWM_DUTY_SHIFT;
-		regmap_write(chip->max8997->regmap_haptic,
-			MAX8997_HAPTIC_REG_DRVCONF, value);
+		regmap_write(chip->regmap, MAX8997_HAPTIC_REG_DRVCONF, value);
 
 		switch (chip->internal_mode_pattern) {
 		case 0:
 			value = chip->pattern_cycle << 4;
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_CYCLECONF1, value);
 			value = chip->pattern_signal_period;
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_SIGCONF1, value);
 			break;
 
 		case 1:
 			value = chip->pattern_cycle;
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_CYCLECONF1, value);
 			value = chip->pattern_signal_period;
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_SIGCONF2, value);
 			break;
 
 		case 2:
 			value = chip->pattern_cycle << 4;
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_CYCLECONF2, value);
 			value = chip->pattern_signal_period;
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_SIGCONF3, value);
 			break;
 
 		case 3:
 			value = chip->pattern_cycle;
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_CYCLECONF2, value);
 			value = chip->pattern_signal_period;
-			regmap_write(chip->max8997->regmap_haptic,
+			regmap_write(chip->regmap,
 				MAX8997_HAPTIC_REG_SIGCONF4, value);
 			break;
 
@@ -277,6 +285,17 @@ static int max8997_haptic_probe(struct platform_device *pdev)
 	chip->mode = haptic_pdata->mode;
 	chip->pwm_divisor = haptic_pdata->pwm_divisor;
 
+	chip->i2c = i2c_new_dummy(iodev->i2c->adapter, MAX8997_I2C_ADDR_HAPTIC);
+
+	chip->regmap = devm_regmap_init_i2c(chip->i2c,
+			&max8997_haptic_regmap_config);
+	if (IS_ERR(chip->regmap)) {
+		error = PTR_ERR(chip->regmap);
+		dev_err(chip->dev,
+			"failed to allocate register map: %d\n", error);
+		goto err_free_i2c;
+	}
+
 	switch (chip->mode) {
 	case MAX8997_INTERNAL_MODE:
 		chip->internal_mode_pattern =
@@ -294,7 +313,7 @@ static int max8997_haptic_probe(struct platform_device *pdev)
 			dev_err(&pdev->dev,
 				"unable to request PWM for haptic, error: %d\n",
 				error);
-			goto err_free_mem;
+			goto err_free_i2c;
 		}
 		break;
 
@@ -302,7 +321,7 @@ static int max8997_haptic_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev,
 			"Invalid chip mode specified (%d)\n", chip->mode);
 		error = -EINVAL;
-		goto err_free_mem;
+		goto err_free_i2c;
 	}
 
 	chip->regulator = regulator_get(&pdev->dev, "inmotor");
@@ -348,6 +367,8 @@ err_put_regulator:
 err_free_pwm:
 	if (chip->mode == MAX8997_EXTERNAL_MODE)
 		pwm_free(chip->pwm);
+err_free_i2c:
+	i2c_unregister_device(chip->i2c);
 err_free_mem:
 	input_free_device(input_dev);
 	kfree(chip);
@@ -370,6 +391,24 @@ static int max8997_haptic_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static u8 max8997_haptic_dumpaddr[] = {
+	MAX8997_HAPTIC_REG_CONF1,
+	MAX8997_HAPTIC_REG_CONF2,
+	MAX8997_HAPTIC_REG_DRVCONF,
+	MAX8997_HAPTIC_REG_CYCLECONF1,
+	MAX8997_HAPTIC_REG_CYCLECONF2,
+	MAX8997_HAPTIC_REG_SIGCONF1,
+	MAX8997_HAPTIC_REG_SIGCONF2,
+	MAX8997_HAPTIC_REG_SIGCONF3,
+	MAX8997_HAPTIC_REG_SIGCONF4,
+	MAX8997_HAPTIC_REG_SIGDC1,
+	MAX8997_HAPTIC_REG_SIGDC2,
+	MAX8997_HAPTIC_REG_SIGPWMDC1,
+	MAX8997_HAPTIC_REG_SIGPWMDC2,
+	MAX8997_HAPTIC_REG_SIGPWMDC3,
+	MAX8997_HAPTIC_REG_SIGPWMDC4,
+};
+
 #ifdef CONFIG_PM_SLEEP
 static int max8997_haptic_suspend(struct device *dev)
 {
@@ -382,7 +421,41 @@ static int max8997_haptic_suspend(struct device *dev)
 }
 #endif
 
-static SIMPLE_DEV_PM_OPS(max8997_haptic_pm_ops, max8997_haptic_suspend, NULL);
+static int max8997_haptic_freeze(struct device *dev)
+{
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+	struct max8997_haptic *chip = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8997_haptic_dumpaddr); i++)
+		regmap_read(chip->regmap, max8997_haptic_dumpaddr[i],
+				&chip->reg_dump[i]);
+
+	return 0;
+}
+
+static int max8997_haptic_restore(struct device *dev)
+{
+	struct platform_device *pdev =
+		container_of(dev, struct platform_device, dev);
+	struct max8997_haptic *chip = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(max8997_haptic_dumpaddr); i++)
+		regmap_write(chip->regmap, max8997_haptic_dumpaddr[i],
+				chip->reg_dump[i]);
+
+	return 0;
+}
+
+static const struct dev_pm_ops max8997_haptic_pm = {
+#ifdef CONFIG_PM_SLEEP
+	.suspend = max8997_haptic_suspend,
+#endif
+	.freeze = max8997_haptic_freeze,
+	.restore = max8997_haptic_restore,
+};
 
 static const struct platform_device_id max8997_haptic_id[] = {
 	{ "max8997-haptic", 0 },
@@ -394,7 +467,7 @@ static struct platform_driver max8997_haptic_driver = {
 	.driver	= {
 		.name	= "max8997-haptic",
 		.owner	= THIS_MODULE,
-		.pm	= &max8997_haptic_pm_ops,
+		.pm	= &max8997_haptic_pm,
 	},
 	.probe		= max8997_haptic_probe,
 	.remove		= max8997_haptic_remove,
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 9b6edfa..d36066d 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -35,12 +35,6 @@
 #include <linux/mfd/max8997-private.h>
 #include <linux/regmap.h>
 
-#define I2C_ADDR_PMIC	(0xCC >> 1)
-#define I2C_ADDR_MUIC	(0x4A >> 1)
-#define I2C_ADDR_BATTERY	(0x6C >> 1)
-#define I2C_ADDR_RTC	(0x0C >> 1)
-#define I2C_ADDR_HAPTIC	(0x90 >> 1)
-
 static const struct mfd_cell max8997_devs[] = {
 	{ .name = "max8997-pmic", },
 	{ .name = "max8997-rtc", },
@@ -107,48 +101,6 @@ static const struct regmap_irq_chip max8997_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max8997_irqs),
 };
 
-static const struct regmap_config max8997_regmap_rtc_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-	.max_register = MAX8997_RTC_REG_END,
-};
-
-static const struct regmap_config max8997_regmap_haptic_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-	.max_register = MAX8997_HAPTIC_REG_END,
-};
-
-static const struct regmap_config max8997_regmap_muic_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-	.max_register = MAX8997_MUIC_REG_END,
-};
-
-static const struct regmap_irq max8997_irqs_muic[] = {
-	/* MUIC_INT1 interrupts */
-	{ .reg_offset = 0, .mask = MUIC_INT1_ADC_MASK, },
-	{ .reg_offset = 0, .mask = MUIC_INT1_ADCLow_MASK, },
-	{ .reg_offset = 0, .mask = MUIC_INT1_ADCError_MASK, },
-	/* MUIC_INT2 interrupts */
-	{ .reg_offset = 1, .mask = MUIC_INT2_ChgTyp_MASK, },
-	{ .reg_offset = 1, .mask = MUIC_INT2_ChgDetRun_MASK, },
-	{ .reg_offset = 1, .mask = MUIC_INT2_DCDTmr_MASK, },
-	{ .reg_offset = 1, .mask = MUIC_INT2_DBChg_MASK, },
-	{ .reg_offset = 1, .mask = MUIC_INT2_VBVolt_MASK, },
-	/* MUIC_INT3 interrupts */
-	{ .reg_offset = 2, .mask = MUIC_INT3_OVP_MASK, },
-};
-
-static const struct regmap_irq_chip max8997_irq_chip_muic = {
-	.name			= "max8997-muic",
-	.status_base		= MAX8997_MUIC_REG_INT1,
-	.mask_base		= MAX8997_MUIC_REG_INTMASK1,
-	.mask_invert		= true,
-	.num_regs		= 3,
-	.irqs			= max8997_irqs_muic,
-	.num_irqs		= ARRAY_SIZE(max8997_irqs_muic),
-};
 
 /*
  * Only the common platform data elements for max8997 are parsed here from the
@@ -224,15 +176,6 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 	mutex_init(&max8997->iolock);
 
-	max8997->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
-	i2c_set_clientdata(max8997->rtc, max8997);
-
-	max8997->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
-	i2c_set_clientdata(max8997->haptic, max8997);
-
-	max8997->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
-	i2c_set_clientdata(max8997->muic, max8997);
-
 	max8997->regmap = devm_regmap_init_i2c(i2c, &max8997_regmap_config);
 	if (IS_ERR(max8997->regmap)) {
 		ret = PTR_ERR(max8997->regmap);
@@ -250,43 +193,10 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	max8997->regmap_rtc = devm_regmap_init_i2c(max8997->rtc,
-					&max8997_regmap_rtc_config);
-	if (IS_ERR(max8997->regmap_rtc)) {
-		ret = PTR_ERR(max8997->regmap_rtc);
-		dev_err(max8997->dev,
-				"failed to allocate register map: %d\n", ret);
-		goto err_regmap;
-	}
-
-	max8997->regmap_haptic = devm_regmap_init_i2c(max8997->haptic,
-					&max8997_regmap_haptic_config);
-	if (IS_ERR(max8997->regmap_haptic)) {
-		ret = PTR_ERR(max8997->regmap_haptic);
-		dev_err(max8997->dev,
-				"failed to allocate register map: %d\n", ret);
-		goto err_regmap;
-	}
-
-	max8997->regmap_muic = devm_regmap_init_i2c(max8997->muic,
-					&max8997_regmap_muic_config);
-	if (IS_ERR(max8997->regmap_muic)) {
-		ret = PTR_ERR(max8997->regmap_muic);
-		dev_err(max8997->dev,
-				"failed to allocate register map: %d\n", ret);
-		goto err_regmap;
-	}
-
-	ret = regmap_add_irq_chip(max8997->regmap_muic, max8997->irq,
-				IRQF_ONESHOT | IRQF_SHARED |
-				IRQF_TRIGGER_FALLING, 0,
-				&max8997_irq_chip_muic,
-				&max8997->irq_data_muic);
 	if (ret) {
 		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
 		return ret;
 	}
-
 	pm_runtime_set_active(max8997->dev);
 
 	ret = mfd_add_devices(max8997->dev, -1, max8997_devs,
@@ -309,10 +219,6 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 
 err_mfd:
 	mfd_remove_devices(max8997->dev);
-err_regmap:
-	i2c_unregister_device(max8997->muic);
-	i2c_unregister_device(max8997->haptic);
-	i2c_unregister_device(max8997->rtc);
 	return ret;
 }
 
@@ -321,9 +227,6 @@ static int max8997_i2c_remove(struct i2c_client *i2c)
 	struct max8997_dev *max8997 = i2c_get_clientdata(i2c);
 
 	mfd_remove_devices(max8997->dev);
-	i2c_unregister_device(max8997->muic);
-	i2c_unregister_device(max8997->haptic);
-	i2c_unregister_device(max8997->rtc);
 
 	return 0;
 }
@@ -460,34 +363,6 @@ static u8 max8997_dumpaddr_pmic[] = {
 	MAX8997_REG_DVSOKTIMER5,
 };
 
-static u8 max8997_dumpaddr_muic[] = {
-	MAX8997_MUIC_REG_INTMASK1,
-	MAX8997_MUIC_REG_INTMASK2,
-	MAX8997_MUIC_REG_INTMASK3,
-	MAX8997_MUIC_REG_CDETCTRL,
-	MAX8997_MUIC_REG_CONTROL1,
-	MAX8997_MUIC_REG_CONTROL2,
-	MAX8997_MUIC_REG_CONTROL3,
-};
-
-static u8 max8997_dumpaddr_haptic[] = {
-	MAX8997_HAPTIC_REG_CONF1,
-	MAX8997_HAPTIC_REG_CONF2,
-	MAX8997_HAPTIC_REG_DRVCONF,
-	MAX8997_HAPTIC_REG_CYCLECONF1,
-	MAX8997_HAPTIC_REG_CYCLECONF2,
-	MAX8997_HAPTIC_REG_SIGCONF1,
-	MAX8997_HAPTIC_REG_SIGCONF2,
-	MAX8997_HAPTIC_REG_SIGCONF3,
-	MAX8997_HAPTIC_REG_SIGCONF4,
-	MAX8997_HAPTIC_REG_SIGDC1,
-	MAX8997_HAPTIC_REG_SIGDC2,
-	MAX8997_HAPTIC_REG_SIGPWMDC1,
-	MAX8997_HAPTIC_REG_SIGPWMDC2,
-	MAX8997_HAPTIC_REG_SIGPWMDC3,
-	MAX8997_HAPTIC_REG_SIGPWMDC4,
-};
-
 static int max8997_freeze(struct device *dev)
 {
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
@@ -498,15 +373,6 @@ static int max8997_freeze(struct device *dev)
 		regmap_read(max8997->regmap, max8997_dumpaddr_pmic[i],
 				&max8997->reg_dump[i]);
 
-	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
-		regmap_read(max8997->regmap_muic, max8997_dumpaddr_muic[i],
-				&max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
-
-	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
-		regmap_read(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
-				&max8997->reg_dump[i + MAX8997_REG_PMIC_END +
-				MAX8997_MUIC_REG_END]);
-
 	return 0;
 }
 
@@ -520,15 +386,6 @@ static int max8997_restore(struct device *dev)
 		regmap_write(max8997->regmap, max8997_dumpaddr_pmic[i],
 				max8997->reg_dump[i]);
 
-	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
-		regmap_write(max8997->regmap_muic, max8997_dumpaddr_muic[i],
-				max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
-
-	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
-		regmap_write(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
-				max8997->reg_dump[i + MAX8997_REG_PMIC_END +
-				MAX8997_MUIC_REG_END]);
-
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index 22769ea..1786da4 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -69,12 +69,20 @@ enum {
 struct max8997_rtc_info {
 	struct device		*dev;
 	struct max8997_dev	*max8997;
+	struct i2c_client	*i2c;
+	struct regmap		*regmap;
 	struct rtc_device	*rtc_dev;
 	struct mutex		lock;
 	int virq;
 	int rtc_24hr_mode;
 };
 
+static const struct regmap_config max8997_rtc_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX8997_RTC_REG_END,
+};
+
 static void max8997_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
 				   int rtc_24hr_mode)
 {
@@ -118,8 +126,7 @@ static inline int max8997_rtc_set_update_reg(struct max8997_rtc_info *info)
 {
 	int ret;
 
-	ret = regmap_write(info->max8997->regmap_rtc,
-				MAX8997_RTC_UPDATE1, RTC_UDR_MASK);
+	ret = regmap_write(info->regmap, MAX8997_RTC_UPDATE1, RTC_UDR_MASK);
 	if (ret < 0)
 		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
 				__func__, ret);
@@ -140,7 +147,7 @@ static int max8997_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	int ret;
 
 	mutex_lock(&info->lock);
-	ret = regmap_bulk_read(info->max8997->regmap_rtc,
+	ret = regmap_bulk_read(info->regmap,
 				MAX8997_RTC_SEC, data, RTC_NR_TIME);
 	mutex_unlock(&info->lock);
 
@@ -167,7 +174,7 @@ static int max8997_rtc_set_time(struct device *dev, struct rtc_time *tm)
 
 	mutex_lock(&info->lock);
 
-	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+	ret = regmap_bulk_write(info->regmap,
 				MAX8997_RTC_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write time reg(%d)\n", __func__,
@@ -190,7 +197,7 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	mutex_lock(&info->lock);
 
-	ret = regmap_bulk_read(info->max8997->regmap_rtc,
+	ret = regmap_bulk_read(info->regmap,
 				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s:%d fail to read alarm reg(%d)\n",
@@ -209,8 +216,7 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	}
 
 	alrm->pending = 0;
-	ret = regmap_read(info->max8997->regmap_rtc,
-			       MAX8997_REG_STATUS1, &val);
+	ret = regmap_read(info->regmap, MAX8997_REG_STATUS1, &val);
 	if (ret < 0) {
 		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
 				__func__, __LINE__, ret);
@@ -233,7 +239,7 @@ static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
 	if (!mutex_is_locked(&info->lock))
 		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
 
-	ret = regmap_bulk_read(info->max8997->regmap_rtc,
+	ret = regmap_bulk_read(info->regmap,
 				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
@@ -244,7 +250,7 @@ static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
 	for (i = 0; i < RTC_NR_TIME; i++)
 		data[i] &= ~ALARM_ENABLE_MASK;
 
-	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+	ret = regmap_bulk_write(info->regmap,
 				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
@@ -265,7 +271,7 @@ static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
 	if (!mutex_is_locked(&info->lock))
 		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
 
-	ret = regmap_bulk_read(info->max8997->regmap_rtc,
+	ret = regmap_bulk_read(info->regmap,
 				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
@@ -284,7 +290,7 @@ static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
 	if (data[RTC_DATE] & 0x1f)
 		data[RTC_DATE] |= (1 << ALARM_ENABLE_SHIFT);
 
-	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+	ret = regmap_bulk_write(info->regmap,
 				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
@@ -316,7 +322,7 @@ static int max8997_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret < 0)
 		goto out;
 
-	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+	ret = regmap_bulk_write(info->regmap,
 				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
@@ -388,7 +394,7 @@ static void max8997_rtc_enable_wtsr(struct max8997_rtc_info *info, bool enable)
 	dev_info(info->dev, "%s: %s WTSR\n", __func__,
 			enable ? "enable" : "disable");
 
-	ret = regmap_update_bits(info->max8997->regmap_rtc,
+	ret = regmap_update_bits(info->regmap,
 				 MAX8997_RTC_WTSR_SMPL, mask, val);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
@@ -417,7 +423,7 @@ static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
 	dev_info(info->dev, "%s: %s SMPL\n", __func__,
 			enable ? "enable" : "disable");
 
-	ret = regmap_update_bits(info->max8997->regmap_rtc,
+	ret = regmap_update_bits(info->regmap,
 				 MAX8997_RTC_WTSR_SMPL, mask, val);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
@@ -428,8 +434,7 @@ static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
 	max8997_rtc_set_update_reg(info);
 
 	val = 0;
-	regmap_read(info->max8997->regmap_rtc,
-			 MAX8997_RTC_WTSR_SMPL, &val);
+	regmap_read(info->regmap, MAX8997_RTC_WTSR_SMPL, &val);
 	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
 }
 
@@ -444,7 +449,7 @@ static int max8997_rtc_init_reg(struct max8997_rtc_info *info)
 
 	info->rtc_24hr_mode = 1;
 
-	ret = regmap_bulk_write(info->max8997->regmap_rtc,
+	ret = regmap_bulk_write(info->regmap,
 				 MAX8997_RTC_CTRLMASK, data, 2);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
@@ -471,13 +476,24 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 	info->dev = &pdev->dev;
 	info->max8997 = max8997;
 
+	info->i2c = i2c_new_dummy(max8997->i2c->adapter, MAX8997_I2C_ADDR_RTC);
+
+	info->regmap = devm_regmap_init_i2c(info->i2c,
+					&max8997_rtc_regmap_config);
+	if (IS_ERR(info->regmap)) {
+		ret = PTR_ERR(info->regmap);
+		dev_err(info->dev,
+				"failed to allocate register map: %d\n", ret);
+		goto err_regmap;
+	}
+
 	platform_set_drvdata(pdev, info);
 
 	ret = max8997_rtc_init_reg(info);
 
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
-		return ret;
+		goto err_regmap;
 	}
 
 	max8997_rtc_enable_wtsr(info, true);
@@ -491,28 +507,41 @@ static int max8997_rtc_probe(struct platform_device *pdev)
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
-		return ret;
+		goto err_regmap;
 	}
 
 	virq = regmap_irq_get_virq(max8997->irq_data, MAX8997_PMICIRQ_RTCA1);
 	if (!virq) {
 		dev_err(&pdev->dev, "Failed to create mapping alarm IRQ\n");
 		ret = -ENXIO;
-		goto err_out;
+		goto err_regmap;
 	}
 	info->virq = virq;
 
 	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
 				max8997_rtc_alarm_irq, 0,
 				"rtc-alarm0", info);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
 			info->virq, ret);
+		goto err_regmap;
+	}
+
+	return ret;
 
-err_out:
+err_regmap:
+	i2c_unregister_device(info->i2c);
 	return ret;
 }
 
+static int max8997_rtc_remove(struct platform_device *pdev)
+{
+	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
+	i2c_unregister_device(info->i2c);
+
+	return 0;
+}
+
 static void max8997_rtc_shutdown(struct platform_device *pdev)
 {
 	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
@@ -532,6 +561,7 @@ static struct platform_driver max8997_rtc_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max8997_rtc_probe,
+	.remove		= max8997_rtc_remove,
 	.shutdown	= max8997_rtc_shutdown,
 	.id_table	= rtc_id,
 };
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index af2f0aa..612a295 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -26,6 +26,13 @@
 #include <linux/export.h>
 #include <linux/irqdomain.h>
 
+#define MAX8997_I2C_ADDR_PMIC		(0xCC >> 1)
+#define MAX8997_I2C_ADDR_MUIC		(0x4A >> 1)
+#define MAX8997_I2C_ADDR_BATTERY	(0x6C >> 1)
+#define MAX8997_I2C_ADDR_RTC		(0x0C >> 1)
+#define MAX8997_I2C_ADDR_HAPTIC		(0x90 >> 1)
+
+
 #define MAX8997_REG_INVALID	(0xff)
 
 enum max8997_pmic_reg {
@@ -430,21 +437,14 @@ struct max8997_dev {
 	struct device *dev;
 	struct max8997_platform_data *pdata;
 	struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
-	struct i2c_client *rtc; /* slave addr 0x0c */
-	struct i2c_client *haptic; /* slave addr 0x90 */
-	struct i2c_client *muic; /* slave addr 0x4a */
 	struct mutex iolock;
 
 	unsigned long type;
 	struct platform_device *battery; /* battery control (not fuel gauge) */
 
 	struct regmap *regmap;
-	struct regmap *regmap_rtc;
-	struct regmap *regmap_haptic;
-	struct regmap *regmap_muic;
 
 	struct regmap_irq_chip_data *irq_data;
-	struct regmap_irq_chip_data *irq_data_muic;
 	int irq;
 	int ono;
 	struct mutex irqlock;
-- 
1.7.9.5

