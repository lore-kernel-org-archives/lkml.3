Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3HLK4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:56:16 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:30697 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3HLKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:55:59 -0400
X-IronPort-AV: E=Sophos;i="4.89,861,1367971200"; 
   d="scan'208";a="7708589"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH v2 2/2] xen-blkfront: revoke foreign access for grants not mapped by the backend
Date: Mon, 12 Aug 2013 12:53:44 +0200
Message-ID: <1376304824-1967-3-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1376304824-1967-1-git-send-email-roger.pau@citrix.com>
References: <1376304824-1967-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to keep the foreign access in a grant if it is not
persistently mapped by the backend. This allows us to free grants that
are not mapped by the backend, thus preventing blkfront from hoarding
all grants.

The main effect of this is that blkfront will only persistently map
the same grants as the backend, and it will always try to use grants
that are already mapped by the backend. Also the number of persistent
grants in blkfront is the same as in blkback (and is controlled by the
value in blkback).

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Matt Wilson <msw@amazon.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
---
 drivers/block/xen-blkfront.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 187a437..bc9fc7d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1016,13 +1016,38 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 	}
 	/* Add the persistent grant into the list of free grants */
 	for (i = 0; i < nseg; i++) {
-		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
-		info->persistent_gnts_c++;
+		if (gnttab_query_foreign_access(s->grants_used[i]->gref)) {
+			/*
+			 * If the grant is still mapped by the backend (the
+			 * backend has chosen to make this grant persistent)
+			 * we add it at the head of the list, so it will be
+			 * reused first.
+			 */
+			list_add(&s->grants_used[i]->node, &info->persistent_gnts);
+			info->persistent_gnts_c++;
+		} else {
+			/*
+			 * If the grant is not mapped by the backend we end the
+			 * foreign access and add it to the tail of the list,
+			 * so it will not be picked again unless we run out of
+			 * persistent grants.
+			 */
+			gnttab_end_foreign_access(s->grants_used[i]->gref, 0, 0UL);
+			s->grants_used[i]->gref = GRANT_INVALID_REF;
+			list_add_tail(&s->grants_used[i]->node, &info->persistent_gnts);
+		}
 	}
 	if (s->req.operation == BLKIF_OP_INDIRECT) {
 		for (i = 0; i < INDIRECT_GREFS(nseg); i++) {
-			list_add(&s->indirect_grants[i]->node, &info->persistent_gnts);
-			info->persistent_gnts_c++;
+			if (gnttab_query_foreign_access(s->indirect_grants[i]->gref)) {
+				list_add(&s->indirect_grants[i]->node, &info->persistent_gnts);
+				info->persistent_gnts_c++;
+			} else {
+				gnttab_end_foreign_access(s->indirect_grants[i]->gref, 0, 0UL);
+				s->indirect_grants[i]->gref = GRANT_INVALID_REF;
+				list_add_tail(&s->indirect_grants[i]->node,
+				              &info->persistent_gnts);
+			}
 		}
 	}
 }
-- 
1.7.7.5 (Apple Git-26)

