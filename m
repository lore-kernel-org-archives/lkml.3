Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaDALeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:34:04 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:46471
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbaDALd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:33:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: [PATCH] ASoC: fsl_sai: Add imx6sx platform support
Date: Tue, 1 Apr 2014 19:34:09 +0800
Message-ID: <1396352049-23554-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next coming i.MX6 Solo X SoC also contains SAI module while we use
imp_pcm_init() for i.MX platform.

So this patch adds one compatible route for imx6sx and updates the DT
doc accordingly.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 Documentation/devicetree/bindings/sound/fsl-sai.txt |  2 +-
 sound/soc/fsl/fsl_sai.c                             | 12 ++++++++++--
 sound/soc/fsl/fsl_sai.h                             |  1 +
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
index 98611a6..35c09fe 100644
--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
@@ -7,7 +7,7 @@ codec/DSP interfaces.
 
 
 Required properties:
-- compatible: Compatible list, contains "fsl,vf610-sai".
+- compatible: Compatible list, contains "fsl,vf610-sai" or "fsl,imx6sx-sai".
 - reg: Offset and length of the register set for the device.
 - clocks: Must contain an entry for each entry in clock-names.
 - clock-names : Must include the "sai" entry.
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index d64c33f..9ed6795 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -22,6 +22,7 @@
 #include <sound/pcm_params.h>
 
 #include "fsl_sai.h"
+#include "imx-pcm.h"
 
 #define FSL_SAI_FLAGS (FSL_SAI_CSR_SEIE |\
 		       FSL_SAI_CSR_FEIE)
@@ -592,6 +593,9 @@ static int fsl_sai_probe(struct platform_device *pdev)
 
 	sai->pdev = pdev;
 
+	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx6sx-sai"))
+		sai->sai_on_imx = true;
+
 	sai->big_endian_regs = of_property_read_bool(np, "big-endian-regs");
 	if (sai->big_endian_regs)
 		fsl_sai_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
@@ -634,12 +638,16 @@ static int fsl_sai_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	return devm_snd_dmaengine_pcm_register(&pdev->dev, NULL,
-			SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
+	if (sai->sai_on_imx)
+		return imx_pcm_dma_init(pdev);
+	else
+		return devm_snd_dmaengine_pcm_register(&pdev->dev, NULL,
+				SND_DMAENGINE_PCM_FLAG_NO_RESIDUE);
 }
 
 static const struct of_device_id fsl_sai_ids[] = {
 	{ .compatible = "fsl,vf610-sai", },
+	{ .compatible = "fsl,imx6sx-sai", },
 	{ /* sentinel */ }
 };
 
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index be26d46..677670d 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -130,6 +130,7 @@ struct fsl_sai {
 	bool big_endian_regs;
 	bool big_endian_data;
 	bool is_dsp_mode;
+	bool sai_on_imx;
 
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
 	struct snd_dmaengine_dai_dma_data dma_params_tx;
-- 
1.8.4


