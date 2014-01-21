Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaAUOAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:00:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46596 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbaAUOAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:00:48 -0500
Message-ID: <52DE7D75.4040302@ti.com>
Date: Tue, 21 Jan 2014 16:00:21 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>, <balbi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] usb: dwc3: adapt dwc3 core to use Generic PHY
 Framework
References: <1385373690-12170-1-git-send-email-kishon@ti.com> <1390299099-14764-1-git-send-email-kishon@ti.com> <1390299099-14764-2-git-send-email-kishon@ti.com>
In-Reply-To: <1390299099-14764-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 01/21/2014 12:11 PM, Kishon Vijay Abraham I wrote:
> Adapted dwc3 core to use the Generic PHY Framework. So for init, exit,
> power_on and power_off the following APIs are used phy_init(), phy_exit(),
> phy_power_on() and phy_power_off().
> 
> However using the old USB phy library wont be removed till the PHYs of all
> other SoC's using dwc3 core is adapted to the Generic PHY Framework.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> Changes from v3:
> * avoided using quirks
> 
>  Documentation/devicetree/bindings/usb/dwc3.txt |    6 ++-
>  drivers/usb/dwc3/core.c                        |   60 ++++++++++++++++++++++++
>  drivers/usb/dwc3/core.h                        |    7 +++
>  3 files changed, 71 insertions(+), 2 deletions(-)
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
> index e009d4e..036d589 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -82,6 +82,11 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
>  
>  	usb_phy_init(dwc->usb2_phy);
>  	usb_phy_init(dwc->usb3_phy);
> +	if (dwc->usb2_generic_phy)
> +		phy_init(dwc->usb2_generic_phy);

What if phy_init() fails? You need to report and fail. Same applies for all PHY apis in this patch.

> +	if (dwc->usb3_generic_phy)
> +		phy_init(dwc->usb3_generic_phy);
> +
>  	mdelay(100);
>  
>  	/* Clear USB3 PHY reset */
> @@ -343,6 +348,11 @@ static void dwc3_core_exit(struct dwc3 *dwc)
>  {
>  	usb_phy_shutdown(dwc->usb2_phy);
>  	usb_phy_shutdown(dwc->usb3_phy);
> +	if (dwc->usb2_generic_phy)
> +		phy_exit(dwc->usb2_generic_phy);
> +	if (dwc->usb3_generic_phy)
> +		phy_exit(dwc->usb3_generic_phy);
> +
>  }
>  
>  #define DWC3_ALIGN_MASK		(16 - 1)
> @@ -433,6 +443,32 @@ static int dwc3_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
> +	if (IS_ERR(dwc->usb2_generic_phy)) {
> +		ret = PTR_ERR(dwc->usb2_generic_phy);
> +		if (ret == -ENOSYS || ret == -ENODEV) {
> +			dwc->usb2_generic_phy = NULL;
> +		} else if (ret == -EPROBE_DEFER) {
> +			return ret;
> +		} else {
> +			dev_err(dev, "no usb2 phy configured\n");
> +			return ret;
> +		}
> +	}
> +
> +	dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
> +	if (IS_ERR(dwc->usb3_generic_phy)) {
> +		ret = PTR_ERR(dwc->usb3_generic_phy);
> +		if (ret == -ENOSYS || ret == -ENODEV) {
> +			dwc->usb3_generic_phy = NULL;
> +		} else if (ret == -EPROBE_DEFER) {
> +			return ret;
> +		} else {
> +			dev_err(dev, "no usb3 phy configured\n");
> +			return ret;
> +		}
> +	}
> +
>  	dwc->xhci_resources[0].start = res->start;
>  	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
>  					DWC3_XHCI_REGS_END;
> @@ -482,6 +518,11 @@ static int dwc3_probe(struct platform_device *pdev)
>  	usb_phy_set_suspend(dwc->usb2_phy, 0);
>  	usb_phy_set_suspend(dwc->usb3_phy, 0);
>  
> +	if (dwc->usb2_generic_phy)
> +		phy_power_on(dwc->usb2_generic_phy);
> +	if (dwc->usb3_generic_phy)
> +		phy_power_on(dwc->usb3_generic_phy);
> +

Is it OK to power on the phy before phy_init()?

I suggest to move phy_init() from core_soft_reset() to here, just before phy_power_on().

>  	ret = dwc3_event_buffers_setup(dwc);
>  	if (ret) {
>  		dev_err(dwc->dev, "failed to setup event buffers\n");
> @@ -565,6 +606,10 @@ err2:
>  err1:
>  	usb_phy_set_suspend(dwc->usb2_phy, 1);
>  	usb_phy_set_suspend(dwc->usb3_phy, 1);
> +	if (dwc->usb2_generic_phy)
> +		phy_power_off(dwc->usb2_generic_phy);
> +	if (dwc->usb3_generic_phy)
> +		phy_power_off(dwc->usb3_generic_phy);
>  	dwc3_core_exit(dwc);
>  
>  err0:
> @@ -580,6 +625,11 @@ static int dwc3_remove(struct platform_device *pdev)
>  	usb_phy_set_suspend(dwc->usb2_phy, 1);
>  	usb_phy_set_suspend(dwc->usb3_phy, 1);
>  
> +	if (dwc->usb2_generic_phy)
> +		phy_power_off(dwc->usb2_generic_phy);
> +	if (dwc->usb3_generic_phy)
> +		phy_power_off(dwc->usb3_generic_phy);
> +
>  	pm_runtime_put_sync(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
>  
> @@ -677,6 +727,11 @@ static int dwc3_suspend(struct device *dev)
>  	usb_phy_shutdown(dwc->usb3_phy);
>  	usb_phy_shutdown(dwc->usb2_phy);
>  
> +	if (dwc->usb2_generic_phy)
> +		phy_exit(dwc->usb2_generic_phy);
> +	if (dwc->usb3_generic_phy)
> +		phy_exit(dwc->usb3_generic_phy);
> +
>  	return 0;
>  }
>  
> @@ -688,6 +743,11 @@ static int dwc3_resume(struct device *dev)
>  	usb_phy_init(dwc->usb3_phy);
>  	usb_phy_init(dwc->usb2_phy);
>  
> +	if (dwc->usb2_generic_phy)
> +		phy_init(dwc->usb2_generic_phy);
> +	if (dwc->usb3_generic_phy)
> +		phy_init(dwc->usb3_generic_phy);
> +
>  	spin_lock_irqsave(&dwc->lock, flags);
>  
>  	dwc3_writel(dwc->regs, DWC3_GCTL, dwc->gctl);

cheers,
-roger
