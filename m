Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab3EMJAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:00:46 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:58711 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3EMJAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:00:45 -0400
MIME-Version: 1.0
Date: Mon, 13 May 2013 17:00:44 +0800
Message-ID: <CAPgLHd_RTomuGFrwReDt6w9q+nH376W=6hHD4qZ4PGQXRGnJqA@mail.gmail.com>
Subject: [PATCH -next] ASoC: mid-x86: add missing iounmap() to probe error and remove
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        wfp5p@virginia.edu, vinod.koul@linux.intel.com, ramesh.babu@intel.com,
        namartax.kohli@intel.com
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing iounmap() before return from snd_mfld_mc_probe()
in the error handling case and to snd_mfld_mc_remove().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/mid-x86/mfld_machine.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mid-x86/mfld_machine.c b/sound/soc/mid-x86/mfld_machine.c
index 78d5825..8206e84 100644
--- a/sound/soc/mid-x86/mfld_machine.c
+++ b/sound/soc/mid-x86/mfld_machine.c
@@ -397,7 +397,7 @@ static int snd_mfld_mc_probe(struct platform_device *pdev)
 			IRQF_SHARED, pdev->dev.driver->name, mc_drv_ctx);
 	if (ret_val) {
 		pr_err("cannot register IRQ\n");
-		goto unalloc;
+		goto unmap;
 	}
 	/* register the soc card */
 	snd_soc_card_mfld.dev = &pdev->dev;
@@ -412,6 +412,8 @@ static int snd_mfld_mc_probe(struct platform_device *pdev)
 
 freeirq:
 	free_irq(irq, mc_drv_ctx);
+unmap:
+	iounmap(mc_drv_ctx->int_base);
 unalloc:
 	kfree(mc_drv_ctx);
 	return ret_val;
@@ -424,6 +426,7 @@ static int snd_mfld_mc_remove(struct platform_device *pdev)
 	pr_debug("snd_mfld_mc_remove called\n");
 	free_irq(platform_get_irq(pdev, 0), mc_drv_ctx);
 	snd_soc_unregister_card(&snd_soc_card_mfld);
+	iounmap(mc_drv_ctx->int_base);
 	kfree(mc_drv_ctx);
 	return 0;
 }

