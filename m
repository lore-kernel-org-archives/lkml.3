Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3GHNFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:05:16 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:56110 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3GHNFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:05:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,1020,1363132800"; 
   d="scan'208";a="6453383"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 3/4] xen-blkfront: prevent hoarding all grants
Date: Mon, 8 Jul 2013 15:03:26 +0200
Message-ID: <1373288607-1876-4-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent blkfront from hoarding all grants by adding a minimum number
of grants that must be free at all times. We still need a way to free
unused grants in blkfront, but this patch will mitigate the problem
in the meantime.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkfront.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 187a437..3d445c0 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -101,6 +101,12 @@ MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default
 #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
 /*
+ * Make sure there are at least MIN_FREE_GRANTS at all times, preventing
+ * blkfront from hoarding all grants
+ */
+#define MIN_FREE_GRANTS		512
+
+/*
  * We have one of these per vbd, whether ide, scsi or 'other'.  They
  * hang in private_data off the gendisk structure. We may end up
  * putting all kinds of interesting stuff here :-)
@@ -412,13 +418,13 @@ static int blkif_queue_request(struct request *req)
 	if (info->persistent_gnts_c < max_grefs) {
 		new_persistent_gnts = 1;
 		if (gnttab_alloc_grant_references(
-		    max_grefs - info->persistent_gnts_c,
+		    max_grefs - info->persistent_gnts_c + MIN_FREE_GRANTS,
 		    &gref_head) < 0) {
 			gnttab_request_free_callback(
 				&info->callback,
 				blkif_restart_queue_callback,
 				info,
-				max_grefs);
+				max_grefs + MIN_FREE_GRANTS);
 			return 1;
 		}
 	} else
-- 
1.7.7.5 (Apple Git-26)

