Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab3C2QIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:08:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab3C2QIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:08:43 -0400
Date: Fri, 29 Mar 2013 12:08:34 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: "Alasdair G. Kergon" <agk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Mike Snitzer <msnitzer@redhat.com>,
        Christoph Hellwig <chellwig@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Track block device users that created dirty pages
Message-ID: <Pine.LNX.4.64.1303291042100.23238@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here I'm sending a patch to change block device buffer flush semantics: 
only processes that created some dirty data do buffer flush on close.

Mikulas

---

Track block device users that created dirty pages

This patch changes the block device driver to use the field
"private_data" to track "file" structures that created some dirty data
in the pagecache. When such "file" structure is closed, we flush block
device cache.

This changes previously defined flush semantics.

Previously, the block device cache was flushed when the last user closed
the block device. That has various problems:
* because system tools and daemons (for example udev or lvm) can open
  any block device anytime, this semantics doesn't guarantee that flush
  happens. For example, if the user runs "dd" to copy some data to the
  partition, then udev opens the device and then "dd" finishes copying
  and closes the device, data is not flushed when "dd" exits (because
  udev still keeps the device open).
* if the last user that closes the device ends up being "lvm" process,
  it can introduce deadlocks. "lvm" would than have to flush some dirty
  data created by some other process. If writeback of these dirty data
  waits for some other operation to be performed by "lvm", we get a
  deadlock.

The new semantics is: if a process did some buffered writes to the block
device (with write or mmap), the cache is flushed when the process
closes the block device. Processes that didn't do any buffered writes to
the device don't cause cache flush. It has these advantages:
* processes that don't do buffered writes (such as "lvm") don't flush
  other process's data.
* if the user runs "dd" on a block device, it is actually guaranteed
  that the data is flushed when "dd" exits.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/block_dev.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-3.9-rc4-fast/fs/block_dev.c
===================================================================
--- linux-3.9-rc4-fast.orig/fs/block_dev.c	2013-03-26 01:59:13.000000000 +0100
+++ linux-3.9-rc4-fast/fs/block_dev.c	2013-03-28 20:58:05.000000000 +0100
@@ -295,10 +295,22 @@ static int blkdev_readpage(struct file *
 	return block_read_full_page(page, blkdev_get_block);
 }
 
+static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == (VM_WRITE | VM_SHARED)) {
+		if (!file->private_data)
+			file->private_data = (void *)1;
+	}
+	return generic_file_mmap(file, vma);
+}
+
 static int blkdev_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
+	if (unlikely(!file->private_data))
+		file->private_data = (void *)1;
+
 	return block_write_begin(mapping, pos, len, flags, pagep,
 				 blkdev_get_block);
 }
@@ -1413,7 +1425,6 @@ static int __blkdev_put(struct block_dev
 
 	if (!--bdev->bd_openers) {
 		WARN_ON_ONCE(bdev->bd_holders);
-		sync_blockdev(bdev);
 		kill_bdev(bdev);
 		/* ->release can cause the old bdi to disappear,
 		 * so must switch it out first
@@ -1497,6 +1508,9 @@ static int blkdev_close(struct inode * i
 {
 	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
 
+	if (unlikely(filp->private_data))
+		sync_blockdev(bdev);
+
 	return blkdev_put(bdev, filp->f_mode);
 }
 
@@ -1595,7 +1609,7 @@ const struct file_operations def_blk_fop
 	.write		= do_sync_write,
 	.aio_read	= blkdev_aio_read,
 	.aio_write	= blkdev_aio_write,
-	.mmap		= generic_file_mmap,
+	.mmap		= blkdev_mmap,
 	.fsync		= blkdev_fsync,
 	.unlocked_ioctl	= block_ioctl,
 #ifdef CONFIG_COMPAT
