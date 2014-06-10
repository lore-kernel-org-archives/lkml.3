Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaFJTxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:53:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaFJTxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Denis Turischev <denis@compulab.co.il>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 051/160] xhci: Switch Intel Lynx Point ports to EHCI on shutdown.
Date: Tue, 10 Jun 2014 12:44:51 -0700
Message-Id: <1402429600-20477-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Turischev <denis.turischev@compulab.co.il>

commit c09ec25d3684cad74d851c0f028a495999591279 upstream.

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
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index d069224..67394da 100644
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
1.9.1

