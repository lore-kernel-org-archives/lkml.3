Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaEHQP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:15:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:57078 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230AbaEHQPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:15:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535979592"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 03/10] usb: catch attempts to submit urbs with a vmalloc'd transfer buffer
Date: Thu,  8 May 2014 19:25:56 +0300
Message-Id: <1399566363-25837-4-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Save someone else the debug cycles of figuring out why a driver's
transfer request is failing or causing undefined system behavior.
Buffers submitted for dma must come from GFP allocated / DMA-able
memory.

Return -EAGAIN matching the return value for dma_mapping_error() cases.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/core/hcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 9c4e292..adddc66 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1502,6 +1502,9 @@ int usb_hcd_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
 					ret = -EAGAIN;
 				else
 					urb->transfer_flags |= URB_DMA_MAP_PAGE;
+			} else if (is_vmalloc_addr(urb->transfer_buffer)) {
+				WARN_ONCE(1, "transfer buffer not dma capable\n");
+				ret = -EAGAIN;
 			} else {
 				urb->transfer_dma = dma_map_single(
 						hcd->self.controller,
-- 
1.8.3.2

