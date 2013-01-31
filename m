Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3AaMwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:52:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50196 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab3AaMwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:52:23 -0500
From: Hebbar Gururaja <gururaja.hebbar@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <alsa-devel@alsa-project.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
CC: <tony@atomide.com>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <rob@landley.net>,
        <grant.likely@secretlab.ca>
Subject: [PATCH v4 1/3] ASoC: tlv320aic3x: Convert mic bias to a supply widget
Date: Thu, 31 Jan 2013 18:23:04 +0530
Message-ID: <1359636786-7056-2-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359636786-7056-1-git-send-email-gururaja.hebbar@ti.com>
References: <1359636786-7056-1-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert MicBias widgets to supply widget.

On tlv320aic3x, Mic bias power on/off shares the same register bits
with output mic bias voltage.  So, when power on mic bias, we need
reclaim it to voltage value.

Provide a new platform data so that the micbias voltage can be sent
according to board requirement. Now since tlv320aic3x codec driver
is DT aware, update dt files and functions to handle this new
"micbias-vg"  platform data.

Because of sharing of bits, when enabling the micbias, voltage also
needs to be updated. So use SND_SOC_DAPM_POST_PMU & SND_SOC_DAPM_PRE_PMD
macro to create an event to handle this.

Since micbias is converted to supply widget, updated machine drivers as
well.

This change is runtime tested on da850-evm with audio loopback
(arecord|aplay) for confirmation.

Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
---
Changes in v4
	 - updated pending machine driver to change in micbias -> supply widget
	 - merge codec & machine driver change into a single commit

Changes in v3
	 - New patch

:100644 100644 e7b98f4... f47c3f5... M	Documentation/devicetree/bindings/sound/tlv320aic3x.txt
:100644 100644 ffd9bc7... 9407fd0... M	include/sound/tlv320aic3x.h
:100644 100644 4989143... 65d09d6... M	sound/soc/codecs/tlv320aic3x.c
:100644 100644 6db3c41... e521ac3... M	sound/soc/codecs/tlv320aic3x.h
:100644 100644 d55e647... 484b22c... M	sound/soc/davinci/davinci-evm.c
:100644 100644 230b8c1... ee7cd53... M	sound/soc/omap/n810.c
:100644 100644 d921ddb... 3cd5257... M	sound/soc/omap/rx51.c
 .../devicetree/bindings/sound/tlv320aic3x.txt      |    6 ++
 include/sound/tlv320aic3x.h                        |   10 +++
 sound/soc/codecs/tlv320aic3x.c                     |   83 ++++++++++++++++++--
 sound/soc/codecs/tlv320aic3x.h                     |    4 +
 sound/soc/davinci/davinci-evm.c                    |    6 +-
 sound/soc/omap/n810.c                              |    4 +-
 sound/soc/omap/rx51.c                              |    8 +-
 7 files changed, 106 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/tlv320aic3x.txt b/Documentation/devicetree/bindings/sound/tlv320aic3x.txt
index e7b98f4..f47c3f5 100644
--- a/Documentation/devicetree/bindings/sound/tlv320aic3x.txt
+++ b/Documentation/devicetree/bindings/sound/tlv320aic3x.txt
@@ -11,6 +11,12 @@ Optional properties:
 
 - gpio-reset - gpio pin number used for codec reset
 - ai3x-gpio-func - <array of 2 int> - AIC3X_GPIO1 & AIC3X_GPIO2 Functionality
+- ai3x-micbias-vg - MicBias Voltage required.
+	1 - MICBIAS output is powered to 2.0V,
+	2 - MICBIAS output is powered to 2.5V,
+	3 - MICBIAS output is connected to AVDD,
+	If this node is not mentioned or if the value is incorrect, then MicBias
+	is powered down.
 
 Example:
 
diff --git a/include/sound/tlv320aic3x.h b/include/sound/tlv320aic3x.h
index ffd9bc7..9407fd0 100644
--- a/include/sound/tlv320aic3x.h
+++ b/include/sound/tlv320aic3x.h
@@ -46,6 +46,13 @@ enum {
 	AIC3X_GPIO2_FUNC_BUTTON_PRESS_IRQ	= 15
 };
 
+enum aic3x_micbias_voltage {
+	AIC3X_MICBIAS_OFF = 0,
+	AIC3X_MICBIAS_2_0V = 1,
+	AIC3X_MICBIAS_2_5V = 2,
+	AIC3X_MICBIAS_AVDDV = 3,
+};
+
 struct aic3x_setup_data {
 	unsigned int gpio_func[2];
 };
@@ -53,6 +60,9 @@ struct aic3x_setup_data {
 struct aic3x_pdata {
 	int gpio_reset; /* < 0 if not used */
 	struct aic3x_setup_data *setup;
+
+	/* Selects the micbias voltage */
+	enum aic3x_micbias_voltage micbias_vg;
 };
 
 #endif
diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index 4989143..65d09d6 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -85,6 +85,9 @@ struct aic3x_priv {
 #define AIC3X_MODEL_33 1
 #define AIC3X_MODEL_3007 2
 	u16 model;
+
+	/* Selects the micbias voltage */
+	enum aic3x_micbias_voltage micbias_vg;
 };
 
 /*
@@ -195,6 +198,37 @@ static int snd_soc_dapm_put_volsw_aic3x(struct snd_kcontrol *kcontrol,
 	return ret;
 }
 
+/*
+ * mic bias power on/off share the same register bits with
+ * output voltage of mic bias. when power on mic bias, we
+ * need reclaim it to voltage value.
+ * 0x0 = Powered off
+ * 0x1 = MICBIAS output is powered to 2.0V,
+ * 0x2 = MICBIAS output is powered to 2.5V
+ * 0x3 = MICBIAS output is connected to AVDD
+ */
+static int mic_bias_event(struct snd_soc_dapm_widget *w,
+	struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_codec *codec = w->codec;
+	struct aic3x_priv *aic3x = snd_soc_codec_get_drvdata(codec);
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMU:
+		/* change mic bias voltage to user defined */
+		snd_soc_update_bits(codec, MICBIAS_CTRL,
+				MICBIAS_LEVEL_MASK,
+				aic3x->micbias_vg << MICBIAS_LEVEL_SHIFT);
+		break;
+
+	case SND_SOC_DAPM_PRE_PMD:
+		snd_soc_update_bits(codec, MICBIAS_CTRL,
+				MICBIAS_LEVEL_MASK, 0);
+		break;
+	}
+	return 0;
+}
+
 static const char *aic3x_left_dac_mux[] = { "DAC_L1", "DAC_L3", "DAC_L2" };
 static const char *aic3x_right_dac_mux[] = { "DAC_R1", "DAC_R3", "DAC_R2" };
 static const char *aic3x_left_hpcom_mux[] =
@@ -596,12 +630,9 @@ static const struct snd_soc_dapm_widget aic3x_dapm_widgets[] = {
 			 AIC3X_ASD_INTF_CTRLA, 0, 3, 3, 0),
 
 	/* Mic Bias */
-	SND_SOC_DAPM_REG(snd_soc_dapm_micbias, "Mic Bias 2V",
-			 MICBIAS_CTRL, 6, 3, 1, 0),
-	SND_SOC_DAPM_REG(snd_soc_dapm_micbias, "Mic Bias 2.5V",
-			 MICBIAS_CTRL, 6, 3, 2, 0),
-	SND_SOC_DAPM_REG(snd_soc_dapm_micbias, "Mic Bias AVDD",
-			 MICBIAS_CTRL, 6, 3, 3, 0),
+	SND_SOC_DAPM_SUPPLY("Mic Bias", MICBIAS_CTRL, 6, 0,
+			 mic_bias_event,
+			 SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
 
 	/* Output mixers */
 	SND_SOC_DAPM_MIXER("Left Line Mixer", SND_SOC_NOPM, 0, 0,
@@ -1386,6 +1417,24 @@ static int aic3x_probe(struct snd_soc_codec *codec)
 	if (aic3x->model == AIC3X_MODEL_3007)
 		snd_soc_add_codec_controls(codec, &aic3x_classd_amp_gain_ctrl, 1);
 
+	/* set mic bias voltage */
+	switch (aic3x->micbias_vg) {
+	case AIC3X_MICBIAS_2_0V:
+	case AIC3X_MICBIAS_2_5V:
+	case AIC3X_MICBIAS_AVDDV:
+		snd_soc_update_bits(codec, MICBIAS_CTRL,
+				    MICBIAS_LEVEL_MASK,
+				    (aic3x->micbias_vg) << MICBIAS_LEVEL_SHIFT);
+		break;
+	case AIC3X_MICBIAS_OFF:
+		/*
+		 * noting to do. target won't enter here. This is just to avoid
+		 * compile time warning "warning: enumeration value
+		 * 'AIC3X_MICBIAS_OFF' not handled in switch"
+		 */
+		break;
+	}
+
 	aic3x_add_widgets(codec);
 	list_add(&aic3x->list, &reset_list);
 
@@ -1461,6 +1510,7 @@ static int aic3x_i2c_probe(struct i2c_client *i2c,
 	struct aic3x_setup_data *ai3x_setup;
 	struct device_node *np = i2c->dev.of_node;
 	int ret;
+	u32 value;
 
 	aic3x = devm_kzalloc(&i2c->dev, sizeof(struct aic3x_priv), GFP_KERNEL);
 	if (aic3x == NULL) {
@@ -1474,6 +1524,7 @@ static int aic3x_i2c_probe(struct i2c_client *i2c,
 	if (pdata) {
 		aic3x->gpio_reset = pdata->gpio_reset;
 		aic3x->setup = pdata->setup;
+		aic3x->micbias_vg = pdata->micbias_vg;
 	} else if (np) {
 		ai3x_setup = devm_kzalloc(&i2c->dev, sizeof(*ai3x_setup),
 								GFP_KERNEL);
@@ -1493,6 +1544,26 @@ static int aic3x_i2c_probe(struct i2c_client *i2c,
 			aic3x->setup = ai3x_setup;
 		}
 
+		if (!of_property_read_u32(np, "ai3x-micbias-vg", &value)) {
+			switch (value) {
+			case 1 :
+				aic3x->micbias_vg = AIC3X_MICBIAS_2_0V;
+				break;
+			case 2 :
+				aic3x->micbias_vg = AIC3X_MICBIAS_2_5V;
+				break;
+			case 3 :
+				aic3x->micbias_vg = AIC3X_MICBIAS_AVDDV;
+				break;
+			default :
+				aic3x->micbias_vg = AIC3X_MICBIAS_OFF;
+				dev_err(&i2c->dev, "Unsuitable MicBias voltage "
+							"found in DT\n");
+			}
+		} else {
+			aic3x->micbias_vg = AIC3X_MICBIAS_OFF;
+		}
+
 	} else {
 		aic3x->gpio_reset = -1;
 	}
diff --git a/sound/soc/codecs/tlv320aic3x.h b/sound/soc/codecs/tlv320aic3x.h
index 6db3c41..e521ac3 100644
--- a/sound/soc/codecs/tlv320aic3x.h
+++ b/sound/soc/codecs/tlv320aic3x.h
@@ -238,6 +238,10 @@
 /* Default input volume */
 #define DEFAULT_GAIN    0x20
 
+/* MICBIAS Control Register */
+#define MICBIAS_LEVEL_SHIFT	(6)
+#define MICBIAS_LEVEL_MASK	(3 << 6)
+
 /* headset detection / button API */
 
 /* The AIC3x supports detection of stereo headsets (GND + left + right signal)
diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
index d55e647..484b22c 100644
--- a/sound/soc/davinci/davinci-evm.c
+++ b/sound/soc/davinci/davinci-evm.c
@@ -116,9 +116,9 @@ static const struct snd_soc_dapm_route audio_map[] = {
 	{"Line Out", NULL, "RLOUT"},
 
 	/* Mic connected to (MIC3L | MIC3R) */
-	{"MIC3L", NULL, "Mic Bias 2V"},
-	{"MIC3R", NULL, "Mic Bias 2V"},
-	{"Mic Bias 2V", NULL, "Mic Jack"},
+	{"MIC3L", NULL, "Mic Bias"},
+	{"MIC3R", NULL, "Mic Bias"},
+	{"Mic Bias", NULL, "Mic Jack"},
 
 	/* Line In connected to (LINE1L | LINE2L), (LINE1R | LINE2R) */
 	{"LINE1L", NULL, "Line In"},
diff --git a/sound/soc/omap/n810.c b/sound/soc/omap/n810.c
index 230b8c1..ee7cd53 100644
--- a/sound/soc/omap/n810.c
+++ b/sound/soc/omap/n810.c
@@ -230,8 +230,8 @@ static const struct snd_soc_dapm_route audio_map[] = {
 	{"Ext Spk", NULL, "LLOUT"},
 	{"Ext Spk", NULL, "RLOUT"},
 
-	{"DMic Rate 64", NULL, "Mic Bias 2V"},
-	{"Mic Bias 2V", NULL, "DMic"},
+	{"DMic Rate 64", NULL, "Mic Bias"},
+	{"Mic Bias", NULL, "DMic"},
 };
 
 static const char *spk_function[] = {"Off", "On"};
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index d921ddb..3cd5257 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -248,16 +248,16 @@ static const struct snd_soc_dapm_route audio_map[] = {
 	{"FM Transmitter", NULL, "LLOUT"},
 	{"FM Transmitter", NULL, "RLOUT"},
 
-	{"DMic Rate 64", NULL, "Mic Bias 2V"},
-	{"Mic Bias 2V", NULL, "DMic"},
+	{"DMic Rate 64", NULL, "Mic Bias"},
+	{"Mic Bias", NULL, "DMic"},
 };
 
 static const struct snd_soc_dapm_route audio_mapb[] = {
 	{"b LINE2R", NULL, "MONO_LOUT"},
 	{"Earphone", NULL, "b HPLOUT"},
 
-	{"LINE1L", NULL, "b Mic Bias 2.5V"},
-	{"b Mic Bias 2.5V", NULL, "HS Mic"}
+	{"LINE1L", NULL, "b Mic Bias"},
+	{"b Mic Bias", NULL, "HS Mic"}
 };
 
 static const char *spk_function[] = {"Off", "On"};
-- 
1.7.9.5

