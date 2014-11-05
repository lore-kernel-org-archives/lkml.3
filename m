Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaKEPhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:37:48 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43424 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaKEPhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:37:47 -0500
Message-ID: <545A4449.8020906@kernel.org>
Date: Wed, 05 Nov 2014 15:37:45 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: cw00.choi@samsung.com, Abhilash Kesavan <a.kesavan@samsung.com>
CC: linux-iio@vger.kernel.org, Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] iio: adc: exynos_adc: Add support for exynos7
References: <1414759083-4555-1-git-send-email-a.kesavan@samsung.com>	<1414814443-4695-1-git-send-email-a.kesavan@samsung.com> <CAGTfZH09UB7ipvZ+R_eKta-_rD-ggR9NaFMW6tds0E+yR_=yYA@mail.gmail.com>
In-Reply-To: <CAGTfZH09UB7ipvZ+R_eKta-_rD-ggR9NaFMW6tds0E+yR_=yYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/14 08:25, Chanwoo Choi wrote:
> Hi Abhilash,
> 
> On Sat, Nov 1, 2014 at 1:00 PM, Abhilash Kesavan <a.kesavan@samsung.com> wrote:
>> The ADC on exynos7 is quite similar to ADCv2. The differences are as
>> follows:
>>         - exynos7-adc has 8 input channels (as against 10 in ADCv2).
>>         - exynos7 does not include an ADC PHY control register.
>>         - Some ADC_CON2 register bits being used in ADCv2 are listed as
>>           reserved in exynos7-adc. This results in a different init_hw
>>           function for exynos7.
>>
>> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>

Looks good.

Applied to the togreg branch of iio.git, initially pushed out as testing for the
autobuilders to play.

Jonathan
>> ---
>> - Based on Naveen's "iio: exynos-adc: use syscon instead of ioremap" patchset
>> http://comments.gmane.org/gmane.linux.kernel.iio/13943
>>
>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |  2 ++
>>  drivers/iio/adc/exynos_adc.c                       | 32 ++++++++++++++++++++++
>>  2 files changed, 34 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> index c368210..f46ca9a 100644
>> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> @@ -16,6 +16,8 @@ Required properties:
>>                                 future controllers.
>>                         Must be "samsung,exynos3250-adc" for
>>                                 controllers compatible with ADC of Exynos3250.
>> +                       Must be "samsung,exynos7-adc" for
>> +                               the ADC in Exynos7 and compatibles
>>                         Must be "samsung,s3c2410-adc" for
>>                                 the ADC in s3c2410 and compatibles
>>                         Must be "samsung,s3c2416-adc" for
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index fe03177..3a2dbb3 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -390,6 +390,35 @@ static const struct exynos_adc_data exynos3250_adc_data = {
>>         .start_conv     = exynos_adc_v2_start_conv,
>>  };
>>
>> +static void exynos_adc_exynos7_init_hw(struct exynos_adc *info)
>> +{
>> +       u32 con1, con2;
>> +
>> +       if (info->data->needs_adc_phy)
>> +               regmap_write(info->pmu_map, info->data->phy_offset, 1);
>> +
>> +       con1 = ADC_V2_CON1_SOFT_RESET;
>> +       writel(con1, ADC_V2_CON1(info->regs));
>> +
>> +       con2 = readl(ADC_V2_CON2(info->regs));
>> +       con2 &= ~ADC_V2_CON2_C_TIME(7);
>> +       con2 |= ADC_V2_CON2_C_TIME(0);
>> +       writel(con2, ADC_V2_CON2(info->regs));
>> +
>> +       /* Enable interrupts */
>> +       writel(1, ADC_V2_INT_EN(info->regs));
>> +}
>> +
>> +static const struct exynos_adc_data exynos7_adc_data = {
>> +       .num_channels   = MAX_ADC_V1_CHANNELS,
>> +       .mask           = ADC_DATX_MASK, /* 12 bit ADC resolution */
>> +
>> +       .init_hw        = exynos_adc_exynos7_init_hw,
>> +       .exit_hw        = exynos_adc_v2_exit_hw,
>> +       .clear_irq      = exynos_adc_v2_clear_irq,
>> +       .start_conv     = exynos_adc_v2_start_conv,
>> +};
>> +
>>  static const struct of_device_id exynos_adc_match[] = {
>>         {
>>                 .compatible = "samsung,s3c2410-adc",
>> @@ -415,6 +444,9 @@ static const struct of_device_id exynos_adc_match[] = {
>>         }, {
>>                 .compatible = "samsung,exynos3250-adc",
>>                 .data = &exynos3250_adc_data,
>> +       }, {
>> +               .compatible = "samsung,exynos7-adc",
>> +               .data = &exynos7_adc_data,
>>         },
>>         {},
>>  };
> 
> Looks good to me.
> 
> Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
> 
> Best Regards,
> Chanwoo Choi
> 
