Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbbASSrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:47:04 -0500
Received: from mout.web.de ([212.227.15.4]:58801 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbbASSrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:47:02 -0500
Message-ID: <54BD5121.8010801@users.sourceforge.net>
Date: Mon, 19 Jan 2015 19:46:57 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 8/9] video: Less function calls in valkyriefb_init() after
 error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54BD44F0.3040705@users.sourceforge.net>
In-Reply-To: <54BD44F0.3040705@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:6MCkPSPmJ/WIu3vGeAbzDL+Fxwes5xdXj2NhoqwMt8zdMukrdhN
 OHv+9GrIZSa+yxuhusODBDfHYhQc1aFS6Hi9ojeV8zKA01+9jUwRIS5K/ETO3R/sNjobWeu
 tJbfUP1a3mkqGSeJ2cQifOcv9RqzSJ/EVFlMzNDyJKwY9DrxTESFyVYyrUiCJu7SQgZgUL6
 zkpL/zRaFJvgYiCdRuU2w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 19 Jan 2015 17:01:25 +0100

The iounmap() function could be called in three cases by the valkyriefb_init()
function during error handling even if the passed data structure element
contained still a null pointer.

This implementation detail could be improved by adjustments for jump labels
(according also to current Linux coding style) and error messages.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/valkyriefb.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/video/fbdev/valkyriefb.c b/drivers/video/fbdev/valkyriefb.c
index 2a9213b..a81a0f1 100644
--- a/drivers/video/fbdev/valkyriefb.c
+++ b/drivers/video/fbdev/valkyriefb.c
@@ -369,40 +369,50 @@ int __init valkyriefb_init(void)
 	}
 	p->total_vram = 0x100000;
 	p->frame_buffer_phys = frame_buffer_phys;
+	err = -ENOMEM;
 	p->frame_buffer = __ioremap(frame_buffer_phys, p->total_vram, flags);
+	if (p->frame_buffer == NULL) {
+		pr_err("%s: %s failed\n", __func__, "Frame buffer mapping");
+		goto free_memory;
+	}
 	p->cmap_regs_phys = cmap_regs_phys;
 	p->cmap_regs = ioremap(p->cmap_regs_phys, 0x1000);
+	if (p->cmap_regs == NULL) {
+		pr_err("%s: %s failed\n", __func__, "cmap");
+		goto io_unmap_framebuffer;
+	}
 	p->valkyrie_regs_phys = cmap_regs_phys+0x6000;
 	p->valkyrie_regs = ioremap(p->valkyrie_regs_phys, 0x1000);
-	err = -ENOMEM;
-	if (p->frame_buffer == NULL || p->cmap_regs == NULL
-	    || p->valkyrie_regs == NULL) {
-		printk(KERN_ERR "valkyriefb: couldn't map resources\n");
-		goto out_free;
+	if (p->valkyrie_regs == NULL) {
+		pr_err("%s: %s failed\n", __func__, "ioremap");
+		goto io_unmap_cmap;
 	}
 
 	valkyrie_choose_mode(p);
 	mac_vmode_to_var(default_vmode, default_cmode, &p->info.var);
 	err = valkyrie_init_info(&p->info, p);
 	if (err < 0)
-		goto out_free;
+		goto io_unmap_valkyrie;
 	valkyrie_init_fix(&p->info.fix, p);
 	if (valkyriefb_set_par(&p->info))
 		/* "can't happen" */
 		printk(KERN_ERR "valkyriefb: can't set default video mode\n");
 
 	if ((err = register_framebuffer(&p->info)) != 0)
-		goto out_cmap_free;
+		goto dealloc_cmap;
 
 	fb_info(&p->info, "valkyrie frame buffer device\n");
 	return 0;
 
- out_cmap_free:
+dealloc_cmap:
 	fb_dealloc_cmap(&p->info.cmap);
- out_free:
-	iounmap(p->frame_buffer);
-	iounmap(p->cmap_regs);
+io_unmap_valkyrie:
 	iounmap(p->valkyrie_regs);
+io_unmap_cmap:
+	iounmap(p->cmap_regs);
+io_unmap_framebuffer:
+	iounmap(p->frame_buffer);
+free_memory:
 	kfree(p);
 	return err;
 }
-- 
2.2.2

