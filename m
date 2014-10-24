Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaJXXs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:48:29 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46754 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbaJXXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 19:48:27 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: broonie@kernel.org, b02247@freescale.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com
Subject: [PATCH 2/2] ASoC: fsl-asoc-card: Add slot_width setting for cpu-dai
Date: Fri, 24 Oct 2014 16:48:13 -0700
Message-Id: <3c45318a95056000736874fe7cc0a26922b742e1.1414193668.git.nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1414193668.git.nicoleotsuka@gmail.com>
References: <cover.1414193668.git.nicoleotsuka@gmail.com>
In-Reply-To: <cover.1414193668.git.nicoleotsuka@gmail.com>
References: <cover.1414193668.git.nicoleotsuka@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ESAI may need to use fixed slot width to comply with external
CODEC. So this set_tdm_slot() call will allow the ESAI driver
to override its default dynamic slot width policy.

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 sound/soc/fsl/fsl-asoc-card.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 14572e6..3f6959c 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -51,6 +51,7 @@ struct codec_priv {
  * @sysclk_freq[2]: SYSCLK rates for set_sysclk()
  * @sysclk_dir[2]: SYSCLK directions for set_sysclk()
  * @sysclk_id[2]: SYSCLK ids for set_sysclk()
+ * @slot_width: Slot width of each frame
  *
  * Note: [1] for tx and [0] for rx
  */
@@ -58,6 +59,7 @@ struct cpu_priv {
 	unsigned long sysclk_freq[2];
 	u32 sysclk_dir[2];
 	u32 sysclk_id[2];
+	u32 slot_width;
 };
 
 /**
@@ -142,6 +144,15 @@ static int fsl_asoc_card_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
+	if (cpu_priv->slot_width) {
+		ret = snd_soc_dai_set_tdm_slot(rtd->cpu_dai, 0x3, 0x3, 2,
+					       cpu_priv->slot_width);
+		if (ret) {
+			dev_err(dev, "failed to set TDM slot for cpu dai\n");
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -453,6 +464,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		priv->cpu_priv.sysclk_freq[RX] = priv->codec_priv.mclk_freq;
 		priv->cpu_priv.sysclk_dir[TX] = SND_SOC_CLOCK_OUT;
 		priv->cpu_priv.sysclk_dir[RX] = SND_SOC_CLOCK_OUT;
+		priv->cpu_priv.slot_width = 32;
 		priv->dai_fmt |= SND_SOC_DAIFMT_CBS_CFS;
 	} else if (of_device_is_compatible(np, "fsl,imx-audio-sgtl5000")) {
 		priv->codec_priv.mclk_id = SGTL5000_SYSCLK;
-- 
1.9.1

