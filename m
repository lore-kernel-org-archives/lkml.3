Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaJCVq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:46:27 -0400
Received: from mail-qg0-f73.google.com ([209.85.192.73]:62633 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbaJCVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:58 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2014 17:45:58 EDT
From: Ben Zhang <benzh@chromium.org>
To: alsa-devel@alsa-project.org
Cc: Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Ben Zhang <benzh@chromium.org>
Subject: [PATCH 3/3] ASoC: rt5677: Add jack detection support
Date: Fri,  3 Oct 2014 14:37:26 -0700
Message-Id: <1412372246-10489-3-git-send-email-benzh@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1412372246-10489-1-git-send-email-benzh@chromium.org>
References: <1412372246-10489-1-git-send-email-benzh@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for jack detection using GPIOs on the codec.
Plug detect signal and mic present signal can be routed from the physical
audio jack to GPIOs on the codec. The codec is configured so that upon
signal change, an IRQ(GPIO1) is fired. The codec interrupt handler reads
related status registers, figures out what has been plugged/unplugged from
the audio jack, and report jack states via snd_soc_jack_report().

ASoC machine driver should register audio jacks for detection with the
codec driver using rt5677_register_jack_detect().

Board setup code should assign GPIOs receiving plug detect/mic present
signal to the codec device itself, via Device Tree, ACPI or platform data.
The corresponding GPIO indexes are:
RT5677_GPIO_PLUG_DET - 0
RT5677_GPIO_MIC_PRESENT_L - 1

Signed-off-by: Ben Zhang <benzh@chromium.org>
---
 sound/soc/codecs/rt5677.c | 179 ++++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/rt5677.h |  92 ++++++++++++++++++++++++
 2 files changed, 271 insertions(+)

diff --git a/sound/soc/codecs/rt5677.c b/sound/soc/codecs/rt5677.c
index 19dbb8a..99f4d1a 100644
--- a/sound/soc/codecs/rt5677.c
+++ b/sound/soc/codecs/rt5677.c
@@ -29,6 +29,7 @@
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
 #include <sound/tlv.h>
+#include <sound/jack.h>
 
 #include "rl6231.h"
 #include "rt5677.h"
@@ -3341,6 +3342,25 @@ static void rt5677_free_gpio(struct i2c_client *i2c)
 
 	gpiochip_remove(&rt5677->gpio_chip);
 }
+
+static void rt5677_request_codec_gpios(struct rt5677_priv *rt5677,
+		struct i2c_client *i2c)
+{
+	struct gpio_desc *desc;
+
+	desc = devm_gpiod_get_index(&i2c->dev, "RT5677_GPIO",
+			RT5677_GPIO_PLUG_DET);
+	if (!IS_ERR(desc) && !gpiod_direction_input(desc))
+		rt5677->gpio_plug_det = desc_to_gpio(desc)
+				- rt5677->gpio_chip.base + 1;
+
+	desc = devm_gpiod_get_index(&i2c->dev, "RT5677_GPIO",
+			RT5677_GPIO_MIC_PRESENT_L);
+	if (!IS_ERR(desc) && !gpiod_direction_input(desc))
+		rt5677->gpio_mic_present_l = desc_to_gpio(desc)
+				- rt5677->gpio_chip.base + 1;
+}
+
 #else
 static void rt5677_init_gpio(struct i2c_client *i2c)
 {
@@ -3349,8 +3369,155 @@ static void rt5677_init_gpio(struct i2c_client *i2c)
 static void rt5677_free_gpio(struct i2c_client *i2c)
 {
 }
+static void rt5677_request_codec_gpios(struct rt5677_priv *rt5677,
+		struct i2c_client *i2c)
+{
+}
 #endif
 
+static void rt5677_report_jack_status(struct rt5677_priv *rt5677, int reg_irq)
+{
+	/* reg_irq: IRQ Control register MX-BDh */
+	int polarity;
+	if (reg_irq & RT5677_JD2_STATUS_MASK) {
+		polarity = reg_irq & RT5677_JD2_POLARITY_MASK;
+		if (rt5677->headphone_jack) {
+			snd_soc_jack_report(rt5677->headphone_jack,
+				polarity ? SND_JACK_HEADPHONE : 0,
+				SND_JACK_HEADPHONE);
+		}
+	}
+
+	if (reg_irq & RT5677_JD3_STATUS_MASK) {
+		polarity = reg_irq & RT5677_JD3_POLARITY_MASK;
+		if (rt5677->mic_jack) {
+			snd_soc_jack_report(rt5677->mic_jack,
+				polarity ? 0 : SND_JACK_MICROPHONE,
+				SND_JACK_MICROPHONE);
+		}
+	}
+}
+
+static irqreturn_t rt5677_irq(int unused, void *data)
+{
+	struct rt5677_priv *rt5677 = data;
+	int ret = 0, i;
+	bool irq_fired;
+	int reg_irq;
+
+	/*
+	 * Loop to handle interrupts until the last i2c read shows no pending
+	 * irqs with a safeguard of 20 loops
+	 */
+	for (i = 0; i < 20; i++) {
+		/* Read interrupt status */
+		ret = regmap_read(rt5677->regmap, RT5677_IRQ_CTRL1, &reg_irq);
+		if (ret)
+			break;
+
+		/* Flip polarity for interrupts that just fired  */
+		irq_fired = false;
+		if (reg_irq & RT5677_JD2_STATUS_MASK) {
+			reg_irq ^= RT5677_JD2_POLARITY_MASK;
+			irq_fired = true;
+		}
+
+		if (reg_irq & RT5677_JD3_STATUS_MASK) {
+			reg_irq ^= RT5677_JD3_POLARITY_MASK;
+			irq_fired = true;
+		}
+
+		if (!irq_fired)
+			break;
+
+		/* Clear interrupts */
+		ret = regmap_write(rt5677->regmap, RT5677_IRQ_CTRL1, reg_irq);
+		if (ret)
+			break;
+
+		/* Process interrupts */
+		rt5677_report_jack_status(rt5677, reg_irq);
+	}
+	return IRQ_HANDLED;
+}
+
+int rt5677_register_jack_detect(struct snd_soc_codec *codec,
+	struct snd_soc_jack *headphone_jack, struct snd_soc_jack *mic_jack)
+{
+	struct rt5677_priv *rt5677 = snd_soc_codec_get_drvdata(codec);
+
+	rt5677->headphone_jack = headphone_jack;
+	rt5677->mic_jack = mic_jack;
+
+	/* Report initial jack status */
+	rt5677_irq(0, rt5677);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt5677_register_jack_detect);
+
+static void rt5677_setup_jack_detect(struct snd_soc_codec *codec,
+		struct rt5677_priv *rt5677)
+{
+	unsigned int val;
+
+	/* Skip jack detect setup if there are no assigned GPIOs */
+	if (!rt5677->gpio_plug_det && !rt5677->gpio_mic_present_l)
+		return;
+	/* GPIO range check */
+	if (rt5677->gpio_plug_det < 4 || rt5677->gpio_plug_det > 6) {
+		dev_err(codec->dev, "PLUG_DET can only use GPIO 4~6, given %d\n",
+				rt5677->gpio_plug_det);
+	}
+	if (rt5677->gpio_mic_present_l < 4 || rt5677->gpio_mic_present_l > 6) {
+		dev_err(codec->dev, "MIC_PRESENT_L can only use GPIO 4~6, given %d\n",
+				rt5677->gpio_mic_present_l);
+	}
+
+	/*
+	 * Select RC as the debounce clock so that GPIO works even when
+	 * MCLK is gated which happens when there is no audio stream
+	 * (SND_SOC_BIAS_OFF).
+	 */
+	regmap_update_bits(rt5677->regmap, RT5677_DIG_MISC,
+			RT5677_IRQ_DEBOUNCE_SEL_MASK,
+			RT5677_IRQ_DEBOUNCE_SEL_RC);
+	/* Enable auto power on RC when GPIO states are changed */
+	val = RT5677_AUTO_RC_ON_GPIO_CHANGE_MASK;
+	if (rt5677->gpio_plug_det)
+		val |= 1 << (rt5677->gpio_plug_det - 1);
+	if (rt5677->gpio_mic_present_l)
+		val |= 1 << (rt5677->gpio_mic_present_l - 1);
+	regmap_update_bits(rt5677->regmap, RT5677_GEN_CTRL1, val, val);
+
+	/*
+	 * Select jack detection source
+	 * JD2: PLUG_DET
+	 * JD3: !MIC_PRESENT_L
+	 */
+	val = 0;
+	if (rt5677->gpio_plug_det)
+		val |= (rt5677->gpio_plug_det - 3)
+			<< RT5677_JD2_SRC_SEL_SFT;
+	if (rt5677->gpio_mic_present_l)
+		val |= (rt5677->gpio_mic_present_l - 3)
+			<< RT5677_JD3_SRC_SEL_SFT;
+	regmap_update_bits(rt5677->regmap, RT5677_JD_CTRL1,
+			RT5677_JD2_SRC_SEL_MASK | RT5677_JD3_SRC_SEL_MASK,
+			val);
+
+	/* Enable JD2 and/or JD3 as IRQ source */
+	val = 0;
+	if (rt5677->gpio_plug_det)
+		val |= RT5677_JD2_IRQ_EN_MASK;
+	if (rt5677->gpio_mic_present_l)
+		val |= RT5677_JD3_IRQ_EN_MASK | RT5677_JD3_POLARITY_INV;
+	regmap_update_bits(rt5677->regmap, RT5677_IRQ_CTRL1, val, val);
+
+	/* Set GPIO1 to be IRQ */
+	regmap_update_bits(rt5677->regmap, RT5677_GPIO_CTRL1,
+			RT5677_GPIO1_PIN_MASK, RT5677_GPIO1_PIN_IRQ);
+}
+
 static int rt5677_probe(struct snd_soc_codec *codec)
 {
 	struct rt5677_priv *rt5677 = snd_soc_codec_get_drvdata(codec);
@@ -3372,6 +3539,7 @@ static int rt5677_probe(struct snd_soc_codec *codec)
 	regmap_write(rt5677->regmap, RT5677_DIG_MISC, 0x0020);
 	regmap_write(rt5677->regmap, RT5677_PWR_DSP2, 0x0c00);
 
+	rt5677_setup_jack_detect(codec, rt5677);
 	return 0;
 }
 
@@ -3668,6 +3836,17 @@ static int rt5677_i2c_probe(struct i2c_client *i2c,
 	}
 
 	rt5677_init_gpio(i2c);
+	rt5677_request_codec_gpios(rt5677, i2c);
+
+	if (i2c->irq) {
+		ret = request_threaded_irq(i2c->irq, NULL, rt5677_irq,
+			IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+			"rt5677", rt5677);
+		if (ret) {
+			dev_err(&i2c->dev, "Failed to request IRQ: %d\n", ret);
+			return ret;
+		}
+	}
 
 	return snd_soc_register_codec(&i2c->dev, &soc_codec_dev_rt5677,
 				      rt5677_dai, ARRAY_SIZE(rt5677_dai));
diff --git a/sound/soc/codecs/rt5677.h b/sound/soc/codecs/rt5677.h
index 99fd023..2ec0844 100644
--- a/sound/soc/codecs/rt5677.h
+++ b/sound/soc/codecs/rt5677.h
@@ -1368,6 +1368,47 @@
 #define RT5677_SEL_SRC_IB01			(0x1 << 0)
 #define RT5677_SEL_SRC_IB01_SFT			0
 
+/* Jack Detection Control 1 (0xb5) */
+#define RT5677_JD1_SRC_SEL_MASK			(0x3 << 14)
+#define RT5677_JD1_SRC_GPIO1			(0x1 << 14)
+#define RT5677_JD1_SRC_GPIO2			(0x2 << 14)
+#define RT5677_JD1_SRC_GPIO3			(0x3 << 14)
+#define RT5677_JD2_SRC_SEL_MASK			(0x3 << 12)
+#define RT5677_JD2_SRC_SEL_SFT			12
+#define RT5677_JD2_SRC_GPIO4			(0x1 << 12)
+#define RT5677_JD2_SRC_GPIO5			(0x2 << 12)
+#define RT5677_JD2_SRC_GPIO6			(0x3 << 12)
+#define RT5677_JD3_SRC_SEL_MASK			(0x3 << 10)
+#define RT5677_JD3_SRC_SEL_SFT			10
+#define RT5677_JD3_SRC_GPIO4			(0x1 << 10)
+#define RT5677_JD3_SRC_GPIO5			(0x2 << 10)
+#define RT5677_JD3_SRC_GPIO6			(0x3 << 10)
+
+/* IRQ Control 1 (0xbd) */
+#define RT5677_JD1_STATUS_MASK			(0x1 << 15)
+#define RT5677_JD1_STATUS_SFT			15
+#define RT5677_JD1_IRQ_EN_MASK			(0x1 << 14)
+#define RT5677_JD1_IRQ_EN_SFT			14
+#define RT5677_JD1_POLARITY_MASK		(0x1 << 12)
+#define RT5677_JD1_POLARITY_NOR			(0x0 << 12)
+#define RT5677_JD1_POLARITY_INV			(0x1 << 12)
+
+#define RT5677_JD2_STATUS_MASK			(0x1 << 11)
+#define RT5677_JD2_STATUS_SFT			11
+#define RT5677_JD2_IRQ_EN_MASK			(0x1 << 10)
+#define RT5677_JD2_IRQ_EN_SFT			10
+#define RT5677_JD2_POLARITY_MASK		(0x1 << 8)
+#define RT5677_JD2_POLARITY_NOR			(0x0 << 8)
+#define RT5677_JD2_POLARITY_INV			(0x1 << 8)
+
+#define RT5677_JD3_STATUS_MASK			(0x1 << 3)
+#define RT5677_JD3_STATUS_SFT			3
+#define RT5677_JD3_IRQ_EN_MASK			(0x1 << 2)
+#define RT5677_JD3_IRQ_EN_SFT			2
+#define RT5677_JD3_POLARITY_MASK		(0x1 << 0)
+#define RT5677_JD3_POLARITY_NOR			(0x0 << 0)
+#define RT5677_JD3_POLARITY_INV			(0x1 << 0)
+
 /* GPIO status (0xbf) */
 #define RT5677_GPIO6_STATUS_MASK		(0x1 << 5)
 #define RT5677_GPIO6_STATUS_SFT			5
@@ -1472,6 +1513,28 @@
 #define RT5677_GPIO6_P_NOR			(0x0 << 0)
 #define RT5677_GPIO6_P_INV			(0x1 << 0)
 
+/* General Control (0xfa) */
+#define RT5677_IRQ_DEBOUNCE_SEL_MASK		(0x3 << 3)
+#define RT5677_IRQ_DEBOUNCE_SEL_MCLK		(0x0 << 3)
+#define RT5677_IRQ_DEBOUNCE_SEL_RC		(0x1 << 3)
+#define RT5677_IRQ_DEBOUNCE_SEL_SLIM		(0x2 << 3)
+
+/* General Control (0xfb) */
+#define RT5677_AUTO_RC_ON_GPIO_CHANGE_MASK	(0x1 << 7)
+#define RT5677_AUTO_RC_ON_GPIO_CHANGE_SFT	7
+#define RT5677_AUTO_RC_ON_GPIO6_MASK		(0x1 << 5)
+#define RT5677_AUTO_RC_ON_GPIO6_SFT		5
+#define RT5677_AUTO_RC_ON_GPIO5_MASK		(0x1 << 4)
+#define RT5677_AUTO_RC_ON_GPIO5_SFT		4
+#define RT5677_AUTO_RC_ON_GPIO4_MASK		(0x1 << 3)
+#define RT5677_AUTO_RC_ON_GPIO4_SFT		3
+#define RT5677_AUTO_RC_ON_GPIO3_MASK		(0x1 << 2)
+#define RT5677_AUTO_RC_ON_GPIO3_SFT		2
+#define RT5677_AUTO_RC_ON_GPIO2_MASK		(0x1 << 1)
+#define RT5677_AUTO_RC_ON_GPIO2_SFT		1
+#define RT5677_AUTO_RC_ON_GPIO1_MASK		(0x1 << 0)
+#define RT5677_AUTO_RC_ON_GPIO1_SFT		0
+
 /* Virtual DSP Mixer Control (0xf7 0xf8 0xf9) */
 #define RT5677_DSP_IB_01_H			(0x1 << 15)
 #define RT5677_DSP_IB_01_H_SFT			15
@@ -1542,10 +1605,20 @@ enum {
 	RT5677_GPIO_NUM,
 };
 
+enum {
+	RT5677_GPIO_PLUG_DET,
+	RT5677_GPIO_MIC_PRESENT_L,
+	RT5677_GPIO_HOTWORD_DET_L,
+	RT5677_GPIO_DSP_INT,
+	RT5677_GPIO_HP_AMP_SHDN_L,
+};
+
 struct rt5677_priv {
 	struct snd_soc_codec *codec;
 	struct rt5677_platform_data pdata;
 	struct regmap *regmap;
+	struct snd_soc_jack *headphone_jack;
+	struct snd_soc_jack *mic_jack;
 
 	int sysclk;
 	int sysclk_src;
@@ -1559,6 +1632,25 @@ struct rt5677_priv {
 #ifdef CONFIG_GPIOLIB
 	struct gpio_chip gpio_chip;
 #endif
+	/*
+	 * Predefined common codec GPIO tasks. Codec GPIO number is
+	 * 1-based, 0 means no GPIO is assigned to the corresponding task.
+	 *
+	 * gpio_plug_det: A codec GPIO used for headphone jack detect
+	 * Low - headphone is not present
+	 * High - headphone is plugged in
+	 * Supported GPIO: 4,5,6
+	 *
+	 * gpio_mic_present_l: A codec GPIO used for mic jack detect
+	 * Low - mic is plugged in
+	 * High - mic is not present
+	 * Supported GPIO: 4,5,6
+	 */
+	int gpio_plug_det;
+	int gpio_mic_present_l;
 };
 
+int rt5677_register_jack_detect(struct snd_soc_codec *codec,
+	struct snd_soc_jack *headphone_jack, struct snd_soc_jack *mic_jack);
+
 #endif /* __RT5677_H__ */
-- 
2.1.0.rc2.206.gedb03e5

