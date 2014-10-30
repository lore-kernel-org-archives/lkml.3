Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161255AbaJ3VAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:00:39 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:58655 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaJ3VAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:00:36 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] xhci: Set shared HCD's hcd_priv in xhci_gen_setup
Date: Thu, 30 Oct 2014 14:00:33 -0700
Message-Id: <1414702833-29156-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xhci_gen_setup() sets the hcd_priv field for the primary HCD, but not
for the shared HCD, requiring xHCI host-controller drivers to set it
between usb_create_shared_hcd() and usb_add_hcd().  There's no reason
xhci_gen_setup() can't set the shared HCD's hcd_priv as well, so move
that bit out of the host-controller drivers and into xhci_gen_setup().

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/usb/host/xhci-pci.c  | 5 -----
 drivers/usb/host/xhci-plat.c | 5 -----
 drivers/usb/host/xhci.c      | 6 +++---
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 280dde9..dc0022c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -231,11 +231,6 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		goto dealloc_usb2_hcd;
 	}
 
-	/* Set the xHCI pointer before xhci_pci_setup() (aka hcd_driver.reset)
-	 * is called by usb_add_hcd().
-	 */
-	*((struct xhci_hcd **) xhci->shared_hcd->hcd_priv) = xhci;
-
 	retval = usb_add_hcd(xhci->shared_hcd, dev->irq,
 			IRQF_SHARED);
 	if (retval)
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 3d78b0c..5bc33bc 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -149,11 +149,6 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if ((node && of_property_read_bool(node, "usb3-lpm-capable")) ||
 			(pdata && pdata->usb3_lpm_capable))
 		xhci->quirks |= XHCI_LPM_SUPPORT;
-	/*
-	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
-	 * is called by usb_add_hcd().
-	 */
-	*((struct xhci_hcd **) xhci->shared_hcd->hcd_priv) = xhci;
 
 	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
 		xhci->shared_hcd->can_do_streams = 1;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2a5d45b..ae05471 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4843,9 +4843,9 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 		 */
 		hcd->has_tt = 1;
 	} else {
-		/* xHCI private pointer was set in xhci_pci_probe for the second
-		 * registered roothub.
-		 */
+		xhci = hcd_to_xhci(hcd->primary_hcd);
+		*((struct xhci_hcd **) hcd->hcd_priv) = xhci;
+
 		return 0;
 	}
 
-- 
2.1.0.rc2.206.gedb03e5

