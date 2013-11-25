Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab3KYOGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:06:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58932 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab3KYNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:47 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Oliver Neukum" <oneukum@suse.de>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.301958433@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 54/87] xhci: quirk for extra long delay for S4
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 455f58925247e8a1a1941e159f3636ad6ee4c90b upstream.

It has been reported that this chipset really cannot
sleep without this extraordinary delay.

This patch should be backported, in order to ensure this host functions
under stable kernels.  The last quirk for Fresco Logic hosts (commit
bba18e33f25072ebf70fd8f7f0cdbf8cdb59a746 "xhci: Extend Fresco Logic MSI
quirk.") was backported to stable kernels as old as 2.6.36.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Use xhci_dbg() instead of xhci_dbg_trace()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-pci.c | 8 ++++++++
 drivers/usb/host/xhci.c     | 7 ++++++-
 drivers/usb/host/xhci.h     | 1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -67,6 +67,14 @@ static void xhci_pci_quirks(struct devic
 			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
 					" endpoint cmd after reset endpoint\n");
 		}
+		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
+				pdev->revision == 0x4) {
+			xhci->quirks |= XHCI_SLOW_SUSPEND;
+			xhci_dbg(xhci,
+				"QUIRK: Fresco Logic xHC revision %u"
+				"must be suspended extra slowly",
+				pdev->revision);
+		}
 		/* Fresco Logic confirms: all revisions of this chip do not
 		 * support MSI, even though some of them claim to in their PCI
 		 * capabilities.
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -869,6 +869,7 @@ static void xhci_clear_command_ring(stru
 int xhci_suspend(struct xhci_hcd *xhci)
 {
 	int			rc = 0;
+	unsigned int		delay = XHCI_MAX_HALT_USEC;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 
@@ -887,8 +888,12 @@ int xhci_suspend(struct xhci_hcd *xhci)
 	command = xhci_readl(xhci, &xhci->op_regs->command);
 	command &= ~CMD_RUN;
 	xhci_writel(xhci, command, &xhci->op_regs->command);
+
+	/* Some chips from Fresco Logic need an extraordinary delay */
+	delay *= (xhci->quirks & XHCI_SLOW_SUSPEND) ? 10 : 1;
+
 	if (handshake(xhci, &xhci->op_regs->status,
-		      STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC)) {
+		      STS_HALT, STS_HALT, delay)) {
 		xhci_warn(xhci, "WARN: xHC CMD_RUN timeout\n");
 		spin_unlock_irq(&xhci->lock);
 		return -ETIMEDOUT;
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1493,6 +1493,7 @@ struct xhci_hcd {
 #define XHCI_SPURIOUS_REBOOT	(1 << 13)
 #define XHCI_COMP_MODE_QUIRK	(1 << 14)
 #define XHCI_AVOID_BEI		(1 << 15)
+#define XHCI_SLOW_SUSPEND	(1 << 17)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */

