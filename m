Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbbA2KBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:01:30 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44767 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758051AbbA2JCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 034/176] genhd: check for int overflow in disk_expand_part_tbl()
Date: Wed, 28 Jan 2015 15:27:44 +0100
Message-Id: <faabc4f5c3b94993ca781a03ead160bf5248c7db.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <axboe@fb.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5fabcb4c33fe11c7e3afdf805fde26c1a54d0953 upstream.

We can get here from blkdev_ioctl() -> blkpg_ioctl() -> add_partition()
with a user passed in partno value. If we pass in 0x7fffffff, the
new target in disk_expand_part_tbl() overflows the 'int' and we
access beyond the end of ptbl->part[] and even write to it when we
do the rcu_assign_pointer() to assign the new partition.

Reported-by: David Ramos <daramos@stanford.edu>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 block/genhd.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e6723bd4d7a1..a8d586a729bb 100644
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
2.2.2

