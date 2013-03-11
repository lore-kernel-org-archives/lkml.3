Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3CKP7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:59:05 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57951 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3CKP7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:59:03 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-omap@vger.kernel.org
Cc: peter.ujfalusi@ti.com, jarkko.nikula@bitmer.com, lgirdwood@gmail.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] omap: convert to devm_ioremap_resource()
Date: Mon, 11 Mar 2013 17:58:57 +0200
Message-Id: <1363017537-11602-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 sound/soc/omap/omap-dmic.c  |    9 +++------
 sound/soc/omap/omap-mcpdm.c |    8 +++-----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
index 77e9e7e..8ebaf11 100644
--- a/sound/soc/omap/omap-dmic.c
+++ b/sound/soc/omap/omap-dmic.c
@@ -493,12 +493,9 @@ static int asoc_dmic_probe(struct platform_device *pdev)
 		goto err_put_clk;
 	}
 
-	dmic->io_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!dmic->io_base) {
-		dev_err(&pdev->dev, "cannot remap\n");
-		ret = -ENOMEM;
-		goto err_put_clk;
-	}
+	dmic->io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dmic->io_base))
+		return PTR_ERR(dmic->io_base);
 
 	ret = snd_soc_register_dai(&pdev->dev, &omap_dmic_dai);
 	if (ret)
diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
index 079f277..ddfcc18 100644
--- a/sound/soc/omap/omap-mcpdm.c
+++ b/sound/soc/omap/omap-mcpdm.c
@@ -464,11 +464,9 @@ static int asoc_mcpdm_probe(struct platform_device *pdev)
 	if (res == NULL)
 		return -ENOMEM;
 
-	mcpdm->io_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!mcpdm->io_base) {
-		dev_err(&pdev->dev, "cannot remap\n");
-		return -ENOMEM;
-	}
+	mcpdm->io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mcpdm->io_base))
+		return PTR_ERR(mcpdm->io_base);
 
 	mcpdm->irq = platform_get_irq(pdev, 0);
 	if (mcpdm->irq < 0)
-- 
1.7.9.5

