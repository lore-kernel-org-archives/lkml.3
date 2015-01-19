Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbbASSns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:43:48 -0500
Received: from mout.web.de ([212.227.17.12]:53546 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbbASSnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:43:46 -0500
Message-ID: <54BD5058.1090809@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:43:36 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 7/9] video: One function call less in tgafb_register() after,
 error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BD44F0.3040705@users.sourceforge.net>
In-Reply-To: <54BD44F0.3040705@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Rt59orZuW9sMiH6wVSjb4XVFV2wHM3OUgiBwcWBWtnxdqbGIeHQ
 /LLceqjM5nToxycHeDSVTUPl/Acd/2VrcdpPbdLS5Bb01SSYuRBPHFNUcSV53HAy2vrxaOW
 VNiS7qttEQaSMvVQfH9leTxPLbOL8DAiZZUSo8Toj7tgh2cqgkooRoe8HN9pMQvYsk15C1/
 UvQ5pyg3jnP+9NFhgKGpA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 19 Jan 2015 15:30:45 +0100

The iounmap() function could be called in one case by the tgafb_register()
function during error handling even if the passed variable "mem_base"
contained still a null pointer.

This implementation detail could be improved by adjustments for jump labels
(according also to current Linux coding style).

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/tgafb.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/tgafb.c b/drivers/video/fbdev/tgafb.c
index b6fb7e8..a3cd0ef 100644
--- a/drivers/video/fbdev/tgafb.c
+++ b/drivers/video/fbdev/tgafb.c
@@ -1436,14 +1436,14 @@ static int tgafb_register(struct device *dev)
 	}
 	if (!request_mem_region (bar0_start, bar0_len, "tgafb")) {
 		printk(KERN_ERR "tgafb: cannot reserve FB region\n");
-		goto err0;
+		goto release_framebuffer;
 	}
 
 	/* Map the framebuffer.  */
 	mem_base = ioremap_nocache(bar0_start, bar0_len);
 	if (!mem_base) {
 		printk(KERN_ERR "tgafb: Cannot map MMIO\n");
-		goto err1;
+		goto release_memory_region;
 	}
 
 	/* Grab info about the card.  */
@@ -1484,13 +1484,13 @@ static int tgafb_register(struct device *dev)
 	if (ret == 0 || ret == 4) {
 		printk(KERN_ERR "tgafb: Could not find valid video mode\n");
 		ret = -EINVAL;
-		goto err1;
+		goto io_unmap;
 	}
 
 	if (fb_alloc_cmap(&info->cmap, 256, 0)) {
 		printk(KERN_ERR "tgafb: Could not allocate color map\n");
 		ret = -ENOMEM;
-		goto err1;
+		goto io_unmap;
 	}
 
 	tgafb_set_par(info);
@@ -1498,7 +1498,7 @@ static int tgafb_register(struct device *dev)
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "tgafb: Could not register framebuffer\n");
 		ret = -EINVAL;
-		goto err2;
+		goto dealloc_cmap;
 	}
 
 	if (tga_bus_pci) {
@@ -1517,12 +1517,13 @@ static int tgafb_register(struct device *dev)
 
 	return 0;
 
- err2:
+dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
- err1:
+io_unmap:
 	iounmap(mem_base);
+release_memory_region:
 	release_mem_region(bar0_start, bar0_len);
- err0:
+release_framebuffer:
 	framebuffer_release(info);
 	return ret;
 }
-- 
2.2.2

