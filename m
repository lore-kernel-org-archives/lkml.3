Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaLOTmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:42:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaLOTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:31:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 51/96] USB: xhci: Reset a halted endpoint immediately when we encounter a stall.
Date: Mon, 15 Dec 2014 11:26:11 -0800
Message-Id: <1418671616-25482-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 8e71a322fdb127814bcba423a512914ca5bc6cf5 upstream.

If a device is halted and reuturns a STALL, then the halted endpoint
needs to be cleared both on the host and device side. The host
side halt is cleared by issueing a xhci reset endpoint command. The device side
is cleared with a ClearFeature(ENDPOINT_HALT) request, which should
be issued by the device driver if a URB reruen -EPIPE.

Previously we cleared the host side halt after the device side was cleared.
To make sure the host side halt is cleared in time we want to issue the
reset endpoint command immedialtely when a STALL status is encountered.

Otherwise we end up not following the specs and not returning -EPIPE
several times in a row when trying to transfer data to a halted endpoint.

Fixes: bcef3fd (USB: xhci: Handle errors that cause endpoint halts.)
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 40 ++++++++---------------------
 drivers/usb/host/xhci.c      | 61 +++++++++++---------------------------------
 2 files changed, 25 insertions(+), 76 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1d84081..3cf8bc4 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2015,22 +2015,13 @@ static int finish_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		ep->stopped_td = td;
 		return 0;
 	} else {
-		if (trb_comp_code == COMP_STALL) {
-			/* The transfer is completed from the driver's
-			 * perspective, but we need to issue a set dequeue
-			 * command for this stalled endpoint to move the dequeue
-			 * pointer past the TD.  We can't do that here because
-			 * the halt condition must be cleared first.  Let the
-			 * USB class driver clear the stall later.
-			 */
-			ep->stopped_td = td;
-			ep->stopped_stream = ep_ring->stream_id;
-		} else if (xhci_requires_manual_halt_cleanup(xhci,
-					ep_ctx, trb_comp_code)) {
-			/* Other types of errors halt the endpoint, but the
-			 * class driver doesn't call usb_reset_endpoint() unless
-			 * the error is -EPIPE.  Clear the halted status in the
-			 * xHCI hardware manually.
+		if (trb_comp_code == COMP_STALL ||
+		    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
+						      trb_comp_code)) {
+			/* Issue a reset endpoint command to clear the host side
+			 * halt, followed by a set dequeue command to move the
+			 * dequeue pointer past the TD.
+			 * The class driver clears the device side halt later.
 			 */
 			xhci_cleanup_halted_endpoint(xhci,
 					slot_id, ep_index, ep_ring->stream_id,
@@ -2150,9 +2141,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, struct xhci_td *td,
 		else
 			td->urb->actual_length = 0;
 
-		xhci_cleanup_halted_endpoint(xhci,
-			slot_id, ep_index, 0, td, event_trb);
-		return finish_td(xhci, td, event_trb, event, ep, status, true);
+		return finish_td(xhci, td, event_trb, event, ep, status, false);
 	}
 	/*
 	 * Did we transfer any data, despite the errors that might have
@@ -2706,17 +2695,8 @@ cleanup:
 		if (ret) {
 			urb = td->urb;
 			urb_priv = urb->hcpriv;
-			/* Leave the TD around for the reset endpoint function
-			 * to use(but only if it's not a control endpoint,
-			 * since we already queued the Set TR dequeue pointer
-			 * command for stalled control endpoints).
-			 */
-			if (usb_endpoint_xfer_control(&urb->ep->desc) ||
-				(trb_comp_code != COMP_STALL &&
-					trb_comp_code != COMP_BABBLE))
-				xhci_urb_free_priv(xhci, urb_priv);
-			else
-				kfree(urb_priv);
+
+			xhci_urb_free_priv(xhci, urb_priv);
 
 			usb_hcd_unlink_urb_from_ep(bus_to_hcd(urb->dev->bus), urb);
 			if ((urb->actual_length != urb->transfer_buffer_length &&
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 959e769..9189f3f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2887,63 +2887,32 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
 	}
 }
 
-/* Deal with stalled endpoints.  The core should have sent the control message
- * to clear the halt condition.  However, we need to make the xHCI hardware
- * reset its sequence number, since a device will expect a sequence number of
- * zero after the halt condition is cleared.
+/* Called when clearing halted device. The core should have sent the control
+ * message to clear the device halt condition. The host side of the halt should
+ * already be cleared with a reset endpoint command issued when the STALL tx
+ * event was received.
+ *
  * Context: in_interrupt
  */
+
 void xhci_endpoint_reset(struct usb_hcd *hcd,
 		struct usb_host_endpoint *ep)
 {
 	struct xhci_hcd *xhci;
-	struct usb_device *udev;
-	unsigned int ep_index;
-	unsigned long flags;
-	int ret;
-	struct xhci_virt_ep *virt_ep;
 
 	xhci = hcd_to_xhci(hcd);
-	udev = (struct usb_device *) ep->hcpriv;
-	/* Called with a root hub endpoint (or an endpoint that wasn't added
-	 * with xhci_add_endpoint()
-	 */
-	if (!ep->hcpriv)
-		return;
-	ep_index = xhci_get_endpoint_index(&ep->desc);
-	virt_ep = &xhci->devs[udev->slot_id]->eps[ep_index];
-	if (!virt_ep->stopped_td) {
-		xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
-			"Endpoint 0x%x not halted, refusing to reset.",
-			ep->desc.bEndpointAddress);
-		return;
-	}
-	if (usb_endpoint_xfer_control(&ep->desc)) {
-		xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
-				"Control endpoint stall already handled.");
-		return;
-	}
-
-	xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
-			"Queueing reset endpoint command");
-	spin_lock_irqsave(&xhci->lock, flags);
-	ret = xhci_queue_reset_ep(xhci, udev->slot_id, ep_index);
 	/*
-	 * Can't change the ring dequeue pointer until it's transitioned to the
-	 * stopped state, which is only upon a successful reset endpoint
-	 * command.  Better hope that last command worked!
+	 * We might need to implement the config ep cmd in xhci 4.8.1 note:
+	 * The Reset Endpoint Command may only be issued to endpoints in the
+	 * Halted state. If software wishes reset the Data Toggle or Sequence
+	 * Number of an endpoint that isn't in the Halted state, then software
+	 * may issue a Configure Endpoint Command with the Drop and Add bits set
+	 * for the target endpoint. that is in the Stopped state.
 	 */
-	if (!ret) {
-		xhci_cleanup_stalled_ring(xhci, udev, ep_index);
-		kfree(virt_ep->stopped_td);
-		xhci_ring_cmd_db(xhci);
-	}
-	virt_ep->stopped_td = NULL;
-	virt_ep->stopped_stream = 0;
-	spin_unlock_irqrestore(&xhci->lock, flags);
 
-	if (ret)
-		xhci_warn(xhci, "FIXME allocate a new ring segment\n");
+	/* For now just print debug to follow the situation */
+	xhci_dbg(xhci, "Endpoint 0x%x ep reset callback called\n",
+		 ep->desc.bEndpointAddress);
 }
 
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
-- 
1.9.1

