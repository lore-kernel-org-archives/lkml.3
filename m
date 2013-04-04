Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab3DDJSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:18:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35260 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757941Ab3DDJSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:18:09 -0400
Message-ID: <515D4544.6000604@ti.com>
Date: Thu, 4 Apr 2013 14:47:56 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] ARM: davinci: dm355: add support for v4l2 video
 display
References: <1364908504-14232-1-git-send-email-prabhakar.csengg@gmail.com> <1364908504-14232-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1364908504-14232-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2013 6:45 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Create platform devices for various video modules like venc,osd,
> vpbe and v4l2 driver for dm355.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  arch/arm/mach-davinci/board-dm355-evm.c |    4 +-
>  arch/arm/mach-davinci/davinci.h         |    3 +-
>  arch/arm/mach-davinci/dm355.c           |  173 ++++++++++++++++++++++++++++++-
>  3 files changed, 172 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
> index 147b8e1..37d12cc 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -253,8 +253,6 @@ static struct davinci_uart_config uart_config __initdata = {
>  
>  static void __init dm355_evm_map_io(void)
>  {
> -	/* setup input configuration for VPFE input devices */
> -	dm355_set_vpfe_config(&vpfe_cfg);
>  	dm355_init();
>  }
>  
> @@ -344,6 +342,8 @@ static __init void dm355_evm_init(void)
>  	davinci_setup_mmc(0, &dm355evm_mmc_config);
>  	davinci_setup_mmc(1, &dm355evm_mmc_config);
>  
> +	dm355_init_video(&vpfe_cfg, NULL);
> +
>  	dm355_init_spi0(BIT(0), dm355_evm_spi_info,
>  			ARRAY_SIZE(dm355_evm_spi_info));
>  
> diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
> index a9de512..5402592 100644
> --- a/arch/arm/mach-davinci/davinci.h
> +++ b/arch/arm/mach-davinci/davinci.h
> @@ -39,6 +39,7 @@
>  #define SYSMOD_VDAC_CONFIG		0x2c
>  #define SYSMOD_VIDCLKCTL		0x38
>  #define SYSMOD_VPSS_CLKCTL		0x44
> +#define VPSS_MUXSEL_EXTCLK_ENABLE	BIT(1)
>  #define VPSS_VENCCLKEN_ENABLE		BIT(3)
>  #define VPSS_DACCLKEN_ENABLE		BIT(4)
>  #define VPSS_PLLC2SYSCLK5_ENABLE	BIT(5)
> @@ -79,7 +80,7 @@ void __init dm355_init(void);
>  void dm355_init_spi0(unsigned chipselect_mask,
>  		const struct spi_board_info *info, unsigned len);
>  void __init dm355_init_asp1(u32 evt_enable, struct snd_platform_data *pdata);
> -void dm355_set_vpfe_config(struct vpfe_config *cfg);
> +int __init dm355_init_video(struct vpfe_config *, struct vpbe_config *);

Why do this especially after sending a big patch cleaning __init
annotation in function declaration all over mach-davinci?

>  
>  /* DM365 function declarations */
>  void __init dm365_init(void);
> diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
> index 8e98bb0..174ad02 100644
> --- a/arch/arm/mach-davinci/dm355.c
> +++ b/arch/arm/mach-davinci/dm355.c
> @@ -36,6 +36,10 @@
>  
>  #define DM355_UART2_BASE	(IO_PHYS + 0x206000)
>  
> +#define DM355_OSD_BASE			0x01c70200
> +

Drop the empty line here and after DM355_UART2_BASE. And be consistent
and add new definitions as (IO_PHYS + N)?

> +#define DM355_VENC_BASE			0x01c70400
> +
>  /*
>   * Device specific clocks
>   */
> @@ -744,11 +748,150 @@ static struct platform_device vpfe_capture_dev = {
>  	},
>  };
>  
> -void dm355_set_vpfe_config(struct vpfe_config *cfg)
> +static struct resource dm355_osd_resources[] = {
> +	{
> +		.start	= DM355_OSD_BASE,
> +		.end	= DM355_OSD_BASE + 0x17f,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +};
> +
> +static struct platform_device dm355_osd_dev = {
> +	.name		= DM355_VPBE_OSD_SUBDEV_NAME,
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(dm355_osd_resources),
> +	.resource	= dm355_osd_resources,
> +	.dev		= {
> +		.dma_mask		= &vpfe_capture_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +	},
> +};
> +
> +static struct resource dm355_venc_resources[] = {
> +	{
> +		.start	= IRQ_VENCINT,
> +		.end	= IRQ_VENCINT,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	/* venc registers io space */
> +	{
> +		.start	= DM355_VENC_BASE,
> +		.end	= DM355_VENC_BASE + 0x17f,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	/* VDAC config register io space */
> +	{
> +		.start	= DAVINCI_SYSTEM_MODULE_BASE + SYSMOD_VDAC_CONFIG,
> +		.end	= DAVINCI_SYSTEM_MODULE_BASE + SYSMOD_VDAC_CONFIG + 3,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +};
> +
> +static struct resource dm355_v4l2_disp_resources[] = {
> +	{
> +		.start	= IRQ_VENCINT,
> +		.end	= IRQ_VENCINT,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	/* venc registers io space */
> +	{
> +		.start	= DM355_VENC_BASE,
> +		.end	= DM355_VENC_BASE + 0x17f,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +};
> +
> +static int dm355_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
> +			    int field)
>  {
> -	vpfe_capture_dev.dev.platform_data = cfg;
> +	switch (if_type) {
> +	case V4L2_MBUS_FMT_SGRBG8_1X8:
> +		davinci_cfg_reg(DM355_VOUT_FIELD_G70);
> +		break;
> +
> +	case V4L2_MBUS_FMT_YUYV10_1X20:
> +		if (field)
> +			davinci_cfg_reg(DM355_VOUT_FIELD);
> +		else
> +			davinci_cfg_reg(DM355_VOUT_FIELD_G70);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	davinci_cfg_reg(DM355_VOUT_COUTL_EN);
> +	davinci_cfg_reg(DM355_VOUT_COUTH_EN);
> +
> +	return 0;
> +}
> +
> +static int dm355_venc_setup_clock(enum vpbe_enc_timings_type type,
> +				   unsigned int pclock)
> +{
> +	void __iomem *vpss_clk_ctrl_reg;
> +
> +	vpss_clk_ctrl_reg = DAVINCI_SYSMOD_VIRT(SYSMOD_VPSS_CLKCTL);
> +
> +	switch (type) {
> +	case VPBE_ENC_STD:
> +		writel(VPSS_DACCLKEN_ENABLE |
> +		       VPSS_VENCCLKEN_ENABLE, vpss_clk_ctrl_reg);

Please don't break the line in middle of expression. Instead break it
after the first argument completes.

Rest of the patch looks good. Thank you for your patience with this.

Regards,
Sekhar
