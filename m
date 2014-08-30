Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaH3QKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:10:04 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41179 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaH3QKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:10:01 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 4/6] block: loop: say goodby to bio
Date: Sun, 31 Aug 2014 00:08:25 +0800
Message-Id: <1409414907-22238-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
References: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to block request completely.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |   46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b02122d..b1181b0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -285,12 +285,12 @@ static int do_lo_send_write(struct loop_device *lo, struct bio_vec *bvec,
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
 
@@ -304,7 +304,7 @@ static int lo_send(struct loop_device *lo, struct bio *bio, loff_t pos)
 		do_lo_send = do_lo_send_direct_write;
 	}
 
-	bio_for_each_segment(bvec, bio, iter) {
+	rq_for_each_segment(bvec, rq, iter) {
 		ret = do_lo_send(lo, &bvec, pos, page);
 		if (ret < 0)
 			break;
@@ -392,19 +392,22 @@ do_lo_receive(struct loop_device *lo,
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
@@ -412,17 +415,17 @@ lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
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
@@ -436,7 +439,7 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
 		 * encryption is enabled, because it may give an attacker
 		 * useful information.
 		 */
-		if (bio->bi_rw & REQ_DISCARD) {
+		if (rq->cmd_flags & REQ_DISCARD) {
 			struct file *file = lo->lo_backing_file;
 			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
 
@@ -446,22 +449,22 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
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
@@ -472,12 +475,6 @@ struct switch_request {
 	struct completion wait;
 };
 
-static inline int loop_handle_bio(struct loop_device *lo, struct bio *bio)
-{
-	int ret = do_bio_filebacked(lo, bio);
-	return ret;
-}
-
 /*
  * Do the actual switch; called from the BIO completion routine
  */
@@ -1557,7 +1554,6 @@ static void loop_queue_work(struct kthread_work *work)
 	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
 	struct loop_device *lo = cmd->hctx_data->lo;
 	int ret = -EIO;
-	struct bio *bio;
 
 	if (lo->lo_state != Lo_bound)
 		goto failed;
@@ -1565,9 +1561,7 @@ static void loop_queue_work(struct kthread_work *work)
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

