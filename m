Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaHVLUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:20:20 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:43475 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbaHVLT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:19:29 -0400
From: Arianna Avanzini <avanzini.arianna@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Cc: bob.liu@oracle.com, felipe.franciosi@citrix.com, axboe@fb.com,
        avanzini.arianna@gmail.com
Subject: [PATCH RFC 2/4] xen, blkfront: factor out flush-related checks from do_blkif_request()
Date: Fri, 22 Aug 2014 13:20:02 +0200
Message-Id: <1408706404-6614-3-git-send-email-avanzini.arianna@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
References: <1408706404-6614-1-git-send-email-avanzini.arianna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit factors out some checks related to the request insertion
path, which now are performed by both the multi-queue and the request-
queue hooks. This commit introduces no functional change.

Signed-off-by: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 drivers/block/xen-blkfront.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 0407ad5..a047346 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -588,6 +588,14 @@ static inline void flush_requests(struct blkfront_info *info)
 		notify_remote_via_irq(info->irq);
 }
 
+static inline bool blkif_request_flush_mismatch(struct request *req,
+						struct blkfront_info *info)
+{
+	return ((req->cmd_type != REQ_TYPE_FS) ||
+		((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
+		!info->flush_op));
+}
+
 /*
  * do_blkif_request
  *  read a block; request is in a request queue
@@ -610,9 +618,7 @@ static void do_blkif_request(struct request_queue *rq)
 
 		blk_start_request(req);
 
-		if ((req->cmd_type != REQ_TYPE_FS) ||
-		    ((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
-		    !info->flush_op)) {
+		if (blkif_request_flush_mismatch(req, info)) {
 			__blk_end_request_all(req, -EIO);
 			continue;
 		}
@@ -648,9 +654,7 @@ static int blkfront_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	if (RING_FULL(&info->ring))
 		goto wait;
 
-	if ((req->cmd_type != REQ_TYPE_FS) ||
-			((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
-			 !info->flush_op)) {
+	if (blkif_request_flush_mismatch(req, info)) {
 		req->errors = -EIO;
 		blk_mq_complete_request(req);
 		spin_unlock_irq(&info->io_lock);
-- 
2.0.4

