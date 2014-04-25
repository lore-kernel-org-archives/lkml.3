Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaDYQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:09:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:58325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaDYQJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:09:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="519794212"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <sarah.a.sharp@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Denis Turischev <denis@compulab.co.il>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH v2 2/4] xhci: Switch Intel Lynx Point ports to EHCI on shutdown.
Date: Fri, 25 Apr 2014 19:20:14 +0300
Message-Id: <1398442816-32538-3-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398442816-32538-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1398442816-32538-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Turischev <denis.turischev@compulab.co.il>

The same issue like with Panther Point chipsets. If the USB ports are
switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
which will wake the system. Some BIOS have work around for this, but not all.
One example is Compulab's mini-desktop, the Intense-PC2.

The bug can be avoided if the USB ports are switched back to EHCI on
shutdown.

This patch should be backported to stable kernels as old as 3.12,
that contain the commit 638298dc66ea36623dbc2757a24fc2c4ab41b016
"xhci: Fix spurious wakeups after S5 on Haswell"

Signed-off-by: Denis Turischev <denis@compulab.co.il>
Cc: stable@vger.kernel.org
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 47390e3..1715063 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -134,6 +134,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		 */
 		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
 			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
+
+		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
-- 
1.8.3.2

