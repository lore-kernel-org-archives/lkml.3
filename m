Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaLANBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:01:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbaLANBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:01:23 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Laszlo Ersek <lersek@redhat.com>, Andrew Jones <drjones@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH RESEND] xen/blkfront: improve protection against issuing unsupported REQ_FUA
Date: Mon,  1 Dec 2014 14:01:13 +0100
Message-Id: <1417438873-2082-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1414417478-20268-1-git-send-email-vkuznets@redhat.com>
References: <1414417478-20268-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guard against issuing unsupported REQ_FUA and REQ_FLUSH was introduced
in d11e61583 and was factored out into blkif_request_flush_valid() in
0f1ca65ee. However:
1) This check in incomplete. In case we negotiated to feature_flush = REQ_FLUSH
   and flush_op = BLKIF_OP_FLUSH_DISKCACHE (so FUA is unsupported) FUA request
   will still pass the check.
2) blkif_request_flush_valid() is misnamed. It is bool but returns true when
   the request is invalid.
3) When blkif_request_flush_valid() fails -EIO is being returned. It seems that
   -EOPNOTSUPP is more appropriate here.
Fix all of the above issues.

This patch is based on the original patch by Laszlo Ersek and a comment by
Jeff Moyer.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Laszlo Ersek <lersek@redhat.com>
---
 drivers/block/xen-blkfront.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 5ac312f..2e6c103 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -582,12 +582,14 @@ static inline void flush_requests(struct blkfront_info *info)
 		notify_remote_via_irq(info->irq);
 }
 
-static inline bool blkif_request_flush_valid(struct request *req,
-					     struct blkfront_info *info)
+static inline bool blkif_request_flush_invalid(struct request *req,
+					       struct blkfront_info *info)
 {
 	return ((req->cmd_type != REQ_TYPE_FS) ||
-		((req->cmd_flags & (REQ_FLUSH | REQ_FUA)) &&
-		!info->flush_op));
+		((req->cmd_flags & REQ_FLUSH) &&
+		 !(info->feature_flush & REQ_FLUSH)) ||
+		((req->cmd_flags & REQ_FUA) &&
+		 !(info->feature_flush & REQ_FUA)));
 }
 
 /*
@@ -612,8 +614,8 @@ static void do_blkif_request(struct request_queue *rq)
 
 		blk_start_request(req);
 
-		if (blkif_request_flush_valid(req, info)) {
-			__blk_end_request_all(req, -EIO);
+		if (blkif_request_flush_invalid(req, info)) {
+			__blk_end_request_all(req, -EOPNOTSUPP);
 			continue;
 		}
 
-- 
1.9.3

