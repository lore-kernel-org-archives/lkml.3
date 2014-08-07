Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102AbaHGQvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:51:24 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39400 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:51:21 -0400
Message-ID: <53E3AE7F.9070602@kernel.org>
Date: Thu, 07 Aug 2014 17:51:11 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, heiko@sntech.de, knaack.h@gmx.de,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 1/3] iio: adc: exynos_adc: add support for s3c64xx adc
References: <1406551442-15186-1-git-send-email-cw00.choi@samsung.com> <1406551442-15186-2-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1406551442-15186-2-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/14 13:44, Chanwoo Choi wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ADC in s3c64xx is almost the same as exynosv1, but
> has a different 'select' method. Adding this here will be
> helpful to move over the existing s3c64xx platform from the
> legacy plat-samsung/adc driver to the new exynos-adc.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Applied to the togreg branch of iio.git.  Initially pushed out as testing
for the autobuilders to play.

Thanks,

> ---
>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |  2 ++
>  drivers/iio/adc/exynos_adc.c                       | 28 +++++++++++++++++++++-
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index adc61b0..d3dad46 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -16,6 +16,8 @@ Required properties:
>  				future controllers.
>  			Must be "samsung,exynos3250-adc" for
>  				controllers compatible with ADC of Exynos3250.
> +			Must be "samsung,s3c6410-adc" for
> +				the ADC in s3c6410 and compatibles
>  - reg:			Contains ADC register address range (base address and
>  			length) and the address of the phy enable register.
>  - interrupts: 		Contains the interrupt information for the timer. The
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index 87e0895..ed9e4c8 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -40,7 +40,7 @@
>  #include <linux/iio/machine.h>
>  #include <linux/iio/driver.h>
>  
> -/* EXYNOS4412/5250 ADC_V1 registers definitions */
> +/* S3C/EXYNOS4412/5250 ADC_V1 registers definitions */
>  #define ADC_V1_CON(x)		((x) + 0x00)
>  #define ADC_V1_DLY(x)		((x) + 0x08)
>  #define ADC_V1_DATX(x)		((x) + 0x0C)
> @@ -61,6 +61,9 @@
>  #define ADC_V1_CON_PRSCLV(x)	(((x) & 0xFF) << 6)
>  #define ADC_V1_CON_STANDBY	(1u << 2)
>  
> +/* Bit definitions for S3C2410 ADC */
> +#define ADC_S3C2410_CON_SELMUX(x) (((x) & 7) << 3)
> +
>  /* Bit definitions for ADC_V2 */
>  #define ADC_V2_CON1_SOFT_RESET	(1u << 2)
>  
> @@ -217,6 +220,26 @@ static const struct exynos_adc_data const exynos_adc_v1_data = {
>  	.start_conv	= exynos_adc_v1_start_conv,
>  };
>  
> +static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
> +					  unsigned long addr)
> +{
> +	u32 con1;
> +
> +	con1 = readl(ADC_V1_CON(info->regs));
> +	con1 &= ~ADC_S3C2410_CON_SELMUX(0x7);
> +	con1 |= ADC_S3C2410_CON_SELMUX(addr);
> +	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
> +}
> +
> +static struct exynos_adc_data const exynos_adc_s3c64xx_data = {
> +	.num_channels	= MAX_ADC_V1_CHANNELS,
> +
> +	.init_hw	= exynos_adc_v1_init_hw,
> +	.exit_hw	= exynos_adc_v1_exit_hw,
> +	.clear_irq	= exynos_adc_v1_clear_irq,
> +	.start_conv	= exynos_adc_s3c64xx_start_conv,
> +};
> +
>  static void exynos_adc_v2_init_hw(struct exynos_adc *info)
>  {
>  	u32 con1, con2;
> @@ -285,6 +308,9 @@ static const struct exynos_adc_data const exynos3250_adc_data = {
>  
>  static const struct of_device_id exynos_adc_match[] = {
>  	{
> +		.compatible = "samsung,s3c6410-adc",
> +		.data = &exynos_adc_s3c64xx_data,
> +	}, {
>  		.compatible = "samsung,exynos-adc-v1",
>  		.data = &exynos_adc_v1_data,
>  	}, {
> 
