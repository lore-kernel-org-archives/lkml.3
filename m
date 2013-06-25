Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab3FYCQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:16:59 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63015 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:16:58 -0400
MIME-Version: 1.0
Date: Tue, 25 Jun 2013 10:16:56 +0800
Message-ID: <CAPgLHd89RzJrpMEs+zR8cQvGHruWvne8e0kGb1LeCqoHdKogHA@mail.gmail.com>
Subject: [PATCH -next] ASoC: mid-x86: Convert to use devm_* APIs
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

devm_* APIs are device managed and make code simpler.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/mid-x86/mfld_machine.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/sound/soc/mid-x86/mfld_machine.c b/sound/soc/mid-x86/mfld_machine.c
index 78d5825..e16bcd1 100644
--- a/sound/soc/mid-x86/mfld_machine.c
+++ b/sound/soc/mid-x86/mfld_machine.c
@@ -371,7 +371,7 @@ static int snd_mfld_mc_probe(struct platform_device *pdev)
 
 	/* audio interrupt base of SRAM location where
 	 * interrupts are stored by System FW */
-	mc_drv_ctx = kzalloc(sizeof(*mc_drv_ctx), GFP_ATOMIC);
+	mc_drv_ctx = devm_kzalloc(&pdev->dev, sizeof(*mc_drv_ctx), GFP_ATOMIC);
 	if (!mc_drv_ctx) {
 		pr_err("allocation failed\n");
 		return -ENOMEM;
@@ -381,40 +381,33 @@ static int snd_mfld_mc_probe(struct platform_device *pdev)
 				pdev, IORESOURCE_MEM, "IRQ_BASE");
 	if (!irq_mem) {
 		pr_err("no mem resource given\n");
-		ret_val = -ENODEV;
-		goto unalloc;
+		return -ENODEV;
 	}
-	mc_drv_ctx->int_base = ioremap_nocache(irq_mem->start,
-					resource_size(irq_mem));
+	mc_drv_ctx->int_base = devm_ioremap_nocache(&pdev->dev, irq_mem->start,
+						    resource_size(irq_mem));
 	if (!mc_drv_ctx->int_base) {
 		pr_err("Mapping of cache failed\n");
-		ret_val = -ENOMEM;
-		goto unalloc;
+		return -ENOMEM;
 	}
 	/* register for interrupt */
-	ret_val = request_threaded_irq(irq, snd_mfld_jack_intr_handler,
+	ret_val = devm_request_threaded_irq(&pdev->dev, irq,
+			snd_mfld_jack_intr_handler,
 			snd_mfld_jack_detection,
 			IRQF_SHARED, pdev->dev.driver->name, mc_drv_ctx);
 	if (ret_val) {
 		pr_err("cannot register IRQ\n");
-		goto unalloc;
+		return ret_val;
 	}
 	/* register the soc card */
 	snd_soc_card_mfld.dev = &pdev->dev;
 	ret_val = snd_soc_register_card(&snd_soc_card_mfld);
 	if (ret_val) {
 		pr_debug("snd_soc_register_card failed %d\n", ret_val);
-		goto freeirq;
+		return ret_val;
 	}
 	platform_set_drvdata(pdev, mc_drv_ctx);
 	pr_debug("successfully exited probe\n");
-	return ret_val;
-
-freeirq:
-	free_irq(irq, mc_drv_ctx);
-unalloc:
-	kfree(mc_drv_ctx);
-	return ret_val;
+	return 0;
 }
 
 static int snd_mfld_mc_remove(struct platform_device *pdev)
@@ -422,9 +415,7 @@ static int snd_mfld_mc_remove(struct platform_device *pdev)
 	struct mfld_mc_private *mc_drv_ctx = platform_get_drvdata(pdev);
 
 	pr_debug("snd_mfld_mc_remove called\n");
-	free_irq(platform_get_irq(pdev, 0), mc_drv_ctx);
 	snd_soc_unregister_card(&snd_soc_card_mfld);
-	kfree(mc_drv_ctx);
 	return 0;
 }
 

