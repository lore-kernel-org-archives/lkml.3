Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162497Ab3LFNVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:21:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44587 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161917Ab3LFNEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 217/272] xhci: Set L1 device slot on USB2 LPM enable/disable.
Date: Fri,  6 Dec 2013 12:58:26 +0000
Message-Id: <1386334761-25517-218-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 58e21f73975ec927119370635bf68b9023831c56 upstream.

To enable USB 2.0 Link Power Management (LPM), the xHCI host controller
needs the device slot ID to generate the device address used in L1 entry
tokens.  That information is set in the L1 device slot ID field of the
USB 2.0 LPM registers.

Currently, the L1 device slot ID is overwritten when the xHCI driver
initiates the software test of USB 2.0 Link PM in
xhci_usb2_software_lpm_test.  It is never cleared when USB 2.0 Link PM
is disabled for the device.  That should be harmless, because the
Hardware LPM Enable (HLE) bit is cleared when USB 2.0 Link PM is
disabled, so the host should not pay attention to the slot ID.

This patch should have no effect on host behavior, but since
xhci_usb2_software_lpm_test is going away in an upcoming bug fix patch,
we need to move that code to the function that enables and disables USB
2.0 Link PM.

This patch should be backported to kernels as old as 3.11, that contain
the commit a558ccdcc71c7770c5e80c926a31cfe8a3892a09 "usb: xhci: add USB2
Link power management BESL support".  The upcoming bug fix patch is also
marked for that stable kernel.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci.c | 4 ++--
 drivers/usb/host/xhci.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index d1fc37f..c7d5eb7 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4230,7 +4230,7 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 		}
 
 		pm_val &= ~PORT_HIRD_MASK;
-		pm_val |= PORT_HIRD(hird) | PORT_RWE;
+		pm_val |= PORT_HIRD(hird) | PORT_RWE | PORT_L1DS(udev->slot_id);
 		xhci_writel(xhci, pm_val, pm_addr);
 		pm_val = xhci_readl(xhci, pm_addr);
 		pm_val |= PORT_HLE;
@@ -4238,7 +4238,7 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 		/* flush write */
 		xhci_readl(xhci, pm_addr);
 	} else {
-		pm_val &= ~(PORT_HLE | PORT_RWE | PORT_HIRD_MASK);
+		pm_val &= ~(PORT_HLE | PORT_RWE | PORT_HIRD_MASK | PORT_L1DS_MASK);
 		xhci_writel(xhci, pm_val, pm_addr);
 		/* flush write */
 		xhci_readl(xhci, pm_addr);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index e63645d..46ce776 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -383,6 +383,7 @@ struct xhci_op_regs {
 #define	PORT_RWE		(1 << 3)
 #define	PORT_HIRD(p)		(((p) & 0xf) << 4)
 #define	PORT_HIRD_MASK		(0xf << 4)
+#define	PORT_L1DS_MASK		(0xff << 8)
 #define	PORT_L1DS(p)		(((p) & 0xff) << 8)
 #define	PORT_HLE		(1 << 16)
 
-- 
1.8.3.2

