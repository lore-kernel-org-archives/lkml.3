Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3FQRbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:31:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3FQRbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 11/84] xhci: Disable D3cold for buggy TI redrivers.
Date: Mon, 17 Jun 2013 10:30:15 -0700
Message-Id: <1371490288-23167-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit c3897aa5386faba77e5bbdf94902a1658d3a5b11 upstream.

Some xHCI hosts contain a "redriver" from TI that silently drops port
status connect changes if the port slips into Compliance Mode.  If the
port slips into compliance mode while the host is in D0, there will not
be a port status change event.  If the port slips into compliance mode
while the host is in D3, the host will not send a PME.  This includes
when the system is suspended (S3) or hibernated (S4).

If this happens when the system is in S3/S4, there is nothing software
can do.  Other port status change events that would normally cause the
host to wake the system from S3/S4 may also be lost.  This includes
remote wakeup, disconnects and connects on other ports, and overrcurrent
events.  A decision was made to _NOT_ disable system suspend/hibernate
on these systems, since users are unlikely to enable wakeup from S3/S4
for the xHCI host.

Software can deal with this issue when the system is in S0.  A work
around was put in to poll the port status registers for Compliance Mode.
The xHCI driver will continue to poll the registers while the host is
runtime suspended.  Unfortunately, that means we can't allow the PCI
device to go into D3cold, because power will be removed from the host,
and the config space will read as all Fs.

Disable D3cold in the xHCI PCI runtime suspend function.

This patch should be backported to kernels as old as 3.2, that
contain the commit 71c731a296f1b08a3724bd1b514b64f1bda87a23 "usb: host:
xhci: Fix Compliance Mode on SN65LVPE502CP Hardware"

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 8 ++++++++
 drivers/usb/host/xhci.c     | 4 ++--
 drivers/usb/host/xhci.h     | 3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index af259e0..1aeb4da 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -221,6 +221,14 @@ static void xhci_pci_remove(struct pci_dev *dev)
 static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
+
+	/*
+	 * Systems with the TI redriver that loses port status change events
+	 * need to have the registers polled during D3, so avoid D3cold.
+	 */
+	if (xhci_compliance_mode_recovery_timer_quirk_check())
+		pdev->no_d3cold = true;
 
 	return xhci_suspend(xhci);
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a0bd618..7f6de85 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -466,7 +466,7 @@ static void compliance_mode_recovery_timer_init(struct xhci_hcd *xhci)
  * Systems:
  * Vendor: Hewlett-Packard -> System Models: Z420, Z620 and Z820
  */
-static bool compliance_mode_recovery_timer_quirk_check(void)
+bool xhci_compliance_mode_recovery_timer_quirk_check(void)
 {
 	const char *dmi_product_name, *dmi_sys_vendor;
 
@@ -517,7 +517,7 @@ int xhci_init(struct usb_hcd *hcd)
 	xhci_dbg(xhci, "Finished xhci_init\n");
 
 	/* Initializing Compliance Mode Recovery Data If Needed */
-	if (compliance_mode_recovery_timer_quirk_check()) {
+	if (xhci_compliance_mode_recovery_timer_quirk_check()) {
 		xhci->quirks |= XHCI_COMP_MODE_QUIRK;
 		compliance_mode_recovery_timer_init(xhci);
 	}
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 6a563ef..abed254 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1852,4 +1852,7 @@ struct xhci_input_control_ctx *xhci_get_input_control_ctx(struct xhci_hcd *xhci,
 struct xhci_slot_ctx *xhci_get_slot_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx);
 struct xhci_ep_ctx *xhci_get_ep_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx, unsigned int ep_index);
 
+/* xHCI quirks */
+bool xhci_compliance_mode_recovery_timer_quirk_check(void);
+
 #endif /* __LINUX_XHCI_HCD_H */
-- 
1.8.1.2

