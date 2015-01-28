Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbbA2DV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:21:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930AbbA2Cft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:35:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@fb.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 037/139] genhd: check for int overflow in disk_expand_part_tbl()
Date: Wed, 28 Jan 2015 14:19:40 -0800
Message-Id: <1422483682-15393-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit 5fabcb4c33fe11c7e3afdf805fde26c1a54d0953 upstream.

We can get here from blkdev_ioctl() -> blkpg_ioctl() -> add_partition()
with a user passed in partno value. If we pass in 0x7fffffff, the
new target in disk_expand_part_tbl() overflows the 'int' and we
access beyond the end of ptbl->part[] and even write to it when we
do the rcu_assign_pointer() to assign the new partition.

Reported-by: David Ramos <daramos@stanford.edu>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 block/genhd.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e6723bd..a8d586a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1070,9 +1070,16 @@ int disk_expand_part_tbl(struct gendisk *disk, int partno)
 	struct disk_part_tbl *old_ptbl = disk->part_tbl;
 	struct disk_part_tbl *new_ptbl;
 	int len = old_ptbl ? old_ptbl->len : 0;
-	int target = partno + 1;
+	int i, target;
 	size_t size;
-	int i;
+
+	/*
+	 * check for int overflow, since we can get here from blkpg_ioctl()
+	 * with a user passed 'partno'.
+	 */
+	target = partno + 1;
+	if (target < 0)
+		return -EINVAL;
 
 	/* disk_max_parts() is zero during initialization, ignore if so */
 	if (disk_max_parts(disk) && target > disk_max_parts(disk))
-- 
1.9.1

