Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3KYN7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:59:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58893 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510Ab3KYNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:52 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oliver Neukum" <oneukum@suse.de>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.528298463@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 55/87] xhci: Fix spurious wakeups after S5 on Haswell
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 638298dc66ea36623dbc2757a24fc2c4ab41b016 upstream.

Haswell LynxPoint and LynxPoint-LP with the recent Intel BIOS show
mysterious wakeups after shutdown occasionally.  After discussing with
BIOS engineers, they explained that the new BIOS expects that the
wakeup sources are cleared and set to D3 for all wakeup devices when
the system is going to sleep or power off, but the current xhci driver
doesn't do this properly (partly intentionally).

This patch introduces a new quirk, XHCI_SPURIOUS_WAKEUP, for
fixing the spurious wakeups at S5 by calling xhci_reset() in the xhci
shutdown ops as done in xhci_stop(), and setting the device to PCI D3
at shutdown and remove ops.

The PCI D3 call is based on the initial fix patch by Oliver Neukum.

[Note: Sarah changed the quirk name from XHCI_HSW_SPURIOUS_WAKEUP to
XHCI_SPURIOUS_WAKEUP, since none of the other quirks have system names
in them.  Sarah also fixed a collision with a quirk submitted around the
same time, by changing the xhci->quirks bit from 17 to 18.]

This patch should be backported to kernels as old as 3.0, that
contain the commit 1c12443ab8eba71a658fae4572147e56d1f84f66 "xhci: Add
Lynx Point to list of Intel switchable hosts."

Cc: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-pci.c | 17 +++++++++++++++++
 drivers/usb/host/xhci.c     |  7 +++++++
 drivers/usb/host/xhci.h     |  1 +
 3 files changed, 25 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -34,6 +34,9 @@
 #define PCI_VENDOR_ID_ETRON		0x1b6f
 #define PCI_DEVICE_ID_ASROCK_P67	0x7023
 
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x8c31
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
+
 static const char hcd_name[] = "xhci_hcd";
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -111,6 +114,15 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 		xhci->quirks |= XHCI_AVOID_BEI;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    (pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI ||
+	     pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI)) {
+		/* Workaround for occasional spurious wakeups from S5 (or
+		 * any other sleep) on Haswell machines with LPT and LPT-LP
+		 * with the new Intel BIOS
+		 */
+		xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
+	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
@@ -210,6 +222,11 @@ static void xhci_pci_remove(struct pci_d
 		usb_put_hcd(xhci->shared_hcd);
 	}
 	usb_hcd_pci_remove(dev);
+
+	/* Workaround for spurious wakeups at shutdown with HSW */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+		pci_set_power_state(dev, PCI_D3hot);
+
 	kfree(xhci);
 }
 
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -763,12 +763,19 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
 	spin_lock_irq(&xhci->lock);
 	xhci_halt(xhci);
+	/* Workaround for spurious wakeups at shutdown with HSW */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+		xhci_reset(xhci);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
 
 	xhci_dbg(xhci, "xhci_shutdown completed - status = %x\n",
 		    xhci_readl(xhci, &xhci->op_regs->status));
+
+	/* Yet another workaround for spurious wakeups at shutdown with HSW */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+		pci_set_power_state(to_pci_dev(hcd->self.controller), PCI_D3hot);
 }
 
 #ifdef CONFIG_PM
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1494,6 +1494,7 @@ struct xhci_hcd {
 #define XHCI_COMP_MODE_QUIRK	(1 << 14)
 #define XHCI_AVOID_BEI		(1 << 15)
 #define XHCI_SLOW_SUSPEND	(1 << 17)
+#define XHCI_SPURIOUS_WAKEUP	(1 << 18)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */

