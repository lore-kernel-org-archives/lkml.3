Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaFXODB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:03:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:8881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaFXOC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,538,1400050800"; 
   d="scan'208";a="560222190"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/5] xhci: Use correct SLOT ID when handling a reset device command
Date: Tue, 24 Jun 2014 17:14:40 +0300
Message-Id: <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403618059-24533-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1403618059-24533-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command completion events normally include command completion status,
SLOT_ID, and a pointer to the original command. Reset device command
completion SLOT_ID may be zero according to xhci specs 4.6.11.

VIA controllers set the SLOT_ID to zero, triggering a WARN_ON in the
command completion handler.

Use the SLOT ID found from the original command instead.

This patch should be applied to stable kernels since 3.13 that contain
the commit 20e7acb13ff48fbc884d5918c3697c27de63922a
"xhci: use completion event's slot id rather than dig it out of command"

Cc: stable@vger.kernel.org # 3.13
Reported-by: Saran Neti <sarannmr@gmail.com>
Tested-by: Saran Neti <sarannmr@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index d67ff71..71657d3 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1433,8 +1433,11 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
 		xhci_handle_cmd_reset_ep(xhci, slot_id, cmd_trb, cmd_comp_code);
 		break;
 	case TRB_RESET_DEV:
-		WARN_ON(slot_id != TRB_TO_SLOT_ID(
-				le32_to_cpu(cmd_trb->generic.field[3])));
+		/* SLOT_ID field in reset device cmd completion event TRB is 0.
+		 * Use the SLOT_ID from the command TRB instead (xhci 4.6.11)
+		 */
+		slot_id = TRB_TO_SLOT_ID(
+				le32_to_cpu(cmd_trb->generic.field[3]));
 		xhci_handle_cmd_reset_dev(xhci, slot_id, event);
 		break;
 	case TRB_NEC_GET_FW:
-- 
1.8.3.2

