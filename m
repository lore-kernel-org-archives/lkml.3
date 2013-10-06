Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3JFPYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 11:24:14 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab3JFPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 11:24:11 -0400
Message-Id: <20131006152410.331665910@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Sun, 06 Oct 2013 08:22:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] blk-mq: more careful bio completion
References: <20131006152237.612666544@bombadil.infradead.org>
Content-Disposition: inline; filename=0001-blk-mq-more-careful-bio-completion.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we set bio errors correctly and don't complete bios midway
through a flush sequence.  Largely copied from the old I/O path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index dece2e2..d2e568e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -269,6 +269,21 @@ void blk_mq_free_request(struct request *rq)
 	__blk_mq_free_request(hctx, ctx, rq);
 }
 
+static void blk_mq_bio_endio(struct request *rq, struct bio *bio, int error)
+{
+	if (error)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		error = -EIO;
+
+	if (unlikely(rq->cmd_flags & REQ_QUIET))
+		set_bit(BIO_QUIET, &bio->bi_flags);
+
+	/* don't actually finish bio if it's part of flush sequence */
+	if (!(rq->cmd_flags & REQ_FLUSH_SEQ))
+		bio_endio(bio, error);
+}
+
 void blk_mq_finish_request(struct request *rq, int error)
 {
 	struct bio *bio = rq->bio;
@@ -279,7 +294,7 @@ void blk_mq_finish_request(struct request *rq, int error)
 
 		bio->bi_next = NULL;
 		bytes += bio->bi_size;
-		bio_endio(bio, error);
+		blk_mq_bio_endio(rq, bio, error);
 		bio = next;
 	}
 
-- 
1.7.10.4


