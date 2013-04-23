Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab3DWWLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:11:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab3DWVxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 37/42] vm: convert fb_mmap to vm_iomap_memory() helper
Date: Tue, 23 Apr 2013 14:52:35 -0700
Message-Id: <20130423215209.230593742@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit fc9bbca8f650e5f738af8806317c0a041a48ae4a upstream.

This is my example conversion of a few existing mmap users.  The
fb_mmap() case is a good example because it is a bit more complicated
than some: fb_mmap() mmaps one of two different memory areas depending
on the page offset of the mmap (but happily there is never any mixing of
the two, so the helper function still works).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbmem.c |   39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1373,15 +1373,12 @@ fb_mmap(struct file *file, struct vm_are
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
@@ -1393,32 +1390,24 @@ fb_mmap(struct file *file, struct vm_are
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
-	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by io_remap_pfn_range()*/
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


