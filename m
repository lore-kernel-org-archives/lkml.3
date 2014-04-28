Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbaD1OLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:11:15 -0400
Received: from ring0.de ([5.45.105.125]:52057 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbaD1OIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:08:14 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv2 8/9] ASoC: omap: rx51: Add DT support
Date: Mon, 28 Apr 2014 16:07:26 +0200
Message-Id: <1398694047-28596-9-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398694047-28596-1-git-send-email-sre@kernel.org>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the Nokia N900 audio driver and
adds documentation for the DT binding.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 .../devicetree/bindings/sound/nokia,rx51.txt       | 27 +++++++++++
 sound/soc/omap/rx51.c                              | 53 ++++++++++++++++++++++
 2 files changed, 80 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/nokia,rx51.txt

diff --git a/Documentation/devicetree/bindings/sound/nokia,rx51.txt b/Documentation/devicetree/bindings/sound/nokia,rx51.txt
new file mode 100644
index 0000000..72f93d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/nokia,rx51.txt
@@ -0,0 +1,27 @@
+* Nokia N900 audio setup
+
+Required properties:
+- compatible: Should contain "nokia,n900-audio"
+- nokia,cpu-dai: phandle for the McBSP node
+- nokia,audio-codec: phandles for the main TLV320AIC3X node and the
+                     auxiliary TLV320AIC3X node (in this order)
+- nokia,headphone-amplifier: phandle for the TPA6130A2 node
+- tvout-selection-gpios: GPIO for tvout selection
+- jack-detection-gpios: GPIO for jack detection
+- eci-switch-gpios: GPIO for ECI (Enhancement Control Interface) switch
+- speaker-amplifier-gpios: GPIO for speaker amplifier
+
+Example:
+
+sound {
+	compatible = "nokia,n900-audio";
+
+	nokia,cpu-dai = <&mcbsp2>;
+	nokia,audio-codec = <&tlv320aic3x>, <&tlv320aic3x_aux>;
+	nokia,headphone-amplifier = <&tpa6130a2>;
+
+	tvout-selection-gpios = <&gpio2 8 GPIO_ACTIVE_HIGH>; /* 40 */
+	jack-detection-gpios = <&gpio6 17 GPIO_ACTIVE_HIGH>; /* 177 */
+	eci-switch-gpios = <&gpio6 22 GPIO_ACTIVE_HIGH>; /* 182 */
+	speaker-amplifier-gpios = <&twl_gpio 7 GPIO_ACTIVE_HIGH>;
+};
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 110deca..866578b 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -386,6 +386,7 @@ static struct snd_soc_card rx51_sound_card = {
 static int rx51_soc_probe(struct platform_device *pdev)
 {
 	struct rx51_audio_pdata *pdata;
+	struct device_node *np = pdev->dev.of_node;
 	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
@@ -394,6 +395,49 @@ static int rx51_soc_probe(struct platform_device *pdev)
 
 	card->dev = &pdev->dev;
 
+	if (np) {
+		struct device_node *dai_node;
+
+		dai_node = of_parse_phandle(np, "nokia,cpu-dai", 0);
+		if (!dai_node) {
+			dev_err(&pdev->dev, "McBSP node is not provided\n");
+			return -EINVAL;
+		}
+		rx51_dai[0].cpu_dai_name = NULL;
+		rx51_dai[0].platform_name = NULL;
+		rx51_dai[0].cpu_of_node = dai_node;
+		rx51_dai[0].platform_of_node = dai_node;
+
+		dai_node = of_parse_phandle(np, "nokia,audio-codec", 0);
+		if (!dai_node) {
+			dev_err(&pdev->dev, "Codec node is not provided\n");
+			return -EINVAL;
+		}
+		rx51_dai[0].codec_name = NULL;
+		rx51_dai[0].codec_of_node = dai_node;
+
+		dai_node = of_parse_phandle(np, "nokia,audio-codec", 1);
+		if (!dai_node) {
+			dev_err(&pdev->dev, "Auxiliary Codec node is not provided\n");
+			return -EINVAL;
+		}
+		rx51_aux_dev[0].codec_name = NULL;
+		rx51_aux_dev[0].codec_of_node = dai_node;
+		rx51_codec_conf[0].dev_name = NULL;
+		rx51_codec_conf[0].of_node = dai_node;
+
+		dai_node = of_parse_phandle(np, "nokia,headphone-amplifier", 0);
+		if (!dai_node) {
+			dev_err(&pdev->dev, "Headphone amplifier node is not provided\n");
+			return -EINVAL;
+		}
+
+		/* TODO: tpa6130a2a driver supports only a single instance, so
+		 * this driver ignores the headphone-amplifier node for now.
+		 * It's already mandatory in the DT binding to be future proof.
+		 */
+	}
+
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (pdata == NULL) {
 		dev_err(card->dev, "failed to create private data\n");
@@ -463,10 +507,19 @@ static int rx51_soc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id rx51_audio_of_match[] = {
+	{ .compatible = "nokia,n900-audio", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, rx51_audio_of_match);
+#endif
+
 static struct platform_driver rx51_soc_driver = {
 	.driver = {
 		.name = "rx51-audio",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(rx51_audio_of_match),
 	},
 	.probe = rx51_soc_probe,
 	.remove = rx51_soc_remove,
-- 
1.9.2

