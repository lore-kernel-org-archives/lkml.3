Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab3BTA3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 19:29:08 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:63343 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934924Ab3BTAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 19:22:53 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk
Subject: [PATCH 06/27] block: Refactor blk_update_request()
Date: Tue, 19 Feb 2013 16:22:20 -0800
Message-Id: <1361319761-23873-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361319761-23873-1-git-send-email-koverstreet@google.com>
References: <1361319761-23873-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converts it to use bio_advance(), simplifying it quite a bit in the
process.

Note that req_bio_endio() now always calls bio_advance() - which means
it always loops over the biovec, not just on partial completions. Don't
expect it to affect performance, but worth noting.

Tested it by forcing partial updates, and dumping before and after on
various bio/bvec fields when doing a partial update.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c | 80 +++++++++-----------------------------------------------
 1 file changed, 12 insertions(+), 68 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 66d3168..8f9f19b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -158,20 +158,10 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
-	if (unlikely(nbytes > bio->bi_size)) {
-		printk(KERN_ERR "%s: want %u bytes done, %u left\n",
-		       __func__, nbytes, bio->bi_size);
-		nbytes = bio->bi_size;
-	}
-
 	if (unlikely(rq->cmd_flags & REQ_QUIET))
 		set_bit(BIO_QUIET, &bio->bi_flags);
 
-	bio->bi_size -= nbytes;
-	bio->bi_sector += (nbytes >> 9);
-
-	if (bio_integrity(bio))
-		bio_integrity_advance(bio, nbytes);
+	bio_advance(bio, nbytes);
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
@@ -2250,8 +2240,7 @@ EXPORT_SYMBOL(blk_fetch_request);
  **/
 bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 {
-	int total_bytes, bio_nbytes, next_idx = 0;
-	struct bio *bio;
+	int total_bytes;
 
 	if (!req->bio)
 		return false;
@@ -2297,56 +2286,21 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 
 	blk_account_io_completion(req, nr_bytes);
 
-	total_bytes = bio_nbytes = 0;
-	while ((bio = req->bio) != NULL) {
-		int nbytes;
+	total_bytes = 0;
+	while (req->bio) {
+		struct bio *bio = req->bio;
+		unsigned bio_bytes = min(bio->bi_size, nr_bytes);
 
-		if (nr_bytes >= bio->bi_size) {
+		if (bio_bytes == bio->bi_size)
 			req->bio = bio->bi_next;
-			nbytes = bio->bi_size;
-			req_bio_endio(req, bio, nbytes, error);
-			next_idx = 0;
-			bio_nbytes = 0;
-		} else {
-			int idx = bio->bi_idx + next_idx;
-
-			if (unlikely(idx >= bio->bi_vcnt)) {
-				blk_dump_rq_flags(req, "__end_that");
-				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
-				       __func__, idx, bio->bi_vcnt);
-				break;
-			}
-
-			nbytes = bio_iovec_idx(bio, idx)->bv_len;
-			BIO_BUG_ON(nbytes > bio->bi_size);
-
-			/*
-			 * not a complete bvec done
-			 */
-			if (unlikely(nbytes > nr_bytes)) {
-				bio_nbytes += nr_bytes;
-				total_bytes += nr_bytes;
-				break;
-			}
 
-			/*
-			 * advance to the next vector
-			 */
-			next_idx++;
-			bio_nbytes += nbytes;
-		}
+		req_bio_endio(req, bio, bio_bytes, error);
 
-		total_bytes += nbytes;
-		nr_bytes -= nbytes;
+		total_bytes += bio_bytes;
+		nr_bytes -= bio_bytes;
 
-		bio = req->bio;
-		if (bio) {
-			/*
-			 * end more in this run, or just return 'not-done'
-			 */
-			if (unlikely(nr_bytes <= 0))
-				break;
-		}
+		if (!nr_bytes)
+			break;
 	}
 
 	/*
@@ -2362,16 +2316,6 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		return false;
 	}
 
-	/*
-	 * if the request wasn't completed, update state
-	 */
-	if (bio_nbytes) {
-		req_bio_endio(req, bio, bio_nbytes, error);
-		bio->bi_idx += next_idx;
-		bio_iovec(bio)->bv_offset += nr_bytes;
-		bio_iovec(bio)->bv_len -= nr_bytes;
-	}
-
 	req->__data_len -= total_bytes;
 	req->buffer = bio_data(req->bio);
 
-- 
1.7.12

