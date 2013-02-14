Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab3BNOU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:20:29 -0500
Received: from relay.parallels.com ([195.214.232.42]:52308 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3BNOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:20:27 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@redhat.com>,
        "Peter Zijlstra" <peterz@infradead.org>
CC: <devel@openvz.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] block: account iowait time when waiting for completion of IO request
Date: Thu, 14 Feb 2013 18:19:59 +0400
Message-ID: <d1fdb105fe23f979871b92c4b4d3dd374146e337.1360851174.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <d5e5c32b045e448072b3a4b77cd6557408b77103.1360851174.git.vdavydov@parallels.com>
References: <d5e5c32b045e448072b3a4b77cd6557408b77103.1360851174.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.22.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using wait_for_completion() for waiting for a IO request to be executed
results in wrong iowait time accounting. For example, a system having
the only task doing write() and fdatasync() on a block device can be
reported being idle instead of iowaiting as it should because
blkdev_issue_flush() calls wait_for_completion() which in turn calls
schedule() that does not increment the iowait proc counter and thus does
not turn on iowait time accounting.

The patch makes block layer use wait_for_completion_io() instead of
wait_for_completion() where appropriate to account iowait time
correctly.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 block/blk-exec.c  |    4 ++--
 block/blk-flush.c |    2 +-
 block/blk-lib.c   |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 74638ec..f634de7 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -120,9 +120,9 @@ int blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 	/* Prevent hang_check timer from firing at us during very long I/O */
 	hang_check = sysctl_hung_task_timeout_secs;
 	if (hang_check)
-		while (!wait_for_completion_timeout(&wait, hang_check * (HZ/2)));
+		while (!wait_for_completion_io_timeout(&wait, hang_check * (HZ/2)));
 	else
-		wait_for_completion(&wait);
+		wait_for_completion_io(&wait);
 
 	if (rq->errors)
 		err = -EIO;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 720ad60..db8f1b5 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -436,7 +436,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 
 	bio_get(bio);
 	submit_bio(WRITE_FLUSH, bio);
-	wait_for_completion(&wait);
+	wait_for_completion_io(&wait);
 
 	/*
 	 * The driver must store the error location in ->bi_sector, if
diff --git a/block/blk-lib.c b/block/blk-lib.c
index b3a1f2b..d6f50d5 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -126,7 +126,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 	/* Wait for bios in-flight */
 	if (!atomic_dec_and_test(&bb.done))
-		wait_for_completion(&wait);
+		wait_for_completion_io(&wait);
 
 	if (!test_bit(BIO_UPTODATE, &bb.flags))
 		ret = -EIO;
@@ -200,7 +200,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 
 	/* Wait for bios in-flight */
 	if (!atomic_dec_and_test(&bb.done))
-		wait_for_completion(&wait);
+		wait_for_completion_io(&wait);
 
 	if (!test_bit(BIO_UPTODATE, &bb.flags))
 		ret = -ENOTSUPP;
@@ -262,7 +262,7 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 
 	/* Wait for bios in-flight */
 	if (!atomic_dec_and_test(&bb.done))
-		wait_for_completion(&wait);
+		wait_for_completion_io(&wait);
 
 	if (!test_bit(BIO_UPTODATE, &bb.flags))
 		/* One of bios in the batch was completed with error.*/
-- 
1.7.1

