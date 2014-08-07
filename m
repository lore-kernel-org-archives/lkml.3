Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbaHGQvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:51:50 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39410 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:51:48 -0400
Message-ID: <53E3AEA1.7040604@kernel.org>
Date: Thu, 07 Aug 2014 17:51:45 +0100
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
Subject: Re: [PATCHv2 2/3] iio: adc: exynos_adc: Add support for s3c24xx ADC
References: <1406551442-15186-1-git-send-email-cw00.choi@samsung.com> <1406551442-15186-3-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1406551442-15186-3-git-send-email-cw00.choi@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/14 13:44, Chanwoo Choi wrote:
> This patch add support for s3c2410/s3c2416/s3c2440/s3c2443 ADC. The s3c24xx
> is alomost same as ADCv1. But, There are a little difference as following:
> - ADCMUX register address
> - ADCDAT mask (10 bit or 12 bit ADC resolution according to SoC version)
> - s3c24xx/s3c64xx has not included ADC_PHY enable register
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
Applied - with a little bit of fuzz and pushed out as testing for the autobuilders
to play with it.

Thanks

Jonathan
> ---
>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |  16 ++-
>  drivers/iio/adc/Kconfig                            |   2 +-
>  drivers/iio/adc/exynos_adc.c                       | 109 +++++++++++++++++++--
>  3 files changed, 114 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> index d3dad46..709efaa 100644
> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
> @@ -11,15 +11,25 @@ New driver handles the following
>  
>  Required properties:
>  - compatible:		Must be "samsung,exynos-adc-v1"
> -				for exynos4412/5250 controllers.
> +				for exynos4412/5250 and s5pv210 controllers.
>  			Must be "samsung,exynos-adc-v2" for
>  				future controllers.
>  			Must be "samsung,exynos3250-adc" for
>  				controllers compatible with ADC of Exynos3250.
> +			Must be "samsung,s3c2410-adc" for
> +				the ADC in s3c2410 and compatibles
> +			Must be "samsung,s3c2416-adc" for
> +				the ADC in s3c2416 and compatibles
> +			Must be "samsung,s3c2440-adc" for
> +				the ADC in s3c2440 and compatibles
> +			Must be "samsung,s3c2443-adc" for
> +				the ADC in s3c2443 and compatibles
>  			Must be "samsung,s3c6410-adc" for
>  				the ADC in s3c6410 and compatibles
> -- reg:			Contains ADC register address range (base address and
> -			length) and the address of the phy enable register.
> +- reg:			List of ADC register address range
> +			- The base address and range of ADC register
> +			- The base address and range of ADC_PHY register (every
> +			  SoC except for s3c24xx/s3c64xx ADC)
>  - interrupts: 		Contains the interrupt information for the timer. The
>  			format is being dependent on which interrupt controller
>  			the Samsung device uses.
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index a80d236..a247655 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -119,7 +119,7 @@ config AT91_ADC
>  
>  config EXYNOS_ADC
>  	tristate "Exynos ADC driver support"
> -	depends on ARCH_EXYNOS || (OF && COMPILE_TEST)
> +	depends on ARCH_EXYNOS || ARCH_S3C24XX || ARCH_S3C64XX || (OF && COMPILE_TEST)
>  	help
>  	  Core support for the ADC block found in the Samsung EXYNOS series
>  	  of SoCs for drivers such as the touchscreen and hwmon to use to share
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index ed9e4c8..3b17faa 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -47,6 +47,9 @@
>  #define ADC_V1_INTCLR(x)	((x) + 0x18)
>  #define ADC_V1_MUX(x)		((x) + 0x1c)
>  
> +/* S3C2410 ADC registers definitions */
> +#define ADC_S3C2410_MUX(x)	((x) + 0x18)
> +
>  /* Future ADC_V2 registers definitions */
>  #define ADC_V2_CON1(x)		((x) + 0x00)
>  #define ADC_V2_CON2(x)		((x) + 0x04)
> @@ -63,6 +66,8 @@
>  
>  /* Bit definitions for S3C2410 ADC */
>  #define ADC_S3C2410_CON_SELMUX(x) (((x) & 7) << 3)
> +#define ADC_S3C2410_DATX_MASK	0x3FF
> +#define ADC_S3C2416_CON_RES_SEL	(1u << 3)
>  
>  /* Bit definitions for ADC_V2 */
>  #define ADC_V2_CON1_SOFT_RESET	(1u << 2)
> @@ -80,6 +85,7 @@
>  
>  /* Bit definitions common for ADC_V1 and ADC_V2 */
>  #define ADC_CON_EN_START	(1u << 0)
> +#define ADC_CON_EN_START_MASK	(0x3 << 0)
>  #define ADC_DATX_MASK		0xFFF
>  
>  #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
> @@ -103,6 +109,8 @@ struct exynos_adc {
>  struct exynos_adc_data {
>  	int num_channels;
>  	bool needs_sclk;
> +	bool needs_adc_phy;
> +	u32 mask;
>  
>  	void (*init_hw)(struct exynos_adc *info);
>  	void (*exit_hw)(struct exynos_adc *info);
> @@ -174,7 +182,8 @@ static void exynos_adc_v1_init_hw(struct exynos_adc *info)
>  {
>  	u32 con1;
>  
> -	writel(1, info->enable_reg);
> +	if (info->data->needs_adc_phy)
> +		writel(1, info->enable_reg);
>  
>  	/* set default prescaler values and Enable prescaler */
>  	con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
> @@ -188,7 +197,8 @@ static void exynos_adc_v1_exit_hw(struct exynos_adc *info)
>  {
>  	u32 con;
>  
> -	writel(0, info->enable_reg);
> +	if (info->data->needs_adc_phy)
> +		writel(0, info->enable_reg);
>  
>  	con = readl(ADC_V1_CON(info->regs));
>  	con |= ADC_V1_CON_STANDBY;
> @@ -213,6 +223,8 @@ static void exynos_adc_v1_start_conv(struct exynos_adc *info,
>  
>  static const struct exynos_adc_data const exynos_adc_v1_data = {
>  	.num_channels	= MAX_ADC_V1_CHANNELS,
> +	.mask		= ADC_DATX_MASK,	/* 12 bit ADC resolution */
> +	.needs_adc_phy	= true,
>  
>  	.init_hw	= exynos_adc_v1_init_hw,
>  	.exit_hw	= exynos_adc_v1_exit_hw,
> @@ -220,6 +232,53 @@ static const struct exynos_adc_data const exynos_adc_v1_data = {
>  	.start_conv	= exynos_adc_v1_start_conv,
>  };
>  
> +static void exynos_adc_s3c2416_start_conv(struct exynos_adc *info,
> +					  unsigned long addr)
> +{
> +	u32 con1;
> +
> +	/* Enable 12 bit ADC resolution */
> +	con1 = readl(ADC_V1_CON(info->regs));
> +	con1 |= ADC_S3C2416_CON_RES_SEL;
> +	writel(con1, ADC_V1_CON(info->regs));
> +
> +	/* Select channel for S3C2416 */
> +	writel(addr, ADC_S3C2410_MUX(info->regs));
> +
> +	con1 = readl(ADC_V1_CON(info->regs));
> +	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
> +}
> +
> +static struct exynos_adc_data const exynos_adc_s3c2416_data = {
> +	.num_channels	= MAX_ADC_V1_CHANNELS,
> +	.mask		= ADC_DATX_MASK,	/* 12 bit ADC resolution */
> +
> +	.init_hw	= exynos_adc_v1_init_hw,
> +	.exit_hw	= exynos_adc_v1_exit_hw,
> +	.start_conv	= exynos_adc_s3c2416_start_conv,
> +};
> +
> +static void exynos_adc_s3c2443_start_conv(struct exynos_adc *info,
> +					  unsigned long addr)
> +{
> +	u32 con1;
> +
> +	/* Select channel for S3C2433 */
> +	writel(addr, ADC_S3C2410_MUX(info->regs));
> +
> +	con1 = readl(ADC_V1_CON(info->regs));
> +	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
> +}
> +
> +static struct exynos_adc_data const exynos_adc_s3c2443_data = {
> +	.num_channels	= MAX_ADC_V1_CHANNELS,
> +	.mask		= ADC_S3C2410_DATX_MASK, /* 10 bit ADC resolution */
> +
> +	.init_hw	= exynos_adc_v1_init_hw,
> +	.exit_hw	= exynos_adc_v1_exit_hw,
> +	.start_conv	= exynos_adc_s3c2443_start_conv,
> +};
> +
>  static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
>  					  unsigned long addr)
>  {
> @@ -231,8 +290,18 @@ static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
>  	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
>  }
>  
> +static struct exynos_adc_data const exynos_adc_s3c24xx_data = {
> +	.num_channels	= MAX_ADC_V1_CHANNELS,
> +	.mask		= ADC_S3C2410_DATX_MASK, /* 10 bit ADC resolution */
> +
> +	.init_hw	= exynos_adc_v1_init_hw,
> +	.exit_hw	= exynos_adc_v1_exit_hw,
> +	.start_conv	= exynos_adc_s3c64xx_start_conv,
> +};
> +
>  static struct exynos_adc_data const exynos_adc_s3c64xx_data = {
>  	.num_channels	= MAX_ADC_V1_CHANNELS,
> +	.mask		= ADC_DATX_MASK,	/* 12 bit ADC resolution */
>  
>  	.init_hw	= exynos_adc_v1_init_hw,
>  	.exit_hw	= exynos_adc_v1_exit_hw,
> @@ -244,7 +313,8 @@ static void exynos_adc_v2_init_hw(struct exynos_adc *info)
>  {
>  	u32 con1, con2;
>  
> -	writel(1, info->enable_reg);
> +	if (info->data->needs_adc_phy)
> +		writel(1, info->enable_reg);
>  
>  	con1 = ADC_V2_CON1_SOFT_RESET;
>  	writel(con1, ADC_V2_CON1(info->regs));
> @@ -261,7 +331,8 @@ static void exynos_adc_v2_exit_hw(struct exynos_adc *info)
>  {
>  	u32 con;
>  
> -	writel(0, info->enable_reg);
> +	if (info->data->needs_adc_phy)
> +		writel(0, info->enable_reg);
>  
>  	con = readl(ADC_V2_CON1(info->regs));
>  	con &= ~ADC_CON_EN_START;
> @@ -289,6 +360,8 @@ static void exynos_adc_v2_start_conv(struct exynos_adc *info,
>  
>  static const struct exynos_adc_data const exynos_adc_v2_data = {
>  	.num_channels	= MAX_ADC_V2_CHANNELS,
> +	.mask		= ADC_DATX_MASK, /* 12 bit ADC resolution */
> +	.needs_adc_phy	= true,
>  
>  	.init_hw	= exynos_adc_v2_init_hw,
>  	.exit_hw	= exynos_adc_v2_exit_hw,
> @@ -298,7 +371,9 @@ static const struct exynos_adc_data const exynos_adc_v2_data = {
>  
>  static const struct exynos_adc_data const exynos3250_adc_data = {
>  	.num_channels	= MAX_EXYNOS3250_ADC_CHANNELS,
> +	.mask		= ADC_DATX_MASK, /* 12 bit ADC resolution */
>  	.needs_sclk	= true,
> +	.needs_adc_phy	= true,
>  
>  	.init_hw	= exynos_adc_v2_init_hw,
>  	.exit_hw	= exynos_adc_v2_exit_hw,
> @@ -308,6 +383,18 @@ static const struct exynos_adc_data const exynos3250_adc_data = {
>  
>  static const struct of_device_id exynos_adc_match[] = {
>  	{
> +		.compatible = "samsung,s3c2410-adc",
> +		.data = &exynos_adc_s3c24xx_data,
> +	}, {
> +		.compatible = "samsung,s3c2416-adc",
> +		.data = &exynos_adc_s3c2416_data,
> +	}, {
> +		.compatible = "samsung,s3c2440-adc",
> +		.data = &exynos_adc_s3c24xx_data,
> +	}, {
> +		.compatible = "samsung,s3c2443-adc",
> +		.data = &exynos_adc_s3c2443_data,
> +	}, {
>  		.compatible = "samsung,s3c6410-adc",
>  		.data = &exynos_adc_s3c64xx_data,
>  	}, {
> @@ -373,9 +460,10 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>  static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>  {
>  	struct exynos_adc *info = (struct exynos_adc *)dev_id;
> +	u32 mask = info->data->mask;
>  
>  	/* Read value */
> -	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
> +	info->value = readl(ADC_V1_DATX(info->regs)) & mask;
>  
>  	/* clear irq */
>  	if (info->data->clear_irq)
> @@ -468,10 +556,13 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  	if (IS_ERR(info->regs))
>  		return PTR_ERR(info->regs);
>  
> -	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	info->enable_reg = devm_ioremap_resource(&pdev->dev, mem);
> -	if (IS_ERR(info->enable_reg))
> -		return PTR_ERR(info->enable_reg);
> +
> +	if (info->data->needs_adc_phy) {
> +		mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +		info->enable_reg = devm_ioremap_resource(&pdev->dev, mem);
> +		if (IS_ERR(info->enable_reg))
> +			return PTR_ERR(info->enable_reg);
> +	}
>  
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0) {
> 
