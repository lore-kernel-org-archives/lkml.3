Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbaGRJsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:48:53 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49488 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbaGRJsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:48:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCHv6 2/4] iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
Date: Fri, 18 Jul 2014 11:47:42 +0200
Message-ID: <6485839.CnzmD0SeQj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405663186-26464-3-git-send-email-cw00.choi@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <1405663186-26464-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:06r+odyQnC4A1Th50XaLKM4Tn5c58q92w9qGWXLy1gB
 fK61tmrofZt/5FJ+iloWSAupv2t0wPFFSJHQBd4wzj3PJa/vKT
 gwTxi3kIQ82Hw8Bv3+HDflwFkMt4t8QWV7JLwq1xteR725AgKq
 8vu8uW343HxRqTTzOEneo841ewhkJ5lLPC5MrJFU5yDACaR3mS
 XCQdgecNnm6cXbFQvj7v6d4UycAQvkoe08VSvjJq56K4QqflVT
 tnX/ZQMI7/GghNKFnCCnfWamDqzhICbJzy9vOYdtt5rpYYegp4
 u7WxHuHdIpK7mB1Zg2l+IvVKFCGOh1cxTTRLud/JwRFPG6+MOS
 f672lWhL+nFCT+jRfZok=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 14:59:44 Chanwoo Choi wrote:
> This patch control special clock for ADC in Exynos series's FSYS block.
> If special clock of ADC is registerd on clock list of common clk framework,
> Exynos ADC drvier have to control this clock.
> 
> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
> - 'adc' clock: bus clock for ADC
> 
> Exynos3250 has additional 'sclk_adc' clock as following:
> - 'sclk_adc' clock: special clock for ADC which provide clock to internal ADC
> 
> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_adc' clock
> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_adc'
> clock in FSYS_BLK.

Do you know if any of the older ADC blocks have an "sclk" input as well?

Further, why is it called "sclk_adc" rather than just "sclk"?

> @@ -199,13 +262,20 @@ static void exynos_adc_v2_start_conv(struct exynos_adc *info,
>         writel(con1 | ADC_CON_EN_START, ADC_V2_CON1(info->regs));
>  }
>  
> +#define __EXYNOS_ADC_V2_DATA                           \
> +       .num_channels   = MAX_ADC_V2_CHANNELS,          \
> +       .init_hw        = exynos_adc_v2_init_hw,        \
> +       .exit_hw        = exynos_adc_v2_exit_hw,        \
> +       .clear_irq      = exynos_adc_v2_clear_irq,      \
> +       .start_conv     = exynos_adc_v2_start_conv,     \
> +
>  static struct exynos_adc_data const exynos_adc_v2_data = {
> -       .num_channels   = MAX_ADC_V2_CHANNELS,
> +       __EXYNOS_ADC_V2_DATA
> +};
>  
> -       .init_hw        = exynos_adc_v2_init_hw,
> -       .exit_hw        = exynos_adc_v2_exit_hw,
> -       .clear_irq      = exynos_adc_v2_clear_irq,
> -       .start_conv     = exynos_adc_v2_start_conv,
> +static struct exynos_adc_data const exynos3250_adc_v2_data = {
> +       __EXYNOS_ADC_V2_DATA
> +       .needs_sclk = true,
>  };

I think the macro hurts readability. Please just duplicate the definition
here.

>  static const struct of_device_id exynos_adc_match[] = {
> @@ -215,6 +285,9 @@ static const struct of_device_id exynos_adc_match[] = {
>         }, {
>                 .compatible = "samsung,exynos-adc-v2",
>                 .data = (void *)&exynos_adc_v2_data,
> +       }, {
> +               .compatible = "samsung,exynos3250-adc-v2",
> +               .data = (void *)&exynos3250_adc_v2_data,
>         },
>         {},

Remove the '(void *)' cast here and mark the structure as 'const'.
We intentionally use a 'const void *' type here to verify that
the driver doesn't modify the per-device type data at runtime,
which would be bad if you ever have multiple device instances.

	Arnd
