Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422901AbaJaCtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:49:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:30552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422877AbaJaCtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:49:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,291,1413270000"; 
   d="scan'208";a="614496270"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 2/3] usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
Date: Fri, 31 Oct 2014 10:38:57 +0800
Message-Id: <1414723138-62776-3-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414723138-62776-1-git-send-email-baolu.lu@linux.intel.com>
References: <1414723138-62776-1-git-send-email-baolu.lu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xhci: clear root port wake on bits if controller isn't wake-up capable

When xHCI PCI host is suspended, if do_wakeup is false in xhci_pci_suspend,
xhci_pci_suspend needs to clear all root port wake on bits. Otherwise some Intel
platforms may get a spurious wakeup, even if PCI PME# is disabled.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci.h     |  6 ++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 280dde9..3e7441a 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -27,6 +27,8 @@
 #include "xhci.h"
 #include "xhci-trace.h"
 
+#define	PORT_WAKE_BITS	(PORT_WKOC_E | PORT_WKDISC_E | PORT_WKCONN_E)
+
 /* Device for a quirk */
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
 #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
@@ -126,6 +128,7 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		 */
 		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 		xhci->quirks |= XHCI_AVOID_BEI;
+		xhci->quirks |= XHCI_DISABLE_PORT_WOB;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI ||
@@ -279,6 +282,42 @@ static void xhci_pci_remove(struct pci_dev *dev)
 }
 
 #ifdef CONFIG_PM
+static void xhci_disable_port_wake_bits(struct xhci_hcd *xhci)
+{
+	int port_index;
+	__le32 __iomem **port_array;
+	unsigned long flags;
+	u32 t1, t2;
+
+	spin_lock_irqsave(&xhci->lock, flags);
+
+	/* disble usb3 ports Wake bits*/
+	port_index = xhci->num_usb3_ports;
+	port_array = xhci->usb3_ports;
+	while (port_index--) {
+		t1 = readl(port_array[port_index]);
+		t2 = xhci_port_state_to_neutral(t1);
+		t2 &= ~PORT_WAKE_BITS;
+		t1 = xhci_port_state_to_neutral(t1);
+		if (t1 != t2)
+			writel(t2, port_array[port_index]);
+	}
+
+	/* disble usb2 ports Wake bits*/
+	port_index = xhci->num_usb2_ports;
+	port_array = xhci->usb2_ports;
+	while (port_index--) {
+		t1 = readl(port_array[port_index]);
+		t2 = xhci_port_state_to_neutral(t1);
+		t2 &= ~PORT_WAKE_BITS;
+		t1 = xhci_port_state_to_neutral(t1);
+		if (t1 != t2)
+			writel(t2, port_array[port_index]);
+	}
+
+	spin_unlock_irqrestore(&xhci->lock, flags);
+}
+
 static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
@@ -291,6 +330,9 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
 		pdev->no_d3cold = true;
 
+	if (xhci->quirks & XHCI_DISABLE_PORT_WOB && !do_wakeup)
+		xhci_disable_port_wake_bits(xhci);
+
 	return xhci_suspend(xhci);
 }
 
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index df76d64..2f6131b 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1560,6 +1560,12 @@ struct xhci_hcd {
 #define XHCI_SPURIOUS_WAKEUP	(1 << 18)
 /* For controllers with a broken beyond repair streams implementation */
 #define XHCI_BROKEN_STREAMS	(1 << 19)
+/*
+ * Some Intel platforms may get a spurious wakeup after entering system
+ * suspend with PCI PME# disabled. Software can workaround this by dis-
+ * abling the wake on bits of all root ports.
+ */
+#define XHCI_DISABLE_PORT_WOB	(1 << 20)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
-- 
1.9.1

