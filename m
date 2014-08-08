Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbaHHWSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:18:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbaHHUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 029/259] xhci: Use correct SLOT ID when handling a reset device command
Date: Fri,  8 Aug 2014 13:37:32 -0700
Message-Id: <1407530482-4483-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 6fcfb0d682a8212d321a6131adc94daf0905992a upstream.

Command completion events normally include command completion status,
SLOT_ID, and a pointer to the original command. Reset device command
completion SLOT_ID may be zero according to xhci specs 4.6.11.

VIA controllers set the SLOT_ID to zero, triggering a WARN_ON in the
command completion handler.

Use the SLOT ID found from the original command instead.

This patch should be applied to stable kernels since 3.13 that contain
the commit 20e7acb13ff48fbc884d5918c3697c27de63922a
"xhci: use completion event's slot id rather than dig it out of command"

Reported-by: Saran Neti <sarannmr@gmail.com>
Tested-by: Saran Neti <sarannmr@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 82b5967..da3a91b 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1592,8 +1592,11 @@ static void handle_cmd_completion(struct xhci_hcd *xhci,
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
1.9.1

