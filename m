Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaJTQ2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:28:40 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:59359 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaJTQ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:28:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Oct 2014 18:28:39 +0200
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de
Cc: jingchang.lu@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: clk-vf610: define PLL's clock tree
In-Reply-To: <1412343065-10336-1-git-send-email-stefan@agner.ch>
References: <1412343065-10336-1-git-send-email-stefan@agner.ch>
Message-ID: <7be3dfb42f4e8debdee3235cdaed6e49@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-10-03 15:31, schrieb Stefan Agner:
> So far, the required PLL's (PLL1/PLL2/PLL5) have been initialized
> by boot loader and the kernel code defined fixed rates according
> to those default configurations. Beginning with the USB PLL7 the
> code started to initialize the PLL's itself (using imx_clk_pllv3).
> 
> However, since commit dc4805c2e78ba5a22ea1632f3e3e4ee601a1743b
> (ARM: imx: remove ENABLE and BYPASS bits from clk-pllv3 driver)
> imx_clk_pllv3 no longer takes care of the ENABLE and BYPASS bits,
> hence the USB PLL were not configured correctly anymore.
> 
> This patch not only fixes those USB PLL's, but also makes use of
> the imx_clk_pllv3 for all PLL's and alignes the code with the PLL
> support of the i.MX6 series.
> ---
> Shawn, if possible, it would be great if this makes it into 3.18.
> Right now, because of the clk-pllv3 change, the newly added USB
> support is broken...
> 
> I could have created a patch which only fixes the USB PLL7, but
> then we touch the header file twice and its getting a mess in
> there. I prefer to have it fixed once for all PLL's. I hope this
> makes it into 3.18 nonetheless. If not, I'm also fine if this
> makes it into next.

Any comment on this...?

> 
>  arch/arm/mach-imx/clk-vf610.c           | 134 ++++++++++++++++++++++----------
>  include/dt-bindings/clock/vf610-clock.h |  39 ++++++++--
>  2 files changed, 123 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
> index a178184..4096372 100644
> --- a/arch/arm/mach-imx/clk-vf610.c
> +++ b/arch/arm/mach-imx/clk-vf610.c
> @@ -58,8 +58,14 @@
>  #define PFD_PLL1_BASE		(anatop_base + 0x2b0)
>  #define PFD_PLL2_BASE		(anatop_base + 0x100)
>  #define PFD_PLL3_BASE		(anatop_base + 0xf0)
> +#define PLL1_CTRL		(anatop_base + 0x270)
> +#define PLL2_CTRL		(anatop_base + 0x30)
>  #define PLL3_CTRL		(anatop_base + 0x10)
> +#define PLL4_CTRL		(anatop_base + 0x70)
> +#define PLL5_CTRL		(anatop_base + 0xe0)
> +#define PLL6_CTRL		(anatop_base + 0xa0)
>  #define PLL7_CTRL		(anatop_base + 0x20)
> +#define ANA_MISC1		(anatop_base + 0x160)
>  
>  static void __iomem *anatop_base;
>  static void __iomem *ccm_base;
> @@ -67,25 +73,34 @@ static void __iomem *ccm_base;
>  /* sources for multiplexer clocks, this is used multiple times */
>  static const char *fast_sels[]	= { "firc", "fxosc", };
>  static const char *slow_sels[]	= { "sirc_32k", "sxosc", };
> -static const char *pll1_sels[]	= { "pll1_main", "pll1_pfd1",
> "pll1_pfd2", "pll1_pfd3", "pll1_pfd4", };
> -static const char *pll2_sels[]	= { "pll2_main", "pll2_pfd1",
> "pll2_pfd2", "pll2_pfd3", "pll2_pfd4", };
> -static const char *sys_sels[]	= { "fast_clk_sel", "slow_clk_sel",
> "pll2_pfd_sel", "pll2_main", "pll1_pfd_sel", "pll3_main", };
> +static const char *pll1_sels[]	= { "pll1_sys", "pll1_pfd1",
> "pll1_pfd2", "pll1_pfd3", "pll1_pfd4", };
> +static const char *pll2_sels[]	= { "pll2_bus", "pll2_pfd1",
> "pll2_pfd2", "pll2_pfd3", "pll2_pfd4", };
> +static const char *pll_bypass_src_sels[] = { "fast_clk_sel", "lvds1_in", };
> +static const char *pll1_bypass_sels[] = { "pll1", "pll1_bypass_src", };
> +static const char *pll2_bypass_sels[] = { "pll2", "pll2_bypass_src", };
> +static const char *pll3_bypass_sels[] = { "pll3", "pll3_bypass_src", };
> +static const char *pll4_bypass_sels[] = { "pll4", "pll4_bypass_src", };
> +static const char *pll5_bypass_sels[] = { "pll5", "pll5_bypass_src", };
> +static const char *pll6_bypass_sels[] = { "pll6", "pll6_bypass_src", };
> +static const char *pll7_bypass_sels[] = { "pll7", "pll7_bypass_src", };
> +static const char *sys_sels[]	= { "fast_clk_sel", "slow_clk_sel",
> "pll2_pfd_sel", "pll2_bus", "pll1_pfd_sel", "pll3_usb_otg", };
>  static const char *ddr_sels[]	= { "pll2_pfd2", "sys_sel", };
>  static const char *rmii_sels[]	= { "enet_ext", "audio_ext",
> "enet_50m", "enet_25m", };
>  static const char *enet_ts_sels[]	= { "enet_ext", "fxosc",
> "audio_ext", "usb", "enet_ts", "enet_25m", "enet_50m", };
> -static const char *esai_sels[]	= { "audio_ext", "mlb", "spdif_rx",
> "pll4_main_div", };
> -static const char *sai_sels[]	= { "audio_ext", "mlb", "spdif_rx",
> "pll4_main_div", };
> +static const char *esai_sels[]	= { "audio_ext", "mlb", "spdif_rx",
> "pll4_audio_div", };
> +static const char *sai_sels[]	= { "audio_ext", "mlb", "spdif_rx",
> "pll4_audio_div", };
>  static const char *nfc_sels[]	= { "platform_bus", "pll1_pfd1",
> "pll3_pfd1", "pll3_pfd3", };
> -static const char *qspi_sels[]	= { "pll3_main", "pll3_pfd4",
> "pll2_pfd4", "pll1_pfd4", };
> -static const char *esdhc_sels[]	= { "pll3_main", "pll3_pfd3",
> "pll1_pfd3", "platform_bus", };
> -static const char *dcu_sels[]	= { "pll1_pfd2", "pll3_main", };
> +static const char *qspi_sels[]	= { "pll3_usb_otg", "pll3_pfd4",
> "pll2_pfd4", "pll1_pfd4", };
> +static const char *esdhc_sels[]	= { "pll3_usb_otg", "pll3_pfd3",
> "pll1_pfd3", "platform_bus", };
> +static const char *dcu_sels[]	= { "pll1_pfd2", "pll3_usb_otg", };
>  static const char *gpu_sels[]	= { "pll2_pfd2", "pll3_pfd2", };
> -static const char *vadc_sels[]	= { "pll6_main_div", "pll3_main_div",
> "pll3_main", };
> +static const char *vadc_sels[]	= { "pll6_video_div",
> "pll3_usb_otg_div", "pll3_usb_otg", };
>  /* FTM counter clock source, not module clock */
>  static const char *ftm_ext_sels[]	= {"sirc_128k", "sxosc",
> "fxosc_half", "audio_ext", };
>  static const char *ftm_fix_sels[]	= { "sxosc", "ipg_bus", };
>  
> -static struct clk_div_table pll4_main_div_table[] = {
> +
> +static struct clk_div_table pll4_audio_div_table[] = {
>  	{ .val = 0, .div = 1 },
>  	{ .val = 1, .div = 2 },
>  	{ .val = 2, .div = 6 },
> @@ -120,6 +135,9 @@ static void __init vf610_clocks_init(struct
> device_node *ccm_node)
>  	clk[VF610_CLK_AUDIO_EXT] = imx_obtain_fixed_clock("audio_ext", 0);
>  	clk[VF610_CLK_ENET_EXT] = imx_obtain_fixed_clock("enet_ext", 0);
>  
> +	/* Clock source from external clock via LVDs PAD */
> +	clk[VF610_CLK_ANACLK1] = imx_obtain_fixed_clock("anaclk1", 0);
> +
>  	clk[VF610_CLK_FXOSC_HALF] = imx_clk_fixed_factor("fxosc_half", "fxosc", 1, 2);
>  
>  	np = of_find_compatible_node(NULL, NULL, "fsl,vf610-anatop");
> @@ -133,31 +151,63 @@ static void __init vf610_clocks_init(struct
> device_node *ccm_node)
>  	clk[VF610_CLK_SLOW_CLK_SEL] = imx_clk_mux("slow_clk_sel", CCM_CCSR,
> 4, 1, slow_sels, ARRAY_SIZE(slow_sels));
>  	clk[VF610_CLK_FASK_CLK_SEL] = imx_clk_mux("fast_clk_sel", CCM_CCSR,
> 5, 1, fast_sels, ARRAY_SIZE(fast_sels));
>  
> -	clk[VF610_CLK_PLL1_MAIN] = imx_clk_fixed_factor("pll1_main",
> "fast_clk_sel", 22, 1);
> -	clk[VF610_CLK_PLL1_PFD1] = imx_clk_pfd("pll1_pfd1", "pll1_main",
> PFD_PLL1_BASE, 0);
> -	clk[VF610_CLK_PLL1_PFD2] = imx_clk_pfd("pll1_pfd2", "pll1_main",
> PFD_PLL1_BASE, 1);
> -	clk[VF610_CLK_PLL1_PFD3] = imx_clk_pfd("pll1_pfd3", "pll1_main",
> PFD_PLL1_BASE, 2);
> -	clk[VF610_CLK_PLL1_PFD4] = imx_clk_pfd("pll1_pfd4", "pll1_main",
> PFD_PLL1_BASE, 3);
> -
> -	clk[VF610_CLK_PLL2_MAIN] = imx_clk_fixed_factor("pll2_main",
> "fast_clk_sel", 22, 1);
> -	clk[VF610_CLK_PLL2_PFD1] = imx_clk_pfd("pll2_pfd1", "pll2_main",
> PFD_PLL2_BASE, 0);
> -	clk[VF610_CLK_PLL2_PFD2] = imx_clk_pfd("pll2_pfd2", "pll2_main",
> PFD_PLL2_BASE, 1);
> -	clk[VF610_CLK_PLL2_PFD3] = imx_clk_pfd("pll2_pfd3", "pll2_main",
> PFD_PLL2_BASE, 2);
> -	clk[VF610_CLK_PLL2_PFD4] = imx_clk_pfd("pll2_pfd4", "pll2_main",
> PFD_PLL2_BASE, 3);
> -
> -	clk[VF610_CLK_PLL3_MAIN] = imx_clk_fixed_factor("pll3_main",
> "fast_clk_sel", 20, 1);
> -	clk[VF610_CLK_PLL3_PFD1] = imx_clk_pfd("pll3_pfd1", "pll3_main",
> PFD_PLL3_BASE, 0);
> -	clk[VF610_CLK_PLL3_PFD2] = imx_clk_pfd("pll3_pfd2", "pll3_main",
> PFD_PLL3_BASE, 1);
> -	clk[VF610_CLK_PLL3_PFD3] = imx_clk_pfd("pll3_pfd3", "pll3_main",
> PFD_PLL3_BASE, 2);
> -	clk[VF610_CLK_PLL3_PFD4] = imx_clk_pfd("pll3_pfd4", "pll3_main",
> PFD_PLL3_BASE, 3);
> -
> -	clk[VF610_CLK_PLL4_MAIN] = imx_clk_fixed_factor("pll4_main",
> "fast_clk_sel", 25, 1);
> -	/* Enet pll: fixed 50Mhz */
> -	clk[VF610_CLK_PLL5_MAIN] = imx_clk_fixed_factor("pll5_main",
> "fast_clk_sel", 125, 6);
> -	/* pll6: default 960Mhz */
> -	clk[VF610_CLK_PLL6_MAIN] = imx_clk_fixed_factor("pll6_main",
> "fast_clk_sel", 40, 1);
> -	/* pll7: USB1 PLL at 480MHz */
> -	clk[VF610_CLK_PLL7_MAIN] = imx_clk_pllv3(IMX_PLLV3_USB,	"pll7_main",
> "fast_clk_sel", PLL7_CTRL, 0x2);
> +	clk[VF610_CLK_PLL1_BYPASS_SRC] = imx_clk_mux("pll1_bypass_src",
> PLL1_CTRL, 14, 1, pll_bypass_src_sels,
> ARRAY_SIZE(pll_bypass_src_sels));
> +	clk[VF610_CLK_PLL2_BYPASS_SRC] = imx_clk_mux("pll2_bypass_src",
> PLL2_CTRL, 14, 1, pll_bypass_src_sels,
> ARRAY_SIZE(pll_bypass_src_sels));
> +	clk[VF610_CLK_PLL3_BYPASS_SRC] = imx_clk_mux("pll3_bypass_src",
> PLL3_CTRL, 14, 1, pll_bypass_src_sels,
> ARRAY_SIZE(pll_bypass_src_sels));
> +	clk[VF610_CLK_PLL4_BYPASS_SRC] = imx_clk_mux("pll4_bypass_src",
> PLL4_CTRL, 14, 1, pll_bypass_src_sels,
> ARRAY_SIZE(pll_bypass_src_sels));
> +	clk[VF610_CLK_PLL5_BYPASS_SRC] = imx_clk_mux("pll5_bypass_src",
> PLL5_CTRL, 14, 1, pll_bypass_src_sels,
> ARRAY_SIZE(pll_bypass_src_sels));
> +	clk[VF610_CLK_PLL6_BYPASS_SRC] = imx_clk_mux("pll6_bypass_src",
> PLL6_CTRL, 14, 1, pll_bypass_src_sels,
> ARRAY_SIZE(pll_bypass_src_sels));
> +	clk[VF610_CLK_PLL7_BYPASS_SRC] = imx_clk_mux("pll7_bypass_src",
> PLL7_CTRL, 14, 1, pll_bypass_src_sels,
> ARRAY_SIZE(pll_bypass_src_sels));
> +
> +	clk[VF610_CLK_PLL1] = imx_clk_pllv3(IMX_PLLV3_GENERIC, "pll1",
> "pll1_bypass_src", PLL1_CTRL, 0x1);
> +	clk[VF610_CLK_PLL2] = imx_clk_pllv3(IMX_PLLV3_GENERIC, "pll2",
> "pll2_bypass_src", PLL2_CTRL, 0x1);
> +	clk[VF610_CLK_PLL3] = imx_clk_pllv3(IMX_PLLV3_USB,     "pll3",
> "pll3_bypass_src", PLL3_CTRL, 0x1);
> +	clk[VF610_CLK_PLL4] = imx_clk_pllv3(IMX_PLLV3_AV,      "pll4",
> "pll4_bypass_src", PLL4_CTRL, 0x7f);
> +	clk[VF610_CLK_PLL5] = imx_clk_pllv3(IMX_PLLV3_ENET,    "pll5",
> "pll5_bypass_src", PLL5_CTRL, 0x3);
> +	clk[VF610_CLK_PLL6] = imx_clk_pllv3(IMX_PLLV3_AV,      "pll6",
> "pll6_bypass_src", PLL6_CTRL, 0x7f);
> +	clk[VF610_CLK_PLL7] = imx_clk_pllv3(IMX_PLLV3_USB,     "pll7",
> "pll7_bypass_src", PLL7_CTRL, 0x1);
> +
> +	clk[VF610_PLL1_BYPASS] = imx_clk_mux_flags("pll1_bypass", PLL1_CTRL,
> 16, 1, pll1_bypass_sels, ARRAY_SIZE(pll1_bypass_sels),
> CLK_SET_RATE_PARENT);
> +	clk[VF610_PLL2_BYPASS] = imx_clk_mux_flags("pll2_bypass", PLL2_CTRL,
> 16, 1, pll2_bypass_sels, ARRAY_SIZE(pll2_bypass_sels),
> CLK_SET_RATE_PARENT);
> +	clk[VF610_PLL3_BYPASS] = imx_clk_mux_flags("pll3_bypass", PLL3_CTRL,
> 16, 1, pll3_bypass_sels, ARRAY_SIZE(pll3_bypass_sels),
> CLK_SET_RATE_PARENT);
> +	clk[VF610_PLL4_BYPASS] = imx_clk_mux_flags("pll4_bypass", PLL4_CTRL,
> 16, 1, pll4_bypass_sels, ARRAY_SIZE(pll4_bypass_sels),
> CLK_SET_RATE_PARENT);
> +	clk[VF610_PLL5_BYPASS] = imx_clk_mux_flags("pll5_bypass", PLL5_CTRL,
> 16, 1, pll5_bypass_sels, ARRAY_SIZE(pll5_bypass_sels),
> CLK_SET_RATE_PARENT);
> +	clk[VF610_PLL6_BYPASS] = imx_clk_mux_flags("pll6_bypass", PLL6_CTRL,
> 16, 1, pll6_bypass_sels, ARRAY_SIZE(pll6_bypass_sels),
> CLK_SET_RATE_PARENT);
> +	clk[VF610_PLL7_BYPASS] = imx_clk_mux_flags("pll7_bypass", PLL7_CTRL,
> 16, 1, pll7_bypass_sels, ARRAY_SIZE(pll7_bypass_sels),
> CLK_SET_RATE_PARENT);
> +
> +	/* Do not bypass PLLs initially */
> +	clk_set_parent(clk[VF610_PLL1_BYPASS], clk[VF610_CLK_PLL1]);
> +	clk_set_parent(clk[VF610_PLL2_BYPASS], clk[VF610_CLK_PLL2]);
> +	clk_set_parent(clk[VF610_PLL3_BYPASS], clk[VF610_CLK_PLL3]);
> +	clk_set_parent(clk[VF610_PLL4_BYPASS], clk[VF610_CLK_PLL4]);
> +	clk_set_parent(clk[VF610_PLL5_BYPASS], clk[VF610_CLK_PLL5]);
> +	clk_set_parent(clk[VF610_PLL6_BYPASS], clk[VF610_CLK_PLL6]);
> +	clk_set_parent(clk[VF610_PLL7_BYPASS], clk[VF610_CLK_PLL7]);
> +
> +	clk[VF610_CLK_PLL1_SYS]      = imx_clk_gate("pll1_sys",     
> "pll1_bypass", PLL1_CTRL, 13);
> +	clk[VF610_CLK_PLL2_BUS]      = imx_clk_gate("pll2_bus",     
> "pll2_bypass", PLL2_CTRL, 13);
> +	clk[VF610_CLK_PLL3_USB_OTG]  = imx_clk_gate("pll3_usb_otg", 
> "pll3_bypass", PLL3_CTRL, 13);
> +	clk[VF610_CLK_PLL4_AUDIO]    = imx_clk_gate("pll4_audio",   
> "pll4_bypass", PLL4_CTRL, 13);
> +	clk[VF610_CLK_PLL5_ENET]     = imx_clk_gate("pll5_enet",    
> "pll5_bypass", PLL5_CTRL, 13);
> +	clk[VF610_CLK_PLL6_VIDEO]    = imx_clk_gate("pll6_video",   
> "pll6_bypass", PLL6_CTRL, 13);
> +	clk[VF610_CLK_PLL7_USB_HOST] = imx_clk_gate("pll7_usb_host",
> "pll7_bypass", PLL7_CTRL, 13);
> +
> +	clk[VF610_CLK_LVDS1_IN]  = imx_clk_gate_exclusive("lvds1_in",
> "anaclk1", ANA_MISC1, 12, BIT(10));
> +
> +	clk[VF610_CLK_PLL1_PFD1] = imx_clk_pfd("pll1_pfd1", "pll1_sys",
> PFD_PLL1_BASE, 0);
> +	clk[VF610_CLK_PLL1_PFD2] = imx_clk_pfd("pll1_pfd2", "pll1_sys",
> PFD_PLL1_BASE, 1);
> +	clk[VF610_CLK_PLL1_PFD3] = imx_clk_pfd("pll1_pfd3", "pll1_sys",
> PFD_PLL1_BASE, 2);
> +	clk[VF610_CLK_PLL1_PFD4] = imx_clk_pfd("pll1_pfd4", "pll1_sys",
> PFD_PLL1_BASE, 3);
> +
> +	clk[VF610_CLK_PLL2_PFD1] = imx_clk_pfd("pll2_pfd1", "pll2_bus",
> PFD_PLL2_BASE, 0);
> +	clk[VF610_CLK_PLL2_PFD2] = imx_clk_pfd("pll2_pfd2", "pll2_bus",
> PFD_PLL2_BASE, 1);
> +	clk[VF610_CLK_PLL2_PFD3] = imx_clk_pfd("pll2_pfd3", "pll2_bus",
> PFD_PLL2_BASE, 2);
> +	clk[VF610_CLK_PLL2_PFD4] = imx_clk_pfd("pll2_pfd4", "pll2_bus",
> PFD_PLL2_BASE, 3);
> +
> +	clk[VF610_CLK_PLL3_PFD1] = imx_clk_pfd("pll3_pfd1", "pll3_usb_otg",
> PFD_PLL3_BASE, 0);
> +	clk[VF610_CLK_PLL3_PFD2] = imx_clk_pfd("pll3_pfd2", "pll3_usb_otg",
> PFD_PLL3_BASE, 1);
> +	clk[VF610_CLK_PLL3_PFD3] = imx_clk_pfd("pll3_pfd3", "pll3_usb_otg",
> PFD_PLL3_BASE, 2);
> +	clk[VF610_CLK_PLL3_PFD4] = imx_clk_pfd("pll3_pfd4", "pll3_usb_otg",
> PFD_PLL3_BASE, 3);
>  
>  	clk[VF610_CLK_PLL1_PFD_SEL] = imx_clk_mux("pll1_pfd_sel", CCM_CCSR,
> 16, 3, pll1_sels, 5);
>  	clk[VF610_CLK_PLL2_PFD_SEL] = imx_clk_mux("pll2_pfd_sel", CCM_CCSR,
> 19, 3, pll2_sels, 5);
> @@ -167,12 +217,12 @@ static void __init vf610_clocks_init(struct
> device_node *ccm_node)
>  	clk[VF610_CLK_PLATFORM_BUS] = imx_clk_divider("platform_bus",
> "sys_bus", CCM_CACRR, 3, 3);
>  	clk[VF610_CLK_IPG_BUS] = imx_clk_divider("ipg_bus", "platform_bus",
> CCM_CACRR, 11, 2);
>  
> -	clk[VF610_CLK_PLL3_MAIN_DIV] = imx_clk_divider("pll3_main_div",
> "pll3_main", CCM_CACRR, 20, 1);
> -	clk[VF610_CLK_PLL4_MAIN_DIV] = clk_register_divider_table(NULL,
> "pll4_main_div", "pll4_main", 0, CCM_CACRR, 6, 3, 0,
> pll4_main_div_table, &imx_ccm_lock);
> -	clk[VF610_CLK_PLL6_MAIN_DIV] = imx_clk_divider("pll6_main_div",
> "pll6_main", CCM_CACRR, 21, 1);
> +	clk[VF610_CLK_PLL3_MAIN_DIV] = imx_clk_divider("pll3_usb_otg_div",
> "pll3_usb_otg", CCM_CACRR, 20, 1);
> +	clk[VF610_CLK_PLL4_MAIN_DIV] = clk_register_divider_table(NULL,
> "pll4_audio_div", "pll4_audio", 0, CCM_CACRR, 6, 3, 0,
> pll4_audio_div_table, &imx_ccm_lock);
> +	clk[VF610_CLK_PLL6_MAIN_DIV] = imx_clk_divider("pll6_video_div",
> "pll6_video", CCM_CACRR, 21, 1);
>  
> -	clk[VF610_CLK_USBPHY0] = imx_clk_gate("usbphy0", "pll3_main", PLL3_CTRL, 6);
> -	clk[VF610_CLK_USBPHY1] = imx_clk_gate("usbphy1", "pll7_main", PLL7_CTRL, 6);
> +	clk[VF610_CLK_USBPHY0] = imx_clk_gate("usbphy0", "pll3_usb_otg",
> PLL3_CTRL, 6);
> +	clk[VF610_CLK_USBPHY1] = imx_clk_gate("usbphy1", "pll7_usb_host",
> PLL7_CTRL, 6);
>  
>  	clk[VF610_CLK_USBC0] = imx_clk_gate2("usbc0", "ipg_bus", CCM_CCGR1,
> CCM_CCGRx_CGn(4));
>  	clk[VF610_CLK_USBC1] = imx_clk_gate2("usbc1", "ipg_bus", CCM_CCGR7,
> CCM_CCGRx_CGn(4));
> @@ -191,8 +241,8 @@ static void __init vf610_clocks_init(struct
> device_node *ccm_node)
>  	clk[VF610_CLK_QSPI1_X1_DIV] = imx_clk_divider("qspi1_x1",
> "qspi1_x2", CCM_CSCDR3, 11, 1);
>  	clk[VF610_CLK_QSPI1] = imx_clk_gate2("qspi1", "qspi1_x1", CCM_CCGR8,
> CCM_CCGRx_CGn(4));
>  
> -	clk[VF610_CLK_ENET_50M] = imx_clk_fixed_factor("enet_50m",
> "pll5_main", 1, 10);
> -	clk[VF610_CLK_ENET_25M] = imx_clk_fixed_factor("enet_25m",
> "pll5_main", 1, 20);
> +	clk[VF610_CLK_ENET_50M] = imx_clk_fixed_factor("enet_50m",
> "pll5_enet", 1, 10);
> +	clk[VF610_CLK_ENET_25M] = imx_clk_fixed_factor("enet_25m",
> "pll5_enet", 1, 20);
>  	clk[VF610_CLK_ENET_SEL] = imx_clk_mux("enet_sel", CCM_CSCMR2, 4, 2,
> rmii_sels, 4);
>  	clk[VF610_CLK_ENET_TS_SEL] = imx_clk_mux("enet_ts_sel", CCM_CSCMR2,
> 0, 3, enet_ts_sels, 7);
>  	clk[VF610_CLK_ENET] = imx_clk_gate("enet", "enet_sel", CCM_CSCDR1, 24);
> diff --git a/include/dt-bindings/clock/vf610-clock.h
> b/include/dt-bindings/clock/vf610-clock.h
> index d6b56b2..801c0ac 100644
> --- a/include/dt-bindings/clock/vf610-clock.h
> +++ b/include/dt-bindings/clock/vf610-clock.h
> @@ -21,24 +21,24 @@
>  #define VF610_CLK_FASK_CLK_SEL		8
>  #define VF610_CLK_AUDIO_EXT		9
>  #define VF610_CLK_ENET_EXT		10
> -#define VF610_CLK_PLL1_MAIN		11
> +#define VF610_CLK_PLL1_SYS		11
>  #define VF610_CLK_PLL1_PFD1		12
>  #define VF610_CLK_PLL1_PFD2		13
>  #define VF610_CLK_PLL1_PFD3		14
>  #define VF610_CLK_PLL1_PFD4		15
> -#define VF610_CLK_PLL2_MAIN		16
> +#define VF610_CLK_PLL2_BUS		16
>  #define VF610_CLK_PLL2_PFD1		17
>  #define VF610_CLK_PLL2_PFD2		18
>  #define VF610_CLK_PLL2_PFD3		19
>  #define VF610_CLK_PLL2_PFD4		20
> -#define VF610_CLK_PLL3_MAIN		21
> +#define VF610_CLK_PLL3_USB_OTG		21
>  #define VF610_CLK_PLL3_PFD1		22
>  #define VF610_CLK_PLL3_PFD2		23
>  #define VF610_CLK_PLL3_PFD3		24
>  #define VF610_CLK_PLL3_PFD4		25
> -#define VF610_CLK_PLL4_MAIN		26
> -#define VF610_CLK_PLL5_MAIN		27
> -#define VF610_CLK_PLL6_MAIN		28
> +#define VF610_CLK_PLL4_AUDIO		26
> +#define VF610_CLK_PLL5_ENET		27
> +#define VF610_CLK_PLL6_VIDEO		28
>  #define VF610_CLK_PLL3_MAIN_DIV		29
>  #define VF610_CLK_PLL4_MAIN_DIV		30
>  #define VF610_CLK_PLL6_MAIN_DIV		31
> @@ -166,9 +166,32 @@
>  #define VF610_CLK_DMAMUX3		153
>  #define VF610_CLK_FLEXCAN0_EN		154
>  #define VF610_CLK_FLEXCAN1_EN		155
> -#define VF610_CLK_PLL7_MAIN		156
> +#define VF610_CLK_PLL7_USB_HOST		156
>  #define VF610_CLK_USBPHY0		157
>  #define VF610_CLK_USBPHY1		158
> -#define VF610_CLK_END			159
> +#define VF610_CLK_LVDS1_IN		159
> +#define VF610_CLK_ANACLK1		160
> +#define VF610_CLK_PLL1_BYPASS_SRC	161
> +#define VF610_CLK_PLL2_BYPASS_SRC	162
> +#define VF610_CLK_PLL3_BYPASS_SRC	163
> +#define VF610_CLK_PLL4_BYPASS_SRC	164
> +#define VF610_CLK_PLL5_BYPASS_SRC	165
> +#define VF610_CLK_PLL6_BYPASS_SRC	166
> +#define VF610_CLK_PLL7_BYPASS_SRC	167
> +#define VF610_CLK_PLL1			168
> +#define VF610_CLK_PLL2			169
> +#define VF610_CLK_PLL3			170
> +#define VF610_CLK_PLL4			171
> +#define VF610_CLK_PLL5			172
> +#define VF610_CLK_PLL6			173
> +#define VF610_CLK_PLL7			174
> +#define VF610_PLL1_BYPASS		175
> +#define VF610_PLL2_BYPASS		176
> +#define VF610_PLL3_BYPASS		177
> +#define VF610_PLL4_BYPASS		178
> +#define VF610_PLL5_BYPASS		179
> +#define VF610_PLL6_BYPASS		180
> +#define VF610_PLL7_BYPASS		181
> +#define VF610_CLK_END			182
>  
>  #endif /* __DT_BINDINGS_CLOCK_VF610_H */
