Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3DWGhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:37:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50070 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab3DWGhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:37:15 -0400
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 05/11] fbdev/controlfb: use vm_iomap_memory()
Date: Tue, 23 Apr 2013 09:36:52 +0300
Message-ID: <1366699018-5439-5-git-send-email-tomi.valkeinen@ti.com>
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
---
 drivers/video/controlfb.c |   50 ++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
index 0c189b3..67b77b4 100644
--- a/drivers/video/controlfb.c
+++ b/drivers/video/controlfb.c
@@ -285,36 +285,26 @@ static int controlfb_pan_display(struct fb_var_screeninfo *var,
 static int controlfb_mmap(struct fb_info *info,
                        struct vm_area_struct *vma)
 {
-       unsigned long off, start;
-       u32 len;
-
-       off = vma->vm_pgoff << PAGE_SHIFT;
-
-       /* frame buffer memory */
-       start = info->fix.smem_start;
-       len = PAGE_ALIGN((start & ~PAGE_MASK)+info->fix.smem_len);
-       if (off >= len) {
-               /* memory mapped io */
-               off -= len;
-               if (info->var.accel_flags)
-                       return -EINVAL;
-               start = info->fix.mmio_start;
-               len = PAGE_ALIGN((start & ~PAGE_MASK)+info->fix.mmio_len);
-	       vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-       } else {
-               /* framebuffer */
-	       vma->vm_page_prot = pgprot_cached_wthru(vma->vm_page_prot);
-       }
-       start &= PAGE_MASK;
-       if ((vma->vm_end - vma->vm_start + off) > len)
-       		return -EINVAL;
-       off += start;
-       vma->vm_pgoff = off >> PAGE_SHIFT;
-       if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-           vma->vm_end - vma->vm_start, vma->vm_page_prot))
-               return -EAGAIN;
-
-       return 0;
+	unsigned long mmio_pgoff;
+	unsigned long start;
+	u32 len;
+
+	start = info->fix.smem_start;
+	len = info->fix.smem_len;
+	mmio_pgoff = PAGE_ALIGN((start & ~PAGE_MASK) + len) >> PAGE_SHIFT;
+	if (vma->vm_pgoff >= mmio_pgoff) {
+		if (info->var.accel_flags)
+			return -EINVAL;
+		vma->vm_pgoff -= mmio_pgoff;
+		start = info->fix.mmio_start;
+		len = info->fix.mmio_len;
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	} else {
+		/* framebuffer */
+		vma->vm_page_prot = pgprot_cached_wthru(vma->vm_page_prot);
+	}
+
+	return vm_iomap_memory(vma, start, len);
 }
 
 static int controlfb_blank(int blank_mode, struct fb_info *info)
-- 
1.7.10.4

