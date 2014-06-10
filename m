Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325AbaFJCa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 22:30:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31718 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbaFJCa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 22:30:26 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: axboe@kernel.dk
Cc: andi@lisas.de, linux-kernel@vger.kernel.org
Subject: [PATCH V2] block: make nr_requests tunable for loop
Date: Tue, 10 Jun 2014 10:31:00 +0800
Message-Id: <1402367460-5305-1-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7b5a3522 (loop: Limit the number of requests in the bio list) limit
the request number in loop queue to not over 128. Since the "request_fn" of
loop device is null, the requests number is not allowed tuned. Make it tunable
from sysfs can improve performance.

The following test is done on a machine with 512M memory. The backend of
/dev/loop1 is a nfs file.

[root@bijx mnt]# cat /sys/block/loop0/queue/nr_requests
128
[root@bijx mnt]# dd if=/dev/zero of=/dev/loop0 bs=1M count=5000
5000+0 records in
5000+0 records out
5242880000 bytes (5.2 GB) copied, 501.572 s, 10.5 MB/s
[root@bijx mnt]#
[root@bijx mnt]# echo 1024 > /sys/block/loop0/queue/nr_requests
[root@bijx mnt]# cat /sys/block/loop0/queue/nr_requests
1024
[root@bijx mnt]# dd if=/dev/zero of=/dev/loop0 bs=1M count=5000
5000+0 records in
5000+0 records out
5242880000 bytes (5.2 GB) copied, 464.481 s, 11.3 MB/s

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 block/blk-core.c  |    6 ++++++
 block/blk-sysfs.c |    9 +++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 40d6548..58c4bd4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -851,6 +851,12 @@ int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
 	q->nr_requests = nr;
 	blk_queue_congestion_threshold(q);
 
+	/* for loop device, return after set its nr_requests */
+	if (!q->request_fn) {
+		spin_unlock_irq(q->queue_lock);
+		return 0;
+	}
+
 	/* congestion isn't cgroup aware and follows root blkcg for now */
 	rl = &q->root_rl;
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 23321fb..c5456a5 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -51,9 +51,6 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	unsigned long nr;
 	int ret, err;
 
-	if (!q->request_fn && !q->mq_ops)
-		return -EINVAL;
-
 	ret = queue_var_store(&nr, page, count);
 	if (ret < 0)
 		return ret;
@@ -61,10 +58,10 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
-	if (q->request_fn)
-		err = blk_update_nr_requests(q, nr);
-	else
+	if (q->mq_ops)
 		err = blk_mq_update_nr_requests(q, nr);
+	else
+		err = blk_update_nr_requests(q, nr);
 
 	if (err)
 		return err;
-- 
1.7.9.5

