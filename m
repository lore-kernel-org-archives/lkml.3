Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3KYNJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:09:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3KYNJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:09:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 77/78] Fix a few incorrectly checked [io_]remap_pfn_range() calls
Date: Mon, 25 Nov 2013 13:07:04 +0000
Message-Id: <1385384825-21681-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
[lizf: backported to 3.4:
 - adjust context
 - no uio_physical_vm_ops]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/uio/uio.c        | 16 +++++++++++++++-
 drivers/video/au1100fb.c | 26 +-------------------------
 drivers/video/au1200fb.c | 23 +----------------------
 3 files changed, 17 insertions(+), 48 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a783d53..7150752 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -650,16 +650,30 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
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
index fe3b6ec..2169bc0 100644
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
index 7ca79f0..117be3d 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1233,36 +1233,15 @@ static int au1200fb_fb_blank(int blank_mode, struct fb_info *fbi)
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
+	return vm_iomap_memory(vma, fbdev->fb_phys, fbdev->fb_len);
 
 	return 0;
 }
-- 
1.8.3.2

