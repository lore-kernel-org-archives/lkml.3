Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaLHOR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:17:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaLHOR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:17:58 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Andrew Jones <drjones@redhat.com>
Subject: [PATCH] xen/blkfront: remove redundant flush_op
Date: Mon,  8 Dec 2014 15:17:47 +0100
Message-Id: <1418048267-18509-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_op is unambiguously defined by feature_flush:
    REQ_FUA | REQ_FLUSH -> BLKIF_OP_WRITE_BARRIER
    REQ_FLUSH -> BLKIF_OP_FLUSH_DISKCACHE
    0 -> 0
and thus can be removed. This is just a cleanup.

The patch was suggested by Boris Ostrovsky.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
The patch is supposed to be applied after "xen/blkfront: improve protection
against issuing unsupported REQ_FUA".
---
 drivers/block/xen-blkfront.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2e6c103..d1ee233 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -126,7 +126,6 @@ struct blkfront_info
 	unsigned int persistent_gnts_c;
 	unsigned long shadow_free;
 	unsigned int feature_flush;
-	unsigned int flush_op;
 	unsigned int feature_discard:1;
 	unsigned int feature_secdiscard:1;
 	unsigned int discard_granularity;
@@ -479,7 +478,14 @@ static int blkif_queue_request(struct request *req)
 				 * way.  (It's also a FLUSH+FUA, since it is
 				 * guaranteed ordered WRT previous writes.)
 				 */
-				ring_req->operation = info->flush_op;
+				if (unlikely(info->feature_flush & REQ_FUA))
+					ring_req->operation =
+						BLKIF_OP_WRITE_BARRIER;
+				else if (likely(info->feature_flush))
+					ring_req->operation =
+						BLKIF_OP_FLUSH_DISKCACHE;
+				else
+					ring_req->operation = 0;
 			}
 			ring_req->u.rw.nr_segments = nseg;
 		}
@@ -691,8 +697,8 @@ static void xlvbd_flush(struct blkfront_info *info)
 	blk_queue_flush(info->rq, info->feature_flush);
 	printk(KERN_INFO "blkfront: %s: %s: %s %s %s %s %s\n",
 	       info->gd->disk_name,
-	       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
-		"barrier" : (info->flush_op == BLKIF_OP_FLUSH_DISKCACHE ?
+	       info->feature_flush == (REQ_FLUSH | REQ_FUA) ?
+		"barrier" : (info->feature_flush == REQ_FLUSH ?
 		"flush diskcache" : "barrier or flush"),
 	       info->feature_flush ? "enabled;" : "disabled;",
 	       "persistent grants:",
@@ -1190,7 +1196,6 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 				if (error == -EOPNOTSUPP)
 					error = 0;
 				info->feature_flush = 0;
-				info->flush_op = 0;
 				xlvbd_flush(info);
 			}
 			/* fall through */
@@ -1810,7 +1815,6 @@ static void blkfront_connect(struct blkfront_info *info)
 		physical_sector_size = sector_size;
 
 	info->feature_flush = 0;
-	info->flush_op = 0;
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			    "feature-barrier", "%d", &barrier,
@@ -1823,10 +1827,8 @@ static void blkfront_connect(struct blkfront_info *info)
 	 *
 	 * If there are barriers, then we use flush.
 	 */
-	if (!err && barrier) {
+	if (!err && barrier)
 		info->feature_flush = REQ_FLUSH | REQ_FUA;
-		info->flush_op = BLKIF_OP_WRITE_BARRIER;
-	}
 	/*
 	 * And if there is "feature-flush-cache" use that above
 	 * barriers.
@@ -1835,10 +1837,8 @@ static void blkfront_connect(struct blkfront_info *info)
 			    "feature-flush-cache", "%d", &flush,
 			    NULL);
 
-	if (!err && flush) {
+	if (!err && flush)
 		info->feature_flush = REQ_FLUSH;
-		info->flush_op = BLKIF_OP_FLUSH_DISKCACHE;
-	}
 
 	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
 			    "feature-discard", "%d", &discard,
-- 
1.9.3

