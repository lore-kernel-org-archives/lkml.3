Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3HLK4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:56:15 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:60396 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555Ab3HLKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:55:59 -0400
X-IronPort-AV: E=Sophos;i="4.89,861,1367971200"; 
   d="scan'208";a="7708588"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH v2 1/2] xen-blkfront: improve aproximation of required grants per request
Date: Mon, 12 Aug 2013 12:53:43 +0200
Message-ID: <1376304824-1967-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1376304824-1967-1-git-send-email-roger.pau@citrix.com>
References: <1376304824-1967-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the calculation of required grants to process a request by
using nr_phys_segments instead of always assuming a request is going
to use all posible segments.

nr_phys_segments contains the number of scatter-gather DMA addr+len
pairs, which is basically what we put at every granted page.
for_each_sg iterates over the DMA addr+len pairs and uses a grant
page for each of them.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
---
 drivers/block/xen-blkfront.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2e1ee34..187a437 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -400,10 +400,13 @@ static int blkif_queue_request(struct request *req)
 	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
 		return 1;
 
-	max_grefs = info->max_indirect_segments ?
-		    info->max_indirect_segments +
-		    INDIRECT_GREFS(info->max_indirect_segments) :
-		    BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	max_grefs = req->nr_phys_segments;
+	if (max_grefs > BLKIF_MAX_SEGMENTS_PER_REQUEST)
+		/*
+		 * If we are using indirect segments we need to account
+		 * for the indirect grefs used in the request.
+		 */
+		max_grefs += INDIRECT_GREFS(req->nr_phys_segments);
 
 	/* Check if we have enough grants to allocate a requests */
 	if (info->persistent_gnts_c < max_grefs) {
-- 
1.7.7.5 (Apple Git-26)

