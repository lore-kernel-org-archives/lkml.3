Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3C0IwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:52:06 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:60190 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3C0Iqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:46:43 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, florianschandinat@gmx.de,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 4/6] drivers/video/wm8505fb.c: use devm_ functions
Date: Wed, 27 Mar 2013 21:46:59 +1300
Message-Id: <1364374021-10844-5-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz>
References: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

The patch makes some other cleanups.  First, the original code used
devm_kzalloc, but kfree.  This would lead to a double free.  The problem
was found using the following semantic match (http://coccinelle.lip6.fr/):

// <smpl>
@@
expression x,e;
@@
x = devm_kzalloc(...)
... when != x = e
?-kfree(x,...);
// </smpl>

The error-handing code of devm_request_and_ioremap does not print any
warning message, because devm_request_and_ioremap does this.

The call to dma_alloc_coherent is converted to its devm equivalent,
dmam_alloc_coherent.  This implicitly introduces a call to
dmam_free_coherent, which was completly missing in the original code.

A semicolon is removed at the end of the error-handling code for the call
to dma_alloc_coherent.

The block of code calling fb_alloc_cmap is moved below the block of code
calling wm8505fb_set_par, so that the error-handing code of the call to
wm8505fb_set_par can just return ret.  This way there is only one block of
error-handling code that needs to call fb_dealloc_cmap, and so this is
moved up to the place where it is needed, eliminating the need for all
gotos and labels in the function.  This was suggested by Tony Prisk.

The initializations of fbi and ret at the beginning of the function are not
necessary and are removed.  The call platform_set_drvdata(pdev, NULL); at
the end of the function is also removed.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/video/wm8505fb.c |   79 +++++++++++-----------------------------------
 1 file changed, 19 insertions(+), 60 deletions(-)

diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index ce23a00..b94ebc9 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -287,15 +287,11 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	unsigned long fb_mem_len;
 	void *fb_mem_virt;
 
-	ret = -ENOMEM;
-	fbi = NULL;
-
 	fbi = devm_kzalloc(&pdev->dev, sizeof(struct wm8505fb_info) +
 			sizeof(u32) * 16, GFP_KERNEL);
 	if (!fbi) {
 		dev_err(&pdev->dev, "Failed to initialize framebuffer device\n");
-		ret = -ENOMEM;
-		goto failed;
+		return -ENOMEM;
 	}
 
 	strcpy(fbi->fb.fix.id, DRIVER_NAME);
@@ -321,31 +317,14 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	fbi->fb.pseudo_palette	= addr;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no I/O memory resource defined\n");
-		ret = -ENODEV;
-		goto failed_fbi;
-	}
-
-	res = request_mem_region(res->start, resource_size(res), DRIVER_NAME);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		ret = -EBUSY;
-		goto failed_fbi;
-	}
-
-	fbi->regbase = ioremap(res->start, resource_size(res));
-	if (fbi->regbase == NULL) {
-		dev_err(&pdev->dev, "failed to map I/O memory\n");
-		ret = -EBUSY;
-		goto failed_free_res;
-	}
+	fbi->regbase = devm_request_and_ioremap(&pdev->dev, res);
+	if (fbi->regbase == NULL)
+		return -EBUSY;
 
 	np = of_parse_phandle(pdev->dev.of_node, "default-mode", 0);
 	if (!np) {
 		pr_err("%s: No display description in Device Tree\n", __func__);
-		ret = -EINVAL;
-		goto failed_free_res;
+		return -EINVAL;
 	}
 
 	/*
@@ -364,7 +343,7 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	ret |= of_property_read_u32(np, "bpp", &bpp);
 	if (ret) {
 		pr_err("%s: Unable to read display properties\n", __func__);
-		goto failed_free_res;
+		return -EINVAL;
 	}
 
 	of_mode.vmode = FB_VMODE_NONINTERLACED;
@@ -378,12 +357,12 @@ static int wm8505fb_probe(struct platform_device *pdev)
 
 	/* try allocating the framebuffer */
 	fb_mem_len = of_mode.xres * of_mode.yres * 2 * (bpp / 8);
-	fb_mem_virt = dma_alloc_coherent(&pdev->dev, fb_mem_len, &fb_mem_phys,
+	fb_mem_virt = dmam_alloc_coherent(&pdev->dev, fb_mem_len, &fb_mem_phys,
 				GFP_KERNEL);
 	if (!fb_mem_virt) {
 		pr_err("%s: Failed to allocate framebuffer\n", __func__);
 		return -ENOMEM;
-	};
+	}
 
 	fbi->fb.var.xres_virtual	= of_mode.xres;
 	fbi->fb.var.yres_virtual	= of_mode.yres * 2;
@@ -394,28 +373,29 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	fbi->fb.screen_base		= fb_mem_virt;
 	fbi->fb.screen_size		= fb_mem_len;
 
-	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
-		dev_err(&pdev->dev, "Failed to allocate color map\n");
-		ret = -ENOMEM;
-		goto failed_free_io;
-	}
-
-	wm8505fb_init_hw(&fbi->fb);
-
 	fbi->contrast = 0x80;
 	ret = wm8505fb_set_par(&fbi->fb);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to set parameters\n");
-		goto failed_free_cmap;
+		return ret;
 	}
 
+	if (fb_alloc_cmap(&fbi->fb.cmap, 256, 0) < 0) {
+		dev_err(&pdev->dev, "Failed to allocate color map\n");
+		return -ENOMEM;
+	}
+
+	wm8505fb_init_hw(&fbi->fb);
+
 	platform_set_drvdata(pdev, fbi);
 
 	ret = register_framebuffer(&fbi->fb);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"Failed to register framebuffer device: %d\n", ret);
-		goto failed_free_cmap;
+		if (fbi->fb.cmap.len)
+			fb_dealloc_cmap(&fbi->fb.cmap);
+		return ret;
 	}
 
 	ret = device_create_file(&pdev->dev, &dev_attr_contrast);
@@ -429,25 +409,11 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	       fbi->fb.fix.smem_start + fbi->fb.fix.smem_len - 1);
 
 	return 0;
-
-failed_free_cmap:
-	if (fbi->fb.cmap.len)
-		fb_dealloc_cmap(&fbi->fb.cmap);
-failed_free_io:
-	iounmap(fbi->regbase);
-failed_free_res:
-	release_mem_region(res->start, resource_size(res));
-failed_fbi:
-	platform_set_drvdata(pdev, NULL);
-	kfree(fbi);
-failed:
-	return ret;
 }
 
 static int wm8505fb_remove(struct platform_device *pdev)
 {
 	struct wm8505fb_info *fbi = platform_get_drvdata(pdev);
-	struct resource *res;
 
 	device_remove_file(&pdev->dev, &dev_attr_contrast);
 
@@ -458,13 +424,6 @@ static int wm8505fb_remove(struct platform_device *pdev)
 	if (fbi->fb.cmap.len)
 		fb_dealloc_cmap(&fbi->fb.cmap);
 
-	iounmap(fbi->regbase);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(fbi);
-
 	return 0;
 }
 
-- 
1.7.9.5

