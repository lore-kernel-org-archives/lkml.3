Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaGVKmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:42:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48393 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbaGVKmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:42:14 -0400
Date: Tue, 22 Jul 2014 11:42:06 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com, broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ASoC: arizona: Disable AIF TX/RX before configuring it
Message-ID: <20140722104206.GA19663@opensource.wolfsonmicro.com>
References: <20140716121029.GA22222@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716121029.GA22222@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to the AIF configuration registers only take
effect when the AIF is disabled. If the configuration
is being changed from the previous setup, temporarily
disable the AIF.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/arizona.c |   87 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index fb30c82..bd41ee4 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -1234,6 +1234,27 @@ static int arizona_hw_params_rate(struct snd_pcm_substream *substream,
 	return 0;
 }
 
+static bool arizona_aif_cfg_changed(struct snd_soc_codec *codec,
+				    int base, int bclk, int lrclk, int frame)
+{
+	int val;
+
+	val = snd_soc_read(codec, base + ARIZONA_AIF_BCLK_CTRL);
+	if (bclk != (val & ARIZONA_AIF1_BCLK_FREQ_MASK))
+		return true;
+
+	val = snd_soc_read(codec, base + ARIZONA_AIF_TX_BCLK_RATE);
+	if (lrclk != (val & ARIZONA_AIF1TX_BCPF_MASK))
+		return true;
+
+	val = snd_soc_read(codec, base + ARIZONA_AIF_FRAME_CTRL_1);
+	if (frame != (val & (ARIZONA_AIF1TX_WL_MASK |
+			     ARIZONA_AIF1TX_SLOT_LEN_MASK)))
+		return true;
+
+	return false;
+}
+
 static int arizona_hw_params(struct snd_pcm_substream *substream,
 			     struct snd_pcm_hw_params *params,
 			     struct snd_soc_dai *dai)
@@ -1249,6 +1270,8 @@ static int arizona_hw_params(struct snd_pcm_substream *substream,
 	int tdm_width = arizona->tdm_width[dai->id - 1];
 	int tdm_slots = arizona->tdm_slots[dai->id - 1];
 	int bclk, lrclk, wl, frame, bclk_target;
+	bool reconfig;
+	unsigned int aif_tx_state, aif_rx_state;
 
 	if (params_rate(params) % 8000)
 		rates = &arizona_44k1_bclk_rates[0];
@@ -1299,28 +1322,56 @@ static int arizona_hw_params(struct snd_pcm_substream *substream,
 	wl = snd_pcm_format_width(params_format(params));
 	frame = wl << ARIZONA_AIF1TX_WL_SHIFT | wl;
 
+	reconfig = arizona_aif_cfg_changed(codec, base, bclk, lrclk, frame);
+
+	if (reconfig) {
+		/* Save AIF TX/RX state */
+		aif_tx_state = snd_soc_read(codec,
+					    base + ARIZONA_AIF_TX_ENABLES);
+		aif_rx_state = snd_soc_read(codec,
+					    base + ARIZONA_AIF_RX_ENABLES);
+		/* Disable AIF TX/RX before reconfiguring it */
+		regmap_update_bits_async(arizona->regmap,
+				    base + ARIZONA_AIF_TX_ENABLES, 0xff, 0x0);
+		regmap_update_bits(arizona->regmap,
+				    base + ARIZONA_AIF_RX_ENABLES, 0xff, 0x0);
+	}
+
 	ret = arizona_hw_params_rate(substream, params, dai);
 	if (ret != 0)
-		return ret;
+		goto restore_aif;
 
-	regmap_update_bits_async(arizona->regmap,
-				 base + ARIZONA_AIF_BCLK_CTRL,
-				 ARIZONA_AIF1_BCLK_FREQ_MASK, bclk);
-	regmap_update_bits_async(arizona->regmap,
-				 base + ARIZONA_AIF_TX_BCLK_RATE,
-				 ARIZONA_AIF1TX_BCPF_MASK, lrclk);
-	regmap_update_bits_async(arizona->regmap,
-				 base + ARIZONA_AIF_RX_BCLK_RATE,
-				 ARIZONA_AIF1RX_BCPF_MASK, lrclk);
-	regmap_update_bits_async(arizona->regmap,
-				 base + ARIZONA_AIF_FRAME_CTRL_1,
-				 ARIZONA_AIF1TX_WL_MASK |
-				 ARIZONA_AIF1TX_SLOT_LEN_MASK, frame);
-	regmap_update_bits(arizona->regmap, base + ARIZONA_AIF_FRAME_CTRL_2,
-			   ARIZONA_AIF1RX_WL_MASK |
-			   ARIZONA_AIF1RX_SLOT_LEN_MASK, frame);
+	if (reconfig) {
+		regmap_update_bits_async(arizona->regmap,
+					 base + ARIZONA_AIF_BCLK_CTRL,
+					 ARIZONA_AIF1_BCLK_FREQ_MASK, bclk);
+		regmap_update_bits_async(arizona->regmap,
+					 base + ARIZONA_AIF_TX_BCLK_RATE,
+					 ARIZONA_AIF1TX_BCPF_MASK, lrclk);
+		regmap_update_bits_async(arizona->regmap,
+					 base + ARIZONA_AIF_RX_BCLK_RATE,
+					 ARIZONA_AIF1RX_BCPF_MASK, lrclk);
+		regmap_update_bits_async(arizona->regmap,
+					 base + ARIZONA_AIF_FRAME_CTRL_1,
+					 ARIZONA_AIF1TX_WL_MASK |
+					 ARIZONA_AIF1TX_SLOT_LEN_MASK, frame);
+		regmap_update_bits(arizona->regmap,
+				   base + ARIZONA_AIF_FRAME_CTRL_2,
+				   ARIZONA_AIF1RX_WL_MASK |
+				   ARIZONA_AIF1RX_SLOT_LEN_MASK, frame);
+	}
 
-	return 0;
+restore_aif:
+	if (reconfig) {
+		/* Restore AIF TX/RX state */
+		regmap_update_bits_async(arizona->regmap,
+					 base + ARIZONA_AIF_TX_ENABLES,
+					 0xff, aif_tx_state);
+		regmap_update_bits(arizona->regmap,
+				   base + ARIZONA_AIF_RX_ENABLES,
+				   0xff, aif_rx_state);
+	}
+	return ret;
 }
 
 static const char *arizona_dai_clk_str(int clk_id)
-- 
1.7.2.5

