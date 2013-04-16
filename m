Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3DPPcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:32:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42045 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753773Ab3DPPcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:32:20 -0400
Date: Tue, 16 Apr 2013 11:32:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <holler@ahsoftware.de>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: ehci-omap: Improve PHY error handling
In-Reply-To: <1366026636-29198-2-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1304161130590.1391-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Roger Quadros wrote:

> As the USB PHY layer never returns NULL we don't need
> to check for that condition.
> 
> If we fail to get the PHY device it could be due
> to missing USB PHY drivers. Give this hint to the user
> in the error message.
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/host/ehci-omap.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 5de3e43..2e34ddd 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -175,13 +175,13 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>  			phy = devm_usb_get_phy_by_phandle(dev, "phys", i);
>  		else
>  			phy = devm_usb_get_phy_dev(dev, i);
> -		if (IS_ERR(phy) || !phy) {
> +		if (IS_ERR(phy)) {
>  			/* Don't bail out if PHY is not absolutely necessary */
>  			if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
>  				continue;
>  
> -			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
> -			dev_err(dev, "Can't get PHY device for port %d: %d\n",
> +			ret = PTR_ERR(phy);
> +			dev_err(dev, "Can't get PHY device for port %d: %d. Is USB_PHY driver enabled?\n",
>  					i, ret);
>  			goto err_phy;
>  		}

Getting rid of the !phy test is good.  But I'm doubtful about the 
change to the error message.  Are you going to make a similar change to 
every platform driver?  There doesn't seem to be any reason to do this 
for ehci-omap but not the others.

Alan Stern

