Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbbASSZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:25:40 -0500
Received: from mout.web.de ([212.227.17.11]:64015 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbbASSZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:25:38 -0500
Message-ID: <54BD4C19.6040500@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:25:29 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: video: One function call less in tdfxfb_probe() after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BD44F0.3040705@users.sourceforge.net>
In-Reply-To: <54BD44F0.3040705@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:a6WDEXxnx7Jm9IuuO/6USfvCwf87nvHIk0IGH8/nVKjcbuEqDlm
 GL0ZN7D2VjmAUQ9ZrqcUMmorUQ56E0r1dqjMNsNfZDhiYiCnjj5QvlsGHublbtNbEhYQcR4
 Qpgbw9miYDVNz4xwT7j9gcICSgvMU3z3CztF+1MoBLLs7kuSzFBJkbfP6CkfUOcewRoXZld
 3JTq65xEOnJhRl42oj/Iw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 18 Jan 2015 23:30:41 +0100

The iounmap() function could be called in two cases by the tdfxfb_probe()
function during error handling even if the passed data structure element
contained still a null pointer.

This implementation detail could be improved by adjustments for jump labels.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/tdfxfb.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
index 69d4062..c280a3b 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1438,20 +1438,20 @@ static int tdfxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!default_par->regbase_virt) {
 		printk(KERN_ERR "fb: Can't remap %s register area.\n",
 				info->fix.id);
-		goto out_err_regbase;
+		goto release_memory_region_regbase;
 	}
 
 	info->fix.smem_start = pci_resource_start(pdev, 1);
 	info->fix.smem_len = do_lfb_size(default_par, pdev->device);
 	if (!info->fix.smem_len) {
 		printk(KERN_ERR "fb: Can't count %s memory.\n", info->fix.id);
-		goto out_err_regbase;
+		goto io_unmap_regbase;
 	}
 
 	if (!request_mem_region(info->fix.smem_start,
 				pci_resource_len(pdev, 1), "tdfx smem")) {
 		printk(KERN_ERR "tdfxfb: Can't reserve smem\n");
-		goto out_err_regbase;
+		goto io_unmap_regbase;
 	}
 
 	info->screen_base = ioremap_nocache(info->fix.smem_start,
@@ -1459,7 +1459,7 @@ static int tdfxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!info->screen_base) {
 		printk(KERN_ERR "fb: Can't remap %s framebuffer.\n",
 				info->fix.id);
-		goto out_err_screenbase;
+		goto release_memory_region_screenbase;
 	}
 
 	default_par->iobase = pci_resource_start(pdev, 2);
@@ -1467,7 +1467,7 @@ static int tdfxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!request_region(pci_resource_start(pdev, 2),
 			    pci_resource_len(pdev, 2), "tdfx iobase")) {
 		printk(KERN_ERR "tdfxfb: Can't reserve iobase\n");
-		goto out_err_screenbase;
+		goto io_unmap_screenbase;
 	}
 
 	printk(KERN_INFO "fb: %s memory = %dK\n", info->fix.id,
@@ -1571,14 +1571,16 @@ out_err_iobase:
 			 info->fix.smem_len);
 	release_region(pci_resource_start(pdev, 2),
 		       pci_resource_len(pdev, 2));
-out_err_screenbase:
+io_unmap_screenbase:
 	iounmap(info->screen_base);
+release_memory_region_screenbase:
 	release_mem_region(info->fix.smem_start, pci_resource_len(pdev, 1));
-out_err_regbase:
+io_unmap_regbase:
 	/*
 	 * Cleanup after anything that was remapped/allocated.
 	 */
 	iounmap(default_par->regbase_virt);
+release_memory_region_regbase:
 	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 out_err:
 	framebuffer_release(info);
-- 
2.2.2

