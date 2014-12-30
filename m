Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaL3K5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:57:48 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:46502 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752098AbaL3K4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:56:45 -0500
From: Andrew Jackson <andrew.jackson@arm.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/6] ASoC: dwc: Switch to managed clock resource
Date: Tue, 30 Dec 2014 10:55:43 +0000
Message-Id: <af6e23a9f11ead4b8abd1f70dbf634964253b37f.1419936132.git.Andrew.Jackson@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1419936132.git.Andrew.Jackson@arm.com>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
In-Reply-To: <cover.1419936132.git.Andrew.Jackson@arm.com>
References: <cover.1419936132.git.Andrew.Jackson@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jackson <Andrew.Jackson@arm.com>

Simplify error handling during probe by using managed clock
resources.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 sound/soc/dwc/designware_i2s.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
index 06d3a34..5e9d163 100644
--- a/sound/soc/dwc/designware_i2s.c
+++ b/sound/soc/dwc/designware_i2s.c
@@ -407,13 +407,13 @@ static int dw_i2s_probe(struct platform_device *pdev)
 
 	dev->capability = pdata->cap;
 	dev->i2s_clk_cfg = pdata->i2s_clk_cfg;
-	dev->clk = clk_get(&pdev->dev, NULL);
+	dev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk))
 		return  PTR_ERR(dev->clk);
 
 	ret = clk_enable(dev->clk);
 	if (ret < 0)
-		goto err_clk_put;
+		return ret;
 
 	dev_set_drvdata(&pdev->dev, dev);
 	ret = snd_soc_register_component(&pdev->dev, &dw_i2s_component,
@@ -427,19 +427,13 @@ static int dw_i2s_probe(struct platform_device *pdev)
 
 err_clk_disable:
 	clk_disable(dev->clk);
-err_clk_put:
-	clk_put(dev->clk);
 	return ret;
 }
 
 static int dw_i2s_remove(struct platform_device *pdev)
 {
-	struct dw_i2s_dev *dev = dev_get_drvdata(&pdev->dev);
-
 	snd_soc_unregister_component(&pdev->dev);
 
-	clk_put(dev->clk);
-
 	return 0;
 }
 
-- 
1.7.1

