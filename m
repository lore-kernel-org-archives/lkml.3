Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbbASSlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:41:07 -0500
Received: from mout.web.de ([212.227.17.12]:60354 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbbASSlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:41:05 -0500
Message-ID: <54BD4FBD.3020308@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:41:01 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 6/9] video: One function call less in pvr2fb_common_init()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BD44F0.3040705@users.sourceforge.net>
In-Reply-To: <54BD44F0.3040705@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:JpEmSg6DWCx5s22BULGqYWIGznGD4ih4HrTdLU8ewiPIiPU3lMH
 chwg8aNeVs5apJ7s6MKjrqQ1JEw5M4AKDDQecOQmxdnhJCGP12jgkwNHdXPx3o+N49V0xEd
 E30fmymKQ1CZLek1GvMZHOQCJtNZvaToyBqXjOwfCKhEdOnfIkMD0dJXonzMpInx4PrPh/n
 ohXTz2K/m8DIjdohZWSPQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 19 Jan 2015 14:50:44 +0100

The iounmap() function could be called in two cases by the pvr2fb_common_init()
function during error handling even if the passed data structure element
contained still a null pointer.

This implementation detail could be improved by adjustments for jump labels.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/pvr2fb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
index 7aa4ef1..9fb8bbf 100644
--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -773,14 +773,14 @@ static int pvr2fb_common_init(void)
 
 	if (!fb_info->screen_base) {
 		printk(KERN_ERR "pvr2fb: Failed to remap smem space\n");
-		goto out_err;
+		return -ENXIO;
 	}
 
 	par->mmio_base = (unsigned long)ioremap_nocache(pvr2_fix.mmio_start,
 							pvr2_fix.mmio_len);
 	if (!par->mmio_base) {
 		printk(KERN_ERR "pvr2fb: Failed to remap mmio space\n");
-		goto out_err;
+		goto io_unmap_screen;
 	}
 
 	fb_memset(fb_info->screen_base, 0, pvr2_fix.smem_len);
@@ -807,7 +807,7 @@ static int pvr2fb_common_init(void)
 	fb_alloc_cmap(&fb_info->cmap, 256, 0);
 
 	if (register_framebuffer(fb_info) < 0)
-		goto out_err;
+		goto io_unmap_mmio;
 	/*Must write PIXDEPTH to register before anything is displayed - so force init */
 	pvr2_init_display(fb_info);
 
@@ -840,10 +840,10 @@ static int pvr2fb_common_init(void)
 
 	return 0;
 
-out_err:
+io_unmap_mmio:
+	iounmap((void *)par->mmio_base);
+io_unmap_screen:
 	iounmap(fb_info->screen_base);
-	if (par->mmio_base)
-		iounmap((void *)par->mmio_base);
 
 	return -ENXIO;
 }
-- 
2.2.2

