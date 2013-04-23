Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab3DWGhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:37:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35622 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab3DWGhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:37:36 -0400
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>, Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>
Subject: [PATCH 04/11] fbdev/au1200fb: use vm_iomap_memory()
Date: Tue, 23 Apr 2013 09:36:51 +0300
Message-ID: <1366699018-5439-4-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366699018-5439-1-git-send-email-tomi.valkeinen@ti.com>
References: <1366699018-5439-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vm_iomap_memory() instead of [io_]remap_pfn_range().
vm_iomap_memory() gives us much simpler API to map memory to userspace,
and reduces possibilities for bugs.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
---
 drivers/video/au1200fb.c |   26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/video/au1200fb.c b/drivers/video/au1200fb.c
index 1b59054..6ce6b83 100644
--- a/drivers/video/au1200fb.c
+++ b/drivers/video/au1200fb.c
@@ -1235,36 +1235,12 @@ static int au1200fb_fb_blank(int blank_mode, struct fb_info *fbi)
 static int au1200fb_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 
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
-- 
1.7.10.4

