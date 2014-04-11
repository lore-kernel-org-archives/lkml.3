Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaDKWpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:45:46 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:54874 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaDKWpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <18632148.yOYlTYattA@amdc1032>
References: <1397181640-18513-1-git-send-email-cw00.choi@samsung.com>
	<18632148.yOYlTYattA@amdc1032>
Date: Sat, 12 Apr 2014 07:45:42 +0900
Message-ID: <CAGTfZH2Rpa+hooPHY2xmquVHCwcE2X7rqf3rzGKCz02rA9qSzA@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
From: =?UTF-8?B?7LWc7LCs7Jqw?= <cwchoi00@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, Kukjin Kim <kgene.kim@samsung.com>,
        linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On Fri, Apr 11, 2014 at 6:41 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
>
> Hi,
>
> On Friday, April 11, 2014 11:00:40 AM Chanwoo Choi wrote:
>> This patch control special clock for ADC in Exynos series's FSYS block.
>
> s/control/controls/

I'll fix it.

>
>> If special clock of ADC is registerd on clock list of common clk framework,
>> Exynos ADC drvier have to control this clock.
>
> s/drvier/driver/

I'll fix it.

>
>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>> - 'adc' clock: bus clock for ADC
>>
>> Exynos3250 has additional 'sclk_tsadc' clock as following:
>> - 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC
>>
>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
>> clock in FSYS_BLK.
>>
>> Cc: Jonathan Cameron <jic23@kernel.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Cc: linux-iio@vger.kernel.org
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/iio/adc/exynos_adc.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index d25b262..4cd1975 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -88,6 +88,7 @@ struct exynos_adc {
>>       void __iomem            *regs;
>>       void __iomem            *enable_reg;
>>       struct clk              *clk;
>> +     struct clk              *sclk;
>>       unsigned int            irq;
>>       struct regulator        *vdd;
>>
>> @@ -308,6 +309,13 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>               goto err_irq;
>>       }
>>
>> +     info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
>> +     if (IS_ERR(info->sclk)) {
>> +             dev_warn(&pdev->dev, "failed getting sclk clock, err = %ld\n",
>> +                                                     PTR_ERR(info->sclk));
>> +             info->sclk = NULL;
>> +     }
>> +
>>       info->vdd = devm_regulator_get(&pdev->dev, "vdd");
>>       if (IS_ERR(info->vdd)) {
>>               dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
>> @@ -341,6 +349,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>               goto err_iio_dev;
>>
>>       clk_prepare_enable(info->clk);
>> +     clk_prepare_enable(info->sclk);
>>
>>       exynos_adc_hw_init(info);
>>
>> @@ -357,6 +366,7 @@ err_of_populate:
>>                               exynos_adc_remove_devices);
>>       regulator_disable(info->vdd);
>>       clk_disable_unprepare(info->clk);
>> +     clk_disable_unprepare(info->sclk);
>
> Please disable clocks in the reverse of order in which they were enabled.

Is it necessary? I don't think that.

Best Regards,
Chanwoo Choi
