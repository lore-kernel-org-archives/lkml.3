Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab3EGEfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:35:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab3EGEZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:51 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KmtswWdjD2AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=zzWnaiUEbbkA:10 a=Z4Rwk6OoAAAA:8 a=oCcaPWc0AAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035855.335995015@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [086/126] vm: convert fb_mmap to vm_iomap_memory() helper
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0086-vm-convert-fb_mmap-to-vm_iomap_memory-helper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit fc9bbca8f650e5f738af8806317c0a041a48ae4a ]

This is my example conversion of a few existing mmap users.  The
fb_mmap() case is a good example because it is a bit more complicated
than some: fb_mmap() mmaps one of two different memory areas depending
on the page offset of the mmap (but happily there is never any mixing of
the two, so the helper function still works).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/video/fbmem.c |   40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 0dff12a..edf5b2d 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1371,15 +1371,12 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
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
@@ -1391,33 +1388,24 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
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
1.7.10.4


