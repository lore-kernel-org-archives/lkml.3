Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3CDN22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:28:28 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:52375 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab3CDN21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:28:27 -0500
Message-ID: <5134A153.6080707@cogentembedded.com>
Date: Mon, 04 Mar 2013 17:27:47 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, David Haerdeman <david@hardeman.nu>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH][v2] xhci: correctly enable interrupts
References: <1362385324-15228-1-git-send-email-hare@suse.de>
In-Reply-To: <1362385324-15228-1-git-send-email-hare@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-03-2013 12:22, Hannes Reinecke wrote:

> xhci has its own interrupt enabling routine, which will try to
> use MSI-X/MSI if present. So the usb core shouldn't try to enable
> legacy interrupts; on some machines the xhci legacy IRQ setting
> is invalid.

> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Frederik Himpe <fhimpe@vub.ac.be>
> Cc: David Haerdeman <david@hardeman.nu>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

> diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
> index 622b4a4..2647e75 100644
> --- a/drivers/usb/core/hcd-pci.c
> +++ b/drivers/usb/core/hcd-pci.c
[...]
> @@ -187,15 +188,21 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
>   		return -ENODEV;
>   	dev->current_state = PCI_D0;
>
> -	/* The xHCI driver supports MSI and MSI-X,
> -	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
> +	/*
> +	 * The xHCI driver supports MSI and MSI-X,
> +	 * so don't fail if the BIOS doesn't provide a legacy IRQ
> +	 * and do not try to enable legacy IRQs.
>   	 */
> -	if (!dev->irq && (driver->flags & HCD_MASK) != HCD_USB3) {
> -		dev_err(&dev->dev,
> -			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
> -			pci_name(dev));
> -		retval = -ENODEV;
> -		goto disable_pci;
> +	if ((driver->flags & HCD_MASK) != HCD_USB3) {
> +		if (!dev->irq) {
> +			dev_err(&dev->dev,
> +				"Found HC with no IRQ.  "
> +				"Check BIOS/PCI %s setup!\n",

    The message strings are allowed to take more than 80 chars (to facilitate 
grepping for them), so no need to break this one; checkpatch.pl should not 
complain...

> +				pci_name(dev));
> +			retval = -ENODEV;
> +			goto disable_pci;
> +		}
> +		hcd_irq = dev->irq;
>   	}
>
>   	hcd = usb_create_hcd(driver, &dev->dev, pci_name(dev));

WBR, Sergei

