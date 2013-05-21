Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3EUKFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:05:04 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59263 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3EUKFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:05:02 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/2] ASoC: ab8500-codec: Set rx dai slots from rx_mask
Date: Tue, 21 May 2013 12:04:09 +0200
Message-Id: <1369130649-15179-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369130649-15179-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369130649-15179-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace hard coded rx slot numbers from ab8500_codec_set_dai_tdm_slot
using the ones requested by the machine driver in rx_mask instead.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c | 29 ++++++++++++++++++++---------
 sound/soc/codecs/ab8500-codec.h | 35 +++++++++++++++--------------------
 2 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index bace321..4ca45b9 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -2334,25 +2334,36 @@ static int ab8500_codec_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	}
 
 	/* Setup TDM AD according to active RX-slots */
+
+	if (rx_mask & ~0xff)
+		return -EINVAL;
+
+	rx_mask = rx_mask << AB8500_AD_DATA0_OFFSET;
 	slots_active = hweight32(rx_mask);
+
 	dev_dbg(dai->codec->dev, "%s: Slots, active, RX: %d\n", __func__,
 		slots_active);
+
 	switch (slots_active) {
 	case 0:
 		break;
 	case 1:
-		/* AD_OUT3 -> slot 0 & 1 */
-		snd_soc_update_bits(codec, AB8500_ADSLOTSEL1, AB8500_MASK_ALL,
-				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN |
-				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_ODD);
+		slot = find_first_bit((unsigned long *)&rx_mask, 32);
+		snd_soc_update_bits(codec, AB8500_ADSLOTSEL(slot),
+				AB8500_MASK_SLOT(slot),
+				AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT3, slot));
 		break;
 	case 2:
-		/* AD_OUT3 -> slot 0, AD_OUT2 -> slot 1 */
+		slot = find_first_bit((unsigned long *)&rx_mask, 32);
+		snd_soc_update_bits(codec,
+				AB8500_ADSLOTSEL(slot),
+				AB8500_MASK_SLOT(slot),
+				AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT3, slot));
+		slot = find_next_bit((unsigned long *)&rx_mask, 32, slot + 1);
 		snd_soc_update_bits(codec,
-				AB8500_ADSLOTSEL1,
-				AB8500_MASK_ALL,
-				AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN |
-				AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_ODD);
+				AB8500_ADSLOTSEL(slot),
+				AB8500_MASK_SLOT(slot),
+				AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(AB8500_AD_OUT2, slot));
 		break;
 	case 8:
 		dev_dbg(dai->codec->dev,
diff --git a/sound/soc/codecs/ab8500-codec.h b/sound/soc/codecs/ab8500-codec.h
index 64c14ce..e2e5442 100644
--- a/sound/soc/codecs/ab8500-codec.h
+++ b/sound/soc/codecs/ab8500-codec.h
@@ -80,6 +80,7 @@
 #define AB8500_ADSLOTSEL14			0x2C
 #define AB8500_ADSLOTSEL15			0x2D
 #define AB8500_ADSLOTSEL16			0x2E
+#define AB8500_ADSLOTSEL(slot)			(AB8500_ADSLOTSEL1 + (slot >> 1))
 #define AB8500_ADSLOTHIZCTRL1			0x2F
 #define AB8500_ADSLOTHIZCTRL2			0x30
 #define AB8500_ADSLOTHIZCTRL3			0x31
@@ -151,6 +152,7 @@
 #define AB8500_CACHEREGNUM			(AB8500_LAST_REG + 1)
 
 #define AB8500_MASK_ALL				0xFF
+#define AB8500_MASK_SLOT(slot)			((slot & 1) ? 0xF0 : 0x0F)
 #define AB8500_MASK_NONE			0x00
 
 /* AB8500_POWERUP */
@@ -354,28 +356,21 @@
 #define AB8500_DIGIFCONF4_IF1WL0		0
 
 /* AB8500_ADSLOTSELX */
-#define AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_ODD	0x00
-#define AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_ODD	0x10
-#define AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_ODD	0x20
-#define AB8500_ADSLOTSELX_AD_OUT4_TO_SLOT_ODD	0x30
-#define AB8500_ADSLOTSELX_AD_OUT5_TO_SLOT_ODD	0x40
-#define AB8500_ADSLOTSELX_AD_OUT6_TO_SLOT_ODD	0x50
-#define AB8500_ADSLOTSELX_AD_OUT7_TO_SLOT_ODD	0x60
-#define AB8500_ADSLOTSELX_AD_OUT8_TO_SLOT_ODD	0x70
-#define AB8500_ADSLOTSELX_ZEROES_TO_SLOT_ODD	0x80
-#define AB8500_ADSLOTSELX_TRISTATE_TO_SLOT_ODD	0xF0
-#define AB8500_ADSLOTSELX_AD_OUT1_TO_SLOT_EVEN	0x00
-#define AB8500_ADSLOTSELX_AD_OUT2_TO_SLOT_EVEN	0x01
-#define AB8500_ADSLOTSELX_AD_OUT3_TO_SLOT_EVEN	0x02
-#define AB8500_ADSLOTSELX_AD_OUT4_TO_SLOT_EVEN	0x03
-#define AB8500_ADSLOTSELX_AD_OUT5_TO_SLOT_EVEN	0x04
-#define AB8500_ADSLOTSELX_AD_OUT6_TO_SLOT_EVEN	0x05
-#define AB8500_ADSLOTSELX_AD_OUT7_TO_SLOT_EVEN	0x06
-#define AB8500_ADSLOTSELX_AD_OUT8_TO_SLOT_EVEN	0x07
-#define AB8500_ADSLOTSELX_ZEROES_TO_SLOT_EVEN	0x08
-#define AB8500_ADSLOTSELX_TRISTATE_TO_SLOT_EVEN	0x0F
+#define AB8500_AD_OUT1	0x0
+#define AB8500_AD_OUT2	0x1
+#define AB8500_AD_OUT3	0x2
+#define AB8500_AD_OUT4	0x3
+#define AB8500_AD_OUT5	0x4
+#define AB8500_AD_OUT6	0x5
+#define AB8500_AD_OUT7	0x6
+#define AB8500_AD_OUT8	0x7
+#define AB8500_ZEROES	0x8
+#define AB8500_TRISTATE	0xF
 #define AB8500_ADSLOTSELX_EVEN_SHIFT		0
 #define AB8500_ADSLOTSELX_ODD_SHIFT		4
+#define AB8500_ADSLOTSELX_AD_OUT_TO_SLOT(out, slot)	\
+	((out) << (((slot) & 1) ? \
+	 AB8500_ADSLOTSELX_ODD_SHIFT : AB8500_ADSLOTSELX_EVEN_SHIFT))
 
 /* AB8500_ADSLOTHIZCTRL1 */
 /* AB8500_ADSLOTHIZCTRL2 */
-- 
1.8.2

