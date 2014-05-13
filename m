Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbaEMJn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:43:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60885 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760103AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Denis Turischev <denis@compulab.co.il>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 084/182] xhci: Switch Intel Lynx Point ports to EHCI on shutdown.
Date: Tue, 13 May 2014 11:27:16 +0200
Message-Id: <07fa3b17d4d6d223910347d4763426b1d6fae37c.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Turischev <denis.turischev@compulab.co.il>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index d06922469000..67394da1c645 100644
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
1.9.3

