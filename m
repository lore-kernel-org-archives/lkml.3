Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3EUKEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:04:51 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:49793 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3EUKEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:04:49 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 1/2] ASoC: ab8500-codec: Set tx dai slots from tx_mask
Date: Tue, 21 May 2013 12:04:08 +0200
Message-Id: <1369130649-15179-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369130649-15179-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369130649-15179-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace hard-coded tx slot numbers from ab8500_codec_set_dai_tdm_slot
using the ones requested by the machine driver in tx_mask instead.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c | 31 +++++++++++++++++++------------
 sound/soc/codecs/ab8500-codec.h |  7 +++++++
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 3126cac..bace321 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2236,7 +2236,7 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 		int slots, int slot_width)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	unsigned int val, mask, slots_active;
+	unsigned int val, mask, slot, slots_active;
 
 	mask = BIT(AB8500_DIGIFCONF2_IF0WL0) |
 		BIT(AB8500_DIGIFCONF2_IF0WL1);
@@ -2292,27 +2292,34 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	snd_soc_update_bits(codec, AB8500_DIGIFCONF1, mask, val);
 
 	/* Setup TDM DA according to active tx slots */
+
+	if (tx_mask & ~0xff)
+		return -EINVAL;
+
 	mask = AB8500_DASLOTCONFX_SLTODAX_MASK;
+	tx_mask = tx_mask << AB8500_DA_DATA0_OFFSET;
 	slots_active = hweight32(tx_mask);
+
 	dev_dbg(dai->codec->dev, "%s: Slots, active, TX: %d\n", __func__,
 		slots_active);
+
 	switch (slots_active) {
 	case 0:
 		break;
 	case 1:
-		/* Slot 9 -> DA_IN1 & DA_IN3 */
-		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, 11);
-		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, 11);
-		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, 11);
-		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, 11);
+		slot = find_first_bit((unsigned long *)&tx_mask, 32);
+		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, slot);
+		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, slot);
+		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, slot);
+		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, slot);
 		break;
 	case 2:
-		/* Slot 9 -> DA_IN1 & DA_IN3, Slot 11 -> DA_IN2 & DA_IN4 */
-		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, 9);
-		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, 9);
-		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, 11);
-		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, 11);
-
+		slot = find_first_bit((unsigned long *)&tx_mask, 32);
+		snd_soc_update_bits(codec, AB8500_DASLOTCONF1, mask, slot);
+		snd_soc_update_bits(codec, AB8500_DASLOTCONF3, mask, slot);
+		slot = find_next_bit((unsigned long *)&tx_mask, 32, slot + 1);
+		snd_soc_update_bits(codec, AB8500_DASLOTCONF2, mask, slot);
+		snd_soc_update_bits(codec, AB8500_DASLOTCONF4, mask, slot);
 		break;
 	case 8:
 		dev_dbg(dai->codec->dev,
diff --git a/sound/soc/codecs/ab8500-codec.h b/sound/soc/codecs/ab8500-codec.h
index 306d0bc..64c14ce 100644
--- a/sound/soc/codecs/ab8500-codec.h
+++ b/sound/soc/codecs/ab8500-codec.h
@@ -24,6 +24,13 @@
 #define AB8500_SUPPORTED_RATE			(SNDRV_PCM_RATE_48000)
 #define AB8500_SUPPORTED_FMT			(SNDRV_PCM_FMTBIT_S16_LE)
 
+/* AB8500 interface slot offset definitions */
+
+#define AB8500_AD_DATA0_OFFSET	0
+#define AB8500_DA_DATA0_OFFSET	8
+#define AB8500_AD_DATA1_OFFSET	16
+#define AB8500_DA_DATA1_OFFSET	24
+
 /* AB8500 audio bank (0x0d) register definitions */
 
 #define AB8500_POWERUP				0x00
-- 
1.8.2

