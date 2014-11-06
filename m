Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaKFDBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:01:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:47162 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaKFDBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:01:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484936976"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 2/3] usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
Date: Thu,  6 Nov 2014 10:50:52 +0800
Message-Id: <1415242253-72501-3-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415242253-72501-1-git-send-email-baolu.lu@linux.intel.com>
References: <1415242253-72501-1-git-send-email-baolu.lu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xhci: clear root port wake on bits if controller isn't allowed to do wakeup

When system is being suspended, if host device is not allowed to do wakeup,
xhci_suspend() needs to clear all root port wake on bits. Otherwise, some
platforms may generate spurious wakeup, even if PCI PME# is disabled.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/xhci-pci.c  |  2 +-
 drivers/usb/host/xhci-plat.c | 10 +++++++++-
 drivers/usb/host/xhci.c      | 42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  2 +-
 4 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 280dde9..d3fa3c2 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -291,7 +291,7 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
 		pdev->no_d3cold = true;
 
-	return xhci_suspend(xhci);
+	return xhci_suspend(xhci, do_wakeup);
 }
 
 static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 3d78b0c..646300c 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -204,7 +204,15 @@ static int xhci_plat_suspend(struct device *dev)
 	struct usb_hcd	*hcd = dev_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
 
-	return xhci_suspend(xhci);
+	/*
+	 * xhci_suspend() needs `do_wakeup` to know whether host is allowed
+	 * to do wakeup during suspend. Since xhci_plat_suspend is currently
+	 * only designed for system suspend, device_may_wakeup() is enough
+	 * to dertermine whether host is allowed to do wakeup. Need to
+	 * reconsider this when xhci_plat_suspend enlarges its scope, e.g.,
+	 * also applies to runtime suspend.
+	 */
+	return xhci_suspend(xhci, device_may_wakeup(dev));
 }
 
 static int xhci_plat_resume(struct device *dev)
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2a5d45b..b832841 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -35,6 +35,8 @@
 #define DRIVER_AUTHOR "Sarah Sharp"
 #define DRIVER_DESC "'eXtensible' Host Controller (xHC) Driver"
 
+#define	PORT_WAKE_BITS	(PORT_WKOC_E | PORT_WKDISC_E | PORT_WKCONN_E)
+
 /* Some 0.95 hardware can't handle the chain bit on a Link TRB being cleared */
 static int link_quirk;
 module_param(link_quirk, int, S_IRUGO | S_IWUSR);
@@ -851,13 +853,47 @@ static void xhci_clear_command_ring(struct xhci_hcd *xhci)
 	xhci_set_cmd_ring_deq(xhci);
 }
 
+static void xhci_disable_port_wake_on_bits(struct xhci_hcd *xhci)
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
+		t1 = xhci_port_state_to_neutral(t1);
+		t2 = t1 & ~PORT_WAKE_BITS;
+		if (t1 != t2)
+			writel(t2, port_array[port_index]);
+	}
+
+	/* disble usb2 ports Wake bits*/
+	port_index = xhci->num_usb2_ports;
+	port_array = xhci->usb2_ports;
+	while (port_index--) {
+		t1 = readl(port_array[port_index]);
+		t1 = xhci_port_state_to_neutral(t1);
+		t2 = t1 & ~PORT_WAKE_BITS;
+		if (t1 != t2)
+			writel(t2, port_array[port_index]);
+	}
+
+	spin_unlock_irqrestore(&xhci->lock, flags);
+}
+
 /*
  * Stop HC (not bus-specific)
  *
  * This is called when the machine transition into S3/S4 mode.
  *
  */
-int xhci_suspend(struct xhci_hcd *xhci)
+int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 {
 	int			rc = 0;
 	unsigned int		delay = XHCI_MAX_HALT_USEC;
@@ -868,6 +904,10 @@ int xhci_suspend(struct xhci_hcd *xhci)
 			xhci->shared_hcd->state != HC_STATE_SUSPENDED)
 		return -EINVAL;
 
+	/* Clear root port wake on bits if wakeup not allowed. */
+	if (!do_wakeup)
+		xhci_disable_port_wake_on_bits(xhci);
+
 	/* Don't poll the roothubs on bus suspend. */
 	xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
 	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index df76d64..d745715 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1746,7 +1746,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
 void xhci_init_driver(struct hc_driver *drv, int (*setup_fn)(struct usb_hcd *));
 
 #ifdef	CONFIG_PM
-int xhci_suspend(struct xhci_hcd *xhci);
+int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup);
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
 #else
 #define	xhci_suspend	NULL
-- 
1.9.1

