Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaAMPA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:00:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:16954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbaAMO6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939334"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 05/10] xhci: use command structure for xhci_queue_new_dequeue_state()
Date: Mon, 13 Jan 2014 17:05:54 +0200
Message-Id: <1389625559-32414-6-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for the global command ring by using command structures
internally in functions calling xhci_queue_new_dequeue_state()

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 3 +++
 drivers/usb/host/xhci.c      | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index da83a844..df5b0f8 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -855,11 +855,14 @@ remove_finished_td:
 
 	/* If necessary, queue a Set Transfer Ring Dequeue Pointer command */
 	if (deq_state.new_deq_ptr && deq_state.new_deq_seg) {
+		struct xhci_command *command;
+		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
 		xhci_queue_new_dequeue_state(xhci,
 				slot_id, ep_index,
 				ep->stopped_td->urb->stream_id,
 				&deq_state);
 		xhci_ring_cmd_db(xhci);
+		kfree(command);
 	} else {
 		/* Otherwise ring the doorbell(s) to restart queued transfers */
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 054132b..fa0ac48 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2867,10 +2867,16 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhci,
 	 * issue a configure endpoint command later.
 	 */
 	if (!(xhci->quirks & XHCI_RESET_EP_QUIRK)) {
+		struct xhci_command *command;
+		/* Can't sleep if we're called from cleanup_halted_endpoint() */
+		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
+		if (!command)
+			return;
 		xhci_dbg_trace(xhci, trace_xhci_dbg_reset_ep,
 				"Queueing new dequeue state");
 		xhci_queue_new_dequeue_state(xhci, udev->slot_id,
 				ep_index, ep->stopped_stream, &deq_state);
+		kfree(command);
 	} else {
 		/* Better hope no one uses the input context between now and the
 		 * reset endpoint completion!
-- 
1.8.1.2

