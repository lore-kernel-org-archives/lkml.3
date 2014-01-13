Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaAMPBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:01:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:16954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbaAMO6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939280"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 03/10] xhci: use command structures for xhci_queue_slot_control()
Date: Mon, 13 Jan 2014 17:05:52 +0200
Message-Id: <1389625559-32414-4-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing for the global command queue by changing functions calling
xhci_queue_slot_control() to internally use command structures

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 0167a1c..a60e432 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3562,6 +3562,11 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	unsigned long flags;
 	u32 state;
 	int i, ret;
+	struct xhci_command *command;
+
+	command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
+	if (!command)
+		return;
 
 #ifndef CONFIG_USB_DEFAULT_PERSIST
 	/*
@@ -3577,8 +3582,10 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	/* If the host is halted due to driver unload, we still need to free the
 	 * device.
 	 */
-	if (ret <= 0 && ret != -ENODEV)
+	if (ret <= 0 && ret != -ENODEV) {
+		kfree(command);
 		return;
+	}
 
 	virt_dev = xhci->devs[udev->slot_id];
 
@@ -3595,16 +3602,20 @@ void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 			(xhci->xhc_state & XHCI_STATE_HALTED)) {
 		xhci_free_virt_device(xhci, udev->slot_id);
 		spin_unlock_irqrestore(&xhci->lock, flags);
+		kfree(command);
 		return;
 	}
 
 	if (xhci_queue_slot_control(xhci, TRB_DISABLE_SLOT, udev->slot_id)) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
+		kfree(command);
 		return;
 	}
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
+	kfree(command);
+
 	/*
 	 * Event command completion handler will free any data structures
 	 * associated with the slot.  XXX Can free sleep?
@@ -3644,31 +3655,41 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	unsigned long flags;
 	int timeleft;
 	int ret;
-	union xhci_trb *cmd_trb;
+	struct xhci_command *command;
+
+	command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
+	if (!command)
+		return 0;
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
+	command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
+	command->completion = &xhci->addr_dev;
 	ret = xhci_queue_slot_control(xhci, TRB_ENABLE_SLOT, 0);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		xhci_dbg(xhci, "FIXME: allocate a command ring segment\n");
+		kfree(command);
 		return 0;
 	}
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* XXX: how much time for xHC slot assignment? */
-	timeleft = wait_for_completion_interruptible_timeout(&xhci->addr_dev,
+	timeleft = wait_for_completion_interruptible_timeout(
+			command->completion,
 			XHCI_CMD_DEFAULT_TIMEOUT);
 	if (timeleft <= 0) {
 		xhci_warn(xhci, "%s while waiting for a slot\n",
 				timeleft == 0 ? "Timeout" : "Signal");
 		/* cancel the enable slot request */
-		return xhci_cancel_cmd(xhci, NULL, cmd_trb);
+		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
+		kfree(command);
+		return ret;
 	}
 
 	if (!xhci->slot_id) {
 		xhci_err(xhci, "Error while assigning device slot ID\n");
+		kfree(command);
 		return 0;
 	}
 
@@ -3703,6 +3724,8 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 		pm_runtime_get_noresume(hcd->self.controller);
 #endif
 
+
+	kfree(command);
 	/* Is this a LS or FS device under a HS hub? */
 	/* Hub or peripherial? */
 	return 1;
@@ -3713,6 +3736,7 @@ disable_slot:
 	if (!xhci_queue_slot_control(xhci, TRB_DISABLE_SLOT, udev->slot_id))
 		xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
+	kfree(command);
 	return 0;
 }
 
-- 
1.8.1.2

