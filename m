Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab3GQWva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:51:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56336 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3GQWv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:51:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 129/145] dm mpath: fix ioctl deadlock when no paths
Date: Wed, 17 Jul 2013 15:47:41 -0700
Message-Id: <1374101277-7915-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 6c182cd88d179cbbd06f4f8a8a19b6977940753f upstream.

When multipath needs to retry an ioctl the reference to the
current live table needs to be dropped. Otherwise a deadlock
occurs when all paths are down:
- dm_blk_ioctl takes a reference to the current table
  and spins in multipath_ioctl().
- A new table is being loaded, but upon resume the process
  hangs in dm_table_destroy() waiting for references to
  drop to zero.

With this patch the reference to the old table is dropped
prior to retry, thereby avoiding the deadlock.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-mpath.c | 8 ++------
 drivers/md/dm.c       | 9 ++++++++-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d267bb5..9f330c1 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1560,7 +1560,6 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	unsigned long flags;
 	int r;
 
-again:
 	bdev = NULL;
 	mode = 0;
 	r = 0;
@@ -1578,7 +1577,7 @@ again:
 	}
 
 	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
-		r = -EAGAIN;
+		r = -ENOTCONN;
 	else if (!bdev)
 		r = -EIO;
 
@@ -1590,11 +1589,8 @@ again:
 	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
 		r = scsi_verify_blk_ioctl(NULL, cmd);
 
-	if (r == -EAGAIN && !fatal_signal_pending(current)) {
+	if (r == -ENOTCONN && !fatal_signal_pending(current))
 		queue_work(kmultipathd, &m->process_queued_ios);
-		msleep(10);
-		goto again;
-	}
 
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0d8f086..6a82721 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -404,10 +404,12 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
-	struct dm_table *map = dm_get_live_table(md);
+	struct dm_table *map;
 	struct dm_target *tgt;
 	int r = -ENOTTY;
 
+retry:
+	map = dm_get_live_table(md);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
@@ -428,6 +430,11 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 out:
 	dm_table_put(map);
 
+	if (r == -ENOTCONN) {
+		msleep(10);
+		goto retry;
+	}
+
 	return r;
 }
 
-- 
1.8.1.2

