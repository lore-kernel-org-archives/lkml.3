Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3COPnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:43:32 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60790 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3COPn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:43:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAHfPSqCJVGsERi+jNTSYOJTCL0H-ytAcLTLb+7fQnFK1KGqkyg@mail.gmail.com>
References: <1363129994-10438-1-git-send-email-dianders@chromium.org>
 <1363207202-10858-1-git-send-email-dianders@chromium.org> <1363207202-10858-3-git-send-email-dianders@chromium.org>
 <CAHfPSqCJVGsERi+jNTSYOJTCL0H-ytAcLTLb+7fQnFK1KGqkyg@mail.gmail.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 15 Mar 2013 21:13:07 +0530
Message-ID: <CAHfPSqCqeRJ-VABi22Q0M33LFFRS_QnK_zGM28j1UPhrRvK-+Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] iio: adc: Add dt support for turning on the phy in exynos-adc
To: Doug Anderson <dianders@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Olof Johansson <olof@lixom.net>, Guenter Roeck <linux@roeck-us.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 March 2013 17:15, Naveen Krishna Ch <naveenkrishna.ch@gmail.com> wrote:
> On 14 March 2013 02:10, Doug Anderson <dianders@chromium.org> wrote:
>> Without this change the exynos adc controller needed to have its phy
>> enabled in some out-of-driver C code.  Add support for specifying the
>> phy enable register by listing it in the reg list.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
I used this in mach file for testing. But this one worked aswell.

>
> Worked for me, Its needed for Exynos5250 and future versions too.
> Tested on SMDK5250.
>> ---
>> Changes in v2: None
>>
>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt         |  4 ++--
>>  drivers/iio/adc/exynos_adc.c                               | 14 +++++++++++++-
>>  2 files changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> index 96db940..05be151 100644
>> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>> @@ -15,7 +15,7 @@ Required properties:
>>                         Must be "samsung,exynos-adc-v2" for
>>                                 future controllers.
>>  - reg:                 Contains ADC register address range (base address and
>> -                       length).
>> +                       length) and the address of the phy enable register.
>>  - interrupts:          Contains the interrupt information for the timer. The
>>                         format is being dependent on which interrupt controller
>>                         the Samsung device uses.
>> @@ -30,7 +30,7 @@ Example: adding device info in dtsi file
>>
>>  adc: adc@12D10000 {
>>         compatible = "samsung,exynos-adc-v1";
>> -       reg = <0x12D10000 0x100>;
>> +       reg = <0x12D10000 0x100>, <0x10040718 0x4>;
>>         interrupts = <0 106 0>;
>>         #io-channel-cells = <1>;
>>         io-channel-ranges;
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index ed6fdd7..5ab0dfd 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -85,6 +85,7 @@ enum adc_version {
>>
>>  struct exynos_adc {
>>         void __iomem            *regs;
>> +       void __iomem            *enable_reg;
>>         struct clk              *clk;
>>         unsigned int            irq;
>>         struct regulator        *vdd;
>> @@ -269,13 +270,19 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>         info = iio_priv(indio_dev);
>>
>>         mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -
>>         info->regs = devm_request_and_ioremap(&pdev->dev, mem);
>>         if (!info->regs) {
>>                 ret = -ENOMEM;
>>                 goto err_iio;
>>         }
>>
>> +       mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +       info->enable_reg = devm_request_and_ioremap(&pdev->dev, mem);
>> +       if (!info->enable_reg) {
>> +               ret = -ENOMEM;
>> +               goto err_iio;
>> +       }
>> +
>>         irq = platform_get_irq(pdev, 0);
>>         if (irq < 0) {
>>                 dev_err(&pdev->dev, "no irq resource?\n");
>> @@ -295,6 +302,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>                 goto err_iio;
>>         }
>>
>> +       writel(1, info->enable_reg);
>> +
>>         info->clk = devm_clk_get(&pdev->dev, "adc");
>>         if (IS_ERR(info->clk)) {
>>                 dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
>> @@ -370,6 +379,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
>>                                 exynos_adc_remove_devices);
>>         regulator_disable(info->vdd);
>>         clk_disable_unprepare(info->clk);
>> +       writel(0, info->enable_reg);
>>         iio_device_unregister(indio_dev);
>>         free_irq(info->irq, info);
>>         iio_device_free(indio_dev);
>> @@ -395,6 +405,7 @@ static int exynos_adc_suspend(struct device *dev)
>>         }
>>
>>         clk_disable_unprepare(info->clk);
>> +       writel(0, info->enable_reg);
>>         regulator_disable(info->vdd);
>>
>>         return 0;
>> @@ -410,6 +421,7 @@ static int exynos_adc_resume(struct device *dev)
>>         if (ret)
>>                 return ret;
>>
>> +       writel(1, info->enable_reg);
>>         clk_prepare_enable(info->clk);
>>
>>         exynos_adc_hw_init(info);
>> --
>> 1.8.1.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Shine bright,
> (: Nav :)



--
Shine bright,
(: Nav :)
