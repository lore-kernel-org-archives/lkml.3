Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab3KHCRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34534 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab3KHCQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 80/91] Fix a few incorrectly checked [io_]remap_pfn_range() calls
Date: Thu,  7 Nov 2013 18:15:35 -0800
Message-Id: <1383876946-2396-81-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 7314e613d5ff9f0934f7a0f74ed7973b903315d1 upstream.

Nico Golde reports a few straggling uses of [io_]remap_pfn_range() that
really should use the vm_iomap_memory() helper.  This trivially converts
two of them to the helper, and comments about why the third one really
needs to continue to use remap_pfn_range(), and adds the missing size
check.

Reported-by: Nico Golde <nico@ngolde.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org.
[ kamal: backport to 3.8 (no uio_physical_vm_ops; context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/uio/uio.c        | 16 +++++++++++++++-
 drivers/video/au1100fb.c | 26 +-------------------------
 drivers/video/au1200fb.c | 25 +------------------------
 3 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5110f36..96f1359 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -650,14 +650,28 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
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
index ddabaa8..f8d8b97 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -375,39 +375,15 @@ void au1100fb_fb_rotate(struct fb_info *fbi, int angle)
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
 
 static struct fb_ops au1100fb_ops =
diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index 1b59054..8f08ae7 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1233,38 +1233,15 @@ static int au1200fb_fb_blank(int blank_mode, struct fb_info *fbi)
  * method mainly to allow the use of the TLB streaming flag (CCA=6)
  */
 static int au1200fb_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
-
 {
-	unsigned int len;
-	unsigned long start=0, off;
 	struct au1200fb_device *fbdev = info->par;
 
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
1.8.1.2

