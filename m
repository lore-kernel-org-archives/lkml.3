Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759120Ab3DAQzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:55:54 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:46536 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab3DAQzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:55:52 -0400
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, sqazi@google.com, viro@zeniv.linux.org.uk,
        yan@linux.vnet.ibm.com, Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] loop: prevent bdev freeing while device in use
Date: Mon,  1 Apr 2013 09:47:56 -0700
Message-Id: <1364834876-30502-1-git-send-email-anatol.pomozov@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
References: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct block_device lifecycle is defined by its inode (see fs/block_dev.c) -
block_device allocated first time we access /dev/loopXX and deallocated on
bdev_destroy_inode. When we create the device "losetup /dev/loopXX afile"
we want that block_device stay alive until we destroy the loop device
with "losetup -d".

But because we do not hold /dev/loopXX inode its counter goes 0, and
inode/bdev can be destroyed at any moment. Usually it happens at memory
pressure or when user drops inode cache (like in the test below). When later in
loop_clr_fd() we want to use bdev we have use-after-free error with following
stack:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000280
  bd_set_size+0x10/0xa0
  loop_clr_fd+0x1f8/0x420 [loop]
  lo_ioctl+0x200/0x7e0 [loop]
  lo_compat_ioctl+0x47/0xe0 [loop]
  compat_blkdev_ioctl+0x341/0x1290
  do_filp_open+0x42/0xa0
  compat_sys_ioctl+0xc1/0xf20
  do_sys_open+0x16e/0x1d0
  sysenter_dispatch+0x7/0x1a

To prevent use-after-free we need to grab the device in loop_set_fd()
and put it later in loop_clr_fd().

The issue is reprodusible on current Linus head and v3.3. Here is the test:

dd if=/dev/zero of=loop.file bs=1M count=1
while [ true ]; do
	losetup /dev/loop0 loop.file
	echo 2 > /proc/sys/vm/drop_caches
	losetup -d /dev/loop0
done

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 drivers/block/loop.c | 9 ++++++++-
 fs/block_dev.c       | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fe5f640..2c127f9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -922,6 +922,11 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
 		ioctl_by_bdev(bdev, BLKRRPART, 0);
+
+	/* Grab the block_device to prevent its destruction after we
+	 * put /dev/loopXX inode. Later in loop_clr_fd() we bdput(bdev).
+	 */
+	bdgrab(bdev);
 	return 0;
 
 out_clr:
@@ -1031,8 +1036,10 @@ static int loop_clr_fd(struct loop_device *lo)
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
-	if (bdev)
+	if (bdev) {
+		bdput(bdev);
 		invalidate_bdev(bdev);
+	}
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
 	if (bdev) {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index aea605c..aae187a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -551,6 +551,7 @@ struct block_device *bdgrab(struct block_device *bdev)
 	ihold(bdev->bd_inode);
 	return bdev;
 }
+EXPORT_SYMBOL(bdgrab);
 
 long nr_blockdev_pages(void)
 {
-- 
1.8.1.3

