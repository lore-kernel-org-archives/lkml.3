Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaKQK7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:59:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37983 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbaKQK7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:59:15 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, ben-linux@fluff.org,
        kgene.kim@samsung.com, broonie@kernel.org
Cc: perex@perex.cz, tiwai@suse.de, galak@codeaurora.org, sbkim73@samsung.com,
        lgirdwood@gmail.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH] ASoC: samsung-i2s: Add 192kHz config option
Date: Mon, 17 Nov 2014 10:57:54 +0000
Message-Id: <1416221874-22092-1-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds QUIRK_SUPPORTS_192KHZ to allow 192kHz rate
to be selected for hardware that supports it.

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
---
 .../devicetree/bindings/sound/samsung-i2s.txt      |    2 ++
 include/linux/platform_data/asoc-s3c.h             |    1 +
 sound/soc/samsung/i2s.c                            |    8 ++++++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/samsung-i2s.txt b/Documentation/devicetree/bindings/sound/samsung-i2s.txt
index d188296..c3f3950 100644
--- a/Documentation/devicetree/bindings/sound/samsung-i2s.txt
+++ b/Documentation/devicetree/bindings/sound/samsung-i2s.txt
@@ -40,6 +40,8 @@ Optional SoC Specific Properties:
   sub system(used in secondary sound source).
 - pinctrl-0: Should specify pin control groups used for this controller.
 - pinctrl-names: Should contain only one value - "default".
+- samsung,supports-192khz: specify this (without a value) if you want to allow
+    192000 sample rate over the I2S link.
 
 Example:
 
diff --git a/include/linux/platform_data/asoc-s3c.h b/include/linux/platform_data/asoc-s3c.h
index 5e0bc77..6d0702d 100644
--- a/include/linux/platform_data/asoc-s3c.h
+++ b/include/linux/platform_data/asoc-s3c.h
@@ -28,6 +28,7 @@ struct samsung_i2s {
 #define QUIRK_NEED_RSTCLR	(1 << 3)
 #define QUIRK_SUPPORTS_TDM	(1 << 4)
 #define QUIRK_SUPPORTS_IDMA	(1 << 5)
+#define QUIRK_SUPPORTS_192KHZ	(1 << 6)
 	/* Quirks of the I2S controller */
 	u32 quirks;
 	dma_addr_t idma_addr;
diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 947352d..f688e89 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1219,6 +1219,9 @@ static int samsung_i2s_probe(struct platform_device *pdev)
 						"specified");
 			}
 		}
+
+		if (of_find_property(np, "samsung,supports-192khz", NULL))
+			quirks |= QUIRK_SUPPORTS_192KHZ;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1247,6 +1250,11 @@ static int samsung_i2s_probe(struct platform_device *pdev)
 	if (quirks & QUIRK_PRI_6CHAN)
 		pri_dai->i2s_dai_drv.playback.channels_max = 6;
 
+	if (quirks & QUIRK_SUPPORTS_192KHZ) {
+		pri_dai->i2s_dai_drv.playback.rates |= SNDRV_PCM_RATE_192000;
+		pri_dai->i2s_dai_drv.capture.rates |= SNDRV_PCM_RATE_192000;
+	}
+
 	if (quirks & QUIRK_SEC_DAI) {
 		sec_dai = i2s_alloc_dai(pdev, true);
 		if (!sec_dai) {
-- 
1.7.2.5

