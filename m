Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaBZT3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:29:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:18347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbaBZT3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:29:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,549,1389772800"; 
   d="scan'208";a="462814074"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFCv3 2/4] xhci: Add a global command queue
Date: Wed, 26 Feb 2014 21:38:48 +0200
Message-Id: <1393443530-9216-3-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1393443530-9216-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1393443530-9216-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a list to store command structures, add a structure to it every time
a command is submitted, and remove it from the list once we get a
command completion event matching the command.

Callers that wait for completion will free their command structures themselves.
The other command structures are freed in the command completion event handler.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-mem.c  |  8 ++++++++
 drivers/usb/host/xhci-ring.c | 21 +++++++++++++++++----
 drivers/usb/host/xhci.c      |  2 --
 drivers/usb/host/xhci.h      |  1 +
 4 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index bce4391..9df2aa0 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1694,6 +1694,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 {
 	struct device	*dev = xhci_to_hcd(xhci)->self.controller;
 	struct xhci_cd  *cur_cd, *next_cd;
+	struct xhci_command *cur_cmd, *next_cmd;
 	int size;
 	int i, j, num_ports;
 
@@ -1722,6 +1723,12 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 		kfree(cur_cd);
 	}
 
+	list_for_each_entry_safe(cur_cmd, next_cmd,
+			&xhci->cmd_list, cmd_list) {
+		list_del(&cur_cmd->cmd_list);
+		kfree(cur_cmd);
+	}
+
 	for (i = 1; i < MAX_HC_SLOTS; ++i)
 		xhci_free_virt_device(xhci, i);
 
@@ -2223,6 +2230,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	int i;
 
 	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
+	INIT_LIST_HEAD(&xhci->cmd_list);
 
 	page_size = readl(&xhci->op_regs->page_size);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index fa34c9b..39d3ff7 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1496,6 +1496,7 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 	dma_addr_t cmd_dequeue_dma;
 	u32 cmd_comp_code;
 	union xhci_trb *cmd_trb;
+	struct xhci_command *cmd;
 	u32 cmd_type;
 
 	cmd_dma = le64_to_cpu(event->cmd_trb);
@@ -1513,6 +1514,13 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		return;
 	}
 
+	cmd = list_entry(xhci->cmd_list.next, struct xhci_command, cmd_list);
+
+	if (cmd->command_trb != xhci->cmd_ring->dequeue) {
+		xhci_err(xhci,
+			 "Command completion event does not match command\n");
+		return;
+	}
 	trace_xhci_cmd_completion(cmd_trb, (struct xhci_generic_trb *) event);
 
 	cmd_comp_code = GET_COMP_CODE(le32_to_cpu(event->status));
@@ -1582,6 +1590,12 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		xhci->error_bitmask |= 1 << 6;
 		break;
 	}
+
+	list_del(&cmd->cmd_list);
+
+	if (!cmd->completion)
+		kfree(cmd);
+
 	inc_deq(xhci, xhci->cmd_ring);
 }
 
@@ -3982,10 +3996,9 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 					"unfailable commands failed.\n");
 		return ret;
 	}
-	if (cmd->completion)
-		cmd->command_trb = xhci->cmd_ring->enqueue;
-	else
-		kfree(cmd);
+
+	cmd->command_trb = xhci->cmd_ring->enqueue;
+	list_add_tail(&cmd->cmd_list, &xhci->cmd_list);
 
 	queue_trb(xhci, xhci->cmd_ring, false, field1, field2, field3,
 			field4 | xhci->cmd_ring->cycle_state);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 8bf2aa3..97de328 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3704,7 +3704,6 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 				timeleft == 0 ? "Timeout" : "Signal");
 		/* cancel the enable slot request */
 		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
-		kfree(command);
 		return ret;
 	}
 
@@ -3860,7 +3859,6 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 			  timeleft == 0 ? "Timeout" : "Signal", act);
 		/* cancel the address device command */
 		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
-		kfree(command);
 		if (ret < 0)
 			return ret;
 		return -ETIME;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 083ff11..7052b8c 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1483,6 +1483,7 @@ struct xhci_hcd {
 #define CMD_RING_STATE_ABORTED         (1 << 1)
 #define CMD_RING_STATE_STOPPED         (1 << 2)
 	struct list_head        cancel_cmd_list;
+	struct list_head        cmd_list;
 	unsigned int		cmd_ring_reserved_trbs;
 	struct xhci_ring	*event_ring;
 	struct xhci_erst	erst;
-- 
1.8.1.2

