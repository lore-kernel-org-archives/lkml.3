Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaJXXsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:48:31 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50549 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaJXXs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 19:48:26 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org, b02247@freescale.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com
Subject: [PATCH 1/2] ASoC: fsl_esai: Use dynamic slot width as default
Date: Fri, 24 Oct 2014 16:48:12 -0700
Message-Id: <c8831e1a3245dc68a27d3fa1ecd9fd4fedb23df3.1414193668.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1414193668.git.nicoleotsuka@gmail.com>
References: <cover.1414193668.git.nicoleotsuka@gmail.com>
In-Reply-To: <cover.1414193668.git.nicoleotsuka@gmail.com>
References: <cover.1414193668.git.nicoleotsuka@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver previously used 32-bit fixed slot width as default.
In result, ESAI might use 32-bit length to capture 16-bit width
audio slot from CODEC side when ESAI is running as DAI slave.

So this patch just removes the default slot_width so as to use
dynamic slot width. If there comes a specific situation that
needs a fixed width, the machine driver shall set slot_width
via set_tdm_slot() so as to let the ESAI driver replace the
dynamic width policy with the fixed value.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl_esai.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
index a645e29..ca319d5 100644
--- a/sound/soc/fsl/fsl_esai.c
+++ b/sound/soc/fsl/fsl_esai.c
@@ -513,10 +513,15 @@ static int fsl_esai_hw_params(struct snd_pcm_substream *substream,
 	u32 width = snd_pcm_format_width(params_format(params));
 	u32 channels = params_channels(params);
 	u32 pins = DIV_ROUND_UP(channels, esai_priv->slots);
+	u32 slot_width = width;
 	u32 bclk, mask, val;
 	int ret;
 
-	bclk = params_rate(params) * esai_priv->slot_width * esai_priv->slots;
+	/* Override slot_width if being specifially set */
+	if (esai_priv->slot_width)
+		slot_width = esai_priv->slot_width;
+
+	bclk = params_rate(params) * slot_width * esai_priv->slots;
 
 	ret = fsl_esai_set_bclk(dai, tx, bclk);
 	if (ret)
@@ -538,7 +543,7 @@ static int fsl_esai_hw_params(struct snd_pcm_substream *substream,
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_xFCR(tx), mask, val);
 
 	mask = ESAI_xCR_xSWS_MASK | (tx ? ESAI_xCR_PADC : 0);
-	val = ESAI_xCR_xSWS(esai_priv->slot_width, width) | (tx ? ESAI_xCR_PADC : 0);
+	val = ESAI_xCR_xSWS(slot_width, width) | (tx ? ESAI_xCR_PADC : 0);
 
 	regmap_update_bits(esai_priv->regmap, REG_ESAI_xCR(tx), mask, val);
 
@@ -780,9 +785,6 @@ static int fsl_esai_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	/* Set a default slot size */
-	esai_priv->slot_width = 32;
-
 	/* Set a default slot number */
 	esai_priv->slots = 2;
 
-- 
1.9.1

