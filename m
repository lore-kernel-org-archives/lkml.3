Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaCLO03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:26:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65182 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaCLO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:26:24 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-ce-53206e8831ae
Message-id: <1394634375.11860.8.camel@AMDC1943>
Subject: Re: [PATCH v2 2/3] mfd: max8997: handle IRQs using regmap
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Wed, 12 Mar 2014 15:26:15 +0100
In-reply-to: <1394631466-6429-3-git-send-email-r.baldyga@samsung.com>
References: <1394631466-6429-1-git-send-email-r.baldyga@samsung.com>
 <1394631466-6429-3-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t/xK7odeQrBBoeWGVksuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi/tfjzJafLvSwWRx89M3VovLu+awWWx9s47R
	Yu2Ru+wWtxtXsFlc23uc2eLB4Z3sFrt3PWW12N/ZwWhxupvVQdhj56y77B57Jp5k89i8Qstj
	06pONo871/awecw7GeixZ/4PVo++LasYPabP+8nk8XmTnMf6LVuZArijuGxSUnMyy1KL9O0S
	uDKmvmliLFiqWdHUeIGxgXGaYhcjJ4eEgIlE0/65bBC2mMSFe+uBbC4OIYGljBJrP9xjgnA+
	M0r09sxlBKniFdCXODzvPhOILSzgJNG1/ywriM0mYCyxefkSsEkiAloSdz7OZwdpZhY4zCyx
	70EHWBGLgKrEhYkzWEBsTgFXiXWXz4I1CAnUS+yceQPMZhZQl5g0bxEzxElKErvbO9kh4vIS
	m9e8ZYY4QlDix+R7LBMYBWYhaZmFpGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3
	MULi8ssOxsXHrA4xCnAwKvHwzlCSDxZiTSwrrsw9xCjBwawkwtucqxAsxJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgTHno2z4bovp00W9lv9O7WScfOCftuiRuYY2S6f1TqvUtFNv8/8wu7fhapoM
	O8/2RBHeWSryazhmV+46ZHzq7t0PIuVv2yZ1aZ+17Zr7yOWz7K22Ar9n70of/Z0YJ7zkY9cS
	1e0uRZ3XQ/WX2m+65LJzk/90M5/cR8dPp3+5IRYpX3F+Bm/d7RdKLMUZiYZazEXFiQA488Om
	qQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2014-03-12 at 14:37 +0100, Robert Baldyga wrote:
> This patch modifies mfd driver to use regmap for handling interrupts.
> It allows to simplify irq handling process. This modifications needed
> to make small changes in function drivers, which use interrupts.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

(...)

> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index 782d7c9..26a360d 100644
> --- a/drivers/mfd/max8997.c
> +++ b/drivers/mfd/max8997.c
> @@ -64,6 +64,49 @@ static const struct regmap_config max8997_regmap_config = {
>  	.max_register = MAX8997_REG_PMIC_END,
>  };
>  
> +static const struct regmap_irq max8997_irqs[] = {
> +	/* PMIC_INT1 interrupts */
> +	{ .reg_offset = 0, .mask = PMIC_INT1_PWRONR_MASK, },
> +	{ .reg_offset = 0, .mask = PMIC_INT1_PWRONF_MASK, },
> +	{ .reg_offset = 0, .mask = PMIC_INT1_PWRON1SEC_MASK, },
> +	{ .reg_offset = 0, .mask = PMIC_INT1_JIGONR_MASK, },
> +	{ .reg_offset = 0, .mask = PMIC_INT1_JIGONF_MASK, },
> +	{ .reg_offset = 0, .mask = PMIC_INT1_LOWBAT2_MASK, },
> +	{ .reg_offset = 0, .mask = PMIC_INT1_LOWBAT1_MASK, },
> +	/* PMIC_INT2 interrupts */
> +	{ .reg_offset = 1, .mask = PMIC_INT2_JIGR_MASK, },
> +	{ .reg_offset = 1, .mask = PMIC_INT2_JIGF_MASK, },
> +	{ .reg_offset = 1, .mask = PMIC_INT2_MR_MASK, },
> +	{ .reg_offset = 1, .mask = PMIC_INT2_DVS1OK_MASK, },
> +	{ .reg_offset = 1, .mask = PMIC_INT2_DVS2OK_MASK, },
> +	{ .reg_offset = 1, .mask = PMIC_INT2_DVS3OK_MASK, },
> +	{ .reg_offset = 1, .mask = PMIC_INT2_DVS4OK_MASK, },
> +	/* PMIC_INT3 interrupts */
> +	{ .reg_offset = 2, .mask = PMIC_INT3_CHGINS_MASK, },
> +	{ .reg_offset = 2, .mask = PMIC_INT3_CHGRM_MASK, },
> +	{ .reg_offset = 2, .mask = PMIC_INT3_DCINOVP_MASK, },
> +	{ .reg_offset = 2, .mask = PMIC_INT3_TOPOFFR_MASK, },
> +	{ .reg_offset = 2, .mask = PMIC_INT3_CHGRSTF_MASK, },
> +	{ .reg_offset = 2, .mask = PMIC_INT3_MBCHGTMEXPD_MASK, },
> +	/* PMIC_INT4 interrupts */
> +	{ .reg_offset = 3, .mask = PMIC_INT4_RTC60S_MASK, },
> +	{ .reg_offset = 3, .mask = PMIC_INT4_RTCA1_MASK, },
> +	{ .reg_offset = 3, .mask = PMIC_INT4_RTCA2_MASK, },
> +	{ .reg_offset = 3, .mask = PMIC_INT4_SMPL_INT_MASK, },
> +	{ .reg_offset = 3, .mask = PMIC_INT4_RTC1S_MASK, },
> +	{ .reg_offset = 3, .mask = PMIC_INT4_WTSR_MASK, },
> +};
> +
> +static const struct regmap_irq_chip max8997_irq_chip = {
> +	.name			= "max8997",
> +	.status_base		= MAX8997_REG_INT1,
> +	.mask_base		= MAX8997_REG_INT1MSK,
> +	.mask_invert		= false,
> +	.num_regs		= 4,
> +	.irqs			= max8997_irqs,
> +	.num_irqs		= ARRAY_SIZE(max8997_irqs),
> +};
> +
>  static const struct regmap_config max8997_regmap_rtc_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
> @@ -82,6 +125,31 @@ static const struct regmap_config max8997_regmap_muic_config = {
>  	.max_register = MAX8997_MUIC_REG_END,
>  };
>  
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
> +static const struct regmap_irq_chip max8997_irq_chip_muic = {
> +	.name			= "max8997-muic",
> +	.status_base		= MAX8997_MUIC_REG_INT1,
> +	.mask_base		= MAX8997_MUIC_REG_INTMASK1,
> +	.mask_invert		= true,
> +	.num_regs		= 3,
> +	.irqs			= max8997_irqs_muic,
> +	.num_irqs		= ARRAY_SIZE(max8997_irqs_muic),
> +};
> +
>  /*
>   * Only the common platform data elements for max8997 are parsed here from the
>   * device tree. Other sub-modules of max8997 such as pmic, rtc and others have
> @@ -214,9 +282,26 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  		goto err_regmap;
>  	}
>  
> -	pm_runtime_set_active(max8997->dev);
> +	ret = regmap_add_irq_chip(max8997->regmap, max8997->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max8997_irq_chip, &max8997->irq_data);
> +	if (ret) {
> +		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
> +		goto err_irq;
> +	}

In case of error here you shouldn't call regmap_del_irq_chip() so:
	goto err_regmap
The regmap_add_irq_chip() may fail before or AFTER setting the value
under max8997->irq_data. However in both error cases the memory stored
there will be freed already by regmap_add_irq_chip().

>  
> -	max8997_irq_init(max8997);
> +	ret = regmap_add_irq_chip(max8997->regmap_muic, max8997->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max8997_irq_chip_muic,
> +				&max8997->irq_data_muic);
> +	if (ret) {
> +		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
> +		goto err_irq_muic;

Same as above - on error remove only one regmap_irq_chip
(max8997->irq_data), not both.


Best regards,
Krzysztof


