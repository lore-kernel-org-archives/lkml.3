Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbbANHqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:46:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbbANHit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:38:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Ramos <daramos@stanford.edu>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.10 29/44] genhd: check for int overflow in disk_expand_part_tbl()
Date: Tue, 13 Jan 2015 23:23:50 -0800
Message-Id: <20150114072229.091840891@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/genhd.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1070,9 +1070,16 @@ int disk_expand_part_tbl(struct gendisk
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


