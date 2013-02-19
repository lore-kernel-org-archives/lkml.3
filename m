Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3BSQLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:11:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53429 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab3BSQLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:11:42 -0500
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="25800040"
From: Yaniv Gardi <ygardi@codeaurora.org>
To: linux-mmc@vger.kernel.org, vgoyal@redhat.com, tj@kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v9 1/2] block: ioctl support for sanitize in eMMC 4.5
Date: Tue, 19 Feb 2013 18:10:51 +0200
Message-Id: <1361290252-6004-2-git-send-email-ygardi@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1361290252-6004-1-git-send-email-ygardi@codeaurora.org>
References: <1361290252-6004-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a new ioctl to support sanitize operation in eMMC
cards version 4.5.
The sanitize ioctl-support, helps performing this operation
via user application

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 block/blk-core.c          |    8 +++++++
 block/blk-lib.c           |   51 +++++++++++++++++++++++++++++++++++++++++++++
 block/blk-merge.c         |    4 +++
 block/elevator.c          |    6 ++++-
 block/ioctl.c             |    9 ++++++++
 include/linux/blk_types.h |    7 ++++-
 include/linux/blkdev.h    |    6 +++++
 include/uapi/linux/fs.h   |    1 +
 kernel/trace/blktrace.c   |    2 +
 9 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c973249..275922f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1740,6 +1740,14 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	if ((bio->bi_rw & REQ_SANITIZE) &&
+	    (!blk_queue_sanitize(q))) {
+		pr_info("%s - Queue doesn't support sanitize requests",
+			__func__);
+		err = -EOPNOTSUPP;
+		goto end_io;
+	}
+
 	if (bio->bi_rw & REQ_WRITE_SAME && !bdev_write_same(bio->bi_bdev)) {
 		err = -EOPNOTSUPP;
 		goto end_io;
diff --git a/block/blk-lib.c b/block/blk-lib.c
index b3a1f2b7..f355878 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -136,6 +136,57 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 EXPORT_SYMBOL(blkdev_issue_discard);
 
 /**
+ * blkdev_issue_sanitize - queue a sanitize request
+ * @bdev:	blockdev to issue sanitize for
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Issue a sanitize request for the specified block device
+ */
+int blkdev_issue_sanitize(struct block_device *bdev, gfp_t gfp_mask)
+{
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request_queue *q = bdev_get_queue(bdev);
+	int type = REQ_WRITE | REQ_SANITIZE;
+	struct bio_batch bb;
+	struct bio *bio;
+	int ret = 0;
+
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_sanitize(q)) {
+		pr_err("%s - card doesn't support sanitize", __func__);
+		return -EOPNOTSUPP;
+	}
+
+	bio = bio_alloc(gfp_mask, 1);
+	if (!bio)
+		return -ENOMEM;
+
+	atomic_set(&bb.done, 1);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+
+	bio->bi_end_io = bio_batch_end_io;
+	bio->bi_bdev = bdev;
+	bio->bi_private = &bb;
+
+	atomic_inc(&bb.done);
+	submit_bio(type, bio);
+
+	/* Wait for bios in-flight */
+	if (!atomic_dec_and_test(&bb.done))
+		wait_for_completion(&wait);
+
+	if (!test_bit(BIO_UPTODATE, &bb.flags))
+		ret = -EIO;
+
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_sanitize);
+
+/**
  * blkdev_issue_write_same - queue a write same operation
  * @bdev:	target blockdev
  * @sector:	start sector
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 936a110..fe87097 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -507,6 +507,10 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!rq_mergeable(rq) || !bio_mergeable(bio))
 		return false;
 
+	/* don't merge file system requests and sanitize requests */
+	if ((bio->bi_rw & REQ_SANITIZE) != (rq->bio->bi_rw & REQ_SANITIZE))
+		return false;
+
 	if (!blk_check_merge_flags(rq->cmd_flags, bio->bi_rw))
 		return false;
 
diff --git a/block/elevator.c b/block/elevator.c
index 9edba1b..a0eafb3 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -364,6 +364,9 @@ void elv_dispatch_sort(struct request_queue *q, struct request *rq)
 		if ((rq->cmd_flags & REQ_DISCARD) !=
 		    (pos->cmd_flags & REQ_DISCARD))
 			break;
+		if ((rq->cmd_flags & REQ_SANITIZE) !=
+		    (pos->cmd_flags & REQ_SANITIZE))
+			break;
 		if (rq_data_dir(rq) != rq_data_dir(pos))
 			break;
 		if (pos->cmd_flags & stop_flags)
@@ -570,7 +573,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
-		if (rq->cmd_type == REQ_TYPE_FS) {
+		if ((rq->cmd_type == REQ_TYPE_FS) ||
+		    (rq->cmd_flags & REQ_SANITIZE)) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..0dcadf9 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -185,6 +185,11 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 	return blkdev_issue_discard(bdev, start, len, GFP_KERNEL, flags);
 }
 
+static int blk_ioctl_sanitize(struct block_device *bdev)
+{
+	return blkdev_issue_sanitize(bdev, GFP_KERNEL);
+}
+
 static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
 			     uint64_t len)
 {
@@ -303,6 +308,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		set_device_ro(bdev, n);
 		return 0;
 
+	case BLKSANITIZE:
+		ret = blk_ioctl_sanitize(bdev);
+		break;
+
 	case BLKDISCARD:
 	case BLKSECDISCARD: {
 		uint64_t range[2];
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index cdf1119..815562c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -175,6 +175,7 @@ enum rq_flag_bits {
 	__REQ_IO_STAT,		/* account I/O stat */
 	__REQ_MIXED_MERGE,	/* merge of different types, fail separately */
 	__REQ_KERNEL, 		/* direct IO to kernel pages */
+	__REQ_SANITIZE,		/* sanitize */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -187,6 +188,7 @@ enum rq_flag_bits {
 #define REQ_PRIO		(1 << __REQ_PRIO)
 #define REQ_DISCARD		(1 << __REQ_DISCARD)
 #define REQ_WRITE_SAME		(1 << __REQ_WRITE_SAME)
+#define REQ_SANITIZE		(1 << __REQ_SANITIZE)
 #define REQ_NOIDLE		(1 << __REQ_NOIDLE)
 
 #define REQ_FAILFAST_MASK \
@@ -194,12 +196,13 @@ enum rq_flag_bits {
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
 	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
-	 REQ_SECURE)
+	 REQ_SECURE | REQ_SANITIZE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 /* This mask is used for both bio and request merge checking */
 #define REQ_NOMERGE_FLAGS \
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | \
+	 REQ_SANITIZE)
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1 << __REQ_THROTTLED)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94bc83..6992cf4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -459,6 +459,7 @@ struct request_queue {
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
 #define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
+#define QUEUE_FLAG_SANITIZE    20	/* supports SANITIZE */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -540,6 +541,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
+#define blk_queue_sanitize(q)	test_bit(QUEUE_FLAG_SANITIZE, &(q)->queue_flags)
 #define blk_queue_secdiscard(q)	(blk_queue_discard(q) && \
 	test_bit(QUEUE_FLAG_SECDISCARD, &(q)->queue_flags))
 
@@ -620,6 +622,9 @@ static inline bool blk_check_merge_flags(unsigned int flags1,
 	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
 		return false;
 
+	if ((flags1 & REQ_SANITIZE) != (flags2 & REQ_SANITIZE))
+		return false;
+
 	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
 		return false;
 
@@ -1041,6 +1046,7 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
+extern int blkdev_issue_sanitize(struct block_device *bdev, gfp_t gfp_mask);
 extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 780d4c6..de543ea 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -144,6 +144,7 @@ struct inodes_stat_t {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+#define BLKSANITIZE _IO(0x12, 128)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index c0bd030..06f7940 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1788,6 +1788,8 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 		rwbs[i++] = 'W';
 	else if (rw & REQ_DISCARD)
 		rwbs[i++] = 'D';
+	else if (rw & REQ_SANITIZE)
+		rwbs[i++] = 'Z';
 	else if (bytes)
 		rwbs[i++] = 'R';
 	else
-- 
1.7.6
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum
