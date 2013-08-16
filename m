Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab3HPWwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:52:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51873 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab3HPWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George Cherian <george.cherian@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 035/133] usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0
Date: Fri, 16 Aug 2013 15:32:57 -0700
Message-Id: <1376692475-28413-36-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Cherian <george.cherian@ti.com>

commit 07f3cb7c28bf3f4dd80bfb136cf45810c46ac474 upstream.

Xhci controllers with hci_version > 0.96 gives spurious success
events on short packet completion. During webcam capture the
"ERROR Transfer event TRB DMA ptr not part of current TD" was observed.
The same application works fine with synopsis controllers hci_version 0.96.
The same issue is seen with Intel Pantherpoint xhci controller. So enabling
this quirk in xhci_gen_setup if controller verion is greater than 0.96.
For xhci-pci move the quirk to much generic place xhci_gen_setup.

Note from Sarah:

The xHCI 1.0 spec changed how hardware handles short packets.  The HW
will notify SW of the TRB where the short packet occurred, and it will
also give a successful status for the last TRB in a TD (the one with the
IOC flag set).  On the second successful status, that warning will be
triggered in the driver.

Software is now supposed to not assume the TD is not completed until it
gets that last successful status.  That means we have a slight race
condition, although it should have little practical impact.  This patch
papers over that issue.

It's on my long-term to-do list to fix this race condition, but it is a
much more involved patch that will probably be too big for stable.  This
patch is needed for stable to avoid serious log spam.

This patch should be backported to kernels as old as 3.0, that
contain the commit ad808333d8201d53075a11bc8dd83b81f3d68f0b "Intel xhci:
Ignore spurious successful event."

The patch will have to be modified for kernels older than 3.2, since
that kernel added the xhci_gen_setup function for xhci platform devices.
The correct conflict resolution for kernels older than 3.2 is to set
XHCI_SPURIOUS_SUCCESS in xhci_pci_quirks for all xHCI 1.0 hosts.

Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 1 -
 drivers/usb/host/xhci.c     | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 1aeb4da..76fb7d9 100644
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
index 6cffc0e..661c553 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4671,6 +4671,13 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 
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
1.8.1.2

