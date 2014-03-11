Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaCKPHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:07:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22894 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaCKPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:07:16 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-1a-531f26a1f0de
Message-id: <1394550432.24263.26.camel@AMDC1943>
Subject: Re: [PATCH 3/3] mfd: max8997: move regmap handling to function drivers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Tue, 11 Mar 2014 16:07:12 +0100
In-reply-to: <1394546304-15191-4-git-send-email-r.baldyga@samsung.com>
References: <1394546304-15191-1-git-send-email-r.baldyga@samsung.com>
 <1394546304-15191-4-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t/xa7oL1eSDDQ7v0LNYcvEqu8XUh0/Y
	LI7unMhkcf3Lc1aLSU/eM1scXvSC0WLiysnMFve/HmW0+Halg8ni5qdvrBaXd81hs9j6Zh2j
	xdojd9ktbjeuYLO4tvc4s8WDwzvZLXbvespqsb+zg9HidDerg7DHzll32T32TDzJ5rF5hZbH
	plWdbB53ru1h85h3MtBjz/wfrB59W1Yxekyf95PJ4/MmOY/1W7YyBXBHcdmkpOZklqUW6dsl
	cGWs+C5bcLqRseLBjKusDYwzM7oYOTkkBEwkdkxcygphi0lcuLeerYuRi0NIYCmjxOaFhxgh
	nM+MEk0vdjGDVPEKGEj8PLmcEcQWFvCXmLFhHxuIzSZgLLF5+RIwW0RAS+LOx/nsIM3MAoeZ
	JfY96ABbwSKgKnFrYTs7iM0p4Cax7N02ZogNjYwSv3dNBtvALKAuMWneImaIm5Qkdrd3skPE
	5SU2r3kLdYWgxI/J91gmMArMQtIyC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefn
	bmKERObXHYxLj1kdYhTgYFTi4Z2pJB8sxJpYVlyZe4hRgoNZSYQ3WRwoxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgVH34T01/aPPpr5XWXTS+0fUKpHMDW8WZs76WBG+r2I65zO2r2+uqbmusToa
	pH2BR+tS+q3A16Vf0wJc1/nMUBUW6n/rkvS7NlZr36W9CwQNpF3cH4Tv6MnXePwzxfVh0Oz1
	PCpPLoUfnVEXM7No7tKM1ydiXFasELNKbeOtXP/Veou6u5nygnolluKMREMt5qLiRACq0zpz
	qgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 14:58 +0100, Robert Baldyga wrote:
> This patch moves code creating new i2c clients and regmaps to function
> drivers which uses them. It allow to avoid creating this instances when
> intividual function drivers are not enabled.

s/which uses/which use/
s/It allow/ It allows/
s/intividual/individual/


> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |  118 +++++++++++++++++++++++++++--
>  drivers/input/misc/max8997_haptic.c |  113 ++++++++++++++++++++++-----
>  drivers/mfd/max8997.c               |  143 -----------------------------------
>  drivers/rtc/rtc-max8997.c           |   74 ++++++++++++------
>  include/linux/mfd/max8997-private.h |   14 ++--
>  5 files changed, 262 insertions(+), 200 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 5948061..a71581a 100644
> --- a/drivers/extcon/extcon-max8997.c
> +++ b/drivers/extcon/extcon-max8997.c
> @@ -118,6 +118,9 @@ enum max8997_muic_charger_type {
>  struct max8997_muic_info {
>  	struct device *dev;
>  	struct max8997_dev *max8997;
> +	struct i2c_client *i2c;
> +	struct regmap *regmap;
> +	struct regmap_irq_chip_data *irq_data;
>  	struct extcon_dev *edev;
>  	int prev_cable_type;
>  	int prev_chg_type;
> @@ -144,6 +147,39 @@ struct max8997_muic_info {
>  	 */
>  	int path_usb;
>  	int path_uart;
> +
> +	unsigned int reg_dump[MAX8997_MUIC_REG_END];
> +};
> +
> +static const struct regmap_config max8997_muic_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_MUIC_REG_END,
> +};
> +
> +static const struct regmap_irq max8997_irqs_muic[] = {
> +	/* MUIC_INT1 interrupts */
> +	{ .reg_offset = 0, .mask = MUIC_INT1_ADC_MASK, },
> +	{ .reg_offset = 0, .mask = MUIC_INT1_ADCLow_MASK, },
> +	{ .reg_offset = 0, .mask = MUIC_INT1_ADCError_MASK, },
> +	/* MUIC_INT2 interrupts */
> +	{ .reg_offset = 1, .mask = MUIC_INT2_ChgTyp_MASK, },
> +	{ .reg_offset = 1, .mask = MUIC_INT2_ChgDetRun_MASK, },
> +	{ .reg_offset = 1, .mask = MUIC_INT2_DCDTmr_MASK, },
> +	{ .reg_offset = 1, .mask = MUIC_INT2_DBChg_MASK, },
> +	{ .reg_offset = 1, .mask = MUIC_INT2_VBVolt_MASK, },
> +	/* MUIC_INT3 interrupts */
> +	{ .reg_offset = 2, .mask = MUIC_INT3_OVP_MASK, },
> +};
> +
> +static const struct regmap_irq_chip max8997_muic_irq_chip = {
> +	.name                   = "max8997-muic",
> +	.status_base            = MAX8997_MUIC_REG_INT1,
> +	.mask_base              = MAX8997_MUIC_REG_INTMASK1,
> +	.mask_invert            = true,
> +	.num_regs               = 3,
> +	.irqs                   = max8997_irqs_muic,
> +	.num_irqs               = ARRAY_SIZE(max8997_irqs_muic),
>  };
>  
>  enum {
> @@ -191,7 +227,7 @@ static int max8997_muic_set_debounce_time(struct max8997_muic_info *info,
>  	case ADC_DEBOUNCE_TIME_10MS:
>  	case ADC_DEBOUNCE_TIME_25MS:
>  	case ADC_DEBOUNCE_TIME_38_62MS:
> -		ret = regmap_update_bits(info->max8997->regmap_muic,
> +		ret = regmap_update_bits(info->regmap,
>  					  MAX8997_MUIC_REG_CONTROL3,
>  					  CONTROL3_ADCDBSET_MASK,
>  					  time << CONTROL3_ADCDBSET_SHIFT);
> @@ -229,7 +265,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
>  	else
>  		ctrl1 = CONTROL1_SW_OPEN;
>  
> -	ret = regmap_update_bits(info->max8997->regmap_muic,
> +	ret = regmap_update_bits(info->regmap,
>  			MAX8997_MUIC_REG_CONTROL1, COMP_SW_MASK, ctrl1);
>  	if (ret < 0) {
>  		dev_err(info->dev, "failed to update MUIC register\n");
> @@ -241,7 +277,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
>  	else
>  		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
>  
> -	ret = regmap_update_bits(info->max8997->regmap_muic,
> +	ret = regmap_update_bits(info->regmap,
>  			MAX8997_MUIC_REG_CONTROL2,
>  			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK, ctrl2);
>  	if (ret < 0) {
> @@ -544,7 +580,7 @@ static void max8997_muic_irq_work(struct work_struct *work)
>  		if (info->irq == muic_irqs[i].virq)
>  			irq_type = muic_irqs[i].irq;
>  
> -	ret = regmap_bulk_read(info->max8997->regmap_muic,
> +	ret = regmap_bulk_read(info->regmap,
>  				MAX8997_MUIC_REG_STATUS1, info->status, 2);
>  	if (ret) {
>  		dev_err(info->dev, "failed to read muic register\n");
> @@ -606,7 +642,7 @@ static int max8997_muic_detect_dev(struct max8997_muic_info *info)
>  	mutex_lock(&info->mutex);
>  
>  	/* Read STATUSx register to detect accessory */
> -	ret = regmap_bulk_read(info->max8997->regmap_muic,
> +	ret = regmap_bulk_read(info->regmap,
>  			MAX8997_MUIC_REG_STATUS1, info->status, 2);
>  	if (ret) {
>  		dev_err(info->dev, "failed to read MUIC register\n");
> @@ -670,6 +706,27 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  	info->dev = &pdev->dev;
>  	info->max8997 = max8997;
>  
> +	info->i2c = i2c_new_dummy(max8997->i2c->adapter, MAX8997_I2C_ADDR_MUIC);

Consider rebasing your patch on Lee Jones' MFD tree because there are
minor fixes for possible NULL pointer dereference on i2c_new_dummy
error. I didn't mentioned this before as this is actually the first
place where you add such code :). So add with current fixes in
linux-next/MFD tree.

This applies also to other drivers (haptic etc.).

> +
> +	info->regmap = devm_regmap_init_i2c(info->i2c,
> +			&max8997_muic_regmap_config);
> +	if (IS_ERR(info->regmap)) {
> +		ret = PTR_ERR(info->regmap);
> +		dev_err(info->dev,
> +			"failed to allocate register map: %d\n", ret);
> +		goto err_regmap;
> +	}
> +
> +	ret = regmap_add_irq_chip(info->regmap, max8997->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max8997_muic_irq_chip,
> +				&info->irq_data);
> +	if (ret) {
> +		dev_err(info->dev, "failed to add irq chip: %d\n", ret);
> +		goto err_regmap;
> +	}
> +

Same as in previous patch - please add regmap_del_irq_chip() in error
paths and remove function.

This applies also to other drivers (haptic etc.).

>  	platform_set_drvdata(pdev, info);
>  	mutex_init(&info->mutex);
>  
> @@ -679,8 +736,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  		struct max8997_muic_irq *muic_irq = &muic_irqs[i];
>  		unsigned int virq = 0;
>  
> -		virq = regmap_irq_get_virq(max8997->irq_data_muic,
> -					muic_irq->irq);
> +		virq = regmap_irq_get_virq(info->irq_data, muic_irq->irq);
>  		if (!virq) {
>  			ret = -EINVAL;
>  			goto err_irq;
> @@ -723,7 +779,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  
>  		/* Initialize registers according to platform data */
>  		for (i = 0; i < muic_pdata->num_init_data; i++) {
> -			regmap_write(info->max8997->regmap_muic,
> +			regmap_write(info->regmap,
>  					muic_pdata->init_data[i].addr,
>  					muic_pdata->init_data[i].data);
>  		}
> @@ -779,6 +835,8 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  err_irq:
>  	while (--i >= 0)
>  		free_irq(muic_irqs[i].virq, info);
> +err_regmap:
> +	i2c_unregister_device(info->i2c);
>  	return ret;
>  }
>  
> @@ -796,10 +854,54 @@ static int max8997_muic_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static u8 max8997_muic_dumpaddr[] = {
> +	MAX8997_MUIC_REG_INTMASK1,
> +	MAX8997_MUIC_REG_INTMASK2,
> +	MAX8997_MUIC_REG_INTMASK3,
> +	MAX8997_MUIC_REG_CDETCTRL,
> +	MAX8997_MUIC_REG_CONTROL1,
> +	MAX8997_MUIC_REG_CONTROL2,
> +	MAX8997_MUIC_REG_CONTROL3,
> +};
> +
> +static int max8997_muic_freeze(struct device *dev)
> +{
> +	struct platform_device *pdev =
> +		container_of(dev, struct platform_device, dev);
> +	struct max8997_muic_info *info = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(max8997_muic_dumpaddr); i++)
> +		regmap_read(info->regmap, max8997_muic_dumpaddr[i],
> +				&info->reg_dump[i]);
> +
> +	return 0;
> +}
> +
> +static int max8997_muic_restore(struct device *dev)
> +{
> +	struct platform_device *pdev =
> +		container_of(dev, struct platform_device, dev);
> +	struct max8997_muic_info *info = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(max8997_muic_dumpaddr); i++)
> +		regmap_write(info->regmap, max8997_muic_dumpaddr[i],
> +				info->reg_dump[i]);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops max8997_muic_pm = {
> +	.freeze = max8997_muic_freeze,
> +	.restore = max8997_muic_restore,
> +};
> +

Shouldn't it be inside #ifdef CONFIG_PM_SLEEP?

>  static struct platform_driver max8997_muic_driver = {
>  	.driver		= {
>  		.name	= DEV_NAME,
>  		.owner	= THIS_MODULE,
> +		.pm	= &max8997_muic_pm,
>  	},
>  	.probe		= max8997_muic_probe,
>  	.remove		= max8997_muic_remove,
> diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
> index d3f7079..abb44f3 100644
> --- a/drivers/input/misc/max8997_haptic.c
> +++ b/drivers/input/misc/max8997_haptic.c
> @@ -47,6 +47,8 @@
>  struct max8997_haptic {
>  	struct device *dev;
>  	struct max8997_dev *max8997;
> +	struct i2c_client *i2c;
> +	struct regmap *regmap;
>  	struct input_dev *input_dev;
>  	struct regulator *regulator;
>  
> @@ -66,6 +68,14 @@ struct max8997_haptic {
>  	unsigned int internal_mode_pattern;
>  	unsigned int pattern_cycle;
>  	unsigned int pattern_signal_period;
> +
> +	unsigned int reg_dump[MAX8997_HAPTIC_REG_END];
> +};
> +
> +static const struct regmap_config max8997_haptic_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = MAX8997_HAPTIC_REG_END,
>  };
>  
>  static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
> @@ -87,19 +97,19 @@ static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
>  		}
>  		switch (chip->internal_mode_pattern) {
>  		case 0:
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_SIGPWMDC1, duty_index);
>  			break;
>  		case 1:
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_SIGPWMDC2, duty_index);
>  			break;
>  		case 2:
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_SIGPWMDC3, duty_index);
>  			break;
>  		case 3:
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_SIGPWMDC4, duty_index);
>  			break;
>  		default:
> @@ -116,51 +126,49 @@ static void max8997_haptic_configure(struct max8997_haptic *chip)
>  	value = chip->type << MAX8997_MOTOR_TYPE_SHIFT |
>  		chip->enabled << MAX8997_ENABLE_SHIFT |
>  		chip->mode << MAX8997_MODE_SHIFT | chip->pwm_divisor;
> -	regmap_write(chip->max8997->regmap_haptic,
> -		MAX8997_HAPTIC_REG_CONF2, value);
> +	regmap_write(chip->regmap, MAX8997_HAPTIC_REG_CONF2, value);
>  
>  	if (chip->mode == MAX8997_INTERNAL_MODE && chip->enabled) {
>  		value = chip->internal_mode_pattern << MAX8997_CYCLE_SHIFT |
>  			chip->internal_mode_pattern << MAX8997_SIG_PERIOD_SHIFT |
>  			chip->internal_mode_pattern << MAX8997_SIG_DUTY_SHIFT |
>  			chip->internal_mode_pattern << MAX8997_PWM_DUTY_SHIFT;
> -		regmap_write(chip->max8997->regmap_haptic,
> -			MAX8997_HAPTIC_REG_DRVCONF, value);
> +		regmap_write(chip->regmap, MAX8997_HAPTIC_REG_DRVCONF, value);
>  
>  		switch (chip->internal_mode_pattern) {
>  		case 0:
>  			value = chip->pattern_cycle << 4;
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_CYCLECONF1, value);
>  			value = chip->pattern_signal_period;
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_SIGCONF1, value);
>  			break;
>  
>  		case 1:
>  			value = chip->pattern_cycle;
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_CYCLECONF1, value);
>  			value = chip->pattern_signal_period;
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_SIGCONF2, value);
>  			break;
>  
>  		case 2:
>  			value = chip->pattern_cycle << 4;
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_CYCLECONF2, value);
>  			value = chip->pattern_signal_period;
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_SIGCONF3, value);
>  			break;
>  
>  		case 3:
>  			value = chip->pattern_cycle;
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_CYCLECONF2, value);
>  			value = chip->pattern_signal_period;
> -			regmap_write(chip->max8997->regmap_haptic,
> +			regmap_write(chip->regmap,
>  				MAX8997_HAPTIC_REG_SIGCONF4, value);
>  			break;
>  
> @@ -277,6 +285,17 @@ static int max8997_haptic_probe(struct platform_device *pdev)
>  	chip->mode = haptic_pdata->mode;
>  	chip->pwm_divisor = haptic_pdata->pwm_divisor;
>  
> +	chip->i2c = i2c_new_dummy(iodev->i2c->adapter, MAX8997_I2C_ADDR_HAPTIC);
> +

Return value - use code from linux-next/MFD tree.

> +	chip->regmap = devm_regmap_init_i2c(chip->i2c,
> +			&max8997_haptic_regmap_config);
> +	if (IS_ERR(chip->regmap)) {
> +		error = PTR_ERR(chip->regmap);
> +		dev_err(chip->dev,
> +			"failed to allocate register map: %d\n", error);
> +		goto err_free_i2c;
> +	}
> +
>  	switch (chip->mode) {
>  	case MAX8997_INTERNAL_MODE:
>  		chip->internal_mode_pattern =
> @@ -294,7 +313,7 @@ static int max8997_haptic_probe(struct platform_device *pdev)
>  			dev_err(&pdev->dev,
>  				"unable to request PWM for haptic, error: %d\n",
>  				error);
> -			goto err_free_mem;
> +			goto err_free_i2c;
>  		}
>  		break;
>  
> @@ -302,7 +321,7 @@ static int max8997_haptic_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev,
>  			"Invalid chip mode specified (%d)\n", chip->mode);
>  		error = -EINVAL;
> -		goto err_free_mem;
> +		goto err_free_i2c;
>  	}
>  
>  	chip->regulator = regulator_get(&pdev->dev, "inmotor");
> @@ -348,6 +367,8 @@ err_put_regulator:
>  err_free_pwm:
>  	if (chip->mode == MAX8997_EXTERNAL_MODE)
>  		pwm_free(chip->pwm);
> +err_free_i2c:
> +	i2c_unregister_device(chip->i2c);
>  err_free_mem:
>  	input_free_device(input_dev);
>  	kfree(chip);
> @@ -370,6 +391,24 @@ static int max8997_haptic_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static u8 max8997_haptic_dumpaddr[] = {
> +	MAX8997_HAPTIC_REG_CONF1,
> +	MAX8997_HAPTIC_REG_CONF2,
> +	MAX8997_HAPTIC_REG_DRVCONF,
> +	MAX8997_HAPTIC_REG_CYCLECONF1,
> +	MAX8997_HAPTIC_REG_CYCLECONF2,
> +	MAX8997_HAPTIC_REG_SIGCONF1,
> +	MAX8997_HAPTIC_REG_SIGCONF2,
> +	MAX8997_HAPTIC_REG_SIGCONF3,
> +	MAX8997_HAPTIC_REG_SIGCONF4,
> +	MAX8997_HAPTIC_REG_SIGDC1,
> +	MAX8997_HAPTIC_REG_SIGDC2,
> +	MAX8997_HAPTIC_REG_SIGPWMDC1,
> +	MAX8997_HAPTIC_REG_SIGPWMDC2,
> +	MAX8997_HAPTIC_REG_SIGPWMDC3,
> +	MAX8997_HAPTIC_REG_SIGPWMDC4,
> +};
> +
>  #ifdef CONFIG_PM_SLEEP
>  static int max8997_haptic_suspend(struct device *dev)
>  {
> @@ -382,7 +421,41 @@ static int max8997_haptic_suspend(struct device *dev)
>  }
>  #endif
>  
> -static SIMPLE_DEV_PM_OPS(max8997_haptic_pm_ops, max8997_haptic_suspend, NULL);
> +static int max8997_haptic_freeze(struct device *dev)
> +{
> +	struct platform_device *pdev =
> +		container_of(dev, struct platform_device, dev);
> +	struct max8997_haptic *chip = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(max8997_haptic_dumpaddr); i++)
> +		regmap_read(chip->regmap, max8997_haptic_dumpaddr[i],
> +				&chip->reg_dump[i]);
> +
> +	return 0;
> +}
> +
> +static int max8997_haptic_restore(struct device *dev)
> +{
> +	struct platform_device *pdev =
> +		container_of(dev, struct platform_device, dev);
> +	struct max8997_haptic *chip = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(max8997_haptic_dumpaddr); i++)
> +		regmap_write(chip->regmap, max8997_haptic_dumpaddr[i],
> +				chip->reg_dump[i]);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops max8997_haptic_pm = {
> +#ifdef CONFIG_PM_SLEEP
> +	.suspend = max8997_haptic_suspend,
> +#endif
> +	.freeze = max8997_haptic_freeze,
> +	.restore = max8997_haptic_restore,
> +};

Freeze should be also in CONFIG_PM_SLEEP.

Best regards,
Krzysztof

