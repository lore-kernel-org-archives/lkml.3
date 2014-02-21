Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaBUNSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:18:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116AbaBUNCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 29/60] xhci: Fix resume issues on Renesas chips in Samsung laptops
Date: Fri, 21 Feb 2014 13:00:56 +0000
Message-Id: <1392987687-15367-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 1aa9578c1a9450fb21501c4f549f5b1edb557e6d upstream.

Don Zickus <dzickus@redhat.com> writes:

Some co-workers of mine bought Samsung laptops that had mostly usb3 ports.
Those ports did not resume correctly (the driver would timeout communicating
and fail).  This led to frustration as suspend/resume is a common use for
laptops.

Poking around, I applied the reset on resume quirk to this chipset and the
resume started working.  Reloading the xhci_hcd module had been the temporary
workaround.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Don Zickus <dzickus@redhat.com>
Tested-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index a8c59c1..7aca79a 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -138,6 +138,11 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
+			pdev->device == 0x0015 &&
+			pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
+			pdev->subsystem_device == 0xc0cd)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 }
-- 
1.9.0

