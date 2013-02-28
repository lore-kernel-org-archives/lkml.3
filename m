Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3B1K3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:29:41 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:31720 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3B1K3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:29:36 -0500
X-IronPort-AV: E=Sophos;i="4.84,754,1355097600"; 
   d="scan'208";a="2012275"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 01/12] xen-blkback: don't store dev_bus_addr
Date: Thu, 28 Feb 2013 11:28:44 +0100
Message-ID: <1362047335-26402-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
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
 drivers/block/xen-blkback/blkback.c |    7 +++----
 drivers/block/xen-blkback/common.h  |    1 -
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index de1f319..d40beb3 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -621,9 +621,7 @@ static int xen_blkbk_map(struct blkif_request *req,
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
@@ -631,7 +629,8 @@ static int xen_blkbk_map(struct blkif_request *req,
 			if (ret)
 				continue;
 
-			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
+			seg[i].buf = pfn_to_mfn(page_to_pfn(
+				persistent_gnts[i]->page)) << PAGE_SHIFT |
 				(req->u.rw.seg[i].first_sect << 9);
 		} else {
 			pending_handle(pending_req, i) = map[j].handle;
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 6072390..f338f8a 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -172,7 +172,6 @@ struct persistent_gnt {
 	struct page *page;
 	grant_ref_t gnt;
 	grant_handle_t handle;
-	uint64_t dev_bus_addr;
 	struct rb_node node;
 };
 
-- 
1.7.7.5 (Apple Git-26)

