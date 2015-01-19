Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbbASStx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:49:53 -0500
Received: from mout.web.de ([212.227.17.11]:55567 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbbASStv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:49:51 -0500
Message-ID: <54BD51C3.8000507@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:49:39 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 9/9] video: Less function calls in w100fb_probe() after error
 detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BD44F0.3040705@users.sourceforge.net>
In-Reply-To: <54BD44F0.3040705@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:QQXltPHHle777ZD8HbMSr1GeNwQuAKtwiNmjbFC5gTqqDHEL3KH
 +iAxv6FwZstysPNtCBKbS3VrV4esCd7nEGEI3ac57rFerq7HVXeMV/CJEw8AXaUTg9NU1Fx
 LZ5hFXqEXBOe+2PdfYIsbENAB6C7xlRwDNQ2ZyeG2JlI7nEV+NNfrJ/dDIkUsYXhrjrnbSG
 l+fiTsuUOKnWkBv/Po7/g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 19 Jan 2015 17:56:11 +0100

The iounmap() function could be called in three cases by the w100fb_probe()
function during error handling even if the passed data structure element
contained still a null pointer.

* This implementation detail could be improved by adjustments for
  jump labels.

* Let us also delete two unnecessary null pointer checks for the
  variable "info".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/w100fb.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/video/fbdev/w100fb.c b/drivers/video/fbdev/w100fb.c
index aeb53eb..67ddc57 100644
--- a/drivers/video/fbdev/w100fb.c
+++ b/drivers/video/fbdev/w100fb.c
@@ -645,12 +645,12 @@ int w100fb_probe(struct platform_device *pdev)
 	/* Remap the chip base address */
 	remapped_base = ioremap_nocache(mem->start+W100_CFG_BASE, W100_CFG_LEN);
 	if (remapped_base == NULL)
-		goto out;
+		goto exit;
 
 	/* Map the register space */
 	remapped_regs = ioremap_nocache(mem->start+W100_REG_BASE, W100_REG_LEN);
 	if (remapped_regs == NULL)
-		goto out;
+		goto io_unmap_base;
 
 	/* Identify the chip */
 	printk("Found ");
@@ -662,19 +662,19 @@ int w100fb_probe(struct platform_device *pdev)
 		default:
 			printk("Unknown imageon chip ID\n");
 			err = -ENODEV;
-			goto out;
+			goto io_unmap_regs;
 	}
 	printk(" at 0x%08lx.\n", (unsigned long) mem->start+W100_CFG_BASE);
 
 	/* Remap the framebuffer */
 	remapped_fbuf = ioremap_nocache(mem->start+MEM_WINDOW_BASE, MEM_WINDOW_SIZE);
 	if (remapped_fbuf == NULL)
-		goto out;
+		goto io_unmap_regs;
 
 	info=framebuffer_alloc(sizeof(struct w100fb_par), &pdev->dev);
 	if (!info) {
 		err = -ENOMEM;
-		goto out;
+		goto io_unmap_framebuffer;
 	}
 
 	par = info->par;
@@ -690,13 +690,13 @@ int w100fb_probe(struct platform_device *pdev)
 	if (!par->pll_table) {
 		printk(KERN_ERR "No matching Xtal definition found\n");
 		err = -EINVAL;
-		goto out;
+		goto release_framebuffer;
 	}
 
 	info->pseudo_palette = kmalloc(sizeof (u32) * MAX_PALETTES, GFP_KERNEL);
 	if (!info->pseudo_palette) {
 		err = -ENOMEM;
-		goto out;
+		goto release_framebuffer;
 	}
 
 	info->fbops = &w100fb_ops;
@@ -716,7 +716,7 @@ int w100fb_probe(struct platform_device *pdev)
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0) < 0) {
 		err = -ENOMEM;
-		goto out;
+		goto free_palette;
 	}
 
 	par->mode = &inf->modelist[0];
@@ -766,15 +766,18 @@ int w100fb_probe(struct platform_device *pdev)
 	fb_info(info, "%s frame buffer device\n", info->fix.id);
 	return 0;
 out:
-	if (info) {
-		fb_dealloc_cmap(&info->cmap);
-		kfree(info->pseudo_palette);
-	}
+	fb_dealloc_cmap(&info->cmap);
+free_palette:
+	kfree(info->pseudo_palette);
+release_framebuffer:
+	framebuffer_release(info);
+io_unmap_framebuffer:
 	iounmap(remapped_fbuf);
+io_unmap_regs:
 	iounmap(remapped_regs);
+io_unmap_base:
 	iounmap(remapped_base);
-	if (info)
-		framebuffer_release(info);
+exit:
 	return err;
 }
 
-- 
2.2.2

