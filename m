Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3EGOXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:23:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42106 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab3EGNkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 019/118] vm: convert mtdchar mmap to vm_iomap_memory() helper
Date: Tue,  7 May 2013 14:37:45 +0100
Message-Id: <1367933964-1564-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8558e4a26b00225efeb085725bc319f91201b239 upstream.

This is my example conversion of a few existing mmap users.  The mtdchar
case is actually disabled right now (and stays disabled), but I did it
because it showed up on my "git grep", and I was familiar with the code
due to fixing an overflow problem in the code in commit 9c603e53d380
("mtdchar: fix offset overflow detection").

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/mtdchar.c | 23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 2cfb1a8..9e33653 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1132,36 +1132,17 @@ static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
 	struct map_info *map = mtd->priv;
-	unsigned long start;
-	unsigned long off;
-	u32 len;
 
         /* This is broken because it assumes the MTD device is map-based
 	   and that mtd->priv is a valid struct map_info.  It should be
 	   replaced with something that uses the mtd_get_unmapped_area()
 	   operation properly. */
 	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
-		off = vma->vm_pgoff << PAGE_SHIFT;
-		start = map->phys;
-		len = PAGE_ALIGN((start & ~PAGE_MASK) + map->size);
-		start &= PAGE_MASK;
-		if ((vma->vm_end - vma->vm_start + off) > len)
-			return -EINVAL;
-
-		off += start;
-		vma->vm_pgoff = off >> PAGE_SHIFT;
-		vma->vm_flags |= VM_IO | VM_RESERVED;
-
 #ifdef pgprot_noncached
-		if (file->f_flags & O_DSYNC || off >= __pa(high_memory))
+		if (file->f_flags & O_DSYNC || map->phys >= __pa(high_memory))
 			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 #endif
-		if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				       vma->vm_end - vma->vm_start,
-				       vma->vm_page_prot))
-			return -EAGAIN;
-
-		return 0;
+		return vm_iomap_memory(vma, map->phys, map->size);
 	}
 	return -ENOSYS;
 #else
-- 
1.8.1.2

