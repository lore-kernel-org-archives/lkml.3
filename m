Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaLFPQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:16:33 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47698 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752234AbaLFPIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 41/66] usb: xhci: rework root port wake bits if controller isn't allowed to wakeup
Date: Sat,  6 Dec 2014 16:07:33 +0100
Message-Id: <6facb9b2fae7b8cfc3a667d04ca89be6c190d8bb.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-pci.c  |  2 +-
 drivers/usb/host/xhci-plat.c | 10 +++++++++-
 drivers/usb/host/xhci.c      | 42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  2 +-
 4 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 1cfe0c743092..7dad9e5ad2f3 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -283,7 +283,7 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 	if (xhci_compliance_mode_recovery_timer_quirk_check())
 		pdev->no_d3cold = true;
 
-	return xhci_suspend(xhci);
+	return xhci_suspend(xhci, do_wakeup);
 }
 
 static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index d9c169f470d3..bb50d309b8e6 100644
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
index de1901222c00..381965957a67 100644
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
index 75f775c993ee..1703de9f0509 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1767,7 +1767,7 @@ void xhci_shutdown(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
 
 #ifdef	CONFIG_PM
-int xhci_suspend(struct xhci_hcd *xhci);
+int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup);
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
 #else
 #define	xhci_suspend	NULL
-- 
2.1.3

