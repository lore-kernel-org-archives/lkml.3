Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaHNPwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:52:37 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33347 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbaHNPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:52:35 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 6/9] block: loop: say goodby to bio
Date: Thu, 14 Aug 2014 23:50:37 +0800
Message-Id: <1408031441-31156-7-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to block request completely.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |   46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1af5265..ad43d4b 100644
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
@@ -474,12 +477,6 @@ struct switch_request {
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
@@ -1507,7 +1504,6 @@ static void loop_queue_work(struct work_struct *work)
 	const bool write = cmd->rq->cmd_flags & REQ_WRITE;
 	struct loop_device *lo = cmd->lo;
 	int ret = -EIO;
-	struct bio *bio;
 
 	if (lo->lo_state != Lo_bound)
 		goto failed;
@@ -1515,9 +1511,7 @@ static void loop_queue_work(struct work_struct *work)
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

