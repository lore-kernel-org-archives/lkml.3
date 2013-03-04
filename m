Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab3CDRID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:08:03 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:56264 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605Ab3CDRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:08:00 -0500
Message-ID: <5134E331.30303@cogentembedded.com>
Date: Mon, 04 Mar 2013 21:08:49 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Frederik Himpe <fhimpe@vub.ac.be>,
        David Haerdeman <david@hardeman.nu>
Subject: Re: [PATCH][v3] xhci: correctly enable interrupts
References: <Pine.LNX.4.44L0.1303041025470.1750-100000@iolanthe.rowland.org> <1742014.AbCVskUi8i@skinner.arch.suse.de>
In-Reply-To: <1742014.AbCVskUi8i@skinner.arch.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/04/2013 07:14 PM, Thomas Renninger wrote:

> From: Hannes Reinecke<hare@suse.de>
>
> xhci has its own interrupt enabling routine, which will try to
> use MSI-X/MSI if present. So the usb core shouldn't try to enable
> legacy interrupts; on some machines the xhci legacy IRQ setting
> is invalid.
>
> v3: Be careful to not break XHCI_BROKEN_MSI workaround (by trenn)
>
> Cc: Bjorn Helgaas<bhelgaas@google.com>
> Cc: Oliver Neukum<oneukum@suse.de>
> Cc: Thomas Renninger<trenn@suse.de>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: Frederik Himpe<fhimpe@vub.ac.be>
> Cc: David Haerdeman<david@hardeman.nu>
> Cc: Alan Stern<stern@rowland.harvard.edu>
>
> Reviewed-by: Thomas Renninger<trenn@suse.de>
> Signed-off-by: Hannes Reinecke<hare@suse.de>
    Still a couple of style comments...

[...]

> @@ -187,15 +188,19 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>   		return -ENODEV;
>   	dev->current_state = PCI_D0;
>
> -	/* The xHCI driver supports MSI and MSI-X,
> -	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
> +	/*
> +	 * The xHCI driver has its own irq management
> +	 * make sure irq setup is not touched for xhci in generic hcd code
>   	 */
> -	if (!dev->irq&&  (driver->flags&  HCD_MASK) != HCD_USB3) {
> -		dev_err(&dev->dev,
> -			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
> -			pci_name(dev));
> -		retval = -ENODEV;
> -		goto disable_pci;
> +	if ((driver->flags&  HCD_MASK) != HCD_USB3) {
> +		if (!dev->irq) {
> +			dev_err(&dev->dev,
> +			"Found HC with no IRQ. Check BIOS/PCI %s setup!\n",
>    

    Could you indent the string like the line below?

> +				pci_name(dev));
> +			retval = -ENODEV;
> +			goto disable_pci;
> +		}
> +		hcd_irq = dev->irq;
>   	}
>
>   	hcd = usb_create_hcd(driver,&dev->dev, pci_name(dev));
>    
[...]
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index f1f01a8..849470b 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
>    
[...]
> @@ -371,6 +371,7 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
>   		return -EINVAL;
>   	}
>
> + legacy_irq:
>    

    Labels shouldn't be indented by a space (unless the existing coding 
style has them indented already, of course).
Although that might be a rule dropped by checkpatch.pl already -- it 
doesn't complain.

WBR, Sergei

