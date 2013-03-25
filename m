Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab3CYGM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:12:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50414 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab3CYGM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:12:56 -0400
Message-ID: <514FEADE.7020603@ti.com>
Date: Mon, 25 Mar 2013 11:42:46 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] ARM: davinci: dm365: add support for v4l2 video
 display
References: <1363939388-22412-1-git-send-email-prabhakar.csengg@gmail.com> <1363939388-22412-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1363939388-22412-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prabhakar,

On 3/22/2013 1:33 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Create platform devices for various video modules like venc,osd,
> vpbe and v4l2 driver for dm365.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  arch/arm/mach-davinci/board-dm365-evm.c |    4 +-
>  arch/arm/mach-davinci/davinci.h         |    2 +-
>  arch/arm/mach-davinci/dm365.c           |  194 +++++++++++++++++++++++++++++--
>  3 files changed, 188 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index c2d4958..cf77c46 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -564,8 +564,6 @@ static struct davinci_uart_config uart_config __initdata = {
>  
>  static void __init dm365_evm_map_io(void)
>  {
> -	/* setup input configuration for VPFE input devices */
> -	dm365_set_vpfe_config(&vpfe_cfg);
>  	dm365_init();
>  }
>  
> @@ -597,6 +595,8 @@ static __init void dm365_evm_init(void)
>  
>  	davinci_setup_mmc(0, &dm365evm_mmc_config);
>  
> +	dm365_init_video(&vpfe_cfg, NULL);
> +
>  	/* maybe setup mmc1/etc ... _after_ mmc0 */
>  	evm_init_cpld();
>  
> diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
> index 12d544b..1c2670f 100644
> --- a/arch/arm/mach-davinci/davinci.h
> +++ b/arch/arm/mach-davinci/davinci.h
> @@ -84,7 +84,7 @@ void __init dm365_init_ks(struct davinci_ks_platform_data *pdata);
>  void __init dm365_init_rtc(void);
>  void dm365_init_spi0(unsigned chipselect_mask,
>  			const struct spi_board_info *info, unsigned len);
> -void dm365_set_vpfe_config(struct vpfe_config *cfg);
> +int __init dm365_init_video(struct vpfe_config *, struct vpbe_config *);

No need of __init specifier in function declaration.

>  
>  /* DM644x function declarations */
>  void __init dm644x_init(void);
> diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
> index f4c19f7..0a2dba2 100644
> --- a/arch/arm/mach-davinci/dm365.c
> +++ b/arch/arm/mach-davinci/dm365.c
> @@ -40,10 +40,16 @@
>  
>  #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
>  
> +#define DM365_VDAC_CONFIG		0x01c4002c

Please define this in davinci.h as an offset from
DAVINCI_SYSTEM_MODULE_BASE.

> +
> +#define DM365_RTC_BASE			0x01c69000
> +
>  /* Base of key scan register bank */
>  #define DM365_KEYSCAN_BASE		0x01c69400
>  
> -#define DM365_RTC_BASE			0x01c69000
> +#define DM365_OSD_BASE			0x01c71c00
> +
> +#define DM365_VENC_BASE			0x01c71e00
>  
>  #define DAVINCI_DM365_VC_BASE		0x01d0c000
>  #define DAVINCI_DMA_VC_TX		2
> @@ -56,6 +62,11 @@
>  #define DM365_EMAC_CNTRL_RAM_OFFSET	0x1000
>  #define DM365_EMAC_CNTRL_RAM_SIZE	0x2000
>  
> +#define DM365_VPSS_CLK_CTRL_ADDR		0x44

This is already defined in davinci.h as SYSMOD_VPSS_CLKCTL. Please use
the existing definition.

> +#define DM365_VPSS_VENCCLKEN_ENABLE		BIT(3)
> +#define DM365_VPSS_DACCLKEN_ENABLE		BIT(4)
> +#define DM365_VPSS_PLLC2SYSCLK5_ENABLE		BIT(5)

Please move these related defintions to davinci.h as well.

> +
>  static struct pll_data pll1_data = {
>  	.num		= 1,
>  	.phys_base	= DAVINCI_PLL1_BASE,
> @@ -1233,6 +1244,179 @@ static struct platform_device dm365_isif_dev = {
>  	},
>  };
>  
> +static struct resource dm365_osd_resources[] = {
> +	{
> +		.start = DM365_OSD_BASE,
> +		.end   = DM365_OSD_BASE + 0x100,

You ignored by earlier comment to fix this to 0xFF and other such
occurrences in this patch.

Thanks,
Sekhar
