Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaCMMzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:55:14 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62177 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaCMMzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:55:12 -0400
Date: Thu, 13 Mar 2014 12:55:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, dmitry.torokhov@gmail.com,
        cooloney@gmail.com, rpurdie@rpsys.net, dbaryshkov@gmail.com,
        dwmw2@infradead.org, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 4/4] mfd: max8997: move regmap handling to function
 drivers
Message-ID: <20140313125504.GA10356@lee--X1>
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-5-git-send-email-r.baldyga@samsung.com>
 <532191E6.6080108@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <532191E6.6080108@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is it necessary? If previous mfd driver has various i2c line, previous mfd driver
> initialize regmap/i2c setting on mfd driver.
> I'm not sure that regmap/i2c setting code move from mfd driver to each driver.
> 
> Dear Lee Jones,
> I need your opinion about moving regmap/i2c code from mfd driver to each driver.

I'd rather take advice from Mark on this one.

> On 03/13/2014 06:38 PM, Robert Baldyga wrote:
> > This patch moves code creating new i2c clients and regmaps to function
> > drivers which use them. It allows to avoid creating this instances when
> > individual function drivers are not enabled.

I think this can be done with if()s, no?

<end>

> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > ---
> >  drivers/extcon/extcon-max8997.c     |  131 +++++++++++++++++++++++++--
> >  drivers/input/misc/max8997_haptic.c |  117 +++++++++++++++++++-----
> >  drivers/mfd/max8997.c               |  169 +----------------------------------
> >  drivers/rtc/rtc-max8997.c           |   78 +++++++++++-----
> >  include/linux/mfd/max8997-private.h |   14 +--
> >  5 files changed, 284 insertions(+), 225 deletions(-)
> > 
> > diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> > index 15fc5c0..51c2781 100644
> > --- a/drivers/extcon/extcon-max8997.c
> > +++ b/drivers/extcon/extcon-max8997.c
> > @@ -118,6 +118,9 @@ enum max8997_muic_charger_type {
> >  struct max8997_muic_info {
> >  	struct device *dev;
> >  	struct max8997_dev *max8997;
> > +	struct i2c_client *i2c;
> > +	struct regmap *regmap;
> > +	struct regmap_irq_chip_data *irq_data;
> >  	struct extcon_dev *edev;
> >  	int prev_cable_type;
> >  	int prev_chg_type;
> > @@ -144,6 +147,39 @@ struct max8997_muic_info {
> >  	 */
> >  	int path_usb;
> >  	int path_uart;
> > +
> > +	unsigned int reg_dump[MAX8997_MUIC_REG_END];
> > +};
> > +
> > +static const struct regmap_config max8997_muic_regmap_config = {
> > +	.reg_bits = 8,
> > +	.val_bits = 8,
> > +	.max_register = MAX8997_MUIC_REG_END,
> > +};
> > +
> > +static const struct regmap_irq max8997_irqs_muic[] = {
> > +	/* MUIC_INT1 interrupts */
> > +	{ .reg_offset = 0, .mask = MUIC_INT1_ADC_MASK, },
> > +	{ .reg_offset = 0, .mask = MUIC_INT1_ADCLOW_MASK, },
> > +	{ .reg_offset = 0, .mask = MUIC_INT1_ADCERROR_MASK, },
> > +	/* MUIC_INT2 interrupts */
> > +	{ .reg_offset = 1, .mask = MUIC_INT2_CHGTYP_MASK, },
> > +	{ .reg_offset = 1, .mask = MUIC_INT2_CHGDETRUN_MASK, },
> > +	{ .reg_offset = 1, .mask = MUIC_INT2_DCDTMR_MASK, },
> > +	{ .reg_offset = 1, .mask = MUIC_INT2_DBCHG_MASK, },
> > +	{ .reg_offset = 1, .mask = MUIC_INT2_VBVOLT_MASK, },
> > +	/* MUIC_INT3 interrupts */
> > +	{ .reg_offset = 2, .mask = MUIC_INT3_OVP_MASK, },
> > +};
> > +
> > +static const struct regmap_irq_chip max8997_muic_irq_chip = {
> > +	.name                   = "max8997-muic",
> > +	.status_base            = MAX8997_MUIC_REG_INT1,
> > +	.mask_base              = MAX8997_MUIC_REG_INTMASK1,
> > +	.mask_invert            = true,
> > +	.num_regs               = 3,
> > +	.irqs                   = max8997_irqs_muic,
> > +	.num_irqs               = ARRAY_SIZE(max8997_irqs_muic),
> >  };
> >  
> >  enum {
> > @@ -191,7 +227,7 @@ static int max8997_muic_set_debounce_time(struct max8997_muic_info *info,
> >  	case ADC_DEBOUNCE_TIME_10MS:
> >  	case ADC_DEBOUNCE_TIME_25MS:
> >  	case ADC_DEBOUNCE_TIME_38_62MS:
> > -		ret = regmap_update_bits(info->max8997->regmap_muic,
> > +		ret = regmap_update_bits(info->regmap,
> >  					  MAX8997_MUIC_REG_CONTROL3,
> >  					  CONTROL3_ADCDBSET_MASK,
> >  					  time << CONTROL3_ADCDBSET_SHIFT);
> > @@ -229,7 +265,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
> >  	else
> >  		ctrl1 = CONTROL1_SW_OPEN;
> >  
> > -	ret = regmap_update_bits(info->max8997->regmap_muic,
> > +	ret = regmap_update_bits(info->regmap,
> >  			MAX8997_MUIC_REG_CONTROL1, COMP_SW_MASK, ctrl1);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "failed to update MUIC register\n");
> > @@ -241,7 +277,7 @@ static int max8997_muic_set_path(struct max8997_muic_info *info,
> >  	else
> >  		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
> >  
> > -	ret = regmap_update_bits(info->max8997->regmap_muic,
> > +	ret = regmap_update_bits(info->regmap,
> >  			MAX8997_MUIC_REG_CONTROL2,
> >  			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK, ctrl2);
> >  	if (ret < 0) {
> > @@ -544,7 +580,7 @@ static void max8997_muic_irq_work(struct work_struct *work)
> >  		if (info->irq == muic_irqs[i].virq)
> >  			irq_type = muic_irqs[i].irq;
> >  
> > -	ret = regmap_bulk_read(info->max8997->regmap_muic,
> > +	ret = regmap_bulk_read(info->regmap,
> >  				MAX8997_MUIC_REG_STATUS1, info->status, 2);
> >  	if (ret) {
> >  		dev_err(info->dev, "failed to read muic register\n");
> > @@ -606,7 +642,7 @@ static int max8997_muic_detect_dev(struct max8997_muic_info *info)
> >  	mutex_lock(&info->mutex);
> >  
> >  	/* Read STATUSx register to detect accessory */
> > -	ret = regmap_bulk_read(info->max8997->regmap_muic,
> > +	ret = regmap_bulk_read(info->regmap,
> >  			MAX8997_MUIC_REG_STATUS1, info->status, 2);
> >  	if (ret) {
> >  		dev_err(info->dev, "failed to read MUIC register\n");
> > @@ -670,6 +706,31 @@ static int max8997_muic_probe(struct platform_device *pdev)
> >  	info->dev = &pdev->dev;
> >  	info->max8997 = max8997;
> >  
> > +	info->i2c = i2c_new_dummy(max8997->i2c->adapter, MAX8997_I2C_ADDR_MUIC);
> > +	if (!info->i2c) {
> > +		dev_err(info->dev, "failed to allocate I2C device\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	info->regmap = devm_regmap_init_i2c(info->i2c,
> > +			&max8997_muic_regmap_config);
> > +	if (IS_ERR(info->regmap)) {
> > +		ret = PTR_ERR(info->regmap);
> > +		dev_err(info->dev,
> > +			"failed to allocate register map: %d\n", ret);
> > +		goto err_regmap;
> > +	}
> > +
> > +	ret = regmap_add_irq_chip(info->regmap, max8997->irq,
> > +				IRQF_ONESHOT | IRQF_SHARED |
> > +				IRQF_TRIGGER_FALLING, 0,
> > +				&max8997_muic_irq_chip,
> > +				&info->irq_data);
> > +	if (ret) {
> > +		dev_err(info->dev, "failed to add irq chip: %d\n", ret);
> > +		goto err_regmap;
> > +	}
> > +
> >  	platform_set_drvdata(pdev, info);
> >  	mutex_init(&info->mutex);
> >  
> > @@ -679,8 +740,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
> >  		struct max8997_muic_irq *muic_irq = &muic_irqs[i];
> >  		unsigned int virq = 0;
> >  
> > -		virq = regmap_irq_get_virq(max8997->irq_data_muic,
> > -					muic_irq->irq);
> > +		virq = regmap_irq_get_virq(info->irq_data, muic_irq->irq);
> >  		if (!virq) {
> >  			ret = -EINVAL;
> >  			goto err_irq;
> > @@ -723,7 +783,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
> >  
> >  		/* Initialize registers according to platform data */
> >  		for (i = 0; i < muic_pdata->num_init_data; i++) {
> > -			regmap_write(info->max8997->regmap_muic,
> > +			regmap_write(info->regmap,
> >  					muic_pdata->init_data[i].addr,
> >  					muic_pdata->init_data[i].data);
> >  		}
> > @@ -779,6 +839,9 @@ static int max8997_muic_probe(struct platform_device *pdev)
> >  err_irq:
> >  	while (--i >= 0)
> >  		free_irq(muic_irqs[i].virq, info);
> > +	regmap_del_irq_chip(info->max8997->irq, info->irq_data);
> > +err_regmap:
> > +	i2c_unregister_device(info->i2c);
> >  	return ret;
> >  }
> >  
> > @@ -789,6 +852,9 @@ static int max8997_muic_remove(struct platform_device *pdev)
> >  
> >  	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
> >  		free_irq(muic_irqs[i].virq, info);
> > +
> > +	regmap_del_irq_chip(info->max8997->irq, info->irq_data);
> > +
> >  	cancel_work_sync(&info->irq_work);
> >  
> >  	extcon_dev_unregister(info->edev);
> > @@ -796,10 +862,59 @@ static int max8997_muic_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > +static u8 max8997_muic_dumpaddr[] = {
> > +	MAX8997_MUIC_REG_INTMASK1,
> > +	MAX8997_MUIC_REG_INTMASK2,
> > +	MAX8997_MUIC_REG_INTMASK3,
> > +	MAX8997_MUIC_REG_CDETCTRL,
> > +	MAX8997_MUIC_REG_CONTROL1,
> > +	MAX8997_MUIC_REG_CONTROL2,
> > +	MAX8997_MUIC_REG_CONTROL3,
> > +};
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int max8997_muic_freeze(struct device *dev)
> > +{
> > +	struct platform_device *pdev =
> > +		container_of(dev, struct platform_device, dev);
> > +	struct max8997_muic_info *info = platform_get_drvdata(pdev);
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(max8997_muic_dumpaddr); i++)
> > +		regmap_read(info->regmap, max8997_muic_dumpaddr[i],
> > +				&info->reg_dump[i]);
> > +
> > +	return 0;
> > +}
> > +
> > +static int max8997_muic_restore(struct device *dev)
> > +{
> > +	struct platform_device *pdev =
> > +		container_of(dev, struct platform_device, dev);
> > +	struct max8997_muic_info *info = platform_get_drvdata(pdev);
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(max8997_muic_dumpaddr); i++)
> > +		regmap_write(info->regmap, max8997_muic_dumpaddr[i],
> > +				info->reg_dump[i]);
> > +
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static const struct dev_pm_ops max8997_muic_pm = {
> > +#ifdef CONFIG_PM_SLEEP
> > +	.freeze = max8997_muic_freeze,
> > +	.restore = max8997_muic_restore,
> > +#endif
> > +
> > +};
> > +
> >  static struct platform_driver max8997_muic_driver = {
> >  	.driver		= {
> >  		.name	= DEV_NAME,
> >  		.owner	= THIS_MODULE,
> > +		.pm	= &max8997_muic_pm,
> >  	},
> >  	.probe		= max8997_muic_probe,
> >  	.remove		= max8997_muic_remove,
> > diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
> > index d3f7079..9952eb2 100644
> > --- a/drivers/input/misc/max8997_haptic.c
> > +++ b/drivers/input/misc/max8997_haptic.c
> > @@ -47,6 +47,8 @@
> >  struct max8997_haptic {
> >  	struct device *dev;
> >  	struct max8997_dev *max8997;
> > +	struct i2c_client *i2c;
> > +	struct regmap *regmap;
> >  	struct input_dev *input_dev;
> >  	struct regulator *regulator;
> >  
> > @@ -66,6 +68,14 @@ struct max8997_haptic {
> >  	unsigned int internal_mode_pattern;
> >  	unsigned int pattern_cycle;
> >  	unsigned int pattern_signal_period;
> > +
> > +	unsigned int reg_dump[MAX8997_HAPTIC_REG_END];
> > +};
> > +
> > +static const struct regmap_config max8997_haptic_regmap_config = {
> > +	.reg_bits = 8,
> > +	.val_bits = 8,
> > +	.max_register = MAX8997_HAPTIC_REG_END,
> >  };
> >  
> >  static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
> > @@ -87,19 +97,19 @@ static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
> >  		}
> >  		switch (chip->internal_mode_pattern) {
> >  		case 0:
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_SIGPWMDC1, duty_index);
> >  			break;
> >  		case 1:
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_SIGPWMDC2, duty_index);
> >  			break;
> >  		case 2:
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_SIGPWMDC3, duty_index);
> >  			break;
> >  		case 3:
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_SIGPWMDC4, duty_index);
> >  			break;
> >  		default:
> > @@ -116,51 +126,49 @@ static void max8997_haptic_configure(struct max8997_haptic *chip)
> >  	value = chip->type << MAX8997_MOTOR_TYPE_SHIFT |
> >  		chip->enabled << MAX8997_ENABLE_SHIFT |
> >  		chip->mode << MAX8997_MODE_SHIFT | chip->pwm_divisor;
> > -	regmap_write(chip->max8997->regmap_haptic,
> > -		MAX8997_HAPTIC_REG_CONF2, value);
> > +	regmap_write(chip->regmap, MAX8997_HAPTIC_REG_CONF2, value);
> >  
> >  	if (chip->mode == MAX8997_INTERNAL_MODE && chip->enabled) {
> >  		value = chip->internal_mode_pattern << MAX8997_CYCLE_SHIFT |
> >  			chip->internal_mode_pattern << MAX8997_SIG_PERIOD_SHIFT |
> >  			chip->internal_mode_pattern << MAX8997_SIG_DUTY_SHIFT |
> >  			chip->internal_mode_pattern << MAX8997_PWM_DUTY_SHIFT;
> > -		regmap_write(chip->max8997->regmap_haptic,
> > -			MAX8997_HAPTIC_REG_DRVCONF, value);
> > +		regmap_write(chip->regmap, MAX8997_HAPTIC_REG_DRVCONF, value);
> >  
> >  		switch (chip->internal_mode_pattern) {
> >  		case 0:
> >  			value = chip->pattern_cycle << 4;
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_CYCLECONF1, value);
> >  			value = chip->pattern_signal_period;
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_SIGCONF1, value);
> >  			break;
> >  
> >  		case 1:
> >  			value = chip->pattern_cycle;
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_CYCLECONF1, value);
> >  			value = chip->pattern_signal_period;
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_SIGCONF2, value);
> >  			break;
> >  
> >  		case 2:
> >  			value = chip->pattern_cycle << 4;
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_CYCLECONF2, value);
> >  			value = chip->pattern_signal_period;
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_SIGCONF3, value);
> >  			break;
> >  
> >  		case 3:
> >  			value = chip->pattern_cycle;
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_CYCLECONF2, value);
> >  			value = chip->pattern_signal_period;
> > -			regmap_write(chip->max8997->regmap_haptic,
> > +			regmap_write(chip->regmap,
> >  				MAX8997_HAPTIC_REG_SIGCONF4, value);
> >  			break;
> >  
> > @@ -277,6 +285,21 @@ static int max8997_haptic_probe(struct platform_device *pdev)
> >  	chip->mode = haptic_pdata->mode;
> >  	chip->pwm_divisor = haptic_pdata->pwm_divisor;
> >  
> > +	chip->i2c = i2c_new_dummy(iodev->i2c->adapter, MAX8997_I2C_ADDR_HAPTIC);
> > +	if (!chip->i2c) {
> > +		dev_err(info->dev, "failed to allocate I2C device\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	chip->regmap = devm_regmap_init_i2c(chip->i2c,
> > +			&max8997_haptic_regmap_config);
> > +	if (IS_ERR(chip->regmap)) {
> > +		error = PTR_ERR(chip->regmap);
> > +		dev_err(chip->dev,
> > +			"failed to allocate register map: %d\n", error);
> > +		goto err_free_i2c;
> > +	}
> > +
> >  	switch (chip->mode) {
> >  	case MAX8997_INTERNAL_MODE:
> >  		chip->internal_mode_pattern =
> > @@ -294,7 +317,7 @@ static int max8997_haptic_probe(struct platform_device *pdev)
> >  			dev_err(&pdev->dev,
> >  				"unable to request PWM for haptic, error: %d\n",
> >  				error);
> > -			goto err_free_mem;
> > +			goto err_free_i2c;
> >  		}
> >  		break;
> >  
> > @@ -302,7 +325,7 @@ static int max8997_haptic_probe(struct platform_device *pdev)
> >  		dev_err(&pdev->dev,
> >  			"Invalid chip mode specified (%d)\n", chip->mode);
> >  		error = -EINVAL;
> > -		goto err_free_mem;
> > +		goto err_free_i2c;
> >  	}
> >  
> >  	chip->regulator = regulator_get(&pdev->dev, "inmotor");
> > @@ -348,6 +371,8 @@ err_put_regulator:
> >  err_free_pwm:
> >  	if (chip->mode == MAX8997_EXTERNAL_MODE)
> >  		pwm_free(chip->pwm);
> > +err_free_i2c:
> > +	i2c_unregister_device(chip->i2c);
> >  err_free_mem:
> >  	input_free_device(input_dev);
> >  	kfree(chip);
> > @@ -370,6 +395,24 @@ static int max8997_haptic_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > +static u8 max8997_haptic_dumpaddr[] = {
> > +	MAX8997_HAPTIC_REG_CONF1,
> > +	MAX8997_HAPTIC_REG_CONF2,
> > +	MAX8997_HAPTIC_REG_DRVCONF,
> > +	MAX8997_HAPTIC_REG_CYCLECONF1,
> > +	MAX8997_HAPTIC_REG_CYCLECONF2,
> > +	MAX8997_HAPTIC_REG_SIGCONF1,
> > +	MAX8997_HAPTIC_REG_SIGCONF2,
> > +	MAX8997_HAPTIC_REG_SIGCONF3,
> > +	MAX8997_HAPTIC_REG_SIGCONF4,
> > +	MAX8997_HAPTIC_REG_SIGDC1,
> > +	MAX8997_HAPTIC_REG_SIGDC2,
> > +	MAX8997_HAPTIC_REG_SIGPWMDC1,
> > +	MAX8997_HAPTIC_REG_SIGPWMDC2,
> > +	MAX8997_HAPTIC_REG_SIGPWMDC3,
> > +	MAX8997_HAPTIC_REG_SIGPWMDC4,
> > +};
> > +
> >  #ifdef CONFIG_PM_SLEEP
> >  static int max8997_haptic_suspend(struct device *dev)
> >  {
> > @@ -380,9 +423,43 @@ static int max8997_haptic_suspend(struct device *dev)
> >  
> >  	return 0;
> >  }
> > +
> > +static int max8997_haptic_freeze(struct device *dev)
> > +{
> > +	struct platform_device *pdev =
> > +		container_of(dev, struct platform_device, dev);
> > +	struct max8997_haptic *chip = platform_get_drvdata(pdev);
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(max8997_haptic_dumpaddr); i++)
> > +		regmap_read(chip->regmap, max8997_haptic_dumpaddr[i],
> > +				&chip->reg_dump[i]);
> > +
> > +	return 0;
> > +}
> > +
> > +static int max8997_haptic_restore(struct device *dev)
> > +{
> > +	struct platform_device *pdev =
> > +		container_of(dev, struct platform_device, dev);
> > +	struct max8997_haptic *chip = platform_get_drvdata(pdev);
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(max8997_haptic_dumpaddr); i++)
> > +		regmap_write(chip->regmap, max8997_haptic_dumpaddr[i],
> > +				chip->reg_dump[i]);
> > +
> > +	return 0;
> > +}
> >  #endif
> >  
> > -static SIMPLE_DEV_PM_OPS(max8997_haptic_pm_ops, max8997_haptic_suspend, NULL);
> > +static const struct dev_pm_ops max8997_haptic_pm = {
> > +#ifdef CONFIG_PM_SLEEP
> > +	.suspend = max8997_haptic_suspend,
> > +	.freeze = max8997_haptic_freeze,
> > +	.restore = max8997_haptic_restore,
> > +#endif
> > +};
> >  
> >  static const struct platform_device_id max8997_haptic_id[] = {
> >  	{ "max8997-haptic", 0 },
> > @@ -394,7 +471,7 @@ static struct platform_driver max8997_haptic_driver = {
> >  	.driver	= {
> >  		.name	= "max8997-haptic",
> >  		.owner	= THIS_MODULE,
> > -		.pm	= &max8997_haptic_pm_ops,
> > +		.pm	= &max8997_haptic_pm,
> >  	},
> >  	.probe		= max8997_haptic_probe,
> >  	.remove		= max8997_haptic_remove,
> > diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> > index 5a35b3f..e4f37d3 100644
> > --- a/drivers/mfd/max8997.c
> > +++ b/drivers/mfd/max8997.c
> > @@ -35,12 +35,6 @@
> >  #include <linux/mfd/max8997-private.h>
> >  #include <linux/regmap.h>
> >  
> > -#define I2C_ADDR_PMIC	(0xCC >> 1)
> > -#define I2C_ADDR_MUIC	(0x4A >> 1)
> > -#define I2C_ADDR_BATTERY	(0x6C >> 1)
> > -#define I2C_ADDR_RTC	(0x0C >> 1)
> > -#define I2C_ADDR_HAPTIC	(0x90 >> 1)
> > -
> >  static const struct mfd_cell max8997_devs[] = {
> >  	{ .name = "max8997-pmic", },
> >  	{ .name = "max8997-rtc", },
> > @@ -107,48 +101,6 @@ static const struct regmap_irq_chip max8997_irq_chip = {
> >  	.num_irqs		= ARRAY_SIZE(max8997_irqs),
> >  };
> >  
> > -static const struct regmap_config max8997_regmap_rtc_config = {
> > -	.reg_bits = 8,
> > -	.val_bits = 8,
> > -	.max_register = MAX8997_RTC_REG_END,
> > -};
> > -
> > -static const struct regmap_config max8997_regmap_haptic_config = {
> > -	.reg_bits = 8,
> > -	.val_bits = 8,
> > -	.max_register = MAX8997_HAPTIC_REG_END,
> > -};
> > -
> > -static const struct regmap_config max8997_regmap_muic_config = {
> > -	.reg_bits = 8,
> > -	.val_bits = 8,
> > -	.max_register = MAX8997_MUIC_REG_END,
> > -};
> > -
> > -static const struct regmap_irq max8997_irqs_muic[] = {
> > -	/* MUIC_INT1 interrupts */
> > -	{ .reg_offset = 0, .mask = MUIC_INT1_ADC_MASK, },
> > -	{ .reg_offset = 0, .mask = MUIC_INT1_ADCLOW_MASK, },
> > -	{ .reg_offset = 0, .mask = MUIC_INT1_ADCERROR_MASK, },
> > -	/* MUIC_INT2 interrupts */
> > -	{ .reg_offset = 1, .mask = MUIC_INT2_CHGTYP_MASK, },
> > -	{ .reg_offset = 1, .mask = MUIC_INT2_CHGDETRUN_MASK, },
> > -	{ .reg_offset = 1, .mask = MUIC_INT2_DCDTMR_MASK, },
> > -	{ .reg_offset = 1, .mask = MUIC_INT2_DBCHG_MASK, },
> > -	{ .reg_offset = 1, .mask = MUIC_INT2_VBVOLT_MASK, },
> > -	/* MUIC_INT3 interrupts */
> > -	{ .reg_offset = 2, .mask = MUIC_INT3_OVP_MASK, },
> > -};
> > -
> > -static const struct regmap_irq_chip max8997_irq_chip_muic = {
> > -	.name			= "max8997-muic",
> > -	.status_base		= MAX8997_MUIC_REG_INT1,
> > -	.mask_base		= MAX8997_MUIC_REG_INTMASK1,
> > -	.mask_invert		= true,
> > -	.num_regs		= 3,
> > -	.irqs			= max8997_irqs_muic,
> > -	.num_irqs		= ARRAY_SIZE(max8997_irqs_muic),
> > -};
> >  
> >  /*
> >   * Only the common platform data elements for max8997 are parsed here from the
> > @@ -224,29 +176,6 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
> >  
> >  	mutex_init(&max8997->iolock);
> >  
> > -	max8997->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
> > -	if (!max8997->rtc) {
> > -		dev_err(max8997->dev, "Failed to allocate I2C device for RTC\n");
> > -		return -ENODEV;
> > -	}
> > -	i2c_set_clientdata(max8997->rtc, max8997);
> > -
> > -	max8997->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
> > -	if (!max8997->haptic) {
> > -		dev_err(max8997->dev, "Failed to allocate I2C device for Haptic\n");
> > -		ret = -ENODEV;
> > -		goto err_i2c_haptic;
> > -	}
> > -	i2c_set_clientdata(max8997->haptic, max8997);
> > -
> > -	max8997->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
> > -	if (!max8997->muic) {
> > -		dev_err(max8997->dev, "Failed to allocate I2C device for MUIC\n");
> > -		ret = -ENODEV;
> > -		goto err_i2c_muic;
> > -	}
> > -	i2c_set_clientdata(max8997->muic, max8997);
> > -
> >  	max8997->regmap = devm_regmap_init_i2c(i2c, &max8997_regmap_config);
> >  	if (IS_ERR(max8997->regmap)) {
> >  		ret = PTR_ERR(max8997->regmap);
> > @@ -255,50 +184,13 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
> >  		return ret;
> >  	}
> >  
> > -	max8997->regmap_rtc = devm_regmap_init_i2c(max8997->rtc,
> > -					&max8997_regmap_rtc_config);
> > -	if (IS_ERR(max8997->regmap_rtc)) {
> > -		ret = PTR_ERR(max8997->regmap_rtc);
> > -		dev_err(max8997->dev,
> > -				"failed to allocate register map: %d\n", ret);
> > -		goto err_regmap;
> > -	}
> > -
> > -	max8997->regmap_haptic = devm_regmap_init_i2c(max8997->haptic,
> > -					&max8997_regmap_haptic_config);
> > -	if (IS_ERR(max8997->regmap_haptic)) {
> > -		ret = PTR_ERR(max8997->regmap_haptic);
> > -		dev_err(max8997->dev,
> > -				"failed to allocate register map: %d\n", ret);
> > -		goto err_regmap;
> > -	}
> > -
> > -	max8997->regmap_muic = devm_regmap_init_i2c(max8997->muic,
> > -					&max8997_regmap_muic_config);
> > -	if (IS_ERR(max8997->regmap_muic)) {
> > -		ret = PTR_ERR(max8997->regmap_muic);
> > -		dev_err(max8997->dev,
> > -				"failed to allocate register map: %d\n", ret);
> > -		goto err_regmap;
> > -	}
> > -
> >  	ret = regmap_add_irq_chip(max8997->regmap, max8997->irq,
> >  				IRQF_ONESHOT | IRQF_SHARED |
> >  				IRQF_TRIGGER_FALLING, 0,
> >  				&max8997_irq_chip, &max8997->irq_data);
> >  	if (ret) {
> >  		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
> > -		goto err_regmap;
> > -	}
> > -
> > -	ret = regmap_add_irq_chip(max8997->regmap_muic, max8997->irq,
> > -				IRQF_ONESHOT | IRQF_SHARED |
> > -				IRQF_TRIGGER_FALLING, 0,
> > -				&max8997_irq_chip_muic,
> > -				&max8997->irq_data_muic);
> > -	if (ret) {
> > -		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
> > -		goto err_irq_muic;
> > +		return ret;
> >  	}
> >  
> >  	pm_runtime_set_active(max8997->dev);
> > @@ -323,15 +215,7 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
> >  
> >  err_mfd:
> >  	mfd_remove_devices(max8997->dev);
> > -	regmap_del_irq_chip(max8997->irq, max8997->irq_data_muic);
> > -err_irq_muic:
> >  	regmap_del_irq_chip(max8997->irq, max8997->irq_data);
> > -err_regmap:
> > -	i2c_unregister_device(max8997->muic);
> > -err_i2c_muic:
> > -	i2c_unregister_device(max8997->haptic);
> > -err_i2c_haptic:
> > -	i2c_unregister_device(max8997->rtc);
> >  	return ret;
> >  }
> >  
> > @@ -341,13 +225,8 @@ static int max8997_i2c_remove(struct i2c_client *i2c)
> >  
> >  	mfd_remove_devices(max8997->dev);
> >  
> > -	regmap_del_irq_chip(max8997->irq, max8997->irq_data_muic);
> >  	regmap_del_irq_chip(max8997->irq, max8997->irq_data);
> >  
> > -	i2c_unregister_device(max8997->muic);
> > -	i2c_unregister_device(max8997->haptic);
> > -	i2c_unregister_device(max8997->rtc);
> > -
> >  	return 0;
> >  }
> >  
> > @@ -483,34 +362,6 @@ static u8 max8997_dumpaddr_pmic[] = {
> >  	MAX8997_REG_DVSOKTIMER5,
> >  };
> >  
> > -static u8 max8997_dumpaddr_muic[] = {
> > -	MAX8997_MUIC_REG_INTMASK1,
> > -	MAX8997_MUIC_REG_INTMASK2,
> > -	MAX8997_MUIC_REG_INTMASK3,
> > -	MAX8997_MUIC_REG_CDETCTRL,
> > -	MAX8997_MUIC_REG_CONTROL1,
> > -	MAX8997_MUIC_REG_CONTROL2,
> > -	MAX8997_MUIC_REG_CONTROL3,
> > -};
> > -
> > -static u8 max8997_dumpaddr_haptic[] = {
> > -	MAX8997_HAPTIC_REG_CONF1,
> > -	MAX8997_HAPTIC_REG_CONF2,
> > -	MAX8997_HAPTIC_REG_DRVCONF,
> > -	MAX8997_HAPTIC_REG_CYCLECONF1,
> > -	MAX8997_HAPTIC_REG_CYCLECONF2,
> > -	MAX8997_HAPTIC_REG_SIGCONF1,
> > -	MAX8997_HAPTIC_REG_SIGCONF2,
> > -	MAX8997_HAPTIC_REG_SIGCONF3,
> > -	MAX8997_HAPTIC_REG_SIGCONF4,
> > -	MAX8997_HAPTIC_REG_SIGDC1,
> > -	MAX8997_HAPTIC_REG_SIGDC2,
> > -	MAX8997_HAPTIC_REG_SIGPWMDC1,
> > -	MAX8997_HAPTIC_REG_SIGPWMDC2,
> > -	MAX8997_HAPTIC_REG_SIGPWMDC3,
> > -	MAX8997_HAPTIC_REG_SIGPWMDC4,
> > -};
> > -
> >  static int max8997_freeze(struct device *dev)
> >  {
> >  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> > @@ -521,15 +372,6 @@ static int max8997_freeze(struct device *dev)
> >  		regmap_read(max8997->regmap, max8997_dumpaddr_pmic[i],
> >  				&max8997->reg_dump[i]);
> >  
> > -	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
> > -		regmap_read(max8997->regmap_muic, max8997_dumpaddr_muic[i],
> > -				&max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
> > -
> > -	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
> > -		regmap_read(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
> > -				&max8997->reg_dump[i + MAX8997_REG_PMIC_END +
> > -				MAX8997_MUIC_REG_END]);
> > -
> >  	return 0;
> >  }
> >  
> > @@ -543,15 +385,6 @@ static int max8997_restore(struct device *dev)
> >  		regmap_write(max8997->regmap, max8997_dumpaddr_pmic[i],
> >  				max8997->reg_dump[i]);
> >  
> > -	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_muic); i++)
> > -		regmap_write(max8997->regmap_muic, max8997_dumpaddr_muic[i],
> > -				max8997->reg_dump[i + MAX8997_REG_PMIC_END]);
> > -
> > -	for (i = 0; i < ARRAY_SIZE(max8997_dumpaddr_haptic); i++)
> > -		regmap_write(max8997->regmap_haptic, max8997_dumpaddr_haptic[i],
> > -				max8997->reg_dump[i + MAX8997_REG_PMIC_END +
> > -				MAX8997_MUIC_REG_END]);
> > -
> >  	return 0;
> >  }
> >  
> > diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
> > index 22769ea..57fab040 100644
> > --- a/drivers/rtc/rtc-max8997.c
> > +++ b/drivers/rtc/rtc-max8997.c
> > @@ -69,12 +69,20 @@ enum {
> >  struct max8997_rtc_info {
> >  	struct device		*dev;
> >  	struct max8997_dev	*max8997;
> > +	struct i2c_client	*i2c;
> > +	struct regmap		*regmap;
> >  	struct rtc_device	*rtc_dev;
> >  	struct mutex		lock;
> >  	int virq;
> >  	int rtc_24hr_mode;
> >  };
> >  
> > +static const struct regmap_config max8997_rtc_regmap_config = {
> > +	.reg_bits = 8,
> > +	.val_bits = 8,
> > +	.max_register = MAX8997_RTC_REG_END,
> > +};
> > +
> >  static void max8997_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
> >  				   int rtc_24hr_mode)
> >  {
> > @@ -118,8 +126,7 @@ static inline int max8997_rtc_set_update_reg(struct max8997_rtc_info *info)
> >  {
> >  	int ret;
> >  
> > -	ret = regmap_write(info->max8997->regmap_rtc,
> > -				MAX8997_RTC_UPDATE1, RTC_UDR_MASK);
> > +	ret = regmap_write(info->regmap, MAX8997_RTC_UPDATE1, RTC_UDR_MASK);
> >  	if (ret < 0)
> >  		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
> >  				__func__, ret);
> > @@ -140,7 +147,7 @@ static int max8997_rtc_read_time(struct device *dev, struct rtc_time *tm)
> >  	int ret;
> >  
> >  	mutex_lock(&info->lock);
> > -	ret = regmap_bulk_read(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_read(info->regmap,
> >  				MAX8997_RTC_SEC, data, RTC_NR_TIME);
> >  	mutex_unlock(&info->lock);
> >  
> > @@ -167,7 +174,7 @@ static int max8997_rtc_set_time(struct device *dev, struct rtc_time *tm)
> >  
> >  	mutex_lock(&info->lock);
> >  
> > -	ret = regmap_bulk_write(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_write(info->regmap,
> >  				MAX8997_RTC_SEC, data, RTC_NR_TIME);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to write time reg(%d)\n", __func__,
> > @@ -190,7 +197,7 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> >  
> >  	mutex_lock(&info->lock);
> >  
> > -	ret = regmap_bulk_read(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_read(info->regmap,
> >  				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s:%d fail to read alarm reg(%d)\n",
> > @@ -209,8 +216,7 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> >  	}
> >  
> >  	alrm->pending = 0;
> > -	ret = regmap_read(info->max8997->regmap_rtc,
> > -			       MAX8997_REG_STATUS1, &val);
> > +	ret = regmap_read(info->regmap, MAX8997_REG_STATUS1, &val);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
> >  				__func__, __LINE__, ret);
> > @@ -233,7 +239,7 @@ static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
> >  	if (!mutex_is_locked(&info->lock))
> >  		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
> >  
> > -	ret = regmap_bulk_read(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_read(info->regmap,
> >  				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
> > @@ -244,7 +250,7 @@ static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
> >  	for (i = 0; i < RTC_NR_TIME; i++)
> >  		data[i] &= ~ALARM_ENABLE_MASK;
> >  
> > -	ret = regmap_bulk_write(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_write(info->regmap,
> >  				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
> > @@ -265,7 +271,7 @@ static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
> >  	if (!mutex_is_locked(&info->lock))
> >  		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
> >  
> > -	ret = regmap_bulk_read(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_read(info->regmap,
> >  				MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
> > @@ -284,7 +290,7 @@ static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
> >  	if (data[RTC_DATE] & 0x1f)
> >  		data[RTC_DATE] |= (1 << ALARM_ENABLE_SHIFT);
> >  
> > -	ret = regmap_bulk_write(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_write(info->regmap,
> >  				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
> > @@ -316,7 +322,7 @@ static int max8997_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
> >  	if (ret < 0)
> >  		goto out;
> >  
> > -	ret = regmap_bulk_write(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_write(info->regmap,
> >  				 MAX8997_RTC_ALARM1_SEC, data, RTC_NR_TIME);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
> > @@ -388,7 +394,7 @@ static void max8997_rtc_enable_wtsr(struct max8997_rtc_info *info, bool enable)
> >  	dev_info(info->dev, "%s: %s WTSR\n", __func__,
> >  			enable ? "enable" : "disable");
> >  
> > -	ret = regmap_update_bits(info->max8997->regmap_rtc,
> > +	ret = regmap_update_bits(info->regmap,
> >  				 MAX8997_RTC_WTSR_SMPL, mask, val);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
> > @@ -417,7 +423,7 @@ static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
> >  	dev_info(info->dev, "%s: %s SMPL\n", __func__,
> >  			enable ? "enable" : "disable");
> >  
> > -	ret = regmap_update_bits(info->max8997->regmap_rtc,
> > +	ret = regmap_update_bits(info->regmap,
> >  				 MAX8997_RTC_WTSR_SMPL, mask, val);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
> > @@ -428,8 +434,7 @@ static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
> >  	max8997_rtc_set_update_reg(info);
> >  
> >  	val = 0;
> > -	regmap_read(info->max8997->regmap_rtc,
> > -			 MAX8997_RTC_WTSR_SMPL, &val);
> > +	regmap_read(info->regmap, MAX8997_RTC_WTSR_SMPL, &val);
> >  	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
> >  }
> >  
> > @@ -444,7 +449,7 @@ static int max8997_rtc_init_reg(struct max8997_rtc_info *info)
> >  
> >  	info->rtc_24hr_mode = 1;
> >  
> > -	ret = regmap_bulk_write(info->max8997->regmap_rtc,
> > +	ret = regmap_bulk_write(info->regmap,
> >  				 MAX8997_RTC_CTRLMASK, data, 2);
> >  	if (ret < 0) {
> >  		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
> > @@ -471,13 +476,28 @@ static int max8997_rtc_probe(struct platform_device *pdev)
> >  	info->dev = &pdev->dev;
> >  	info->max8997 = max8997;
> >  
> > +	info->i2c = i2c_new_dummy(max8997->i2c->adapter, MAX8997_I2C_ADDR_RTC);
> > +	if (!info->i2c) {
> > +		dev_err(info->dev, "failed to allocate I2C device\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	info->regmap = devm_regmap_init_i2c(info->i2c,
> > +					&max8997_rtc_regmap_config);
> > +	if (IS_ERR(info->regmap)) {
> > +		ret = PTR_ERR(info->regmap);
> > +		dev_err(info->dev,
> > +				"failed to allocate register map: %d\n", ret);
> > +		goto err_regmap;
> > +	}
> > +
> >  	platform_set_drvdata(pdev, info);
> >  
> >  	ret = max8997_rtc_init_reg(info);
> >  
> >  	if (ret < 0) {
> >  		dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
> > -		return ret;
> > +		goto err_regmap;
> >  	}
> >  
> >  	max8997_rtc_enable_wtsr(info, true);
> > @@ -491,28 +511,41 @@ static int max8997_rtc_probe(struct platform_device *pdev)
> >  	if (IS_ERR(info->rtc_dev)) {
> >  		ret = PTR_ERR(info->rtc_dev);
> >  		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
> > -		return ret;
> > +		goto err_regmap;
> >  	}
> >  
> >  	virq = regmap_irq_get_virq(max8997->irq_data, MAX8997_PMICIRQ_RTCA1);
> >  	if (!virq) {
> >  		dev_err(&pdev->dev, "Failed to create mapping alarm IRQ\n");
> >  		ret = -ENXIO;
> > -		goto err_out;
> > +		goto err_regmap;
> >  	}
> >  	info->virq = virq;
> >  
> >  	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
> >  				max8997_rtc_alarm_irq, 0,
> >  				"rtc-alarm0", info);
> > -	if (ret < 0)
> > +	if (ret < 0) {
> >  		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
> >  			info->virq, ret);
> > +		goto err_regmap;
> > +	}
> > +
> > +	return ret;
> >  
> > -err_out:
> > +err_regmap:
> > +	i2c_unregister_device(info->i2c);
> >  	return ret;
> >  }
> >  
> > +static int max8997_rtc_remove(struct platform_device *pdev)
> > +{
> > +	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
> > +	i2c_unregister_device(info->i2c);
> > +
> > +	return 0;
> > +}
> > +
> >  static void max8997_rtc_shutdown(struct platform_device *pdev)
> >  {
> >  	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
> > @@ -532,6 +565,7 @@ static struct platform_driver max8997_rtc_driver = {
> >  		.owner	= THIS_MODULE,
> >  	},
> >  	.probe		= max8997_rtc_probe,
> > +	.remove		= max8997_rtc_remove,
> >  	.shutdown	= max8997_rtc_shutdown,
> >  	.id_table	= rtc_id,
> >  };
> > diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
> > index 2817fa6..c2458c3 100644
> > --- a/include/linux/mfd/max8997-private.h
> > +++ b/include/linux/mfd/max8997-private.h
> > @@ -26,6 +26,13 @@
> >  #include <linux/export.h>
> >  #include <linux/irqdomain.h>
> >  
> > +#define MAX8997_I2C_ADDR_PMIC		(0xCC >> 1)
> > +#define MAX8997_I2C_ADDR_MUIC		(0x4A >> 1)
> > +#define MAX8997_I2C_ADDR_BATTERY	(0x6C >> 1)
> > +#define MAX8997_I2C_ADDR_RTC		(0x0C >> 1)
> > +#define MAX8997_I2C_ADDR_HAPTIC		(0x90 >> 1)
> > +
> > +
> >  #define MAX8997_REG_INVALID	(0xff)
> >  
> >  enum max8997_pmic_reg {
> > @@ -430,21 +437,14 @@ struct max8997_dev {
> >  	struct device *dev;
> >  	struct max8997_platform_data *pdata;
> >  	struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
> > -	struct i2c_client *rtc; /* slave addr 0x0c */
> > -	struct i2c_client *haptic; /* slave addr 0x90 */
> > -	struct i2c_client *muic; /* slave addr 0x4a */
> >  	struct mutex iolock;
> >  
> >  	unsigned long type;
> >  	struct platform_device *battery; /* battery control (not fuel gauge) */
> >  
> >  	struct regmap *regmap;
> > -	struct regmap *regmap_rtc;
> > -	struct regmap *regmap_haptic;
> > -	struct regmap *regmap_muic;
> >  
> >  	struct regmap_irq_chip_data *irq_data;
> > -	struct regmap_irq_chip_data *irq_data_muic;
> >  	int irq;
> >  	int ono;
> >  	struct mutex irqlock;
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
