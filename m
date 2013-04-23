Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3DWGhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:37:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35623 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab3DWGhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:37:38 -0400
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 07/11] fbdev/sa1100fb: use vm_iomap_memory()
Date: Tue, 23 Apr 2013 09:36:54 +0300
Message-ID: <1366699018-5439-7-git-send-email-tomi.valkeinen@ti.com>
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
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/video/sa1100fb.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index cfbde5e..f34c858 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -556,7 +556,7 @@ static int sa1100fb_mmap(struct fb_info *info,
 			 struct vm_area_struct *vma)
 {
 	struct sa1100fb_info *fbi = (struct sa1100fb_info *)info;
-	unsigned long start, len, off = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
 
 	if (off < info->fix.smem_len) {
 		vma->vm_pgoff += 1; /* skip over the palette */
@@ -564,19 +564,9 @@ static int sa1100fb_mmap(struct fb_info *info,
 					     fbi->map_dma, fbi->map_size);
 	}
 
-	start = info->fix.mmio_start;
-	len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.mmio_len);
-
-	if ((vma->vm_end - vma->vm_start + off) > len)
-		return -EINVAL;
-
-	off += start & PAGE_MASK;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-	vma->vm_flags |= VM_IO;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	return io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				   vma->vm_end - vma->vm_start,
-				   vma->vm_page_prot);
+
+	return vm_iomap_memory(vma, info->fix.mmio_start, info->fix.mmio_len);
 }
 
 static struct fb_ops sa1100fb_ops = {
-- 
1.7.10.4

