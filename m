Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659AbaDVR6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:58:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42664 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933643AbaDVR6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:58:34 -0400
Date: Tue, 22 Apr 2014 13:58:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <kgene.kim@samsung.com>,
        <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] usb: ohci-exynos: Add facility to use phy provided by
 the generic phy framework
In-Reply-To: <1397136261-16408-1-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1404221350300.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014, Vivek Gautam wrote:

> Add support to consume phy provided by Generic phy framework.
> Keeping the support for older usb-phy intact right now, in order
> to prevent any functionality break in absence of relevant
> device tree side change for ohci-exynos.
> Once we move to new phy in the device nodes for ohci, we can
> remove the support for older phys.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>

> +static int exynos_ohci_phyg_on(struct phy *phy, bool on)
> +{
> +	int ret = 0;
> +
> +	if (phy) {
> +		if (on)
> +			ret = phy_power_on(phy);
> +		else
> +			ret = phy_power_off(phy);
> +	}
> +
> +	return ret;
> +}

This would be cleaner if you had separate routines for 
exynos_ohci_phyg_of and exynos_ohci_phyg_off.  For example:

static int exynos_ohci_phyg_on(struct phy *phy)
{
	return phy ? phy_power_on(phy) : 0;
}

> @@ -88,16 +104,49 @@ static int exynos_ohci_probe(struct platform_device *pdev)
>  					"samsung,exynos5440-ohci"))
>  		goto skip_phy;
>  
> -	phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> -	if (IS_ERR(phy)) {
> -		usb_put_hcd(hcd);
> -		dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
> -		return -EPROBE_DEFER;
> +	exynos_ohci->phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
> +	if (IS_ERR(exynos_ohci->phy)) {
> +		err = PTR_ERR(exynos_ohci->phy);
> +		if (err == -ENXIO || err == -ENODEV) {
> +			exynos_ohci->phy = NULL;
> +		} else if (err == -EPROBE_DEFER) {
> +			usb_put_hcd(hcd);
> +			return err;
> +		} else {
> +			dev_err(&pdev->dev, "no usb2 phy configured\n");
> +			usb_put_hcd(hcd);
> +			return err;
> +		}

Instead of all the calls to usb_put_hcd() here and below, just goto 
fail_clk.  Or add a new fail_phy label at the same spot and goto it.

Otherwise this looks basically okay.

Alan Stern

