Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3FKUWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:22:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3FKUDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>
Subject: [ 08/79] xhci: Disable D3cold for buggy TI redrivers.
Date: Tue, 11 Jun 2013 13:02:34 -0700
Message-Id: <20130611195313.502826852@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    8 ++++++++
 drivers/usb/host/xhci.c     |    4 ++--
 drivers/usb/host/xhci.h     |    3 +++
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -221,6 +221,14 @@ static void xhci_pci_remove(struct pci_d
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
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -466,7 +466,7 @@ static void compliance_mode_recovery_tim
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
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1853,4 +1853,7 @@ struct xhci_input_control_ctx *xhci_get_
 struct xhci_slot_ctx *xhci_get_slot_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx);
 struct xhci_ep_ctx *xhci_get_ep_ctx(struct xhci_hcd *xhci, struct xhci_container_ctx *ctx, unsigned int ep_index);
 
+/* xHCI quirks */
+bool xhci_compliance_mode_recovery_timer_quirk_check(void);
+
 #endif /* __LINUX_XHCI_HCD_H */


