Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab3DWGhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:37:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53660 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3DWGhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:37:21 -0400
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 09/11] fbdev/sgivwfb: use vm_iomap_memory()
Date: Tue, 23 Apr 2013 09:36:56 +0300
Message-ID: <1366699018-5439-9-git-send-email-tomi.valkeinen@ti.com>
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
 drivers/video/sgivwfb.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index 2331fad..b2a8912 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -705,23 +705,17 @@ static int sgivwfb_setcolreg(u_int regno, u_int red, u_int green,
 static int sgivwfb_mmap(struct fb_info *info,
 			struct vm_area_struct *vma)
 {
-	unsigned long size = vma->vm_end - vma->vm_start;
-	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	int r;
 
-	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
-		return -EINVAL;
-	if (offset + size > sgivwfb_mem_size)
-		return -EINVAL;
-	offset += sgivwfb_mem_phys;
 	pgprot_val(vma->vm_page_prot) =
-	    pgprot_val(vma->vm_page_prot) | _PAGE_PCD;
-	vma->vm_flags |= VM_IO;
-	if (remap_pfn_range(vma, vma->vm_start, offset >> PAGE_SHIFT,
-						size, vma->vm_page_prot))
-		return -EAGAIN;
+		pgprot_val(vma->vm_page_prot) | _PAGE_PCD;
+
+	r = vm_iomap_memory(vma, sgivwfb_mem_phys, sgivwfb_mem_size);
+
 	printk(KERN_DEBUG "sgivwfb: mmap framebuffer P(%lx)->V(%lx)\n",
 	       offset, vma->vm_start);
-	return 0;
+
+	return r;
 }
 
 int __init sgivwfb_setup(char *options)
-- 
1.7.10.4

