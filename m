Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaLCQjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:39:23 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:42717 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbaLCQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:39:22 -0500
Message-ID: <547F3C96.9070509@arm.com>
Date: Wed, 03 Dec 2014 16:38:46 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: [PATCH 1/5] ASoC: dwc: Allocate resources with devm_ioremap_resource
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for the introduction of device-tree support by re-ordering some
of the allocations and using devm_iomap_resource to simplify IO mapping.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |   46 ++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index e961388..08f0229 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -338,31 +338,34 @@ static int dw_i2s_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no i2s resource defined\n");
-		return -ENODEV;
-	}
-
-	if (!devm_request_mem_region(&pdev->dev, res->start,
-				resource_size(res), pdev->name)) {
-		dev_err(&pdev->dev, "i2s region already claimed\n");
-		return -EBUSY;
-	}
-
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_warn(&pdev->dev, "kzalloc fail\n");
 		return -ENOMEM;
 	}
 
-	dev->i2s_base = devm_ioremap(&pdev->dev, res->start,
-			resource_size(res));
-	if (!dev->i2s_base) {
-		dev_err(&pdev->dev, "ioremap fail for i2s_region\n");
+	dw_i2s_dai = devm_kzalloc(&pdev->dev, sizeof(*dw_i2s_dai), GFP_KERNEL);
+	if (!dw_i2s_dai) {
+		dev_err(&pdev->dev, "mem allocation failed for dai driver\n");
 		return -ENOMEM;
 	}
 
+	dw_i2s_dai->ops = &dw_i2s_dai_ops;
+	dw_i2s_dai->suspend = dw_i2s_suspend;
+	dw_i2s_dai->resume = dw_i2s_resume;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no i2s resource defined\n");
+		return -ENODEV;
+	}
+
+	dev->i2s_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(dev->i2s_base)) {
+		dev_err(&pdev->dev, "ioremap fail for i2s_region\n");
+		return PTR_ERR(dev->i2s_base);
+	}
+
 	cap = pdata->cap;
 	dev->capability = cap;
 	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
@@ -388,13 +391,6 @@ static int dw_i2s_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_clk_put;
 
-	dw_i2s_dai = devm_kzalloc(&pdev->dev, sizeof(*dw_i2s_dai), GFP_KERNEL);
-	if (!dw_i2s_dai) {
-		dev_err(&pdev->dev, "mem allocation failed for dai driver\n");
-		ret = -ENOMEM;
-		goto err_clk_disable;
-	}
-
 	if (cap & DWC_I2S_PLAY) {
 		dev_dbg(&pdev->dev, " designware: play supported\n");
 		dw_i2s_dai->playback.channels_min = MIN_CHANNEL_NUM;
@@ -411,10 +407,6 @@ static int dw_i2s_probe(struct platform_device *pdev)
 		dw_i2s_dai->capture.rates = pdata->snd_rates;
 	}
 
-	dw_i2s_dai->ops = &dw_i2s_dai_ops;
-	dw_i2s_dai->suspend = dw_i2s_suspend;
-	dw_i2s_dai->resume = dw_i2s_resume;
-
 	dev->dev = &pdev->dev;
 	dev_set_drvdata(&pdev->dev, dev);
 	ret = snd_soc_register_component(&pdev->dev, &dw_i2s_component,
-- 
1.7.1

