Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbbASSat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:30:49 -0500
Received: from mout.web.de ([212.227.17.12]:62350 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbbASSar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:30:47 -0500
Message-ID: <54BD4D52.2090902@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:30:42 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/9] video: One function call less in vesafb_probe() after,
 error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BD44F0.3040705@users.sourceforge.net>
In-Reply-To: <54BD44F0.3040705@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:pbWTDFgv2gpfqmMuw/HlXFSMCuPcXn5AkeJ2uTTyh/wkpjufH3R
 36LUeaiyvfTN5M1Lx5WYwQg0h6TSKie5gNfWf6LFrax6ES7FroF4sqmmIHO4tSUYSX6VuRf
 55b/J21ArY1l6QKVScco9U/xD/Z5oQoMe+8nNJK/8iv51qwiDBwce2/3hos2eVgOqTu1TIr
 g3stOMij6zS0x9VlV2yng==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 19 Jan 2015 11:30:33 +0100

The iounmap() function could be called in two cases by the vesafb_probe()
function during error handling even if the passed data structure element
contained still a null pointer.

This implementation detail could be improved by adjustments for jump labels.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/vesafb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/vesafb.c b/drivers/video/fbdev/vesafb.c
index 693d18e..de7cad0 100644
--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -303,7 +303,7 @@ static int vesafb_probe(struct platform_device *dev)
 	info->apertures = alloc_apertures(1);
 	if (!info->apertures) {
 		err = -ENOMEM;
-		goto err;
+		goto release_framebuffer;
 	}
 	info->apertures->ranges[0].base = screen_info.lfb_base;
 	info->apertures->ranges[0].size = size_total;
@@ -462,7 +462,7 @@ static int vesafb_probe(struct platform_device *dev)
 		       "vesafb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
 			vesafb_fix.smem_len, vesafb_fix.smem_start);
 		err = -EIO;
-		goto err;
+		goto release_framebuffer;
 	}
 
 	printk(KERN_INFO "vesafb: framebuffer at 0x%lx, mapped to 0x%p, "
@@ -492,6 +492,7 @@ static int vesafb_probe(struct platform_device *dev)
 	return 0;
 err:
 	iounmap(info->screen_base);
+release_framebuffer:
 	framebuffer_release(info);
 	release_mem_region(vesafb_fix.smem_start, size_total);
 	return err;
-- 
2.2.2

