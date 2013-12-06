Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3LFJs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:48:28 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:43431
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757435Ab3LFJsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:48:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097h84d07hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <tiwai@suse.de>, <perex@perex.cz>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>
Subject: [PATCH 3/3] ASoC: fsl: imx-wm8962: Add headphone and microphone jack plugin/out detection
Date: Fri, 6 Dec 2013 17:48:23 +0800
Message-ID: <82d3285b7efe1f98dbc3d9c0a423b2e5e454481f.1386322845.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1386322845.git.b42378@freescale.com>
References: <cover.1386322845.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms of i.MX series place two GPIOs to detect jack pluging events of
headphone and microphone so as to let software switch the output (input) route
between headphone (analog microphone) and external speakers (on-board digital
microphone).

Therefore, this patch mainly adds jack event detection feature and switchs I/O
routes accordingly. Meanwhile, for those monaural input cases, we also turn on
the ADC monomix features of WM8962 if needed.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 .../devicetree/bindings/sound/imx-audio-wm8962.txt |   8 +
 Documentation/devicetree/bindings/sound/wm8962.txt |   8 +
 sound/soc/fsl/imx-wm8962.c                         | 225 +++++++++++++++++++++
 3 files changed, 241 insertions(+)

diff --git a/Documentation/devicetree/bindings/sound/imx-audio-wm8962.txt b/Documentation/devicetree/bindings/sound/imx-audio-wm8962.txt
index f49450a..5d4222e 100644
--- a/Documentation/devicetree/bindings/sound/imx-audio-wm8962.txt
+++ b/Documentation/devicetree/bindings/sound/imx-audio-wm8962.txt
@@ -24,6 +24,12 @@ Required properties:
 Note: The AUDMUX port numbering should start at 1, which is consistent with
 hardware manual.
 
+Optional properties:
+- hp-det-gpios : The gpio pin to detect plug in/out event that happens to
+  Headphone jack.
+- mic-det-gpios: The gpio pin to detect plug in/out event that happens to
+  Microphone jack.
+
 Example:
 
 sound {
@@ -43,4 +49,6 @@ sound {
 		"DMICDAT", "DMIC";
 	mux-int-port = <2>;
 	mux-ext-port = <3>;
+	hp-det-gpios = <&gpio7 8 1>;
+	mic-det-gpios = <&gpio1 9 1>;
 };
diff --git a/Documentation/devicetree/bindings/sound/wm8962.txt b/Documentation/devicetree/bindings/sound/wm8962.txt
index 7f82b59..744d148 100644
--- a/Documentation/devicetree/bindings/sound/wm8962.txt
+++ b/Documentation/devicetree/bindings/sound/wm8962.txt
@@ -13,6 +13,14 @@ Optional properties:
     of R51 (Class D Control 2) gets set, indicating that the speaker is
     in mono mode.
 
+  - amic-mono: This is a boolean property. If present, indicating that the
+    analog micphone is hardware monaural input, the driver would enable the
+    monomix for it.
+
+  - dmic-mono: This is a boolean property. If present, indicating that the
+    digital micphone is hardware monaural input, the driver would enable the
+    monomix for it.
+
   - mic-cfg : Default register value for R48 (Additional Control 4).
     If absent, the default should be the register default.
 
diff --git a/sound/soc/fsl/imx-wm8962.c b/sound/soc/fsl/imx-wm8962.c
index 8baf5d4..1f457df 100644
--- a/sound/soc/fsl/imx-wm8962.c
+++ b/sound/soc/fsl/imx-wm8962.c
@@ -14,10 +14,13 @@
  */
 
 #include <linux/module.h>
+#include <linux/of_gpio.h>
 #include <linux/of_platform.h>
+#include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
+#include <sound/jack.h>
 #include <sound/soc.h>
 #include <sound/pcm_params.h>
 #include <sound/soc-dapm.h>
@@ -39,10 +42,113 @@ struct imx_wm8962_data {
 };
 
 struct imx_priv {
+	int hp_gpio;
+	int hp_active_low;
+	int mic_gpio;
+	int mic_active_low;
+	bool amic_mono;
+	bool dmic_mono;
+	struct snd_soc_codec *codec;
 	struct platform_device *pdev;
 };
 static struct imx_priv card_priv;
 
+static struct snd_soc_jack imx_hp_jack;
+static struct snd_soc_jack_pin imx_hp_jack_pins[] = {
+	{
+		.pin = "Headphone Jack",
+		.mask = SND_JACK_HEADPHONE,
+	},
+};
+static struct snd_soc_jack_gpio imx_hp_jack_gpio = {
+	.name = "headphone detect",
+	.report = SND_JACK_HEADPHONE,
+	.debounce_time = 250,
+	.invert = 0,
+};
+
+static struct snd_soc_jack imx_mic_jack;
+static struct snd_soc_jack_pin imx_mic_jack_pins[] = {
+	{
+		.pin = "AMIC",
+		.mask = SND_JACK_MICROPHONE,
+	},
+};
+static struct snd_soc_jack_gpio imx_mic_jack_gpio = {
+	.name = "microphone detect",
+	.report = SND_JACK_MICROPHONE,
+	.debounce_time = 250,
+	.invert = 0,
+};
+
+static int hpjack_status_check(void)
+{
+	struct imx_priv *priv = &card_priv;
+	struct platform_device *pdev = priv->pdev;
+	char *envp[3], buf[32];
+	int hp_status, ret;
+
+	if (!gpio_is_valid(priv->hp_gpio))
+		return 0;
+
+	hp_status = gpio_get_value(priv->hp_gpio) != 0;
+
+	if (hp_status != priv->hp_active_low) {
+		snprintf(buf, 32, "STATE=%d", 2);
+		snd_soc_dapm_disable_pin(&priv->codec->dapm, "Ext Spk");
+		ret = imx_hp_jack_gpio.report;
+	} else {
+		snprintf(buf, 32, "STATE=%d", 0);
+		snd_soc_dapm_enable_pin(&priv->codec->dapm, "Ext Spk");
+		ret = 0;
+	}
+
+	envp[0] = "NAME=headphone";
+	envp[1] = buf;
+	envp[2] = NULL;
+	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, envp);
+
+	return ret;
+}
+
+static int micjack_status_check(void)
+{
+	struct imx_priv *priv = &card_priv;
+	struct platform_device *pdev = priv->pdev;
+	char *envp[3], buf[32];
+	int mic_status, ret;
+
+	if (!gpio_is_valid(priv->mic_gpio))
+		return 0;
+
+	mic_status = gpio_get_value(priv->mic_gpio) != 0;
+
+	if ((mic_status != priv->mic_active_low && priv->amic_mono) ||
+	    (mic_status == priv->mic_active_low && priv->dmic_mono))
+		snd_soc_update_bits(priv->codec, WM8962_THREED1,
+				WM8962_ADC_MONOMIX_MASK, WM8962_ADC_MONOMIX);
+	else
+		snd_soc_update_bits(priv->codec, WM8962_THREED1,
+				WM8962_ADC_MONOMIX_MASK, 0);
+
+	if (mic_status != priv->mic_active_low) {
+		snprintf(buf, 32, "STATE=%d", 2);
+		snd_soc_dapm_disable_pin(&priv->codec->dapm, "DMIC");
+		ret = imx_mic_jack_gpio.report;
+	} else {
+		snprintf(buf, 32, "STATE=%d", 0);
+		snd_soc_dapm_enable_pin(&priv->codec->dapm, "DMIC");
+		ret = 0;
+	}
+
+	envp[0] = "NAME=microphone";
+	envp[1] = buf;
+	envp[2] = NULL;
+	kobject_uevent_env(&pdev->dev.kobj, KOBJ_CHANGE, envp);
+
+	return ret;
+}
+
 static const struct snd_soc_dapm_widget imx_wm8962_dapm_widgets[] = {
 	SND_SOC_DAPM_HP("Headphone Jack", NULL),
 	SND_SOC_DAPM_SPK("Ext Spk", NULL),
@@ -167,6 +273,88 @@ static int imx_wm8962_set_bias_level(struct snd_soc_card *card,
 	return 0;
 }
 
+static int imx_wm8962_gpio_init(struct snd_soc_pcm_runtime *rtd)
+{
+	struct snd_soc_codec *codec = rtd->codec;
+	struct imx_priv *priv = &card_priv;
+
+	priv->codec = codec;
+
+	if (gpio_is_valid(priv->hp_gpio)) {
+		imx_hp_jack_gpio.gpio = priv->hp_gpio;
+		imx_hp_jack_gpio.jack_status_check = hpjack_status_check;
+
+		snd_soc_jack_new(codec, "Headphone Jack", SND_JACK_HEADPHONE, &imx_hp_jack);
+		snd_soc_jack_add_pins(&imx_hp_jack,
+				ARRAY_SIZE(imx_hp_jack_pins), imx_hp_jack_pins);
+		snd_soc_jack_add_gpios(&imx_hp_jack, 1, &imx_hp_jack_gpio);
+	}
+
+	if (gpio_is_valid(priv->mic_gpio)) {
+		imx_mic_jack_gpio.gpio = priv->mic_gpio;
+		imx_mic_jack_gpio.jack_status_check = micjack_status_check;
+
+		snd_soc_jack_new(codec, "AMIC", SND_JACK_MICROPHONE, &imx_mic_jack);
+		snd_soc_jack_add_pins(&imx_mic_jack,
+				ARRAY_SIZE(imx_mic_jack_pins), imx_mic_jack_pins);
+		snd_soc_jack_add_gpios(&imx_mic_jack, 1, &imx_mic_jack_gpio);
+	} else if (priv->amic_mono || priv->dmic_mono) {
+		/* Permanently set monomix bit if only one microphone is
+		 * present on the board while it needs monomix.
+		 */
+		snd_soc_update_bits(priv->codec, WM8962_THREED1,
+				WM8962_ADC_MONOMIX_MASK, WM8962_ADC_MONOMIX);
+	}
+
+	return 0;
+}
+
+static ssize_t show_headphone(struct device_driver *dev, char *buf)
+{
+	struct imx_priv *priv = &card_priv;
+	int hp_status;
+
+	if (!gpio_is_valid(priv->hp_gpio)) {
+		strcpy(buf, "no detect gpio connected\n");
+		return strlen(buf);
+	}
+
+	/* Check if headphone is plugged in */
+	hp_status = gpio_get_value(priv->hp_gpio) != 0;
+
+	if (hp_status != priv->hp_active_low)
+		strcpy(buf, "headphone\n");
+	else
+		strcpy(buf, "speaker\n");
+
+	return strlen(buf);
+}
+
+static DRIVER_ATTR(headphone, S_IRUGO | S_IWUSR, show_headphone, NULL);
+
+static ssize_t show_mic(struct device_driver *dev, char *buf)
+{
+	struct imx_priv *priv = &card_priv;
+	int mic_status;
+
+	if (!gpio_is_valid(priv->mic_gpio)) {
+		strcpy(buf, "no detect gpio connected\n");
+		return strlen(buf);
+	}
+
+	/* Check if analog microphone is plugged in */
+	mic_status = gpio_get_value(priv->mic_gpio) != 0;
+
+	if (mic_status != priv->mic_active_low)
+		strcpy(buf, "amic\n");
+	else
+		strcpy(buf, "dmic\n");
+
+	return strlen(buf);
+}
+
+static DRIVER_ATTR(microphone, S_IRUGO | S_IWUSR, show_mic, NULL);
+
 static int imx_wm8962_late_probe(struct snd_soc_card *card)
 {
 	struct snd_soc_dai *codec_dai = card->rtd[0].codec_dai;
@@ -275,6 +463,14 @@ static int imx_wm8962_probe(struct platform_device *pdev)
 		goto fail;
 	}
 
+	priv->amic_mono = of_property_read_bool(codec_np, "amic-mono");
+	priv->dmic_mono = of_property_read_bool(codec_np, "dmic-mono");
+
+	priv->hp_gpio = of_get_named_gpio_flags(np, "hp-det-gpios", 0,
+				(enum of_gpio_flags *)&priv->hp_active_low);
+	priv->mic_gpio = of_get_named_gpio_flags(np, "mic-det-gpios", 0,
+				(enum of_gpio_flags *)&priv->mic_active_low);
+
 	data->dai.name = "HiFi";
 	data->dai.stream_name = "HiFi";
 	data->dai.codec_dai_name = "wm8962";
@@ -282,6 +478,7 @@ static int imx_wm8962_probe(struct platform_device *pdev)
 	data->dai.cpu_dai_name = dev_name(&ssi_pdev->dev);
 	data->dai.platform_of_node = ssi_np;
 	data->dai.ops = &imx_hifi_ops;
+	data->dai.init = &imx_wm8962_gpio_init;
 	data->dai.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF |
 			    SND_SOC_DAIFMT_CBM_CFM;
 
@@ -307,11 +504,33 @@ static int imx_wm8962_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, data);
+
+	if (gpio_is_valid(priv->hp_gpio)) {
+		ret = driver_create_file(pdev->dev.driver, &driver_attr_headphone);
+		if (ret) {
+			dev_err(&pdev->dev, "create hp attr failed (%d)\n", ret);
+			goto fail_hp;
+		}
+	}
+
+	if (gpio_is_valid(priv->mic_gpio)) {
+		ret = driver_create_file(pdev->dev.driver, &driver_attr_microphone);
+		if (ret) {
+			dev_err(&pdev->dev, "create mic attr failed (%d)\n", ret);
+			goto fail_mic;
+		}
+	}
+
 	of_node_put(ssi_np);
 	of_node_put(codec_np);
 
 	return 0;
 
+fail_mic:
+	if (gpio_is_valid(priv->hp_gpio))
+		driver_remove_file(pdev->dev.driver, &driver_attr_headphone);
+fail_hp:
+	snd_soc_unregister_card(&data->card);
 clk_fail:
 	clk_disable_unprepare(data->codec_clk);
 fail:
@@ -326,6 +545,12 @@ fail:
 static int imx_wm8962_remove(struct platform_device *pdev)
 {
 	struct imx_wm8962_data *data = platform_get_drvdata(pdev);
+	struct imx_priv *priv = &card_priv;
+
+	if (gpio_is_valid(priv->mic_gpio))
+		driver_remove_file(pdev->dev.driver, &driver_attr_microphone);
+	if (gpio_is_valid(priv->hp_gpio))
+		driver_remove_file(pdev->dev.driver, &driver_attr_headphone);
 
 	if (!IS_ERR(data->codec_clk))
 		clk_disable_unprepare(data->codec_clk);
-- 
1.8.4


