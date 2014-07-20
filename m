Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaGTVip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:38:45 -0400
Received: from mout.gmx.net ([212.227.17.21]:57054 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbaGTVik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:38:40 -0400
Message-ID: <53CC3683.9090101@gmx.de>
Date: Sun, 20 Jul 2014 23:37:07 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        heiko.stuebner@bq.com, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] iio: exynos-adc: add support for s3c64xx adc
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <5186890.aLtladpMgD@wuerfel>
In-Reply-To: <5186890.aLtladpMgD@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:5scY6ANOdbkB09YdV7CKyJaWX1U50S+7dRUY+eHE8P84olQJKjQ
 ZfRnaubP/Sv163ZN1EWuziSUvl5lUIXcN5Q+h8xeuOT49y2iTv1g+vA9vvXfS8RCkf8sjvk
 +NtaFeh9lT8nH6CQTUwXXrhLaZkIdQ9UkHHtA+fBbKSh9JX20gbI8rh2QuHj8DNCxqJLZvq
 M0tK4J1Y94tfeb7DljMzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann schrieb:
> The ADC in s3c64xx is almost the same as exynosv1, but
> has a different 'select' method. Adding this here will be
> helpful to move over the existing s3c64xx platform from the
> legacy plat-samsung/adc driver to the new exynos-adc.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
There are some style issues, see the comments inline.
> [In reply to Exynos3250 ADC support, adding Heiko and Ben]
>
> I spent way too much time this week trying to clean up the
> old plat-samsung/adc.c driver as preparation for s3c64xx multiplatform
> support. Eventually I figured out that all that code is much simpler
> done using the new driver. This adds support for s3c64xx in
> samsung-adc.c, similar code changes can be done to support the
> various s3c24xx variants as well.
>
> This first patch should be fairly straightforward but is not tested
> yet. The second patch is more tricky.
>
> Both are based on the exynos3250 patches sent by Chanwoo Choi.
>
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index 26232f98d8c5..f84e9250429b 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -11,11 +11,21 @@ New driver handles the following
>  
>  Required properties:
>  - compatible:		Must be "samsung,exynos-adc-v1"
> -				for exynos4412/5250 controllers.
> +				for exynos4412/5250 and s5pv210 controllers.
>  			Must be "samsung,exynos-adc-v2" for
>  				future controllers.
>  			Must be "samsung,exynos3250-adc-v2" for
>  				controllers compatible with ADC of Exynos3250.
> +			Must be "samsung,s3c2410-adc" for
> +				the ADC in s3c2410 and compatibles
> +			Must be "samsung,s3c2416-adc" for
> +				the ADC in s3c2416 and compatibles
> +			Must be "samsung,s3c2440-adc" for
> +				the ADC in s3c2440 and compatibles
> +			Must be "samsung,s3c2440-adc" for
> +				the ADC in s3c2440 and compatibles
> +			Must be "samsung,s3c2443-adc" for
> +				the ADC in s3c2443 and compatibles
>  - reg:			Contains ADC register address range (base address and
>  			length) and the address of the phy enable register.
>  - interrupts: 		Contains the interrupt information for the timer. The
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index b63e88247eb2..5f95638513d2 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -39,12 +39,16 @@
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
> @@ -60,6 +64,30 @@
>  #define ADC_V1_CON_PRSCLV(x)	(((x) & 0xFF) << 6)
>  #define ADC_V1_CON_STANDBY	(1u << 2)
>  
Leave a whitespace around operators below.
> +#define ADC_S3C2410_CON_SELMUX(x) (((x)&0x7)<<3)
> +
> +/* ADCTSC Register Bits */
> +#define ADC_S3C2443_TSC_UD_SEN		(1<<8)
> +#define ADC_S3C2410_TSC_YM_SEN		(1<<7)
> +#define ADC_S3C2410_TSC_YP_SEN		(1<<6)
> +#define ADC_S3C2410_TSC_XM_SEN		(1<<5)
> +#define ADC_S3C2410_TSC_XP_SEN		(1<<4)
> +#define ADC_S3C2410_TSC_PULL_UP_DISABLE	(1<<3)
> +#define ADC_S3C2410_TSC_AUTO_PST	(1<<2)
> +#define ADC_S3C2410_TSC_XY_PST(x)	(((x)&0x3)<<0)
> +
> +#define ADC_TSC_WAIT4INT (ADC_S3C2410_TSC_YM_SEN | \
> +			 ADC_S3C2410_TSC_YP_SEN | \
> +			 ADC_S3C2410_TSC_XP_SEN | \
> +			 ADC_S3C2410_TSC_XY_PST(3))
> +
> +#define ADC_TSC_AUTOPST	(ADC_S3C2410_TSC_YM_SEN | \
> +			 ADC_S3C2410_TSC_YP_SEN | \
> +			 ADC_S3C2410_TSC_XP_SEN | \
> +			 ADC_S3C2410_TSC_AUTO_PST | \
> +			 ADC_S3C2410_TSC_XY_PST(0))
> +
> +
>  /* Bit definitions for ADC_V2 */
>  #define ADC_V2_CON1_SOFT_RESET	(1u << 2)
>  
> @@ -195,6 +223,26 @@ static void exynos_adc_v1_clear_irq(struct exynos_adc *info)
>  	writel(1, ADC_V1_INTCLR(info->regs));
>  }
>  
> +static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
> +				     unsigned long addr)
This indention could be a bit better.
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
>  static void exynos_adc_v1_start_conv(struct exynos_adc *info,
>  				     unsigned long addr)
>  {
> @@ -280,6 +328,9 @@ static struct exynos_adc_data const exynos3250_adc_v2_data = {
>  
>  static const struct of_device_id exynos_adc_match[] = {
>  	{
> +		.compatible = "samsung,s3c64100-adc",
> +		.data = &exynos_adc_s3c64xx_data,
> +	}, {
>  		.compatible = "samsung,exynos-adc-v1",
>  		.data = (void *)&exynos_adc_v1_data,
>  	}, {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

