Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab3CHJMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:12:36 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:60677 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933331Ab3CHJM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:12:29 -0500
Message-ID: <1362733947.5994.40.camel@x61.thuisdomein>
Subject: [PATCH] [RESEND] ASoC: davinci: drop SFFSDR_FPGA and
 CONFIG_SFFSDR_FPGA
From: Paul Bolle <pebolle@tiscali.nl>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 10:12:27 +0100
In-Reply-To: <1321211714.20271.85.camel@x61.thuisdomein>
References: <1321211714.20271.85.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 09:12:28.0058 (UTC) FILETIME=[0E37BFA0:01CE1BDD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 08bd168696 ("ASoC: Add driver for the Lyrtech SFFSDR board")
added a reference to a Kconfig symbol SFFSDR_FPGA. Commit ac37373b64
("ASoC: DaVinci: Fix SFFSDR compilation error.") added a macro
CONFIG_SFFSDR_FPGA. But there's no Kconfig symbol SFFSDR_FPGA and no
define of CONFIG_SFFSDR_FPGA. So the select of SFFSDR_FPGA is a nop. It
can be dropped. The checks for CONFIG_SFFSDR_FPGA can also be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) First sent over a year ago. Reapplied on top of v3.9-rc1.

1) Still untested, and this might need (build, etc.) testing if we want
to be thorough. But I do not have the hardware and neither do I have the
toolchain needed at hand. The patch should be correct anyhow.

2) Note that there's no file named *plat-sffsdr/sffsdr-fpga.h in the
mainline tree. Neither is there a function or a macro named
sffsdr_fpga_set_codec_fs(). So enabling SFFSDR_FPGA can currently never
work.

 sound/soc/davinci/Kconfig          | 1 -
 sound/soc/davinci/davinci-sffsdr.c | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/sound/soc/davinci/Kconfig b/sound/soc/davinci/Kconfig
index 9e11a14..6a91206 100644
--- a/sound/soc/davinci/Kconfig
+++ b/sound/soc/davinci/Kconfig
@@ -59,7 +59,6 @@ config SND_DAVINCI_SOC_SFFSDR
 	depends on SND_DAVINCI_SOC && MACH_SFFSDR
 	select SND_DAVINCI_SOC_I2S
 	select SND_SOC_PCM3008
-	select SFFSDR_FPGA
 	help
 	  Say Y if you want to add support for SoC audio on
 	  Lyrtech SFFSDR board.
diff --git a/sound/soc/davinci/davinci-sffsdr.c b/sound/soc/davinci/davinci-sffsdr.c
index 5be65aa..ec4cb3a 100644
--- a/sound/soc/davinci/davinci-sffsdr.c
+++ b/sound/soc/davinci/davinci-sffsdr.c
@@ -24,9 +24,6 @@
 
 #include <asm/dma.h>
 #include <asm/mach-types.h>
-#ifdef CONFIG_SFFSDR_FPGA
-#include <asm/plat-sffsdr/sffsdr-fpga.h>
-#endif
 
 #include <mach/edma.h>
 
@@ -53,13 +50,11 @@ static int sffsdr_hw_params(struct snd_pcm_substream *substream,
 	/* Fsref can be 32000, 44100 or 48000. */
 	fs = params_rate(params);
 
-#ifndef CONFIG_SFFSDR_FPGA
 	/* Without the FPGA module, the Fs is fixed at 44100 Hz */
 	if (fs != 44100) {
 		pr_debug("warning: only 44.1 kHz is supported without SFFSDR FPGA module\n");
 		return -EINVAL;
 	}
-#endif
 
 	/* set cpu DAI configuration */
 	ret = snd_soc_dai_set_fmt(cpu_dai, AUDIO_FORMAT);
@@ -68,11 +63,7 @@ static int sffsdr_hw_params(struct snd_pcm_substream *substream,
 
 	pr_debug("sffsdr_hw_params: rate = %d Hz\n", fs);
 
-#ifndef CONFIG_SFFSDR_FPGA
 	return 0;
-#else
-	return sffsdr_fpga_set_codec_fs(fs);
-#endif
 }
 
 static struct snd_soc_ops sffsdr_ops = {
-- 
1.7.11.7

