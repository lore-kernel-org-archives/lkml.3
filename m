Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaKYKle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaKYKlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 077/254] ASoC: tlv320aic3x: fix PLL D configuration
Date: Tue, 25 Nov 2014 10:37:07 +0000
Message-Id: <1416912004-5928-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>

commit 31d9f8faf9a54c851e835af489c82f45105a442f upstream.

Current caching implementation during regcache_sync() call bypasses
all register writes of values that are already known as default
(regmap reg_defaults). Same time in TLV320AIC3x codecs register 5
(AIC3X_PLL_PROGC_REG) write should be immediately followed by register
6 write (AIC3X_PLL_PROGD_REG) even if it was not changed. Otherwise
both registers will not be written.

This brings to issue that appears particulary in case of 44.1kHz
playback with 19.2MHz master clock. In this case AIC3X_PLL_PROGC_REG
is 0x6e while AIC3X_PLL_PROGD_REG is 0x0 (same as register
default). Thus AIC3X_PLL_PROGC_REG also remains not written and we get
wrong playback speed.

In this patch snd_soc_read() is used to get cached pll values and
snd_soc_write() (unlike regcache_sync() this function doesn't bypasses
hardware default values) to write them to registers.

Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/tlv320aic3x.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index e12fafbb1e09..80d2722392ff 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1121,6 +1121,7 @@ static int aic3x_regulator_event(struct notifier_block *nb,
 static int aic3x_set_power(struct snd_soc_codec *codec, int power)
 {
 	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
+	unsigned int pll_c, pll_d;
 	int ret;
 
 	if (power) {
@@ -1138,6 +1139,18 @@ static int aic3x_set_power(struct snd_soc_codec *codec, int power)
 		/* Sync reg_cache with the hardware */
 		regcache_cache_only(aic3x->regmap, false);
 		regcache_sync(aic3x->regmap);
+
+		/* Rewrite paired PLL D registers in case cached sync skipped
+		 * writing one of them and thus caused other one also not
+		 * being written
+		 */
+		pll_c = snd_soc_read(codec, AIC3X_PLL_PROGC_REG);
+		pll_d = snd_soc_read(codec, AIC3X_PLL_PROGD_REG);
+		if (pll_c == aic3x_reg[AIC3X_PLL_PROGC_REG].def ||
+			pll_d == aic3x_reg[AIC3X_PLL_PROGD_REG].def) {
+			snd_soc_write(codec, AIC3X_PLL_PROGC_REG, pll_c);
+			snd_soc_write(codec, AIC3X_PLL_PROGD_REG, pll_d);
+		}
 	} else {
 		/*
 		 * Do soft reset to this codec instance in order to clear
-- 
2.1.0

