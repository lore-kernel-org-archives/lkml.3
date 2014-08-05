Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaHEOjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:39:06 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39852 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaHEOjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:39:02 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] block_dev: implement readpages() to optimize sequential read
Date: Tue,  5 Aug 2014 23:38:34 +0900
Message-Id: <1407249514-20465-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
References: <1407249514-20465-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sequential read from a block device is expected to be equal or faster
than from the file on a filesystem.  But it is not correct due to the
lack of effective readpages() in the address space operations for
block device.

This implements readpages() operation for block device by using
mpage_readpages() which can create multipage BIOs instead of BIOs for
each page and reduce system CPU time consumption.

Install 1GB of RAM disk storage:

	# modprobe scsi_debug dev_size_mb=1024 delay=0

Sequential read from file on a filesystem:

	# mkfs.ext4 /dev/$DEV
	# mount /dev/$DEV /mnt
	# fio --name=t --size=512m --rw=read --filename=/mnt/file
	...
	  read : io=524288KB, bw=2133.4MB/s, iops=546133, runt=   240msec

Sequential read from a block device:
	# fio --name=t --size=512m --rw=read --filename=/dev/$DEV
	...
(Without this commit)
	  read : io=524288KB, bw=1700.2MB/s, iops=435455, runt=   301msec

(With this commit)
	  read : io=524288KB, bw=2160.4MB/s, iops=553046, runt=   237msec

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/block_dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6d72746..e2f3ad08 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -304,6 +304,12 @@ static int blkdev_readpage(struct file * file, struct page * page)
 	return block_read_full_page(page, blkdev_get_block);
 }
 
+static int blkdev_readpages(struct file *file, struct address_space *mapping,
+			struct list_head *pages, unsigned nr_pages)
+{
+	return mpage_readpages(mapping, pages, nr_pages, blkdev_get_block);
+}
+
 static int blkdev_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -1622,6 +1628,7 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
 
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
+	.readpages	= blkdev_readpages,
 	.writepage	= blkdev_writepage,
 	.write_begin	= blkdev_write_begin,
 	.write_end	= blkdev_write_end,
-- 
1.9.1

