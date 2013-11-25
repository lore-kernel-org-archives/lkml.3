Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3KYN7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:59:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58971 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab3KYNxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, Linus@decadent.org.uk,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Nico Golde" <nico@ngolde.de>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.819812669@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 80/87] Fix a few incorrectly checked [io_]remap_pfn_range()
 calls
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Also remove redundant vm_flags changes, removed separately upstream]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -650,16 +650,28 @@ static int uio_mmap_physical(struct vm_a
 {
 	struct uio_device *idev = vma->vm_private_data;
 	int mi = uio_find_mem_index(vma);
+	struct uio_mem *mem;
 	if (mi < 0)
 		return -EINVAL;
+	mem = idev->info->mem + mi;
 
-	vma->vm_flags |= VM_IO | VM_RESERVED;
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
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -387,39 +387,13 @@ void au1100fb_fb_rotate(struct fb_info *
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
 
-	vma->vm_flags |= VM_IO;
-
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
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1216,38 +1216,13 @@ static int au1200fb_fb_blank(int blank_m
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
 
-	vma->vm_flags |= VM_IO;
-
-	return io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				  vma->vm_end - vma->vm_start,
-				  vma->vm_page_prot);
-
-	return 0;
+	return vm_iomap_memory(vma, fbdev->fb_phys, fbdev->fb_len);
 }
 
 static void set_global(u_int cmd, struct au1200_lcd_global_regs_t *pdata)

