Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaDXMjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:39:06 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:46960 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbaDXMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:37:13 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 13/13] video: omap: allow building on !MMU
Date: Thu, 24 Apr 2014 13:28:29 +0100
Message-Id: <1398342509-10243-14-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The omap lcdc driver has an elaborate mmap_kern function
to map the frame buffer into kernel address space as
write-combined. This uses functions that are only available
on MMU-enabled builds.

It does seem equivalent to ioremap_wc though, so we should
be able to just use that instead.

This patch is build-tested only, it needs to be run on real
hardware before applying.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-omap@vger.kernel.org
---
 drivers/video/fbdev/omap/lcdc.c |   28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/drivers/video/fbdev/omap/lcdc.c b/drivers/video/fbdev/omap/lcdc.c
index b52f625..40e8200 100644
--- a/drivers/video/fbdev/omap/lcdc.c
+++ b/drivers/video/fbdev/omap/lcdc.c
@@ -613,29 +613,11 @@ static void lcdc_dma_handler(u16 status, void *data)
 
 static int mmap_kern(void)
 {
-	struct vm_struct	*kvma;
-	struct vm_area_struct	vma;
-	pgprot_t		pgprot;
-	unsigned long		vaddr;
-
-	kvma = get_vm_area(lcdc.vram_size, VM_IOREMAP);
-	if (kvma == NULL) {
-		dev_err(lcdc.fbdev->dev, "can't get kernel vm area\n");
+	void __iomem *vaddr;
+
+	vaddr = ioremap_wc(lcdc.vram_phys, lcdc.vram_size);
+	if (!vaddr)
 		return -ENOMEM;
-	}
-	vma.vm_mm = &init_mm;
-
-	vaddr = (unsigned long)kvma->addr;
-	vma.vm_start = vaddr;
-	vma.vm_end = vaddr + lcdc.vram_size;
-
-	pgprot = pgprot_writecombine(pgprot_kernel);
-	if (io_remap_pfn_range(&vma, vaddr,
-			   lcdc.vram_phys >> PAGE_SHIFT,
-			   lcdc.vram_size, pgprot) < 0) {
-		dev_err(lcdc.fbdev->dev, "kernel mmap for FB memory failed\n");
-		return -EAGAIN;
-	}
 
 	lcdc.vram_virt = (void *)vaddr;
 
@@ -644,7 +626,7 @@ static int mmap_kern(void)
 
 static void unmap_kern(void)
 {
-	vunmap(lcdc.vram_virt);
+	iounmap(lcdc.vram_virt);
 }
 
 static int alloc_palette_ram(void)
-- 
1.7.9.5

