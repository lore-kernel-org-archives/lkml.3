Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3CDELH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:11:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60965 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755895Ab3CDDnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:06 -0500
Message-Id: <20130304033718.994259747@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Paolo Bonzini <pbonzini@redhat.com>,
        Paul Clements <Paul.Clements@steeleye.com>,
        Alex Bligh <alex@alex.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 116/153] nbd: fsync and kill block device on shutdown
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 3a2d63f87989e01437ba994df5f297528c353d7d upstream.

There are two problems with shutdown in the NBD driver.

1: Receiving the NBD_DISCONNECT ioctl does not sync the filesystem.

   This patch adds the sync operation into __nbd_ioctl()'s
   NBD_DISCONNECT handler.  This is useful because BLKFLSBUF is restricted
   to processes that have CAP_SYS_ADMIN, and the NBD client may not
   possess it (fsync of the block device does not sync the filesystem,
   either).

2: Once we clear the socket we have no guarantee that later reads will
   come from the same backing storage.

   The patch adds calls to kill_bdev() in __nbd_ioctl()'s socket
   clearing code so the page cache is cleaned, lest reads that hit on the
   page cache will return stale data from the previously-accessible disk.

Example:

    # qemu-nbd -r -c/dev/nbd0 /dev/sr0
    # file -s /dev/nbd0
    /dev/stdin: # UDF filesystem data (version 1.5) etc.
    # qemu-nbd -d /dev/nbd0
    # qemu-nbd -r -c/dev/nbd0 /dev/sda
    # file -s /dev/nbd0
    /dev/stdin: # UDF filesystem data (version 1.5) etc.

While /dev/sda has:

    # file -s /dev/sda
    /dev/sda: x86 boot sector; etc.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Paul Clements <Paul.Clements@steeleye.com>
Cc: Alex Bligh <alex@alex.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2:
 - Adjusted context
 - s/\bnbd\b/lo/
 - Incorporate export of kill_bdev() from commit ff01bb483265
   ('fs: move code out of buffer.c')]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -584,12 +584,20 @@ static int __nbd_ioctl(struct block_devi
 		struct request sreq;
 
 		dev_info(disk_to_dev(lo->disk), "NBD_DISCONNECT\n");
+		if (!lo->sock)
+			return -EINVAL;
 
+		mutex_unlock(&lo->tx_lock);
+		fsync_bdev(bdev);
+		mutex_lock(&lo->tx_lock);
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
+
+		/* Check again after getting mutex back.  */
 		if (!lo->sock)
 			return -EINVAL;
+
 		nbd_send_req(lo, &sreq);
                 return 0;
 	}
@@ -603,6 +611,7 @@ static int __nbd_ioctl(struct block_devi
 		nbd_clear_que(lo);
 		BUG_ON(!list_empty(&lo->queue_head));
 		BUG_ON(!list_empty(&lo->waiting_queue));
+		kill_bdev(bdev);
 		if (file)
 			fput(file);
 		return 0;
@@ -683,6 +692,7 @@ static int __nbd_ioctl(struct block_devi
 		lo->file = NULL;
 		nbd_clear_que(lo);
 		dev_warn(disk_to_dev(lo->disk), "queue cleared\n");
+		kill_bdev(bdev);
 		if (file)
 			fput(file);
 		lo->bytesize = 0;
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -82,13 +82,14 @@ sector_t blkdev_max_block(struct block_d
 }
 
 /* Kill _all_ buffers and pagecache , dirty or not.. */
-static void kill_bdev(struct block_device *bdev)
+void kill_bdev(struct block_device *bdev)
 {
 	if (bdev->bd_inode->i_mapping->nrpages == 0)
 		return;
 	invalidate_bh_lrus();
 	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
 }	
+EXPORT_SYMBOL(kill_bdev);
 
 int set_blocksize(struct block_device *bdev, int size)
 {
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2103,6 +2103,7 @@ extern void bd_forget(struct inode *inod
 extern void bdput(struct block_device *);
 extern void invalidate_bdev(struct block_device *);
 extern int sync_blockdev(struct block_device *bdev);
+extern void kill_bdev(struct block_device *);
 extern struct super_block *freeze_bdev(struct block_device *);
 extern void emergency_thaw_all(void);
 extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
@@ -2110,6 +2111,7 @@ extern int fsync_bdev(struct block_devic
 #else
 static inline void bd_forget(struct inode *inode) {}
 static inline int sync_blockdev(struct block_device *bdev) { return 0; }
+static inline void kill_bdev(struct block_device *bdev) {}
 static inline void invalidate_bdev(struct block_device *bdev) {}
 
 static inline struct super_block *freeze_bdev(struct block_device *sb)


