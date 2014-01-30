Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaA3OFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 09:05:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:43983 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbaA3OCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 09:02:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,750,1384329600"; 
   d="scan'208";a="475123364"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFCv2 04/10] xhci: use command structures for xhci_queue_stop_endpoint()
Date: Thu, 30 Jan 2014 16:10:21 +0200
Message-Id: <1391091027-31783-5-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1391091027-31783-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for the global command ring by using command structures
internally in functions calling xhci_queue_stop_endpoint()

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c | 15 +++++++++++++--
 drivers/usb/host/xhci.c     |  3 +++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 805f234..68bc1c6 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -20,7 +20,8 @@
  * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/gfp.h>
+
+#include <linux/slab.h>
 #include <asm/unaligned.h>
 
 #include "xhci.h"
@@ -284,8 +285,18 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 
 	spin_lock_irqsave(&xhci->lock, flags);
 	for (i = LAST_EP_INDEX; i > 0; i--) {
-		if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue)
+		if (virt_dev->eps[i].ring && virt_dev->eps[i].ring->dequeue) {
+			struct xhci_command *command;
+			command = xhci_alloc_command(xhci, false, false,
+						     GFP_NOIO);
+			if (!command) {
+				spin_unlock_irqrestore(&xhci->lock, flags);
+				xhci_free_command(xhci, cmd);
+				return -ENOMEM;
+			}
 			xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
+			kfree(command);
+		}
 	}
 	cmd->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	list_add_tail(&cmd->cmd_list, &virt_dev->cmd_list);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4ce8c85..d4684d0 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1466,6 +1466,7 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	unsigned int ep_index;
 	struct xhci_ring *ep_ring;
 	struct xhci_virt_ep *ep;
+	struct xhci_command *command;
 
 	xhci = hcd_to_xhci(hcd);
 	spin_lock_irqsave(&xhci->lock, flags);
@@ -1535,6 +1536,7 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 	 * the first cancellation to be handled.
 	 */
 	if (!(ep->ep_state & EP_HALT_PENDING)) {
+		command = xhci_alloc_command(xhci, false, false, GFP_ATOMIC);
 		ep->ep_state |= EP_HALT_PENDING;
 		ep->stop_cmds_pending++;
 		ep->stop_cmd_timer.expires = jiffies +
@@ -1542,6 +1544,7 @@ int xhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		add_timer(&ep->stop_cmd_timer);
 		xhci_queue_stop_endpoint(xhci, urb->dev->slot_id, ep_index, 0);
 		xhci_ring_cmd_db(xhci);
+		kfree(command);
 	}
 done:
 	spin_unlock_irqrestore(&xhci->lock, flags);
-- 
1.8.1.2

