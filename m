Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaFXODZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:03:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:24941 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbaFXODX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,538,1400050800"; 
   d="scan'208";a="560222422"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/5] xhci: correct burst count field for isoc transfers on 1.0 xhci hosts
Date: Tue, 24 Jun 2014 17:14:41 +0300
Message-Id: <1403619322-24704-2-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1403618059-24533-1-git-send-email-mathias.nyman@linux.intel.com>
 <1403619322-24704-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The transfer burst count (TBC) field in xhci 1.0 hosts should be set
to the number of bursts needed to transfer all packets in a isoc TD.
Supported values are 0-2 (1 to 3 bursts per service interval).

Formula for TBC calculation is given in xhci spec section 4.11.2.3:
TBC = roundup( Transfer Descriptor Packet Count / Max Burst Size +1 ) - 1

This patch should be applied to stable kernels since 3.0 that contain
the commit 5cd43e33b9519143f06f507dd7cbee6b7a621885
"xhci 1.0: Set transfer burst count field."

Cc: stable@vger.kernel.org # 3.0
Suggested-by: ShiChun Ma <masc2008@qq.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 71657d3..749fc68 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3537,7 +3537,7 @@ static unsigned int xhci_get_burst_count(struct xhci_hcd *xhci,
 		return 0;
 
 	max_burst = urb->ep->ss_ep_comp.bMaxBurst;
-	return roundup(total_packet_count, max_burst + 1) - 1;
+	return DIV_ROUND_UP(total_packet_count, max_burst + 1) - 1;
 }
 
 /*
-- 
1.8.3.2

