Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3DWGiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:38:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50076 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab3DWGhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:37:23 -0400
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 06/11] fbdev/fb-puv3: use vm_iomap_memory()
Date: Tue, 23 Apr 2013 09:36:53 +0300
Message-ID: <1366699018-5439-6-git-send-email-tomi.valkeinen@ti.com>
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
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 drivers/video/fb-puv3.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/video/fb-puv3.c b/drivers/video/fb-puv3.c
index 7d106f1f..27fc956 100644
--- a/drivers/video/fb-puv3.c
+++ b/drivers/video/fb-puv3.c
@@ -640,21 +640,9 @@ static int unifb_pan_display(struct fb_var_screeninfo *var,
 int unifb_mmap(struct fb_info *info,
 		    struct vm_area_struct *vma)
 {
-	unsigned long size = vma->vm_end - vma->vm_start;
-	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned long pos = info->fix.smem_start + offset;
-
-	if (offset + size > info->fix.smem_len)
-		return -EINVAL;
-
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
-	if (io_remap_pfn_range(vma, vma->vm_start, pos >> PAGE_SHIFT, size,
-				vma->vm_page_prot))
-		return -EAGAIN;
-
-	/* VM_IO | VM_DONTEXPAND | VM_DONTDUMP are set by remap_pfn_range() */
-	return 0;
+	return vm_iomap_memory(vma, info->fix.smem_start, info->fix.smem_len);
 }
 
 static struct fb_ops unifb_ops = {
-- 
1.7.10.4

