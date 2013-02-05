Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3BEQme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:42:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3BEQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:42:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] ASoC: fsl: fix allyesconfig build for imx-pcm
Date: Tue, 5 Feb 2013 16:42:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <20130122063331.GA1766@opensource.wolfsonmicro.com> <201302051621.12320.arnd@arndb.de>
In-Reply-To: <201302051621.12320.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051642.25361.arnd@arndb.de>
X-Provags-ID: V02:K0:c1IaMVRP87obXeLX4kTMw4upwSxNzFyNjq3BpzPt1CS
 QCKBjGbJp5SRjpgnT4RCCaVz/zdU2pYH0ByWLJrt6Y1a1yLxQo
 31ATeHr1rFqCxXbZCtUCQ69Ykvm/cCOfLcD+EuPJv3y3E/40Oq
 Ydm2RzpZtS/7dMH0hss1kSwpxYqFXqUcAEZIK+0QzYorKdONx3
 9ojuKfz1pVEhOufxbW+5I/5ih9wOlGEZJ+DLxnRH4riQP2Gk8F
 h/gCAf3s+F10xWjSpT69fVMpgFlIQwv+4KqM3JYgLo37sqSww/
 uFDPfGgGZO2YGO8dr29hBxXsnlhmhc+A4f40nQxHg39/A1limd
 3r/SoUZMhNhJommmz6A0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 25b8d314 "ASoC: fsl: fix multiple definition of init_module changed
the Makefile for imx-pcm.ko to build two modules that both contain the
imx-pcm.c file, which nicely solves the problem of building both versions
of the driver as modules, but it causes two new problems:

1. Since imx-pcm.c is now used in two different modules, Kbuild no longer
sets the KBUILD_MODNAME symbol when building the object file, which makes
it impossible to use dynamic pr_debug code, resulting in this error

sound/soc/fsl/imx-pcm.c: In function 'snd_imx_pcm_mmap':
sound/soc/fsl/imx-pcm.c:28:121: error: 'KBUILD_MODNAME' undeclared (first use in this function)
sound/soc/fsl/imx-pcm.c:28:121: note: each undeclared identifier is reported only once for each function it appears insound/soc/fsl/snd-soc-imx-pcm-dma.o: In function `imx_pcm_free':

2. If we don't use the dynamic debug code, we get a link error since we now
try to link together the same file into built-in.o twice:

sound/soc/fsl/imx-pcm.c:80: multiple definition of `imx_pcm_free'
sound/soc/fsl/snd-soc-imx-pcm-fiq.o:/sound/soc/fsl/imx-pcm.c:80: first defined here
sound/soc/fsl/snd-soc-imx-pcm-dma.o: In function `snd_imx_pcm_mmap':
sound/soc/fsl/imx-pcm.c:21: multiple definition of `snd_imx_pcm_mmap'
sound/soc/fsl/snd-soc-imx-pcm-fiq.o:/sound/soc/fsl/imx-pcm.c:21: first defined here
sound/soc/fsl/snd-soc-imx-pcm-dma.o: In function `imx_pcm_new':
sound/soc/fsl/imx-pcm.c:52: multiple definition of `imx_pcm_new'
sound/soc/fsl/snd-soc-imx-pcm-fiq.o:/sound/soc/fsl/imx-pcm.c:52: first defined here

I originally suggested disallowing the selection of both the DMA and FIQ
code in the same kernel. That is not very nice, but it resolves the
build error for both built-in and modular code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
----
Sorry, the previous version did not apply, it was on top of my older patch accidentally

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index a210c8d..3f20cb7 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -122,6 +122,7 @@ config SND_SOC_IMX_AUDMUX
 config SND_MXC_SOC_WM1133_EV1
 	tristate "Audio on the i.MX31ADS with WM1133-EV1 fitted"
 	depends on MACH_MX31ADS_WM1133_EV1
+	depends on !SND_SOC_IMX_PCM_DMA
 	select SND_SOC_WM8350
 	select SND_SOC_IMX_PCM_FIQ
 	select SND_SOC_IMX_AUDMUX
@@ -144,6 +145,7 @@ config SND_SOC_MX27VIS_AIC32X4
 config SND_SOC_PHYCORE_AC97
 	tristate "SoC Audio support for Phytec phyCORE (and phyCARD) boards"
 	depends on MACH_PCM043 || MACH_PCA100
+	depends on !SND_SOC_IMX_PCM_DMA
 	select SND_SOC_AC97_BUS
 	select SND_SOC_WM9712
 	select SND_SOC_IMX_PCM_FIQ
@@ -160,6 +162,7 @@ config SND_SOC_EUKREA_TLV320
 		|| MACH_EUKREA_MBIMXSD35_BASEBOARD \
 		|| MACH_EUKREA_MBIMXSD51_BASEBOARD
 	depends on I2C
+	depends on !SND_SOC_IMX_PCM_DMA
 	select SND_SOC_TLV320AIC23
 	select SND_SOC_IMX_PCM_FIQ
 	select SND_SOC_IMX_AUDMUX
diff --git a/sound/soc/fsl/Makefile b/sound/soc/fsl/Makefile
index ec14579..ddd9076 100644
--- a/sound/soc/fsl/Makefile
+++ b/sound/soc/fsl/Makefile
@@ -30,13 +30,6 @@ obj-$(CONFIG_SND_MPC52xx_SOC_EFIKA) += efika-audio-fabric.o
 # i.MX Platform Support
 snd-soc-imx-ssi-objs := imx-ssi.o
 snd-soc-imx-audmux-objs := imx-audmux.o
-snd-soc-imx-pcm-objs := imx-pcm.o
-ifneq ($(CONFIG_SND_SOC_IMX_PCM_FIQ),)
-	snd-soc-imx-pcm-objs += imx-pcm-fiq.o
-endif
-ifneq ($(CONFIG_SND_SOC_IMX_PCM_DMA),)
-	snd-soc-imx-pcm-objs += imx-pcm-dma.o
-endif
 
 obj-$(CONFIG_SND_SOC_IMX_SSI) += snd-soc-imx-ssi.o
 obj-$(CONFIG_SND_SOC_IMX_AUDMUX) += snd-soc-imx-audmux.o
