Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbbAFLOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:14:46 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42801 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbbAFLOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:14:45 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Mark Brown <broonie@kernel.org>, Bo Shen <voice.shen@atmel.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ASoC: sam9g20_wm8731: drop machine_is_xxx
Date: Tue,  6 Jan 2015 12:14:32 +0100
Message-Id: <1420542872-10015-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atmel based boards can now only be used with device tree. Drop non DT
initialization.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 sound/soc/atmel/sam9g20_wm8731.c | 68 ++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index 531728975bbb..639a85d0999c 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -46,8 +46,6 @@
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
 
-#include <asm/mach-types.h>
-
 #include "../codecs/wm8731.h"
 #include "atmel-pcm.h"
 #include "atmel_ssc_dai.h"
@@ -197,9 +195,7 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 	int ret;
 
 	if (!np) {
-		if (!(machine_is_at91sam9g20ek() ||
-			machine_is_at91sam9g20ek_2mmc()))
-			return -ENODEV;
+		return -ENODEV;
 	}
 
 	ret = atmel_ssc_set_audio(0);
@@ -236,39 +232,37 @@ static int at91sam9g20ek_audio_probe(struct platform_device *pdev)
 	card->dev = &pdev->dev;
 
 	/* Parse device node info */
-	if (np) {
-		ret = snd_soc_of_parse_card_name(card, "atmel,model");
-		if (ret)
-			goto err;
-
-		ret = snd_soc_of_parse_audio_routing(card,
-			"atmel,audio-routing");
-		if (ret)
-			goto err;
-
-		/* Parse codec info */
-		at91sam9g20ek_dai.codec_name = NULL;
-		codec_np = of_parse_phandle(np, "atmel,audio-codec", 0);
-		if (!codec_np) {
-			dev_err(&pdev->dev, "codec info missing\n");
-			return -EINVAL;
-		}
-		at91sam9g20ek_dai.codec_of_node = codec_np;
-
-		/* Parse dai and platform info */
-		at91sam9g20ek_dai.cpu_dai_name = NULL;
-		at91sam9g20ek_dai.platform_name = NULL;
-		cpu_np = of_parse_phandle(np, "atmel,ssc-controller", 0);
-		if (!cpu_np) {
-			dev_err(&pdev->dev, "dai and pcm info missing\n");
-			return -EINVAL;
-		}
-		at91sam9g20ek_dai.cpu_of_node = cpu_np;
-		at91sam9g20ek_dai.platform_of_node = cpu_np;
-
-		of_node_put(codec_np);
-		of_node_put(cpu_np);
+	ret = snd_soc_of_parse_card_name(card, "atmel,model");
+	if (ret)
+		goto err;
+
+	ret = snd_soc_of_parse_audio_routing(card,
+		"atmel,audio-routing");
+	if (ret)
+		goto err;
+
+	/* Parse codec info */
+	at91sam9g20ek_dai.codec_name = NULL;
+	codec_np = of_parse_phandle(np, "atmel,audio-codec", 0);
+	if (!codec_np) {
+		dev_err(&pdev->dev, "codec info missing\n");
+		return -EINVAL;
+	}
+	at91sam9g20ek_dai.codec_of_node = codec_np;
+
+	/* Parse dai and platform info */
+	at91sam9g20ek_dai.cpu_dai_name = NULL;
+	at91sam9g20ek_dai.platform_name = NULL;
+	cpu_np = of_parse_phandle(np, "atmel,ssc-controller", 0);
+	if (!cpu_np) {
+		dev_err(&pdev->dev, "dai and pcm info missing\n");
+		return -EINVAL;
 	}
+	at91sam9g20ek_dai.cpu_of_node = cpu_np;
+	at91sam9g20ek_dai.platform_of_node = cpu_np;
+
+	of_node_put(codec_np);
+	of_node_put(cpu_np);
 
 	ret = snd_soc_register_card(card);
 	if (ret) {
-- 
2.1.0

