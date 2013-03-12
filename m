Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab3CLKv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:51:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42062 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3CLKvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:51:25 -0400
Message-ID: <513F089B.5080004@ti.com>
Date: Tue, 12 Mar 2013 16:21:07 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>,
        <b-cousson@ti.com>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 12/12] USB: ehci-omap: Fix detection in HSIC mode
References: <1363085090-24676-1-git-send-email-rogerq@ti.com> <1363085090-24676-13-git-send-email-rogerq@ti.com>
In-Reply-To: <1363085090-24676-13-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 12 March 2013 04:14 PM, Roger Quadros wrote:
> The HSIC devices need to be kept in reset while the EHCI controller
> is being initialized and only brought out of reset after the
> initialization is complete, else HSIC devices will not be detected.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> CC: Alan Stern <stern@rowland.harvard.edu>
> ---
>   drivers/usb/host/ehci-omap.c |   28 +++++++++++-----------------
>   1 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 1ba1df8..52a2d46 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -50,6 +50,7 @@
>   #include <linux/usb/hcd.h>
>   #include <linux/of.h>
>   #include <linux/dma-mapping.h>
> +#include <linux/delay.h>

not needed here I guess.
>
>   #include "ehci.h"
>
> @@ -90,26 +91,13 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
>   static int omap_ehci_init(struct usb_hcd *hcd)
>   {
>   	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
> -	struct omap_hcd	*omap = (struct omap_hcd *)ehci->priv;
> -	int rc, i;
> -
> -	/* Hold PHYs in reset while initializing EHCI controller */
> -	for (i = 0; i < omap->nports; i++) {
> -		if (omap->phy[i])
> -			usb_phy_shutdown(omap->phy[i]);
> -	}
> +	int rc;
>
>   	/* we know this is the memory we want, no need to ioremap again */
>   	ehci->caps = hcd->regs;
>
>   	rc = ehci_setup(hcd);
>
> -	/* Bring PHYs out of reset */
> -	for (i = 0; i < omap->nports; i++) {
> -		if (omap->phy[i])
> -			usb_phy_init(omap->phy[i]);
> -	}
> -
>   	return rc;
>   }
>
> @@ -219,9 +207,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>   		}
>
>   		omap->phy[i] = phy;
> -		usb_phy_init(omap->phy[i]);
> -		/* bring PHY out of suspend */
> -		usb_phy_set_suspend(omap->phy[i], 0);
>   	}
>
>   	pm_runtime_enable(dev);
> @@ -245,6 +230,15 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>   		goto err_pm_runtime;
>   	}
>
> +	/* Bring PHYs out of reset */
> +	for (i = 0; i < omap->nports; i++) {
> +		if (!omap->phy[i])
> +			continue;
> +
> +		usb_phy_init(omap->phy[i]);
> +		/* bring PHY out of suspend */
> +		usb_phy_set_suspend(omap->phy[i], 0);
> +	}

But isn't HSIC supposed to be PHYless devices. Maybe a comment 
explaining it might be helpful.

Thanks
Kishon
