Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119AbaFRH6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:58:55 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50066 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbaFRH6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:58:53 -0400
Message-ID: <53A146A8.7050501@gmail.com>
Date: Wed, 18 Jun 2014 09:58:32 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, t.figa@samsung.com, kgene.kim@samsung.com
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 2/4] iio: adc: exynos_adc: Control special clock of
 ADC to support Exynos3250 ADC
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com> <1403058061-24271-3-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1403058061-24271-3-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 18.06.2014 04:20, Chanwoo Choi wrote:
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
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/adc/exynos_adc.c | 93 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 81 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index c30def6..6b026ac 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -41,7 +41,8 @@
>  
>  enum adc_version {
>  	ADC_V1,
> -	ADC_V2
> +	ADC_V2,
> +	ADC_V2_EXYNOS3250,
>  };
>  
>  /* EXYNOS4412/5250 ADC_V1 registers definitions */
> @@ -85,9 +86,11 @@ enum adc_version {
>  #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
>  
>  struct exynos_adc {
> +	struct device		*dev;
>  	void __iomem		*regs;
>  	void __iomem		*enable_reg;
>  	struct clk		*clk;
> +	struct clk		*sclk;
>  	unsigned int		irq;
>  	struct regulator	*vdd;
>  	struct exynos_adc_ops	*ops;
> @@ -96,6 +99,7 @@ struct exynos_adc {
>  
>  	u32			value;
>  	unsigned int            version;
> +	bool			needs_sclk;

This should be rather a part of the variant struct. See my comments to
patch 1/4.

>  };
>  
>  struct exynos_adc_ops {
> @@ -103,11 +107,21 @@ struct exynos_adc_ops {
>  	void (*clear_irq)(struct exynos_adc *info);
>  	void (*start_conv)(struct exynos_adc *info, unsigned long addr);
>  	void (*stop_conv)(struct exynos_adc *info);
> +	void (*disable_clk)(struct exynos_adc *info);
> +	int (*enable_clk)(struct exynos_adc *info);
>  };
>  
>  static const struct of_device_id exynos_adc_match[] = {
> -	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
> -	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
> +	{
> +		.compatible = "samsung,exynos-adc-v1",
> +		.data = (void *)ADC_V1,
> +	}, {
> +		.compatible = "samsung,exynos-adc-v2",
> +		.data = (void *)ADC_V2,
> +	}, {
> +		.compatible = "samsung,exynos3250-adc-v2",
> +		.data = (void *)ADC_V2_EXYNOS3250,
> +	},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_adc_match);
> @@ -156,11 +170,42 @@ static void exynos_adc_v1_stop_conv(struct exynos_adc *info)
>  	writel(con, ADC_V1_CON(info->regs));
>  }
>  
> +static void exynos_adc_disable_clk(struct exynos_adc *info)
> +{
> +	if (info->needs_sclk)
> +		clk_disable_unprepare(info->sclk);
> +	clk_disable_unprepare(info->clk);
> +}
> +
> +static int exynos_adc_enable_clk(struct exynos_adc *info)
> +{
> +	int ret;
> +
> +	ret = clk_prepare_enable(info->clk);
> +	if (ret) {
> +		dev_err(info->dev, "failed enabling adc clock: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (info->needs_sclk) {
> +		ret = clk_prepare_enable(info->sclk);
> +		if (ret) {
> +			clk_disable_unprepare(info->clk);
> +			dev_err(info->dev,
> +				"failed enabling sclk_tsadc clock: %d\n", ret);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static struct exynos_adc_ops exynos_adc_v1_ops = {
>  	.init_hw	= exynos_adc_v1_init_hw,
>  	.clear_irq	= exynos_adc_v1_clear_irq,
>  	.start_conv	= exynos_adc_v1_start_conv,
>  	.stop_conv	= exynos_adc_v1_stop_conv,
> +	.disable_clk	= exynos_adc_disable_clk,
> +	.enable_clk	= exynos_adc_enable_clk,
>  };
>  
>  static void exynos_adc_v2_init_hw(struct exynos_adc *info)
> @@ -210,6 +255,8 @@ static struct exynos_adc_ops exynos_adc_v2_ops = {
>  	.start_conv	= exynos_adc_v2_start_conv,
>  	.clear_irq	= exynos_adc_v2_clear_irq,
>  	.stop_conv	= exynos_adc_v2_stop_conv,
> +	.disable_clk	= exynos_adc_disable_clk,
> +	.enable_clk	= exynos_adc_enable_clk,

Based on the fact that all variants use the same function, I don't think
there is a reason to add .{disable,enable}_clk in the ops struct. If
they diverge in future, they could be added later, but right now it
doesn't have any value.

Best regards,
Tomasz
