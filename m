Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaKHAjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:39:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbaKHAjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:39:00 -0500
From: NeilBrown <neilb@suse.de>
To: Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>
Date: Sat, 08 Nov 2014 11:38:03 +1100
Subject: [PATCH 2/3] ASoC: twl4030: allow voice port to be connected
 externally.
Cc: GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141108003803.6561.57464.stgit@notabene.brown>
In-Reply-To: <20141108002637.6561.19002.stgit@notabene.brown>
References: <20141108002637.6561.19002.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If voice port on twl4030 is not connected to a McBSP (or similar)
then we cannot configure the format the way we normally do for a DAI.

In this case, allow the platform data/devicetree to specify a format
which is put into effect when the 'voice' mode is selected.

If there is a voice connection, then we keep the twl side tri-stated
when not being driven.  This allows for the device to also be
connected to a McBSP if desired.

This is needed if the 'voice' port directly connects to a mobile-phone
module.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 .../devicetree/bindings/mfd/twl4030-audio.txt      |    7 ++++
 include/linux/i2c/twl.h                            |    3 ++
 sound/soc/codecs/twl4030.c                         |   34 +++++++++++++++++++-
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/twl4030-audio.txt b/Documentation/devicetree/bindings/mfd/twl4030-audio.txt
index 414d2ae0adf6..f133cd9db6aa 100644
--- a/Documentation/devicetree/bindings/mfd/twl4030-audio.txt
+++ b/Documentation/devicetree/bindings/mfd/twl4030-audio.txt
@@ -19,6 +19,13 @@ Audio functionality:
 -ti,offset_cncl_path: Offset cancellation path selection, refer to TRM for the
 		      valid values.
 
+Voice functionality:
+- ti,voice_fmt:  The separate 'voice' interface is connected to a
+		 separate device such as a GSM modem.  This field
+		 sets the format expected by that device (who masters
+		 the clock/FRM and what their polarity is).
+
+
 Vibra functionality
 - ti,enable-vibra: Need to be set to <1> if the vibra functionality is used. if
 		   missing or it is 0, the vibra functionality is disabled.
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 8cfb50f38529..0a59acd597b7 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -688,6 +688,9 @@ struct twl4030_codec_data {
 	unsigned int offset_cncl_path;
 	unsigned int hs_extmute:1;
 	int hs_extmute_gpio;
+	unsigned int voice_fmt;	/* If != 0, gives format for external
+				 * voice connection.
+				 */
 };
 
 struct twl4030_vibra_data {
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index c873f5887486..39b6d24377e5 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -221,6 +221,9 @@ static void twl4030_setup_pdata_of(struct twl4030_codec_data *pdata,
 	if (!of_property_read_u32(node, "ti,hs_extmute", &value))
 		pdata->hs_extmute = value;
 
+	if (of_property_read_u32(node, "ti,voice_fmt", &value) == 0)
+		pdata->voice_fmt = value;
+
 	pdata->hs_extmute_gpio = of_get_named_gpio(node,
 						   "ti,hs_extmute_gpio", 0);
 	if (gpio_is_valid(pdata->hs_extmute_gpio))
@@ -249,6 +252,8 @@ static struct twl4030_codec_data *twl4030_get_pdata(struct snd_soc_codec *codec)
 	return pdata;
 }
 
+static int twl4030_voice_set_codec_fmt(struct snd_soc_codec *codec,
+				       unsigned int fmt);
 static void twl4030_init_chip(struct snd_soc_codec *codec)
 {
 	struct twl4030_codec_data *pdata;
@@ -338,6 +343,16 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 		 ((byte & TWL4030_CNCL_OFFSET_START) ==
 		  TWL4030_CNCL_OFFSET_START));
 
+	if (twl4030->pdata->voice_fmt) {
+		/* Configure voice format but keep interface
+		 * tri-state until enabled */
+		twl4030_voice_set_codec_fmt(codec,
+					    twl4030->pdata->voice_fmt);
+		twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+				 TWL4030_VIF_TRI_EN,
+				 TWL4030_REG_VOICE_IF);
+	}
+
 	twl4030_codec_enable(codec, 0);
 }
 
@@ -969,6 +984,15 @@ static int snd_soc_put_twl4030_opmode_enum_double(struct snd_kcontrol *kcontrol,
 			"operation mode cannot be changed on-the-fly\n");
 		return -EBUSY;
 	}
+	if (twl4030->pdata->voice_fmt) {
+		/* There is no SND interface to voice, we need to control
+		 * it here.
+		 */
+		/* If 'val' then voice is disabled, so tri-state it as well */
+		snd_soc_update_bits(codec, TWL4030_REG_VOICE_IF,
+				    TWL4030_VIF_TRI_EN,
+				    val ? 0xff : 0);
+	}
 
 	return snd_soc_put_enum_double(kcontrol, ucontrol);
 }
@@ -2038,10 +2062,9 @@ static int twl4030_voice_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 	return 0;
 }
 
-static int twl4030_voice_set_dai_fmt(struct snd_soc_dai *codec_dai,
+static int twl4030_voice_set_codec_fmt(struct snd_soc_codec *codec,
 				     unsigned int fmt)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 	u8 old_format, format;
 
@@ -2090,6 +2113,13 @@ static int twl4030_voice_set_dai_fmt(struct snd_soc_dai *codec_dai,
 	return 0;
 }
 
+static int twl4030_voice_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	return twl4030_voice_set_codec_fmt(codec, fmt);
+}
+
 static int twl4030_voice_set_tristate(struct snd_soc_dai *dai, int tristate)
 {
 	struct snd_soc_codec *codec = dai->codec;


