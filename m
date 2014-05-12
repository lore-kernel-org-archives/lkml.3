Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbaELBol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:41 -0400
Received: from 1wt.eu ([62.212.114.60]:34810 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089AbaELBoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:39 -0400
Message-Id: <20140512003205.520549802@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 117/143] Fix a few incorrectly checked [io_]remap_pfn_range() calls
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

Nico Golde reports a few straggling uses of [io_]remap_pfn_range() that
really should use the vm_iomap_memory() helper.  This trivially converts
two of them to the helper, and comments about why the third one really
needs to continue to use remap_pfn_range(), and adds the missing size
check.

Reported-by: Nico Golde <nico@ngolde.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 7314e613d5ff9f0934f7a0f74ed7973b903315d1)
[wt: vm_flags were absent in mainline, Ben removed them in 3.2, but
 I kept them to minimize changes and avoid any side effect]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/uio/uio.c        | 16 +++++++++++++++-
 drivers/video/au1100fb.c | 26 +-------------------------
 drivers/video/au1200fb.c | 26 +-------------------------
 3 files changed, 17 insertions(+), 51 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index e941367..e3804d3 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -669,16 +669,30 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 {
 	struct uio_device *idev = vma->vm_private_data;
 	int mi = uio_find_mem_index(vma);
+	struct uio_mem *mem;
 	if (mi < 0)
 		return -EINVAL;
+	mem = idev->info->mem + mi;
+
+	if (vma->vm_end - vma->vm_start > mem->size)
+		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED;
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
+	/*
+	 * We cannot use the vm_iomap_memory() helper here,
+	 * because vma->vm_pgoff is the map index we looked
+	 * up above in uio_find_mem_index(), rather than an
+	 * actual page offset into the mmap.
+	 *
+	 * So we just do the physical mmap without a page
+	 * offset.
+	 */
 	return remap_pfn_range(vma,
 			       vma->vm_start,
-			       idev->info->mem[mi].addr >> PAGE_SHIFT,
+			       mem->addr >> PAGE_SHIFT,
 			       vma->vm_end - vma->vm_start,
 			       vma->vm_page_prot);
 }
diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index a699aab..745e5b3 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -392,39 +392,15 @@ void au1100fb_fb_rotate(struct fb_info *fbi, int angle)
 int au1100fb_fb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 {
 	struct au1100fb_device *fbdev;
-	unsigned int len;
-	unsigned long start=0, off;
 
 	fbdev = to_au1100fb_device(fbi);
 
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT)) {
-		return -EINVAL;
-	}
-
-	start = fbdev->fb_phys & PAGE_MASK;
-	len = PAGE_ALIGN((start & ~PAGE_MASK) + fbdev->fb_len);
-
-	off = vma->vm_pgoff << PAGE_SHIFT;
-
-	if ((vma->vm_end - vma->vm_start + off) > len) {
-		return -EINVAL;
-	}
-
-	off += start;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	pgprot_val(vma->vm_page_prot) |= (6 << 9); //CCA=6
 
 	vma->vm_flags |= VM_IO;
 
-	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				vma->vm_end - vma->vm_start,
-				vma->vm_page_prot)) {
-		return -EAGAIN;
-	}
-
-	return 0;
+	return vm_iomap_memory(vma, fbdev->fb_phys, fbdev->fb_len);
 }
 
 /* fb_cursor
diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index 0d96f1d..5d6e509 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1241,42 +1241,18 @@ static int au1200fb_fb_blank(int blank_mode, struct fb_info *fbi)
  * method mainly to allow the use of the TLB streaming flag (CCA=6)
  */
 static int au1200fb_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
-
 {
-	unsigned int len;
-	unsigned long start=0, off;
 	struct au1200fb_device *fbdev = (struct au1200fb_device *) info;
 
 #ifdef CONFIG_PM
 	au1xxx_pm_access(LCD_pm_dev);
 #endif
-
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT)) {
-		return -EINVAL;
-	}
-
-	start = fbdev->fb_phys & PAGE_MASK;
-	len = PAGE_ALIGN((start & ~PAGE_MASK) + fbdev->fb_len);
-
-	off = vma->vm_pgoff << PAGE_SHIFT;
-
-	if ((vma->vm_end - vma->vm_start + off) > len) {
-		return -EINVAL;
-	}
-
-	off += start;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	pgprot_val(vma->vm_page_prot) |= _CACHE_MASK; /* CCA=7 */
 
 	vma->vm_flags |= VM_IO;
 
-	return io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				  vma->vm_end - vma->vm_start,
-				  vma->vm_page_prot);
-
-	return 0;
+	return vm_iomap_memory(vma, fbdev->fb_phys, fbdev->fb_len);
 }
 
 static void set_global(u_int cmd, struct au1200_lcd_global_regs_t *pdata)
-- 
1.7.12.2.21.g234cd45.dirty



