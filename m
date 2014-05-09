Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbaEIWrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 18:47:00 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:51747 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaEIWq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 18:46:58 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Griffin <peter.griffin@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH] video: omap: delete support for early fbmem allocation
Date: Sat, 10 May 2014 01:52:44 +0300
Message-Id: <1399675964-22917-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1e434f9318efc3dddc0c0b8d2071712668154c2b (OMAPFB: remove early mem
alloc from old omapfb) deleted the support for early fbmem allocation
from the platform code, but some code still remains in the driver side.
Delete this code now, as it repotedly causes build issues on !MMU.

The patch was tested on Amstrad E3 and Nokia 770 and framebuffer
functionality is not affected.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/video/fbdev/omap/lcdc.c | 67 ++---------------------------------------
 1 file changed, 2 insertions(+), 65 deletions(-)

diff --git a/drivers/video/fbdev/omap/lcdc.c b/drivers/video/fbdev/omap/lcdc.c
index b52f625..6efa259 100644
--- a/drivers/video/fbdev/omap/lcdc.c
+++ b/drivers/video/fbdev/omap/lcdc.c
@@ -74,7 +74,6 @@ static struct omap_lcd_controller {
 	void			(*dma_callback)(void *data);
 	void			*dma_callback_data;
 
-	int			fbmem_allocated;
 	dma_addr_t		vram_phys;
 	void			*vram_virt;
 	unsigned long		vram_size;
@@ -611,42 +610,6 @@ static void lcdc_dma_handler(u16 status, void *data)
 		lcdc.dma_callback(lcdc.dma_callback_data);
 }
 
-static int mmap_kern(void)
-{
-	struct vm_struct	*kvma;
-	struct vm_area_struct	vma;
-	pgprot_t		pgprot;
-	unsigned long		vaddr;
-
-	kvma = get_vm_area(lcdc.vram_size, VM_IOREMAP);
-	if (kvma == NULL) {
-		dev_err(lcdc.fbdev->dev, "can't get kernel vm area\n");
-		return -ENOMEM;
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
-
-	lcdc.vram_virt = (void *)vaddr;
-
-	return 0;
-}
-
-static void unmap_kern(void)
-{
-	vunmap(lcdc.vram_virt);
-}
-
 static int alloc_palette_ram(void)
 {
 	lcdc.palette_virt = dma_alloc_writecombine(lcdc.fbdev->dev,
@@ -703,8 +666,6 @@ static void free_fbmem(void)
 
 static int setup_fbmem(struct omapfb_mem_desc *req_md)
 {
-	int r;
-
 	if (!req_md->region_cnt) {
 		dev_err(lcdc.fbdev->dev, "no memory regions defined\n");
 		return -EINVAL;
@@ -715,31 +676,7 @@ static int setup_fbmem(struct omapfb_mem_desc *req_md)
 		req_md->region_cnt = 1;
 	}
 
-	if (req_md->region[0].paddr == 0) {
-		lcdc.fbmem_allocated = 1;
-		if ((r = alloc_fbmem(&req_md->region[0])) < 0)
-			return r;
-		return 0;
-	}
-
-	lcdc.vram_phys = req_md->region[0].paddr;
-	lcdc.vram_size = req_md->region[0].size;
-
-	if ((r = mmap_kern()) < 0)
-		return r;
-
-	dev_dbg(lcdc.fbdev->dev, "vram at %08x size %08lx mapped to 0x%p\n",
-		 lcdc.vram_phys, lcdc.vram_size, lcdc.vram_virt);
-
-	return 0;
-}
-
-static void cleanup_fbmem(void)
-{
-	if (lcdc.fbmem_allocated)
-		free_fbmem();
-	else
-		unmap_kern();
+	return alloc_fbmem(&req_md->region[0]);
 }
 
 static int omap_lcdc_init(struct omapfb_device *fbdev, int ext_mode,
@@ -833,7 +770,7 @@ static void omap_lcdc_cleanup(void)
 {
 	if (!lcdc.ext_mode)
 		free_palette_ram();
-	cleanup_fbmem();
+	free_fbmem();
 	omap_free_lcd_dma();
 	free_irq(OMAP_LCDC_IRQ, lcdc.fbdev);
 	clk_disable(lcdc.lcd_ck);
-- 
1.9.0

