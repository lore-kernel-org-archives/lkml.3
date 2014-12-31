Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaLaNXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 08:23:53 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:40717 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaLaNXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 08:23:15 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v3 3/5] block: loop: say goodby to bio
Date: Wed, 31 Dec 2014 13:22:58 +0000
Message-Id: <1420032180-30256-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
References: <1420032180-30256-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to block request completely.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |   45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c678eb2..d958901 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -287,12 +287,12 @@ static int do_lo_send_write(struct loop_device *lo, struct bio_vec *bvec,
 	return ret;
 }
 
-static int lo_send(struct loop_device *lo, struct bio *bio, loff_t pos)
+static int lo_send(struct loop_device *lo, struct request *rq, loff_t pos)
 {
 	int (*do_lo_send)(struct loop_device *, struct bio_vec *, loff_t,
 			struct page *page);
 	struct bio_vec bvec;
-	struct bvec_iter iter;
+	struct req_iterator iter;
 	struct page *page = NULL;
 	int ret = 0;
 
@@ -306,7 +306,7 @@ static int lo_send(struct loop_device *lo, struct bio *bio, loff_t pos)
 		do_lo_send = do_lo_send_direct_write;
 	}
 
-	bio_for_each_segment(bvec, bio, iter) {
+	rq_for_each_segment(bvec, rq, iter) {
 		ret = do_lo_send(lo, &bvec, pos, page);
 		if (ret < 0)
 			break;
@@ -394,19 +394,22 @@ do_lo_receive(struct loop_device *lo,
 }
 
 static int
-lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
+lo_receive(struct loop_device *lo, struct request *rq, int bsize, loff_t pos)
 {
 	struct bio_vec bvec;
-	struct bvec_iter iter;
+	struct req_iterator iter;
 	ssize_t s;
 
-	bio_for_each_segment(bvec, bio, iter) {
+	rq_for_each_segment(bvec, rq, iter) {
 		s = do_lo_receive(lo, &bvec, bsize, pos);
 		if (s < 0)
 			return s;
 
 		if (s != bvec.bv_len) {
-			zero_fill_bio(bio);
+			struct bio *bio;
+
+			__rq_for_each_bio(bio, rq)
+				zero_fill_bio(bio);
 			break;
 		}
 		pos += bvec.bv_len;
@@ -414,17 +417,17 @@ lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
 	return 0;
 }
 
-static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
+static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 {
 	loff_t pos;
 	int ret;
 
-	pos = ((loff_t) bio->bi_iter.bi_sector << 9) + lo->lo_offset;
+	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
-	if (bio_rw(bio) == WRITE) {
+	if (rq->cmd_flags & REQ_WRITE) {
 		struct file *file = lo->lo_backing_file;
 
-		if (bio->bi_rw & REQ_FLUSH) {
+		if (rq->cmd_flags & REQ_FLUSH) {
 			ret = vfs_fsync(file, 0);
 			if (unlikely(ret && ret != -EINVAL)) {
 				ret = -EIO;
@@ -438,7 +441,7 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 		 * encryption is enabled, because it may give an attacker
 		 * useful information.
 		 */
-		if (bio->bi_rw & REQ_DISCARD) {
+		if (rq->cmd_flags & REQ_DISCARD) {
 			struct file *file = lo->lo_backing_file;
 			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 
@@ -448,22 +451,22 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 				goto out;
 			}
 			ret = file->f_op->fallocate(file, mode, pos,
-						    bio->bi_iter.bi_size);
+						    blk_rq_bytes(rq));
 			if (unlikely(ret && ret != -EINVAL &&
 				     ret != -EOPNOTSUPP))
 				ret = -EIO;
 			goto out;
 		}
 
-		ret = lo_send(lo, bio, pos);
+		ret = lo_send(lo, rq, pos);
 
-		if ((bio->bi_rw & REQ_FUA) && !ret) {
+		if ((rq->cmd_flags & REQ_FUA) && !ret) {
 			ret = vfs_fsync(file, 0);
 			if (unlikely(ret && ret != -EINVAL))
 				ret = -EIO;
 		}
 	} else
-		ret = lo_receive(lo, bio, lo->lo_blocksize, pos);
+		ret = lo_receive(lo, rq, lo->lo_blocksize, pos);
 
 out:
 	return ret;
@@ -474,11 +477,6 @@ struct switch_request {
 	struct completion wait;
 };
 
-static inline int loop_handle_bio(struct loop_device *lo, struct bio *bio)
-{
-	return do_bio_filebacked(lo, bio);
-}
-
 /*
  * Do the actual switch; called from the BIO completion routine
  */
@@ -1510,7 +1508,6 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
 	struct loop_device *lo = cmd->rq->q->queuedata;
 	int ret = -EIO;
-	struct bio *bio;
 
 	if (lo->lo_state != Lo_bound)
 		goto failed;
@@ -1518,9 +1515,7 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY))
 		goto failed;
 
-	ret = 0;
-	__rq_for_each_bio(bio, cmd->rq)
-		ret |= loop_handle_bio(lo, bio);
+	ret = do_req_filebacked(lo, cmd->rq);
 
  failed:
 	if (ret)
-- 
1.7.9.5

