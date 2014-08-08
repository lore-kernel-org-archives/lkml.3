Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbaHHWSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:18:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbaHHUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 030/259] xhci: correct burst count field for isoc transfers on 1.0 xhci hosts
Date: Fri,  8 Aug 2014 13:37:33 -0700
Message-Id: <1407530482-4483-31-git-send-email-kamal@canonical.com>
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

commit 3213b151387df0b95f4eada104f68eb1c1409cb3 upstream.

The transfer burst count (TBC) field in xhci 1.0 hosts should be set
to the number of bursts needed to transfer all packets in a isoc TD.
Supported values are 0-2 (1 to 3 bursts per service interval).

Formula for TBC calculation is given in xhci spec section 4.11.2.3:
TBC = roundup( Transfer Descriptor Packet Count / Max Burst Size +1 ) - 1

This patch should be applied to stable kernels since 3.0 that contain
the commit 5cd43e33b9519143f06f507dd7cbee6b7a621885
"xhci 1.0: Set transfer burst count field."

Suggested-by: ShiChun Ma <masc2008@qq.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index da3a91b..d0d906f 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3680,7 +3680,7 @@ static unsigned int xhci_get_burst_count(struct xhci_hcd *xhci,
 		return 0;
 
 	max_burst = urb->ep->ss_ep_comp.bMaxBurst;
-	return roundup(total_packet_count, max_burst + 1) - 1;
+	return DIV_ROUND_UP(total_packet_count, max_burst + 1) - 1;
 }
 
 /*
-- 
1.9.1

