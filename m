Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab3EGEgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:36:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab3EGEZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:50 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=QsG50T1mz9AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ce2OYw0VIvEA:10 a=Z4Rwk6OoAAAA:8 a=boOtke3PPdf1enM-YC0A:9 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035855.840570653@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [089/126] vm: convert mtdchar mmap to vm_iomap_memory() helper
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0089-vm-convert-mtdchar-mmap-to-vm_iomap_memory-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 8558e4a26b00225efeb085725bc319f91201b239 ]

This is my example conversion of a few existing mmap users.  The mtdchar
case is actually disabled right now (and stays disabled), but I did it
because it showed up on my "git grep", and I was familiar with the code
due to fixing an overflow problem in the code in commit 9c603e53d380
("mtdchar: fix offset overflow detection").

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/mtd/mtdchar.c |   32 ++------------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 76afcb4..6e3d6dc 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -1159,45 +1159,17 @@ static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
 	struct mtd_file_info *mfi = file->private_data;
 	struct mtd_info *mtd = mfi->mtd;
 	struct map_info *map = mtd->priv;
-	resource_size_t start, off;
-	unsigned long len, vma_len;
 
         /* This is broken because it assumes the MTD device is map-based
 	   and that mtd->priv is a valid struct map_info.  It should be
 	   replaced with something that uses the mtd_get_unmapped_area()
 	   operation properly. */
 	if (0 /*mtd->type == MTD_RAM || mtd->type == MTD_ROM*/) {
-		off = get_vm_offset(vma);
-		start = map->phys;
-		len = PAGE_ALIGN((start & ~PAGE_MASK) + map->size);
-		start &= PAGE_MASK;
-		vma_len = get_vm_size(vma);
-
-		/* Overflow in off+len? */
-		if (vma_len + off < off)
-			return -EINVAL;
-		/* Does it fit in the mapping? */
-		if (vma_len + off > len)
-			return -EINVAL;
-
-		off += start;
-		/* Did that overflow? */
-		if (off < start)
-			return -EINVAL;
-		if (set_vm_offset(vma, off) < 0)
-			return -EINVAL;
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
1.7.10.4


