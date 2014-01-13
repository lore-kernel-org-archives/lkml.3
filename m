Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaAMO6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:58:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:9868 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaAMO62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939248"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 02/10] xhci: use a command structure internally in xhci_address_device()
Date: Mon, 13 Jan 2014 17:05:51 +0200
Message-Id: <1389625559-32414-3-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparing for the global command queue by using command strucure
in xhci_address_device

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5e65052..0167a1c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3732,7 +3732,7 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_slot_ctx *slot_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
 	u64 temp_64;
-	union xhci_trb *cmd_trb;
+	struct xhci_command *command;
 
 	if (!udev->slot_id) {
 		xhci_dbg_trace(xhci, trace_xhci_dbg_address,
@@ -3753,11 +3753,19 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 		return -EINVAL;
 	}
 
+	command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
+	if (!command)
+		return -ENOMEM;
+
+	command->in_ctx = virt_dev->in_ctx;
+	command->completion = &xhci->addr_dev;
+
 	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
 	ctrl_ctx = xhci_get_input_control_ctx(xhci, virt_dev->in_ctx);
 	if (!ctrl_ctx) {
 		xhci_warn(xhci, "%s: Could not get input context, bad type.\n",
 				__func__);
+		kfree(command);
 		return -EINVAL;
 	}
 	/*
@@ -3779,20 +3787,22 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 				slot_ctx->dev_info >> 27);
 
 	spin_lock_irqsave(&xhci->lock, flags);
-	cmd_trb = xhci_find_next_enqueue(xhci->cmd_ring);
+	command->command_trb = xhci_find_next_enqueue(xhci->cmd_ring);
 	ret = xhci_queue_address_device(xhci, virt_dev->in_ctx->dma,
 					udev->slot_id);
 	if (ret) {
 		spin_unlock_irqrestore(&xhci->lock, flags);
 		xhci_dbg_trace(xhci, trace_xhci_dbg_address,
 				"FIXME: allocate a command ring segment");
+		kfree(command);
 		return ret;
 	}
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* ctrl tx can take up to 5 sec; XXX: need more time for xHC? */
-	timeleft = wait_for_completion_interruptible_timeout(&xhci->addr_dev,
+	timeleft = wait_for_completion_interruptible_timeout(
+			command->completion,
 			XHCI_CMD_DEFAULT_TIMEOUT);
 	/* FIXME: From section 4.3.4: "Software shall be responsible for timing
 	 * the SetAddress() "recovery interval" required by USB and aborting the
@@ -3802,7 +3812,8 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 		xhci_warn(xhci, "%s while waiting for address device command\n",
 				timeleft == 0 ? "Timeout" : "Signal");
 		/* cancel the address device command */
-		ret = xhci_cancel_cmd(xhci, NULL, cmd_trb);
+		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
+		kfree(command);
 		if (ret < 0)
 			return ret;
 		return -ETIME;
@@ -3838,6 +3849,7 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 		break;
 	}
 	if (ret) {
+		kfree(command);
 		return ret;
 	}
 	temp_64 = xhci_read_64(xhci, &xhci->op_regs->dcbaa_ptr);
@@ -3872,7 +3884,7 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_address,
 		       "Internal device address = %d",
 		       le32_to_cpu(slot_ctx->dev_state) & DEV_ADDR_MASK);
-
+	kfree(command);
 	return 0;
 }
 
-- 
1.8.1.2

