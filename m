Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaHEH3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:29:51 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:10512
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756470AbaHEH3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:29:49 -0400
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <devicetree@vger.kernel.org>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
Date: Tue, 5 Aug 2014 15:32:05 +0800
Message-ID: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130516973700535240;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009002)(6009001)(199002)(189002)(110136001)(86362001)(81442001)(93916002)(46102001)(73972005)(33646002)(77982001)(26826002)(81542001)(48376002)(104016003)(80022001)(82202001)(50986999)(104166001)(61266001)(97736001)(47776003)(64706001)(87572001)(20776003)(92726001)(21056001)(81342001)(99396002)(107046002)(102836001)(19580405001)(19580395003)(2351001)(31966008)(36756003)(77156001)(6806004)(44976005)(229853001)(81156004)(106466001)(83072002)(85852003)(69596002)(68736004)(105596002)(55446002)(87286001)(87936001)(89996001)(85306004)(4396001)(88136002)(50226001)(84676001)(73392001)(50466002)(95666004)(79102001)(74502001)(74662001)(92566001)(62966002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB356;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=nicoleotsuka@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolin Chen <Guangyu.Chen@freescale.com>

SAI supports these operation modes:
1) asynchronous mode
   Both Tx and Rx are set to be asynchronous.
2) synchronous mode (Rx sync with Tx)
   Tx is set to be asynchronous, Rx is set to be synchronous.
3) synchronous mode (Tx sync with Rx)
   Rx is set to be asynchronous, Tx is set to be synchronous.
4) synchronous mode (Tx/Rx sync with another SAI's Tx)
5) synchronous mode (Tx/Rx sync with another SAI's Rx)

* 4) and 5) are beyond this patch because they are related with another SAI.

As the initial version of this SAI driver, it supported 2) as default while
the others were totally missing.

So this patch just adds supports for 1) and 3).

Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
---
 .../devicetree/bindings/sound/fsl-sai.txt          | 16 ++++++++++++
 sound/soc/fsl/fsl_sai.c                            | 30 +++++++++++++++++++---
 sound/soc/fsl/fsl_sai.h                            |  4 +++
 3 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
index 0f4e238..77864f4 100644
--- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
+++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
@@ -24,6 +24,22 @@ Required properties:
 - big-endian-data: If this property is absent, the little endian mode will
   be in use as default, or the big endian mode will be in use for all the
   fifo data.
+- fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
+  that SAI will work in the synchronous mode (sync Tx with Rx) which means
+  both the transimitter and receiver will send and receive data by following
+  receiver's bit clocks and frame sync clocks.
+- fsl,sai-asynchronous: This is a boolean property. If present, indicating
+  that SAI will work in the asynchronous mode, which means both transimitter
+  and receiver will send and receive data by following their own bit clocks
+  and frame sync clocks separately.
+
+Note:
+- If both fsl,sai-asynchronous and fsl,sai-synchronous-rx are absent, the
+  default synchronous mode (sync Rx with Tx) will be used, which means both
+  transimitter and receiver will send and receive data by following clocks
+  of transimitter.
+- fsl,sai-asynchronous will be ignored if fsl,sai-synchronous-rx property is
+  already present.
 
 Example:
 sai2: sai@40031000 {
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 9f10575..dc84f98 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -330,12 +330,14 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
 	u32 xcsr, count = 100;
 
 	/*
-	 * The transmitter bit clock and frame sync are to be
-	 * used by both the transmitter and receiver.
+	 * Asynchronous mode: Clear SYNC for both Tx and Rx.
+	 * Rx sync with Tx clocks: Clear SYNC for Tx, set it for Rx.
+	 * Tx sync with Rx clocks: Clear SYNC for Rx, set it for Tx.
 	 */
-	regmap_update_bits(sai->regmap, FSL_SAI_TCR2, FSL_SAI_CR2_SYNC, 0);
+	regmap_update_bits(sai->regmap, FSL_SAI_TCR2, FSL_SAI_CR2_SYNC,
+			   sai->synchronous[TX] ? FSL_SAI_CR2_SYNC : 0);
 	regmap_update_bits(sai->regmap, FSL_SAI_RCR2, FSL_SAI_CR2_SYNC,
-			   FSL_SAI_CR2_SYNC);
+			   sai->synchronous[RX] ? FSL_SAI_CR2_SYNC : 0);
 
 	/*
 	 * It is recommended that the transmitter is the last enabled
@@ -620,6 +622,26 @@ static int fsl_sai_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Sync Tx with Rx as default by following old DT binding */
+	sai->synchronous[RX] = true;
+	sai->synchronous[TX] = false;
+	fsl_sai_dai.symmetric_rates = 1;
+	fsl_sai_dai.symmetric_channels = 1;
+	fsl_sai_dai.symmetric_samplebits = 1;
+
+	if (of_find_property(np, "fsl,sai-synchronous-rx", NULL)) {
+		/* Sync Rx with Tx */
+		sai->synchronous[RX] = false;
+		sai->synchronous[TX] = true;
+	} else if (of_find_property(np, "fsl,sai-asynchronous", NULL)) {
+		/* Discard all settings for asynchronous mode */
+		sai->synchronous[RX] = false;
+		sai->synchronous[TX] = false;
+		fsl_sai_dai.symmetric_rates = 0;
+		fsl_sai_dai.symmetric_channels = 0;
+		fsl_sai_dai.symmetric_samplebits = 0;
+	}
+
 	sai->dma_params_rx.addr = res->start + FSL_SAI_RDR;
 	sai->dma_params_tx.addr = res->start + FSL_SAI_TDR;
 	sai->dma_params_rx.maxburst = FSL_SAI_MAXBURST_RX;
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 0e6c9f5..c24d3fd 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -135,9 +135,13 @@ struct fsl_sai {
 	bool big_endian_data;
 	bool is_dsp_mode;
 	bool sai_on_imx;
+	bool synchronous[2];
 
 	struct snd_dmaengine_dai_dma_data dma_params_rx;
 	struct snd_dmaengine_dai_dma_data dma_params_tx;
 };
 
+#define TX 1
+#define RX 0
+
 #endif /* __FSL_SAI_H */
-- 
1.8.4

