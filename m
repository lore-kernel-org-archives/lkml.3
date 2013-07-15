Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3GOOFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:05:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47903 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab3GOOFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:05:44 -0400
Message-ID: <51E40199.9070906@ti.com>
Date: Mon, 15 Jul 2013 17:05:13 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>, <benoit.cousson@linaro.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v2 4/4] ARM: OMAP2+: Provide alias to USB PHY clock
References: <1371571487-14389-1-git-send-email-rogerq@ti.com> <1371571487-14389-5-git-send-email-rogerq@ti.com>
In-Reply-To: <1371571487-14389-5-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 06/18/2013 07:04 PM, Roger Quadros wrote:
> Till the OMAP clocks are correctly defined in device tree, use
> this temporary hack to provide clock alias to the USB PHY clocks.
> 
> Without this, USB Host & Ethernet will not be functional with
> device tree boots on Panda and uEVM.

Looks like this one got missed out.

USB host no longer works on Panda with DT boot.
Could you please queue this for next 3.11-rc? Thanks.

cheers,
-roger

> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/mach-omap2/board-generic.c |   23 ++++++++++++++++++++++-
>  1 files changed, 22 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
> index 88aa6b1..7428733 100644
> --- a/arch/arm/mach-omap2/board-generic.c
> +++ b/arch/arm/mach-omap2/board-generic.c
> @@ -15,6 +15,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
>  #include <linux/irqdomain.h>
> +#include <linux/clk.h>
>  
>  #include <asm/mach/arch.h>
>  
> @@ -35,6 +36,21 @@ static struct of_device_id omap_dt_match_table[] __initdata = {
>  	{ }
>  };
>  
> +/*
> + * Create alias for USB host PHY clock.
> + * Remove this when clock phandle can be provided via DT
> + */
> +static void __init legacy_init_ehci_clk(char *clkname)
> +{
> +	int ret;
> +
> +	ret = clk_add_alias("main_clk", NULL, clkname, NULL);
> +	if (ret) {
> +		pr_err("%s:Failed to add main_clk alias to %s :%d\n",
> +						__func__, clkname, ret);
> +	}
> +}
> +
>  static void __init omap_generic_init(void)
>  {
>  	omap_sdrc_init(NULL, NULL);
> @@ -45,10 +61,15 @@ static void __init omap_generic_init(void)
>  	 * HACK: call display setup code for selected boards to enable omapdss.
>  	 * This will be removed when omapdss supports DT.
>  	 */
> -	if (of_machine_is_compatible("ti,omap4-panda"))
> +	if (of_machine_is_compatible("ti,omap4-panda")) {
>  		omap4_panda_display_init_of();
> +		legacy_init_ehci_clk("auxclk3_ck");
> +
> +	}
>  	else if (of_machine_is_compatible("ti,omap4-sdp"))
>  		omap_4430sdp_display_init_of();
> +	else if (of_machine_is_compatible("ti,omap5-uevm"))
> +		legacy_init_ehci_clk("auxclk1_ck");
>  }
>  
>  #ifdef CONFIG_SOC_OMAP2420
> 

