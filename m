Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbaBKGo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:44:57 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:39769 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbaBKGo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:44:56 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097h84d07hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <Guangyu.Chen@freescale.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 1/2] ASoC: fsl-spdif: big-endian support
Date: Tue, 11 Feb 2014 13:41:15 +0800
Message-ID: <1392097276-14705-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For most platforms, the CPU and SPDIF device is in the same endianess
mode. While for the LS1 platform, the CPU is in LE mode and the SPDIF
is in BE mode.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 Documentation/devicetree/bindings/sound/fsl,spdif.txt | 4 ++++
 sound/soc/fsl/fsl_spdif.c                             | 8 +++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl,spdif.txt b/Documentation/devicetree/bindings/sound/fsl,spdif.txt
index f2ae335..433ad00 100644
--- a/Documentation/devicetree/bindings/sound/fsl,spdif.txt
+++ b/Documentation/devicetree/bindings/sound/fsl,spdif.txt
@@ -29,6 +29,10 @@ Required properties:
 			can also be referred to TxClk_Source
 			bit of register SPDIF_STC.
 
+   - big-endian : If this property is absent, the native endian mode will
+   be in use as default, or the big endian mode will be in use for all the
+   device registers.
+
 Example:
 
 spdif: spdif@02004000 {
diff --git a/sound/soc/fsl/fsl_spdif.c b/sound/soc/fsl/fsl_spdif.c
index 8f36f49..2f8ad75 100644
--- a/sound/soc/fsl/fsl_spdif.c
+++ b/sound/soc/fsl/fsl_spdif.c
@@ -83,6 +83,8 @@ struct fsl_spdif_priv {
 	struct snd_dmaengine_dai_dma_data dma_params_tx;
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
 
+	bool big_endian;
+
 	/* The name space will be allocated dynamically */
 	char name[0];
 };
@@ -985,7 +987,7 @@ static bool fsl_spdif_writeable_reg(struct device *dev, unsigned int reg)
 	}
 }
 
-static const struct regmap_config fsl_spdif_regmap_config = {
+static struct regmap_config fsl_spdif_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
@@ -1105,6 +1107,10 @@ static int fsl_spdif_probe(struct platform_device *pdev)
 	memcpy(&spdif_priv->cpu_dai_drv, &fsl_spdif_dai, sizeof(fsl_spdif_dai));
 	spdif_priv->cpu_dai_drv.name = spdif_priv->name;
 
+	spdif_priv->big_endian = of_property_read_bool(np, "big-endian");
+	if (spdif_priv->big_endian)
+		fsl_spdif_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
+
 	/* Get the addresses and IRQ */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	regs = devm_ioremap_resource(&pdev->dev, res);
-- 
1.8.4


