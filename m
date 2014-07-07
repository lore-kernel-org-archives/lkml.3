Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbaGHBN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:13:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaGGXxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Saran Neti <sarannmr@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.15 008/122] xhci: Use correct SLOT ID when handling a reset device command
Date: Mon,  7 Jul 2014 16:56:10 -0700
Message-Id: <20140707235734.488742694@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci-ring.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1611,8 +1611,11 @@ static void handle_cmd_completion(struct
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


