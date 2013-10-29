Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3J2SIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59396 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab3J2SIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>, Takashi Iwai <tiwai@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 66/81] xhci: Fix spurious wakeups after S5 on Haswell
Date: Tue, 29 Oct 2013 11:04:27 -0700
Message-Id: <1383069882-11437-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 17 +++++++++++++++++
 drivers/usb/host/xhci.c     |  7 +++++++
 drivers/usb/host/xhci.h     |  1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 2f44259..ab4b0be 100644
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
@@ -114,6 +117,15 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
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
@@ -220,6 +232,11 @@ static void xhci_pci_remove(struct pci_dev *dev)
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
 
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index dd7a138..4bade57 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -776,12 +776,19 @@ void xhci_shutdown(struct usb_hcd *hcd)
 
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
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 26f9277..ba214ae 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1518,6 +1518,7 @@ struct xhci_hcd {
 #define XHCI_AVOID_BEI		(1 << 15)
 #define XHCI_PLAT		(1 << 16)
 #define XHCI_SLOW_SUSPEND	(1 << 17)
+#define XHCI_SPURIOUS_WAKEUP	(1 << 18)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
-- 
1.8.1.2

