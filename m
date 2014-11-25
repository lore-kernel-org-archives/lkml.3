Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaKYNPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:15:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37143 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaKYNPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:15:46 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <peter.chen@freescale.com>, <sojka@merica.cz>, <mathias.nyman@intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 02/19] usb: host xhci: fix up deallocation code
Date: Tue, 25 Nov 2014 18:41:38 +0530
Message-ID: <1416921115-10467-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up the deallocation code in the xhci driver, so that
usb_add_hcd()/usb_remove_hcd() can be called repeatedly without
crashing.

In case of DRD mode, the DRD library calls /usb_remove_hcd() while
switching from HOST mode to Device mode, but it doesnot call usb_put_hcd().
We need to preserve the already allocated xhci struct for the subsequent
call of usb_add_hcd() from the DRD library.

A new quirk flag XHCI_DRD_SUPPORT is added to differentiate between
normal usb_remove_hcd and drd specific call.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/host/xhci.c | 22 ++++++++++++++++------
 drivers/usb/host/xhci.h |  1 +
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 2a5d45b..d4196f8 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -666,7 +666,8 @@ static void xhci_only_stop_hcd(struct usb_hcd *hcd)
 	 * calls this function when allocation fails in usb_add_hcd(), or
 	 * usb_remove_hcd() is called).  So we need to unset xHCI's pointer.
 	 */
-	xhci->shared_hcd = NULL;
+	if (!(xhci->quirks & XHCI_DRD_SUPPORT))
+		xhci->shared_hcd = NULL;
 	spin_unlock_irq(&xhci->lock);
 }
 
@@ -4815,6 +4816,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	struct xhci_hcd		*xhci;
 	struct device		*dev = hcd->self.controller;
 	int			retval;
+	bool			allocated = false;
 
 	/* Accept arbitrarily long scatter-gather lists */
 	hcd->self.sg_tablesize = ~0;
@@ -4826,10 +4828,15 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	hcd->self.no_stop_on_short = 1;
 
 	if (usb_hcd_is_primary_hcd(hcd)) {
-		xhci = kzalloc(sizeof(struct xhci_hcd), GFP_KERNEL);
-		if (!xhci)
-			return -ENOMEM;
-		*((struct xhci_hcd **) hcd->hcd_priv) = xhci;
+		if (*((struct xhci_hcd **)hcd->hcd_priv) == NULL) {
+			xhci = kzalloc(sizeof(struct xhci_hcd), GFP_KERNEL);
+			if (!xhci)
+				return -ENOMEM;
+			*((struct xhci_hcd **)hcd->hcd_priv) = xhci;
+			allocated = true;
+		} else {
+			xhci = *((struct xhci_hcd **)hcd->hcd_priv);
+		}
 		xhci->main_hcd = hcd;
 		/* Mark the first roothub as being USB 2.0.
 		 * The xHCI driver will register the USB 3.0 roothub.
@@ -4902,7 +4909,10 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 	xhci_dbg(xhci, "Called HCD init\n");
 	return 0;
 error:
-	kfree(xhci);
+	if (allocated) {
+		*((struct xhci_hcd **)hcd->hcd_priv) = NULL;
+		kfree(xhci);
+	}
 	return retval;
 }
 EXPORT_SYMBOL_GPL(xhci_gen_setup);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index df76d64..2248058 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1560,6 +1560,7 @@ struct xhci_hcd {
 #define XHCI_SPURIOUS_WAKEUP	(1 << 18)
 /* For controllers with a broken beyond repair streams implementation */
 #define XHCI_BROKEN_STREAMS	(1 << 19)
+#define XHCI_DRD_SUPPORT	(1 << 20)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */
-- 
1.8.3.1

