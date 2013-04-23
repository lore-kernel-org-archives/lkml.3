Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab3DWGh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:37:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35609 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab3DWGhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:37:24 -0400
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 10/11] fbdev/ps3fb: use vm_iomap_memory()
Date: Tue, 23 Apr 2013 09:36:57 +0300
Message-ID: <1366699018-5439-10-git-send-email-tomi.valkeinen@ti.com>
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
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/ps3fb.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/video/ps3fb.c b/drivers/video/ps3fb.c
index 920c27b..1bdeb08 100644
--- a/drivers/video/ps3fb.c
+++ b/drivers/video/ps3fb.c
@@ -705,21 +705,14 @@ static int ps3fb_pan_display(struct fb_var_screeninfo *var,
 
 static int ps3fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
-	unsigned long size, offset;
+	int r;
 
-	size = vma->vm_end - vma->vm_start;
-	offset = vma->vm_pgoff << PAGE_SHIFT;
-	if (offset + size > info->fix.smem_len)
-		return -EINVAL;
-
-	offset += info->fix.smem_start;
-	if (remap_pfn_range(vma, vma->vm_start, offset >> PAGE_SHIFT,
-			    size, vma->vm_page_prot))
-		return -EAGAIN;
+	r = vm_ioremap_memory(vma, info->fix.smem_start, info->fix.smem_len);
 
 	dev_dbg(info->device, "ps3fb: mmap framebuffer P(%lx)->V(%lx)\n",
 		offset, vma->vm_start);
-	return 0;
+
+	return r;
 }
 
     /*
-- 
1.7.10.4

