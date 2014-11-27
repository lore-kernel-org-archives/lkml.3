Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaK0ItG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:49:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:42361 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbaK0ItB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:01 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Altaparmakov <aia21@cam.ac.uk>,
        Anton Altaparmakov <aia21@cantab.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 60/91] Fix nasty 32-bit overflow bug in buffer i/o code.
Date: Thu, 27 Nov 2014 16:42:43 +0800
Message-Id: <1417077794-9299-60-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Altaparmakov <aia21@cam.ac.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit f2d5a94436cc7cc0221b9a81bba2276a25187dd3 upstream.

On 32-bit architectures, the legacy buffer_head functions are not always
handling the sector number with the proper 64-bit types, and will thus
fail on 4TB+ disks.

Any code that uses __getblk() (and thus bread(), breadahead(),
sb_bread(), sb_breadahead(), sb_getblk()), and calls it using a 64-bit
block on a 32-bit arch (where "long" is 32-bit) causes an inifinite loop
in __getblk_slow() with an infinite stream of errors logged to dmesg
like this:

  __find_get_block_slow() failed. block=6740375944, b_blocknr=2445408648
  b_state=0x00000020, b_size=512
  device sda1 blocksize: 512

Note how in hex block is 0x191C1F988 and b_blocknr is 0x91C1F988 i.e. the
top 32-bits are missing (in this case the 0x1 at the top).

This is because grow_dev_page() is broken and has a 32-bit overflow due
to shifting the page index value (a pgoff_t - which is just 32 bits on
32-bit architectures) left-shifted as the block number.  But the top
bits to get lost as the pgoff_t is not type cast to sector_t / 64-bit
before the shift.

This patch fixes this issue by type casting "index" to sector_t before
doing the left shift.

Note this is not a theoretical bug but has been seen in the field on a
4TiB hard drive with logical sector size 512 bytes.

This patch has been verified to fix the infinite loop problem on 3.17-rc5
kernel using a 4TB disk image mounted using "-o loop".  Without this patch
doing a "find /nt" where /nt is an NTFS volume causes the inifinite loop
100% reproducibly whilst with the patch it works fine as expected.

Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9bf31ac..f235e18 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -971,7 +971,8 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 		bh = page_buffers(page);
 		if (bh->b_size == size) {
 			end_block = init_page_buffers(page, bdev,
-						index << sizebits, size);
+						(sector_t)index << sizebits,
+						size);
 			goto done;
 		}
 		if (!try_to_free_buffers(page))
@@ -992,7 +993,8 @@ grow_dev_page(struct block_device *bdev, sector_t block,
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
 	link_dev_buffers(page, bh);
-	end_block = init_page_buffers(page, bdev, index << sizebits, size);
+	end_block = init_page_buffers(page, bdev, (sector_t)index << sizebits,
+			size);
 	spin_unlock(&inode->i_mapping->private_lock);
 done:
 	ret = (block < end_block) ? 1 : -ENXIO;
-- 
1.9.1

