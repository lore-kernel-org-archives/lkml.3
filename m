Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858Ab3CZPrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:47:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965131Ab3CZPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, David Haerdeman <david@hardeman.nu>,
        Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 073/150] USB: xhci: correctly enable interrupts
Date: Tue, 26 Mar 2013 15:19:32 +0000
Message-Id: <1364311249-14454-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hcd-pci.c | 23 ++++++++++++++---------
 drivers/usb/host/xhci.c    |  3 ++-
 2 files changed, 16 insertions(+), 10 deletions(-)

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
index 7002b67..23a0091 100644
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
-- 
1.8.1.2

