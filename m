Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3CAIxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:53:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab3CAIw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:52:59 -0500
From: Hannes Reinecke <hare@suse.de>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Oliver Neukum <oneukum@suse.de>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Frederik Himpe <fhimpe@vub.ac.be>, David Haerdeman <david@hardeman.nu>
Subject: [PATCH] usb: correctly enable interrupts for xhci
Date: Fri,  1 Mar 2013 09:52:54 +0100
Message-Id: <1362127974-24487-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xhci might run with MSI/MSI-X only, with no support for legacy
interrupts. On these devices the request_irq() call in usb_add_hcd()
will fail, causing the entire device to fail.
For xhci this is especially painful as the driver will enable
interrupts during xhci_run(), so the initial call to request_irq()
is not required anyway.

This patch adds a flag 'msix_supported' to struct usb_hcd, which
will cause usb_add_hcd() to skip interrupt setup. This flag is
set in xhci-pci, so the registration will skip the first request_irq()
and can proceed.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Frederik Himpe <fhimpe@vub.ac.be>
Cc: David Haerdeman <david@hardeman.nu>
Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 8e64adf..e583444 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2536,7 +2536,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	/* enable irqs just before we start the controller,
 	 * if the BIOS provides legacy PCI irqs.
 	 */
-	if (usb_hcd_is_primary_hcd(hcd) && irqnum) {
+	if (usb_hcd_is_primary_hcd(hcd) && irqnum && !hcd->msix_supported) {
 		retval = usb_hcd_request_irqs(hcd, irqnum, irqflags);
 		if (retval)
 			goto err_request_irq;
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index af259e0..a08c0ee 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -183,6 +183,12 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	 */
 	*((struct xhci_hcd **) xhci->shared_hcd->hcd_priv) = xhci;
 
+	/*
+	 * Interrupts are setup during xhci_run(), so do not try
+	 * to request an interrupt during hcd init.
+	 */
+	hcd->msix_supported = 1;
+
 	retval = usb_add_hcd(xhci->shared_hcd, dev->irq,
 			IRQF_SHARED);
 	if (retval)
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 0a78df5..eb6bf10 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -124,6 +124,7 @@ struct usb_hcd {
 	/* Flags that get set only during HCD registration or removal. */
 	unsigned		rh_registered:1;/* is root hub registered? */
 	unsigned		rh_pollable:1;	/* may we poll the root hub? */
+	unsigned		msix_supported:1; /* driver supports MSI-X */
 	unsigned		msix_enabled:1;	/* driver has MSI-X enabled? */
 
 	/* The next flag is a stopgap, to be removed when all the HCDs
