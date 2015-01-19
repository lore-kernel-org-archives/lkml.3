Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbbASSif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:38:35 -0500
Received: from mout.web.de ([212.227.17.11]:55791 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbbASSiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:38:17 -0500
Message-ID: <54BD4F10.9040401@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:38:08 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 5/9] video: Less function calls in trident_pci_probe() after
 error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BD44F0.3040705@users.sourceforge.net>
In-Reply-To: <54BD44F0.3040705@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:fKoxAnPOtwDvSdY4ocfboj15fRVq2ISBw8y3tNHWF/ctk23aOEz
 wSDEVaARhvy32bX+8nyLA0u1I98FQU52qmQTaJkhRMV2iN07bDOKY0EH7hvCodhQIW2oXD3
 YqO0Qd1rpdW5rm62gpKPabhMtPcuxS61eQR4wclMpZ1B+cAgDLFpedfN/VCfkKwEQ5ezNRP
 bzJxqcmapv4v/5BApxrhg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 19 Jan 2015 14:18:47 +0100

The functions "iounmap" and "kfree" could be called in a few cases by the
trident_pci_probe() function during error handling even if the passed data
structure element contained still a null pointer.

This implementation detail could be improved by adjustments for jump labels.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/tridentfb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/tridentfb.c b/drivers/video/fbdev/tridentfb.c
index 71567401..86d4733 100644
--- a/drivers/video/fbdev/tridentfb.c
+++ b/drivers/video/fbdev/tridentfb.c
@@ -1436,7 +1436,7 @@ static int trident_pci_probe(struct pci_dev *dev,
 	if (!default_par->io_virt) {
 		debug("ioremap failed\n");
 		err = -1;
-		goto out_unmap1;
+		goto release_memory_region_mmio;
 	}
 
 	enable_mmio(default_par);
@@ -1459,7 +1459,7 @@ static int trident_pci_probe(struct pci_dev *dev,
 	if (!info->screen_base) {
 		debug("ioremap failed\n");
 		err = -1;
-		goto out_unmap2;
+		goto release_memory_region_smem;
 	}
 
 	default_par->flatpanel = is_flatpanel(default_par);
@@ -1485,7 +1485,7 @@ static int trident_pci_probe(struct pci_dev *dev,
 	info->pixmap.addr = kmalloc(4096, GFP_KERNEL);
 	if (!info->pixmap.addr) {
 		err = -ENOMEM;
-		goto out_unmap2;
+		goto io_unmap_screenbase;
 	}
 
 	info->pixmap.size = 4096;
@@ -1531,11 +1531,14 @@ static int trident_pci_probe(struct pci_dev *dev,
 
 out_unmap2:
 	kfree(info->pixmap.addr);
+io_unmap_screenbase:
 	iounmap(info->screen_base);
+release_memory_region_smem:
 	release_mem_region(tridentfb_fix.smem_start, tridentfb_fix.smem_len);
 	disable_mmio(info->par);
 out_unmap1:
 	iounmap(default_par->io_virt);
+release_memory_region_mmio:
 	release_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 	framebuffer_release(info);
 	return err;
-- 
2.2.2

