Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaEUDYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:24:51 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33827 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaEUDYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:24:48 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        sbkim73@samsung.com, kgene.kim@samsung.com
Subject: [PATCH 4/4] ASoC: samsung: Add devm_clk_get to pcm.c
Date: Wed, 21 May 2014 08:52:20 +0530
Message-Id: <1400642540-24375-5-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
References: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get in probe function can be safely replaced with devm_clk_get.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/samsung/pcm.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/sound/soc/samsung/pcm.c b/sound/soc/samsung/pcm.c
index 90fcd52..a3c9c9c 100644
--- a/sound/soc/samsung/pcm.c
+++ b/sound/soc/samsung/pcm.c
@@ -542,7 +542,7 @@ static int s3c_pcm_dev_probe(struct platform_device *pdev)
 	/* Default is 128fs */
 	pcm->sclk_per_fs = 128;
 
-	pcm->cclk = clk_get(&pdev->dev, "audio-bus");
+	pcm->cclk = devm_clk_get(&pdev->dev, "audio-bus");
 	if (IS_ERR(pcm->cclk)) {
 		dev_err(&pdev->dev, "failed to get audio-bus\n");
 		ret = PTR_ERR(pcm->cclk);
@@ -567,7 +567,7 @@ static int s3c_pcm_dev_probe(struct platform_device *pdev)
 		goto err3;
 	}
 
-	pcm->pclk = clk_get(&pdev->dev, "pcm");
+	pcm->pclk = devm_clk_get(&pdev->dev, "pcm");
 	if (IS_ERR(pcm->pclk)) {
 		dev_err(&pdev->dev, "failed to get pcm_clock\n");
 		ret = -ENOENT;
@@ -605,14 +605,12 @@ static int s3c_pcm_dev_probe(struct platform_device *pdev)
 
 err5:
 	clk_disable_unprepare(pcm->pclk);
-	clk_put(pcm->pclk);
 err4:
 	iounmap(pcm->regs);
 err3:
 	release_mem_region(mem_res->start, resource_size(mem_res));
 err2:
 	clk_disable_unprepare(pcm->cclk);
-	clk_put(pcm->cclk);
 err1:
 	return ret;
 }
@@ -631,8 +629,6 @@ static int s3c_pcm_dev_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(pcm->cclk);
 	clk_disable_unprepare(pcm->pclk);
-	clk_put(pcm->pclk);
-	clk_put(pcm->cclk);
 
 	return 0;
 }
-- 
1.7.9.5

