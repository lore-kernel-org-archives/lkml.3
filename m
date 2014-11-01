Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaKAWva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:51:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60188 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbaKAWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:29 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Anton Altaparmakov" <aia21@cantab.net>,
        "Anton Altaparmakov" <aia21@cam.ac.uk>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.485153234@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 067/102] Fix nasty 32-bit overflow bug in buffer i/o code.
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Altaparmakov <aia21@cam.ac.uk>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1021,7 +1021,8 @@ grow_dev_page(struct block_device *bdev,
 		bh = page_buffers(page);
 		if (bh->b_size == size) {
 			end_block = init_page_buffers(page, bdev,
-						index << sizebits, size);
+						(sector_t)index << sizebits,
+						size);
 			goto done;
 		}
 		if (!try_to_free_buffers(page))
@@ -1042,7 +1043,8 @@ grow_dev_page(struct block_device *bdev,
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
 	link_dev_buffers(page, bh);
-	end_block = init_page_buffers(page, bdev, index << sizebits, size);
+	end_block = init_page_buffers(page, bdev, (sector_t)index << sizebits,
+			size);
 	spin_unlock(&inode->i_mapping->private_lock);
 done:
 	ret = (block < end_block) ? 1 : -ENXIO;

