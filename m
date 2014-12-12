Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967247AbaLLG7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:59:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51732 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758605AbaLLGQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.496257986@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 149/164] usb: xhci: rework root port wake bits if
 controller isn't allowed to wakeup
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context; drop xhci-plat changes]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -235,7 +235,7 @@ static int xhci_pci_suspend(struct usb_h
 			xhci->shared_hcd->state != HC_STATE_SUSPENDED)
 		return -EINVAL;
 
-	retval = xhci_suspend(xhci);
+	retval = xhci_suspend(xhci, do_wakeup);
 
 	return retval;
 }
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -33,6 +33,8 @@
 #define DRIVER_AUTHOR "Sarah Sharp"
 #define DRIVER_DESC "'eXtensible' Host Controller (xHC) Driver"
 
+#define	PORT_WAKE_BITS	(PORT_WKOC_E | PORT_WKDISC_E | PORT_WKCONN_E)
+
 /* Some 0.95 hardware can't handle the chain bit on a Link TRB being cleared */
 static int link_quirk;
 module_param(link_quirk, int, S_IRUGO | S_IWUSR);
@@ -867,19 +869,57 @@ static void xhci_clear_command_ring(stru
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
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 
+	/* Clear root port wake on bits if wakeup not allowed. */
+	if (!do_wakeup)
+		xhci_disable_port_wake_on_bits(xhci);
+
 	/* Don't poll the roothubs on bus suspend. */
 	xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
 	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1698,7 +1698,7 @@ void xhci_shutdown(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
 
 #ifdef	CONFIG_PM
-int xhci_suspend(struct xhci_hcd *xhci);
+int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup);
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
 #else
 #define	xhci_suspend	NULL

