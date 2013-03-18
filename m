Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3CRQvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:51:48 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:32902 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab3CRQvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:51:18 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355097600"; 
   d="scan'208";a="2617154"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/5] xen-blkfront: remove frame list from blk_shadow
Date: Mon, 18 Mar 2013 17:49:36 +0100
Message-ID: <1363625376-35612-6-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
References: <1363625376-35612-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have the frame (pfn of the grant page) stored inside struct
grant, so there's no need to keep an aditional list of mapped frames
for a specific request. This reduces memory usage in blkfront.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org
---
 drivers/block/xen-blkfront.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index c640433..a894f88 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -74,7 +74,6 @@ struct grant {
 struct blk_shadow {
 	struct blkif_request req;
 	struct request *request;
-	unsigned long frame[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct grant *grants_used[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
@@ -356,7 +355,6 @@ static int blkif_ioctl(struct block_device *bdev, fmode_t mode,
 static int blkif_queue_request(struct request *req)
 {
 	struct blkfront_info *info = req->rq_disk->private_data;
-	unsigned long buffer_mfn;
 	struct blkif_request *ring_req;
 	unsigned long id;
 	unsigned int fsect, lsect;
@@ -434,7 +432,6 @@ static int blkif_queue_request(struct request *req)
 
 			gnt_list_entry = get_grant(&gref_head, info);
 			ref = gnt_list_entry->gref;
-			buffer_mfn = pfn_to_mfn(gnt_list_entry->pfn);
 
 			info->shadow[id].grants_used[i] = gnt_list_entry;
 
@@ -465,7 +462,6 @@ static int blkif_queue_request(struct request *req)
 				kunmap_atomic(shared_data);
 			}
 
-			info->shadow[id].frame[i] = mfn_to_pfn(buffer_mfn);
 			ring_req->u.rw.seg[i] =
 					(struct blkif_request_segment) {
 						.gref       = ref,
@@ -1268,7 +1264,7 @@ static int blkif_recover(struct blkfront_info *info)
 				gnttab_grant_foreign_access_ref(
 					req->u.rw.seg[j].gref,
 					info->xbdev->otherend_id,
-					pfn_to_mfn(info->shadow[req->u.rw.id].frame[j]),
+					pfn_to_mfn(copy[i].grants_used[j]->pfn),
 					0);
 		}
 		info->shadow[req->u.rw.id].req = *req;
-- 
1.7.7.5 (Apple Git-26)

