Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab3KLS1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:27:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54200 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab3KLS1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:27:32 -0500
Message-ID: <52827311.6060206@codeaurora.org>
Date: Tue, 12 Nov 2013 13:27:29 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH v4 01/15] usb: phy: msm: Move mach dependent code to platform
 data
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com> <1384267910-32066-2-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1384267910-32066-2-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On 11/12/2013 09:51 AM, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> This patch fix compilation error when driver is compiled
> in multi-platform builds.
> 
> drivers/built-in.o: In function `msm_otg_link_clk_reset':
> ./drivers/usb/phy/phy-msm-usb.c:314: undefined reference to `clk_reset'
> ./drivers/usb/phy/phy-msm-usb.c:318: undefined reference to `clk_reset'
> 
> Use platform data supplied reset handlers and adjust error
> messages reported when reset sequence fail.
> 
> This is an intermediate step before adding support for reset
> framework and newer targets.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Acked-by: David Brown <davidb@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++++++++++++++
>  arch/arm/mach-msm/board-qsd8x50.c |   35 +++++++++++++++++++++++++++++++++++
>  drivers/usb/phy/phy-msm-usb.c     |   35 +++++++++++++++--------------------
>  include/linux/usb/msm_hsusb.h     |    3 +++
>  4 files changed, 88 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
> index f9af5a4..46de789 100644
> --- a/arch/arm/mach-msm/board-msm7x30.c
> +++ b/arch/arm/mach-msm/board-msm7x30.c
> @@ -30,6 +30,7 @@
>  #include <asm/memory.h>
>  #include <asm/setup.h>
>  
> +#include <mach/clk.h>
>  #include <mach/msm_iomap.h>
>  #include <mach/dma.h>
>  
> @@ -60,10 +61,44 @@ static int hsusb_phy_init_seq[] = {
>  	-1
>  };
>  
> +static int hsusb_link_clk_reset(struct clk *link_clk, bool assert)
> +{
> +	int ret;
> +
> +	if (assert) {
> +		ret = clk_reset(link_clk, CLK_RESET_ASSERT);
> +		if (ret)
> +			pr_err("usb hs_clk assert failed\n");
> +	} else {
> +		ret = clk_reset(link_clk, CLK_RESET_DEASSERT);
> +		if (ret)
> +			pr_err("usb hs_clk deassert failed\n");
> +	}
> +	return ret;
> +}
> +
> +static int hsusb_phy_clk_reset(struct clk *phy_clk)
> +{
> +	int ret;
> +
> +	ret = clk_reset(phy_clk, CLK_RESET_ASSERT);
> +	if (ret) {
> +		pr_err("usb phy clk assert failed\n");
> +		return ret;
> +	}
> +	usleep_range(10000, 12000);
> +	ret = clk_reset(phy_clk, CLK_RESET_DEASSERT);
> +	if (ret)
> +		pr_err("usb phy clk deassert failed\n");
> +	return ret;
> +}
> +
>  static struct msm_otg_platform_data msm_otg_pdata = {
>  	.phy_init_seq		= hsusb_phy_init_seq,
>  	.mode                   = USB_PERIPHERAL,
>  	.otg_control		= OTG_PHY_CONTROL,
> +	.link_clk_reset		= hsusb_link_clk_reset,
> +	.phy_clk_reset		= hsusb_phy_clk_reset,
>  };
>  
>  struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
> diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
> index 5f933bc..9169ec3 100644
> --- a/arch/arm/mach-msm/board-qsd8x50.c
> +++ b/arch/arm/mach-msm/board-qsd8x50.c
> @@ -31,6 +31,7 @@
>  #include <mach/irqs.h>
>  #include <mach/sirc.h>
>  #include <mach/vreg.h>
> +#include <mach/clk.h>
>  #include <linux/platform_data/mmc-msm_sdcc.h>
>  
>  #include "devices.h"
> @@ -81,10 +82,44 @@ static int hsusb_phy_init_seq[] = {
>  	-1
>  };
>  
> +static int hsusb_link_clk_reset(struct clk *link_clk, bool assert)
> +{
> +	int ret;
> +
> +	if (assert) {
> +		ret = clk_reset(link_clk, CLK_RESET_ASSERT);
> +		if (ret)
> +			pr_err("usb hs_clk assert failed\n");
> +	} else {
> +		ret = clk_reset(link_clk, CLK_RESET_DEASSERT);
> +		if (ret)
> +			pr_err("usb hs_clk deassert failed\n");
> +	}
> +	return ret;
> +}
> +
> +static int hsusb_phy_clk_reset(struct clk *phy_clk)
> +{
> +	int ret;
> +
> +	ret = clk_reset(phy_clk, CLK_RESET_ASSERT);
> +	if (ret) {
> +		pr_err("usb phy clk assert failed\n");
> +		return ret;
> +	}
> +	usleep_range(10000, 12000);
> +	ret = clk_reset(phy_clk, CLK_RESET_DEASSERT);
> +	if (ret)
> +		pr_err("usb phy clk deassert failed\n");
> +	return ret;
> +}

Why are there identical, static definitions of hsusb_link_clk_reset and
hsusb_phy_clk_reset across the two board files? Why not share a single
non-static set of definitions?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
