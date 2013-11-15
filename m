Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab3KOQZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:25:36 -0500
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:16965
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab3KOQZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:25:29 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz154dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <timur@tabi.org>, <broonie@kernel.org>, <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <lgirdwood@gmail.com>
Subject: [PATCH v2] ASoC: fsl_ssi: Add monaural audio support for non-ac97 interface
Date: Sat, 16 Nov 2013 00:25:29 +0800
Message-ID: <1384532729-6588-1-git-send-email-b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The normal mode of SSI allows it to send/receive data to/from the first
slot of each period. So we can use this normal mode to trick I2S signal
by puting/getting data to/from the first slot only (the left channel)
so as to support monaural audio playback and recording.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
Changelog
v2:
 * Moved i2s_mode to ssi_private so that we can save and retore it as needed
 * And dropped the horrible static thing.

 sound/soc/fsl/fsl_ssi.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index f43be6d..cba5c4d 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -144,6 +144,7 @@ struct fsl_ssi_private {
 	bool imx_ac97;
 	bool use_dma;
 	bool use_dual_fifo;
+	u8 i2s_mode;
 	struct clk *clk;
 	struct snd_dmaengine_dai_dma_data dma_params_tx;
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
@@ -325,14 +326,13 @@ static irqreturn_t fsl_ssi_isr(int irq, void *dev_id)
 static int fsl_ssi_setup(struct fsl_ssi_private *ssi_private)
 {
 	struct ccsr_ssi __iomem *ssi = ssi_private->ssi;
-	u8 i2s_mode;
 	u8 wm;
 	int synchronous = ssi_private->cpu_dai_drv.symmetric_rates;
 
 	if (ssi_private->imx_ac97)
-		i2s_mode = CCSR_SSI_SCR_I2S_MODE_NORMAL | CCSR_SSI_SCR_NET;
+		ssi_private->i2s_mode = CCSR_SSI_SCR_I2S_MODE_NORMAL | CCSR_SSI_SCR_NET;
 	else
-		i2s_mode = CCSR_SSI_SCR_I2S_MODE_SLAVE;
+		ssi_private->i2s_mode = CCSR_SSI_SCR_I2S_MODE_SLAVE;
 
 	/*
 	 * Section 16.5 of the MPC8610 reference manual says that the SSI needs
@@ -349,7 +349,7 @@ static int fsl_ssi_setup(struct fsl_ssi_private *ssi_private)
 	write_ssi_mask(&ssi->scr,
 		CCSR_SSI_SCR_I2S_MODE_MASK | CCSR_SSI_SCR_SYN,
 		CCSR_SSI_SCR_TFR_CLK_DIS |
-		i2s_mode |
+		ssi_private->i2s_mode |
 		(synchronous ? CCSR_SSI_SCR_SYN : 0));
 
 	write_ssi(CCSR_SSI_STCR_TXBIT0 | CCSR_SSI_STCR_TFEN0 |
@@ -517,6 +517,7 @@ static int fsl_ssi_hw_params(struct snd_pcm_substream *substream,
 {
 	struct fsl_ssi_private *ssi_private = snd_soc_dai_get_drvdata(cpu_dai);
 	struct ccsr_ssi __iomem *ssi = ssi_private->ssi;
+	unsigned int channels = params_channels(hw_params);
 	unsigned int sample_size =
 		snd_pcm_format_width(params_format(hw_params));
 	u32 wl = CCSR_SSI_SxCCR_WL(sample_size);
@@ -546,6 +547,11 @@ static int fsl_ssi_hw_params(struct snd_pcm_substream *substream,
 	else
 		write_ssi_mask(&ssi->srccr, CCSR_SSI_SxCCR_WL_MASK, wl);
 
+	if (!ssi_private->imx_ac97)
+		write_ssi_mask(&ssi->scr,
+				CCSR_SSI_SCR_NET | CCSR_SSI_SCR_I2S_MODE_MASK,
+				channels == 1 ? 0 : ssi_private->i2s_mode);
+
 	return 0;
 }
 
@@ -658,14 +664,13 @@ static const struct snd_soc_dai_ops fsl_ssi_dai_ops = {
 static struct snd_soc_dai_driver fsl_ssi_dai_template = {
 	.probe = fsl_ssi_dai_probe,
 	.playback = {
-		/* The SSI does not support monaural audio. */
-		.channels_min = 2,
+		.channels_min = 1,
 		.channels_max = 2,
 		.rates = FSLSSI_I2S_RATES,
 		.formats = FSLSSI_I2S_FORMATS,
 	},
 	.capture = {
-		.channels_min = 2,
+		.channels_min = 1,
 		.channels_max = 2,
 		.rates = FSLSSI_I2S_RATES,
 		.formats = FSLSSI_I2S_FORMATS,
-- 
1.8.4


