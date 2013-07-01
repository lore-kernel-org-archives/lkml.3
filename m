Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3GAF3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 01:29:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60730 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3GAF3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 01:29:21 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2] usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0
Date: Mon, 1 Jul 2013 10:59:12 +0530
Message-ID: <1372656552-18824-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xhci controllers with hci_version > 0.96 gives spurious success
events on short packet completion. During webcam capture the
"ERROR Transfer event TRB DMA ptr not part of current TD" was observed.
The same application works fine with synopsis controllers hci_version 0.96.
The same Issue is seen with Intel Pantherpoint xhci controller. So enabling
this quirk in xhci_gen_setup if controller verion is greater than 0.96.
For xhci-pci move the quirk to much generic place xhci_gen_setup.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/host/xhci-pci.c | 1 -
 drivers/usb/host/xhci.c     | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index cc24e39..f00cb20 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -93,7 +93,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 			pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
-		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
 		xhci->limit_active_eps = 64;
 		xhci->quirks |= XHCI_SW_BW_CHECKING;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index d8f640b..0f7be59 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4697,6 +4697,13 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 
 	get_quirks(dev, xhci);
 
+	/* In xhci controllers which follow xhci 1.0 spec gives a spurious
+	 * success event after a short transfer. This quirk will ignore such
+	 * spurious event.
+	 */
+	if (xhci->hci_version > 0x96)
+		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
+
 	/* Make sure the HC is halted. */
 	retval = xhci_halt(xhci);
 	if (retval)
-- 
1.8.1.4

