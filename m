Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbaCEOo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:44:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53319 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbaCEOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:44:19 -0500
Message-ID: <53173809.2060303@ti.com>
Date: Wed, 5 Mar 2014 16:43:21 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>,
        <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <s.nawrocki@samsung.com>, <galak@codeaurora.org>
Subject: Re: [PATCH v5 2/6] usb: dwc3: adapt dwc3 core to use Generic PHY
 Framework
References: <1393846695-14644-1-git-send-email-kishon@ti.com> <1393846695-14644-3-git-send-email-kishon@ti.com>
In-Reply-To: <1393846695-14644-3-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 03/03/2014 01:38 PM, Kishon Vijay Abraham I wrote:
> Adapted dwc3 core to use the Generic PHY Framework. So for init, exit,
> power_on and power_off the following APIs are used phy_init(), phy_exit(),
> phy_power_on() and phy_power_off().
> 
> However using the old USB phy library wont be removed till the PHYs of all
> other SoC's using dwc3 core is adapted to the Generic PHY Framework.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/dwc3.txt |    6 +-
>  drivers/usb/dwc3/core.c                        |   86 +++++++++++++++++++++---
>  drivers/usb/dwc3/core.h                        |    7 ++
>  3 files changed, 89 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
> index e807635..471366d 100644
> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
> @@ -6,11 +6,13 @@ Required properties:
>   - compatible: must be "snps,dwc3"
>   - reg : Address and length of the register set for the device
>   - interrupts: Interrupts used by the dwc3 controller.
> +
> +Optional properties:
>   - usb-phy : array of phandle for the PHY device.  The first element
>     in the array is expected to be a handle to the USB2/HS PHY and
>     the second element is expected to be a handle to the USB3/SS PHY
> -
> -Optional properties:
> + - phys: from the *Generic PHY* bindings
> + - phy-names: from the *Generic PHY* bindings
>   - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
>  
>  This is usually a subnode to DWC3 glue to which it is connected.
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 225a4d6..497234a 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -61,9 +61,10 @@ void dwc3_set_mode(struct dwc3 *dwc, u32 mode)
>   * dwc3_core_soft_reset - Issues core soft reset and PHY reset
>   * @dwc: pointer to our context structure
>   */
> -static void dwc3_core_soft_reset(struct dwc3 *dwc)
> +static int dwc3_core_soft_reset(struct dwc3 *dwc)
>  {
>  	u32		reg;
> +	int		ret;
>  
>  	/* Before Resetting PHY, put Core in Reset */
>  	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
> @@ -82,6 +83,15 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
>  
>  	usb_phy_init(dwc->usb2_phy);
>  	usb_phy_init(dwc->usb3_phy);
> +	ret = phy_init(dwc->usb2_generic_phy);

you need to check if dwc->usb?_generic_phy is not NULL before using any of the PHY APIs
throughout this patch.

> +	if (ret < 0)
> +		return ret;
> +
> +	ret = phy_init(dwc->usb3_generic_phy);
> +	if (ret < 0) {
> +		phy_exit(dwc->usb2_generic_phy);
> +		return ret;
> +	}
>  	mdelay(100);
>  
>  	/* Clear USB3 PHY reset */
> @@ -100,6 +110,8 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
>  	reg = dwc3_readl(dwc->regs, DWC3_GCTL);
>  	reg &= ~DWC3_GCTL_CORESOFTRESET;
>  	dwc3_writel(dwc->regs, DWC3_GCTL, reg);
> +
> +	return 0;
>  }
>  

cheers,
-roger

