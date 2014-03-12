Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaCLPLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:11:53 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18725 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaCLPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:11:50 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-0f-53207933faa5
Message-id: <1394637106.11860.16.camel@AMDC1943>
Subject: Re: [PATCH v2 3/3] mfd: max8997: move regmap handling to function
 drivers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Wed, 12 Mar 2014 16:11:46 +0100
In-reply-to: <1394631466-6429-4-git-send-email-r.baldyga@samsung.com>
References: <1394631466-6429-1-git-send-email-r.baldyga@samsung.com>
 <1394631466-6429-4-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xq7rGlQrBBheeW1ksuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi/tfjzJafLvSwWRx89M3VovLu+awWWx9s47R
	Yu2Ru+wWtxtXsFlc23uc2eLB4Z3sFrt3PWW12N/ZwWhxupvVQdhj56y77B57Jp5k89i8Qstj
	06pONo871/awecw7GeixZ/4PVo++LasYPabP+8nk8XmTnMf6LVuZArijuGxSUnMyy1KL9O0S
	uDJOzehhL9hjVbFn+WuWBsYDel2MnBwSAiYS83f0sUHYYhIX7q0Hsrk4hASWMkpsOf2cHcL5
	zCixr38hC0gVr4CBxLYLlxlBbGGBEImp09ezgthsAsYSm5cvAZskIqAlcefjfLBmZoHDzBL7
	HnSAFbEIqEo8PXwdrJlTwFVi8+vlYA1CAvUSny9uZgexmQXUJSbNW8QMcZKSxO72Tqi4vMTm
	NW+ZIY4QlPgx+R7LBEaBWUhaZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2M
	kLj8uoNx6TGrQ4wCHIxKPLwzleSDhVgTy4orcw8xSnAwK4nwPi1UCBbiTUmsrEotyo8vKs1J
	LT7EyMTBKdXAWCDAJvLn8WKTrlk851JDZU0Vn674xv90+el9d8sF1dfaXU+dMbdJ7cGBNu6b
	7icZXNVE+AsNZWuSS/9XyteFJd/5LNd2YXaVvZOM5aGkjJIv/L5/dk+/5ORUPfNBgf1hcxZN
	mfrvK27/2thycXVsZc//iFcTUifIft579sWXm5EZWbPXbDCep8RSnJFoqMVcVJwIANpC2eup	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 14:37 +0100, Robert Baldyga wrote:
> This patch moves code creating new i2c clients and regmaps to function
> drivers which use them. It allows to avoid creating this instances when
> individual function drivers are not enabled.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> 
> Conflicts:
> 
> 	drivers/mfd/max8997.c

You can strip out the conflict from commit message.

> ---
>  drivers/extcon/extcon-max8997.c     |  131 +++++++++++++++++++++++++--
>  drivers/input/misc/max8997_haptic.c |  117 +++++++++++++++++++-----
>  drivers/mfd/max8997.c               |  167 -----------------------------------
>  drivers/rtc/rtc-max8997.c           |   78 +++++++++++-----
>  include/linux/mfd/max8997-private.h |   14 +--
>  5 files changed, 283 insertions(+), 224 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> index 15fc5c0..42c9915 100644
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
> +	{ .reg_offset = 0, .mask = MUIC_INT1_ADCLOW_MASK, },
> +	{ .reg_offset = 0, .mask = MUIC_INT1_ADCERROR_MASK, },
> +	/* MUIC_INT2 interrupts */
> +	{ .reg_offset = 1, .mask = MUIC_INT2_CHGTYP_MASK, },
> +	{ .reg_offset = 1, .mask = MUIC_INT2_CHGDETRUN_MASK, },
> +	{ .reg_offset = 1, .mask = MUIC_INT2_DCDTMR_MASK, },
> +	{ .reg_offset = 1, .mask = MUIC_INT2_DBCHG_MASK, },
> +	{ .reg_offset = 1, .mask = MUIC_INT2_VBVOLT_MASK, },
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
> @@ -670,6 +706,31 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  	info->dev = &pdev->dev;
>  	info->max8997 = max8997;
>  
> +	info->i2c = i2c_new_dummy(max8997->i2c->adapter, MAX8997_I2C_ADDR_MUIC);
> +	if (!info->i2c) {
> +		dev_err(info->dev, "failed to allocate I2C device\n");
> +		return -ENODEV;
> +	}
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
> +		goto err_regmap_irq;
> +	}

Same issue as in patch 2/3 - regmap_del_irq_chip() shouldn't be called
when add fails.

> +
>  	platform_set_drvdata(pdev, info);
>  	mutex_init(&info->mutex);
>  
> @@ -679,8 +740,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  		struct max8997_muic_irq *muic_irq = &muic_irqs[i];
>  		unsigned int virq = 0;
>  
> -		virq = regmap_irq_get_virq(max8997->irq_data_muic,
> -					muic_irq->irq);
> +		virq = regmap_irq_get_virq(info->irq_data, muic_irq->irq);
>  		if (!virq) {
>  			ret = -EINVAL;
>  			goto err_irq;
> @@ -723,7 +783,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  
>  		/* Initialize registers according to platform data */
>  		for (i = 0; i < muic_pdata->num_init_data; i++) {
> -			regmap_write(info->max8997->regmap_muic,
> +			regmap_write(info->regmap,
>  					muic_pdata->init_data[i].addr,
>  					muic_pdata->init_data[i].data);
>  		}
> @@ -779,6 +839,10 @@ static int max8997_muic_probe(struct platform_device *pdev)
>  err_irq:
>  	while (--i >= 0)
>  		free_irq(muic_irqs[i].virq, info);
> +err_regmap_irq:
> +	regmap_del_irq_chip(info->max8997->irq, info->irq_data);
> +err_regmap:
> +	i2c_unregister_device(info->i2c);
>  	return ret;
>  }
>  
> @@ -787,6 +851,8 @@ static int max8997_muic_remove(struct platform_device *pdev)
>  	struct max8997_muic_info *info = platform_get_drvdata(pdev);
>  	int i;
>  
> +	regmap_del_irq_chip(info->max8997->irq, info->irq_data);
> +
>  	for (i = 0; i < ARRAY_SIZE(muic_irqs); i++)
>  		free_irq(muic_irqs[i].virq, info);

I think the order should be different: first free_irq() then
regmap_del_irq_chip(). At least this is logically expected as the
virtual irqs aren't useful without irq_chip.


Best regards,
Krzysztof


