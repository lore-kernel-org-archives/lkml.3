Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab3BEQVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:21:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab3BEQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:21:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 05/15] ASoC: fsl: fiq and dma cannot both be modules
Date: Tue, 5 Feb 2013 16:21:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <20130122035028.GB29677@S2100-06.ap.freescale.net> <20130122063331.GA1766@opensource.wolfsonmicro.com>
In-Reply-To: <20130122063331.GA1766@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302051621.12320.arnd@arndb.de>
X-Provags-ID: V02:K0:srfrSNJennB3w3P1d9GvmGOFDm2/ecVrN9RJZ393GZl
 mNxBS7jBf+P/eyh6/LZ/6ejVQ2V+ytSLNbWbw4H9j3IMiOueB0
 n1CaMB3URmim2aLJnxK2B5QGCc3d06blnLfovJpSUHPbK/HOfl
 DM288m/gVEqz3x0+ugTHzNV4OFHCbNUd7QVymImSwdrE5fPBu+
 kXykT3pv3c9uxrkWistGenKtSj/kuW/d4NK/Ixg9QhletbN7nd
 Y3JCwYnLcYOoymT7HrJr6fopK312j8PpymlT23CsUWbWzoQWfj
 m9CutUsUIUDrXgaqI5mOPrxaLafi1WE4mPi0qlvaeN5FS6d9Hb
 xV4dHHDWzJHHfbESygNI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Mark Brown wrote:
>   Show Details
>   On Tue, Jan 22, 2013 at 11:50:30AM +0800, Shawn Guo wrote:
> > On Mon, Jan 21, 2013 at 05:15:58PM +0000, Arnd Bergmann wrote:
> 
> > > Without this patch, we cannot build the ARM 'allmodconfig', or
> > > we get this error:
> 
> > > sound/soc/fsl/imx-pcm-dma.o: In function `init_module':
> > > sound/soc/fsl/imx-pcm-dma.c:177: multiple definition of `init_module'
> > > sound/soc/fsl/imx-pcm-fiq.o:sound/soc/fsl/imx-pcm-fiq.c:334: first defined here
> > > sound/soc/fsl/imx-pcm-dma.o: In function `cleanup_module':
> > > sound/soc/fsl/imx-pcm-dma.c:177: multiple definition of `cleanup_module'
> > > sound/soc/fsl/imx-pcm-fiq.o:sound/soc/fsl/imx-pcm-fiq.c:334: first defined here
> 
> > I sent a fix [1] for that queued by Mark.
> 
> > Mark,
> 
> > Is the patch on the way to 3.8-rc?
> 
> Yes, should be.
>   

Hmm, I tried building 3.8-rc again, which contains the fix to make
'make allmodconfig' work with this code, but it broke 'make allyesconfig', which
was working before :(

8<----------
Subject: [PATCH] ASoC: fsl: fix allyesconfig build for imx-pcm

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

diff --git a/sound/soc/fsl/Kconfig b/sound/soc/fsl/Kconfig
index e24e417..3f20cb7 100644
--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -122,7 +122,7 @@ config SND_SOC_IMX_AUDMUX
 config SND_MXC_SOC_WM1133_EV1
 	tristate "Audio on the i.MX31ADS with WM1133-EV1 fitted"
 	depends on MACH_MX31ADS_WM1133_EV1
-	depends on !SND_SOC_IMX_PCM_DMA || SND_IMX_SOC=y
+	depends on !SND_SOC_IMX_PCM_DMA
 	select SND_SOC_WM8350
 	select SND_SOC_IMX_PCM_FIQ
 	select SND_SOC_IMX_AUDMUX
@@ -145,7 +145,7 @@ config SND_SOC_MX27VIS_AIC32X4
 config SND_SOC_PHYCORE_AC97
 	tristate "SoC Audio support for Phytec phyCORE (and phyCARD) boards"
 	depends on MACH_PCM043 || MACH_PCA100
-	depends on !SND_SOC_IMX_PCM_DMA || SND_IMX_SOC=y
+	depends on !SND_SOC_IMX_PCM_DMA
 	select SND_SOC_AC97_BUS
 	select SND_SOC_WM9712
 	select SND_SOC_IMX_PCM_FIQ
@@ -162,7 +162,7 @@ config SND_SOC_EUKREA_TLV320
 		|| MACH_EUKREA_MBIMXSD35_BASEBOARD \
 		|| MACH_EUKREA_MBIMXSD51_BASEBOARD
 	depends on I2C
-	depends on !SND_SOC_IMX_PCM_DMA || SND_IMX_SOC=y
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
