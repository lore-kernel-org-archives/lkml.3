Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3CYB2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:28:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33988 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab3CYBP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:59 -0400
Message-Id: <20130325010530.415166395@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:26 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Hannes Reinecke <hare@suse.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, David Haerdeman <david@hardeman.nu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 062/104] USB: xhci: correctly enable interrupts
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 00eed9c814cb8f281be6f0f5d8f45025dc0a97eb upstream.

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
Acked-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hcd-pci.c |   23 ++++++++++++++---------
 drivers/usb/host/xhci.c    |    3 ++-
 2 files changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -173,6 +173,7 @@ int usb_hcd_pci_probe(struct pci_dev *de
 	struct hc_driver	*driver;
 	struct usb_hcd		*hcd;
 	int			retval;
+	int			hcd_irq = 0;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -187,15 +188,19 @@ int usb_hcd_pci_probe(struct pci_dev *de
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
@@ -245,7 +250,7 @@ int usb_hcd_pci_probe(struct pci_dev *de
 
 	pci_set_master(dev);
 
-	retval = usb_add_hcd(hcd, dev->irq, IRQF_SHARED);
+	retval = usb_add_hcd(hcd, hcd_irq, IRQF_SHARED);
 	if (retval != 0)
 		goto unmap_registers;
 	set_hs_companion(dev, hcd);
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -342,7 +342,7 @@ static int xhci_try_enable_msi(struct us
 	 * generate interrupts.  Don't even try to enable MSI.
 	 */
 	if (xhci->quirks & XHCI_BROKEN_MSI)
-		return 0;
+		goto legacy_irq;
 
 	/* unregister the legacy interrupt */
 	if (hcd->irq)
@@ -363,6 +363,7 @@ static int xhci_try_enable_msi(struct us
 		return -EINVAL;
 	}
 
+ legacy_irq:
 	/* fall back to legacy interrupt*/
 	ret = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
 			hcd->irq_descr, hcd);


