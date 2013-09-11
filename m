Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3IKFXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:23:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3IKE51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:27 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=MzowhjiMplMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=7QzOEiTD6F4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=0kPLrQdw3YYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042910.068292959@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [107/251] dm mpath: fix ioctl deadlock when no paths
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0107-dm-mpath-fix-ioctl-deadlock-when-no-paths.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 6c182cd88d179cbbd06f4f8a8a19b6977940753f ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/dm-mpath.c |    8 ++------
 drivers/md/dm.c       |    9 ++++++++-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 034233e..4fc70c8 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1561,7 +1561,6 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 	unsigned long flags;
 	int r;
 
-again:
 	bdev = NULL;
 	mode = 0;
 	r = 0;
@@ -1579,7 +1578,7 @@ again:
 	}
 
 	if ((pgpath && m->queue_io) || (!pgpath && m->queue_if_no_path))
-		r = -EAGAIN;
+		r = -ENOTCONN;
 	else if (!bdev)
 		r = -EIO;
 
@@ -1591,11 +1590,8 @@ again:
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
index 4256200..dd0a1a8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -414,10 +414,12 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
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
 
@@ -438,6 +440,11 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
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
1.7.10.4


