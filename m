Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbaELB7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:59:55 -0400
Received: from 1wt.eu ([62.212.114.60]:34635 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbaELBmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:49 -0400
Message-Id: <20140512003201.342270010@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 017/143] block: do not pass disk names as format strings
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit ffc8b30866879ed9ba62bd0a86fecdbd51cd3d19 upstream

Disk names may contain arbitrary strings, so they must not be
interpreted as format strings.  It seems that only md allows arbitrary
strings to be used for disk names, but this could allow for a local
memory corruption from uid 0 into ring 0.

CVE-2013-2851

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

[jmm: Backport to 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/block/nbd.c   | 4 +++-
 fs/partitions/check.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 26ada47..90550ba 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -655,7 +655,9 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 
 		mutex_unlock(&lo->tx_lock);
 
-		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+		thread = kthread_create(nbd_thread, lo, "%s",
+					lo->disk->disk_name);
+
 		if (IS_ERR(thread)) {
 			mutex_lock(&lo->tx_lock);
 			return PTR_ERR(thread);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 7b685e1..aa90d88 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -476,7 +476,7 @@ void register_disk(struct gendisk *disk)
 
 	ddev->parent = disk->driverfs_dev;
 
-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
-- 
1.7.12.2.21.g234cd45.dirty



