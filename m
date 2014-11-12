Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaKLBW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:22:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaKLBWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:22:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 036/319] ASoC: tlv320aic3x: fix PLL D configuration
Date: Wed, 12 Nov 2014 10:12:54 +0900
Message-Id: <20141112010958.636899172@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/tlv320aic3x.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -1121,6 +1121,7 @@ static int aic3x_regulator_event(struct
 static int aic3x_set_power(struct snd_soc_codec *codec, int power)
 {
 	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
+	unsigned int pll_c, pll_d;
 	int ret;
 
 	if (power) {
@@ -1138,6 +1139,18 @@ static int aic3x_set_power(struct snd_so
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


