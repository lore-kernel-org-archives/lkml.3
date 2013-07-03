Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab3GCTDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:03:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28068 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042Ab3GCTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:32 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=wByEn6SnafoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=su-O6YEmCVUA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=Y3nRCmVAlQJ2w_xPpkcA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184056.411073580@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>
Subject: [071/141] xhci: Disable D3cold for buggy TI redrivers.
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0071-xhci-Disable-D3cold-for-buggy-TI-redrivers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

[ Upstream commit c3897aa5386faba77e5bbdf94902a1658d3a5b11 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci-pci.c |   10 ++++++++++
 drivers/usb/host/xhci.c     |    4 ++--
 drivers/usb/host/xhci.h     |    3 +++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index dcb72f7..cd0fc48 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -221,12 +221,22 @@ static void xhci_pci_remove(struct pci_dev *dev)
 static int xhci_pci_suspend(struct usb_hcd *hcd, bool do_wakeup)
 {
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct pci_dev		*pdev;
 	int	retval = 0;
 
 	if (hcd->state != HC_STATE_SUSPENDED ||
 			xhci->shared_hcd->state != HC_STATE_SUSPENDED)
 		return -EINVAL;
 
+	pdev = to_pci_dev(hcd->self.controller);
+
+	/*
+	 * Systems with the TI redriver that loses port status change events
+	 * need to have the registers polled during D3, so avoid D3cold.
+	 */
+	if (xhci_compliance_mode_recovery_timer_quirk_check())
+		pdev->no_d3cold = true;
+
 	retval = xhci_suspend(xhci);
 
 	return retval;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6ee481a..2c117ec 100644
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
index 212d408..f056e9f 100644
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
1.7.10.4


