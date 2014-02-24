Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaBXRot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:44:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42594 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752314AbaBXRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:44:48 -0500
Date: Mon, 24 Feb 2014 12:44:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mathias Nyman <mathias.nyman@linux.intel.com>
cc: linux-usb@vger.kernel.org, <sarah.a.sharp@linux.intel.com>,
        <david.a.cohen@linux.intel.com>, <jianqiang.tang@intel.com>,
        <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2] xhci: Prevent runtime pm from autosuspending
 during initialization
In-Reply-To: <1393259343-825-1-git-send-email-mathias.nyman@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1402241243230.1427-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Mathias Nyman wrote:

> xHCI driver has its own pci probe function that will call usb_hcd_pci_probe
> to register its usb-2 bus, and then continue to manually register the
> usb-3 bus. usb_hcd_pci_probe does a pm_runtime_put_noidle at the end and
> might thus trigger a runtime suspend before the usb-3 bus is ready.
> 
> Prevent the runtime suspend by increasing the usage count in the
> beginning of xhci_pci_probe, and decrease it once the usb-3 bus is
> ready.
> 
> xhci-platform driver is not using usb_hcd_pci_probe to set up
> busses and should not need to have it's usage count increased during probe.
> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> ---
>  drivers/usb/host/xhci-pci.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 04f986d..ea7158b 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -190,6 +190,10 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  	struct usb_hcd *hcd;
>  
>  	driver = (struct hc_driver *)id->driver_data;
> +
> +	/* Prevent USB-2 roothub runtime suspend until USB-3 is initialized. */
> +	pm_runtime_get_noresume(&dev->dev);

Strictly speaking, this prevents the _controller_ from going into
runtime suspend -- not the root hub.

> +
>  	/* Register the USB 2.0 roothub.
>  	 * FIXME: USB core must know to register the USB 2.0 roothub first.
>  	 * This is sort of silly, because we could just set the HCD driver flags
> @@ -199,7 +203,7 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  	retval = usb_hcd_pci_probe(dev, id);
>  
>  	if (retval)
> -		return retval;
> +		goto put_runtime_pm;
>  
>  	/* USB 2.0 roothub is stored in the PCI device now. */
>  	hcd = dev_get_drvdata(&dev->dev);
> @@ -228,12 +232,17 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>  	if (xhci->quirks & XHCI_LPM_SUPPORT)
>  		hcd_to_bus(xhci->shared_hcd)->root_hub->lpm_capable = 1;
>  
> +	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
> +	pm_runtime_put_noidle(&dev->dev);
> +
>  	return 0;
>  
>  put_usb3_hcd:
>  	usb_put_hcd(xhci->shared_hcd);
>  dealloc_usb2_hcd:
>  	usb_hcd_pci_remove(dev);
> +put_runtime_pm:
> +	pm_runtime_put_noidle(&dev->dev);
>  	return retval;
>  }

Apart from nit about the comment,

Acked-by: Alan Stern <stern@rowland.harvard.edu>

