Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaDYOgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:36:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42547 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753782AbaDYOgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:36:50 -0400
Date: Fri, 25 Apr 2014 10:36:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <k.debski@samsung.com>, <jg1.han@samsung.com>
Subject: Re: [PATCH v2 1/2] usb: ohci-exynos: Add facility to use phy provided
 by the generic phy framework
In-Reply-To: <1398424683-20168-2-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1404251031260.1140-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014, Vivek Gautam wrote:

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


> +static int exynos_ohci_phyg_on(struct phy *phy[])
> +{
> +	int i;
> +	int ret = 0;
> +
> +	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> +		if (phy[i])
> +			ret = phy_power_on(phy[i]);
> +	if (ret)
> +		for (i--; i >= 0; i--)
> +			if (phy[i])
> +				phy_power_off(phy[i]);
> +
> +	return ret;
> +}
> +
> +static int exynos_ohci_phyg_off(struct phy *phy[])
> +{
> +	int i;
> +	int ret = 0;
> +
> +	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> +		if (phy[i])
> +			ret = phy_power_off(phy[i]);
> +
> +	return ret;
> +}

You probably shouldn't break out of this loop if ret is nonzero; you
should continue to power off the remaining phys.

I'd be inclined to put these two routines directly into 
exynos_ohci_phy_enable() and exynos_ohci_phy_disable(), since they 
aren't used anywhere else.

> @@ -151,6 +253,7 @@ skip_phy:
>  
>  fail_add_hcd:
>  	exynos_ohci_phy_disable(pdev);
> +	exynos_ohci_phyg_off(exynos_ohci->phy_g);

Why did you add this line?  It doesn't do anything useful, because 
exynos_ohci_phy_disable() already calls exynos_ohci_phyg_off().

Alan Stern

