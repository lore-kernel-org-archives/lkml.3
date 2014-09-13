Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaIMAmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 20:42:01 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:49853 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaIMAmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 20:42:00 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <6d686c60ef357a02a2011c0512439aa5>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH 3/5] ASoC: rockchip-i2s: add dma data to snd_soc_dai
Date: Sat, 13 Sep 2014 08:41:38 +0800
Message-Id: <1410568898-21773-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add playback/capture dma data to snd_soc_dai.
Test on RK3288 with max98090.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
---
 sound/soc/rockchip/rockchip_i2s.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
index 870a664..1b9b404 100644
--- a/sound/soc/rockchip/rockchip_i2s.c
+++ b/sound/soc/rockchip/rockchip_i2s.c
@@ -244,16 +244,6 @@ static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
 	regmap_update_bits(i2s->regmap, I2S_TXCR, I2S_TXCR_VDW_MASK, val);
 	regmap_update_bits(i2s->regmap, I2S_RXCR, I2S_RXCR_VDW_MASK, val);
 
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		dai->playback_dma_data = &i2s->playback_dma_data;
-		regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_TDL_MASK,
-				   I2S_DMACR_TDL(1) | I2S_DMACR_TDE_ENABLE);
-	} else {
-		dai->capture_dma_data = &i2s->capture_dma_data;
-		regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_RDL_MASK,
-				   I2S_DMACR_RDL(1) | I2S_DMACR_RDE_ENABLE);
-	}
-
 	return 0;
 }
 
@@ -301,6 +291,16 @@ static int rockchip_i2s_set_sysclk(struct snd_soc_dai *cpu_dai, int clk_id,
 	return ret;
 }
 
+static int rockchip_i2s_dai_probe(struct snd_soc_dai *dai)
+{
+	struct rk_i2s_dev *i2s = snd_soc_dai_get_drvdata(dai);
+
+	dai->capture_dma_data = &i2s->capture_dma_data;
+	dai->playback_dma_data = &i2s->playback_dma_data;
+
+	return 0;
+}
+
 static const struct snd_soc_dai_ops rockchip_i2s_dai_ops = {
 	.hw_params = rockchip_i2s_hw_params,
 	.set_sysclk = rockchip_i2s_set_sysclk,
@@ -309,7 +309,9 @@ static const struct snd_soc_dai_ops rockchip_i2s_dai_ops = {
 };
 
 static struct snd_soc_dai_driver rockchip_i2s_dai = {
+	.probe = rockchip_i2s_dai_probe,
 	.playback = {
+		.stream_name = "Playback",
 		.channels_min = 2,
 		.channels_max = 8,
 		.rates = SNDRV_PCM_RATE_8000_192000,
@@ -319,6 +321,7 @@ static struct snd_soc_dai_driver rockchip_i2s_dai = {
 			    SNDRV_PCM_FMTBIT_S24_LE),
 	},
 	.capture = {
+		.stream_name = "Capture",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_192000,
-- 
1.9.1


