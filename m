Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3CDLZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:25:41 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:54003 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab3CDLZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:25:39 -0500
Date: Mon, 4 Mar 2013 12:25:28 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Hannes Reinecke <hare@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH][v2] xhci: correctly enable interrupts
Message-ID: <20130304112528.GA4345@hardeman.nu>
Mail-Followup-To: Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
	Oliver Neukum <oneukum@suse.de>, Thomas Renninger <trenn@suse.de>,
	Yinghai Lu <yinghai@kernel.org>, Frederik Himpe <fhimpe@vub.ac.be>,
	Alan Stern <stern@rowland.harvard.edu>
References: <1362385324-15228-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362385324-15228-1-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 09:22:04AM +0100, Hannes Reinecke wrote:
>xhci has its own interrupt enabling routine, which will try to
>use MSI-X/MSI if present. So the usb core shouldn't try to enable
>legacy interrupts; on some machines the xhci legacy IRQ setting
>is invalid.
>
>Cc: Bjorn Helgaas <bhelgaas@google.com>
>Cc: Oliver Neukum <oneukum@suse.de>
>Cc: Thomas Renninger <trenn@suse.de>
>Cc: Yinghai Lu <yinghai@kernel.org>
>Cc: Frederik Himpe <fhimpe@vub.ac.be>
>Cc: David Haerdeman <david@hardeman.nu>
>Cc: Alan Stern <stern@rowland.harvard.edu>
>Signed-off-by: Hannes Reinecke <hare@suse.de>

No idea if it's the "right" solution but it works for me.

Tested-by: David Härdeman <david@hardeman.nu>

>
>diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
>index 622b4a4..2647e75 100644
>--- a/drivers/usb/core/hcd-pci.c
>+++ b/drivers/usb/core/hcd-pci.c
>@@ -173,6 +173,7 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
> 	struct hc_driver	*driver;
> 	struct usb_hcd		*hcd;
> 	int			retval;
>+	int			hcd_irq = 0;
> 
> 	if (usb_disabled())
> 		return -ENODEV;
>@@ -187,15 +188,21 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
> 		return -ENODEV;
> 	dev->current_state = PCI_D0;
> 
>-	/* The xHCI driver supports MSI and MSI-X,
>-	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
>+	/*
>+	 * The xHCI driver supports MSI and MSI-X,
>+	 * so don't fail if the BIOS doesn't provide a legacy IRQ
>+	 * and do not try to enable legacy IRQs.
> 	 */
>-	if (!dev->irq && (driver->flags & HCD_MASK) != HCD_USB3) {
>-		dev_err(&dev->dev,
>-			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
>-			pci_name(dev));
>-		retval = -ENODEV;
>-		goto disable_pci;
>+	if ((driver->flags & HCD_MASK) != HCD_USB3) {
>+		if (!dev->irq) {
>+			dev_err(&dev->dev,
>+				"Found HC with no IRQ.  "
>+				"Check BIOS/PCI %s setup!\n",
>+				pci_name(dev));
>+			retval = -ENODEV;
>+			goto disable_pci;
>+		}
>+		hcd_irq = dev->irq;
> 	}
> 
> 	hcd = usb_create_hcd(driver, &dev->dev, pci_name(dev));
>@@ -245,7 +252,7 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
> 
> 	pci_set_master(dev);
> 
>-	retval = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
>+	retval = usb_add_hcd(hcd, hcd_irq, IRQF_SHARED);
> 	if (retval != 0)
> 		goto unmap_registers;
> 	set_hs_companion(dev, hcd);
>

-- 
David Härdeman
