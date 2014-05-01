Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaEAGty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:49:54 -0400
Received: from fallback4.mail.ru ([94.100.176.42]:34226 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaEAGtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:49:53 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/2] ASoC: mc13783: Add devicetree support
Date: Thu,  1 May 2014 10:49:12 +0400
Message-Id: <1398926952-21820-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds devicetree support for mc13783-codec.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 Documentation/devicetree/bindings/mfd/mc13xxx.txt |  3 +++
 sound/soc/codecs/mc13783.c                        | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/mc13xxx.txt b/Documentation/devicetree/bindings/mfd/mc13xxx.txt
index 1413f39..8aba488 100644
--- a/Documentation/devicetree/bindings/mfd/mc13xxx.txt
+++ b/Documentation/devicetree/bindings/mfd/mc13xxx.txt
@@ -10,6 +10,9 @@ Optional properties:
 - fsl,mc13xxx-uses-touch : Indicate the touchscreen controller is being used
 
 Sub-nodes:
+- codec: Contain the Audio Codec node.
+  - adc-port: Contain PMIC SSI port number used for ADC.
+  - dac-port: Contain PMIC SSI port number used for DAC.
 - leds : Contain the led nodes and initial register values in property
   "led-control". Number of register depends of used IC, for MC13783 is 6,
   for MC13892 is 4, for MC34708 is 1. See datasheet for bits definitions of
diff --git a/sound/soc/codecs/mc13783.c b/sound/soc/codecs/mc13783.c
index 0b0a4ca..9965277 100644
--- a/sound/soc/codecs/mc13783.c
+++ b/sound/soc/codecs/mc13783.c
@@ -22,6 +22,7 @@
  */
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/of.h>
 #include <linux/mfd/mc13xxx.h>
 #include <linux/slab.h>
 #include <sound/core.h>
@@ -748,6 +749,7 @@ static int __init mc13783_codec_probe(struct platform_device *pdev)
 {
 	struct mc13783_priv *priv;
 	struct mc13xxx_codec_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np;
 	int ret;
 
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
@@ -758,7 +760,17 @@ static int __init mc13783_codec_probe(struct platform_device *pdev)
 		priv->adc_ssi_port = pdata->adc_ssi_port;
 		priv->dac_ssi_port = pdata->dac_ssi_port;
 	} else {
-		return -ENOSYS;
+		np = of_get_child_by_name(pdev->dev.parent->of_node, "codec");
+		if (!np)
+			return -ENOSYS;
+
+		ret = of_property_read_u32(np, "adc-port", &priv->adc_ssi_port);
+		if (ret)
+			return ret;
+
+		ret = of_property_read_u32(np, "dac-port", &priv->dac_ssi_port);
+		if (ret)
+			return ret;
 	}
 
 	dev_set_drvdata(&pdev->dev, priv);
-- 
1.8.3.2

