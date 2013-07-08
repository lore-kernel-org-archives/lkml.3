Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab3GHNGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:06:34 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:44823 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3GHNFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:05:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,1020,1363132800"; 
   d="scan'208";a="6453382"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 2/4] xen-blkfront: improve aproximation of required grants per request
Date: Mon, 8 Jul 2013 15:03:25 +0200
Message-ID: <1373288607-1876-3-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the calculation of required grants to process a request by
using nr_phys_segments instead of always assuming a request is going
to use all posible segments.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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

