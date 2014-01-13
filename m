Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaAMO7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:59:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:16954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaAMO6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:58:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="457939402"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <linux-usb@vger.kernel.org>
Cc: <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC 08/10] xhci: Add a global command queue
Date: Mon, 13 Jan 2014 17:05:57 +0200
Message-Id: <1389625559-32414-9-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1389625559-32414-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a list to store command structures, add a strucure to it every time
a command is submitted, and remove it from the list once we get a
command completion event matching the command.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-mem.c  |  8 ++++++++
 drivers/usb/host/xhci-ring.c | 13 ++++++++++++-
 drivers/usb/host/xhci.h      |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 49b8bd0..7f8e4c3 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1694,6 +1694,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 {
 	struct pci_dev	*pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
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
 
 	page_size = xhci_readl(xhci, &xhci->op_regs->page_size);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6f6018c..5ccf642 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1502,6 +1502,7 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 	dma_addr_t cmd_dequeue_dma;
 	u32 cmd_comp_code;
 	union xhci_trb *cmd_trb;
+	struct xhci_command *cmd;
 	u32 cmd_type;
 
 	cmd_dma = le64_to_cpu(event->cmd_trb);
@@ -1519,6 +1520,13 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
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
@@ -1588,6 +1596,9 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		xhci->error_bitmask |= 1 << 6;
 		break;
 	}
+
+	list_del(&cmd->cmd_list);
+
 	inc_deq(xhci, xhci->cmd_ring);
 }
 
@@ -3989,7 +4000,7 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 		return ret;
 	}
 	cmd->command_trb = xhci->cmd_ring->enqueue;
-
+	list_add_tail(&cmd->cmd_list, &xhci->cmd_list);
 	queue_trb(xhci, xhci->cmd_ring, false, field1, field2, field3,
 			field4 | xhci->cmd_ring->cycle_state);
 	return 0;
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index d02b73d..71aed35 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1475,6 +1475,7 @@ struct xhci_hcd {
 #define CMD_RING_STATE_ABORTED         (1 << 1)
 #define CMD_RING_STATE_STOPPED         (1 << 2)
 	struct list_head        cancel_cmd_list;
+	struct list_head        cmd_list;
 	unsigned int		cmd_ring_reserved_trbs;
 	struct xhci_ring	*event_ring;
 	struct xhci_erst	erst;
-- 
1.8.1.2

