Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3AURUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:20:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3AURRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Shawn Guo <shawn.guo@linaro.org>, alsa-devel@alsa-project.org
Subject: [PATCH 05/15] ASoC: fsl: fiq and dma cannot both be modules
Date: Mon, 21 Jan 2013 17:15:58 +0000
Message-Id: <1358788568-11137-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:XEGaj0ETPUirJfOPrioqed44CWbhVE+Bos28ft9EbLc
 PJiv2XUkP31ruzJiEjx7GU4BzQGM4TqeaPF2ycb/qvKn0H9qYi
 yZ/bObS/VD9y1cFi0CWDzhVai11SZFAsYXy5OPdUqUlcmJILaw
 swqVXJWYezdfAGNSA3ZdILdYWX2LMH+8Cf6T0RucEG6gFVS+Ct
 pL7v1ZUrgEULMBV1JO3mmRSrTLH6U16Wj+gFVHwqoPkMXlp85w
 ryyEusVvLAPBvIv/3KVuFGEk0NywXY2YqMr9c9jCQrBXb6XnjK
 lTILIoBeiK6dJK3IwUL/df0Fj06GfDpP8TMMg1x3L37NH4Ek+E
 PnsXC9i9mtbIEeg5I5DQ0QLdPcN6HAtiRBmUc6DjB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma and fiq portions of the imx-pcm driver both
have a module_init() call, of which there can be only
one in any given module. This changes Kconfig to enforce
either the driver to be built-in in the kernel, or
to have only one of the two when building imx-pcm as
a module.

Without this patch, we cannot build the ARM 'allmodconfig', or
we get this error:

sound/soc/fsl/imx-pcm-dma.o: In function `init_module':
sound/soc/fsl/imx-pcm-dma.c:177: multiple definition of `init_module'
sound/soc/fsl/imx-pcm-fiq.o:sound/soc/fsl/imx-pcm-fiq.c:334: first defined here
sound/soc/fsl/imx-pcm-dma.o: In function `cleanup_module':
sound/soc/fsl/imx-pcm-dma.c:177: multiple definition of `cleanup_module'
sound/soc/fsl/imx-pcm-fiq.o:sound/soc/fsl/imx-pcm-fiq.c:334: first defined here

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/fsl/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 3b98159..282b08e 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -127,6 +127,7 @@ config SND_SOC_IMX_AUDMUX
 config SND_MXC_SOC_WM1133_EV1
 	tristate "Audio on the i.MX31ADS with WM1133-EV1 fitted"
 	depends on MACH_MX31ADS_WM1133_EV1
+	depends on !SND_SOC_IMX_PCM_DMA || SND_IMX_SOC=y
 	select SND_SOC_WM8350
 	select SND_SOC_IMX_PCM_FIQ
 	select SND_SOC_IMX_AUDMUX
@@ -149,6 +150,7 @@ config SND_SOC_MX27VIS_AIC32X4
 config SND_SOC_PHYCORE_AC97
 	tristate "SoC Audio support for Phytec phyCORE (and phyCARD) boards"
 	depends on MACH_PCM043 || MACH_PCA100
+	depends on !SND_SOC_IMX_PCM_DMA || SND_IMX_SOC=y
 	select SND_SOC_AC97_BUS
 	select SND_SOC_WM9712
 	select SND_SOC_IMX_PCM_FIQ
@@ -165,6 +167,7 @@ config SND_SOC_EUKREA_TLV320
 		|| MACH_EUKREA_MBIMXSD35_BASEBOARD \
 		|| MACH_EUKREA_MBIMXSD51_BASEBOARD
 	depends on I2C
+	depends on !SND_SOC_IMX_PCM_DMA || SND_IMX_SOC=y
 	select SND_SOC_TLV320AIC23
 	select SND_SOC_IMX_PCM_FIQ
 	select SND_SOC_IMX_AUDMUX
-- 
1.7.10.4

