Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3LYEN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 23:13:28 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:47813
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab3LYEN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 23:13:27 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <shawn.guo@linaro.org>, <timur@tabi.org>, <lgirdwood@gmail.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <b47053@freescale.com>
Subject: [PATCH] ASoC: fsl_sai: Move the global registers setting to _dai_probe()
Date: Wed, 25 Dec 2013 11:20:14 +0800
Message-ID: <1387941614-7629-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because we cannot make sure which one of _dai_fmt() and _dai_sysclk()
will be firstly called. So move the RCSR/TCSR and TCR1/RCR1's
initialization to _dai_probe(), and this can make sure that before any
of {T,R}CR{1~5} register to be set the RCSR/TCSR's RE/TE bit has been
cleared for the hareware limitation.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/fsl/fsl_sai.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index b72132f..596aabb 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -100,11 +100,6 @@ static int fsl_sai_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
 	if (ret)
 		return ret;
 
-	sai_writel(sai, 0x0, sai->base + FSL_SAI_RCSR);
-	sai_writel(sai, 0x0, sai->base + FSL_SAI_TCSR);
-	sai_writel(sai, FSL_SAI_MAXBURST_TX * 2, sai->base + FSL_SAI_TCR1);
-	sai_writel(sai, FSL_SAI_MAXBURST_RX - 1, sai->base + FSL_SAI_RCR1);
-
 	ret = fsl_sai_set_dai_sysclk_tr(cpu_dai, clk_id, freq,
 					FSL_FMT_TRANSMITTER);
 	if (ret) {
@@ -351,6 +346,18 @@ static const struct snd_soc_dai_ops fsl_sai_pcm_dai_ops = {
 static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
 {
 	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
+	int ret;
+
+	ret = clk_prepare_enable(sai->clk);
+	if (ret)
+		return ret;
+
+	sai_writel(sai, 0x0, sai->base + FSL_SAI_RCSR);
+	sai_writel(sai, 0x0, sai->base + FSL_SAI_TCSR);
+	sai_writel(sai, FSL_SAI_MAXBURST_TX * 2, sai->base + FSL_SAI_TCR1);
+	sai_writel(sai, FSL_SAI_MAXBURST_RX - 1, sai->base + FSL_SAI_RCR1);
+
+	clk_disable_unprepare(sai->clk);
 
 	snd_soc_dai_init_dma_data(cpu_dai, &sai->dma_params_tx,
 				&sai->dma_params_rx);
-- 
1.8.4


