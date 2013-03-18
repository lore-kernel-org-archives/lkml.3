Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3CRQvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:51:21 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:57578 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab3CRQvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:51:16 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355097600"; 
   d="scan'208";a="2617148"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/5] xen-blkback: don't store dev_bus_addr
Date: Mon, 18 Mar 2013 17:49:32 +0100
Message-ID: <1363625376-35612-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
References: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_bus_addr returned in the grant ref map operation is the mfn of the
passed page, there's no need to store it in the persistent grant
entry, since we can always get it provided that we have the page.

This reduces the memory overhead of persistent grants in blkback.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org
---
 drivers/block/xen-blkback/blkback.c |   17 ++++-------------
 drivers/block/xen-blkback/common.h  |    1 -
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 477a17c..d909acf0 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -621,30 +621,21 @@ static int xen_blkbk_map(struct blkif_request *req,
 				 * If this is a new persistent grant
 				 * save the handler
 				 */
-				persistent_gnts[i]->handle = map[j].handle;
-				persistent_gnts[i]->dev_bus_addr =
-					map[j++].dev_bus_addr;
+				persistent_gnts[i]->handle = map[j++].handle;
 			}
 			pending_handle(pending_req, i) =
 				persistent_gnts[i]->handle;
 
 			if (ret)
 				continue;
-
-			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
-				(req->u.rw.seg[i].first_sect << 9);
 		} else {
-			pending_handle(pending_req, i) = map[j].handle;
+			pending_handle(pending_req, i) = map[j++].handle;
 			bitmap_set(pending_req->unmap_seg, i, 1);
 
-			if (ret) {
-				j++;
+			if (ret)
 				continue;
-			}
-
-			seg[i].buf = map[j++].dev_bus_addr |
-				(req->u.rw.seg[i].first_sect << 9);
 		}
+		seg[i].buf = (req->u.rw.seg[i].first_sect << 9);
 	}
 	return ret;
 }
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index da78346..60103e2 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -187,7 +187,6 @@ struct persistent_gnt {
 	struct page *page;
 	grant_ref_t gnt;
 	grant_handle_t handle;
-	uint64_t dev_bus_addr;
 	struct rb_node node;
 };
 
-- 
1.7.7.5 (Apple Git-26)

