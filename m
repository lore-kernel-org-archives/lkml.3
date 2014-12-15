Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaLOTbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:31:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaLOTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:31:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 52/96] usb: xhci: rework root port wake bits if controller isn't allowed to wakeup
Date: Mon, 15 Dec 2014 11:26:12 -0800
Message-Id: <1418671616-25482-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit a1377e5397ab321e21b793ec8cd2b6f12bd3c718 upstream.

When system is being suspended, if host device is not allowed to do wakeup,
xhci_suspend() needs to clear all root port wake on bits. Otherwise, some
platforms may generate spurious wakeup, even if PCI PME# is disabled.

The initial commit ff8cbf250b44 ("xhci: clear root port wake on bits"),
which also got into stable, turned out to not work correctly and had to
be reverted, and is now rewritten.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
[Mathias Nyman: reword commit message]
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-pci.c  |  2 +-
 drivers/usb/host/xhci-plat.c | 10 +++++++++-
 drivers/usb/host/xhci.c      | 42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  2 +-
 4 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 4588815..6a7ad5c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -271,7 +271,7 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	if (xhci_compliance_mode_recovery_timer_quirk_check())
 		pdev->no_d3cold = true;
 
-	return xhci_suspend(xhci);
+	return xhci_suspend(xhci, do_wakeup);
 }
 
 static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index d9c169f..bb50d30 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -203,7 +203,15 @@ static int xhci_plat_suspend(struct device *dev)
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
index 9189f3f..b2b2da2 100644
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
@@ -840,13 +842,47 @@ static void xhci_clear_command_ring(struct xhci_hcd *xhci)
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
@@ -857,6 +893,10 @@ int xhci_suspend(struct xhci_hcd *xhci)
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
index 1a64027..e9765fd 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1765,7 +1765,7 @@ void xhci_shutdown(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
 
 #ifdef	CONFIG_PM
-int xhci_suspend(struct xhci_hcd *xhci);
+int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup);
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
 #else
 #define	xhci_suspend	NULL
-- 
1.9.1

