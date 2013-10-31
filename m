Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3JaGdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:33:11 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:1407
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186Ab3JaGdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:33:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <s.hauer@pengutronix.de>, <timur@tabi.org>, <shawn.guo@linaro.org>,
        <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <rob.herring@calxeda.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>, <pawel.moll@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>
Subject: [PATCH v2 3/4] ASoC: fsl_ssi: Add dual fifo mode support
Date: Thu, 31 Oct 2013 14:32:05 +0800
Message-ID: <0e947536358af7bd6e179559006a3526801a1abe.1383197521.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383197521.git.b42378@freescale.com>
References: <cover.1383197521.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By enabling dual fifo mode, it would allow SSI enter a better performance
to transimit/receive data without occasional hardware underrun/overrun.

[ Passed compile-test with mpc85xx_defconfig ]

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 sound/soc/fsl/fsl_ssi.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 35e2773..0dfb7d6 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -143,6 +143,7 @@ struct fsl_ssi_private {
 	bool ssi_on_imx;
 	bool imx_ac97;
 	bool use_dma;
+	bool use_dual_fifo;
 	struct clk *clk;
 	struct snd_dmaengine_dai_dma_data dma_params_tx;
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
@@ -413,6 +414,16 @@ static int fsl_ssi_setup(struct fsl_ssi_private *ssi_private)
 		write_ssi(CCSR_SSI_SOR_WAIT(3), &ssi->sor);
 	}
 
+	if (ssi_private->use_dual_fifo) {
+		write_ssi_mask(&ssi->srcr, 0, CCSR_SSI_SRCR_RFEN1);
+		write_ssi_mask(&ssi->stcr, 0, CCSR_SSI_STCR_TFEN1);
+		write_ssi_mask(&ssi->scr, 0, CCSR_SSI_SCR_TCH_EN);
+	} else {
+		write_ssi_mask(&ssi->srcr, CCSR_SSI_SRCR_RFEN1, 0);
+		write_ssi_mask(&ssi->stcr, CCSR_SSI_STCR_TFEN1, 0);
+		write_ssi_mask(&ssi->scr, CCSR_SSI_SCR_TCH_EN, 0);
+	}
+
 	return 0;
 }
 
@@ -947,7 +958,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 		ssi_private->fifo_depth = 8;
 
 	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx21-ssi")) {
-		u32 dma_events[2];
+		u32 dma_events[2], dmas[4];
 		ssi_private->ssi_on_imx = true;
 
 		ssi_private->clk = devm_clk_get(&pdev->dev, NULL);
@@ -1001,6 +1012,17 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 			dma_events[0], shared ? IMX_DMATYPE_SSI_SP : IMX_DMATYPE_SSI);
 		imx_pcm_dma_params_init_data(&ssi_private->filter_data_rx,
 			dma_events[1], shared ? IMX_DMATYPE_SSI_SP : IMX_DMATYPE_SSI);
+		if (!of_property_read_u32_array(pdev->dev.of_node, "dmas", dmas, 4)
+				&& dmas[2] == IMX_DMATYPE_SSI_DUAL) {
+			ssi_private->use_dual_fifo = true;
+			/* When using dual fifo mode, we need to keep watermark
+			 * as even numbers due to dma script limitation.
+			 */
+			ssi_private->dma_params_tx.maxburst /= 2;
+			ssi_private->dma_params_tx.maxburst *= 2;
+			ssi_private->dma_params_rx.maxburst /= 2;
+			ssi_private->dma_params_rx.maxburst *= 2;
+		}
 	} else if (ssi_private->use_dma) {
 		/* The 'name' should not have any slashes in it. */
 		ret = devm_request_irq(&pdev->dev, ssi_private->irq,
-- 
1.8.4


