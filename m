Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaDPHAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:00:55 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39826 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaDPHAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:00:52 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <534DD943.8050707@samsung.com>
References: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com> <1397466426-13870-2-git-send-email-cw00.choi@samsung.com> <534DD943.8050707@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCHv2 1/2] iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 16 Apr 2014 08:00:42 +0100
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: ch.naveen@samsung.com, kgene.kim@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Message-ID: <01dbc4c9-3e34-4e76-b3d8-6f126b9761a7@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On April 16, 2014 2:13:39 AM GMT+01:00, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>Hi Jonathan,
>
>Any comment of this patchset?
>
>Best Regards,
>Chanwoo Choi
Hi Chanwoo

Not got to it yet I'm afraid. May be sometime next week before I do.

Jonathan
>
>On 04/14/2014 06:07 PM, Chanwoo Choi wrote:
>> This patch control special clock for ADC in Exynos series's FSYS
>block.
>> If special clock of ADC is registerd on clock list of common clk
>framework,
>> Exynos ADC drvier have to control this clock.
>> 
>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>> - 'adc' clock: bus clock for ADC
>> 
>> Exynos3250 has additional 'sclk_tsadc' clock as following:
>> - 'sclk_tsadc' clock: special clock for ADC which provide clock to
>internal ADC
>> 
>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included
>'sclk_tsadc' clock
>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included
>'sclk_tsadc'
>> clock in FSYS_BLK.
>> 
>> Cc: Jonathan Cameron <jic23@kernel.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Naveen Krishna Chatradhi
>> Cc: linux-iio@vger.kernel.org
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/iio/adc/exynos_adc.c | 54
>+++++++++++++++++++++++++++++++++-----------
>>  1 file changed, 41 insertions(+), 13 deletions(-)
>> 
>> diff --git a/drivers/iio/adc/exynos_adc.c
>b/drivers/iio/adc/exynos_adc.c
>> index d25b262..3c99243 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -40,8 +40,9 @@
>>  #include <linux/iio/driver.h>
>>  
>>  enum adc_version {
>> -	ADC_V1,
>> -	ADC_V2
>> +	ADC_V1 = 0x1,
>> +	ADC_V2 = 0x2,
>> +	ADC_V3 = (ADC_V1 | ADC_V2),
>>  };
>>  
>>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
>> @@ -88,6 +89,7 @@ struct exynos_adc {
>>  	void __iomem		*regs;
>>  	void __iomem		*enable_reg;
>>  	struct clk		*clk;
>> +	struct clk		*sclk;
>>  	unsigned int		irq;
>>  	struct regulator	*vdd;
>>  
>> @@ -100,6 +102,7 @@ struct exynos_adc {
>>  static const struct of_device_id exynos_adc_match[] = {
>>  	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>>  	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
>> +	{ .compatible = "samsung,exynos-adc-v3", .data = (void *)ADC_V3 },
>>  	{},
>>  };
>>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
>> @@ -128,7 +131,7 @@ static int exynos_read_raw(struct iio_dev
>*indio_dev,
>>  	mutex_lock(&indio_dev->mlock);
>>  
>>  	/* Select the channel to be used and Trigger conversion */
>> -	if (info->version == ADC_V2) {
>> +	if (info->version & ADC_V2) {
>>  		con2 = readl(ADC_V2_CON2(info->regs));
>>  		con2 &= ~ADC_V2_CON2_ACH_MASK;
>>  		con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
>> @@ -165,7 +168,7 @@ static irqreturn_t exynos_adc_isr(int irq, void
>*dev_id)
>>  	info->value = readl(ADC_V1_DATX(info->regs)) &
>>  						ADC_DATX_MASK;
>>  	/* clear irq */
>> -	if (info->version == ADC_V2)
>> +	if (info->version & ADC_V2)
>>  		writel(1, ADC_V2_INT_ST(info->regs));
>>  	else
>>  		writel(1, ADC_V1_INTCLR(info->regs));
>> @@ -226,11 +229,25 @@ static int exynos_adc_remove_devices(struct
>device *dev, void *c)
>>  	return 0;
>>  }
>>  
>> +static void exynos_adc_enable_clock(struct exynos_adc *info, bool
>enable)
>> +{
>> +	if (enable) {
>> +		clk_prepare_enable(info->clk);
>> +		if (info->version == ADC_V3)
>> +			clk_prepare_enable(info->sclk);
>> +
>> +	} else {
>> +		if (info->version == ADC_V3)
>> +			clk_disable_unprepare(info->sclk);
>> +		clk_disable_unprepare(info->clk);
>> +	}
>> +}
>> +
>>  static void exynos_adc_hw_init(struct exynos_adc *info)
>>  {
>>  	u32 con1, con2;
>>  
>> -	if (info->version == ADC_V2) {
>> +	if (info->version & ADC_V2) {
>>  		con1 = ADC_V2_CON1_SOFT_RESET;
>>  		writel(con1, ADC_V2_CON1(info->regs));
>>  
>> @@ -300,6 +317,8 @@ static int exynos_adc_probe(struct
>platform_device *pdev)
>>  
>>  	writel(1, info->enable_reg);
>>  
>> +	info->version = exynos_adc_get_version(pdev);
>> +
>>  	info->clk = devm_clk_get(&pdev->dev, "adc");
>>  	if (IS_ERR(info->clk)) {
>>  		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
>> @@ -308,6 +327,17 @@ static int exynos_adc_probe(struct
>platform_device *pdev)
>>  		goto err_irq;
>>  	}
>>  
>> +	if (info->version == ADC_V3) {
>> +		info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
>> +		if (IS_ERR(info->sclk)) {
>> +			dev_warn(&pdev->dev,
>> +				"failed getting sclk clock, err = %ld\n",
>> +				PTR_ERR(info->sclk));
>> +			ret = PTR_ERR(info->sclk);
>> +			goto err_irq;
>> +		}
>> +	}
>> +
>>  	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
>>  	if (IS_ERR(info->vdd)) {
>>  		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
>> @@ -316,8 +346,6 @@ static int exynos_adc_probe(struct
>platform_device *pdev)
>>  		goto err_irq;
>>  	}
>>  
>> -	info->version = exynos_adc_get_version(pdev);
>> -
>>  	platform_set_drvdata(pdev, indio_dev);
>>  
>>  	indio_dev->name = dev_name(&pdev->dev);
>> @@ -340,7 +368,7 @@ static int exynos_adc_probe(struct
>platform_device *pdev)
>>  	if (ret)
>>  		goto err_iio_dev;
>>  
>> -	clk_prepare_enable(info->clk);
>> +	exynos_adc_enable_clock(info, true);
>>  
>>  	exynos_adc_hw_init(info);
>>  
>> @@ -356,7 +384,7 @@ err_of_populate:
>>  	device_for_each_child(&pdev->dev, NULL,
>>  				exynos_adc_remove_devices);
>>  	regulator_disable(info->vdd);
>> -	clk_disable_unprepare(info->clk);
>> +	exynos_adc_enable_clock(info, false);
>>  err_iio_dev:
>>  	iio_device_unregister(indio_dev);
>>  err_irq:
>> @@ -372,7 +400,7 @@ static int exynos_adc_remove(struct
>platform_device *pdev)
>>  	device_for_each_child(&pdev->dev, NULL,
>>  				exynos_adc_remove_devices);
>>  	regulator_disable(info->vdd);
>> -	clk_disable_unprepare(info->clk);
>> +	exynos_adc_enable_clock(info, false);
>>  	writel(0, info->enable_reg);
>>  	iio_device_unregister(indio_dev);
>>  	free_irq(info->irq, info);
>> @@ -387,7 +415,7 @@ static int exynos_adc_suspend(struct device *dev)
>>  	struct exynos_adc *info = iio_priv(indio_dev);
>>  	u32 con;
>>  
>> -	if (info->version == ADC_V2) {
>> +	if (info->version & ADC_V2) {
>>  		con = readl(ADC_V2_CON1(info->regs));
>>  		con &= ~ADC_CON_EN_START;
>>  		writel(con, ADC_V2_CON1(info->regs));
>> @@ -397,7 +425,7 @@ static int exynos_adc_suspend(struct device *dev)
>>  		writel(con, ADC_V1_CON(info->regs));
>>  	}
>>  
>> -	clk_disable_unprepare(info->clk);
>> +	exynos_adc_enable_clock(info, false);
>>  	writel(0, info->enable_reg);
>>  	regulator_disable(info->vdd);
>>  
>> @@ -415,7 +443,7 @@ static int exynos_adc_resume(struct device *dev)
>>  		return ret;
>>  
>>  	writel(1, info->enable_reg);
>> -	clk_prepare_enable(info->clk);
>> +	exynos_adc_enable_clock(info, true);
>>  
>>  	exynos_adc_hw_init(info);
>>  
>> 

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
