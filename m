Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab3J1PFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:05:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3J1Os5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 18/64] xhci: quirk for extra long delay for S4
Date: Mon, 28 Oct 2013 14:47:37 +0000
Message-Id: <1382971703-17393-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - adjusted context
  - replaced usage of xhci_dbg_trace() by xhci_dbg() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 8 ++++++++
 drivers/usb/host/xhci.c     | 7 ++++++-
 drivers/usb/host/xhci.h     | 1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 5e3ef3e..8b218a4 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -67,6 +67,14 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			xhci_dbg(xhci, "QUIRK: Fresco Logic xHC needs configure"
 					" endpoint cmd after reset endpoint\n");
 		}
+		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK &&
+				pdev->revision == 0x4) {
+			xhci->quirks |= XHCI_SLOW_SUSPEND;
+			xhci_dbg(xhci,
+				 "QUIRK: Fresco Logic xHC revision %u"
+				 "must be suspended extra slowly",
+				 pdev->revision);
+		}
 		/* Fresco Logic confirms: all revisions of this chip do not
 		 * support MSI, even though some of them claim to in their PCI
 		 * capabilities.
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index eb31daa..10e10a6 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -883,6 +883,7 @@ static void xhci_clear_command_ring(struct xhci_hcd *xhci)
 int xhci_suspend(struct xhci_hcd *xhci)
 {
 	int			rc = 0;
+	unsigned int		delay = XHCI_MAX_HALT_USEC;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	u32			command;
 
@@ -901,8 +902,12 @@ int xhci_suspend(struct xhci_hcd *xhci)
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
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 9a97918..b15d034 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1517,6 +1517,7 @@ struct xhci_hcd {
 #define XHCI_COMP_MODE_QUIRK	(1 << 14)
 #define XHCI_AVOID_BEI		(1 << 15)
 #define XHCI_PLAT		(1 << 16)
+#define XHCI_SLOW_SUSPEND	(1 << 17)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
-- 
1.8.3.2

