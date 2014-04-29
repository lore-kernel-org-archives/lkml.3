Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779AbaD2LUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:20:31 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57175 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbaD2LUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:20:24 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 13/15] ASoC: SND_S3C_DMA_LEGACY needs S3C24XX_DMA
Date: Tue, 29 Apr 2014 19:18:34 +0800
Message-Id: <1398770316-19715-14-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

SND_S3C_DMA_LEGACY can only be set on S3C24xx, which does not
(yet) support the dmaengine framework, so samsung_dma_get_ops()
fails to link if S3C24XX_DMA is disabled:

sound/built-in.o: In function `dma_hw_params':
:(.text+0x7f310): undefined reference to `s3c_dma_get_ops'
sound/built-in.o: In function `s3c_ac97_trigger':
:(.text+0x7f7f0): undefined reference to `s3c_dma_get_ops'
sound/built-in.o: In function `s3c_ac97_mic_trigger':
:(.text+0x7f884): undefined reference to `s3c_dma_get_ops'
sound/built-in.o: In function `s3c2412_i2s_trigger':
:(.text+0x80944): undefined reference to `s3c2410_dma_ctrl'

This makes sure S3C24XX_DMA is always enabled when we need
it, just like we do it for the same dependency in SND_S3C24XX_I2S,
which has the same problem. Selecting "S3C2410_DMA" as we did
before does not actually have the intended effect, since
that one is only used on the s3c2410 and s3c2442 SoCs of the
s3c24xx family, but not the others, so we can remove this
from Kconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: alsa-devel@alsa-project.org
---
 sound/soc/samsung/Kconfig |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 99cc196..7b610a8 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -1,7 +1,6 @@
 config SND_SOC_SAMSUNG
 	tristate "ASoC support for Samsung"
 	depends on PLAT_SAMSUNG
-	select S3C2410_DMA if ARCH_S3C24XX
 	select S3C64XX_PL080 if ARCH_S3C64XX
 	select SND_S3C_DMA if !ARCH_S3C24XX
 	select SND_S3C_DMA_LEGACY if ARCH_S3C24XX
@@ -15,11 +14,11 @@ config SND_S3C_DMA
 	tristate
 
 config SND_S3C_DMA_LEGACY
+	select S3C24XX_DMA
 	tristate
 
 config SND_S3C24XX_I2S
 	tristate
-	select S3C24XX_DMA
 
 config SND_S3C_I2SV2_SOC
 	tristate
@@ -27,7 +26,6 @@ config SND_S3C_I2SV2_SOC
 config SND_S3C2412_SOC_I2S
 	tristate
 	select SND_S3C_I2SV2_SOC
-	select S3C2410_DMA
 
 config SND_SAMSUNG_PCM
 	tristate
@@ -83,7 +81,6 @@ config SND_SOC_SAMSUNG_SMDK_WM8994
 config SND_SOC_SAMSUNG_SMDK2443_WM9710
 	tristate "SoC AC97 Audio support for SMDK2443 - WM9710"
 	depends on SND_SOC_SAMSUNG && MACH_SMDK2443
-	select S3C2410_DMA
 	select AC97_BUS
 	select SND_SOC_AC97_CODEC
 	select SND_SAMSUNG_AC97
@@ -94,7 +91,6 @@ config SND_SOC_SAMSUNG_SMDK2443_WM9710
 config SND_SOC_SAMSUNG_LN2440SBC_ALC650
 	tristate "SoC AC97 Audio support for LN2440SBC - ALC650"
 	depends on SND_SOC_SAMSUNG && ARCH_S3C24XX
-	select S3C2410_DMA
 	select AC97_BUS
 	select SND_SOC_AC97_CODEC
 	select SND_SAMSUNG_AC97
-- 
1.7.9.5

