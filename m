Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaCKOna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:43:30 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21506 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaCKOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:43:28 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-73-531f210dd415
Message-id: <1394549003.24263.15.camel@AMDC1943>
Subject: Re: [PATCH 2/3] mfd: max8997: handle IRQs using regmap
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, dmitry.torokhov@gmail.com, cooloney@gmail.com,
        rpurdie@rpsys.net, dbaryshkov@gmail.com, dwmw2@infradead.org,
        lgirdwood@gmail.com, broonie@kernel.org, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com
Date: Tue, 11 Mar 2014 15:43:23 +0100
In-reply-to: <1394546304-15191-3-git-send-email-r.baldyga@samsung.com>
References: <1394546304-15191-1-git-send-email-r.baldyga@samsung.com>
 <1394546304-15191-3-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t/xy7q8ivLBBl2PFCyWXLzKbjH14RM2
	i6M7JzJZXP/ynNVi0pP3zBaHF71gtJi4cjKzxf2vRxktvl3pYLK4+ekbq8XlXXPYLLa+Wcdo
	sfbIXXaL240r2Cyu7T3ObPHg8E52i927nrJa7O/sYLQ43c3qIOyxc9Zddo89E0+yeWxeoeWx
	aVUnm8eda3vYPOadDPTYM/8Hq0ffllWMHtPn/WTy+LxJzmP9lq1MAdxRXDYpqTmZZalF+nYJ
	XBkrN9kVXPKvmPLzC2sDY79DFyMnh4SAicSRcztYIGwxiQv31rN1MXJxCAksZZQ4ufkQM4Tz
	Gch5e5ipi5GDg1fAQOLcPHWQBmEBe4nuKy/AmtkEjCU2L1/CBmKLCGhJ3Pk4nx2kl1ngMLPE
	vgcdrCAJFgFVia8Lb7OBzOEUcJM4Os0XYn4jo8TWSTPBBjELqEtMmreIGeIiJYnd7Z3sEHF5
	ic1r3oLFeQUEJX5MvscygVFgFpKWWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/
	dxMjJCa/7GBcfMzqEKMAB6MSD+8Kf7lgIdbEsuLK3EOMEhzMSiK8yeLywUK8KYmVValF+fFF
	pTmpxYcYmTg4pRoYw7KXbWK9unJGfGS06XahRaH295NzeyMdJ4ebXP07h3kz413rPEshmyOi
	byT8vPyjtqvKrdk1LfD6iRTdoj+HWCcI65+btUzUda7rnsBpJ2eaHy2YXa4V8rSo2nqz5ZGv
	Hzpct2slrmjZ3a4dt3tt747D7ftCEp78cndbwHr9jd0uobffkhJ/KLEUZyQaajEXFScCAF8R
	YQGnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 14:58 +0100, Robert Baldyga wrote:
> This patch modifies mfd driver to use regmap for handling interrupts.
> It allows to simplify irq handling process. This modifications needed
> to make small changes in function drivers, which use interrupts.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |    3 +-
>  drivers/mfd/Makefile                |    2 +-
>  drivers/mfd/max8997-irq.c           |  373 -----------------------------------
>  drivers/mfd/max8997.c               |   91 ++++++++-
>  drivers/rtc/rtc-max8997.c           |    2 +-
>  include/linux/mfd/max8997-private.h |   63 +++++-
>  6 files changed, 147 insertions(+), 387 deletions(-)
>  delete mode 100644 drivers/mfd/max8997-irq.c

Add "select REGMAP_IRQ" in Kconfig.

(...)

> diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
> index ca6f310..9b6edfa 100644
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
> @@ -173,6 +241,15 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  		return ret;
>  	}
>  
> +	ret = regmap_add_irq_chip(max8997->regmap, max8997->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max8997_irq_chip, &max8997->irq_data);
> +	if (ret) {
> +		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
> +		return ret;
> +	}
> +

Add regmap_del_irq_chip() on driver remove and where needed on probe
error paths.

>  	max8997->regmap_rtc = devm_regmap_init_i2c(max8997->rtc,
>  					&max8997_regmap_rtc_config);
>  	if (IS_ERR(max8997->regmap_rtc)) {
> @@ -200,9 +277,17 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
>  		goto err_regmap;
>  	}
>  
> -	pm_runtime_set_active(max8997->dev);
> +	ret = regmap_add_irq_chip(max8997->regmap_muic, max8997->irq,
> +				IRQF_ONESHOT | IRQF_SHARED |
> +				IRQF_TRIGGER_FALLING, 0,
> +				&max8997_irq_chip_muic,
> +				&max8997->irq_data_muic);
> +	if (ret) {
> +		dev_err(max8997->dev, "failed to add irq chip: %d\n", ret);
> +		return ret;
> +	}
>  
> -	max8997_irq_init(max8997);
> +	pm_runtime_set_active(max8997->dev);
>  
>  	ret = mfd_add_devices(max8997->dev, -1, max8997_devs,
>  			ARRAY_SIZE(max8997_devs),
> @@ -464,7 +549,7 @@ static int max8997_resume(struct device *dev)
>  
>  	if (device_may_wakeup(dev))
>  		irq_set_irq_wake(max8997->irq, 0);
> -	return max8997_irq_resume(max8997);
> +	return 0;
>  }

Actually you're changing a little driver logic here. I think the
max8997_irq_resume() was here on purpose - to process any interrupts and
clear interrupt registers (e.g. MUIC from) after resuming. Is it working
properly during suspend/resume? Is it working when the MUIC interrupt is
the wake up source?
 

>  static const struct dev_pm_ops max8997_pm = {
> diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
> index b866f7d5..22769ea 100644
> --- a/drivers/rtc/rtc-max8997.c
> +++ b/drivers/rtc/rtc-max8997.c
> @@ -494,7 +494,7 @@ static int max8997_rtc_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> -	virq = irq_create_mapping(max8997->irq_domain, MAX8997_PMICIRQ_RTCA1);
> +	virq = regmap_irq_get_virq(max8997->irq_data, MAX8997_PMICIRQ_RTCA1);
>  	if (!virq) {
>  		dev_err(&pdev->dev, "Failed to create mapping alarm IRQ\n");
>  		ret = -ENXIO;
> diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
> index ea80ef8..af2f0aa 100644
> --- a/include/linux/mfd/max8997-private.h
> +++ b/include/linux/mfd/max8997-private.h
> @@ -333,6 +333,48 @@ enum max8997_irq_source {
>  	MAX8997_IRQ_GROUP_NR,
>  };
>  
> +#define PMIC_INT1_PWRONR_MASK		(0x1 << 0)
> +#define PMIC_INT1_PWRONF_MASK		(0x1 << 1)
> +#define PMIC_INT1_PWRON1SEC_MASK	(0x1 << 3)
> +#define PMIC_INT1_JIGONR_MASK		(0x1 << 4)
> +#define PMIC_INT1_JIGONF_MASK		(0x1 << 5)
> +#define PMIC_INT1_LOWBAT2_MASK		(0x1 << 6)
> +#define PMIC_INT1_LOWBAT1_MASK		(0x1 << 7)
> +
> +#define PMIC_INT2_JIGR_MASK		(0x1 << 0)
> +#define PMIC_INT2_JIGF_MASK		(0x1 << 1)
> +#define PMIC_INT2_MR_MASK		(0x1 << 2)
> +#define PMIC_INT2_DVS1OK_MASK		(0x1 << 3)
> +#define PMIC_INT2_DVS2OK_MASK		(0x1 << 4)
> +#define PMIC_INT2_DVS3OK_MASK		(0x1 << 5)
> +#define PMIC_INT2_DVS4OK_MASK		(0x1 << 6)
> +
> +#define PMIC_INT3_CHGINS_MASK		(0x1 << 0)
> +#define PMIC_INT3_CHGRM_MASK		(0x1 << 1)
> +#define PMIC_INT3_DCINOVP_MASK		(0x1 << 2)
> +#define PMIC_INT3_TOPOFFR_MASK		(0x1 << 3)
> +#define PMIC_INT3_CHGRSTF_MASK		(0x1 << 5)
> +#define PMIC_INT3_MBCHGTMEXPD_MASK	(0x1 << 7)
> +
> +#define PMIC_INT4_RTC60S_MASK		(0x1 << 0)
> +#define PMIC_INT4_RTCA1_MASK		(0x1 << 1)
> +#define PMIC_INT4_RTCA2_MASK		(0x1 << 2)
> +#define PMIC_INT4_SMPL_INT_MASK		(0x1 << 3)
> +#define PMIC_INT4_RTC1S_MASK		(0x1 << 4)
> +#define PMIC_INT4_WTSR_MASK		(0x1 << 5)
> +
> +#define MUIC_INT1_ADC_MASK		(0x1 << 0)
> +#define MUIC_INT1_ADCLow_MASK		(0x1 << 1)
> +#define MUIC_INT1_ADCError_MASK		(0x1 << 2)
> +
> +#define MUIC_INT2_ChgTyp_MASK		(0x1 << 0)
> +#define MUIC_INT2_ChgDetRun_MASK	(0x1 << 1)
> +#define MUIC_INT2_DCDTmr_MASK		(0x1 << 2)
> +#define MUIC_INT2_DBChg_MASK		(0x1 << 3)
> +#define MUIC_INT2_VBVolt_MASK		(0x1 << 4)

You changed here naming convention to CamelCase. Any reasons?

> +
> +#define MUIC_INT3_OVP_MASK		(0x1 << 2)
> +
>  enum max8997_irq {
>  	MAX8997_PMICIRQ_PWRONR,
>  	MAX8997_PMICIRQ_PWRONF,
> @@ -364,19 +406,23 @@ enum max8997_irq {
>  	MAX8997_PMICIRQ_RTC1S,
>  	MAX8997_PMICIRQ_WTSR,
>  
> -	MAX8997_MUICIRQ_ADCError,
> -	MAX8997_MUICIRQ_ADCLow,
> +	MAX8997_PMICIRQ_NR,
> +};
> +
> +enum max8997_irq_muic {
>  	MAX8997_MUICIRQ_ADC,
> +	MAX8997_MUICIRQ_ADCLow,
> +	MAX8997_MUICIRQ_ADCError,
>  
> -	MAX8997_MUICIRQ_VBVolt,
> -	MAX8997_MUICIRQ_DBChg,
> -	MAX8997_MUICIRQ_DCDTmr,
> -	MAX8997_MUICIRQ_ChgDetRun,
>  	MAX8997_MUICIRQ_ChgTyp,
> +	MAX8997_MUICIRQ_ChgDetRun,
> +	MAX8997_MUICIRQ_DCDTmr,
> +	MAX8997_MUICIRQ_DBChg,
> +	MAX8997_MUICIRQ_VBVolt,
>  
>  	MAX8997_MUICIRQ_OVP,
>  
> -	MAX8997_IRQ_NR,
> +	MAX8997_MUCIRQ_NR,
>  };

Camel shows up once again.

>  
>  #define MAX8997_NUM_GPIO	12
> @@ -397,9 +443,10 @@ struct max8997_dev {
>  	struct regmap *regmap_haptic;
>  	struct regmap *regmap_muic;
>  
> +	struct regmap_irq_chip_data *irq_data;
> +	struct regmap_irq_chip_data *irq_data_muic;
>  	int irq;
>  	int ono;
> -	struct irq_domain *irq_domain;
>  	struct mutex irqlock;
>  	int irq_masks_cur[MAX8997_IRQ_GROUP_NR];
>  	int irq_masks_cache[MAX8997_IRQ_GROUP_NR];

