Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaKADWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 23:22:43 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:43636 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaKADWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 23:22:42 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: jay.xu@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: jay.xu@rock-chips.com
X-UNIQUE-TAG: <368cef260923caf00c5014aaf765f5b5>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Jianqun <jay.xu@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, Li.Xiubo@freescale.com, moinejf@free.fr,
        kuninori.morimoto.gx@renesas.com, jsarha@ti.com,
        Guangyu.Chen@freescale.com, dgreid@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: huangtao@rock-chips.com, cf@rock-chips.com,
        Jianqun <jay.xu@rock-chips.com>
Subject: [PATCH] ASoC: simple-card: add "invert" property for detect GPIOs
Date: Sat,  1 Nov 2014 11:22:18 +0800
Message-Id: <1414812138-6178-1-git-send-email-jay.xu@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since hardware may invert detect GPIO of headphone or mic, add one
property to support software invert.

Signed-off-by: Jianqun <jay.xu@rock-chips.com>
---
 sound/soc/generic/simple-card.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index d1b7293..f1bb537 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -29,7 +29,9 @@ struct simple_card_data {
 	} *dai_props;
 	unsigned int mclk_fs;
 	int gpio_hp_det;
+	int gpio_hp_det_invert;
 	int gpio_mic_det;
+	int gpio_mic_det_invert;
 	struct snd_soc_dai_link dai_link[];	/* dynamically allocated */
 };
 
@@ -148,6 +150,7 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 				      simple_card_hp_jack_pins);
 
 		simple_card_hp_jack_gpio.gpio = priv->gpio_hp_det;
+		simple_card_hp_jack_gpio.invert = priv->gpio_hp_det_invert;
 		snd_soc_jack_add_gpios(&simple_card_hp_jack, 1,
 				       &simple_card_hp_jack_gpio);
 	}
@@ -159,6 +162,7 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 				      ARRAY_SIZE(simple_card_mic_jack_pins),
 				      simple_card_mic_jack_pins);
 		simple_card_mic_jack_gpio.gpio = priv->gpio_mic_det;
+		simple_card_mic_jack_gpio.invert = priv->gpio_mic_det_invert;
 		snd_soc_jack_add_gpios(&simple_card_mic_jack, 1,
 				       &simple_card_mic_jack_gpio);
 	}
@@ -381,6 +385,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 				     struct simple_card_data *priv)
 {
 	struct device *dev = simple_priv_to_dev(priv);
+	enum of_gpio_flags flags;
 	u32 val;
 	int ret;
 
@@ -436,13 +441,15 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			return ret;
 	}
 
-	priv->gpio_hp_det = of_get_named_gpio(node,
-				"simple-audio-card,hp-det-gpio", 0);
+	priv->gpio_hp_det = of_get_named_gpio_flags(node,
+				"simple-audio-card,hp-det-gpio", 0, &flags);
+	priv->gpio_hp_det_invert = !!(flags & OF_GPIO_ACTIVE_LOW);
 	if (priv->gpio_hp_det == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
-	priv->gpio_mic_det = of_get_named_gpio(node,
-				"simple-audio-card,mic-det-gpio", 0);
+	priv->gpio_mic_det = of_get_named_gpio_flags(node,
+				"simple-audio-card,mic-det-gpio", 0, &flags);
+	priv->gpio_mic_det_invert = !!(flags & OF_GPIO_ACTIVE_LOW);
 	if (priv->gpio_mic_det == -EPROBE_DEFER)
 		return -EPROBE_DEFER;
 
-- 
1.9.1


