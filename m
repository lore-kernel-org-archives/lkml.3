Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3CRISa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:18:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50023 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3CRIS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:18:27 -0400
Message-ID: <5146CDC5.9000702@ti.com>
Date: Mon, 18 Mar 2013 13:48:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: LAK <linux-arm-kernel@lists.infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] ARM: davinci: dm365: add support for v4l2 video
 display
References: <1363360303-15521-1-git-send-email-prabhakar.csengg@gmail.com> <1363360303-15521-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1363360303-15521-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/2013 8:41 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Create platform devices for various video modules like venc,osd,
> vpbe and v4l2 driver for dm365.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  arch/arm/mach-davinci/board-dm365-evm.c |    4 +-
>  arch/arm/mach-davinci/davinci.h         |    2 +-
>  arch/arm/mach-davinci/dm365.c           |  203 +++++++++++++++++++++++++++++--
>  3 files changed, 195 insertions(+), 14 deletions(-)

> diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
> index 6c39805..ec8b06e 100644
> --- a/arch/arm/mach-davinci/dm365.c
> +++ b/arch/arm/mach-davinci/dm365.c
> @@ -40,10 +40,16 @@
>  
>  #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
>  
> +#define DM3XX_VDAC_CONFIG		0x01c4002c

DM365_VDAC_CONFIG since this is a DM365 specific file and to be
consistent with rest of the names?

> +
> +#define DM365_RTC_BASE			0x01c69000
> +
>  /* Base of key scan register bank */
>  #define DM365_KEYSCAN_BASE		0x01c69400
>  
> -#define DM365_RTC_BASE			0x01c69000
> +#define DM365_OSD_BASE			0x01c71c00
> +
> +#define DM365_VENC_REG_BASE		0x01c71e00
>  
>  #define DAVINCI_DM365_VC_BASE		0x01d0c000
>  #define DAVINCI_DMA_VC_TX		2
> @@ -56,6 +62,11 @@
>  #define DM365_EMAC_CNTRL_RAM_OFFSET	0x1000
>  #define DM365_EMAC_CNTRL_RAM_SIZE	0x2000
>  
> +#define DM365_VPSS_CLK_CTRL_ADDR		0x44
> +#define DM365_VPSS_VENCCLKEN_ENABLE		BIT(3)
> +#define DM365_VPSS_DACCLKEN_ENABLE		BIT(4)
> +#define DM365_VPSS_PLLC2SYSCLK5_ENABLE		BIT(5)
> +
>  static struct pll_data pll1_data = {
>  	.num		= 1,
>  	.phys_base	= DAVINCI_PLL1_BASE,
> @@ -1226,6 +1237,186 @@ static struct platform_device dm365_isif_dev = {
>  	},
>  };
>  
> +static struct resource dm365_osd_resources[] = {
> +	{
> +		.start = DM365_OSD_BASE,
> +		.end   = DM365_OSD_BASE + 0x100,
> +		.flags = IORESOURCE_MEM,
> +	},
> +};
> +
> +static u64 dm365_video_dma_mask = DMA_BIT_MASK(32);
> +
> +static struct platform_device dm365_osd_dev = {
> +	.name		= DM365_VPBE_OSD_SUBDEV_NAME,
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(dm365_osd_resources),
> +	.resource	= dm365_osd_resources,
> +	.dev		= {
> +		.dma_mask		= &dm365_video_dma_mask,
> +		.coherent_dma_mask	= DMA_BIT_MASK(32),
> +	},
> +};
> +
> +static struct resource dm365_venc_resources[] = {
> +	{
> +		.start = IRQ_VENCINT,
> +		.end   = IRQ_VENCINT,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	/* venc registers io space */
> +	{
> +		.start = DM365_VENC_REG_BASE,
> +		.end   = DM365_VENC_REG_BASE + 0x180,
> +		.flags = IORESOURCE_MEM,
> +	},
> +	/* vdaccfg registers io space */
> +	{
> +		.start = DM3XX_VDAC_CONFIG,
> +		.end   = DM3XX_VDAC_CONFIG + 4,

DM3XX_VDAC_CONFIG + 3. Check for similar errors in rest of the patch.

> +		.flags = IORESOURCE_MEM,
> +	},
> +};
> +
> +static struct resource dm365_v4l2_disp_resources[] = {
> +	{
> +		.start = IRQ_VENCINT,
> +		.end   = IRQ_VENCINT,
> +		.flags = IORESOURCE_IRQ,
> +	},
> +	/* venc registers io space */
> +	{
> +		.start = DM365_VENC_REG_BASE,
> +		.end   = DM365_VENC_REG_BASE + 0x180,
> +		.flags = IORESOURCE_MEM,
> +	},
> +};
> +

[...]

> +static int dm365_venc_setup_clock(enum vpbe_enc_timings_type type,
> +				  unsigned int pclock)
> +{
> +	void __iomem *vpss_clkctl_reg;
> +	u32 val;
> +
> +	vpss_clkctl_reg = DAVINCI_SYSMOD_VIRT(DM365_VPSS_CLK_CTRL_ADDR);
> +
> +	switch (type) {
> +	case VPBE_ENC_STD:
> +		vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);

So as you found out, it is not correct to call driver functions from
platform code. I suggesting moving this function to driver altogether.
You just need access to DM365_VPSS_CLK_CTRL_ADDR which you can pass
using resource structures.

> +		vpss_enable_clock(VPSS_VPBE_CLOCK, 1);
> +		val = DM365_VPSS_VENCCLKEN_ENABLE | DM365_VPSS_DACCLKEN_ENABLE;
> +		break;
> +
> +	case VPBE_ENC_DV_TIMINGS:
> +		if (pclock <= 27000000) {
> +			vpss_enable_clock(VPSS_VENC_CLOCK_SEL, 1);
> +			vpss_enable_clock(VPSS_VPBE_CLOCK, 1);
> +			val = DM365_VPSS_VENCCLKEN_ENABLE |
> +			      DM365_VPSS_DACCLKEN_ENABLE;
> +		} else {
> +			/* set sysclk4 to output 74.25 MHz from pll1 */
> +			val = DM365_VPSS_PLLC2SYSCLK5_ENABLE |
> +			      DM365_VPSS_DACCLKEN_ENABLE |
> +			      DM365_VPSS_VENCCLKEN_ENABLE;
> +		}
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +	writel(val, vpss_clkctl_reg);
> +
> +	return 0;
> +}

[...]

> +int __init dm365_init_video(struct vpfe_config *vpfe_cfg,
> +				struct vpbe_config *vpbe_cfg)
> +{
> +	if (vpfe_cfg || vpbe_cfg)
> +		platform_device_register(&dm365_vpss_device);
> +
> +	if (vpfe_cfg) {
> +		vpfe_capture_dev.dev.platform_data = vpfe_cfg;
> +		/* Add isif clock alias */

This comment is useless. Instead please document why the aliases are
needed. I know you are just moving code here, but lets do a clean-up job
while at it.

> +		clk_add_alias("master", dm365_isif_dev.name,
> +			      "vpss_master", NULL);
> +		platform_device_register(&dm365_isif_dev);
> +		platform_device_register(&vpfe_capture_dev);
> +	}
> +	if (vpbe_cfg) {
> +		dm365_vpbe_dev.dev.platform_data = vpbe_cfg;
> +		platform_device_register(&dm365_osd_dev);
> +		platform_device_register(&dm365_venc_dev);
> +		platform_device_register(&dm365_vpbe_dev);
> +		platform_device_register(&dm365_vpbe_display);
> +	}
> +
> +	return 0;
> +}

Thanks,
Sekhar
