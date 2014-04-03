Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaDCOdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:33:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:31167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaDCOdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:33:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,787,1389772800"; 
   d="scan'208";a="514126633"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <sebastien.dufour@intel.com>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC v5 2/4] xhci: Add a global command queue
Date: Thu,  3 Apr 2014 17:42:52 +0300
Message-Id: <1396536174-20471-3-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396536174-20471-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1396536174-20471-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a list to store command structures, add a structure to it every time
a command is submitted, and remove it from the list once we get a
command completion event matching the command.

Callers that wait for completion will free their command structures themselves.
The other command structures are freed in the command completion event handler.

Also add a check that prevents queuing commands if host is dying

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-mem.c  |  2 ++
 drivers/usb/host/xhci-ring.c | 34 ++++++++++++++++++++++++++++++----
 drivers/usb/host/xhci.c      |  2 --
 drivers/usb/host/xhci.h      |  2 ++
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index c089668..b070a17 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1821,6 +1821,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 		list_del(&cur_cd->cancel_cmd_list);
 		kfree(cur_cd);
 	}
+	xhci_cleanup_command_queue(xhci);
 
 	for (i = 1; i < MAX_HC_SLOTS; ++i)
 		xhci_free_virt_device(xhci, i);
@@ -2324,6 +2325,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 	int i;
 
 	INIT_LIST_HEAD(&xhci->cancel_cmd_list);
+	INIT_LIST_HEAD(&xhci->cmd_list);
 
 	page_size = readl(&xhci->op_regs->page_size);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 25c83db..884da42 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1521,6 +1521,20 @@ static void xhci_handle_cmd_nec_get_fw(struct xhci_hcd *xhci,
 			NEC_FW_MINOR(le32_to_cpu(event->status)));
 }
 
+static void xhci_del_and_free_cmd(struct xhci_command *cmd)
+{
+	list_del(&cmd->cmd_list);
+	if (!cmd->completion)
+		kfree(cmd);
+}
+
+void xhci_cleanup_command_queue(struct xhci_hcd *xhci)
+{
+	struct xhci_command *cur_cmd, *tmp_cmd;
+	list_for_each_entry_safe(cur_cmd, tmp_cmd, &xhci->cmd_list, cmd_list)
+		xhci_del_and_free_cmd(cur_cmd);
+}
+
 static void handle_cmd_completion(struct xhci_hcd *xhci,
 		struct xhci_event_cmd *event)
 {
@@ -1529,6 +1543,7 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 	dma_addr_t cmd_dequeue_dma;
 	u32 cmd_comp_code;
 	union xhci_trb *cmd_trb;
+	struct xhci_command *cmd;
 	u32 cmd_type;
 
 	cmd_dma = le64_to_cpu(event->cmd_trb);
@@ -1546,6 +1561,13 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
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
@@ -1615,6 +1637,9 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		xhci->error_bitmask |= 1 << 6;
 		break;
 	}
+
+	xhci_del_and_free_cmd(cmd);
+
 	inc_deq(xhci, xhci->cmd_ring);
 }
 
@@ -4002,6 +4027,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 {
 	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
 	int ret;
+	if (xhci->xhc_state & XHCI_STATE_DYING)
+		return -ESHUTDOWN;
 
 	if (!command_must_succeed)
 		reserved_trbs++;
@@ -4015,10 +4042,9 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
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
index 942aa7a..a8d0c50 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3733,7 +3733,6 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 				timeleft == 0 ? "Timeout" : "Signal");
 		/* cancel the enable slot request */
 		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
-		kfree(command);
 		return ret;
 	}
 
@@ -3889,7 +3888,6 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 			  timeleft == 0 ? "Timeout" : "Signal", act);
 		/* cancel the address device command */
 		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
-		kfree(command);
 		if (ret < 0)
 			return ret;
 		return -ETIME;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index d1d0907..4f816e3 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1486,6 +1486,7 @@ struct xhci_hcd {
 #define CMD_RING_STATE_ABORTED         (1 << 1)
 #define CMD_RING_STATE_STOPPED         (1 << 2)
 	struct list_head        cancel_cmd_list;
+	struct list_head        cmd_list;
 	unsigned int		cmd_ring_reserved_trbs;
 	struct xhci_ring	*event_ring;
 	struct xhci_erst	erst;
@@ -1854,6 +1855,7 @@ int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
 		union xhci_trb *cmd_trb);
 void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
 		unsigned int ep_index, unsigned int stream_id);
+void xhci_cleanup_command_queue(struct xhci_hcd *xhci);
 
 /* xHCI roothub code */
 void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
-- 
1.8.3.2

