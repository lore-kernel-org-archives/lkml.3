Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaFCMMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:12:42 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:52112 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaFCMMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:12:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: fsl: refine DMA/FIQ dependencies
Date: Tue, 03 Jun 2014 14:11:56 +0200
Message-ID: <6452477.9e3eS6Cip1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tdws1u9bl/a99ZLRsHPb/NE4DmnoFc+Yb2qP6KmQofV
 t0Ykx41juQsKPN6tEqgqndpawkZoMAHLWcvSOf7obR8ki+g1Sr
 hHe67Lu7T8Vh9FYxY/qap5bn267OQgmR21u4bulqCvFzRUr1tH
 mDCtlVAhOdkq34dVOiB7MKdzP+/vg6L5CRkiA+kMExDth62CRH
 U0tB7DCYmnHo/8UCv/NX8ZCL59BRYvgHvx4YKwwxWphSXaPXhM
 sr8NBjhYHme2Y/PymGJsMCI0lW+kq1RdvBpQAO4IQIG8g1TimK
 W+UmL3ykOE8glYNcbZlRe3pFM+/Z81SnptwMvBQqYzqY+YFPIf
 sfzXV4C+dGBU4L0zOZUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 31ee2bfd724ab ("ASoC: fsl: select SND_SOC_IMX_PCM_DMA
where needed") started selecting SND_SOC_IMX_PCM_DMA and
SND_SOC_IMX_PCM_FIQ for two drivers when building for i.MX.
This has turned out too aggressive, as FIQ is only available
for i.mx2 through i.mx5, but not i.mx6 or vybrid.

Further, two more drivers have become user-selectable in the
meantime, and they both depend on DMA for the imx platform
as well.

This changes the selection of FIQ to depend on the TZIC or
AVIC interrupt controllers that actually export the imx
specific FIQ interfaces, and adds the missing select statements
for SAI and ESAI.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index 3793362..52bbe9f 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -5,6 +5,7 @@ comment "Common SoC Audio options for Freescale CPUs:"
 config SND_SOC_FSL_SAI
 	tristate "Synchronous Audio Interface (SAI) module support"
 	select REGMAP_MMIO
+	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Say Y if you want to add Synchronous Audio Interface (SAI)
@@ -15,7 +16,7 @@ config SND_SOC_FSL_SAI
 config SND_SOC_FSL_SSI
 	tristate "Synchronous Serial Interface module support"
 	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
-	select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && ARCH_MXC
+	select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && (MXC_TZIC || MXC_AVIC)
 	select REGMAP_MMIO
 	help
 	  Say Y if you want to add Synchronous Serial Interface (SSI)
@@ -27,7 +28,7 @@ config SND_SOC_FSL_SPDIF
 	tristate "Sony/Philips Digital Interface module support"
 	select REGMAP_MMIO
 	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
-	select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && ARCH_MXC
+	select SND_SOC_IMX_PCM_FIQ if SND_IMX_SOC != n && (MXC_TZIC || MXC_AVIC)
 	help
 	  Say Y if you want to add Sony/Philips Digital Interface (SPDIF)
 	  support for the Freescale CPUs.
@@ -37,6 +38,7 @@ config SND_SOC_FSL_SPDIF
 config SND_SOC_FSL_ESAI
 	tristate "Enhanced Serial Audio Interface (ESAI) module support"
 	select REGMAP_MMIO
+	select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
 	select SND_SOC_FSL_UTILS
 	help
 	  Say Y if you want to add Enhanced Synchronous Audio Interface

