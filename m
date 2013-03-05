Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3CEXiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:38:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:35349 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3CEXiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:38:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="299615321"
Date: Tue, 5 Mar 2013 15:37:38 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Frederik Himpe <fhimpe@vub.ac.be>,
        David Haerdeman <david@hardeman.nu>
Subject: Re: [PATCH][v3] xhci: correctly enable interrupts
Message-ID: <20130305233738.GB9651@xanatos>
References: <Pine.LNX.4.44L0.1303041025470.1750-100000@iolanthe.rowland.org>
 <1742014.AbCVskUi8i@skinner.arch.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1742014.AbCVskUi8i@skinner.arch.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine on the xHCI portion.  Thanks for catching the XHCI_BROKEN_MSI
case.

Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>

On Mon, Mar 04, 2013 at 05:14:43PM +0100, Thomas Renninger wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> xhci has its own interrupt enabling routine, which will try to
> use MSI-X/MSI if present. So the usb core shouldn't try to enable
> legacy interrupts; on some machines the xhci legacy IRQ setting
> is invalid.
> 
> v3: Be careful to not break XHCI_BROKEN_MSI workaround (by trenn)
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Frederik Himpe <fhimpe@vub.ac.be>
> Cc: David Haerdeman <david@hardeman.nu>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> 
> Reviewed-by: Thomas Renninger <trenn@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> 
> diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
> index 622b4a4..2b487d4 100644
> --- a/drivers/usb/core/hcd-pci.c
> +++ b/drivers/usb/core/hcd-pci.c
> @@ -173,6 +173,7 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  	struct hc_driver	*driver;
>  	struct usb_hcd		*hcd;
>  	int			retval;
> +	int			hcd_irq = 0;
>  
>  	if (usb_disabled())
>  		return -ENODEV;
> @@ -187,15 +188,19 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  		return -ENODEV;
>  	dev->current_state = PCI_D0;
>  
> -	/* The xHCI driver supports MSI and MSI-X,
> -	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
> +	/*
> +	 * The xHCI driver has its own irq management
> +	 * make sure irq setup is not touched for xhci in generic hcd code
>  	 */
> -	if (!dev->irq && (driver->flags & HCD_MASK) != HCD_USB3) {
> -		dev_err(&dev->dev,
> -			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
> -			pci_name(dev));
> -		retval = -ENODEV;
> -		goto disable_pci;
> +	if ((driver->flags & HCD_MASK) != HCD_USB3) {
> +		if (!dev->irq) {
> +			dev_err(&dev->dev,
> +			"Found HC with no IRQ. Check BIOS/PCI %s setup!\n",
> +				pci_name(dev));
> +			retval = -ENODEV;
> +			goto disable_pci;
> +		}
> +		hcd_irq = dev->irq;
>  	}
>  
>  	hcd = usb_create_hcd(driver, &dev->dev, pci_name(dev));
> @@ -245,7 +250,7 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  
>  	pci_set_master(dev);
>  
> -	retval = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
> +	retval = usb_add_hcd(hcd, hcd_irq, IRQF_SHARED);
>  	if (retval != 0)
>  		goto unmap_registers;
>  	set_hs_companion(dev, hcd);
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index f1f01a8..849470b 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -350,7 +350,7 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
>  	 * generate interrupts.  Don't even try to enable MSI.
>  	 */
>  	if (xhci->quirks & XHCI_BROKEN_MSI)
> -		return 0;
> +		goto legacy_irq;
>  
>  	/* unregister the legacy interrupt */
>  	if (hcd->irq)
> @@ -371,6 +371,7 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
>  		return -EINVAL;
>  	}
>  
> + legacy_irq:
>  	/* fall back to legacy interrupt*/
>  	ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
>  			hcd->irq_descr, hcd);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
