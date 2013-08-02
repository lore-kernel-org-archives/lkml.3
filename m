Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3HBKmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:42:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030375Ab3HBKLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 63/99] dm mpath: fix ioctl deadlock when no paths
Date: Fri,  2 Aug 2013 18:08:16 +0800
Message-Id: <20130802100234.817702880@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |    8 ++------
 drivers/md/dm.c       |    9 ++++++++-
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1561,7 +1561,6 @@ static int multipath_ioctl(struct dm_tar
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
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -386,10 +386,12 @@ static int dm_blk_ioctl(struct block_dev
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
 
@@ -410,6 +412,11 @@ static int dm_blk_ioctl(struct block_dev
 out:
 	dm_table_put(map);
 
+	if (r == -ENOTCONN) {
+		msleep(10);
+		goto retry;
+	}
+
 	return r;
 }
 


