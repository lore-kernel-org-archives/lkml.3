Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab3GBD10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:27:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:31698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab3GBD1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:27:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,977,1363158000"; 
   d="scan'208";a="339052149"
Date: Mon, 1 Jul 2013 20:27:12 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-usb@vger.kernel.org, balbi@ti.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all
 controllers with xhci 1.0
Message-ID: <20130702032712.GD6262@xanatos>
References: <1372656552-18824-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372656552-18824-1-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks George, this looks fine.  I will munge the description a bit when
I commit it, and mark it for stable as well.

Unfortunately, due to the timing of the merge window, this patch will
have to wait for 2-3 weeks until 3.11-rc1 is out.

Sarah Sharp

On Mon, Jul 01, 2013 at 10:59:12AM +0530, George Cherian wrote:
> Xhci controllers with hci_version > 0.96 gives spurious success
> events on short packet completion. During webcam capture the
> "ERROR Transfer event TRB DMA ptr not part of current TD" was observed.
> The same application works fine with synopsis controllers hci_version 0.96.
> The same Issue is seen with Intel Pantherpoint xhci controller. So enabling
> this quirk in xhci_gen_setup if controller verion is greater than 0.96.
> For xhci-pci move the quirk to much generic place xhci_gen_setup.
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/host/xhci-pci.c | 1 -
>  drivers/usb/host/xhci.c     | 7 +++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index cc24e39..f00cb20 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -93,7 +93,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
>  	}
>  	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
>  			pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
> -		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
>  		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
>  		xhci->limit_active_eps = 64;
>  		xhci->quirks |= XHCI_SW_BW_CHECKING;
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index d8f640b..0f7be59 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -4697,6 +4697,13 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
>  
>  	get_quirks(dev, xhci);
>  
> +	/* In xhci controllers which follow xhci 1.0 spec gives a spurious
> +	 * success event after a short transfer. This quirk will ignore such
> +	 * spurious event.
> +	 */
> +	if (xhci->hci_version > 0x96)
> +		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
> +
>  	/* Make sure the HC is halted. */
>  	retval = xhci_halt(xhci);
>  	if (retval)
> -- 
> 1.8.1.4
> 
