Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaG0St6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 14:49:58 -0400
Received: from mout.gmx.net ([212.227.15.15]:54594 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbaG0St4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 14:49:56 -0400
Message-ID: <53D549A2.1000900@gmx.de>
Date: Sun, 27 Jul 2014 20:49:06 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org
CC: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] iio: adc: exynos_adc: add support for s3c64xx adc
References: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com> <1405995074-3271-2-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1405995074-3271-2-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:x9M4xhUUa413QW78fZDmcGn/qZjZWEl05KCnNi6i4pirVxNPmPj
 bkX1rezgg0MdrYdi3GH419t80EDrZp4jl++xEGKC2znCqkOl+D6eVzlbp3anEQh69pGcMcX
 bS7g8Gl8QOYW1J/BGp64JJfUdLw5/k4CvdzJgx8bPpvirKMDZBFi0N9ni9p3tQPZSSOYL9M
 dmqU+Aw09tI/9Y5f6SH0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chanwoo Choi schrieb:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The ADC in s3c64xx is almost the same as exynosv1, but
> has a different 'select' method. Adding this here will be
> helpful to move over the existing s3c64xx platform from the
> legacy plat-samsung/adc driver to the new exynos-adc.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |  2 ++
>  drivers/iio/adc/exynos_adc.c                       | 32 +++++++++++++++++++++-
>  2 files changed, 33 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index 6d34891..b6e3989 100644
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
> index 87e0895..05bdd2f12 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -40,12 +40,16 @@
>  #include <linux/iio/machine.h>
>  #include <linux/iio/driver.h>
>  
> -/* EXYNOS4412/5250 ADC_V1 registers definitions */
> +/* S3C/EXYNOS4412/5250 ADC_V1 registers definitions */
>  #define ADC_V1_CON(x)		((x) + 0x00)
> +#define ADC_V1_TSC(x)		((x) + 0x04)
>  #define ADC_V1_DLY(x)		((x) + 0x08)
>  #define ADC_V1_DATX(x)		((x) + 0x0C)
> +#define ADC_V1_DATY(x)		((x) + 0x10)
> +#define ADC_V1_UPDN(x)		((x) + 0x14)
>  #define ADC_V1_INTCLR(x)	((x) + 0x18)
>  #define ADC_V1_MUX(x)		((x) + 0x1c)
> +#define ADC_V1_CLRINTPNDNUP(x)	((x) + 0x20)
>  
>  /* Future ADC_V2 registers definitions */
>  #define ADC_V2_CON1(x)		((x) + 0x00)
> @@ -61,6 +65,9 @@
>  #define ADC_V1_CON_PRSCLV(x)	(((x) & 0xFF) << 6)
>  #define ADC_V1_CON_STANDBY	(1u << 2)
>  
> +/* Bit definitions for S3C2410 ADC */
> +#define ADC_S3C2410_CON_SELMUX(x) (((x) & 7) <<3)
There is a whitespace missing.
> +
>  /* Bit definitions for ADC_V2 */
>  #define ADC_V2_CON1_SOFT_RESET	(1u << 2)
>  
> @@ -217,6 +224,26 @@ static const struct exynos_adc_data const exynos_adc_v1_data = {
>  	.start_conv	= exynos_adc_v1_start_conv,
>  };
>  
> +static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
> +					  unsigned long addr)
> +{
> +	u32 con1;
> +
> +	con1 = readl(ADC_V1_CON(info->regs));
> +	con1 &= ~ADC_S3C2410_CON_SELMUX(7);
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
> @@ -285,6 +312,9 @@ static const struct exynos_adc_data const exynos3250_adc_data = {
>  
>  static const struct of_device_id exynos_adc_match[] = {
>  	{
> +		.compatible = "samsung,s3c6410-adc",
> +		.data = &exynos_adc_s3c64xx_data,
> +	}, {
>  		.compatible = "samsung,exynos-adc-v1",
>  		.data = &exynos_adc_v1_data,
>  	}, {

