Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab3ILSRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:17:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002Ab3ILSPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Mark Brown <broonie@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 12/16] ASoC: fsl: Fix module build
Date: Thu, 12 Sep 2013 11:15:04 -0700
Message-Id: <20130912181157.536195478@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 3f1a91aa25579ba5e7268a47a73d2a83e4802c62 upstream.

Building imx_v6_v7_defconfig with all audio drivers as modules results in
the folowing build error:

ERROR: "imx_pcm_fiq_init" [sound/soc/fsl/snd-soc-imx-ssi.ko] undefined!
ERROR: "imx_pcm_dma_init" [sound/soc/fsl/snd-soc-imx-ssi.ko] undefined!
ERROR: "imx_pcm_fiq_exit" [sound/soc/fsl/snd-soc-imx-ssi.ko] undefined!
ERROR: "imx_pcm_dma_exit" [sound/soc/fsl/snd-soc-imx-ssi.ko] undefined!
ERROR: "imx_pcm_dma_init" [sound/soc/fsl/snd-soc-fsl-ssi.ko] undefined!
ERROR: "imx_pcm_dma_exit" [sound/soc/fsl/snd-soc-fsl-ssi.ko] undefined!

Fix this by allowing SND_SOC_IMX_PCM_FIQ and SND_SOC_IMX_PCM_DMA to be also
built as modules and by using 'IS_ENABLED' to cover the module case.

Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
[Guenter Roeck: back-ported to 3.11]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/Kconfig   |    4 ++--
 sound/soc/fsl/imx-pcm.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/fsl/Kconfig
+++ b/sound/soc/fsl/Kconfig
@@ -109,11 +109,11 @@ config SND_SOC_IMX_SSI
 	tristate
 
 config SND_SOC_IMX_PCM_FIQ
-	bool
+	tristate
 	select FIQ
 
 config SND_SOC_IMX_PCM_DMA
-	bool
+	tristate
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 
 config SND_SOC_IMX_AUDMUX
--- a/sound/soc/fsl/imx-pcm.h
+++ b/sound/soc/fsl/imx-pcm.h
@@ -32,7 +32,7 @@ imx_pcm_dma_params_init_data(struct imx_
 		dma_data->peripheral_type = IMX_DMATYPE_SSI;
 }
 
-#ifdef CONFIG_SND_SOC_IMX_PCM_DMA
+#if IS_ENABLED(CONFIG_SND_SOC_IMX_PCM_DMA)
 int imx_pcm_dma_init(struct platform_device *pdev);
 void imx_pcm_dma_exit(struct platform_device *pdev);
 #else
@@ -46,7 +46,7 @@ static inline void imx_pcm_dma_exit(stru
 }
 #endif
 
-#ifdef CONFIG_SND_SOC_IMX_PCM_FIQ
+#if IS_ENABLED(CONFIG_SND_SOC_IMX_PCM_FIQ)
 int imx_pcm_fiq_init(struct platform_device *pdev);
 void imx_pcm_fiq_exit(struct platform_device *pdev);
 #else


