Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3LJN4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:56:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:41745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab3LJNzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:55:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,865,1378882800"; 
   d="scan'208";a="449857005"
Date: Tue, 10 Dec 2013 15:55:48 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com, kishon@ti.com,
        jg1.han@samsung.com, jwerner@chromium.org
Subject: Re: [PATCH RFC 3/4] xhci: Tune PHY for the DWC3-Exynos host
 controller
Message-ID: <20131210135548.GA28456@xps8300>
References: <1386672926-26885-1-git-send-email-gautam.vivek@samsung.com>
 <1386672926-26885-4-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386672926-26885-4-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 10, 2013 at 04:25:25PM +0530, Vivek Gautam wrote:
> @@ -170,6 +189,15 @@ static int xhci_plat_probe(struct platform_device *pdev)
>  	}
>  
>  	/*
> +	 * The parent of the xhci-plat device may pass in a PHY via
> +	 * platform data.  If it exists, store it in our struct usb_hcd
> +	 * so that we can use it later.
> +	 */
> +	phy_generic = dev_get_platdata(&pdev->dev);
> +	if (phy_generic)
> +		xhci->shared_hcd->phy_generic = *phy_generic;

Getting the handle to the phy from platform data like this is not
going to work for long. It should be possible to get it normally with
phy_get(). It's not going to be possible to get the handle from the
platform data like this if the xhci-hcd platform device is created
from ACPI or DT. You are also not considering case where you have two
phys.

Vivek, I have made a patch set for the phy framework allowing
associations between the phys and their users to be made in same way
gpios and clk make them. With those you should be able to create a
lookup entry to the phy framework in drivers/usb/dwc3/host.c. Then we
could use phy_get() here already. Please check them. Subject of the
thread:

"phy: remove the need for the phys to know about their users"

The lookup table can then be added in drivers/usb/dwc3/host.c with
something like this:

int dwc3_host_init(struct dwc3 *dwc)
{
        struct platform_device  *xhci;
        struct phy_lookup_table *table;
        ...
        table->dev_id = dev_name(&xhci->dev);
        if (dwc->usb2_generic_phy)
                table->table[0].phy_name = dev_name(&dwc->usb2_generic_phy->dev);
        if (dwc->usb3_generic_phy)
                table->table[1].phy_name = dev_name(&dwc->usb3_generic_phy->dev);
        phy_add_lookup_table(table);
        ...

Br,

-- 
heikki
