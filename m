Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3JIBbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:31:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:35738 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab3JIBbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1059,1371106800"; 
   d="scan'208";a="407992287"
Subject: [PATCH] xhci-hub.c: handle command_trb that may be link TRB
From: Xiao Jin <jin.xiao@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com, sboyd@codeaurora.org,
        jslaby@suse.cz
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Oct 2013 09:42:36 +0800
Message-ID: <1381282956.9531.14.camel@xiaojin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiao jin <jin.xiao@intel.com>
Date: Wed, 9 Oct 2013 09:38:45 +0800
Subject: [PATCH] xhci-hub.c: handle command_trb that may be link TRB

When xhci stop device, it's possible cmd_ring enqueue point to
link TRB after queue the last but one stop endpoint. We must
handle the command_trb point to the next segment trb. Otherwise
xhci stop devie will timeout because command_trb can't match
with cmd_ring dequeue.

The patch is to let command_trb point to the next segment trb if
cmd_ring enqueue point to link TRB.

Signed-off-by: xiao jin <jin.xiao@intel.com>
---
 drivers/usb/host/xhci-hub.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 1d35459..4872640 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -287,6 +287,13 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 			xhci_queue_stop_endpoint(xhci, slot_id, i, suspend);
 	}
 	cmd->command_trb = xhci->cmd_ring->enqueue;
+	/* Enqueue pointer can be left pointing to the link TRB,
+	 * we must handle that
+	 */
+	if (TRB_TYPE_LINK_LE32(cmd->command_trb->link.control))
+		cmd->command_trb =
+			xhci->cmd_ring->enq_seg->next->trbs;
+
 	list_add_tail(&cmd->cmd_list, &virt_dev->cmd_list);
 	xhci_queue_stop_endpoint(xhci, slot_id, 0, suspend);
 	xhci_ring_cmd_db(xhci);
-- 
1.7.1



