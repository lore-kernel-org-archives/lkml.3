Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaFIGHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 02:07:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32474 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaFIGHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 02:07:50 -0400
From: Junxiao Bi <junxiao.bi@oracle.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: make nr_requests tunable for loop
Date: Mon,  9 Jun 2014 14:07:35 +0800
Message-Id: <1402294055-910-1-git-send-email-junxiao.bi@oracle.com>
X-Mailer: git-send-email 1.7.9.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7b5a3522 (loop: Limit the number of requests in the bio list) limit
the request number in loop queue to not over 128. Make the number tunable
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
 block/blk-sysfs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 7500f87..193ad8a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -52,9 +52,6 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	unsigned long nr;
 	int ret;
 
-	if (!q->request_fn)
-		return -EINVAL;
-
 	ret = queue_var_store(&nr, page, count);
 	if (ret < 0)
 		return ret;
@@ -66,6 +63,11 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	q->nr_requests = nr;
 	blk_queue_congestion_threshold(q);
 
+	if (!q->request_fn) {
+		spin_unlock_irq(q->queue_lock);
+		return ret;
+	}
+
 	/* congestion isn't cgroup aware and follows root blkcg for now */
 	rl = &q->root_rl;
 
-- 
1.7.9.5

