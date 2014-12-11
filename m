Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942AbaLKHoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 02:44:14 -0500
Received: from atl4mhob04.myregisteredsite.com ([209.17.115.42]:55434 "EHLO
	atl4mhob04.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188AbaLKHoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 02:44:13 -0500
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: lars@metafoo.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: [PATCH v3] sound/soc/adi/axi-spdif.c: Support programmable master clock
Date: Thu, 11 Dec 2014 08:44:07 +0100
Message-Id: <1418283847-25673-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <54893D3D.8050100@topic.nl>
References: <54893D3D.8050100@topic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the master clock supports programmable rates, program it to generate
the desired frequency. Only apply constraints when the clock is fixed.
This allows proper clock generation for both 44100 and 48000 Hz based
sampling rates if the platform supports it.

The clock frequency must be set before enabling it. Enabling the clock
was done in "startup", but that occurs before "hw_params" where the rate
is known. Enabling a programmable clock without first setting a valid
frequency may harm the system. Move the clock start to the hw_params
routine, and keep track of whether the clock has been started, because
shutdown may be called without having called hw_params first, and
hw_params may be called multiple times.
Starting the clock and enabling the SPDIF output AFTER programming the
dividers is a more logical order anyway.

To detect if the source clock is fixed, the driver calls clk_round_rate
for two frequencies. If the results are equal, or if the call returns
an error, the driver assumes the clock is fixed.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
---
v3: Only enable clock once in hw_params which may be called multiple times.

 sound/soc/adi/axi-spdif.c |   62 +++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/sound/soc/adi/axi-spdif.c b/sound/soc/adi/axi-spdif.c
index 198e3a4..d8a98a9 100644
--- a/sound/soc/adi/axi-spdif.c
+++ b/sound/soc/adi/axi-spdif.c
@@ -4,7 +4,6 @@
  *
  * Licensed under the GPL-2.
  */
-
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -44,6 +43,8 @@ struct axi_spdif {
 
 	struct snd_ratnum ratnum;
 	struct snd_pcm_hw_constraint_ratnums rate_constraints;
+
+	bool clk_ref_running;
 };
 
 static int axi_spdif_trigger(struct snd_pcm_substream *substream, int cmd,
@@ -79,6 +80,7 @@ static int axi_spdif_hw_params(struct snd_pcm_substream *substream,
 	struct axi_spdif *spdif = snd_soc_dai_get_drvdata(dai);
 	unsigned int rate = params_rate(params);
 	unsigned int clkdiv, stat;
+	int ret;
 
 	switch (params_rate(params)) {
 	case 32000:
@@ -95,6 +97,9 @@ static int axi_spdif_hw_params(struct snd_pcm_substream *substream,
 		break;
 	}
 
+	/* Try to set the master clock */
+	clk_set_rate(spdif->clk_ref, rate * 128);
+
 	clkdiv = DIV_ROUND_CLOSEST(clk_get_rate(spdif->clk_ref),
 			rate * 64 * 2) - 1;
 	clkdiv <<= AXI_SPDIF_CTRL_CLKDIV_OFFSET;
@@ -103,6 +108,16 @@ static int axi_spdif_hw_params(struct snd_pcm_substream *substream,
 	regmap_update_bits(spdif->regmap, AXI_SPDIF_REG_CTRL,
 		AXI_SPDIF_CTRL_CLKDIV_MASK, clkdiv);
 
+	if (!spdif->clk_ref_running) {
+		ret = clk_prepare_enable(spdif->clk_ref);
+		if (ret)
+			return ret;
+		spdif->clk_ref_running = true;
+	}
+
+	regmap_update_bits(spdif->regmap, AXI_SPDIF_REG_CTRL,
+		AXI_SPDIF_CTRL_TXEN, AXI_SPDIF_CTRL_TXEN);
+
 	return 0;
 }
 
@@ -121,18 +136,13 @@ static int axi_spdif_startup(struct snd_pcm_substream *substream,
 	struct axi_spdif *spdif = snd_soc_dai_get_drvdata(dai);
 	int ret;
 
-	ret = snd_pcm_hw_constraint_ratnums(substream->runtime, 0,
-			   SNDRV_PCM_HW_PARAM_RATE,
-			   &spdif->rate_constraints);
-	if (ret)
-		return ret;
-
-	ret = clk_prepare_enable(spdif->clk_ref);
-	if (ret)
-		return ret;
-
-	regmap_update_bits(spdif->regmap, AXI_SPDIF_REG_CTRL,
-		AXI_SPDIF_CTRL_TXEN, AXI_SPDIF_CTRL_TXEN);
+	if (spdif->rate_constraints.nrats) {
+		ret = snd_pcm_hw_constraint_ratnums(substream->runtime, 0,
+				SNDRV_PCM_HW_PARAM_RATE,
+				&spdif->rate_constraints);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
@@ -145,7 +155,10 @@ static void axi_spdif_shutdown(struct snd_pcm_substream *substream,
 	regmap_update_bits(spdif->regmap, AXI_SPDIF_REG_CTRL,
 		AXI_SPDIF_CTRL_TXEN, 0);
 
-	clk_disable_unprepare(spdif->clk_ref);
+	if (spdif->clk_ref_running) {
+		clk_disable_unprepare(spdif->clk_ref);
+		spdif->clk_ref_running = false;
+	}
 }
 
 static const struct snd_soc_dai_ops axi_spdif_dai_ops = {
@@ -183,6 +196,7 @@ static int axi_spdif_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	int ret;
+	long rate;
 
 	spdif = devm_kzalloc(&pdev->dev, sizeof(*spdif), GFP_KERNEL);
 	if (!spdif)
@@ -216,14 +230,18 @@ static int axi_spdif_probe(struct platform_device *pdev)
 	spdif->dma_data.addr_width = 4;
 	spdif->dma_data.maxburst = 1;
 
-	spdif->ratnum.num = clk_get_rate(spdif->clk_ref) / 128;
-	spdif->ratnum.den_step = 1;
-	spdif->ratnum.den_min = 1;
-	spdif->ratnum.den_max = 64;
-
-	spdif->rate_constraints.rats = &spdif->ratnum;
-	spdif->rate_constraints.nrats = 1;
-
+	/* Determine if the clock rate is fixed. If it cannot change frequency,
+	 * it returns an error or it will simply return its fixed value. */
+	rate = clk_round_rate(spdif->clk_ref, 128 * 44100);
+	if (rate < 0 || rate != clk_round_rate(spdif->clk_ref, 128 * 48000)) {
+		spdif->ratnum.num = clk_get_rate(spdif->clk_ref) / 128;
+		spdif->ratnum.den_step = 1;
+		spdif->ratnum.den_min = 1;
+		spdif->ratnum.den_max = 64;
+
+		spdif->rate_constraints.rats = &spdif->ratnum;
+		spdif->rate_constraints.nrats = 1;
+	}
 	ret = devm_snd_soc_register_component(&pdev->dev, &axi_spdif_component,
 					 &axi_spdif_dai, 1);
 	if (ret)
-- 
1.7.9.5

