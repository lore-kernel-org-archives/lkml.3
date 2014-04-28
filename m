Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaD1PB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:01:28 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56775 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348AbaD1PBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:01:24 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-e6-535e6d40eafe
Message-id: <1398697278.12945.19.camel@AMDC1943>
Subject: Re: [PATCH 2/2] mfd: max77693: handle IRQs using regmap
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com
Date: Mon, 28 Apr 2014 17:01:18 +0200
In-reply-to: <1398694103-29320-3-git-send-email-r.baldyga@samsung.com>
References: <1398694103-29320-1-git-send-email-r.baldyga@samsung.com>
 <1398694103-29320-3-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xa7oOuXHBBkvPilksuXiV3eL+16OM
	Fpd3zWGzWHvkLrvFg8M72S32d3YwWpzuZnVg99gz8SSbx51re9g85p0M9OjbsorRY/q8n0we
	nzfJBbBFcdmkpOZklqUW6dslcGX8n/ycrWCdS0XHivOMDYyfTboYOTkkBEwkOq49ZoGwxSQu
	3FvP1sXIxSEksJRRYkLzRHYI5zOjxKrrT5hBqngFDCQ6d64Es4UFHCSuHf3LBmKzCRhLbF6+
	BMwWEdCSuPNxPlgzs8BcRokdbz8zgiRYBFQl3u6fCdbMKeAm8fXJQ1YQW0igkVFi9RMNEJtZ
	QF1i0rxFzBAnKUvM23+MCWKxoMSPyfdYIGrkJTavecs8gVFgFpKWWUjKZiEpW8DIvIpRNLU0
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjJNy/7GBcfMzqEKMAB6MSD+8KhZhgIdbEsuLK3EOMEhzM
	SiK8omlxwUK8KYmVValF+fFFpTmpxYcYmTg4pRoYs0VLYk7OnSp2ysThgvdL05PBM1NCV9x6
	XWaSre0c7yuX9mm7yuGEvfoXeDJePFo45V4hH3eFkvbnI1OUU1+sXKk8c5umqIT5KfYdrw13
	1fcKyeUeX/bw+cJFB9u/9B6+suqqGa/Kb7mOHZG9CbL377d8uRyifqSrWOO1Z8fbxvpo4xZe
	80XSSizFGYmGWsxFxYkAS77ayFUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-04-28 at 16:08 +0200, Robert Baldyga wrote:
> This patch modifies mfd driver to use regmap for handling interrupts.
> It allows to simplify irq handling process. This modifications needed
> to make small changes in function drivers, which use interrupts.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max77693.c     |   3 +-
>  drivers/mfd/Kconfig                  |   1 +
>  drivers/mfd/Makefile                 |   2 +-
>  drivers/mfd/max77693-irq.c           | 337 -----------------------------------
>  drivers/mfd/max77693.c               | 158 ++++++++++++++--
>  include/linux/mfd/max77693-private.h |  47 ++++-
>  6 files changed, 196 insertions(+), 352 deletions(-)
>  delete mode 100644 drivers/mfd/max77693-irq.c

(...)

> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 6336251..8b2633d 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -55,12 +55,95 @@ static const struct regmap_config max77693_regmap_config = {
>  	.max_register = MAX77693_PMIC_REG_END,
>  };
>  
> +static const struct regmap_irq max77693_led_irqs[] = {
> +	{ .mask = LED_IRQ_FLED2_OPEN, },
> +	{ .mask = LED_IRQ_FLED2_SHORT, },
> +	{ .mask = LED_IRQ_FLED1_OPEN, },
> +	{ .mask = LED_IRQ_FLED1_SHORT, },
> +	{ .mask = LED_IRQ_MAX_FLASH, },
> +};
> +
> +static const struct regmap_irq_chip max77693_led_irq_chip = {
> +	.name                   = "max77693-led",
> +	.status_base            = MAX77693_LED_REG_FLASH_INT,
> +	.mask_base              = MAX77693_LED_REG_FLASH_INT_MASK,
> +	.mask_invert            = false,
> +	.num_regs               = 1,
> +	.irqs                   = max77693_led_irqs,
> +	.num_irqs               = ARRAY_SIZE(max77693_led_irqs),
> +};
> +
> +static const struct regmap_irq max77693_topsys_irqs[] = {
> +	{ .mask = TOPSYS_IRQ_T120C_INT, },
> +	{ .mask = TOPSYS_IRQ_T140C_INT, },
> +	{ .mask = TOPSYS_IRQ_LOWSYS_INT, },
> +};
> +
> +static const struct regmap_irq_chip max77693_topsys_irq_chip = {
> +	.name                   = "max77693-topsys",
> +	.status_base            = MAX77693_PMIC_REG_TOPSYS_INT,
> +	.mask_base              = MAX77693_PMIC_REG_TOPSYS_INT_MASK,
> +	.mask_invert            = false,
> +	.num_regs               = 1,
> +	.irqs                   = max77693_topsys_irqs,
> +	.num_irqs               = ARRAY_SIZE(max77693_topsys_irqs),
> +};
> +
> +static const struct regmap_irq max77693_charger_irqs[] = {
> +	{ .mask = CHG_IRQ_BYP_I, },
> +	{ .mask = CHG_IRQ_THM_I, },
> +	{ .mask = CHG_IRQ_BAT_I, },
> +	{ .mask = CHG_IRQ_CHG_I, },
> +	{ .mask = CHG_IRQ_CHGIN_I, },
> +};
> +
> +static const struct regmap_irq_chip max77693_charger_irq_chip = {
> +	.name                   = "max77693-charger",
> +	.status_base            = MAX77693_CHG_REG_CHG_INT,
> +	.mask_base              = MAX77693_CHG_REG_CHG_INT_MASK,
> +	.mask_invert            = false,
> +	.num_regs               = 1,
> +	.irqs                   = max77693_charger_irqs,
> +	.num_irqs               = ARRAY_SIZE(max77693_charger_irqs),
> +};
> +
>  static const struct regmap_config max77693_regmap_muic_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  	.max_register = MAX77693_MUIC_REG_END,
>  };
>  
> +static const struct regmap_irq max77693_muic_irqs[] = {
> +	{ .reg_offset = 0, .mask = MUIC_IRQ_INT1_ADC, },
> +	{ .reg_offset = 0, .mask = MUIC_IRQ_INT1_ADC_LOW, },
> +	{ .reg_offset = 0, .mask = MUIC_IRQ_INT1_ADC_ERR, },
> +	{ .reg_offset = 0, .mask = MUIC_IRQ_INT1_ADC1K, },
> +
> +	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_CHGTYP, },
> +	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_CHGDETREUN, },
> +	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_DCDTMR, },
> +	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_DXOVP, },
> +	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_VBVOLT, },
> +	{ .reg_offset = 1, .mask = MUIC_IRQ_INT2_VIDRM, },
> +
> +	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_EOC, },
> +	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_CGMBC, },
> +	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_OVP, },
> +	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_MBCCHG_ERR, },
> +	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_CHG_ENABLED, },
> +	{ .reg_offset = 2, .mask = MUIC_IRQ_INT3_BAT_DET, },
> +};
> +
> +static const struct regmap_irq_chip max77693_muic_irq_chip = {
> +	.name                   = "max77693-muic",
> +	.status_base            = MAX77693_MUIC_REG_INT1,
> +	.mask_base              = MAX77693_MUIC_REG_INTMASK1,
> +	.mask_invert            = true,
> +	.num_regs               = 3,
> +	.irqs                   = max77693_muic_irqs,
> +	.num_irqs               = ARRAY_SIZE(max77693_muic_irqs),
> +};
> +
>  static int max77693_i2c_probe(struct i2c_client *i2c,
>  			      const struct i2c_device_id *id)
>  {
> @@ -124,9 +207,45 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  		goto err_regmap_muic;
>  	}
>  
> -	ret = max77693_irq_init(max77693);
> -	if (ret < 0)
> -		goto err_irq;
> +	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max77693_led_irq_chip,
> +				&max77693->irq_data_led);
> +	if (ret) {
> +		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
> +		goto err_regmap_muic;
> +	}
> +
> +	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max77693_topsys_irq_chip,
> +				&max77693->irq_data_topsys);
> +	if (ret) {
> +		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
> +		goto err_irq_topsys;
> +	}
> +
> +	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max77693_charger_irq_chip,
> +				&max77693->irq_data_charger);
> +	if (ret) {
> +		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
> +		goto err_irq_charger;
> +	}
> +
> +	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max77693_muic_irq_chip,
> +				&max77693->irq_data_muic);
> +	if (ret) {
> +		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
> +		goto err_irq_muic;
> +	}
>  
>  	pm_runtime_set_active(max77693->dev);
>  
> @@ -138,8 +257,14 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
>  	return ret;
>  
>  err_mfd:
> -	max77693_irq_exit(max77693);
> -err_irq:
> +	mfd_remove_devices(max77693->dev);

Hmmm... The mfd_add_devices() calls mfd_remove_devices() on failure so
why calling it also here?

> +	regmap_del_irq_chip(max77693->irq, max77693->irq_data_muic);
> +err_irq_muic:
> +	regmap_del_irq_chip(max77693->irq, max77693->irq_data_charger);
> +err_irq_charger:
> +	regmap_del_irq_chip(max77693->irq, max77693->irq_data_topsys);
> +err_irq_topsys:
> +	regmap_del_irq_chip(max77693->irq, max77693->irq_data_led);
>  err_regmap_muic:
>  	i2c_unregister_device(max77693->haptic);
>  err_i2c_haptic:
> @@ -152,7 +277,12 @@ static int max77693_i2c_remove(struct i2c_client *i2c)
>  	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
>  
>  	mfd_remove_devices(max77693->dev);
> -	max77693_irq_exit(max77693);
> +
> +	regmap_del_irq_chip(max77693->irq, max77693->irq_data_muic);
> +	regmap_del_irq_chip(max77693->irq, max77693->irq_data_charger);
> +	regmap_del_irq_chip(max77693->irq, max77693->irq_data_topsys);
> +	regmap_del_irq_chip(max77693->irq, max77693->irq_data_led);
> +
>  	i2c_unregister_device(max77693->muic);
>  	i2c_unregister_device(max77693->haptic);
>  
> @@ -170,8 +300,11 @@ static int max77693_suspend(struct device *dev)
>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>  	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
>  
> -	if (device_may_wakeup(dev))
> -		irq_set_irq_wake(max77693->irq, 1);
> +	if (device_may_wakeup(dev)) {
> +		enable_irq_wake(max77693->irq);
> +		disable_irq(max77693->irq);
> +	}

The disable_irq() should be called regardless of wakeup source. Actually
I could reproduce error even when the driver was not a wakeup source.

> +
>  	return 0;
>  }
>  
> @@ -180,9 +313,12 @@ static int max77693_resume(struct device *dev)
>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>  	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
>  
> -	if (device_may_wakeup(dev))
> -		irq_set_irq_wake(max77693->irq, 0);
> -	return max77693_irq_resume(max77693);
> +	if (device_may_wakeup(dev)) {
> +		disable_irq_wake(max77693->irq);
> +		enable_irq(max77693->irq);

Same here.

Best regards,
Krzysztof


