Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936122AbaFIJdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:33:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936243AbaFIJ1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:02 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 109/146] ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile
Date: Mon,  9 Jun 2014 10:50:44 +0200
Message-Id: <54fba4664fc90aa354713c203978b7cc4eec296e.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 44330ab516c15dda8a1e660eeaf0003f84e43e3f upstream.

The register CLASS_D_CONTROL_1 is marked as volatile because it contains
a bit, DAC_MUTE, which is also mirrored in the ADC_DAC_CONTROL_1
register. This causes problems for the "Speaker Switch" control, which
will report an error if the CODEC is suspended because it relies on a
volatile register.

To resolve this issue mark CLASS_D_CONTROL_1 as non-volatile and
manually keep the register cache in sync by updating both bits when
changing the mute status.

Reported-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/wm8962.c | 15 ++++++++++++---
 sound/soc/codecs/wm8962.h |  4 ++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 871f8518626f..ea16dc456352 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -154,6 +154,7 @@ static struct reg_default wm8962_reg[] = {
 	{ 40, 0x0000 },   /* R40    - SPKOUTL volume */
 	{ 41, 0x0000 },   /* R41    - SPKOUTR volume */
 
+	{ 49, 0x0010 },   /* R49    - Class D Control 1 */
 	{ 51, 0x0003 },   /* R51    - Class D Control 2 */
 
 	{ 56, 0x0506 },   /* R56    - Clocking 4 */
@@ -795,7 +796,6 @@ static bool wm8962_volatile_register(struct device *dev, unsigned int reg)
 	case WM8962_ALC2:
 	case WM8962_THERMAL_SHUTDOWN_STATUS:
 	case WM8962_ADDITIONAL_CONTROL_4:
-	case WM8962_CLASS_D_CONTROL_1:
 	case WM8962_DC_SERVO_6:
 	case WM8962_INTERRUPT_STATUS_1:
 	case WM8962_INTERRUPT_STATUS_2:
@@ -2901,13 +2901,22 @@ static int wm8962_set_fll(struct snd_soc_codec *codec, int fll_id, int source,
 static int wm8962_mute(struct snd_soc_dai *dai, int mute)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	int val;
+	int val, ret;
 
 	if (mute)
-		val = WM8962_DAC_MUTE;
+		val = WM8962_DAC_MUTE | WM8962_DAC_MUTE_ALT;
 	else
 		val = 0;
 
+	/**
+	 * The DAC mute bit is mirrored in two registers, update both to keep
+	 * the register cache consistent.
+	 */
+	ret = snd_soc_update_bits(codec, WM8962_CLASS_D_CONTROL_1,
+				  WM8962_DAC_MUTE_ALT, val);
+	if (ret < 0)
+		return ret;
+
 	return snd_soc_update_bits(codec, WM8962_ADC_DAC_CONTROL_1,
 				   WM8962_DAC_MUTE, val);
 }
diff --git a/sound/soc/codecs/wm8962.h b/sound/soc/codecs/wm8962.h
index a1a5d5294c19..910aafd09d21 100644
--- a/sound/soc/codecs/wm8962.h
+++ b/sound/soc/codecs/wm8962.h
@@ -1954,6 +1954,10 @@
 #define WM8962_SPKOUTL_ENA_MASK                 0x0040  /* SPKOUTL_ENA */
 #define WM8962_SPKOUTL_ENA_SHIFT                     6  /* SPKOUTL_ENA */
 #define WM8962_SPKOUTL_ENA_WIDTH                     1  /* SPKOUTL_ENA */
+#define WM8962_DAC_MUTE_ALT                     0x0010  /* DAC_MUTE */
+#define WM8962_DAC_MUTE_ALT_MASK                0x0010  /* DAC_MUTE */
+#define WM8962_DAC_MUTE_ALT_SHIFT                    4  /* DAC_MUTE */
+#define WM8962_DAC_MUTE_ALT_WIDTH                    1  /* DAC_MUTE */
 #define WM8962_SPKOUTL_PGA_MUTE                 0x0002  /* SPKOUTL_PGA_MUTE */
 #define WM8962_SPKOUTL_PGA_MUTE_MASK            0x0002  /* SPKOUTL_PGA_MUTE */
 #define WM8962_SPKOUTL_PGA_MUTE_SHIFT                1  /* SPKOUTL_PGA_MUTE */
-- 
1.9.3

