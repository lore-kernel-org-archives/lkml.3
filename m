Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaH3QKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:10:12 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59010 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaH3QKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:10:07 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 5/6] block: loop: introduce lo_discard() and lo_req_flush()
Date: Sun, 31 Aug 2014 00:08:26 +0800
Message-Id: <1409414907-22238-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
References: <1409414907-22238-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No behaviour change, just move the handling for REQ_DISCARD
and REQ_FLUSH in these two functions.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/block/loop.c |   73 +++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b1181b0..d7cdb60 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -415,6 +415,40 @@ lo_receive(struct loop_device *lo, struct request *rq, int bsize, loff_t pos)
 	return 0;
 }
 
+static int lo_discard(struct loop_device *lo, struct request *rq, loff_t pos)
+{
+	/*
+	 * We use punch hole to reclaim the free space used by the
+	 * image a.k.a. discard. However we do not support discard if
+	 * encryption is enabled, because it may give an attacker
+	 * useful information.
+	 */
+	struct file *file = lo->lo_backing_file;
+	int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+	int ret;
+
+	if ((!file->f_op->fallocate) || lo->lo_encrypt_key_size) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ret = file->f_op->fallocate(file, mode, pos, blk_rq_bytes(rq));
+	if (unlikely(ret && ret != -EINVAL && ret != -EOPNOTSUPP))
+		ret = -EIO;
+ out:
+	return ret;
+}
+
+static int lo_req_flush(struct loop_device *lo, struct request *rq)
+{
+	struct file *file = lo->lo_backing_file;
+	int ret = vfs_fsync(file, 0);
+	if (unlikely(ret && ret != -EINVAL))
+		ret = -EIO;
+
+	return ret;
+}
+
 static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 {
 	loff_t pos;
@@ -423,46 +457,19 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
 	if (rq->cmd_flags & REQ_WRITE) {
-		struct file *file = lo->lo_backing_file;
-
-		if (rq->cmd_flags & REQ_FLUSH) {
-			ret = vfs_fsync(file, 0);
-			if (unlikely(ret && ret != -EINVAL)) {
-				ret = -EIO;
-				goto out;
-			}
-		}
 
-		/*
-		 * We use punch hole to reclaim the free space used by the
-		 * image a.k.a. discard. However we do not support discard if
-		 * encryption is enabled, because it may give an attacker
-		 * useful information.
-		 */
+		if (rq->cmd_flags & REQ_FLUSH)
+			ret = lo_req_flush(lo, rq);
+
 		if (rq->cmd_flags & REQ_DISCARD) {
-			struct file *file = lo->lo_backing_file;
-			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
-
-			if ((!file->f_op->fallocate) ||
-			    lo->lo_encrypt_key_size) {
-				ret = -EOPNOTSUPP;
-				goto out;
-			}
-			ret = file->f_op->fallocate(file, mode, pos,
-						    blk_rq_bytes(rq));
-			if (unlikely(ret && ret != -EINVAL &&
-				     ret != -EOPNOTSUPP))
-				ret = -EIO;
+			ret = lo_discard(lo, rq, pos);
 			goto out;
 		}
 
 		ret = lo_send(lo, rq, pos);
 
-		if ((rq->cmd_flags & REQ_FUA) && !ret) {
-			ret = vfs_fsync(file, 0);
-			if (unlikely(ret && ret != -EINVAL))
-				ret = -EIO;
-		}
+		if ((rq->cmd_flags & REQ_FUA) && !ret)
+			ret = lo_req_flush(lo, rq);
 	} else
 		ret = lo_receive(lo, rq, lo->lo_blocksize, pos);
 
-- 
1.7.9.5

