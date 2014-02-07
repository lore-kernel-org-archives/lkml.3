Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBGSXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:23:24 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35109 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaBGSXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:23:20 -0500
Message-Id: <20140207182319.818443734@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 07 Feb 2014 10:22:37 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/4] blk-mq: divert __blk_put_request for MQ ops
References: <20140207182235.659185141@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-blk-mq-divert-__blk_put_request-for-MQ-ops.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__blk_put_request needs to call into the blk-mq code just like
blk_put_request.  As we don't have the queue lock in this case both
end up calling the same function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index c00e0bd..06636f3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1278,6 +1278,11 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(!q))
 		return;
 
+	if (q->mq_ops) {
+		blk_mq_free_request(req);
+		return;
+	}
+
 	blk_pm_put_request(req);
 
 	elv_completed_request(q, req);
-- 
1.7.10.4


