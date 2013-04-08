Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936007Ab3DHJxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:53:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935977Ab3DHJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 096/102] loop: prevent bdev freeing while device in use
Date: Mon,  8 Apr 2013 10:50:51 +0100
Message-Id: <1365414657-29191-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatol Pomozov <anatol.pomozov@gmail.com>

commit c1681bf8a7b1b98edee8b862a42c19c4e53205fd upstream.

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

[ Doing bdgrab/bput in loop_set_fd/loop_clr_fd is safe, because every
  time we call loop_set_fd() we check that loop_device->lo_state is
  Lo_unbound and set it to Lo_bound If somebody will try to set_fd again
  it will get EBUSY.  And if we try to loop_clr_fd() on unbound loop
  device we'll get ENXIO.

  loop_set_fd/loop_clr_fd (and any other loop ioctl) is called under
  loop_device->lo_ctl_mutex. ]

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/loop.c | 9 ++++++++-
 fs/block_dev.c       | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a77d9a5..c5e0f73 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -908,6 +908,11 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
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
@@ -1004,8 +1009,10 @@ static int loop_clr_fd(struct loop_device *lo)
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
index 77e86b3..1244094 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -604,6 +604,7 @@ struct block_device *bdgrab(struct block_device *bdev)
 	ihold(bdev->bd_inode);
 	return bdev;
 }
+EXPORT_SYMBOL(bdgrab);
 
 long nr_blockdev_pages(void)
 {
-- 
1.8.1.2

