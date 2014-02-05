Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbaBEVQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:16:49 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47874 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaBEUDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        <dm-devel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 012/213] dm: do not forward ioctls from logical volumes to the underlying device
Date: Wed, 5 Feb 2014 14:59:27 -0500
Message-ID: <1391630568-49251-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit ec8013beddd717d1740cfefb1a9b900deef85462 upstream.

A logical volume can map to just part of underlying physical volume.
In this case, it must be treated like a partition.

Based on a patch from Alasdair G Kergon.

Cc: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[PG: drop drivers/md/dm-flakey.c chunk; file not present in 2.6.34]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/dm-linear.c | 12 +++++++++++-
 drivers/md/dm-mpath.c  |  6 ++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 9200dbf2391a..bf404845aa9d 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -115,7 +115,17 @@ static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
 			unsigned long arg)
 {
 	struct linear_c *lc = (struct linear_c *) ti->private;
-	return __blkdev_driver_ioctl(lc->dev->bdev, lc->dev->mode, cmd, arg);
+	struct dm_dev *dev = lc->dev;
+	int r = 0;
+
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (lc->start ||
+	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
+	return r ? : __blkdev_driver_ioctl(dev->bdev, dev->mode, cmd, arg);
 }
 
 static int linear_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 78090ebaba6c..3c06fdb13868 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1541,6 +1541,12 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
+		r = scsi_verify_blk_ioctl(NULL, cmd);
+
 	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 }
 
-- 
1.8.5.2

