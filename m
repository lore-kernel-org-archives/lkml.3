Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaDPDsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:48:52 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34948 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaDPDsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <1397466426-13870-2-git-send-email-cw00.choi@samsung.com>
References: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com>
	<1397466426-13870-2-git-send-email-cw00.choi@samsung.com>
Date: Wed, 16 Apr 2014 09:18:17 +0530
Message-ID: <CAK9yfHzdPu67JKrww-VFjFvKni7S_y_hvLKKUdeQe-_pxjoBAQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
        naveen krishna <ch.naveen@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, rdunlap@infradead.org,
        Tomasz Figa <t.figa@samsung.com>, linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 14 April 2014 14:37, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch control special clock for ADC in Exynos series's FSYS block.
> If special clock of ADC is registerd on clock list of common clk framework,
> Exynos ADC drvier have to control this clock.
>
> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
> - 'adc' clock: bus clock for ADC
>
> Exynos3250 has additional 'sclk_tsadc' clock as following:
> - 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC
>
> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
> clock in FSYS_BLK.
>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Naveen Krishna Chatradhi
> Cc: linux-iio@vger.kernel.org
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/adc/exynos_adc.c | 54 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 41 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index d25b262..3c99243 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -40,8 +40,9 @@
>  #include <linux/iio/driver.h>
>
>  enum adc_version {
> -       ADC_V1,
> -       ADC_V2
> +       ADC_V1 = 0x1,
> +       ADC_V2 = 0x2,
> +       ADC_V3 = (ADC_V1 | ADC_V2),

Can't this be simply 0x3? Or is this not really a h/w version?

>  };
>
>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
> @@ -88,6 +89,7 @@ struct exynos_adc {
>         void __iomem            *regs;
>         void __iomem            *enable_reg;
>         struct clk              *clk;
> +       struct clk              *sclk;
>         unsigned int            irq;
>         struct regulator        *vdd;
>
> @@ -100,6 +102,7 @@ struct exynos_adc {
>  static const struct of_device_id exynos_adc_match[] = {
>         { .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>         { .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
> +       { .compatible = "samsung,exynos-adc-v3", .data = (void *)ADC_V3 },
>         {},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
> @@ -128,7 +131,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>         mutex_lock(&indio_dev->mlock);
>
>         /* Select the channel to be used and Trigger conversion */
> -       if (info->version == ADC_V2) {
> +       if (info->version & ADC_V2) {

So, now this would be applicable for ADC_V3 too, right?


>                 con2 = readl(ADC_V2_CON2(info->regs));
>                 con2 &= ~ADC_V2_CON2_ACH_MASK;
>                 con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
> @@ -165,7 +168,7 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>         info->value = readl(ADC_V1_DATX(info->regs)) &
>                                                 ADC_DATX_MASK;
>         /* clear irq */
> -       if (info->version == ADC_V2)
> +       if (info->version & ADC_V2)
>                 writel(1, ADC_V2_INT_ST(info->regs));
>         else
>                 writel(1, ADC_V1_INTCLR(info->regs));
> @@ -226,11 +229,25 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
>         return 0;
>  }
>
> +static void exynos_adc_enable_clock(struct exynos_adc *info, bool enable)
> +{
> +       if (enable) {
> +               clk_prepare_enable(info->clk);

This could fail. Is it OK without any checks?

> +               if (info->version == ADC_V3)
> +                       clk_prepare_enable(info->sclk);

ditto.

> +
> +       } else {
> +               if (info->version == ADC_V3)
> +                       clk_disable_unprepare(info->sclk);
> +               clk_disable_unprepare(info->clk);
> +       }
> +}
> +
>  static void exynos_adc_hw_init(struct exynos_adc *info)
>  {
>         u32 con1, con2;
>
> -       if (info->version == ADC_V2) {
> +       if (info->version & ADC_V2) {
>                 con1 = ADC_V2_CON1_SOFT_RESET;
>                 writel(con1, ADC_V2_CON1(info->regs));
>
> @@ -300,6 +317,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
>
>         writel(1, info->enable_reg);
>
> +       info->version = exynos_adc_get_version(pdev);
> +
>         info->clk = devm_clk_get(&pdev->dev, "adc");
>         if (IS_ERR(info->clk)) {
>                 dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
> @@ -308,6 +327,17 @@ static int exynos_adc_probe(struct platform_device *pdev)
>                 goto err_irq;
>         }
>
> +       if (info->version == ADC_V3) {
> +               info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
> +               if (IS_ERR(info->sclk)) {
> +                       dev_warn(&pdev->dev,
> +                               "failed getting sclk clock, err = %ld\n",
> +                               PTR_ERR(info->sclk));
> +                       ret = PTR_ERR(info->sclk);

nit: you could move this line above dev_warn and use 'ret' in the print
statement.


-- 
With warm regards,
Sachin
