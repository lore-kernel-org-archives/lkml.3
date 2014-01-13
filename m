Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaAMO7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:59:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:16954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbaAMO6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939349"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 06/10] xhci: use command structures for xhci_queue_reset_ep()
Date: Mon, 13 Jan 2014 17:05:55 +0200
Message-Id: <1389625559-32414-7-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for the global command ring by using command structures
internally in functions calling xhci_queue_reset_ep()

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 5 +++++
 drivers/usb/host/xhci.c      | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index df5b0f8..bf50d28 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1913,6 +1913,10 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 		struct xhci_td *td, union xhci_trb *event_trb)
 {
 	struct xhci_virt_ep *ep = &xhci->devs[slot_id]->eps[ep_index];
+	struct xhci_command *command;
+	command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
+	if (!command)
+		return;
 	ep->ep_state |= EP_HALTED;
 	ep->stopped_td = td;
 	ep->stopped_trb = event_trb;
@@ -1926,6 +1930,7 @@ static void xhci_cleanup_halted_endpoint(struct xhci_hcd *xhci,
 	ep->stopped_stream = 0;
 
 	xhci_ring_cmd_db(xhci);
+	kfree(command);
 }
 
 /* Check if an error has halted the endpoint ring.  The class driver will
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index fa0ac48..23e057f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2906,6 +2906,7 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
 	unsigned long flags;
 	int ret;
 	struct xhci_virt_ep *virt_ep;
+	struct xhci_command *command;
 
 	xhci = hcd_to_xhci(hcd);
 	udev = (struct usb_device *) ep->hcpriv;
@@ -2928,6 +2929,10 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
 		return;
 	}
 
+	command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
+	if (!command)
+		return;
+
 	xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
 			"Queueing reset endpoint command");
 	spin_lock_irqsave(&xhci->lock, flags);
@@ -2946,6 +2951,7 @@ void xhci_endpoint_reset(struct usb_hcd *hcd,
 	virt_ep->stopped_trb = NULL;
 	virt_ep->stopped_stream = 0;
 	spin_unlock_irqrestore(&xhci->lock, flags);
+	kfree(command);
 
 	if (ret)
 		xhci_warn(xhci, "FIXME allocate a new ring segment\n");
-- 
1.8.1.2

