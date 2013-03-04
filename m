Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab3CDQOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:14:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758412Ab3CDQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:14:45 -0500
From: Thomas Renninger <trenn@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Oliver Neukum <oneukum@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, David Haerdeman <david@hardeman.nu>
Subject: [PATCH][v3] xhci: correctly enable interrupts
Date: Mon, 04 Mar 2013 17:14:43 +0100
Message-ID: <1742014.AbCVskUi8i@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.7-1.2-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1303041025470.1750-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1303041025470.1750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

xhci has its own interrupt enabling routine, which will try to
use MSI-X/MSI if present. So the usb core shouldn't try to enable
legacy interrupts; on some machines the xhci legacy IRQ setting
is invalid.

v3: Be careful to not break XHCI_BROKEN_MSI workaround (by trenn)

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Frederik Himpe <fhimpe@vub.ac.be>
Cc: David Haerdeman <david@hardeman.nu>
Cc: Alan Stern <stern@rowland.harvard.edu>

Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 622b4a4..2b487d4 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -173,6 +173,7 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct hc_driver	*driver;
 	struct usb_hcd		*hcd;
 	int			retval;
+	int			hcd_irq = 0;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -187,15 +188,19 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENODEV;
 	dev->current_state = PCI_D0;
 
-	/* The xHCI driver supports MSI and MSI-X,
-	 * so don't fail if the BIOS doesn't provide a legacy IRQ.
+	/*
+	 * The xHCI driver has its own irq management
+	 * make sure irq setup is not touched for xhci in generic hcd code
 	 */
-	if (!dev->irq && (driver->flags & HCD_MASK) != HCD_USB3) {
-		dev_err(&dev->dev,
-			"Found HC with no IRQ.  Check BIOS/PCI %s setup!\n",
-			pci_name(dev));
-		retval = -ENODEV;
-		goto disable_pci;
+	if ((driver->flags & HCD_MASK) != HCD_USB3) {
+		if (!dev->irq) {
+			dev_err(&dev->dev,
+			"Found HC with no IRQ. Check BIOS/PCI %s setup!\n",
+				pci_name(dev));
+			retval = -ENODEV;
+			goto disable_pci;
+		}
+		hcd_irq = dev->irq;
 	}
 
 	hcd = usb_create_hcd(driver, &dev->dev, pci_name(dev));
@@ -245,7 +250,7 @@ int usb_hcd_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	pci_set_master(dev);
 
-	retval = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
+	retval = usb_add_hcd(hcd, hcd_irq, IRQF_SHARED);
 	if (retval != 0)
 		goto unmap_registers;
 	set_hs_companion(dev, hcd);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index f1f01a8..849470b 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -350,7 +350,7 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
 	 * generate interrupts.  Don't even try to enable MSI.
 	 */
 	if (xhci->quirks & XHCI_BROKEN_MSI)
-		return 0;
+		goto legacy_irq;
 
 	/* unregister the legacy interrupt */
 	if (hcd->irq)
@@ -371,6 +371,7 @@ static int xhci_try_enable_msi(struct usb_hcd *hcd)
 		return -EINVAL;
 	}
 
+ legacy_irq:
 	/* fall back to legacy interrupt*/
 	ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
 			hcd->irq_descr, hcd);

