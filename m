Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3KFLaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:30:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:4931 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756120Ab3KFLaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:30:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="317669293"
From: xiao jin <jin.xiao@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xiao jin <jin.xiao@intel.com>
Subject: [PATCH] xhci-ring: process bulk set actual_length only when not COMP_STOP_INVAL
Date: Wed,  6 Nov 2013 19:42:35 +0800
Message-Id: <1383738155-9264-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When suspend, some urb is put into cancelled_td_list.
process_bulk_intr_td may process the last trb as below:
xhci_transfer_event.transfer_len = 0
xhci_transfer_event.trb_comp_code = 27
urb.transfer_buffer_length = 1024

trb_comp_code is COMP_STOP_INVAL, it should be taken as
invalid urb and discarded, but urb actual_length still is
calculated as transfer_buffer_length. When handling Stop
Endpoint Command completion, the urb in cancelled_td_list
is transferred to upper layer(cdc-acm for example). The
content of urb transfer_buffer is the overlay of previous
two read transfer_buffer. It makes upper layer process wrong
buffer.

This patch is to set actual_length as transfer_buffer_length
only if trb_comp_code is not COMP_STOP_INVAL when
process_bulk_intr_td.

Signed-off-by: xiao jin <jin.xiao@intel.com>
---
 drivers/usb/host/xhci-ring.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6bfbd80..c9a8863 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2319,8 +2319,11 @@ static int process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_td *td,
 					*status = 0;
 			}
 		} else {
-			td->urb->actual_length =
-				td->urb->transfer_buffer_length;
+			if (trb_comp_code != COMP_STOP_INVAL)
+				td->urb->actual_length =
+					td->urb->transfer_buffer_length;
+			else
+				td->urb->actual_length = 0;
 			/* Ignore a short packet completion if the
 			 * untransferred length was zero.
 			 */
-- 
1.7.0.4

