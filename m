Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaEHQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:16:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:57102 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbaEHQQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:16:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535979689"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 08/10] xhci: Add a global command queue
Date: Thu,  8 May 2014 19:26:01 +0300
Message-Id: <1399566363-25837-9-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
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
index b172a7d..89b8745 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1520,6 +1520,20 @@ static void xhci_handle_cmd_nec_get_fw(struct xhci_hcd *xhci,
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
@@ -1528,6 +1542,7 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 	dma_addr_t cmd_dequeue_dma;
 	u32 cmd_comp_code;
 	union xhci_trb *cmd_trb;
+	struct xhci_command *cmd;
 	u32 cmd_type;
 
 	cmd_dma = le64_to_cpu(event->cmd_trb);
@@ -1545,6 +1560,13 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
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
@@ -1614,6 +1636,9 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		xhci->error_bitmask |= 1 << 6;
 		break;
 	}
+
+	xhci_del_and_free_cmd(cmd);
+
 	inc_deq(xhci, xhci->cmd_ring);
 }
 
@@ -3998,6 +4023,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 {
 	int reserved_trbs = xhci->cmd_ring_reserved_trbs;
 	int ret;
+	if (xhci->xhc_state & XHCI_STATE_DYING)
+		return -ESHUTDOWN;
 
 	if (!command_must_succeed)
 		reserved_trbs++;
@@ -4011,10 +4038,9 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
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
index 9a4c6df..8dbc410 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3732,7 +3732,6 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 				timeleft == 0 ? "Timeout" : "Signal");
 		/* cancel the enable slot request */
 		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
-		kfree(command);
 		return ret;
 	}
 
@@ -3891,7 +3890,6 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 			  timeleft == 0 ? "Timeout" : "Signal", act);
 		/* cancel the address device command */
 		ret = xhci_cancel_cmd(xhci, NULL, command->command_trb);
-		kfree(command);
 		if (ret < 0)
 			return ret;
 		return -ETIME;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index c0fdb49..d33cd37 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1484,6 +1484,7 @@ struct xhci_hcd {
 #define CMD_RING_STATE_ABORTED         (1 << 1)
 #define CMD_RING_STATE_STOPPED         (1 << 2)
 	struct list_head        cancel_cmd_list;
+	struct list_head        cmd_list;
 	unsigned int		cmd_ring_reserved_trbs;
 	struct xhci_ring	*event_ring;
 	struct xhci_erst	erst;
@@ -1851,6 +1852,7 @@ int xhci_cancel_cmd(struct xhci_hcd *xhci, struct xhci_command *command,
 		union xhci_trb *cmd_trb);
 void xhci_ring_ep_doorbell(struct xhci_hcd *xhci, unsigned int slot_id,
 		unsigned int ep_index, unsigned int stream_id);
+void xhci_cleanup_command_queue(struct xhci_hcd *xhci);
 
 /* xHCI roothub code */
 void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
-- 
1.8.3.2

