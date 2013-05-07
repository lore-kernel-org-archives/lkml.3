Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3EGNkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368Ab3EGNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 017/118] vm: convert fb_mmap to vm_iomap_memory() helper
Date: Tue,  7 May 2013 14:37:43 +0100
Message-Id: <1367933964-1564-18-git-send-email-luis.henriques@canonical.com>
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

commit fc9bbca8f650e5f738af8806317c0a041a48ae4a upstream.

This is my example conversion of a few existing mmap users.  The
fb_mmap() case is a good example because it is a bit more complicated
than some: fb_mmap() mmaps one of two different memory areas depending
on the page offset of the mmap (but happily there is never any mixing of
the two, so the helper function still works).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/fbmem.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index e4cc585..0a49456 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1373,15 +1373,12 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	struct fb_info *info = file_fb_info(file);
 	struct fb_ops *fb;
-	unsigned long off;
+	unsigned long mmio_pgoff;
 	unsigned long start;
 	u32 len;
 
 	if (!info)
 		return -ENODEV;
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
-		return -EINVAL;
-	off = vma->vm_pgoff << PAGE_SHIFT;
 	fb = info->fbops;
 	if (!fb)
 		return -ENODEV;
@@ -1393,33 +1390,24 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 		return res;
 	}
 
-	/* frame buffer memory */
+	/*
+	 * Ugh. This can be either the frame buffer mapping, or
+	 * if pgoff points past it, the mmio mapping.
+	 */
 	start = info->fix.smem_start;
-	len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.smem_len);
-	if (off >= len) {
-		/* memory mapped io */
-		off -= len;
-		if (info->var.accel_flags) {
-			mutex_unlock(&info->mm_lock);
-			return -EINVAL;
-		}
+	len = info->fix.smem_len;
+	mmio_pgoff = PAGE_ALIGN((start & ~PAGE_MASK) + len) >> PAGE_SHIFT;
+	if (vma->vm_pgoff >= mmio_pgoff) {
+		vma->vm_pgoff -= mmio_pgoff;
 		start = info->fix.mmio_start;
-		len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.mmio_len);
+		len = info->fix.mmio_len;
 	}
 	mutex_unlock(&info->mm_lock);
-	start &= PAGE_MASK;
-	if ((vma->vm_end - vma->vm_start + off) > len)
-		return -EINVAL;
-	off += start;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-	/* This is an IO map - tell maydump to skip this VMA */
-	vma->vm_flags |= VM_IO | VM_RESERVED;
+
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
-	fb_pgprotect(file, vma, off);
-	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-			     vma->vm_end - vma->vm_start, vma->vm_page_prot))
-		return -EAGAIN;
-	return 0;
+	fb_pgprotect(file, vma, start);
+
+	return vm_iomap_memory(vma, start, len);
 }
 
 static int
-- 
1.8.1.2

